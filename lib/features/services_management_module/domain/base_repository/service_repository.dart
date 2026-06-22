import 'package:flutter/cupertino.dart';

import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/features/services_management_module/data/models/requested_model.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/data/models/state_model.dart';

class SlaDataModel {
  final String slaOne;
  final String slaTwo;

  final bool notifyRequesterChecked;
  final bool notifyProviderChecked;
  final bool notifyManagerChecked;

  final bool notifyRequesterSwitch0;
  final bool notifyManagerSwitch1;

  final Map<String, Map<int, bool>> notificationSwitches;

  final List<String> extraSlaValues;
  final List<String> extraSlaTwoValues;

  const SlaDataModel({
    required this.slaOne,
    required this.slaTwo,
    required this.notifyRequesterChecked,
    required this.notifyProviderChecked,
    required this.notifyManagerChecked,
    required this.notifyRequesterSwitch0,
    required this.notifyManagerSwitch1,
    required this.notificationSwitches,
    required this.extraSlaValues,
    required this.extraSlaTwoValues,
  });
}

abstract class CreateServicesRepository {
  // ✅ UPDATED: All ServicesModel changed to ServicesHistoryModel
 // Future<void> uploadServices(ServicesHistoryModel services, String departmentId);
  Future<List<ServicesHistoryModel>> getAllServices();
  Future<List<ServicesHistoryModel>> getAllRequestServices();
  Future<void> deleteService(String innerDocId);
  Future<ServicesHistoryModel?> getServiceById(String departmentId, String serviceId);
  Future<void> uploadRequest(ServicesHistoryModel services, String departmentId);
  Future<List<ServicesHistoryModel>> getMyRequestServices();
  Future<void> editService(String docId, ServicesHistoryModel updatedModel);
  Future<void> deleteMyRequest(String departmentId, String innerDocId);
  Future<List<ServicesHistoryModel>> getApprovalServices(String departmentId);
  Future<void> updateApprovalState({
    required String docID,
    required String email,
    required String newState,
  });
  Future<Map<String, Map<String, dynamic>>> getServiceProviderPerDoc();
  Future<void> addRequestedService({
    required String docId,
    required RequestedServices requestModel,
    required String uidUser,
  });
  Future<List<RequestedServices>> getRequestedServices({required String docId});
  Future<StateStatisticsModel> fetchStateStatistics(String parentDocId);

  // Firebase services
  Future<List<ServicesHistoryModel>> getFirebaseServices();

  // Local drafts from SharedPreferences
  Future<List<ServicesHistoryModel>> getLocalDrafts();

  // Count done services per status
  Future<Map<String, int>> getDoneServicesCount();

  // Extract providers' info from services
  Future<Map<String, Map<String, dynamic>>> getSelectedProviders(List<ServicesHistoryModel> services);

  // Check if service name already exists
  Future<bool> checkDuplicateServiceName(String name);

  // Save service form data to SharedPreferences (as draft)
  Future<void> saveServiceToPrefs(ServicesHistoryModel model);

  // Load service model into SharedPrefs (for editing)
  Future<void> loadServiceToFormControllers(ServicesHistoryModel model);

  // Update service status (active/inactive)
  Future<void> updateServiceStatus(String docId, bool isActive);

  // Fetch current service status
  Future<String?> getServiceStatus(String docId);

  // // Fetch all employees
  // Future<List<EmployeeEntityPro>> getAllEmployees();

  // Load SLA and notification values from SharedPreferences
  Future<SlaDataModel> loadFromSharedPrefs();

  // Save draft
  Future<void> saveDraft(ServicesHistoryModel model);

  // Update draft if editing existing one
  Future<void> updateDraft(ServicesHistoryModel oldModel, ServicesHistoryModel newModel);

  // Remove draft after submission
  Future<void> removeDraftById(String id);

  // Submit service to Firestore
  Future<void> saveService(String docId, ServicesHistoryModel model);

  // Update existing submitted service
  Future<void> updateService(String docId, ServicesHistoryModel model);

  // Save SLA configuration to SharedPreferences
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
  });

  // Get filtered services for request view
  Future<List<ServicesHistoryModel>> getFilteredServices(
      BuildContext context,
      String userEmail,
      String userDepartment,
      );

  // Get department counts
  Future<Map<String, int>> getDepartmentCounts(
      BuildContext context,
      String userDepartment,
      );

  // Select service provider
  Future<Map<String, dynamic>?> selectServiceProvider(String serviceId);
}
