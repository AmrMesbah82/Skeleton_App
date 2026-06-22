import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/shared_prefs.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/utils/shared.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_prefs_employee.dart';

import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/data/firebase_draft_repository.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/data/provider_selection_data.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/provider_selection_state.dart';

class ProviderSelectionCubit extends Cubit<ProviderSelectionState> {
  final MainCoreEmployeeController employeeController;
  final MainCoreDepartmentController departmentController;
  final ServicesManagerCubit servicesManagerCubit;

  ProviderSelectionCubit({
    required this.employeeController,
    required this.departmentController,
    required this.servicesManagerCubit,
  }) : super(const ProviderSelectionInitial());

  // ==================== INITIALIZATION ====================

  Future<void> initialize({
    ServicesHistoryModel? editingModel,
    String? docId,
    ServicesHistoryModel? editProvider,
  }) async {
    emit(const ProviderSelectionLoading());

    final isEditMode = editProvider != null;
    String? originalProviderEmail;

    if (isEditMode && editProvider != null) {
      final providers = editProvider.currentProviderServices;
      if (providers.isNotEmpty) {
        originalProviderEmail = providers.first.email;
      }
    }

    final initialData = ProviderSelectionData(
      editingModel: editingModel,
      docId: docId,
      editProvider: editProvider,
      isEditMode: isEditMode,
      originalProviderEmail: originalProviderEmail,
    );

    emit(ProviderSelectionLoaded(
      data: initialData,
      allEmployees: [],
      filteredEmployees: [],
    ));

    // Post-frame initialization
    await _clearAllPreviousData();
    await _initializeCorrectSelection(editingModel, editProvider, isEditMode);
    await _loadEmployeesFromMainCore();
  }

  // ==================== DATA LOADING ====================

  Future<void> _loadEmployeesFromMainCore() async {

    try {
      final employees = employeeController.allEmployeesEntities;

      if (employees != null && employees.isNotEmpty) {
        final currentState = state as ProviderSelectionLoaded;

        emit(currentState.copyWith(
          data: currentState.data.copyWith(isLoading: false),
          allEmployees: employees,
        ));

        _applySearchFilter('');
      } else {

        final fetchedEmployees = await employeeController.getAllNewEmployees();

        if (fetchedEmployees != null && fetchedEmployees.isNotEmpty) {
          final currentState = state as ProviderSelectionLoaded;

          emit(currentState.copyWith(
            data: currentState.data.copyWith(isLoading: false),
            allEmployees: fetchedEmployees,
          ));

          _applySearchFilter('');
        } else {
          final currentState = state as ProviderSelectionLoaded;
          emit(currentState.copyWith(
            data: currentState.data.copyWith(isLoading: false),
          ));
        }
      }
    } catch (e, stackTrace) {

      final currentState = state as ProviderSelectionLoaded;
      emit(currentState.copyWith(
        data: currentState.data.copyWith(isLoading: false),
      ));
    }

  }

  // ==================== SELECTION MANAGEMENT ====================

  Future<void> _clearAllPreviousData() async {
    try {
      await SharedPrefsEmployeeHelper.clearSelectedEmployees();

      final currentState = state as ProviderSelectionLoaded;
      final data = currentState.data;

      if (data.isEditMode) {
        if (servicesManagerCubit.docService != null) {
          servicesManagerCubit.docService = servicesManagerCubit.docService!.copyWith(
            providerServices: [],
          );
        }
      } else if (servicesManagerCubit.docService != null) {
        if (data.editingModel?.id != null &&
            servicesManagerCubit.docService?.id != data.editingModel?.id) {
          servicesManagerCubit.docService = null;
        }
      }

    } catch (e) {
    }
  }

  Future<void> _initializeCorrectSelection(
      ServicesHistoryModel? editingModel,
      ServicesHistoryModel? editProvider,
      bool isEditMode,
      ) async {

    final currentState = state as ProviderSelectionLoaded;

    if (currentState.data.hasRestoredSelection) {
      return;
    }

    try {
      Set<String> selectedEmails = {};

      if (isEditMode) {

        await SharedPrefsEmployeeHelper.clearSelectedEmployees();

        if (servicesManagerCubit.docService != null) {
          servicesManagerCubit.docService = servicesManagerCubit.docService!.copyWith(
            providerServices: [],
          );
        }

      } else if (editingModel != null) {
        final correctProviders = editingModel.currentProviderServices;

        final validEmails = <String>{};
        for (final provider in correctProviders) {
          if (provider.email != null && provider.email!.isNotEmpty) {
            validEmails.add(normalizeEmail(provider.email!));
          }
        }

        selectedEmails = validEmails;

      } else {
        final cubitModel = servicesManagerCubit.docService;

        if (cubitModel != null) {
          final cubitProviders = cubitModel.currentProviderServices;

          final validEmails = <String>{};
          for (final provider in cubitProviders) {
            if (provider.email != null && provider.email!.isNotEmpty) {
              validEmails.add(normalizeEmail(provider.email!));
            }
          }

          selectedEmails = validEmails;

        } else {
          final savedEmployees = await SharedPrefsEmployeeHelper.getSelectedEmployees();

          final validEmails = <String>{};
          for (final employee in savedEmployees) {
            if (employee.email != null && employee.email!.isNotEmpty) {
              validEmails.add(normalizeEmail(employee.email!));
            }
          }

          selectedEmails = validEmails;
        }
      }

      emit(currentState.copyWith(
        data: currentState.data.copyWith(
          selectedEmployeeEmails: selectedEmails,
          hasRestoredSelection: true,
        ),
      ));

    } catch (e) {
      emit(currentState.copyWith(
        data: currentState.data.copyWith(
          selectedEmployeeEmails: <String>{},
          hasRestoredSelection: true,
        ),
      ));
    }
  }

  // ==================== SEARCH & FILTER ====================

  void updateSearch(String query) {
    _applySearchFilter(query);
  }

  void _applySearchFilter(String query) {
    final currentState = state as ProviderSelectionLoaded;
    final data = currentState.data;
    final allEmployees = currentState.allEmployees;

    final q = query.trim().toLowerCase();

    var availableEmployees = List<EmployeeEntityPro>.from(allEmployees);

    if (data.isEditMode && data.originalProviderEmail != null) {
      final normalizedOriginal = normalizeEmail(data.originalProviderEmail);
      availableEmployees = availableEmployees
          .where((e) => normalizeEmail(e.email) != normalizedOriginal)
          .toList();
    }

    final selected = availableEmployees
        .where((e) => data.selectedEmployeeEmails.contains(normalizeEmail(e.email)))
        .toList();

    if (q.isEmpty) {
      final rest = availableEmployees
          .where((e) => !data.selectedEmployeeEmails.contains(normalizeEmail(e.email)))
          .toList();

      emit(currentState.copyWith(
        filteredEmployees: [...selected, ...rest],
        searchQuery: query,
      ));
      return;
    }

    final matches = availableEmployees.where((employee) {
      final firstName = (employee.firstName ?? '').trim().toLowerCase();
      final lastName = (employee.lastName ?? '').trim().toLowerCase();
      final fullName = '$firstName $lastName';
      final firstNameAr = (employee.firstNameInArabic ?? '').trim().toLowerCase();
      final lastNameAr = (employee.middleNameInArabic ?? '').trim().toLowerCase();
      final fullNameAr = '$firstNameAr $lastNameAr';

      return firstName.startsWith(q) ||
          lastName.startsWith(q) ||
          fullName.startsWith(q) ||
          firstNameAr.startsWith(q) ||
          lastNameAr.startsWith(q) ||
          fullNameAr.startsWith(q);
    }).where((e) => !data.selectedEmployeeEmails.contains(normalizeEmail(e.email))).toList();

    emit(currentState.copyWith(
      filteredEmployees: [...selected, ...matches],
      searchQuery: query,
    ));
  }

  // ==================== PROVIDER SELECTION ====================

  void toggleProviderSelection(String email) {
    final currentState = state as ProviderSelectionLoaded;
    final data = currentState.data;
    final normalizedEmail = normalizeEmail(email);

    Set<String> newSelection = Set<String>.from(data.selectedEmployeeEmails);

    if (data.isEditMode) {
      // Single select for edit mode
      newSelection.clear();
      newSelection.add(normalizedEmail);
    } else {
      // Multi select for create mode
      if (newSelection.contains(normalizedEmail)) {
        newSelection.remove(normalizedEmail);
      } else {
        newSelection.add(normalizedEmail);
      }
    }

    emit(currentState.copyWith(
      data: data.copyWith(selectedEmployeeEmails: newSelection),
    ));

    _applySearchFilter(currentState.searchQuery);
    _saveSelectionToPrefsAndCubit();
  }

  Future<void> _saveSelectionToPrefsAndCubit() async {
    final currentState = state as ProviderSelectionLoaded;
    final data = currentState.data;

    if (data.selectedEmployeeEmails.isEmpty) {
      await SharedPrefsEmployeeHelper.clearSelectedEmployees();
      return;
    }

    try {
      final chosen = currentState.allEmployees
          .where((e) => data.selectedEmployeeEmails.contains(normalizeEmail(e.email)))
          .map((e) => _mapToEmployeeEntityModell(e))
          .toList();

      await SharedPrefsEmployeeHelper.saveSelectedEmployees(chosen);

      if (data.editingModel != null) {
        servicesManagerCubit.docService = data.editingModel!.copyWith(
          providerServices: chosen,
        );
      } else {
        final current = servicesManagerCubit.docService;
        if (current != null) {
          servicesManagerCubit.docService = current.copyWith(
            providerServices: chosen,
          );
        } else {
          servicesManagerCubit.docService = ServicesHistoryModel.createNew(
            id: '',
            state: "draft",
            status: "draft",
            providerServices: chosen,
            selectDepartment: [],
            approvalCycle: [],
            emailRequester: employeeController.employeeEntity?.email ?? '',
            serviceNameEnglish: '',
            serviceNameArabic: '',
            serviceDescriptionEnglish: '',
            serviceDescriptionArabic: '',
            durationOfServices: '',
            selectedDurationUnit: '',
          );
        }
      }

    } catch (e) {
      rethrow;
    }
  }

  void validateSelectionAfterLoad() {
    final currentState = state as ProviderSelectionLoaded;
    final data = currentState.data;

    if (!data.hasRestoredSelection || currentState.allEmployees.isEmpty) return;

    final validEmails = currentState.allEmployees
        .map((e) => normalizeEmail(e.email))
        .where((e) => e.isNotEmpty)
        .toSet();

    final currentSelection = Set<String>.from(data.selectedEmployeeEmails);

    final validSelection = currentSelection
        .where((email) => validEmails.contains(normalizeEmail(email)))
        .toSet();

    if (validSelection.length != currentSelection.length) {

      emit(currentState.copyWith(
        data: data.copyWith(selectedEmployeeEmails: validSelection),
      ));
    }

  }

  Future<void> handleSaveForLaterToFirebase() async {
    // ✅ Guard
    if (state is! ProviderSelectionLoaded) return;
    final currentState = state as ProviderSelectionLoaded;

    emit(ProviderSelectionSaving(
      data: currentState.data,
      allEmployees: currentState.allEmployees,
    ));

    try {
      // ✅ FIX: Use saved reference instead of casting state again
      final completeModel = await _getCompleteServiceModel(
        data: currentState.data,
        allEmployees: currentState.allEmployees,
      );

      final draftId = await servicesManagerCubit.saveDraftToFirebase(
        model: completeModel,
        currentPage: FirebaseDraftRepository.pageSelectProvider,
      );

      emit(ProviderSelectionSavedToFirebase(draftId: draftId));
      // No need to restore here — this navigates away

    } catch (error) {
      // ✅ Restore loaded state on error
      emit(currentState);
      emit(ProviderSelectionError('Failed to save draft: $error'));
      emit(currentState); // Restore after error state
    }
  }

// ==================== MODEL BUILDING ====================

// ✅ UPDATED: Accept data as parameters instead of casting state
  Future<ServicesHistoryModel> _getCompleteServiceModel({
    required ProviderSelectionData data,
    required List<EmployeeEntityPro> allEmployees,
  }) async {
    final requesterEmail = employeeController.employeeEntity?.email ?? '';

    if (data.editingModel != null) {

      final selectedEmployees = allEmployees
          .where((e) => data.selectedEmployeeEmails.contains(normalizeEmail(e.email)))
          .map((e) => _mapToEmployeeEntityModell(e))
          .toList();

      return data.editingModel!.copyWith(
        providerServices: selectedEmployees,
      );
    }

    final cubitModel = servicesManagerCubit.docService;

    if (cubitModel != null) {

      final selectedEmployees = allEmployees
          .where((e) => data.selectedEmployeeEmails.contains(normalizeEmail(e.email)))
          .map((e) => _mapToEmployeeEntityModell(e))
          .toList();

      return cubitModel.copyWith(
        providerServices: selectedEmployees,
      );
    }

    // For NEW services from SharedPrefs
    final nameEn = await SharedPrefsHelper.getString('service_name_en') ?? '';
    final nameAr = await SharedPrefsHelper.getString('service_name_ar') ?? '';
    final descEn = await SharedPrefsHelper.getString('service_description_en') ?? '';
    final descAr = await SharedPrefsHelper.getString('service_description_ar') ?? '';
    final durationVal = await SharedPrefsHelper.getString('duration_value') ?? '';
    final durationUnit = await SharedPrefsHelper.getString('duration_unit') ?? 'minutes';
    final imageUrl = await SharedPrefsHelper.getString('service_image_url') ?? '';

    final selectedEmployees = allEmployees
        .where((e) => data.selectedEmployeeEmails.contains(normalizeEmail(e.email)))
        .map((e) => _mapToEmployeeEntityModell(e))
        .toList();

    final departments = await SharedPrefsDepartmentsHelper.getDepartments();
    final approvalCycle = await SharedPrefsApprovalHelper.getApprovalCycle();

    return ServicesHistoryModel.createNew(
      id: '',
      state: "draft",
      status: "draft",
      serviceNameEnglish: nameEn,
      serviceNameArabic: nameAr,
      serviceDescriptionEnglish: descEn,
      serviceDescriptionArabic: descAr,
      durationOfServices: durationVal,
      selectedDurationUnit: durationUnit,
      imageUrl: imageUrl,
      providerServices: selectedEmployees,
      selectDepartment: departments,
      approvalCycle: approvalCycle,
      emailRequester: requesterEmail,
    );
  }

  // ==================== NAVIGATION & ACTIONS ====================

  Future<void> handleBackNavigation() async {
    // ✅ Guard: only proceed if in loaded state
    if (state is! ProviderSelectionLoaded) return;
    final currentState = state as ProviderSelectionLoaded;

    if (currentState.data.selectedEmployeeEmails.isNotEmpty) {
      await _saveSelectionToPrefsAndCubit();
    }

    await SharedPrefsHelper.setBool('is_returning_from_next_screen', true);

    // ✅ FIX: Emit nav state first, then immediately restore loaded state
    emit(const ProviderSelectionNavigateBack());
    emit(currentState); // ← This is the KEY fix — restores state for when user returns
  }

  Future<void> handleNextNavigation() async {
    // ✅ Guard: protect against wrong state
    if (state is! ProviderSelectionLoaded) return;
    final currentState = state as ProviderSelectionLoaded;
    final data = currentState.data;

    if (data.selectedEmployeeEmails.isEmpty) {
      emit(const ProviderSelectionShowWarning('pleaseSelectOneProviderAtLeast'));
      emit(currentState); // ✅ Restore after warning
      return;
    }

    try {

      await _saveSelectionToPrefsAndCubit();

      ServicesHistoryModel completeModel;

      if (data.docId != null && data.docId!.isNotEmpty) {

        final requesterEmail = employeeController.employeeEntity?.email ?? '';

        final docRef = FirebaseFirestore.instance
            .collection(getBaseUrl(FirestoreCollections.createServices))
            .doc(data.docId);

        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          final docData = docSnapshot.data() as Map<String, dynamic>;
          completeModel = ServicesHistoryModel.fromJson(docData, data.docId);
        } else {

          final querySnapshot = await FirebaseFirestore.instance
              .collection(getBaseUrl(FirestoreCollections.createServices))
              .where("Email_Requester", arrayContains: requesterEmail)
              .get();

          DocumentSnapshot? foundDoc;
          try {
            foundDoc = querySnapshot.docs.firstWhere((doc) => doc.id == data.docId!);
          } catch (e) {
            foundDoc = null;
          }

          if (foundDoc != null) {
            final docData = foundDoc.data() as Map<String, dynamic>;
            completeModel = ServicesHistoryModel.fromJson(docData, data.docId);
          } else {
            if (data.editingModel == null) {
              throw Exception("Document not found and no editing model available");
            }
            completeModel = data.editingModel!;
          }
        }
      } else {
        if (servicesManagerCubit.docService == null) {
          throw Exception("No service model available");
        }
        completeModel = servicesManagerCubit.docService!;
      }

      final selectedEmployees = currentState.allEmployees
          .where((e) => data.selectedEmployeeEmails.contains(normalizeEmail(e.email)))
          .map((e) => _mapToEmployeeEntityModell(e))
          .toList();

      final updatedModel = completeModel.copyWith(providerServices: selectedEmployees);
      servicesManagerCubit.docService = updatedModel;

      if (data.editProvider != null) {
        await _updateProviderInFirebase(data, selectedEmployees);
        // ✅ Restore state after edit provider firebase update
        emit(currentState);
        return;
      }

      // ✅ FIX: Emit nav state then restore loaded state
      emit(ProviderSelectionNavigateToDetails(
        completeModel: updatedModel,
        docId: data.docId,
      ));
      emit(currentState); // ← Restore so screen works if user presses back from next page

    } catch (e, stackTrace) {
      // ✅ Restore state on error
      emit(currentState);
      emit(ProviderSelectionError('An error occurred: ${e.toString()}'));
      // ✅ Restore again after error so screen isn't stuck
      emit(currentState.copyWith(
        data: currentState.data,
      ));
    }
  }

  Future<void> _updateProviderInFirebase(
      ProviderSelectionData data,
      List<EmployeeEntityModell> selectedEmployees,
      ) async {

    try {
      final requestId = data.editProvider!.currentId;
      final firestore = FirebaseFirestore.instance;
      final docPath = '${getBaseUrl(FirestoreCollections.requestServices)}/$requestId';

      // ✅ Encode provider list as JSON string (matches model's provider_Services format)
      final providerJson = jsonEncode(
        selectedEmployees.map((e) => e.toJson()).toList(),
      );

      await firestore.doc(docPath).update({
        // ✅ FIXED: Exact Firestore field names matching ServicesHistoryModel
        'Assigned_Provider_Email': [selectedEmployees.first.email],
        'Provider_Services': [providerJson],  // ✅ Wrapped in list, matching _parseList format
        'timestamps': FieldValue.arrayUnion([
          DateTime.now().millisecondsSinceEpoch,
        ]),
      });

      servicesManagerCubit.getAllServices();
      servicesManagerCubit.getMyRequestServices();

      emit(const ProviderSelectionProviderUpdated());

    } catch (e, stackTrace) {
      emit(ProviderSelectionError('Failed to update provider: ${e.toString()}'));
    }
  }

  Future<void> handleSaveForLater() async {
    final currentState = state as ProviderSelectionLoaded;

    try {
      await _saveSelectionToPrefsAndCubit();
      await Future.delayed(const Duration(milliseconds: 100));

      // ✅ FIX: Pass required parameters
      final completeModel = await _getCompleteServiceModel(
        data: currentState.data,
        allEmployees: currentState.allEmployees,
      );

      final data = currentState.data;

      if (data.editingModel != null &&
          data.editingModel!.currentId != null &&
          data.editingModel!.currentId!.isNotEmpty) {
        final updatedModel = completeModel.copyWith(
          id: data.editingModel!.currentId,
        );

        await SharedPrefsServiceMaster.updateDraft(data.editingModel!, updatedModel);
      } else {
        final cubitModel = servicesManagerCubit.docService;

        if (cubitModel != null &&
            cubitModel.currentId != null &&
            cubitModel.currentId.startsWith('draft_')) {
          final updatedModel = completeModel.copyWith(
            id: cubitModel.currentId,
          );
          await SharedPrefsServiceMaster.updateDraft(cubitModel, updatedModel);
        } else {
          await SharedPrefsServiceMaster.saveDraft(completeModel);
        }
      }

      await SharedPrefsServiceMaster.debugSavedDrafts();
      emit(const ProviderSelectionSaved());

    } catch (error) {
      emit(ProviderSelectionError('Failed to save draft: $error'));
    }
  }

  // ==================== MODEL BUILDING ====================

  // ==================== HELPER METHODS ====================

  // CHANGED: Made public from private (_normalizeEmail -> normalizeEmail)
  String normalizeEmail(String? email) {
    if (email == null || email.isEmpty) return '';
    return email.trim().toLowerCase();
  }

  // CHANGED: Updated to accept bool instead of String
  String getOrdinal(int number, bool isArabic) {
    return isArabic ? _ordinalAr(number) : _ordinalEn(number);
  }

  EmployeeEntityModell _mapToEmployeeEntityModell(EmployeeEntityPro e) {
    return EmployeeEntityModell(
      id: e.id,
      state: "pending",
      firstName: e.firstName,
      middleName: e.middleName,
      lastName: e.lastName,
      email: e.email,
      gender: e.gender,
      title: e.title,
      titleInArabic: e.titleInArabic,
      photo: e.photo,
      departmentId: e.departmentId,
      language: e.language,
      maritalStatus: e.maritalStatus,
      middleNameInArabic: e.middleNameInArabic,
      lastNameInArabic: e.lastNameInArabic,
      firstNameInArabic: e.firstNameInArabic,
      homePhone: e.homePhone,
      drivingLicenseId: e.drivingLicenseId,
      country: e.country,
      city: e.city,
      postalCode: e.postalCode,
      province: e.province,
      role: e.role,
      status: e.status,
      supervisor: e.supervisor,
      workLocation: e.workLocation,
      mobilePhone: (e.mobilePhone != null)
          ? ServicesMobilePhoneEntity.fromMobilePhoneEntity(e.mobilePhone!)
          : null,
    );
  }

  // ==================== UI HELPERS ====================

  String getScreenTitle(BuildContext context) {
    final currentState = state as ProviderSelectionLoaded;
    final data = currentState.data;

    // ✅ NEW: editProvider mode has its own title
    if (data.editProvider != null) {
      return Localizations.localeOf(context).languageCode == 'ar'
          ? 'تعديل مزود الخدمة'
          : 'Edit Service Provider';
    }

    if (data.editingModel == null && data.docId == null) {
      return S.of(context).creatingNewService;
    }

    if (data.editingModel != null) {
      final isDraft = data.editingModel!.currentState == "draft" ||
          data.editingModel!.currentDurationOfServices == "-" ||
          data.editingModel!.currentDurationOfServices.isEmpty;

      final serviceName = Localizations.localeOf(context).languageCode == 'ar'
          ? data.editingModel!.currentServiceNameArabic
          : data.editingModel!.currentServiceNameEnglish;

      if (isDraft) {
        return "${S.of(context).draft} $serviceName";
      } else {
        return "${S.of(context).Editing} $serviceName";
      }
    }

    if (data.docId != null) {
      return S.of(context).creatingNewService;
    }

    return S.of(context).creatingNewService;
  }

  String formatPhoneNumber(dynamic mobilePhone) {
    if (mobilePhone == null) return '';

    var countryCode = mobilePhone.countryCode ?? '';
    var phone = mobilePhone.phone ?? '';

    countryCode = countryCode.replaceAll('[', '').replaceAll(']', '').trim();
    phone = phone.replaceAll('[', '').replaceAll(']', '').trim();

    if (countryCode.isEmpty || phone.isEmpty) return '';

    return '+$countryCode $phone';
  }

  String _ordinalEn(int n) {
    switch (n) {
      case 1: return "First";
      case 2: return "Second";
      case 3: return "Third";
      case 4: return "Fourth";
      case 5: return "Fifth";
      case 6: return "Sixth";
      case 7: return "Seventh";
      case 8: return "Eighth";
      case 9: return "Ninth";
      case 10: return "Tenth";
      default:
        final mod100 = n % 100;
        if (mod100 >= 11 && mod100 <= 13) return "${n}th";
        switch (n % 10) {
          case 1: return "${n}st";
          case 2: return "${n}nd";
          case 3: return "${n}rd";
          default: return "${n}th";
        }
    }
  }

  String _ordinalAr(int n) {
    switch (n) {
      case 1: return "الأول";
      case 2: return "الثاني";
      case 3: return "الثالث";
      case 4: return "الرابع";
      case 5: return "الخامس";
      case 6: return "السادس";
      case 7: return "السابع";
      case 8: return "الثامن";
      case 9: return "التاسع";
      case 10: return "العاشر";
      default: return "رقم $n";
    }
  }
}
