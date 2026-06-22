import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:demo_app/core/utils/shared.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_prefs_employee.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/employee/data/models/emplyees_model/new_employee_model.dart';
import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/features/services_management_module/domain/base_repository/service_repository.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/create_services_helper.dart';
import 'package:demo_app/features/services_management_module/data/models/requested_model.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/data/models/state_model.dart';

class GetServiceRepositoryImpl implements CreateServicesRepository {
  final FirebaseFirestore firestore;

  GetServiceRepositoryImpl({required this.firestore});

  EmployeeEntityPro get employeeEntity =>
      Get.find<MainCoreEmployeeController>().employeeEntity!;

 // @override
  // Future<void> uploadServices(
  //     ServicesHistoryModel services,
  //     String departmentId,
  //     ) async
  // {
  //   // final servicesMap = services.toJson();
  //   // await firestore
  //   //     .collection(getBaseUrl('CreateServices'))
  //   //     .doc('services_list')
  //   //     .set(servicesMap);
  // }
  //CreateServices

  @override
  Future<List<ServicesHistoryModel>> getAllServices() async {
    List<ServicesHistoryModel> servicesList = [];

    try {

      final controller = Get.find<MainCoreEmployeeController>();

      if (controller.employeeEntity == null) {
        await Future.delayed(Duration(milliseconds: 500));

        if (controller.employeeEntity == null) {
          return servicesList;
        }
      }

      final userEmail = controller.employeeEntity!.email;
      if (userEmail == null || userEmail.isEmpty) {
        return servicesList;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl('CreateServices'))
          .where('Email_Requester',isEqualTo: "Email_Requester")
          .get();

      final prefs = await SharedPreferences.getInstance();

      for (var doc in querySnapshot.docs) {

        final model = ServicesHistoryModel.fromJson(doc.data(), doc.id);

        servicesList.add(model);

        // ✅ UPDATED: Use current getters
        await prefs.setString('firstNameRequester', model.currentFirstNameRequester);
        await prefs.setString('lastNameRequester', model.currentLastNameRequester);
        await prefs.setString('jobTitleRequester', model.currentJobTitleRequester);
        await prefs.setString('departmentRequester', model.currentDepartmentRequester);
        await prefs.setString('emailRequester', userEmail);
        await prefs.setString('firstNameRequesterArabic', model.currentFirstNameRequesterArabic);
        await prefs.setString('lastNameRequesterArabic', model.currentLastNameRequesterArabic);
        await prefs.setString('jobTitleRequesterArabic', model.currentJobTitleRequesterArabic);
      }
    } catch (e) {
    }

    return servicesList;
  }

  @override
  Future<List<ServicesHistoryModel>> getAllRequestServices() async {
    final List<ServicesHistoryModel> servicesList = [];

    try {

      final String tenantRoot = getBaseUrl(FirestoreCollections.createServices);

      // ✅ Query the CreateServices collection directly
      final querySnapshot = await FirebaseFirestore.instance
          .collection(tenantRoot)
          .get();

      int processedCount = 0;

      for (var doc in querySnapshot.docs) {
        processedCount++;

        try {
          final model = ServicesHistoryModel.fromJson(doc.data(), doc.id);
          servicesList.add(model);

        } catch (e) {
        }
      }

    } catch (e) {
    }

    return servicesList;
  }

  @override
  Future<void> deleteService(String innerDocId) async {
    await firestore
        .collection(getBaseUrl(FirestoreCollections.createServices))
        .doc(innerDocId)
        .delete();
  }

  @override
  Future<ServicesHistoryModel?> getServiceById(
      String departmentId,
      String serviceId,
      ) async {
    try {
      final doc = await firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .doc(serviceId)
          .get();

      //Document_Utilization
      if (doc.exists) {
        return ServicesHistoryModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> uploadRequest(
      ServicesHistoryModel services,
      String departmentId,
      ) async {
    final servicesMap = services.toJson();
    await firestore
        .collection(getBaseUrl(FirestoreCollections.createServices))
        .doc('services_list')
        .set(servicesMap);
  }

  @override
  Future<List<ServicesHistoryModel>> getMyRequestServices() async {
    List<ServicesHistoryModel> servicesList = [];

    try {

      final querySnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .where("Email_Requester", arrayContains: employeeEntity.email)
          .get();

      // ✅ Process each document and enrich with service names
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        var service = ServicesHistoryModel.fromJson(data, doc.id);

        // ✅ If service names are empty, fetch from parent CreateServices
        if ((service.currentServiceNameEnglish.isEmpty || service.currentServiceNameArabic.isEmpty)
            && service.currentParentServiceId.isNotEmpty) {

          try {
            final serviceDetails = await CreateServicesHelper.getServiceDetailsFromCreateServices(
              parentServiceId: service.currentParentServiceId,
              emailRequester: employeeEntity.email!,
            );

            // ✅ Update the service with fetched names using copyWith
            service = service.copyWith(
              serviceNameEnglish: serviceDetails['serviceNameEnglish'],
              serviceNameArabic: serviceDetails['serviceNameArabic'],
              serviceDescriptionEnglish: serviceDetails['serviceDescriptionEnglish'],
              serviceDescriptionArabic: serviceDetails['serviceDescriptionArabic'],
              durationOfServices: serviceDetails['duration'],
              selectedDurationUnit: serviceDetails['unit'],
            );

          } catch (e) {
            // Continue with empty service name if parent fetch fails
          }
        }

        servicesList.add(service);
      }

    } catch (e) {
    }

    return servicesList;
  }

  @override
  Future<void> deleteMyRequest(String departmentId, String innerDocId) async {
    // Query directly in RequestServices collection
    final querySnapshot = await firestore
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("Email_Requester", arrayContains: employeeEntity.email)
        .get();

    // Find and delete the matching document by ID
    for (var doc in querySnapshot.docs) {
      if (doc.id == innerDocId) {
        await doc.reference.delete();
        return;
      }
    }

  }

  @override
  Future<List<ServicesHistoryModel>> getApprovalServices(String email) async {
    final firestore = FirebaseFirestore.instance;
    final String target = email.trim().toLowerCase();
    final String tenantRoot = getBaseUrl(FirestoreCollections.requestServices);

    final List<ServicesHistoryModel> servicesList = [];

    try {
      // ✅ CRITICAL FIX: Parse the path properly
      final pathParts = tenantRoot.split('/');

      CollectionReference<Map<String, dynamic>> requestsCollection;

      if (pathParts.length == 3) {
        // Format: "Demo/14031841/RequestServices"
        requestsCollection = firestore
            .collection(pathParts[0])  // "Demo"
            .doc(pathParts[1])          // "14031841"
            .collection(pathParts[2]);  // "RequestServices"
      } else if (pathParts.length == 1) {
        // Format: "RequestServices" (direct collection)
        requestsCollection = firestore.collection(pathParts[0]);
      } else {
        return servicesList;
      }

      // ✅ Get ALL documents
      final querySnapshot = await requestsCollection.get();

      if (querySnapshot.docs.isEmpty) {
        return servicesList;
      }

      int processedCount = 0;
      int foundWithApprovalCycle = 0;
      int matchedEmail = 0;

      for (var doc in querySnapshot.docs) {
        processedCount++;
        final data = doc.data();

        // ✅ Check BOTH field name variations (camelCase and PascalCase with underscore)
        dynamic approvalCycleData = data['Approval_Cycle'] ?? data['Approval_Cycle'];

        if (approvalCycleData == null) {
          continue;
        }

        if (approvalCycleData is! List || approvalCycleData.isEmpty) {
          continue;
        }

        foundWithApprovalCycle++;

        final lastEntry = approvalCycleData.last;

        if (lastEntry is! String) {
          continue;
        }

        try {
          final decoded = jsonDecode(lastEntry) as List;

          // Print all approvers
          for (int i = 0; i < decoded.length; i++) {
            final approver = decoded[i];
            final approverEmail = (approver['email'] ?? '').toString().toLowerCase().trim();
            final approverName = '${approver['firstName'] ?? ''} ${approver['lastName'] ?? ''}'.trim();
            final approverState = approver['state'] ?? 'unknown';

          }

          // Check if target email exists
          bool found = false;
          for (var approver in decoded) {
            final approverEmail = (approver['email'] ?? '').toString().toLowerCase().trim();

            if (approverEmail == target) {
              found = true;
              matchedEmail++;
              break;
            }
          }

          if (found) {
            try {
              final model = ServicesHistoryModel.fromJson(data, doc.id);
              servicesList.add(model);
            } catch (e, stackTrace) {
            }
          }

        } catch (e, stackTrace) {
        }
      }

    } catch (e, stackTrace) {
    }

    return servicesList;
  }
  @override
  Future<Map<String, Map<String, dynamic>>> getServiceProviderPerDoc() async {
    final Map<String, int> providerGlobalCount = {};
    final Map<String, Map<String, dynamic>> finalProviders = {};

    final allDocs = await firestore
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("Email_Requester",arrayContains: employeeEntity.email)

        .get();

    final docs = allDocs.docs;

    for (var doc in docs) {
      // ✅ UPDATED: Handle list format for providerServices
      final providerData = doc.data()['Provider_Services'];
      List<dynamic>? providerList;

      if (providerData is List && providerData.isNotEmpty) {
        // Get the last entry from history
        final lastEntry = providerData.last;
        if (lastEntry is String) {
          try {
            providerList = jsonDecode(lastEntry) as List;
          } catch (e) {
          }
        }
      }

      if (providerList != null) {
        final Set<String> uniqueEmailsInDoc = {};
        for (var provider in providerList) {
          final email = provider['email'];
          if (email != null) {
            uniqueEmailsInDoc.add(email);
          }
        }
        for (var email in uniqueEmailsInDoc) {
          providerGlobalCount[email] = (providerGlobalCount[email] ?? 0) + 1;
        }
      }
    }

    for (var doc in docs) {
      final docId = doc.id;
      final providerData = doc.data()['Provider_Services'];
      List<dynamic>? providerList;

      if (providerData is List && providerData.isNotEmpty) {
        final lastEntry = providerData.last;
        if (lastEntry is String) {
          try {
            providerList = jsonDecode(lastEntry) as List;
          } catch (e) {
          }
        }
      }

      if (providerList != null && providerList.isNotEmpty) {
        Map<String, dynamic>? selectedProvider;
        int minAppearances = 999999;

        for (var provider in providerList) {
          final email = provider['email'];
          if (email != null) {
            final count = providerGlobalCount[email] ?? 0;
            if (count < minAppearances) {
              selectedProvider = provider;
              minAppearances = count;
            }
          }
        }

        if (selectedProvider != null) {
          finalProviders[docId] = selectedProvider;
        }
      }
    }

    return finalProviders;
  }

  @override
  Future<void> updateApprovalState({
    required String docID,
    required String email,
    required String newState,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final String tenantRoot = getBaseUrl(FirestoreCollections.requestServices);
    final String target = email.toLowerCase().trim();

    String? _keyEq(Map<String, dynamic> m, String wantLower) {
      for (final k in m.keys) {
        if (k.toLowerCase() == wantLower) return k;
      }
      return null;
    }

    // ✅ FIXED: Query the flat collection directly
    final docPath = '$tenantRoot/$docID';

    final docRef = firestore.doc(docPath);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      throw Exception('Request "$docID" not found at $docPath');
    }

    final data = docSnapshot.data() as Map<String, dynamic>;

    final cycleKey = _keyEq(data, 'Approval_Cycle') ?? _keyEq(data, 'Approval_Cycle');

    String updatePath;
    List<dynamic> approvalList;

    if (cycleKey != null) {
      final cycleNode = data[cycleKey];
      // Handle list format
      if (cycleNode is List && cycleNode.isNotEmpty) {
        final lastEntry = cycleNode.last;
        if (lastEntry is String) {
          try {
            approvalList = List<Map<String, dynamic>>.from(jsonDecode(lastEntry) as List);
            updatePath = cycleKey;
          } catch (e) {
            throw Exception('Failed to decode approval cycle: $e');
          }
        } else {
          approvalList = List<Map<String, dynamic>>.from(cycleNode);
          updatePath = cycleKey;
        }
      } else {
        throw Exception('Unsupported shape for "$cycleKey".');
      }
    } else if (data.containsKey('Approval_Cycle.value')) {
      final v = data['Approval_Cycle.value'];
      if (v is List) {
        approvalList = List<Map<String, dynamic>>.from(v);
        updatePath = 'Approval_Cycle.value';
      } else {
        throw Exception('Unsupported shape for "Approval_Cycle.value".');
      }
    } else {
      throw Exception('No approval cycle field found.');
    }

    final idx = approvalList.indexWhere((item) {
      if (item is Map) {
        final em = (item['email'] ?? '').toString().toLowerCase().trim();
        return em == target;
      }
      return false;
    });

    if (idx == -1) {
      throw Exception('Target email "$email" not found in approval list.');
    }

    (approvalList[idx] as Map<String, dynamic>)['state'] = newState;

    // Use FieldValue.arrayUnion to add new entry to history
    await docRef.update({
      updatePath: FieldValue.arrayUnion([jsonEncode(approvalList)]),
      'timestamps': FieldValue.arrayUnion([DateTime.now().millisecondsSinceEpoch]),
    });

  }

  @override
  Future<void> addRequestedService({
    required String docId,
    required RequestedServices requestModel,
    required String uidUser
  }) async {
    try {
      // Verify the parent document exists and belongs to the user
      final parentDocRef = firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .doc(docId);

      final parentDoc = await parentDocRef.get();

      if (!parentDoc.exists || parentDoc.data()?['Email_Requester'] != employeeEntity.email) {
        throw Exception("Unauthorized: Cannot add service to another user's request");
      }

      // Add the requested service
      await parentDocRef
          .collection(FirestoreCollections.requestServices)
          .add({
        "uidUser": uidUser,
        "Email_Requester": employeeEntity.email,
        ...requestModel.toJson(),
      });
    } catch (e) {
      throw Exception("Failed to add requested service: $e");
    }
  }

  @override
  Future<List<RequestedServices>> getRequestedServices({
    required String docId,
  }) async
  {
    try {
      final querySnapshot = await firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .doc(docId)
          .collection(FirestoreCollections.requestServices)
          .where("Email_Requester", arrayContains: employeeEntity.email)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return RequestedServices.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch requested services: $e");
    }
  }

  @override
  Future<StateStatisticsModel> fetchStateStatistics(String parentDocId) async {
    int approved = 0;
    int cancel = 0;
    int pending = 0;
    int rejected = 0;
    int inProgress = 0;
    int branchSla = 0;
    int done = 0;

    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("Email_Requester",arrayContains: employeeEntity.email)
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();

      // ✅ UPDATED: Handle list format for state
      String? outerState;
      if (data['state'] is List && (data['state'] as List).isNotEmpty) {
        outerState = (data['state'] as List).last.toString().toLowerCase();
      } else if (data['state'] is String) {
        outerState = data['state'].toString().toLowerCase();
      }

      // ✅ UPDATED: Handle list format for approvalCycle
      List<dynamic> approvalCycleList = [];
      if (data['approvalCycle'] is List && (data['approvalCycle'] as List).isNotEmpty) {
        final lastEntry = (data['approvalCycle'] as List).last;
        if (lastEntry is String) {
          try {
            approvalCycleList = jsonDecode(lastEntry) as List;
          } catch (e) {
          }
        }
      }

      bool counted = false;

      switch (outerState) {
        case 'inprogress':
          inProgress++;
          counted = true;
          break;
        case 'approved':
          approved++;
          counted = true;
          break;
        case 'done':
          done++;
          counted = true;
          break;
        case 'cancel':
          cancel++;
          counted = true;
          break;
        case 'branchsla':
          branchSla++;
          counted = true;
          break;
      }

      if (!counted && approvalCycleList.isNotEmpty) {
        for (var approver in approvalCycleList) {
          final innerState = approver['state']?.toString().toLowerCase();
          switch (innerState) {
            case 'approved':
              approved++;
              counted = true;
              break;
            case 'rejected':
              rejected++;
              counted = true;
              break;
            case 'pending':
              pending++;
              counted = true;
              break;
          }
          if (counted) break;
        }
      }

      if (data['branchSla'] == true) {
        branchSla++;
      }
    }

    return StateStatisticsModel(
      approvedCount: approved,
      cancelCount: cancel,
      pendingCount: pending,
      rejectedCount: rejected,
      inProgressCount: inProgress,
      branchSlaCount: branchSla,
      doneCount: done,
    );
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final controller = EmployeeEntityController();

  @override
  Future<List<ServicesHistoryModel>> getFirebaseServices() async {
    final snapshot = await _firestore
        .collection(getBaseUrl(FirestoreCollections.createServices))
        .where("Email_Requester",arrayContains: employeeEntity.email)

        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return ServicesHistoryModel.fromJson(data, doc.id);
    }).toList();
  }

  @override
  Future<List<ServicesHistoryModel>> getLocalDrafts() async {
    return await SharedPrefsServiceMaster.loadDrafts();
  }

  @override
  Future<Map<String, int>> getDoneServicesCount() async {
    final snapshot = await _firestore
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("state", isEqualTo: "done")
        .get();

    Map<String, int> counts = {};
    for (var doc in snapshot.docs) {
      final serviceId = doc["serviceId"];
      if (serviceId != null) {
        counts[serviceId] = (counts[serviceId] ?? 0) + 1;
      }
    }
    return counts;
  }

  @override
  Future<Map<String, Map<String, dynamic>>> getSelectedProviders(
      List<ServicesHistoryModel> services) async {
    Map<String, Map<String, dynamic>> result = {};
    for (var service in services) {
      // ✅ UPDATED: Use current getter
      final serviceId = service.currentId;
      if (serviceId.isNotEmpty) {
        final provider = await selectServiceProvider(serviceId);
        if (provider != null) {
          result[serviceId] = provider;
        }
      }
    }
    return result;
  }

  @override
  Future<bool> checkDuplicateServiceName(String name) async {
    final snapshot = await _firestore
        .collection(getBaseUrl(FirestoreCollections.createServices))
        .where("Email_Requester",arrayContains: employeeEntity.email)

        .get();

    return snapshot.docs.any((doc) {
      final data = doc.data();
      // ✅ UPDATED: Handle list format
      final nameData = data['Service_Name_English'];
      if (nameData is List && nameData.isNotEmpty) {
        return nameData.last.toString().toLowerCase() == name.toLowerCase();
      } else if (nameData is String) {
        return nameData.toLowerCase() == name.toLowerCase();
      }
      return false;
    });
  }

  @override
  Future<void> saveServiceToPrefs(ServicesHistoryModel model) async {
    // ✅ UPDATED: Use current getters
    await SharedPrefsHelper.setString(
        'service_name_en', model.currentServiceNameEnglish);
    await SharedPrefsHelper.setString(
        'service_name_ar', model.currentServiceNameArabic);
    await SharedPrefsHelper.setString(
        'service_description_en', model.currentServiceDescriptionEnglish);
    await SharedPrefsHelper.setString(
        'service_description_ar', model.currentServiceDescriptionArabic);
    await SharedPrefsHelper.setString(
        'duration_value', model.currentDurationOfServices);
    await SharedPrefsHelper.setString(
        'duration_unit', model.currentSelectedDurationUnit);
    await SharedPrefsEmployeeHelper.saveSelectedEmployees(
        model.currentProviderServices);
  }

  @override
  Future<void> loadServiceToFormControllers(ServicesHistoryModel model) async {
    await saveServiceToPrefs(model);
  }

  @override
  Future<void> updateServiceStatus(String docId, bool isActive) async {
    try {
      // Query to find the document
      final querySnapshot = await _firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .where("Email_Requester", arrayContains: employeeEntity.email)
          .get();

      // Find the specific document by docId
      final doc = querySnapshot.docs.firstWhere(
            (doc) => doc.id == docId,
        orElse: () => throw Exception("Document not found"),
      );

      // Update the found document
      await _firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .doc(doc.id)
          .update({
        "status": FieldValue.arrayUnion([isActive ? "active" : "inactive"]),
        "timestamps": FieldValue.arrayUnion([DateTime.now().millisecondsSinceEpoch]),
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> getServiceStatus(String docId) async {
    try {
      // Query all documents where the emailRequester array contains this user's email
      final querySnapshot = await _firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .where("Email_Requester", arrayContains: employeeEntity.email)
          .get();

      // Find the specific document by docId
      final doc = querySnapshot.docs.firstWhere(
            (doc) => doc.id == docId,
        orElse: () => throw Exception("Document not found"),
      );

      if (doc.exists && doc.data() != null) {
        final statusData = doc.data()["status"];
        if (statusData is List && statusData.isNotEmpty) {
          return statusData.last as String?;
        } else if (statusData is String) {
          return statusData;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // @override
  // Future<List<EmployeeEntityPro>> getAllEmployees() async {
  //   final snapshot = await _firestore
  //       .collection(getBaseUrl('Employees'))
  //       .get();
  //
  //   final models = snapshot.docs.map((doc) {
  //     final data = doc.data();
  //     data['id'] = doc.id;
  //     return NewEmployeeModel.fromMap(data);
  //   }).toList();
  //
  //   return controller.fromModelList(models);
  // }

  @override
  Future<void> saveToSharedPrefs({
    required String slaOne,
    required String slaTwo,
    required bool notifyRequesterChecked,
    required bool notifyProviderChecked,
    required bool notifyManagerChecked,
    required bool notifyRequesterSwitch0,
    required bool notifyManagerSwitch1,
    required Map<String, Map<int, bool>> notificationSwitches,
    required List<String> extraSlaValues,
    required List<String> extraSlaTwoValues,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('sla_one', slaOne);
    await prefs.setString('sla_two', slaTwo);
    await prefs.setBool('Notify Service Requester_checked', notifyRequesterChecked);
    await prefs.setBool('Notify Service Provider_checked', notifyProviderChecked);
    await prefs.setBool('Notify Provider Manager_checked', notifyManagerChecked);
    await prefs.setBool('Notify Service Requester_switch_0', notifyRequesterSwitch0);
    await prefs.setBool('Notify Provider Manager_switch_1', notifyManagerSwitch1);

    for (int i = 0; i < extraSlaValues.length; i++) {
      await prefs.setString('extra_sla_$i', extraSlaValues[i]);
    }
    await prefs.setInt('extra_sla_count', extraSlaValues.length);

    for (int i = 0; i < extraSlaTwoValues.length; i++) {
      await prefs.setString('extra_sla_two_$i', extraSlaTwoValues[i]);
    }
    await prefs.setInt('extra_sla_two_count', extraSlaTwoValues.length);

    for (final entry in notificationSwitches.entries) {
      final title = entry.key;
      final switchMap = entry.value;
      for (final switchEntry in switchMap.entries) {
        await prefs.setBool('${title}_switch_${switchEntry.key}', switchEntry.value);
      }
    }
  }

  @override
  Future<SlaDataModel> loadFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final slaOne = prefs.getString('sla_one') ?? '';
    final slaTwo = prefs.getString('sla_two') ?? '';
    final notifyRequesterChecked = prefs.getBool('Notify Service Requester_checked') ?? true;
    final notifyProviderChecked = prefs.getBool('Notify Service Provider_checked') ?? true;
    final notifyManagerChecked = prefs.getBool('Notify Provider Manager_checked') ?? true;
    final notifyRequesterSwitch0 = prefs.getBool('Notify Service Requester_switch_0') ?? false;
    final notifyManagerSwitch1 = prefs.getBool('Notify Provider Manager_switch_1') ?? false;

    final List<String> extraSlaValues = [];
    final extraCount = prefs.getInt('extra_sla_count') ?? 0;
    for (int i = 0; i < extraCount; i++) {
      extraSlaValues.add(prefs.getString('extra_sla_$i') ?? '');
    }

    final List<String> extraSlaTwoValues = [];
    final extraTwoCount = prefs.getInt('extra_sla_two_count') ?? 0;
    for (int i = 0; i < extraTwoCount; i++) {
      extraSlaTwoValues.add(prefs.getString('extra_sla_two_$i') ?? '');
    }

    final titles = [
      'Notify Service Requester',
      'Notify Service Provider',
      'Notify Provider Manager',
    ];

    Map<String, Map<int, bool>> notificationSwitches = {};
    for (final title in titles) {
      Map<int, bool> map = {};
      for (int i = 0; i < 5; i++) {
        final value = prefs.getBool('${title}_switch_$i');
        if (value != null) {
          map[i] = value;
        }
      }
      notificationSwitches[title] = map;
    }

    return SlaDataModel(
      slaOne: slaOne,
      slaTwo: slaTwo,
      notifyRequesterChecked: notifyRequesterChecked,
      notifyProviderChecked: notifyProviderChecked,
      notifyManagerChecked: notifyManagerChecked,
      notifyRequesterSwitch0: notifyRequesterSwitch0,
      notifyManagerSwitch1: notifyManagerSwitch1,
      extraSlaValues: extraSlaValues,
      extraSlaTwoValues: extraSlaTwoValues,
      notificationSwitches: notificationSwitches,
    );
  }

  @override
  Future<void> saveDraft(ServicesHistoryModel model) async {
    await SharedPrefsServiceMaster.saveDraft(model);
  }

  @override
  Future<void> updateDraft(ServicesHistoryModel oldModel, ServicesHistoryModel newModel) async {
    await SharedPrefsServiceMaster.updateDraft(oldModel, newModel);
  }

  @override
  Future<void> removeDraftById(String id) async {
    await SharedPrefsServiceMaster.removeDraftById(id);
  }

  @override
  Future<void> saveService(String docId, ServicesHistoryModel model) async {
    final docRef = _firestore
        .collection(getBaseUrl(FirestoreCollections.createServices))
        .doc(docId);

    // ✅ Use set with merge to create or update
    await docRef.set(
      model.toJsonForCreate(),
      SetOptions(merge: true),  // ✅ This will merge with existing data
    );
  }

  @override
  Future<void> editService(String docId, ServicesHistoryModel updatedModel) async {
    final docRef = _firestore
        .collection(getBaseUrl(FirestoreCollections.createServices))
        .doc(docId);

    // ✅ Fetch existing document first
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      throw Exception("Service not found: $docId");
    }

    // ✅ Parse existing model
    final existingModel = ServicesHistoryModel.fromJson(
      docSnapshot.data()!,
      docId,
    );

    // ✅ Create updated model using copyWith to preserve history
    final newModel = existingModel.copyWith(
      serviceNameEnglish: updatedModel.currentServiceNameEnglish,
      serviceNameArabic: updatedModel.currentServiceNameArabic,
      serviceDescriptionEnglish: updatedModel.currentServiceDescriptionEnglish,
      serviceDescriptionArabic: updatedModel.currentServiceDescriptionArabic,
      durationOfServices: updatedModel.currentDurationOfServices,
      selectedDurationUnit: updatedModel.currentSelectedDurationUnit,
      providerServices: updatedModel.currentProviderServices,
      approvalCycle: updatedModel.currentApprovalCycle,
      selectDepartment: updatedModel.currentSelectDepartment,
      limitAvailability: updatedModel.currentLimitAvailability,
      requireApproval: updatedModel.currentRequireApproval,
      slaOneControllerEnglish: updatedModel.currentSlaOneControllerEnglish,
      slaTwoControllerEnglish: updatedModel.currentSlaTwoControllerEnglish,
      notifyRequesterChecked: updatedModel.currentNotifyRequesterChecked,
      notifyProviderChecked: updatedModel.currentNotifyProviderChecked,
      notifyManagerChecked: updatedModel.currentNotifyManagerChecked,
      // Add other fields as needed
    );

    // ✅ Save with full data (not just create data)
    await docRef.set(
      newModel.toJson(),  // ✅ Use full toJson() to preserve all fields
      SetOptions(merge: false),  // ✅ Replace entire document
    );
  }

// ==========================================
// ✅ COMPLETE FIXED updateService METHOD
// ==========================================
// Replace your ENTIRE updateService method with this code

// ==========================================
// ✅ COMPLETE FIXED updateService METHOD
// ==========================================
// Replace your ENTIRE updateService method with this code

  @override
  Future<void> updateService(String docId, ServicesHistoryModel model) async {

    // ✅ STEP 1: Fetch existing document from CreateServices
    final createServicesRef = _firestore
        .collection(getBaseUrl(FirestoreCollections.createServices))
        .doc(docId);

    final docSnapshot = await createServicesRef.get();

    if (!docSnapshot.exists) {
      throw Exception("Service document not found: $docId");
    }

    // ✅ STEP 2: Parse existing model to preserve ALL fields
    final existingModel = ServicesHistoryModel.fromJson(
      docSnapshot.data()!,
      docId,
    );

    // ✅ STEP 3: Create updated model using copyWith (preserves history)
    final newModel = existingModel.copyWith(
      serviceNameEnglish: model.currentServiceNameEnglish,
      serviceNameArabic: model.currentServiceNameArabic,
      serviceDescriptionEnglish: model.currentServiceDescriptionEnglish,
      serviceDescriptionArabic: model.currentServiceDescriptionArabic,
      durationOfServices: model.currentDurationOfServices,
      selectedDurationUnit: model.currentSelectedDurationUnit,
      providerServices: model.currentProviderServices,
      approvalCycle: model.currentApprovalCycle,
      selectDepartment: model.currentSelectDepartment,
      limitAvailability: model.currentLimitAvailability,
      requireApproval: model.currentRequireApproval,
      slaOneControllerEnglish: model.currentSlaOneControllerEnglish,
      slaTwoControllerEnglish: model.currentSlaTwoControllerEnglish,
      // slaOneControllerArabic: model.currentSlaOneControllerArabic,
      // slaTwoControllerArabic: model.currentSlaTwoControllerArabic,
      notifyRequesterChecked: model.currentNotifyRequesterChecked,
      notifyProviderChecked: model.currentNotifyProviderChecked,
      notifyManagerChecked: model.currentNotifyManagerChecked,
      notifyRequesterSwitch0: model.currentNotifyRequesterSwitch0,
      notifyManagerSwitch1: model.currentNotifyManagerSwitch1,
      // notificationSwitches: model.currentNotificationSwitches,
      // extraSlaList: model.currentExtraSlaList,
      // extraSlaTwoList: model.currentExtraSlaTwoList,
    );

    // ✅ STEP 4: Convert to JSON using FULL toJson() (NOT toJsonForCreate!)
    final jsonData = newModel.toJson();

    // ✅ STEP 5: Update CreateServices
    await createServicesRef.set(
      jsonData,
      SetOptions(merge: false),  // Complete replacement
    );

    // ✅ STEP 6: Update myCreateRequests (allServices)
    final allServicesRef = _firestore
        .collection(getBaseUrl(FirestoreCollections.createServices))  // This is "myCreateRequests"
        .doc(docId);

    try {
      await allServicesRef.set(
        jsonData,
        SetOptions(merge: true),  // Merge in case doc doesn't exist
      );
    } catch (e) {
    }

  }
  @override
  Future<void> saveSlaToPrefs({
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
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('sla_one', slaOne);
    await prefs.setString('sla_two', slaTwo);

    await prefs.setBool('Notify Service Requester_checked', notifyRequesterChecked);
    await prefs.setBool('Notify Service Provider_checked', notifyProviderChecked);
    await prefs.setBool('Notify Provider Manager_checked', notifyManagerChecked);

    await prefs.setBool('Notify Service Requester_switch_0', notifyRequesterSwitch0);
    await prefs.setBool('Notify Provider Manager_switch_1', notifyManagerSwitch1);

    for (int i = 0; i < extraSlaList.length; i++) {
      await prefs.setString('extra_sla_$i', extraSlaList[i]);
    }
    await prefs.setInt('extra_sla_count', extraSlaList.length);

    for (int i = 0; i < extraSlaTwoList.length; i++) {
      await prefs.setString('extra_sla_two_$i', extraSlaTwoList[i]);
    }
    await prefs.setInt('extra_sla_two_count', extraSlaTwoList.length);

    for (final entry in notificationSwitches.entries) {
      final title = entry.key;
      final switchMap = entry.value;
      for (final switchEntry in switchMap.entries) {
        final index = switchEntry.key;
        final value = switchEntry.value;
        await prefs.setBool('${title}_switch_$index', value);
      }
    }
  }

  @override
  Future<List<ServicesHistoryModel>> getFilteredServices(
      BuildContext context, String userEmail, String userDepartment) async {
    final cubitServices = ServicesManagerCubit.get(context).services;
    return cubitServices.where((service) {
      // ✅ UPDATED: Use current getters
      final isLimited = service.currentLimitAvailability;
      final serviceDept = service.currentDepartmentRequester.toLowerCase().trim();
      final userDept = userDepartment.toLowerCase().trim();
      final sameDepartment = serviceDept == userDept;
      return isLimited ? sameDepartment : true;
    }).toList();
  }

  @override
  Future<Map<String, int>> getDepartmentCounts(
      BuildContext context, String userDepartment) async {
    final model = ServicesManagerCubit.get(context).services;

    final departments = [
      "Executive",
      "Customer Support",
      "Operations",
      "Finance",
      "Information Technology",
      "Human Resources",
      "Marketing",
      "Sales",
      "Data Management",
      "Compliance & Legal",
      "Software"
    ];

    final departmentCounts = {for (var dept in departments) dept: 0};

    for (var service in model) {
      // ✅ UPDATED: Use current getters
      final isLimited = service.currentLimitAvailability;
      final serviceDept = service.currentDepartmentRequester.toLowerCase().trim();
      final userDept = userDepartment.toLowerCase().trim();
      final sameDepartment = serviceDept == userDept;

      if (!isLimited || sameDepartment) {
        final dept = service.currentDepartmentRequester;
        if (departmentCounts.containsKey(dept)) {
          departmentCounts[dept] = departmentCounts[dept]! + 1;
        }
      }
    }
    return departmentCounts;
  }

  @override
  Future<Map<String, dynamic>?> selectServiceProvider(String serviceId) async {
    final doc = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .doc(serviceId)
        .get();
    if (doc.exists && doc.data() != null) {
      final providerData = doc.data()!['Provider_Services'];

      // ✅ UPDATED: Handle list format
      if (providerData is List && providerData.isNotEmpty) {
        final lastEntry = providerData.last;
        if (lastEntry is String) {
          try {
            final decoded = jsonDecode(lastEntry) as List;
            if (decoded.isNotEmpty) {
              return decoded[0] as Map<String, dynamic>;
            }
          } catch (e) {
          }
        }
      }
    }

    return null;
  }
}
