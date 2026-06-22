import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/create_services_helper.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_helper_function.dart';
import 'package:demo_app/features/services_management_module/domain/base_repository/service_repository.dart';
import 'package:demo_app/features/services_management_module/data/models/requested_model.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/data/models/state_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/data/firebase_draft_repository.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/calc_state_method.dart';

part 'services_manager_state.dart';

class ServicesManagerCubit extends Cubit<ServicesManagerState> {
  final CreateServicesRepository repository;
  ServicesManagerCubit(this.repository) : super(ServicesManagerInitial());

  static ServicesManagerCubit get(BuildContext context) => BlocProvider.of(context);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ UPDATED: Changed all to ServicesHistoryModel
  ServicesHistoryModel? servicesModel;
  ServicesHistoryModel? docService;
  List<ServicesHistoryModel> services = [];
  List<ServicesHistoryModel> servicesRequest = [];
  List<ServicesHistoryModel> myRequestModel = [];
  List<ServicesHistoryModel> myApproval = [];
  Map<String, Map<String, dynamic>>? providerSelector;

  List<RequestedServices> requestedServices = [];
  StateStatisticsModel? stateStatisticsModel;

  EmployeeEntityPro get employeeEntity =>
      Get.find<MainCoreEmployeeController>().employeeEntity!;

  // Add to ServicesManagerCubit class

  final FirebaseDraftRepository _draftRepository = FirebaseDraftRepository();

// Track current draft ID across pages
  String? _currentDraftId;
  int? _currentDraftPage;

  String? get currentDraftId => _currentDraftId;
  int? get currentDraftPage => _currentDraftPage;

  void setCurrentDraft(String? draftId, int page) {
    _currentDraftId = draftId;
    _currentDraftPage = page;
  }

  /// Save draft to Firebase from any page
  /// Save draft to Firebase from any page
  Future<String> saveDraftToFirebase({
    required ServicesHistoryModel model,
    required int currentPage,
  }) async {
    try {
      // ✅ CRITICAL: Check if we already have a draft ID from previous save
      // If not, check if model already has a draft ID in its currentId
      String? existingId = _currentDraftId;

      if (existingId == null || existingId.isEmpty) {
        // Try to get from model's currentId if it's a draft
        if (model.currentId.startsWith('draft_')) {
          existingId = model.currentId;
          _currentDraftId = existingId; // Track it
        }
      }

      final draftId = await _draftRepository.saveDraft(
        model: model,
        currentPage: currentPage,
        existingDraftId: existingId, // ✅ Pass the existing ID
      );

      // Track this draft
      _currentDraftId = draftId;
      _currentDraftPage = currentPage;

      return draftId;
    } catch (e) {
      rethrow;
    }
  }

  /// Update existing draft page
  Future<void> updateDraftPage({
    required String draftId,
    required int currentPage,
    required ServicesHistoryModel model,
  }) async {
    try {
      await _draftRepository.updateDraftPage(
        draftId: draftId,
        currentPage: currentPage,
        updatedModel: model,
      );

      _currentDraftId = draftId;
      _currentDraftPage = currentPage;
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh drafts list after publishing - removes published draft from list
  Future<void> refreshDraftsAfterPublish(String publishedDraftId) async {

    // Clear current draft tracking
    if (_currentDraftId == publishedDraftId) {
      clearCurrentDraft();
    }

    // Reload drafts from Firebase - this will exclude the published one
    final updatedDrafts = await getFirebaseDrafts();

    // Optionally emit a state to update UI
    // emit(DraftsRefreshed(updatedDrafts));
  }

  /// Get all user drafts from Firebase
  /// Get all user drafts from Firebase
  Future<List<ServicesHistoryModel>> getFirebaseDrafts() async {
    try {
      final userEmail = employeeEntity?.email ?? '';
      if (userEmail.isEmpty) {
        return [];
      }

      // ✅ FIXED: Use the draft repository which queries CreateServices, not requestServices
      final drafts = await _draftRepository.getUserDrafts();

      // Debug print

      return drafts;

    } catch (e, stackTrace) {
      return [];
    }
  }

  /// Get draft with page info for resuming
  /// Get draft with page info for resuming
  Future<DraftWithPage?> getDraftWithPage(String draftId) async {
    final result = await _draftRepository.getDraftWithPage(draftId);

    if (result != null) {
      // ✅ CRITICAL: Track this draft ID so subsequent saves update it
      _currentDraftId = draftId;
      _currentDraftPage = result.currentPage;
    }

    return result;
  }

  /// Delete draft when done
  Future<void> deleteDraft(String draftId) async {
    await _draftRepository.deleteDraft(draftId);
    if (_currentDraftId == draftId) {
      _currentDraftId = null;
      _currentDraftPage = null;
    }
  }

  /// Clear current draft tracking
  void clearCurrentDraft() {
    _currentDraftId = null;
    _currentDraftPage = null;
  }

  Future<void> saveService(String innerDoc, ServicesHistoryModel model) async {
    emit(ServicesManagerSaving());
    try {
      // ✅ CHANGED: Use toJsonMinimal() instead of toJson()
      await _firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .doc(innerDoc)
          .set(model.toJsonForCreate());  // ✅ CHANGED

      servicesModel = model;
      emit(ServicesManagerSaved(model));
    } catch (e) {
      emit(ServicesManagerError("Failed to save: $e"));
    }
  }
  Future<void> saveRequestService(String innerDoc, ServicesHistoryModel model) async {
    emit(ServicesManagerSaving());
    try {
      // ✅ CHANGED: Use toJsonMinimal() instead of toJson()
      await _firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .doc(innerDoc)
          .set(model.toJsonForCreate());  // ✅ CHANGED

      servicesModel = model;
      emit(ServicesManagerSaved(model));
    } catch (e) {
      emit(ServicesManagerError("Failed to save: $e"));
    }
  }
  Future<void> updateService(String serviceDocId, ServicesHistoryModel model) async {
    try {

      // ✅ Call the repository method - it handles EVERYTHING:
      //    - Fetches existing document
      //    - Preserves ALL fields with copyWith
      //    - Uses full toJson() (not toJsonForCreate)
      //    - Updates CreateServices
      //    - Updates myCreateRequests
      await repository.updateService(serviceDocId, model);

      // Refresh the services list
      await getAllServices();

    } catch (e, stackTrace) {
      rethrow; // Re-throw to let the UI handle it
    }
  }

  Future<void> getAllServices() async {
    emit(GetServiceLoading());
    try {
      services = await repository.getAllServices();
      emit(GetServiceLoaded(services));
    } catch (e) {
      emit(GetServiceError('Failed to load services: $e'));
    }
  }

  Future<void> getAllRequestServices() async {
    emit(GetServiceLoading());
    try {

      // Get raw services from repository
      List<ServicesHistoryModel> rawServices = await repository.getAllRequestServices();

      // ✅ CRITICAL FIX: Repair drafts with missing emails
      servicesRequest = rawServices.map((service) {
        final email = service.currentEmailRequester ?? '';
        final state = service.currentState ?? '';

        // If draft has no email but ID contains email pattern, repair it
        if (email.isEmpty && state.toLowerCase() == 'draft') {
          final docId = service.currentId;

          // Extract email from draft ID format: draft_timestamp_email@gmail.com
          if (docId.contains('draft_')) {
            final parts = docId.split('_');
            if (parts.length >= 3) {
              // Reconstruct email (parts[2] onwards, joined by _ in case email has underscores)
              final extractedEmail = parts.sublist(2).join('_');

              // ✅ FIXED: Use correct parameter name 'emailRequester' (not 'currentEmailRequester')
              return service.copyWith(emailRequester: extractedEmail);
            }
          }
        }
        return service;
      }).toList();

      // Debug: Print all services

      emit(GetServiceLoaded(servicesRequest));

    } catch (e, stackTrace) {
      emit(GetServiceError('Failed to load services: $e'));
    }
  }

  Future<void> deleteService(String innerDocId) async {
    emit(ServicesManagerDeleting());
    try {
      await repository.deleteService(innerDocId);
      emit(ServicesManagerDeleted());
      await getAllServices();
    } catch (e) {
      emit(ServicesManagerError("Failed to delete: $e"));
    }
  }

  Map<String, dynamic>? docServiceRawJson;

  Future<void> debugCreateServicesStructure(String serviceId) async {
    try {

      final createServicesPath = getBaseUrl(FirestoreCollections.createServices);

      // ✅ Step 1: Get the collection reference

      final pathParts = createServicesPath.split('/');
      CollectionReference<Map<String, dynamic>> createServicesCollection;

      if (pathParts.length == 3) {
        createServicesCollection = _firestore
            .collection(pathParts[0])
            .doc(pathParts[1])
            .collection(pathParts[2]);
      } else if (pathParts.length == 1) {
        createServicesCollection = _firestore.collection(pathParts[0]);
      } else {
        return;
      }

      // ✅ Step 2: Get all documents in CreateServices
      final snapshot = await createServicesCollection.get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      // ✅ Step 3: Show sample documents
      for (int i = 0; i < min(5, snapshot.docs.length); i++) {
        final doc = snapshot.docs[i];
        final data = doc.data();

        // Extract service name
        String serviceName = 'N/A';
        if (data['serviceNameEnglish'] is List && (data['serviceNameEnglish'] as List).isNotEmpty) {
          serviceName = (data['serviceNameEnglish'] as List).last.toString();
        } else if (data['serviceNameEnglish'] is String) {
          serviceName = data['serviceNameEnglish'].toString();
        }

        // Extract email
        String email = 'N/A';
        if (data['emailRequester'] is List && (data['emailRequester'] as List).isNotEmpty) {
          email = (data['emailRequester'] as List).last.toString();
        } else if (data['emailRequester'] is String) {
          email = data['emailRequester'].toString();
        }

      }

      // ✅ Step 4: Search for the specific service

      final serviceDoc = await createServicesCollection.doc(serviceId).get();

      if (serviceDoc.exists) {

        final data = serviceDoc.data();
        if (data != null) {

          // Check emailRequester field
          if (data.containsKey('emailRequester')) {
            final emailReq = data['emailRequester'];
          }

          // Check service name
          if (data.containsKey('serviceNameEnglish')) {
            final serviceName = data['serviceNameEnglish'];
          }

          // Check status
          if (data.containsKey('status')) {
            final status = data['status'];
          }
        }
      }

      // ✅ Step 5: Check AllServices for comparison
      final allServicesPath = getBaseUrl(FirestoreCollections.createServices);

      final allServicesPathParts = allServicesPath.split('/');
      DocumentReference<Map<String, dynamic>> allServicesDoc;

      if (allServicesPathParts.length == 3) {
        allServicesDoc = _firestore
            .collection(allServicesPathParts[0])
            .doc(allServicesPathParts[1])
            .collection(allServicesPathParts[2])
            .doc(serviceId);
      } else if (allServicesPathParts.length == 1) {
        allServicesDoc = _firestore
            .collection(allServicesPathParts[0])
            .doc(serviceId);
      } else {
        return;
      }

      final allServicesSnapshot = await allServicesDoc.get();

      if (allServicesSnapshot.exists) {
        final data = allServicesSnapshot.data();
        if (data != null && data.containsKey('emailRequester')) {
          final emailReq = data['emailRequester'];
          String extractedEmail = '';
          if (emailReq is List && emailReq.isNotEmpty) {
            extractedEmail = emailReq.last.toString();
          } else if (emailReq is String) {
            extractedEmail = emailReq;
          }
        }
      }

      // ✅ Step 6: Query test using emailRequester
      if (serviceDoc.exists) {
        final data = serviceDoc.data();
        if (data != null && data.containsKey('emailRequester')) {
          String testEmail = '';
          if (data['emailRequester'] is List && (data['emailRequester'] as List).isNotEmpty) {
            testEmail = (data['emailRequester'] as List).last.toString().trim().toLowerCase();
          } else if (data['emailRequester'] is String) {
            testEmail = data['emailRequester'].toString().trim().toLowerCase();
          }

          if (testEmail.isNotEmpty) {
            final querySnapshot = await createServicesCollection
                .where("emailRequester", arrayContains: testEmail)
                .get();

            final foundInQuery = querySnapshot.docs.any((doc) => doc.id == serviceId);
          }
        }
      }

    } catch (e, stackTrace) {
    }
  }

  Future<ServicesHistoryModel?> getDocToEdit(String serviceId) async {
    emit(GetDocServiceLoading());
    try {
      // ✅ First, get from AllServices to find the email
      final allServicesDoc = await _firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .doc(serviceId)
          .get();

      if (!allServicesDoc.exists) {
        emit(GetDocServiceError('Service not found'));
        return null;
      }

      final allServicesData = allServicesDoc.data()!;

      String? emailFromAllServices;
      if (allServicesData['Email_Requester'] is List) {
        emailFromAllServices = (allServicesData['Email_Requester'] as List).last?.toString();
      } else {
        emailFromAllServices = allServicesData['Email_Requester']?.toString();
      }

      if (emailFromAllServices == null || emailFromAllServices.isEmpty) {
        emit(GetDocServiceError('Creator email not found'));
        return null;
      }

      emailFromAllServices = emailFromAllServices.trim().toLowerCase();

      DocumentSnapshot<Map<String, dynamic>>? doc;

      // ✅ Try to get from CreateServices using query
      try {
        final querySnapshot = await _firestore
            .collection(getBaseUrl(FirestoreCollections.createServices))
            .where("Email_Requester", arrayContains: emailFromAllServices)
            .get();

        // Find the specific document by serviceId
        final foundDoc = querySnapshot.docs.firstWhere(
              (d) => d.id == serviceId,
          orElse: () => throw Exception("Document not found"),
        );

        if (foundDoc.exists) {
          doc = foundDoc;
        }
      } catch (e) {
      }

      // ✅ If not found in CreateServices, try myCreateRequests
      if (doc == null || !doc.exists) {
        try {
          doc = await _firestore
              .collection('Demo')
              .doc('36898316')
              .collection('myCreateRequests')
              .doc(serviceId)
              .get();

        } catch (e) {
        }
      }

      if (doc != null && doc.exists) {
        docServiceRawJson = doc.data();
        final model = ServicesHistoryModel.fromJson(doc.data()!, doc.id);
        docService = model;
        emit(GetDocServiceLoaded(model));
        return model;
      } else {
        emit(GetDocServiceError('Service not found'));
        return null;
      }
    } catch (e, stackTrace) {
      emit(GetDocServiceError('Error: $e'));
      return null;
    }
  }

  String _capitalizeFirstLetter(String email) {
    if (email.isEmpty) return email;
    return email[0].toUpperCase() + email.substring(1);
  }  // Add these new methods to your cubit (services_manger_cubit.dart)

  /// Fetches document for editing WITHOUT emitting states
  Future<ServicesHistoryModel?> getDocToEditSilent(String serviceId) async {
    try {
      final allServicesDoc = await _firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .doc(serviceId)
          .get();

      if (!allServicesDoc.exists) {
        return null;
      }

      final allServicesData = allServicesDoc.data()!;

      // ✅ Extract and normalize email
      String? creatorEmail;
      if (allServicesData['Email_Requester'] is List) {
        creatorEmail = (allServicesData['Email_Requester'] as List).last?.toString();
      } else {
        creatorEmail = allServicesData['Email_Requester']?.toString();
      }

      if (creatorEmail == null || creatorEmail.isEmpty) {
        return null;
      }

      // ✅ CRITICAL FIX: Normalize to lowercase and trim
      creatorEmail = creatorEmail.trim().toLowerCase();

      // ✅ Query documents where emailRequester contains the creator's email
      final querySnapshot = await _firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .where("Email_Requester", arrayContains: creatorEmail)
          .get();

      // ✅ Find the specific document by serviceId
      final doc = querySnapshot.docs.firstWhere(
            (doc) => doc.id == serviceId,
        orElse: () => throw Exception("Document not found"),
      );

      if (doc.exists) {
        docServiceRawJson = doc.data();
        final model = ServicesHistoryModel.fromJson(doc.data(), doc.id);
        docService = model;
        return model;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Fetches from AllServices WITHOUT emitting states
  Future<ServicesHistoryModel?> getDocAllToEditSilent(String serviceId) async {
    try {
      final doc = await _firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .doc(serviceId)
          .get();

      if (doc.exists) {
        docServiceRawJson = doc.data();
        final model = ServicesHistoryModel.fromJson(doc.data()!, doc.id);
        docService = model;
        return model;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<ServicesHistoryModel?> getDocAllToEdit(String serviceId) async {
    emit(GetDocServiceLoading());
    try {
      final doc = await _firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .doc(serviceId)
          .get();

      if (doc.exists) {
        docServiceRawJson = doc.data();
        final model = ServicesHistoryModel.fromJson(doc.data()!, doc.id);
        docService = model;
        emit(GetDocServiceLoaded(model));
        return model;
      } else {
        emit(GetDocServiceError('Service not found'));
        return null;
      }
    } catch (e) {
      emit(GetDocServiceError('Error fetching document: $e'));
      return null;
    }
  }

  Future<void> uploadRequestServices(String innerDoc, ServicesHistoryModel model) async {
    emit(UploadServicesLoading());
    try {
      String? assignedProviderEmail;

      final currentProviderServices = model.currentProviderServices;

      if (currentProviderServices.isNotEmpty) {
        final selectedProvider = await _selectProviderForNewRequest(
          providers: currentProviderServices,
          parentServiceId: model.currentParentServiceId,
        );

        if (selectedProvider != null) {
          assignedProviderEmail = selectedProvider['email']?.toString().toLowerCase();
        }
      }

      if (assignedProviderEmail != null && assignedProviderEmail.isNotEmpty) {
        final updatedModel = model.copyWith(assignedProviderEmail: assignedProviderEmail);

        // ✅ CHANGED: Use toJsonMinimal() instead of toJson()
        await _firestore
            .collection(getBaseUrl(FirestoreCollections.requestServices))
            .doc(innerDoc)
            .set(updatedModel.toJsonMinimal());

        servicesModel = updatedModel;
        emit(UploadServicesSuccess(updatedModel));
      } else {
        // ✅ CHANGED: Use toJsonMinimal() instead of toJson()
        await _firestore
            .collection(getBaseUrl(FirestoreCollections.requestServices))
            .doc(innerDoc)
            .set(model.toJsonMinimal());

        servicesModel = model;
        emit(UploadServicesSuccess(model));
      }
    } catch (e) {
      emit(UploadServicesError("Failed to save: $e"));
    }
  }

  Future<Map<String, dynamic>?> _selectProviderForNewRequest({
    required List<EmployeeEntityModell> providers,
    String? parentServiceId,
  }) async
  {
    if (providers.isEmpty) return null;
    if (providers.length == 1) {
      return _convertEmployeeToMap(providers.first);
    }

    try {
      if (parentServiceId != null && parentServiceId.isNotEmpty) {
        // ✅ Query the RequestServices collection directly
        final historicalDocs = await _firestore
            .collection(getBaseUrl(FirestoreCollections.requestServices))
            .where('parentServiceId', arrayContains: parentServiceId)
            .get();

        final candidates = providers.map((e) => {
          'email': e.email ?? '',
          'firstName': e.firstName ?? '',
          'lastName': e.lastName ?? '',
          'firstNameInArabic': e.firstNameInArabic ?? '',
          'lastNameInArabic': e.lastNameInArabic ?? '',
        }).where((m) => (m['email'] ?? '').toString().isNotEmpty).toList();

        return _selectProviderByTotalWorkload(
          candidates: candidates,
          allHistoricalDocs: historicalDocs.docs,
        );
      }
    } catch (e) {
    }

    return _convertEmployeeToMap(providers.first);
  }

  Map<String, dynamic> _convertEmployeeToMap(EmployeeEntityModell employee) {
    return {
      'id': employee.id ?? '',
      'email': employee.email ?? '',
      'firstName': employee.firstName ?? '',
      'lastName': employee.lastName ?? '',
      'firstNameInArabic': employee.firstNameInArabic ?? '',
      'lastNameInArabic': employee.lastNameInArabic ?? '',
      'middleName': employee.middleName ?? '',
      'middleNameInArabic': employee.middleNameInArabic ?? '',
      'departmentId': employee.departmentId ?? '',
      'title': employee.title ?? '',
      'titleInArabic': employee.titleInArabic ?? '',
      'role': employee.role ?? '',
      'gender': employee.gender ?? '',
      'workLocation': employee.workLocation ?? '',
      'status': employee.status ?? 'active',
    };
  }

  Future<void> getMyRequestServices() async {
    emit(GetMyRequestServicesLoading());
    try {
      myRequestModel = await repository.getMyRequestServices();
      emit(GetMyRequestServicesSuccess(myRequestModel));
    } catch (e) {
      emit(GetMyRequestServicesError('Failed to load services: $e'));
    }
  }

  Future<void> updateApprovalState({
    required String docID,
    required String email,
    required String newState,
  }) async {

    try {
      final tenantRoot = getBaseUrl(FirestoreCollections.requestServices);
      final normalizedEmail = email.trim().toLowerCase();

      // ✅ FIXED: Direct path to document (no subcollection)
      final docPath = '$tenantRoot/$docID';

      final docRef = FirebaseFirestore.instance.doc(docPath);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        return;
      }

      final data = docSnapshot.data() as Map<String, dynamic>;

      // Extract approval cycle from list format
      dynamic approvalCycleData = data['approvalCycle'];
      String fieldName = 'approvalCycle';

      if (approvalCycleData == null) {
        approvalCycleData = data['appapprovalCycle'];
        fieldName = 'appapprovalCycle';
      }

      String? jsonString;
      if (approvalCycleData is List && approvalCycleData.isNotEmpty) {
        jsonString = approvalCycleData.last as String?;
      } else if (approvalCycleData is String) {
        jsonString = approvalCycleData;
      }

      if (jsonString == null || jsonString.isEmpty) {
        return;
      }

      List<dynamic> approvalList = jsonDecode(jsonString) as List<dynamic>;

      bool found = false;
      for (int i = 0; i < approvalList.length; i++) {
        final approver = approvalList[i] as Map<String, dynamic>;
        final approverEmail = (approver['email'] ?? '').toString().toLowerCase();

        if (approverEmail == normalizedEmail) {

          approver['state'] = newState;
          found = true;
          break;
        }
      }

      if (!found) {
        return;
      }

      final updatedJsonString = jsonEncode(approvalList);

      // Update using list format with timestamps
      await docRef.update({
        fieldName: FieldValue.arrayUnion([updatedJsonString]),
        'timestamps': FieldValue.arrayUnion([DateTime.now().millisecondsSinceEpoch]),
      });

      await getMyApprovalServices(email);
      emit(state);

    } catch (e, stackTrace) {
      rethrow;
    }
  }

  Future<void> deleteMyRequest(String departmentId, String innerDocId) async {
    emit(ServicesManagerDeleting());
    try {
      await repository.deleteMyRequest(departmentId, innerDocId);
      emit(ServicesManagerDeleted());
      await getAllServices();
    } catch (e) {
      emit(ServicesManagerError("Failed to delete: $e"));
    }
  }

  final Map<String, String> serviceIdToFirestoreDocId = {};
  final Map<String, String> serviceIdToRequesterEmail = {};

  Future<void> getMyApprovalServices(String? email) async {

    if (email == null || email.isEmpty) {
      emit(GetMyApprovalServicesError('Email is null or empty'));
      return;
    }

    serviceIdToFirestoreDocId.clear();
    serviceIdToRequesterEmail.clear();

    try {
      // ✅ CALL THE REPOSITORY METHOD
      final approvalList = await repository.getApprovalServices(email);

      // ✅ CRITICAL: Populate the serviceIdToFirestoreDocId map
      for (final service in approvalList) {
        final serviceId = service.currentId;

        // ✅ The Firestore document ID is the same as the service ID
        // because documents are stored directly in RequestServices collection
        serviceIdToFirestoreDocId[serviceId] = serviceId;

        // Also store requester email for reference
        serviceIdToRequesterEmail[serviceId] = service.currentEmailRequester ?? '';

      }

      myApproval = approvalList;
      emit(GetMyApprovalServicesSuccess(approvalList));

    } catch (e, stackTrace) {
      emit(GetMyApprovalServicesError(e.toString()));
    }
  }

  Map<String, Map<String, dynamic>> providerPerDoc = {};

  Future<void> loadProviderPerDocument() async {
    emit(ProviderServicesLoading());
    try {
      final result = await repository.getServiceProviderPerDoc();

      providerSelector = result;
      emit(ProviderServicesLoaded(result));
    } catch (e) {
      emit(ProviderServicesError(e.toString()));
    }
  }

  Future<void> addRequestedService({
    required String docId,
    required String uidUser,
    required RequestedServices requestModel,
  }) async {
    emit(RequestServiceLoading());
    try {
      await repository.addRequestedService(
        uidUser: uidUser,
        docId: docId,
        requestModel: requestModel,
      );
      emit(RequestServiceSuccess());
    } catch (e) {
      emit(RequestServiceError(e.toString()));
    }
  }

  Future<void> getRequestedServices(String docId) async {
    emit(RequestServiceLoading());
    try {
      requestedServices = await repository.getRequestedServices(docId: docId);
      emit(RequestServiceSuccess());
    } catch (e) {
      emit(RequestServiceError(e.toString()));
    }
  }

  Future<void> getStatistics(String parentDocId) async {
    emit(StateStatisticsLoading());
    try {
      final result = await repository.fetchStateStatistics(parentDocId);
      stateStatisticsModel = result;
      emit(StateStatisticsLoaded(result));
    } catch (e) {
      emit(StateStatisticsError(e.toString()));
    }
  }

  String userEmail = '';
  String userDepartment = '';

  // ✅ UPDATED: All list types changed to ServicesHistoryModel
  List<ServicesHistoryModel> allServices = [];
  List<ServicesHistoryModel> firebaseServices = [];
  List<ServicesHistoryModel> draftServices = [];
  List<ServicesHistoryModel> activeServices = [];
  List<ServicesHistoryModel> inactiveServices = [];
  Map<String, int> doneServicesCount = {};
  Map<String, Map<String, dynamic>> selectedProviders = {};

  String slaOne = '';
  String slaTwo = '';

  List<String> extraSlaOneList = [];
  List<String> extraSlaTwoList = [];

  bool notifyRequesterChecked = true;
  bool notifyProviderChecked = true;
  bool notifyManagerChecked = true;

  bool notifyRequesterSwitch0 = false;
  bool notifyManagerSwitch1 = false;

  Map<String, Map<int, bool>> notificationSwitches = {};

  Future loadServices() async {
    emit(ServicesLoading());
    try {
      firebaseServices = await repository.getFirebaseServices();
      draftServices = await repository.getLocalDrafts();

      allServices = [...firebaseServices, ...draftServices];

      // ✅ UPDATED: Access current values
      activeServices = firebaseServices
          .where((e) => e.currentStatus.toLowerCase() == 'active')
          .toList();
      inactiveServices = firebaseServices
          .where((e) => e.currentStatus.toLowerCase() == 'inactive')
          .toList();

      selectedProviders = await repository.getSelectedProviders(firebaseServices);
      doneServicesCount = await repository.getDoneServicesCount();

      emit(ServicesLoaded());
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  void search(String query) {
    final lowerQuery = query.toLowerCase();
    final results = allServices.where((item) {
      // ✅ UPDATED: Access current values
      return item.currentServiceNameEnglish.toLowerCase().contains(lowerQuery) ||
          item.currentServiceNameArabic.toLowerCase().contains(lowerQuery);
    }).toList();

    emit(ServicesFiltered(results));
  }

  Future<void> checkDuplicateNameAndProceed(String name, ServicesHistoryModel model) async {
    emit(ServicesLoading());
    final isDuplicate = await repository.checkDuplicateServiceName(name);
    if (isDuplicate) {
      emit(ServiceNameDuplicate());
    } else {
      await repository.saveServiceToPrefs(model);
      emit(ServiceSavedToPrefs());
    }
  }

  Future<void> saveServiceDraft(ServicesHistoryModel model) async {
    await repository.saveServiceToPrefs(model);
    emit(ServiceSavedToPrefs());
  }

  Future<void> fetchServiceStatus(String docId) async {
    emit(ServiceStatusLoading());
    final status = await repository.getServiceStatus(docId);
    emit(ServiceStatusFetched(status == "active"));
  }

  Future<void> updateServiceStatus(String docId, bool isActive) async {
    await repository.updateServiceStatus(docId, isActive);
    emit(ServiceStatusUpdated());
  }

  // Future<void> loadEmployees() async {
  //   emit(EmployeeLoading());
  //   try {
  //     final employees = await repository.getAllEmployees();
  //     emit(EmployeeLoaded(employees));
  //   } catch (e) {
  //     emit(EmployeeError(e.toString()));
  //   }
  // }

  Future<void> loadSlaData() async {
    emit(ServicesLoading());
    try {
      final data = await repository.loadFromSharedPrefs();

      slaOne = data.slaOne;
      slaTwo = data.slaTwo;

      notifyRequesterChecked = data.notifyRequesterChecked;
      notifyProviderChecked = data.notifyProviderChecked;
      notifyManagerChecked = data.notifyManagerChecked;

      notifyRequesterSwitch0 = data.notifyRequesterSwitch0;
      notifyManagerSwitch1 = data.notifyManagerSwitch1;

      extraSlaOneList = data.extraSlaValues;
      extraSlaTwoList = data.extraSlaTwoValues;
      notificationSwitches = data.notificationSwitches;

      emit(SlaDataLoaded());
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  Future<void> saveSlaDraft(ServicesHistoryModel model, {ServicesHistoryModel? oldModel}) async {
    emit(ServicesLoading());
    try {
      if (oldModel != null) {
        await repository.updateDraft(oldModel, model);
      } else {
        await repository.saveDraft(model);
      }
      emit(SlaDraftSaved());
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  Future<void> submitSlaService(String docId, ServicesHistoryModel model, {required bool isUpdate}) async {
    emit(ServicesLoading());
    try {
      if (isUpdate) {
        await repository.updateService(docId, model);
      } else {
        await repository.saveService(docId, model);
      }

      emit(SlaServiceSubmitted());
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  Future<void> submitSlaData({
    required String slaOne,
    required String slaTwo,
    required bool notifyRequesterChecked,
    required bool notifyProviderChecked,
    required bool notifyManagerChecked,
    required bool notifyRequesterSwitch0,
    required bool notifyManagerSwitch1,
    required List<String> extraSlaList,
    required List<String> extraSlaTwoList,
    required Map<String, Map<int, bool>> notificationSwitches,
  }) async {
    emit(SlaSaving());
    try {
      await repository.saveSlaToPrefs(
        slaOne: slaOne,
        slaTwo: slaTwo,
        notifyRequesterChecked: notifyRequesterChecked,
        notifyProviderChecked: notifyProviderChecked,
        notifyManagerChecked: notifyManagerChecked,
        notifyRequesterSwitch0: notifyRequesterSwitch0,
        notifyManagerSwitch1: notifyManagerSwitch1,
        extraSlaList: extraSlaList,
        extraSlaTwoList: extraSlaTwoList,
        notificationSwitches: notificationSwitches,
      );
      emit(SlaSaved());
    } catch (e) {
      emit(SlaError(e.toString()));
    }
  }

  Future<void> loadRequestServices(BuildContext context) async {
    emit(RequestServicesLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      userEmail = prefs.getString("emailRequester") ?? '';
      userDepartment = MainCoreEmployeeController().getEmployeeDepartmentName(userEmail);

      allServices = await repository.getFilteredServices(context, userEmail, userDepartment);
      final deptCounts = await repository.getDepartmentCounts(context, userDepartment);

      emit(RequestServicesLoaded(services: allServices, departmentCounts: deptCounts));
    } catch (e) {
      emit(RequestServicesError(e.toString()));
    }
  }

  searchServices(String query) {
    final lowerQuery = query.toLowerCase().trim();
    return allServices.where((service) {
      // ✅ UPDATED: Access current values
      final en = service.currentServiceNameEnglish.toLowerCase();
      final ar = service.currentServiceNameArabic.toLowerCase();
      return en.contains(lowerQuery) || ar.contains(lowerQuery);
    }).toList();
  }

  filterByDepartment(String department) {
    return department == "All"
        ? allServices
        : allServices.where((s) =>
    s.currentDepartmentRequester.toLowerCase() == department.toLowerCase()
    ).toList();
  }

  Future<Map<String, dynamic>?> getProviderForService(String id) {
    return repository.selectServiceProvider(id);
  }

  Map<String, dynamic>? pickProviderFromRecentDocs({
    required List<Map<String, dynamic>> candidates,
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> recentDocs,
    required DateTime startToday,
    required DateTime endToday,
    int perDayCap = 2,
    required Function isActiveStatus,
    required Function toMinutes,
  }) {
    if (candidates.isEmpty) return null;
    if (candidates.length == 1) return candidates.first;

    final emails = candidates
        .map((c) => (c['email'] ?? '').toString().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet();
    if (emails.isEmpty) return candidates.first;

    final Map<String, double> minutes = {for (final e in emails) e: 0.0};
    final Map<String, int> count = {for (final e in emails) e: 0};
    final Map<String, int> today = {for (final e in emails) e: 0};

    for (final d in recentDocs) {
      final data = d.data();
      final prov = data['provider'];
      if (prov is! Map) continue;

      final email = (prov['email'] ?? '').toString().toLowerCase();
      if (!emails.contains(email)) continue;

      final st = (data['state'] ?? '').toString();
      if (!isActiveStatus(st)) continue;

      final ts = data['createdAt'] ?? data['serviceNameEnglishTimestamp'];
      if (ts is! Timestamp) continue;
      final created = ts.toDate();

      final unit = data['selectedDurationUnit'] is Map
          ? data['selectedDurationUnit']['value']?.toString()
          : data['selectedDurationUnit']?.toString();

      final valStr = data['durationOfServices'] is Map
          ? data['durationOfServices']['value']?.toString()
          : data['durationOfServices']?.toString();

      final mins = toMinutes(double.tryParse(valStr ?? '0') ?? 0, unit);

      minutes[email] = (minutes[email] ?? 0) + mins;
      count[email] = (count[email] ?? 0) + 1;

      if (!created.isBefore(startToday) && created.isBefore(endToday)) {
        today[email] = (today[email] ?? 0) + 1;
      }
    }

    final filtered = (perDayCap > 0)
        ? candidates.where((c) {
      final e = (c['email'] ?? '').toString().toLowerCase();
      return (today[e] ?? 0) < perDayCap;
    }).toList()
        : candidates.toList();

    final pool = filtered.isNotEmpty ? filtered : candidates;

    pool.sort((a, b) {
      final ea = (a['email'] ?? '').toString().toLowerCase();
      final eb = (b['email'] ?? '').toString().toLowerCase();
      final mA = minutes[ea] ?? 0;
      final mB = minutes[eb] ?? 0;
      if (mA != mB) return mA.compareTo(mB);
      final cA = count[ea] ?? 0;
      final cB = count[eb] ?? 0;
      if (cA != cB) return cA.compareTo(cB);
      return ea.compareTo(eb);
    });

    final best = pool.first;
    final be = (best['email'] ?? '').toString().toLowerCase();
    final bm = minutes[be] ?? 0;
    final bc = count[be] ?? 0;

    final tied = pool.where((c) {
      final e = (c['email'] ?? '').toString().toLowerCase();
      return (minutes[e] ?? 0) == bm && (count[e] ?? 0) == bc;
    }).toList();

    if (tied.length <= 1) return best;
    tied.shuffle(Random());
    return tied.first;
  }

  Future<Map<String, dynamic>?> computeProvider({
    required List<EmployeeEntityModell> providerServices,
  }) {
    final candidates = (providerServices ?? [])
        .map((e) => {
      'email': e.email,
      'firstName': e.firstName,
      'lastName': e.lastName,
      'firstNameInArabic': e.firstNameInArabic,
      'lastNameInArabic': e.lastNameInArabic,
      'title': e.title,
      'titleInArabic': e.titleInArabic,
      'mobilePhone': (e.mobilePhone == null)
          ? null
          : {
        'countryApp': e.mobilePhone?.countryApp,
        'countryCode': e.mobilePhone?.countryCode,
        'phone': e.mobilePhone?.phone,
      },
    })
        .where((m) => (m['email'] ?? '').toString().isNotEmpty)
        .toList();

    return selectServiceProviderLite(
      candidates: candidates,
      windowDays: 7,
      perDayCap: 2,
    );
  }

  Future<Map<String, dynamic>> loadFilteredItems({
    required String? parentServiceId,
    required BuildContext context,
    required ServicesHistoryModel parentService,
  }) async {

    final firestore = FirebaseFirestore.instance;
    final String? parentId = parentServiceId?.trim();

    final emptyResult = {
      'filteredItems': <Map<String, dynamic>>[],
      'allEmployees': <EmployeeEntityModell>[],
      'displayedStats': <Map<String, dynamic>>[],
      'localStats': {
        'done': 0,
        'approved': 0,
        'inprogress': 0,
        'pending': 0,
        'rejected': 0,
        'cancel': 0,
        'branchsla': 0,
      },
    };

    if (parentId == null || parentId.isEmpty) {
      return emptyResult;
    }

    try {
      final String requestServicesPath = getBaseUrl(FirestoreCollections.requestServices);

      final pathParts = requestServicesPath.split('/');

      CollectionReference<Map<String, dynamic>> requestsCollection;

      if (pathParts.length == 3) {
        requestsCollection = firestore
            .collection(pathParts[0])
            .doc(pathParts[1])
            .collection(pathParts[2]);
      } else if (pathParts.length == 1) {
        requestsCollection = firestore.collection(pathParts[0]);
      } else {
        return emptyResult;
      }

      final requestsSnapshot = await requestsCollection.get();

      List<QueryDocumentSnapshot> matchingDocs = [];

      for (final doc in requestsSnapshot.docs) {
        final data = doc.data();
        String docParentId = '';

        if (data['Parent_Service_Id'] is List) {
          final parentIdList = data['Parent_Service_Id'] as List;
          if (parentIdList.isNotEmpty) {
            docParentId = parentIdList.last.toString().trim();
          }
        } else if (data['Parent_Service_Id'] is String) {
          docParentId = data['Parent_Service_Id'].toString().trim();
        }

        if (docParentId == parentId) {
          matchingDocs.add(doc);
        }
      }

      if (matchingDocs.isEmpty) {
        return emptyResult;
      }

      final List<Map<String, dynamic>> results = [];
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';

      int doneCount = 0;
      int approvedCount = 0;
      int inProgressCount = 0;
      int pendingCount = 0;
      int rejectedCount = 0;
      int cancelCount = 0;
      int branchSlaCount = 0;

      for (int i = 0; i < matchingDocs.length; i++) {
        final doc = matchingDocs[i];
        final data = doc.data() as Map<String, dynamic>;
        final docId = doc.id;

        ServicesHistoryModel? model;
        try {
          model = ServicesHistoryModel.fromJson(data, docId);
        } catch (e) {
          continue;
        }

        // ✅ FETCH MISSING DATA FROM CreateServices
        Map<String, String> serviceDetails = {};

        // Extract email from model
        String emailRequester = model.currentEmailRequester;

        // If email is empty, try to extract from data
        if (emailRequester.isEmpty && data.containsKey('Email_Requester')) {
          final rawEmail = data['Email_Requester'];
          if (rawEmail is List && rawEmail.isNotEmpty) {
            emailRequester = rawEmail.last.toString();
          } else if (rawEmail is String) {
            emailRequester = rawEmail;
          }
        }

        if (emailRequester.isNotEmpty && parentId.isNotEmpty) {
          try {
            // ✅ CRITICAL: Fetch service and requester data from CreateServices
            serviceDetails = await CreateServicesHelper.getServiceDetailsFromCreateServices(
              parentServiceId: parentId,
              emailRequester: emailRequester,
            );

            // ✅ UPDATE the model with fetched data
            model = model.copyWith(
              serviceNameEnglish: serviceDetails['serviceNameEnglish']!.isNotEmpty
                  ? serviceDetails['serviceNameEnglish']
                  : null,
              serviceNameArabic: serviceDetails['serviceNameArabic']!.isNotEmpty
                  ? serviceDetails['serviceNameArabic']
                  : null,
              firstNameRequester: serviceDetails['requesterName']!.split(' ').first,
              lastNameRequester: serviceDetails['requesterName']!.split(' ').length > 1
                  ? serviceDetails['requesterName']!.split(' ').sublist(1).join(' ')
                  : '',
              firstNameRequesterArabic: serviceDetails['requesterNameArabic']!.split(' ').first,
              lastNameRequesterArabic: serviceDetails['requesterNameArabic']!.split(' ').length > 1
                  ? serviceDetails['requesterNameArabic']!.split(' ').sublist(1).join(' ')
                  : '',
              jobTitleRequester: serviceDetails['jobTitle'],
              jobTitleRequesterArabic: serviceDetails['jobTitleArabic'],
            );

          } catch (e) {
            // Continue with empty data if fetch fails
          }
        }

        final requestor = isArabic
            ? '${model!.currentFirstNameRequesterArabic} ${model.currentLastNameRequesterArabic}'.trim()
            : '${model!.currentFirstNameRequester} ${model.currentLastNameRequester}'.trim();

        final jobTitle = isArabic
            ? model.currentJobTitleRequesterArabic
            : model.currentJobTitleRequester;

        String calculatedStatus = 'pending';

        if (data.containsKey('state')) {
          final rawState = data['state'];
          if (rawState is List && rawState.isNotEmpty) {
            calculatedStatus = rawState.last.toString().toLowerCase().trim();
          } else if (rawState is String && rawState.isNotEmpty) {
            calculatedStatus = rawState.toLowerCase().trim();
          }
        }

        if ((calculatedStatus.isEmpty || calculatedStatus == 'pending') &&
            model.currentState.isNotEmpty) {
          calculatedStatus = model.currentState.toLowerCase().trim();
        }

        switch (calculatedStatus) {
          case 'done':
            doneCount++;
            break;
          case 'approved':
            approvedCount++;
            break;
          case 'inprogress':
          case 'in progress':
            inProgressCount++;
            break;
          case 'pending':
            pendingCount++;
            break;
          case 'rejected':
            rejectedCount++;
            break;
          case 'cancel':
          case 'cancelled':
          case 'canceled':
            cancelCount++;
            break;
          case 'branchsla':
          case 'breached sla':
            branchSlaCount++;
            break;
          default:
            pendingCount++;
        }

        String assignedEmail = '';
        if (data.containsKey('Assigned_Provider_Email')) {
          final rawEmail = data['Assigned_Provider_Email'];

          if (rawEmail is List && rawEmail.isNotEmpty) {
            assignedEmail = rawEmail.last.toString().trim().toLowerCase();
          } else if (rawEmail is String && rawEmail.isNotEmpty) {
            assignedEmail = rawEmail.trim().toLowerCase();
          }
        }

        if (assignedEmail.isEmpty) {
          assignedEmail = model.currentAssignedProviderEmail.trim().toLowerCase();
        }

        String providerName = 'N/A';

        if (assignedEmail.isNotEmpty) {
          List<EmployeeEntityModell> availableProviders = [];
          availableProviders.addAll(parentService.currentProviderServices);

          if (data.containsKey('Provider_Services')) {
            try {
              final rawProviders = data['Provider_Services'];
              String providersJson = '';

              if (rawProviders is List && rawProviders.isNotEmpty) {
                providersJson = rawProviders.last.toString();
              } else if (rawProviders is String) {
                providersJson = rawProviders;
              }

              if (providersJson.isNotEmpty) {
                final providersList = jsonDecode(providersJson) as List;
                for (var providerData in providersList) {
                  try {
                    final provider = EmployeeEntityModell(
                      id: providerData['id']?.toString() ?? '',
                      email: providerData['email']?.toString() ?? '',
                      firstName: providerData['firstName']?.toString() ?? '',
                      lastName: providerData['lastName']?.toString() ?? '',
                      firstNameInArabic: providerData['firstNameInArabic']?.toString() ?? '',
                      lastNameInArabic: providerData['lastNameInArabic']?.toString() ?? '',
                      middleName: providerData['middleName']?.toString() ?? '',
                      middleNameInArabic: providerData['middleNameInArabic']?.toString() ?? '',
                      title: providerData['title']?.toString() ?? '',
                      titleInArabic: providerData['titleInArabic']?.toString() ?? '',
                      departmentId: providerData['departmentId']?.toString() ?? '',
                      role: providerData['role']?.toString() ?? '',
                      gender: providerData['gender']?.toString() ?? '',
                      status: providerData['status']?.toString() ?? 'active',
                    );
                    availableProviders.add(provider);
                  } catch (e) {
                  }
                }
              }
            } catch (e) {
            }
          }

          EmployeeEntityModell? foundProvider;

          try {
            foundProvider = availableProviders.firstWhere(
                  (p) => (p.email ?? '').toLowerCase() == assignedEmail,
            );
          } catch (e) {
            try {
              foundProvider = parentService.currentApprovalCycle.firstWhere(
                    (p) => (p.email ?? '').toLowerCase() == assignedEmail,
              );
            } catch (e2) {
            }
          }

          if (foundProvider != null) {
            providerName = isArabic
                ? '${foundProvider.firstNameInArabic ?? ''} ${foundProvider.lastNameInArabic ?? ''}'.trim()
                : '${foundProvider.firstName ?? ''} ${foundProvider.lastName ?? ''}'.trim();

            if (providerName.isEmpty) {
              providerName = assignedEmail;
            }

          } else {
            providerName = assignedEmail;
          }
        }

        final timestamp = model.currentDurationOfServicesTimestamp;
        final requestDate = DateFormat.yMMMMd(Localizations.localeOf(context).languageCode)
            .format(timestamp.toDate());

        // ✅ Use department from fetched data if available
        String departmentId = model.currentDepartmentRequester;
        if (departmentId.isEmpty && serviceDetails.containsKey('department')) {
          // If we have department name from helper, we need to convert it back to ID
          // For now, just use what we have
          departmentId = serviceDetails['department'] ?? '';
        }

        results.add({
          "no": i + 1,
          "department": departmentId,
          "serviceName": model.currentServiceNameEnglish.isNotEmpty
              ? model.currentServiceNameEnglish
              : model.currentServiceNameArabic,
          "gender": model.currentGenderRequester,
          "requestor": requestor.isNotEmpty ? requestor : "-",
          "jobtitle": jobTitle.isEmpty ? "-" : jobTitle,
          "requestDate": requestDate,
          "status": calculatedStatus,
          "provider": providerName,
          "docId": docId,
          "model": model,  // ✅ Updated model with fetched data
          "raw": data,
        });
      }

      final providerList = parentService.currentProviderServices;
      final approvalList = parentService.currentApprovalCycle;

      final Set<String> usedEmails = {};
      final List<EmployeeEntityModell> combined = [];

      for (final provider in providerList) {
        final email = (provider.email ?? '').toLowerCase();
        if (email.isNotEmpty && !usedEmails.contains(email)) {
          combined.add(provider);
          usedEmails.add(email);
        }
      }

      for (final approver in approvalList) {
        final email = (approver.email ?? '').toLowerCase();
        if (email.isNotEmpty && !usedEmails.contains(email)) {
          combined.add(approver);
          usedEmails.add(email);
        }
      }
      final displayedStats = combined
          .map((e) => calculateStatsForEmployee(
        e,
        context,
        results,
        parentDuration: parentService.currentDurationOfServices,
        parentDurationUnit: parentService.currentSelectedDurationUnit,
      ))
          .toList();

      final localStats = {
        'done': doneCount,
        'approved': approvedCount,
        'inprogress': inProgressCount,
        'pending': pendingCount,
        'rejected': rejectedCount,
        'cancel': cancelCount,
        'branchsla': branchSlaCount,
      };

      return {
        'filteredItems': results,
        'allEmployees': combined,
        'displayedStats': displayedStats,
        'localStats': localStats,
      };
    } catch (e, stackTrace) {
      return emptyResult;
    }
  }

  Map<String, dynamic>? _selectProviderByTotalWorkload({
    required List<Map<String, dynamic>> candidates,
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> allHistoricalDocs,
  }) {
    if (candidates.isEmpty) return null;
    if (candidates.length == 1) return candidates.first;

    final Map<String, double> totalWorkload = {};
    final Map<String, int> totalAssignments = {};

    for (final candidate in candidates) {
      final email = (candidate['email'] ?? '').toString().toLowerCase();
      totalWorkload[email] = 0.0;
      totalAssignments[email] = 0;
    }

    for (final doc in allHistoricalDocs) {
      final data = doc.data();

      String assignedEmail = '';
      if (data.containsKey('assignedProviderEmail') && data['assignedProviderEmail'] != null) {
        assignedEmail = data['assignedProviderEmail'].toString().toLowerCase();
      } else if (data.containsKey('provider') && data['provider'] is Map) {
        final pData = data['provider'] as Map<String, dynamic>;
        assignedEmail = (pData['email'] ?? '').toString().toLowerCase();
      }

      if (assignedEmail.isNotEmpty && totalWorkload.containsKey(assignedEmail)) {
        final minutes = _calculateWorkloadMinutes(data);
        totalWorkload[assignedEmail] = (totalWorkload[assignedEmail] ?? 0) + minutes;
        totalAssignments[assignedEmail] = (totalAssignments[assignedEmail] ?? 0) + 1;

      }
    }

    final sortedCandidates = List<Map<String, dynamic>>.from(candidates);
    sortedCandidates.sort((a, b) {
      final emailA = (a['email'] ?? '').toString().toLowerCase();
      final emailB = (b['email'] ?? '').toString().toLowerCase();

      final workloadA = totalWorkload[emailA] ?? 0.0;
      final workloadB = totalWorkload[emailB] ?? 0.0;

      if (workloadA != workloadB) {
        return workloadA.compareTo(workloadB);
      }

      final assignmentsA = totalAssignments[emailA] ?? 0;
      final assignmentsB = totalAssignments[emailB] ?? 0;
      if (assignmentsA != assignmentsB) {
        return assignmentsA.compareTo(assignmentsB);
      }

      return emailA.compareTo(emailB);
    });

    final chosen = sortedCandidates.first;
    final chosenEmail = (chosen['email'] ?? '').toString().toLowerCase();

    return chosen;
  }

  double _calculateWorkloadMinutes(Map<String, dynamic> data) {
    double value = 0.0;
    String unit = 'minutes';

    // ✅ UPDATED: Handle list format for durationOfServices
    if (data.containsKey('durationOfServices')) {
      final duration = data['durationOfServices'];
      if (duration is List && duration.isNotEmpty) {
        value = double.tryParse(duration.last.toString()) ?? 0.0;
      } else if (duration is String || duration is num) {
        value = double.tryParse(duration.toString()) ?? 0.0;
      }
    }

    // ✅ UPDATED: Handle list format for selectedDurationUnit
    if (data.containsKey('selectedDurationUnit')) {
      final unitData = data['selectedDurationUnit'];
      if (unitData is List && unitData.isNotEmpty) {
        unit = unitData.last.toString();
      } else if (unitData is String) {
        unit = unitData;
      }
    }

    switch (unit.toLowerCase()) {
      case 'hours':
      case 'hour':
      case 'h':
        return value * 60;
      case 'days':
      case 'day':
      case 'd':
        return value * 1440;
      case 'weeks':
      case 'week':
      case 'w':
        return value * 10080;
      default:
        return value;
    }
  }

  double _toMinutes(double v, String? unit) {
    switch ((unit ?? '').toLowerCase()) {
      case 'minutes':
        return v;
      case 'hours':
        return v * 60;
      case 'days':
        return v * 60 * 24;
      case 'weeks':
        return v * 60 * 24 * 7;
      default:
        return v;
    }
  }

  bool _isActiveStatus(String s) {
    s = s.toLowerCase();
    return s == 'pending' || s == 'approved' || s == 'inprogress' || s == 'done';
  }

  Future<Map<String, dynamic>?> selectServiceProviderLite({
    required List<Map<String, dynamic>> candidates,
    int windowDays = 7,
    int perDayCap = 2,
  }) async {
    if (candidates.isEmpty) return null;
    if (candidates.length == 1) return candidates.first;

    try {
      final now = DateTime.now();
      final startWindow = now.subtract(Duration(days: windowDays));
      final startToday = DateTime(now.year, now.month, now.day);
      final endToday = startToday.add(Duration(days: 1));

      final recentDocs = await _firestore
          .collectionGroup('user')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startWindow))
          .get();

      return pickProviderFromRecentDocs(
        candidates: candidates,
        recentDocs: recentDocs.docs,
        startToday: startToday,
        endToday: endToday,
        perDayCap: perDayCap,
        isActiveStatus: _isActiveStatus,
        toMinutes: _toMinutes,
      );
    } catch (e) {
      return candidates.first;
    }
  }
}
