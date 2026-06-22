import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:demo_app/core/utils/shared.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/data/create_service_form_data.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/data/firebase_draft_repository.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/controller/create_service_state.dart';

class CreateServiceCubit extends Cubit<CreateServiceState> {
  final ServicesManagerCubit _servicesManagerCubit;
  final ImagePicker _picker = ImagePicker();

  CreateServiceCubit(this._servicesManagerCubit)
      : super(const CreateServiceInitial());

  // ✅ CLEAN Initialize - NO SharedPreferences loading at all
  Future<void> initialize({
    ServicesHistoryModel? editingModel,
    String? docId,
  }) async {
    emit(const CreateServiceLoading());

    if (editingModel != null) {
      // Edit mode - load from model ONLY
      final formData = CreateServiceFormData(
        docId: docId,
        serviceNameEn: editingModel.currentServiceNameEnglish,
        serviceNameAr: editingModel.currentServiceNameArabic,
        descriptionEn: editingModel.currentServiceDescriptionEnglish,
        descriptionAr: editingModel.currentServiceDescriptionArabic,
        durationValue: editingModel.currentDurationOfServices,
        durationUnit: editingModel.currentSelectedDurationUnit.isEmpty
            ? 'minutes'
            : editingModel.currentSelectedDurationUnit,
        imageUrl: editingModel.currentImageUrl.isEmpty
            ? null
            : editingModel.currentImageUrl,
        isActive: editingModel.currentStatus == "active",
        isEditMode: true,
        state: editingModel.currentState,
        providers: editingModel.currentProviderServices,
      );

      _servicesManagerCubit.saveServiceDraft(editingModel);
      emit(CreateServiceLoaded(formData: formData));

      // Load real status from Firestore if docId exists
      if (docId != null) {
        await _loadCurrentStatusFromFirestore(docId);
      }
    } else {
      // ✅ Create mode - ALWAYS START WITH CLEAN EMPTY FORM
      emit(const CreateServiceLoaded(formData: CreateServiceFormData()));
    }
  }

  Future<void> _loadCurrentStatusFromFirestore(String docId) async {
    try {
      final String userEmail = _extractEmail();

      final querySnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .where("Email_Requester", arrayContains: userEmail)
          .get();

      final doc = querySnapshot.docs.firstWhere(
            (doc) => doc.id == docId,
        orElse: () => throw Exception("Document not found"),
      );

      if (doc.exists) {
        final statusData = doc.data()['status'];
        String status = 'active';
        if (statusData is List && statusData.isNotEmpty) {
          status = statusData.last.toString();
        } else if (statusData is String) {
          status = statusData;
        }

        if (state is CreateServiceLoaded) {
          final currentState = state as CreateServiceLoaded;
          emit(currentState.copyWith(
            formData: currentState.formData.copyWith(isActive: status == 'active'),
          ));
        }
      }
    } catch (e) {
    }
  }

  String _extractEmail() {
    try {
      final controller = Get.find<MainCoreEmployeeController>();
      final email = controller.employeeEntity?.email ?? '';

      if (email.isNotEmpty) {
        return email;
      }

      return '';

    } catch (e) {
      return '';
    }
  }

  // Form field updates
  void updateServiceNameEn(String value) {
    _updateFormData((data) => data.copyWith(serviceNameEn: value));
  }

  void updateServiceNameAr(String value) {
    _updateFormData((data) => data.copyWith(serviceNameAr: value));
  }

  void updateDescriptionEn(String value) {
    _updateFormData((data) => data.copyWith(descriptionEn: value));
  }

  void updateDescriptionAr(String value) {
    _updateFormData((data) => data.copyWith(descriptionAr: value));
  }

  void updateDurationValue(String value) {
    _updateFormData((data) => data.copyWith(durationValue: value));
  }

  void updateDurationUnit(String value) {
    _updateFormData((data) => data.copyWith(durationUnit: value));
  }

  // void toggleStatus(bool value) {
  //   _updateFormData((data) => data.copyWith(isActive: value));
  // }

  void _updateFormData(CreateServiceFormData Function(CreateServiceFormData) updater) {
    if (state is CreateServiceLoaded) {
      final currentState = state as CreateServiceLoaded;
      emit(currentState.copyWith(formData: updater(currentState.formData)));
    }
  }

  // Image handling
  Future<void> pickImage() async {
    if (state is! CreateServiceLoaded) return;

    final currentState = state as CreateServiceLoaded;
    if (currentState.isUploadingImage) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          emit(currentState.copyWith(webImage: bytes, selectedImage: null));
        } else {
          emit(currentState.copyWith(selectedImage: File(image.path), webImage: null));
        }
        await _uploadImageToFirebase();
      }
    } catch (e) {
      emit(CreateServiceError('Error picking image: $e'));
      if (state is CreateServiceLoaded) emit(currentState);
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (state is! CreateServiceLoaded) return;
    final currentState = state as CreateServiceLoaded;

    if ((currentState.selectedImage == null && currentState.webImage == null)) return;

    emit(currentState.copyWith(isUploadingImage: true));

    try {
      final storage = FirebaseStorage.instance;
      final fileName = 'service_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = storage.ref().child('services_images/$fileName');

      UploadTask uploadTask;
      if (kIsWeb && currentState.webImage != null) {
        uploadTask = ref.putData(
          currentState.webImage!,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else if (currentState.selectedImage != null) {
        uploadTask = ref.putFile(
          currentState.selectedImage!,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        throw Exception('No image selected');
      }

      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();

      emit(currentState.copyWith(
        isUploadingImage: false,
        formData: currentState.formData.copyWith(imageUrl: downloadURL),
      ));

      emit(CreateServiceImageUploaded(downloadURL));
    } catch (e) {
      emit(currentState.copyWith(isUploadingImage: false));
      emit(CreateServiceError('Failed to upload image: $e'));
      emit(currentState.copyWith(isUploadingImage: false));
    }
  }

  Future<void> removeImage() async {
    if (state is! CreateServiceLoaded) return;
    final currentState = state as CreateServiceLoaded;

    if (currentState.formData.imageUrl != null) {
      try {
        final ref = FirebaseStorage.instance.refFromURL(currentState.formData.imageUrl!);
        await ref.delete();
      } catch (e) {
      }
    }

    emit(currentState.copyWith(
      selectedImage: null,
      webImage: null,
      formData: currentState.formData.copyWith(imageUrl: null),
    ));
  }

  void resetToDuplicateState() {
    if (state is CreateServiceDuplicateName) {
      final duplicateState = state as CreateServiceDuplicateName;
      if (duplicateState.formData != null) {
        emit(CreateServiceLoaded(formData: duplicateState.formData!));
      }
    }
  }

  // ✅ CLEAN Submit - NO SharedPreferences saving
  Future<void> submitForm() async {
    if (state is! CreateServiceLoaded) return;
    final currentState = state as CreateServiceLoaded;

    emit(currentState.copyWith(submitted: true));

    if (!currentState.formData.isFormValid) {
      return;
    }

    if (currentState.isUploadingImage) {
      emit(CreateServiceError('Please wait for image upload to complete'));
      // ✅ Restore loaded state after error
      emit(currentState.copyWith(submitted: true));
      return;
    }

    try {
      final String userEmail = _extractEmail();

      final duplicateCheckResult = await _checkForDuplicates(
        serviceNameEn: currentState.formData.serviceNameEn.trim(),
        serviceNameAr: currentState.formData.serviceNameAr.trim(),
        userEmail: userEmail,
        currentDocId: currentState.formData.docId,
        isEditMode: currentState.formData.isEditMode,
      );

      if (duplicateCheckResult.isDuplicate) {
        emit(CreateServiceDuplicateName(
          duplicateField: duplicateCheckResult.duplicateField,
          duplicateValue: duplicateCheckResult.duplicateValue,
          formData: currentState.formData,
        ));
        return; // ← resetToDuplicateState() handles restoring from here
      }

      await SharedPrefsHelper.setBool('service_status', currentState.formData.isActive);

      final providersToUse = currentState.formData.providers;

      final completeModel = ServicesHistoryModel.createNew(
        id: currentState.formData.docId ?? '',
        state: currentState.formData.state,
        status: currentState.formData.isActive ? "active" : "inactive",
        serviceNameEnglish: currentState.formData.serviceNameEn,
        serviceNameArabic: currentState.formData.serviceNameAr,
        serviceDescriptionEnglish: currentState.formData.descriptionEn,
        serviceDescriptionArabic: currentState.formData.descriptionAr,
        durationOfServices: currentState.formData.durationValue,
        selectedDurationUnit: currentState.formData.durationUnit,
        imageUrl: currentState.formData.imageUrl ?? '',
        providerServices: providersToUse,
      );

      await _servicesManagerCubit.saveServiceDraft(completeModel);
      _servicesManagerCubit.docService = completeModel;

      // ✅ FIX: Emit nav state then immediately restore loaded state
      emit(CreateServiceNavigateToProviders(
        docId: currentState.formData.docId,
        formData: currentState.formData.copyWith(providers: providersToUse),
      ));

      // ✅ This is the key fix — when user presses back from provider page,
      // the cubit is already in loaded state, button works correctly
      emit(currentState.copyWith(
        submitted: false, // ✅ Reset submitted so validation UI clears
      ));

    } catch (e, stackTrace) {
      emit(CreateServiceError('An error occurred: ${e.toString()}'));
      emit(currentState); // ✅ Already existed, keep it
    }
  }

  void toggleStatus(bool value) {
    _updateFormData((data) => data.copyWith(isActive: value));
    // ✅ Persist immediately so draft saves mid-flow also carry correct status
    SharedPrefsHelper.setBool('service_status', value);
  }

  Future<DuplicateCheckResult> _checkForDuplicates({
    required String serviceNameEn,
    required String serviceNameAr,
    required String userEmail,
    String? currentDocId,
    required bool isEditMode,
  }) async {
    try {

      final querySnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .where("Email_Requester", arrayContains: userEmail)
          .get();

      for (var doc in querySnapshot.docs) {

        if (isEditMode && doc.id == currentDocId) {
          continue;
        }

        final data = doc.data();

        // Check English Name
        final nameEnData = data['Service_Name_English'];
        String existingNameEn = '';

        if (nameEnData is List && nameEnData.isNotEmpty) {
          existingNameEn = nameEnData.last.toString();
        } else if (nameEnData is String) {
          existingNameEn = nameEnData;
        }

        if (existingNameEn.trim().toLowerCase() == serviceNameEn.toLowerCase()) {
          return DuplicateCheckResult(
            isDuplicate: true,
            duplicateField: 'Service_Name_English',
            duplicateValue: existingNameEn,
          );
        }

        // Check Arabic Name (only if not empty)
        if (serviceNameAr.isNotEmpty) {
          final nameArData = data['Service_Name_Arabic'];
          String existingNameAr = '';

          if (nameArData is List && nameArData.isNotEmpty) {
            existingNameAr = nameArData.last.toString();
          } else if (nameArData is String) {
            existingNameAr = nameArData;
          }

          if (existingNameAr.trim() == serviceNameAr.trim()) {
            return DuplicateCheckResult(
              isDuplicate: true,
              duplicateField: 'Service_Name_Arabic',
              duplicateValue: existingNameAr,
            );
          }
        }
      }

      return DuplicateCheckResult(isDuplicate: false);

    } catch (e, stackTrace) {
      throw Exception('Failed to check for duplicates: $e');
    }
  }

  /// 🔥 Save draft from page 1
  Future<void> saveDraftFromPage1() async {
    if (state is! CreateServiceLoaded) return;
    final currentState = state as CreateServiceLoaded;

    try {
      final model = ServicesHistoryModel.createNew(
        id: currentState.formData.docId ?? '',
        state: "draft",
        status: "draft",
        serviceNameEnglish: currentState.formData.serviceNameEn,
        serviceNameArabic: currentState.formData.serviceNameAr,
        serviceDescriptionEnglish: currentState.formData.descriptionEn,
        serviceDescriptionArabic: currentState.formData.descriptionAr,
        durationOfServices: currentState.formData.durationValue,
        selectedDurationUnit: currentState.formData.durationUnit,
        imageUrl: currentState.formData.imageUrl ?? '',
        providerServices: [],
      );

      final draftId = await _servicesManagerCubit.saveDraftToFirebase(
        model: model,
        currentPage: FirebaseDraftRepository.pageCreateService,
      );

      emit(CreateServiceDraftSaved(draftId: draftId));

    } catch (e) {
      emit(CreateServiceError('Failed to save draft: $e'));
    }
  }

  void discard() {
    // Handled by navigation pop in UI
  }
}

class DuplicateCheckResult {
  final bool isDuplicate;
  final String duplicateField;
  final String duplicateValue;

  const DuplicateCheckResult({
    required this.isDuplicate,
    this.duplicateField = '',
    this.duplicateValue = '',
  });
}
