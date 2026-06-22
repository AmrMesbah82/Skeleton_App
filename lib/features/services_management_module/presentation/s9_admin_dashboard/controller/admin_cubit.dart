/// ******************* FILE INFO *******************
/// File Name: dashboard_admin_cubit.dart
/// Description: Business logic for Admin Dashboard
/// Created by: Amr Mesbah

import 'dart:convert';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/create_services_helper.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/controller/admin_state.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';

class DashboardAdminCubit extends Cubit<DashboardAdminState> {
  DashboardAdminCubit() : super(DashboardAdminState.initial());

  // ─── Public API ────────────────────────────────────────────────────────────

  Future<void> bootstrap() async {
    emit(state.copyWith(bootstrapping: true));
    try {
      await Future.wait([
        loadServiceStatusData(),
        fetchDepartmentCountsFilter(),
        fetchMonthlyServiceCounts(),
        fetchServiceUsageCounts(),
        fetchDepartmentCounts(),
        loadServiceStatusDataFilter(),
        loadFilteredServices(),
        loadRequestsData(),
      ]);
    } catch (e, st) {
    } finally {
      emit(state.copyWith(bootstrapping: false, bootstrapped: true, tableDataLoaded: true));
    }
  }

  Future<void> onDepartmentChanged(String newStatus) async {
    emit(state.copyWith(
      selectStatus: newStatus,
      isServiceListLoading: true,
      isLoadingRequests: true,
      isLoading: true,
      isLoadingServicesName: true,
      allServices: [],
      displayedItems: [],
      monthCounts: {},
      monthHours: {},
      monthCountss: {},
      serviceNames: [],
      serviceNamesArabic: [],
    ));

    try {
      await Future.wait([
        loadServiceStatusDataFilter(),
        loadFilteredServices(),
        loadRequestsData(),
        fetchServiceUsageCounts(),
        fetchMonthlyServiceCounts(),
        fetchMonthlyDurationInHours(),
      ]);
    } catch (e, st) {
    }
  }

  void toggleShowAll() => emit(state.copyWith(showAll: !state.showAll));

  void toggleServiceCount(bool showCount) {
    emit(state.copyWith(showServiceCount: showCount, isLoading: true));
    if (showCount) {
      fetchMonthlyServiceCounts();
    } else {
      fetchMonthlyDurationInHours();
    }
  }

  void toggleShowRequests(bool show) => emit(state.copyWith(showRequests: show));

  // ─── Data Loading ──────────────────────────────────────────────────────────

  Future<void> loadRequestsData() async {
    emit(state.copyWith(isLoadingRequests: true, displayedItems: []));

    final firestore = FirebaseFirestore.instance;
    final employeeController = Get.find<MainCoreEmployeeController>();
    final departmentController = Get.find<MainCoreDepartmentController>();

    final servicesSnapshot = await firestore
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    final List<Map<String, dynamic>> results = [];

    for (int i = 0; i < servicesSnapshot.docs.length; i++) {
      final doc = servicesSnapshot.docs[i];
      final data = doc.data();
      final docId = doc.id;

      try {
        final emailRequester = _extractValue(data['Email_Requester']);
        if (emailRequester.isEmpty) continue;

        final employee = employeeController.mapOfEmployeesWithEmailKey[emailRequester];
        if (employee == null) continue;

        String normalizedDepartment = '';
        if (employee.departmentId != null && employee.departmentId!.isNotEmpty) {
          normalizedDepartment = departmentController
              .getEnglishDepartmentNameFromDepartmentId(
              departmentId: employee.departmentId!) ??
              '';
        }

        if (state.selectStatus != "All" && normalizedDepartment != state.selectStatus) continue;

        String serviceNameEnglish = _extractValue(data['Service_Name_English']);
        String serviceNameArabic = _extractValue(data['Service_Name_Arabic']);
        final parentServiceId = _extractValue(data['Parent_Service_Id']);

        if ((serviceNameEnglish.isEmpty || serviceNameArabic.isEmpty) &&
            parentServiceId.isNotEmpty) {
          final serviceDetails =
          await CreateServicesHelper.getServiceDetailsFromCreateServices(
            parentServiceId: parentServiceId,
            emailRequester: emailRequester,
          );
          if (serviceNameEnglish.isEmpty)
            serviceNameEnglish = serviceDetails['serviceNameEnglish'] ?? '';
          if (serviceNameArabic.isEmpty)
            serviceNameArabic = serviceDetails['serviceNameArabic'] ?? '';
        }

        final providerData = _resolveProvider(data, emailRequester, employeeController);

        final finalState = resolveFinalStateFromData(data);
        final requestDate = _resolveRequestDate(data);

        results.add({
          "no": results.length + 1,
          "department": normalizedDepartment,
          "serviceName": serviceNameEnglish,
          "serviceNameArabic": serviceNameArabic,
          "gender": employee.gender ?? '',
          "requestor": '${employee.firstName ?? ''} ${employee.lastName ?? ''}'.trim(),
          "firstNameRequester": employee.firstName ?? '',
          "lastNameRequester": employee.lastName ?? '',
          "firstNameRequesterArabic": employee.firstNameInArabic ?? '',
          "lastNameRequesterArabic": employee.lastNameInArabic ?? '',
          "provider": providerData['name'],
          "firstNameProvider": providerData['firstName'],
          "lastNameProvider": providerData['lastName'],
          "firstNameProviderArabic": providerData['firstNameArabic'],
          "lastNameProviderArabic": providerData['lastNameArabic'],
          "jobTitleRequester": employee.title ?? '',
          "jobTitleRequesterArabic": employee.titleInArabic ?? '',
          "requestDate": requestDate,
          "status": finalState,
          "docId": docId,
          "raw": data,
          "selectedProvider": providerData['map'],
        });
      } catch (e, st) {
      }
    }

    emit(state.copyWith(displayedItems: results, isLoadingRequests: false));
  }

  Future<void> loadServiceStatusData() async {
    final counts = await calculateServiceStatesFilter();
    emit(state.copyWith(statusCounts: counts, isLoadingFirst: false));
  }

  Future<void> loadServiceStatusDataFilter() async {
    final filter =
    (state.selectStatus != "All") ? state.selectStatus : null;
    final counts =
    await calculateServiceStatesFilter(filterDepartment: filter);
    emit(state.copyWith(statusCounts: counts, isLoadingFirst: false));
  }

  Future<void> fetchMonthlyServiceCounts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    Map<int, double> counts = {for (int i = 0; i < 12; i++) i: 0};
    final employeeController = Get.find<MainCoreEmployeeController>();
    final departmentController = Get.find<MainCoreDepartmentController>();

    for (var doc in snapshot.docs) {
      try {
        final data = doc.data();

        if (state.selectStatus != "All") {
          final email = _extractValue(data['Email_Requester']);
          if (email.isEmpty) continue;
          final emp = employeeController.mapOfEmployeesWithEmailKey[email];
          if (emp == null) continue;
          String dept = '';
          if (emp.departmentId?.isNotEmpty == true) {
            dept = departmentController.getEnglishDepartmentNameFromDepartmentId(
                departmentId: emp.departmentId!) ??
                '';
          }
          if (dept != state.selectStatus) continue;
        }

        final ts = _extractLatestTimestamp(data);
        if (ts != null) {
          final month = DateTime.fromMillisecondsSinceEpoch(ts).month - 1;
          counts[month] = (counts[month] ?? 0) + 1;
        }
      } catch (e) {
      }
    }

    emit(state.copyWith(monthCounts: counts, isLoading: false));
  }

  Future<void> fetchMonthlyDurationInHours() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    Map<int, double> durationPerMonth = {for (int i = 0; i < 12; i++) i: 0};
    final employeeController = Get.find<MainCoreEmployeeController>();
    final departmentController = Get.find<MainCoreDepartmentController>();

    for (var doc in snapshot.docs) {
      try {
        final data = doc.data();

        if (state.selectStatus != "All") {
          final email = _extractValue(data['Email_Requester']);
          if (email.isEmpty) continue;
          final emp = employeeController.mapOfEmployeesWithEmailKey[email];
          if (emp == null) continue;
          String dept = '';
          if (emp.departmentId?.isNotEmpty == true) {
            dept = departmentController.getEnglishDepartmentNameFromDepartmentId(
                departmentId: emp.departmentId!) ??
                '';
          }
          if (dept != state.selectStatus) continue;
        }

        final parentServiceId = _extractValue(data['Parent_Service_Id']);
        final emailRequester = _extractValue(data['Email_Requester']);
        if (parentServiceId.isEmpty || emailRequester.isEmpty) continue;

        final serviceDetails =
        await CreateServicesHelper.getServiceDetailsFromCreateServices(
          parentServiceId: parentServiceId,
          emailRequester: emailRequester,
        );

        final durationStr = serviceDetails['duration'] ?? '';
        final unit = serviceDetails['unit']?.toLowerCase() ?? '';
        if (durationStr.isEmpty || unit.isEmpty) continue;

        double value = double.tryParse(durationStr) ?? 0;
        if (value <= 0) continue;

        double hours = _toHours(value, unit);
        if (hours <= 0) continue;

        final ts = _extractLatestTimestamp(data);
        if (ts == null) continue;

        final month = DateTime.fromMillisecondsSinceEpoch(ts).month - 1;
        durationPerMonth[month] = (durationPerMonth[month] ?? 0) + hours;
      } catch (e) {
      }
    }

    emit(state.copyWith(monthHours: durationPerMonth, isLoading: false));
  }

  Future<void> fetchServiceUsageCounts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    Map<String, double> serviceIdToCount = {};
    Map<String, String> serviceIdToNameEn = {};
    Map<String, String> serviceIdToNameAr = {};

    final employeeController = Get.find<MainCoreEmployeeController>();
    final departmentController = Get.find<MainCoreDepartmentController>();

    for (var doc in snapshot.docs) {
      try {
        final data = doc.data();

        if (state.selectStatus != "All") {
          final email = _extractValue(data['Email_Requester']);
          if (email.isEmpty) continue;
          final emp = employeeController.mapOfEmployeesWithEmailKey[email];
          if (emp == null) continue;
          String dept = '';
          if (emp.departmentId?.isNotEmpty == true) {
            dept = departmentController.getEnglishDepartmentNameFromDepartmentId(
                departmentId: emp.departmentId!) ??
                '';
          }
          if (dept != state.selectStatus) continue;
        }

        final parentServiceId = _getSafeString(data['Parent_Service_Id']);
        if (parentServiceId == null || parentServiceId.isEmpty) continue;

        serviceIdToCount[parentServiceId] =
            (serviceIdToCount[parentServiceId] ?? 0) + 1;

        final nameEn = _getSafeString(data['Service_Name_English']);
        final nameAr = _getSafeString(data['Service_Name_Arabic']);

        if ((nameEn == null || nameEn.isEmpty) &&
            (nameAr == null || nameAr.isEmpty)) {
          if (!serviceIdToNameEn.containsKey(parentServiceId)) {
            final email = _getSafeString(data['Email_Requester']);
            if (email != null && email.isNotEmpty) {
              final details =
              await CreateServicesHelper.getServiceDetailsFromCreateServices(
                parentServiceId: parentServiceId,
                emailRequester: email,
              );
              serviceIdToNameEn[parentServiceId] =
                  details['serviceNameEnglish'] ?? '';
              serviceIdToNameAr[parentServiceId] =
                  details['serviceNameArabic'] ?? '';
            }
          }
        } else {
          serviceIdToNameEn[parentServiceId] = nameEn ?? '';
          serviceIdToNameAr[parentServiceId] = nameAr ?? '';
        }
      } catch (e) {
      }
    }

    List<String> tempNames = [];
    List<String> tempNamesAr = [];
    Map<int, double> tempCounts = {};

    int index = 0;
    for (var entry in serviceIdToCount.entries) {
      final nameEn = serviceIdToNameEn[entry.key] ?? '';
      final nameAr = serviceIdToNameAr[entry.key] ?? '';
      if (nameEn.isNotEmpty && !tempNames.contains(nameEn)) {
        tempNames.add(nameEn);
        tempNamesAr.add(nameAr);
        tempCounts[index] = entry.value;
        index++;
      }
    }

    emit(state.copyWith(
      serviceNames: tempNames,
      serviceNamesArabic: tempNamesAr,
      monthCountss: tempCounts,
      isLoadingServicesName: false,
    ));
  }

  Future<void> fetchDepartmentCounts() async {
    final counts = await _countDepartments();
    emit(state.copyWith(departmentCounts: counts, isLoadingDepartments: false));
  }

  Future<void> fetchDepartmentCountsFilter() async {
    final firestore = FirebaseFirestore.instance;
    final departmentController = Get.find<MainCoreDepartmentController>();
    final employeeController = Get.find<MainCoreEmployeeController>();
    final departments = departmentController.departmentsEnglishName;

    final Map<String, int> counts = {for (var d in departments) d: 0};

    try {
      final querySnapshot = await firestore
          .collection(getBaseUrl(FirestoreCollections.createServices))
          .get();

      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          final email = _extractValue(data['Email_Requester']);
          if (email.isEmpty) continue;

          final emp = employeeController.mapOfEmployeesWithEmailKey[email];
          if (emp == null || emp.departmentId == null || emp.departmentId!.isEmpty)
            continue;

          final deptName = departmentController
              .getEnglishDepartmentNameFromDepartmentId(
              departmentId: emp.departmentId!);

          if (deptName != null && counts.containsKey(deptName)) {
            counts[deptName] = counts[deptName]! + 1;
          }
        } catch (e) {
        }
      }
    } catch (e) {
    }

    // ✅ Emit dynamic departmentCounts map + totalServices
    emit(state.copyWith(
      departmentCounts: counts,
      totalServices: counts.values.fold(0, (s, v) => s! + v),
    ));
  }

  Future<void> loadFilteredServices() async {
    emit(state.copyWith(isServiceListLoading: true));

    final firestore = FirebaseFirestore.instance;
    final employeeController = Get.find<MainCoreEmployeeController>();
    final departmentController = Get.find<MainCoreDepartmentController>();

    final createServicesSnapshot = await firestore
        .collection(getBaseUrl(FirestoreCollections.createServices))
        .get();

    Map<String, Map<String, dynamic>> createServicesMap = {};
    Map<String, String> serviceNameToDocId = {};
    List<Map<String, dynamic>> allServicesData = [];

    for (var serviceDoc in createServicesSnapshot.docs) {
      try {
        final data = serviceDoc.data();
        final email = _extractValue(data['Email_Requester']);
        String department = '';

        if (email.isNotEmpty) {
          final emp = employeeController.mapOfEmployeesWithEmailKey[email];
          if (emp != null && emp.departmentId?.isNotEmpty == true) {
            department = departmentController
                .getEnglishDepartmentNameFromDepartmentId(
                departmentId: emp.departmentId!) ??
                '';
          }
        }

        if (state.selectStatus != "All" && department != state.selectStatus)
          continue;

        final nameEn = _extractValue(data['Service_Name_English']);
        final nameAr = _extractValue(data['Service_Name_Arabic']);
        final durationStr = _extractValue(data['Duration_Of_Services']);
        final unit = _extractValue(data['Selected_Duration_Unit']).toLowerCase();
        final earliestTs = _extractEarliestTimestamp(data);

        createServicesMap[serviceDoc.id] = {
          'nameEn': nameEn,
          'nameAr': nameAr,
          'durationStr': durationStr,
          'unit': unit,
          'earliestTimestamp': earliestTs,
          'department': department,
        };

        if (nameEn.isNotEmpty) {
          serviceNameToDocId[nameEn] = serviceDoc.id;
          allServicesData.add({
            'docId': serviceDoc.id,
            'nameEn': nameEn,
            'nameAr': nameAr,
            'durationStr': durationStr,
            'unit': unit,
            'earliestTimestamp': earliestTs,
          });
        }
      } catch (e) {
      }
    }

    final requestServicesSnapshot = await firestore
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    Map<String, Map<String, dynamic>> requestStats = {};

    for (var doc in requestServicesSnapshot.docs) {
      try {
        final data = doc.data();
        String nameEn = _extractValue(data['Service_Name_English']);

        if (nameEn.isEmpty) {
          final parentId = _extractValue(data['Parent_Service_Id']);
          if (parentId.isNotEmpty && createServicesMap.containsKey(parentId)) {
            nameEn = createServicesMap[parentId]!['nameEn'] ?? '';
          }
        }

        if (nameEn.isEmpty) continue;

        requestStats.putIfAbsent(nameEn, () => {
          'doneCount': 0,
          'totalHours': 0.0,
          'earliestTimestamp': null,
        });

        final finalState = resolveFinalStateFromData(data);

        if (finalState == 'done' || finalState == 'branchsla') {
          requestStats[nameEn]!['doneCount']++;

          String durationStr = _extractValue(data['Duration_Of_Services']);
          String unit = _extractValue(data['Selected_Duration_Unit']).toLowerCase();

          if (durationStr.isEmpty || unit.isEmpty) {
            final parentId = _extractValue(data['Parent_Service_Id']);
            if (parentId.isNotEmpty && createServicesMap.containsKey(parentId)) {
              durationStr = createServicesMap[parentId]!['durationStr'] ?? '';
              unit = createServicesMap[parentId]!['unit'] ?? '';
            }
            if ((durationStr.isEmpty || unit.isEmpty) &&
                serviceNameToDocId.containsKey(nameEn)) {
              final csDocId = serviceNameToDocId[nameEn]!;
              durationStr = createServicesMap[csDocId]!['durationStr'] ?? '';
              unit = createServicesMap[csDocId]!['unit'] ?? '';
            }
          }

          if (durationStr.isNotEmpty && unit.isNotEmpty) {
            final double dur = double.tryParse(durationStr) ?? 0;
            final hours = _toHours(dur, unit);
            requestStats[nameEn]!['totalHours'] =
                (requestStats[nameEn]!['totalHours'] as double) + hours;
          }
        }

        final docTs = _extractEarliestTimestamp(data);
        if (docTs != null) {
          final current = requestStats[nameEn]!['earliestTimestamp'] as int?;
          if (current == null || docTs < current) {
            requestStats[nameEn]!['earliestTimestamp'] = docTs;
          }
        }
      } catch (e, st) {
      }
    }

    List<Map<String, dynamic>> result = [];

    for (var sd in allServicesData) {
      final nameEn = sd['nameEn'] as String;
      final nameAr = sd['nameAr'] as String;
      if (nameEn.isEmpty) continue;

      final stats = requestStats[nameEn];
      final int doneCount = stats?['doneCount'] ?? 0;
      final double totalHours = (stats?['totalHours'] ?? 0.0) as double;

      int? earliestTs = stats?['earliestTimestamp'] as int?;
      earliestTs ??= sd['earliestTimestamp'] as int?;

      String startDate = 'N/A';
      if (earliestTs != null) {
        try {
          startDate = DateFormat('dd MMM yyyy')
              .format(DateTime.fromMillisecondsSinceEpoch(earliestTs));
        } catch (_) {}
      }

      result.add({
        'title': nameEn,
        'titleEnglish': nameEn,
        'titleArabic': nameAr,
        'startDate': startDate,
        'done': doneCount.toString(),
        'total': totalHours.toStringAsFixed(1),
      });
    }

    emit(state.copyWith(allServices: result, isServiceListLoading: false));
  }

  Future<Map<String, int>> calculateServiceStatesFilter({
    String? filterDepartment,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final employeeController = Get.find<MainCoreEmployeeController>();
    final departmentController = Get.find<MainCoreDepartmentController>();

    final snapshot = await firestore
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    int done = 0,
        inProgress = 0,
        approved = 0,
        rejected = 0,
        pending = 0,
        cancel = 0,
        branchSla = 0;

    for (var doc in snapshot.docs) {
      try {
        final data = doc.data();
        final email = _extractValue(data['Email_Requester']);
        String department = '';

        if (email.isNotEmpty) {
          final emp = employeeController.mapOfEmployeesWithEmailKey[email];
          if (emp != null && emp.departmentId?.isNotEmpty == true) {
            department = departmentController
                .getEnglishDepartmentNameFromDepartmentId(
                departmentId: emp.departmentId!) ??
                '';
          }
        }

        if (filterDepartment != null &&
            filterDepartment != "All" &&
            department != filterDepartment) continue;

        switch (resolveFinalStateFromData(data)) {
          case 'done':       done++;       break;
          case 'inprogress': inProgress++; break;
          case 'approved':   approved++;   break;
          case 'rejected':   rejected++;   break;
          case 'pending':    pending++;    break;
          case 'cancel':     cancel++;     break;
          case 'branchsla':  branchSla++;  break;
        }
      } catch (e) {
      }
    }

    return {
      'done': done,
      'inprogress': inProgress,
      'approved': approved,
      'pending': pending,
      'rejected': rejected,
      'cancel': cancel,
      'branchsla': branchSla,
    };
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  /// Current user email, resolved from the module's employee controller.
  /// Keeps the module self-contained (no dependency on the settings screen).
  String get _currentUserEmail {
    try {
      final controller = Get.find<MainCoreEmployeeController>();
      return controller.employeeEntity?.email ?? '';
    } catch (e) {
      return '';
    }
  }

  String resolveFinalStateFromData(Map<String, dynamic> data) {
    String actualState = '';

    if (data['state'] is List) {
      final list = data['state'] as List;
      actualState =
      list.isNotEmpty ? (list.last?.toString().trim().toLowerCase() ?? '') : '';
    } else if (data['state'] is String) {
      actualState = (data['state'] as String).trim().toLowerCase();
    } else if (data['state'] != null) {
      actualState = data['state'].toString().trim().toLowerCase();
    }

    const finalStates = [
      'done', 'inprogress', 'cancel', 'canceled', 'branchsla',
      'breached sla', 'approved', 'pending', 'rejected'
    ];

    if (actualState.isNotEmpty && finalStates.contains(actualState)) {
      if (actualState == 'cancel' || actualState == 'canceled') return 'cancel';
      return actualState;
    }

    if (data['Approval_Cycle'] is List) {
      final approvalList = data['Approval_Cycle'] as List;
      if (approvalList.isNotEmpty) {
        final lastValue = approvalList.last;
        if (lastValue is String) {
          try {
            final decoded = jsonDecode(lastValue);
            if (decoded is List) {
              final states = decoded
                  .map((e) => (e['state']?.toString().trim().toLowerCase() ?? ''))
                  .where((s) => s.isNotEmpty)
                  .toList();
              if (states.contains('cancel') || states.contains('canceled'))
                return 'cancel';
              if (states.contains('rejected')) return 'rejected';
              if (states.contains('done')) return 'done';
              if (states.every((s) => s == 'approved')) return 'approved';
              if (states.contains('inprogress')) return 'inprogress';
              if (states.contains('pending')) return 'pending';
            }
          } catch (_) {}
        }
      }
    }

    if (data['approvalCycle'] is Map<String, dynamic>) {
      final approvalMap = data['approvalCycle'] as Map<String, dynamic>;
      final valueList = approvalMap['value'];
      if (valueList is List) {
        final states = valueList
            .map((e) => (e['state']?.toString().trim().toLowerCase() ?? ''))
            .where((s) => s.isNotEmpty)
            .toList();
        if (states.contains('cancel') || states.contains('canceled'))
          return 'cancel';
        if (states.contains('rejected')) return 'rejected';
        if (states.isNotEmpty && states.every((s) => s == 'approved'))
          return 'approved';
        if (states.contains('pending')) return 'pending';
      }
    }

    return 'pending';
  }

  String _extractValue(dynamic value) {
    if (value == null) return '';
    if (value is List) return value.isEmpty ? '' : (value[0]?.toString() ?? '');
    return value.toString();
  }

  String? _getSafeString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List) {
      return value.isNotEmpty && value.first is String
          ? value.first as String
          : null;
    }
    return value.toString();
  }

  int? _extractLatestTimestamp(Map<String, dynamic> data) {
    int? latest;

    void consider(dynamic raw) {
      int? val;
      if (raw is int) val = raw;
      else if (raw is double) val = raw.toInt();
      else if (raw is Timestamp) val = raw.millisecondsSinceEpoch;
      if (val != null && (latest == null || val > latest!)) latest = val;
    }

    final ts = data['timestamps'];
    if (ts is List) {
      for (var t in ts) consider(t);
    } else {
      consider(ts);
    }

    final dts = data['Duration_Of_Services_Timestamp'];
    if (dts is List) {
      for (var t in dts) consider(t);
    } else {
      consider(dts);
    }

    consider(data['createdDate']);
    return latest;
  }

  int? _extractEarliestTimestamp(Map<String, dynamic> data) {
    int? earliest;

    void consider(dynamic raw) {
      int? val;
      if (raw is int) val = raw;
      else if (raw is double) val = raw.toInt();
      else if (raw is Timestamp) val = raw.millisecondsSinceEpoch;
      if (val != null && (earliest == null || val < earliest!)) earliest = val;
    }

    final ts = data['timestamps'];
    if (ts is List) {
      for (var t in ts) consider(t);
    } else {
      consider(ts);
    }

    final dts = data['Duration_Of_Services_Timestamp'];
    if (dts is List) {
      for (var t in dts) consider(t);
    } else {
      consider(dts);
    }

    consider(data['createdDate']);
    return earliest;
  }

  String _resolveRequestDate(Map<String, dynamic> data) {
    final format = DateFormat('yyyy-MM-dd – kk:mm');

    final ts = data['timestamps'];
    if (ts is List && ts.isNotEmpty && ts.last is int) {
      return format.format(DateTime.fromMillisecondsSinceEpoch(ts.last as int));
    }

    final dts = data['Duration_Of_Services_Timestamp'];
    if (dts is List && dts.isNotEmpty && dts.last is int) {
      return format.format(DateTime.fromMillisecondsSinceEpoch(dts.last as int));
    }

    final cd = data['createdDate'];
    if (cd is Timestamp) return format.format(cd.toDate());

    return 'N/A';
  }

  Map<String, dynamic> _resolveProvider(
      Map<String, dynamic> data,
      String emailRequester,
      MainCoreEmployeeController employeeController,
      ) {
    Map<String, dynamic> selectedProvider = {};
    String firstName = '', lastName = '', firstNameAr = '', lastNameAr = '';

    // Method 1: selectedServiceProvider
    if (data['selectedServiceProvider'] is Map) {
      selectedProvider =
      Map<String, dynamic>.from(data['selectedServiceProvider'] as Map);
      firstName = selectedProvider['firstName']?.toString() ?? '';
      lastName = selectedProvider['lastName']?.toString() ?? '';
      firstNameAr = selectedProvider['firstNameInArabic']?.toString() ?? '';
      lastNameAr = selectedProvider['lastNameInArabic']?.toString() ?? '';
    }

    // Method 2: Provider_Services
    if (selectedProvider.isEmpty && data['Provider_Services'] != null) {
      try {
        final raw = data['Provider_Services'];
        Map<String, dynamic>? providerMap;

        if (raw is Map) {
          providerMap = Map<String, dynamic>.from(raw);
        } else if (raw is List && raw.isNotEmpty) {
          final first = raw.first;
          if (first is Map) {
            providerMap = Map<String, dynamic>.from(first);
          } else if (first is String) {
            providerMap = _parseFirstJsonObject(first);
          }
        } else if (raw is String) {
          providerMap = _parseFirstJsonObject(raw);
        }

        if (providerMap != null && providerMap.isNotEmpty) {
          selectedProvider = providerMap;
          firstName = providerMap['firstName']?.toString() ?? '';
          lastName = providerMap['lastName']?.toString() ?? '';
          firstNameAr = providerMap['firstNameInArabic']?.toString() ?? '';
          lastNameAr = providerMap['lastNameInArabic']?.toString() ?? '';
        }
      } catch (_) {}
    }

    // Method 3: Assigned_Provider_Email
    if (selectedProvider.isEmpty && data['Assigned_Provider_Email'] != null) {
      String? providerEmail;
      final raw = data['Assigned_Provider_Email'];

      if (raw is List && raw.isNotEmpty) {
        providerEmail = raw[0]?.toString();
        if (providerEmail == null ||
            providerEmail.isEmpty ||
            providerEmail == emailRequester) {
          providerEmail =
          raw.length > 1 ? raw[1]?.toString() : null;
        }
      } else if (raw is String && raw.isNotEmpty && raw != emailRequester) {
        providerEmail = raw;
      }

      if (providerEmail != null && providerEmail.isNotEmpty) {
        final emp = employeeController.mapOfEmployeesWithEmailKey[providerEmail];
        if (emp != null) {
          selectedProvider = {
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
          firstName = emp.firstName ?? '';
          lastName = emp.lastName ?? '';
          firstNameAr = emp.firstNameInArabic ?? '';
          lastNameAr = emp.lastNameInArabic ?? '';
        }
      }
    }

    // Method 4: state array
    if (selectedProvider.isEmpty && data['state'] is List) {
      for (var s in (data['state'] as List)) {
        if (s is Map) {
          String? email = (s['providerEmail'] ?? s['assignedTo'] ?? s['provider'])?.toString();
          if (email != null && email.isNotEmpty && email != emailRequester) {
            final emp = employeeController.mapOfEmployeesWithEmailKey[email];
            if (emp != null) {
              selectedProvider = {
                'firstName': emp.firstName ?? '',
                'lastName': emp.lastName ?? '',
                'firstNameInArabic': emp.firstNameInArabic ?? '',
                'lastNameInArabic': emp.lastNameInArabic ?? '',
                'email': emp.email ?? '',
              };
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
        for (var approval in valueList) {
          if (approval is Map) {
            String? email =
            (approval['email'] ?? approval['approverEmail'])?.toString();
            if (email != null && email.isNotEmpty && email != emailRequester) {
              final emp = employeeController.mapOfEmployeesWithEmailKey[email];
              if (emp != null) {
                selectedProvider = {
                  'firstName': emp.firstName ?? '',
                  'lastName': emp.lastName ?? '',
                  'firstNameInArabic': emp.firstNameInArabic ?? '',
                  'lastNameInArabic': emp.lastNameInArabic ?? '',
                  'email': emp.email ?? '',
                };
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

    final name = (firstName.isNotEmpty || lastName.isNotEmpty)
        ? '$firstName $lastName'.trim()
        : 'N/A';

    return {
      'map': selectedProvider,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'firstNameArabic': firstNameAr,
      'lastNameArabic': lastNameAr,
    };
  }

  Map<String, dynamic>? _parseFirstJsonObject(String raw) {
    String json = raw.trim();
    if (json.startsWith('[')) json = json.substring(1, json.length - 1);

    int braceCount = 0, endIndex = -1;
    bool inString = false;

    for (int i = 0; i < json.length; i++) {
      final c = json[i];
      if (c == '"' && (i == 0 || json[i - 1] != '\\')) inString = !inString;
      if (!inString) {
        if (c == '{') braceCount++;
        if (c == '}') {
          braceCount--;
          if (braceCount == 0) {
            endIndex = i;
            break;
          }
        }
      }
    }

    if (endIndex <= 0) return null;
    try {
      return jsonDecode(json.substring(0, endIndex + 1)) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  double _toHours(double value, String unit) {
    return switch (unit) {
      'minutes' => value / 60,
      'hours'   => value,
      'days'    => value * 24,
      'weeks'   => value * 168,
      _         => 0,
    };
  }

  Future<Map<String, int>> _countDepartments() async {
    final firestore = FirebaseFirestore.instance;
    const knownDepartments = [
      "Operations", "Finance", "Sales", "Marketing", "Software",
    ];

    final Map<String, int> departmentCount = {
      for (var d in knownDepartments) d: 0,
      'Other': 0,
    };

    final querySnapshot = await firestore
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("Email_Requester", arrayContains: _currentUserEmail)
        .get();

    for (var doc in querySnapshot.docs) {
      try {
        final service = ServicesHistoryModel.fromJson(doc.data(), doc.id);
        for (var dept in service.currentSelectDepartment) {
          final normalized = dept.trim().toLowerCase();
          final match = knownDepartments.firstWhere(
                (k) => k.toLowerCase() == normalized,
            orElse: () => 'Other',
          );
          departmentCount[match] = departmentCount[match]! + 1;
        }
      } catch (e) {
      }
    }

    return departmentCount;
  }

  Map<String, int> _buildDeptBreakdown(
      Map<String, int> counts,
      MainCoreDepartmentController deptController,
      ) {
    final result = <String, int>{};
    for (var name in deptController.departmentsEnglishName) {
      result[name] = counts[name] ?? 0;
    }
    return result;
  }
}
