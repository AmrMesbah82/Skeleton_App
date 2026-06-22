/// ******************* FILE INFO *******************
/// File Name: dashboard_master_cubit.dart
/// Description: Business logic for DashBoard Master (Mobile + Admin)
/// Created by: Amr Mesbah
/// *************************************************

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/presentation/ui/pages/dashboard_view_data/chart_orientation_enum.dart';
import 'package:demo_app/features/home/presentation/ui/pages/dashboard_view_data/chart_registry.dart';
import 'package:demo_app/features/home/presentation/ui/pages/dashboard_view_data/chart_setting_firebase_service.dart';

import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_helper_function.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/create_services_helper.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/controller/dashboard_master_state.dart';

class DashboardMasterCubit extends Cubit<DashboardMasterState> {
  DashboardMasterCubit() : super(DashboardMasterState.initial());

  // ─── Public API ────────────────────────────────────────────────────────────

  Future<void> bootstrap({
    required bool isAdmin,
    required String? adminSelectedDepartment,
  }) async {
    emit(state.copyWith(bootstrapping: true));
    _initializeDepartmentData();

    try {
      final departmentController = Get.find<MainCoreDepartmentController>();
      await departmentController.getAllDepartments();

      await Future.wait([
        loadServiceStatusData(isAdmin: isAdmin, adminSelectedDepartment: adminSelectedDepartment),
        fetchMonthlyServiceCounts(isAdmin: isAdmin, adminSelectedDepartment: adminSelectedDepartment),
        fetchServiceUsageCounts(isAdmin: isAdmin, adminSelectedDepartment: adminSelectedDepartment),
        fetchDepartmentCounts(isAdmin: isAdmin, adminSelectedDepartment: adminSelectedDepartment),
        loadFilteredItems(isAdmin: isAdmin, adminSelectedDepartment: adminSelectedDepartment),
        fetchMonthlyRejectedCounts(isAdmin: isAdmin, adminSelectedDepartment: adminSelectedDepartment),
        fetchMonthlyCanceledCounts(isAdmin: isAdmin, adminSelectedDepartment: adminSelectedDepartment),
        _loadChartSettings(),
      ]);
    } catch (e, st) {
    } finally {
      emit(state.copyWith(bootstrapping: false, bootstrapped: true));
    }
  }

  void toggleTab(bool showRequested) =>
      emit(state.copyWith(showRequestedServices: showRequested));

  Future<void> toggleChartMode({
    required bool showCount,
    required bool isAdmin,
    required String? adminSelectedDepartment,
  }) async {
    // ✅ FIXED: Save the toggle choice in state BEFORE setting isLoading
    // This way isHoursMode survives the widget rebuild during loading
    emit(state.copyWith(
      isHoursMode: !showCount, // showCount=true means NOT hours
      isLoading: true,
    ));
    if (showCount) {
      await fetchMonthlyServiceCounts(
        isAdmin: isAdmin,
        adminSelectedDepartment: adminSelectedDepartment,
      );
    } else {
      await fetchMonthlyDurationInHours(
        isAdmin: isAdmin,
        adminSelectedDepartment: adminSelectedDepartment,
      );
    }
  }

  Future<void> reloadChartSettings() => _loadChartSettings();

  void applyFilters({
    String? department,
    String? status,
    DateTime? date,
    bool clearDepartment = false,
    bool clearStatus = false,
    bool clearDate = false,
    String? searchQuery,
  }) {
    final next = state.copyWith(
      activeDepartment: department,
      activeStatus: status,
      activeDate: date,
      clearActiveDepartment: clearDepartment,
      clearActiveStatus: clearStatus,
      clearActiveDate: clearDate,
      searchQuery: searchQuery,
    );
    emit(next.copyWith(displayedItems: _computeDisplayedItems(next)));
  }

  void onSearchChanged(String query) {
    final next = state.copyWith(searchQuery: query);
    emit(next.copyWith(displayedItems: _computeDisplayedItems(next)));
  }

  ChartOrientation getChartOrientation(String chartId) {
    if (state.chartOrientations.containsKey(chartId)) {
      return state.chartOrientations[chartId]!;
    }
    return ChartRegistry.getServicesChartById(chartId)?.defaultOrientation ??
        ChartOrientation.vertical;
  }

  double getPercentage(String key) {
    final total = state.statusCounts.values.fold<int>(0, (a, b) => a + b);
    final value = state.statusCounts[key] ?? 0;
    return total == 0 ? 0.0 : (value / total) * 100.0;
  }

  // ─── Provider Stats ────────────────────────────────────────────────────────

  List<String> getUniqueProviderNames(List<Map<String, dynamic>> items) {
    final Set<String> names = {};
    for (final item in items) {
      final provider = item['provider']?.toString() ?? '';
      if (provider.isNotEmpty && provider != 'N/A') names.add(provider);
    }
    return names.toList();
  }

  Map<String, dynamic> calculateProviderStats(String providerName) {
    int done = 0;
    int breached = 0;
    double totalMinutes = 0;
    String? name;
    String? department;
    String? jobTitle;

    for (final item in state.filteredItems) {
      if ((item['provider'] ?? '') != providerName) continue;

      final model = item['model'] as ServicesHistoryModel;
      final stateField = model.currentState.toLowerCase();

      if (stateField == 'done') done++;
      if (stateField == 'breached sla' || stateField == 'branchsla') breached++;

      if (stateField == 'done') {
        final val = double.tryParse(model.currentDurationOfServices) ?? 0;
        final unit = model.currentSelectedDurationUnit.toLowerCase();
        totalMinutes += switch (unit) {
          'minutes' => val,
          'hours'   => val * 60,
          'days'    => val * 1440,
          'weeks'   => val * 10080,
          _         => 0,
        };
      }

      name ??= item['provider'];
      department ??= item['department'];
      jobTitle ??= model.currentJobTitleRequester;
    }

    return {
      'name': name ?? 'N/A',
      'department': department ?? 'N/A',
      'jobTitle': jobTitle ?? 'N/A',
      'done': done,
      'breached': breached,
      'hours': done > 0 ? totalMinutes / 60 : 0.0,
    };
  }

  // ─── Initialization ────────────────────────────────────────────────────────

  void _initializeDepartmentData() {
    try {
      final dc = Get.find<MainCoreDepartmentController>();
      final en = dc.departmentsEnglishName;
      final ar = dc.departmentsArabicName;

      final Map<String, String> enToAr = {};
      final Map<String, Color> colors = {};

      const colorList = [
        Color(0xffE5C100), Color(0xffe3d38c), Color(0xffFFDE59),
        Color(0xffa18a2d), Color(0xffE5B800), Color(0xff807b69),
        Color(0xff8D8D8D), Color(0xffCACACA), Color(0xff6b5650),
        Color(0xff795548), Color(0xffFFCC00),
      ];

      for (int i = 0; i < en.length; i++) {
        if (i < ar.length) enToAr[en[i]] = ar[i];
        colors[en[i]] = colorList[i % colorList.length];
      }

      emit(state.copyWith(
        enToArDepartments: enToAr,
        departmentColors: colors,
        knownDepartments: en,
        knownDepartmentsArabic: ar,
      ));
    } catch (e) {
    }
  }

  // ─── Department filter helper ──────────────────────────────────────────────

  String? _getFilterDepartment({
    required bool isAdmin,
    required String? adminSelectedDepartment,
  }) {
    if (isAdmin) {
      if (adminSelectedDepartment == null || adminSelectedDepartment == 'All') return null;
      return adminSelectedDepartment;
    }
    final dc = Get.find<MainCoreDepartmentController>();
    final ec = Get.find<MainCoreEmployeeController>();
    final deptId = ec.employeeEntity?.departmentId;
    if (deptId == null) return null;
    return dc.getDepartmentName(deptId, true);
  }

  // ─── Data Loading ──────────────────────────────────────────────────────────

  Future<void> loadFilteredItems({
    required bool isAdmin,
    required String? adminSelectedDepartment,
    int limit = 300,
  }) async {
    final filterDepartment = _getFilterDepartment(
      isAdmin: isAdmin,
      adminSelectedDepartment: adminSelectedDepartment,
    );

    final firestore = FirebaseFirestore.instance;
    final employeeController = Get.find<MainCoreEmployeeController>();

    final snapshot = await firestore
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .orderBy('timestamps', descending: true)
        .limit(limit * 2)
        .get();

    final List<Map<String, dynamic>> results = [];

    for (int i = 0; i < snapshot.docs.length; i++) {
      if (results.length >= limit) break;

      final doc = snapshot.docs[i];
      final data = doc.data();
      final docId = doc.id;

      try {
        // ── Department ───────────────────────────────────────────────────────
        String normalizedDepartment = _normalizeDepartmentValue(data['departmentRequester']);

        // ── Service names ────────────────────────────────────────────────────
        String serviceNameEn = _extractValue(data['Service_Name_English']);
        String serviceNameAr = _extractValue(data['Service_Name_Arabic']);
        String firstNameRequester = _extractValue(data['firstNameRequester']);
        String lastNameRequester = _extractValue(data['lastNameRequester']);
        String firstNameRequesterAr = _extractValue(data['firstNameRequesterArabic']);
        String lastNameRequesterAr = _extractValue(data['lastNameRequesterArabic']);
        String genderRequester = _extractValue(data['genderRequester']);
        String jobTitleRequester = _extractValue(data['jobTitleRequester']);
        String jobTitleRequesterAr = _extractValue(data['jobTitleRequesterArabic']);

        // ── Enrich from CreateServices if needed ─────────────────────────────
        final needsFetch = normalizedDepartment.isEmpty ||
            (serviceNameEn.isEmpty && serviceNameAr.isEmpty) ||
            (firstNameRequester.isEmpty && lastNameRequester.isEmpty) ||
            genderRequester.isEmpty ||
            jobTitleRequester.isEmpty;

        if (needsFetch) {
          final parentServiceId = _extractValue(data['Parent_Service_Id']);
          final emailRequester = _extractValue(data['Email_Requester']);

          if (parentServiceId.isNotEmpty && emailRequester.isNotEmpty) {
            final details = await CreateServicesHelper.getServiceDetailsFromCreateServices(
              parentServiceId: parentServiceId,
              emailRequester: emailRequester,
            );
            if (serviceNameEn.isEmpty) serviceNameEn = details['serviceNameEnglish'] ?? '';
            if (serviceNameAr.isEmpty) serviceNameAr = details['serviceNameArabic'] ?? '';
            if (firstNameRequester.isEmpty) {
              final parts = (details['requesterName'] ?? '').split(' ');
              firstNameRequester = parts.isNotEmpty ? parts.first : '';
              lastNameRequester = parts.length > 1 ? parts.skip(1).join(' ') : '';
            }
            if (firstNameRequesterAr.isEmpty) {
              final partsAr = (details['requesterNameArabic'] ?? '').split(' ');
              firstNameRequesterAr = partsAr.isNotEmpty ? partsAr.first : '';
              lastNameRequesterAr = partsAr.length > 1 ? partsAr.skip(1).join(' ') : '';
            }
            if (jobTitleRequester.isEmpty) jobTitleRequester = details['jobTitle'] ?? '';
            if (jobTitleRequesterAr.isEmpty) jobTitleRequesterAr = details['jobTitleArabic'] ?? '';
            if (genderRequester.isEmpty) genderRequester = details['gender'] ?? '';
            if (normalizedDepartment.isEmpty) normalizedDepartment = details['department'] ?? '';
          }
        }

        // ── Department filter ────────────────────────────────────────────────
        if (filterDepartment != null && normalizedDepartment != filterDepartment) continue;

        // ── Provider resolution ──────────────────────────────────────────────
        final emailRequester = _extractValue(data['Email_Requester']);
        final providerData = _resolveProvider(
          data: data,
          emailRequester: emailRequester,
          employeeController: employeeController,
        );
        final selectedProvider = providerData['map'] as Map<String, dynamic>;
        final providerName = providerData['name'] as String;

        // ── Status + Timestamp ───────────────────────────────────────────────
        final model = ServicesHistoryModel.fromJson(data, docId);
        final status = getFinalStateFromModel(model);
        final requestTimestamp = model.currentTimestamp != null
            ? Timestamp.fromMillisecondsSinceEpoch(model.currentTimestamp!)
            : null;

        results.add({
          'no': results.length + 1,
          'department': normalizedDepartment,
          'serviceName': serviceNameEn,
          'serviceNameArabic': serviceNameAr,
          'gender': genderRequester,
          'requestor': '$firstNameRequester $lastNameRequester'.trim(),
          'requestorArabic': '$firstNameRequesterAr $lastNameRequesterAr'.trim(),
          'requestDate': requestTimestamp,
          'status': status,
          'provider': providerName.isNotEmpty ? providerName : 'N/A',
          'docId': docId,
          'model': model,
          'raw': data,
          'selectedProvider': selectedProvider,
          'jobTitleRequester': jobTitleRequester,
          'jobTitleRequesterArabic': jobTitleRequesterAr,
        });
      } catch (e, st) {
      }
    }

    emit(state.copyWith(
      filteredItems: results,
      displayedItems: results,
    ));
  }

  Future<void> loadServiceStatusData({
    required bool isAdmin,
    required String? adminSelectedDepartment,
  }) async {
    final filterDepartment = _getFilterDepartment(
      isAdmin: isAdmin,
      adminSelectedDepartment: adminSelectedDepartment,
    );

    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    final Map<String, int> counts = {
      'done': 0, 'approved': 0, 'pending': 0, 'inprogress': 0,
      'branchsla': 0, 'rejected': 0, 'cancel': 0,
    };

    for (final doc in snapshot.docs) {
      final data = doc.data();
      String dept = _normalizeDepartmentValue(data['departmentRequester']);
      if (dept.isEmpty) {
        final email = _extractValue(data['Email_Requester']);
        if (email.isNotEmpty) {
          dept = CreateServicesHelper.getRequesterInfo(emailRequester: email)['department'] ?? '';
        }
      }
      if (filterDepartment != null && dept != filterDepartment) continue;

      final model = ServicesHistoryModel.fromJson(data, doc.id);
      final key = getFinalStateFromModel(model).toLowerCase().replaceAll(' ', '');
      if (counts.containsKey(key)) counts[key] = counts[key]! + 1;
    }

    emit(state.copyWith(statusCounts: counts, isLoadingFirst: false));
  }

  Future<void> fetchMonthlyServiceCounts({
    required bool isAdmin,
    required String? adminSelectedDepartment,
  }) async {
    final filterDepartment = _getFilterDepartment(
      isAdmin: isAdmin,
      adminSelectedDepartment: adminSelectedDepartment,
    );

    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    final Map<int, double> counts = {for (int i = 0; i < 12; i++) i: 0};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      String dept = _normalizeDepartmentValue(data['departmentRequester']);
      if (dept.isEmpty) {
        final email = _extractValue(data['Email_Requester']);
        if (email.isNotEmpty) {
          dept = CreateServicesHelper.getRequesterInfo(emailRequester: email)['department'] ?? '';
        }
      }
      if (filterDepartment != null && dept != filterDepartment) continue;

      final model = ServicesHistoryModel.fromJson(data, doc.id);
      if (model.currentTimestamp != null) {
        final month = DateTime.fromMillisecondsSinceEpoch(model.currentTimestamp!).month - 1;
        counts[month] = (counts[month] ?? 0) + 1;
      }
    }

    emit(state.copyWith(monthCounts: counts, isLoading: false));
  }

  Future<void> fetchMonthlyDurationInHours({
    required bool isAdmin,
    required String? adminSelectedDepartment,
  }) async {
    final filterDepartment = _getFilterDepartment(
      isAdmin: isAdmin,
      adminSelectedDepartment: adminSelectedDepartment,
    );

    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    final Map<int, double> hours = {for (int i = 0; i < 12; i++) i: 0};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      try {
        String dept = _normalizeDepartmentValue(data['departmentRequester']);
        if (dept.isEmpty) {
          final email = _extractValue(data['Email_Requester']);
          if (email.isNotEmpty) {
            dept = CreateServicesHelper.getRequesterInfo(emailRequester: email)['department'] ?? '';
          }
        }
        if (filterDepartment != null && dept != filterDepartment) continue;

        final model = ServicesHistoryModel.fromJson(data, doc.id);
        if (model.currentState.toLowerCase().trim() != 'done') continue;

        final val = double.tryParse(model.currentDurationOfServices) ?? 0;
        final unit = model.currentSelectedDurationUnit.toLowerCase();
        if (val <= 0 || unit.isEmpty) continue;

        final h = _toHours(val, unit);
        if (h <= 0) continue;

        final date = model.currentDurationOfServicesTimestamp.toDate();
        hours[date.month - 1] = (hours[date.month - 1] ?? 0) + h;
      } catch (e) {
      }
    }

    emit(state.copyWith(monthHours: hours, isLoading: false));
  }

  Future<void> fetchMonthlyRejectedCounts({
    required bool isAdmin,
    required String? adminSelectedDepartment,
  }) async {
    final filterDepartment = _getFilterDepartment(
      isAdmin: isAdmin,
      adminSelectedDepartment: adminSelectedDepartment,
    );

    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    final Map<int, double> counts = {for (int i = 0; i < 12; i++) i: 0};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      String dept = _normalizeDepartmentValue(data['departmentRequester']);
      if (dept.isEmpty) {
        final email = _extractValue(data['Email_Requester']);
        if (email.isNotEmpty) {
          dept = CreateServicesHelper.getRequesterInfo(emailRequester: email)['department'] ?? '';
        }
      }
      if (filterDepartment != null && dept != filterDepartment) continue;

      final model = ServicesHistoryModel.fromJson(data, doc.id);
      if (getFinalStateFromModel(model).toLowerCase() == 'rejected' &&
          model.currentTimestamp != null) {
        final month = DateTime.fromMillisecondsSinceEpoch(model.currentTimestamp!).month - 1;
        counts[month] = (counts[month] ?? 0) + 1;
      }
    }

    emit(state.copyWith(monthRejected: counts, isLoadingRejectedCanceled: false));
  }

  Future<void> fetchMonthlyCanceledCounts({
    required bool isAdmin,
    required String? adminSelectedDepartment,
  }) async {
    final filterDepartment = _getFilterDepartment(
      isAdmin: isAdmin,
      adminSelectedDepartment: adminSelectedDepartment,
    );

    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    final Map<int, double> counts = {for (int i = 0; i < 12; i++) i: 0};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      String dept = _normalizeDepartmentValue(data['departmentRequester']);
      if (dept.isEmpty) {
        final email = _extractValue(data['Email_Requester']);
        if (email.isNotEmpty) {
          dept = CreateServicesHelper.getRequesterInfo(emailRequester: email)['department'] ?? '';
        }
      }
      if (filterDepartment != null && dept != filterDepartment) continue;

      final model = ServicesHistoryModel.fromJson(data, doc.id);
      if (getFinalStateFromModel(model).toLowerCase() == 'cancel' &&
          model.currentTimestamp != null) {
        final month = DateTime.fromMillisecondsSinceEpoch(model.currentTimestamp!).month - 1;
        counts[month] = (counts[month] ?? 0) + 1;
      }
    }

    emit(state.copyWith(monthCanceled: counts, isLoadingRejectedCanceled: false));
  }

  Future<void> fetchServiceUsageCounts({
    required bool isAdmin,
    required String? adminSelectedDepartment,
  }) async {
    final filterDepartment = _getFilterDepartment(
      isAdmin: isAdmin,
      adminSelectedDepartment: adminSelectedDepartment,
    );

    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    final Map<String, double> serviceIdToCount = {};
    final Map<String, String> serviceIdToNameEn = {};
    final Map<String, String> serviceIdToNameAr = {};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      String dept = _normalizeDepartmentValue(data['departmentRequester']);
      if (dept.isEmpty) {
        final email = _extractValue(data['Email_Requester']);
        if (email.isNotEmpty) {
          dept = _getDepartmentFromEmail(email) ?? '';
        }
      }
      if (filterDepartment != null && dept != filterDepartment) continue;

      final parentServiceId = _getSafeString(data['Parent_Service_Id']);
      if (parentServiceId == null || parentServiceId.isEmpty) continue;

      serviceIdToCount[parentServiceId] = (serviceIdToCount[parentServiceId] ?? 0) + 1;
      if (serviceIdToNameEn.containsKey(parentServiceId)) continue;

      final nameEn = _getSafeString(data['Service_Name_English']);
      final nameAr = _getSafeString(data['Service_Name_Arabic']);

      if (nameEn != null && nameEn.isNotEmpty) {
        serviceIdToNameEn[parentServiceId] = nameEn;
        serviceIdToNameAr[parentServiceId] = nameAr ?? '';
      } else {
        final emailRequester = _getSafeString(data['Email_Requester']);
        if (emailRequester != null && emailRequester.isNotEmpty) {
          final details = await CreateServicesHelper.getServiceDetailsFromCreateServices(
            parentServiceId: parentServiceId,
            emailRequester: emailRequester,
          );
          final fetchedEn = details['serviceNameEnglish'] ?? '';
          serviceIdToNameEn[parentServiceId] =
          fetchedEn.isNotEmpty ? fetchedEn : 'Service $parentServiceId';
          serviceIdToNameAr[parentServiceId] = details['serviceNameArabic'] ?? '';
        }
      }
    }

    final List<String> names = [];
    final List<String> namesAr = [];
    final Map<int, double> counts = {};

    int index = 0;
    for (final entry in serviceIdToCount.entries) {
      names.add(serviceIdToNameEn[entry.key] ?? 'Unknown');
      namesAr.add(serviceIdToNameAr[entry.key] ?? '');
      counts[index] = entry.value;
      index++;
    }

    emit(state.copyWith(
      serviceNames: names,
      serviceNamesArabic: namesAr,
      monthCountss: counts,
      isLoadingServicesName: false,
    ));
  }

  Future<void> fetchDepartmentCounts({
    required bool isAdmin,
    required String? adminSelectedDepartment,
  }) async {
    final filterDepartment = _getFilterDepartment(
      isAdmin: isAdmin,
      adminSelectedDepartment: adminSelectedDepartment,
    );

    final dc = Get.find<MainCoreDepartmentController>();
    final dynamicDepts = dc.departmentsEnglishName;

    if (filterDepartment != null && filterDepartment.isNotEmpty) {
      final snapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .get();

      final Map<String, int> counts = {for (var d in dynamicDepts) d: 0};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        String dept = _normalizeDepartmentValue(data['departmentRequester']);
        if (dept.isEmpty) {
          final email = _extractValue(data['Email_Requester']);
          if (email.isNotEmpty) dept = _getDepartmentFromEmail(email) ?? '';
        }
        if (counts.containsKey(dept)) counts[dept] = (counts[dept] ?? 0) + 1;
      }

      emit(state.copyWith(departmentCounts: counts, isLoadingDepartments: false));
    } else {
      emit(state.copyWith(
        departmentCounts: {for (var d in dynamicDepts) d: 0},
        isLoadingDepartments: false,
      ));
    }
  }

  // ─── Chart Settings ────────────────────────────────────────────────────────

  Future<void> _loadChartSettings() async {
    try {
      final email = employeeFunctionHelper.email;
      if (email == null) {
        emit(state.copyWith(isLoadingChartSettings: false));
        return;
      }
      final orientations = await ChartSettingsFirebaseService().getAllChartOrientations(
        email: email,
        module: 'services',
      );
      emit(state.copyWith(
        chartOrientations: orientations,
        isLoadingChartSettings: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingChartSettings: false));
    }
  }

  // ─── Status resolution ─────────────────────────────────────────────────────

  String getFinalStateFromModel(ServicesHistoryModel service) {
    final stateArray = service.state;

    if (stateArray.isNotEmpty) {
      final lastState = stateArray.last.toLowerCase().trim();
      if (['rejected', 'cancel', 'done', 'approved', 'inprogress', 'branchsla', 'breached sla']
          .contains(lastState)) {
        return lastState;
      }
    }

    final approvalCycle = service.currentApprovalCycle;
    if (approvalCycle.isNotEmpty) {
      final states = approvalCycle
          .map((e) => e.state?.toLowerCase().trim() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();

      if (states.contains('rejected')) return 'rejected';
      if (states.contains('cancel')) return 'cancel';
      if (states.contains('pending')) return 'pending';
      if (states.every((s) => s == 'approved')) {
        if (stateArray.isEmpty) return 'approved';
        return stateArray.last.toLowerCase().trim();
      }
    }

    if (stateArray.isEmpty) return 'pending';
    return stateArray.last.toLowerCase().trim();
  }

  // ─── Private: Filter ──────────────────────────────────────────────────────

  List<Map<String, dynamic>> _computeDisplayedItems(DashboardMasterState s) {
    final query = s.searchQuery.toLowerCase().trim();

    return s.filteredItems.where((item) {
      final matchesQuery = query.isEmpty ||
          [
            item['department'], item['serviceName'], item['serviceNameArabic'],
            item['requestor'], item['requestorArabic'], item['status'], item['provider'],
          ].join(' ').toLowerCase().contains(query);

      final matchesDept = s.activeDepartment == null ||
          s.activeDepartment!.isEmpty ||
          item['department'] == s.activeDepartment;

      final matchesStatus = s.activeStatus == null ||
          s.activeStatus!.isEmpty ||
          item['status']?.toString().toLowerCase() == s.activeStatus!.toLowerCase();

      final ts = item['requestDate'] as Timestamp?;
      final modelDate = ts?.toDate();
      final matchesDate = s.activeDate == null ||
          (modelDate != null &&
              modelDate.year == s.activeDate!.year &&
              modelDate.month == s.activeDate!.month &&
              modelDate.day == s.activeDate!.day);

      return matchesQuery && matchesDept && matchesStatus && matchesDate;
    }).toList();
  }

  // ─── Private: Provider resolution ─────────────────────────────────────────

  Map<String, dynamic> _resolveProvider({
    required Map<String, dynamic> data,
    required String emailRequester,
    required MainCoreEmployeeController employeeController,
  }) {
    Map<String, dynamic> selectedProvider = {};
    String firstName = '';
    String lastName = '';
    String firstNameAr = '';
    String lastNameAr = '';

    // Method 1: selectedServiceProvider map
    if (data['selectedServiceProvider'] is Map) {
      final map = Map<String, dynamic>.from(data['selectedServiceProvider'] as Map);
      if (map.isNotEmpty) {
        selectedProvider = map;
        firstName = map['firstName']?.toString() ?? '';
        lastName = map['lastName']?.toString() ?? '';
        firstNameAr = map['firstNameInArabic']?.toString() ?? '';
        lastNameAr = map['lastNameInArabic']?.toString() ?? '';
      }
    }

    // Method 2: Provider_Services JSON
    if (selectedProvider.isEmpty && data['Provider_Services'] != null) {
      try {
        final raw = data['Provider_Services'];
        String? jsonStr;
        if (raw is List && raw.isNotEmpty) jsonStr = raw.first.toString();
        else if (raw is String) jsonStr = raw;

        if (jsonStr != null && jsonStr.startsWith('[{')) {
          jsonStr = jsonStr.substring(1, jsonStr.length - 1);
          final provMap = jsonDecode(jsonStr) as Map<String, dynamic>;
          if (provMap.isNotEmpty) {
            selectedProvider = provMap;
            firstName = provMap['firstName']?.toString() ?? '';
            lastName = provMap['lastName']?.toString() ?? '';
            firstNameAr = provMap['firstNameInArabic']?.toString() ?? '';
            lastNameAr = provMap['lastNameInArabic']?.toString() ?? '';
          }
        }
      } catch (_) {}
    }

    // Method 3: Assigned_Provider_Email
    if (selectedProvider.isEmpty && data['Assigned_Provider_Email'] != null) {
      String? providerEmail;
      final raw = data['Assigned_Provider_Email'];
      if (raw is List && raw.isNotEmpty) {
        providerEmail = raw[0]?.toString();
        if (providerEmail == null || providerEmail.isEmpty || providerEmail == emailRequester) {
          providerEmail = raw.length > 1 ? raw[1]?.toString() : null;
        }
      } else if (raw is String && raw.isNotEmpty && raw != emailRequester) {
        providerEmail = raw;
      }

      if (providerEmail != null && providerEmail.isNotEmpty && providerEmail != emailRequester) {
        final emp = employeeController.mapOfEmployeesWithEmailKey[providerEmail];
        if (emp != null) {
          selectedProvider = _buildProviderMap(emp);
          firstName = emp.firstName ?? '';
          lastName = emp.lastName ?? '';
          firstNameAr = emp.firstNameInArabic ?? '';
          lastNameAr = emp.lastNameInArabic ?? '';
        }
      }
    }

    // Method 4: state array
    if (selectedProvider.isEmpty && data['state'] is List) {
      for (final s in (data['state'] as List)) {
        if (s is Map) {
          final email = (s['providerEmail'] ?? s['assignedTo'] ?? s['provider'])?.toString();
          if (email != null && email.isNotEmpty && email != emailRequester) {
            final emp = employeeController.mapOfEmployeesWithEmailKey[email];
            if (emp != null) {
              selectedProvider = _buildProviderMap(emp);
              firstName = emp.firstName ?? '';
              lastName = emp.lastName ?? '';
              firstNameAr = emp.firstNameInArabic ?? '';
              lastNameAr = emp.lastNameInArabic ?? '';
              break;
            }
          }
        }
      }
    }

    // Method 5: approvalCycle
    if (selectedProvider.isEmpty && data['approvalCycle'] is Map) {
      final valueList = (data['approvalCycle'] as Map)['value'];
      if (valueList is List) {
        for (final approval in valueList) {
          if (approval is Map) {
            final email = (approval['email'] ?? approval['approverEmail'])?.toString();
            if (email != null && email.isNotEmpty && email != emailRequester) {
              final emp = employeeController.mapOfEmployeesWithEmailKey[email];
              if (emp != null) {
                selectedProvider = _buildProviderMap(emp);
                firstName = emp.firstName ?? '';
                lastName = emp.lastName ?? '';
                firstNameAr = emp.firstNameInArabic ?? '';
                lastNameAr = emp.lastNameInArabic ?? '';
                break;
              }
            }
          }
        }
      }
    }

    if (!selectedProvider.containsKey('gender')) selectedProvider['gender'] = '';

    return {
      'map': selectedProvider,
      'name': (firstName.isNotEmpty || lastName.isNotEmpty)
          ? '$firstName $lastName'.trim()
          : 'N/A',
      'firstName': firstName,
      'lastName': lastName,
      'firstNameArabic': firstNameAr,
      'lastNameArabic': lastNameAr,
    };
  }

  Map<String, dynamic> _buildProviderMap(dynamic emp) => {
    'firstName': emp.firstName ?? '',
    'lastName': emp.lastName ?? '',
    'firstNameInArabic': emp.firstNameInArabic ?? '',
    'lastNameInArabic': emp.lastNameInArabic ?? '',
    'email': emp.email ?? '',
    'gender': emp.gender ?? '',
    'title': emp.title ?? '',
    'titleInArabic': emp.titleInArabic ?? '',
    'departmentId': emp.departmentId ?? '',
  };

  // ─── Private: Helpers ──────────────────────────────────────────────────────

  String _extractValue(dynamic value) {
    if (value == null) return '';
    if (value is List) return value.isEmpty ? '' : (value[0]?.toString() ?? '');
    return value.toString();
  }

  String? _getSafeString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    if (value is List) {
      if (value.isEmpty) return null;
      final s = value.first?.toString() ?? '';
      return s.isEmpty ? null : s;
    }
    return value.toString();
  }

  String _normalizeDepartmentValue(dynamic departmentValue) {
    if (departmentValue == null) return '';
    final dc = Get.find<MainCoreDepartmentController>();
    String value = '';

    if (departmentValue is List && departmentValue.isNotEmpty) {
      value = departmentValue.last?.toString().trim() ?? '';
    } else {
      value = departmentValue.toString().trim();
    }

    if (value.isEmpty) return '';

    if (int.tryParse(value) != null) {
      return dc.getEnglishDepartmentNameFromDepartmentId(departmentId: value) ?? value;
    }

    return value;
  }

  String? _getDepartmentFromEmail(String email) {
    final ec = Get.find<MainCoreEmployeeController>();
    final dc = Get.find<MainCoreDepartmentController>();
    final emp = ec.mapOfEmployeesWithEmailKey[email];
    if (emp?.departmentId == null) return null;
    return dc.getEnglishDepartmentNameFromDepartmentId(departmentId: emp!.departmentId!);
  }

  double _toHours(double value, String unit) => switch (unit) {
    'minutes' => value / 60,
    'hours'   => value,
    'days'    => value * 24,
    'weeks'   => value * 168,
    _         => 0,
  };
}
