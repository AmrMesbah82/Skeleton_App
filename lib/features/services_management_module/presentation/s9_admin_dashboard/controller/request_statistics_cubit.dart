/// ******************* FILE INFO *******************
/// File Name: dashboard_details_cubit.dart
/// Description: Business logic for Admin Dashboard Details page
/// Created by: Amr Mesbah
/// *************************************************

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/create_services_helper.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/controller/request_statistics_state.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';

const String _otherKey = "Other";

class DashboardDetailsCubit extends Cubit<DashboardDetailsState> {
  DashboardDetailsCubit() : super(DashboardDetailsState.initial());

  // ─── Public API ────────────────────────────────────────────────────────────

  Future<void> bootstrap({required String selectedServiceName}) async {
    emit(state.copyWith(bootstrapping: true));
    _initializeDepartmentData();
    try {
      await _loadFilteredItems(selectedServiceName: selectedServiceName);
      await Future.wait([
        _loadServiceStatusData(),
        _fetchMonthlyServiceCounts(selectedServiceName: selectedServiceName),
        _fetchDepartmentCounts(selectedServiceName: selectedServiceName),
      ]);
    } catch (e, st) {
    } finally {
      emit(state.copyWith(bootstrapping: false, bootstrapped: true));
    }
  }

  void toggleTab(bool showRequested) =>
      emit(state.copyWith(showRequestedServices: showRequested));

  void toggleChartMode(bool showCount, {required String selectedServiceName}) {
    emit(state.copyWith(showServiceCount: showCount, isLoading: true));
    if (showCount) {
      _fetchMonthlyServiceCounts(selectedServiceName: selectedServiceName);
    } else {
      _fetchMonthlyDurationInHours(selectedServiceName: selectedServiceName);
    }
  }

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
    emit(next);
    emit(next.copyWith(displayedItems: _computeDisplayedItems(next)));
  }

  void onSearchChanged(String query) {
    final next = state.copyWith(searchQuery: query);
    emit(next.copyWith(displayedItems: _computeDisplayedItems(next)));
  }

  // ─── Provider Stats (called from UI widgets) ───────────────────────────────

  List<String> getUniqueProviderNames(List<Map<String, dynamic>> items) {
    final Set<String> names = {};
    for (final item in items) {
      final provider = item['provider']?.toString() ?? '';
      if (provider.isNotEmpty) names.add(provider);
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

      final status = item['status']?.toString().toLowerCase() ?? '';
      if (status == 'done') done++;
      if (status == 'breached sla' || status == 'branchsla') breached++;

      final val = double.tryParse(item['duration']?.toString() ?? '0') ?? 0;
      final unit = item['unit']?.toString().toLowerCase() ?? 'minutes';
      totalMinutes += switch (unit) {
        'minutes' => val,
        'hours'   => val * 60,
        'days'    => val * 1440,
        'weeks'   => val * 10080,
        _         => 0,
      };

      name ??= item['provider'];
      department ??= item['department'];
      jobTitle ??= item['jobTitleRequester'];
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

  double getPercentage(String key) {
    final total = state.statusCounts.values.fold<int>(0, (a, b) => a + b);
    final value = state.statusCounts[key] ?? 0;
    return total == 0 ? 0.0 : (value / total) * 100.0;
  }

  Map<String, int> getTop5Departments() {
    final sorted = state.departmentCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted.take(5));
  }

  // ─── Initialization ────────────────────────────────────────────────────────

  void _initializeDepartmentData() {
    try {
      final departmentController = Get.find<MainCoreDepartmentController>();
      final Map<String, String> enToAr = {};
      final List<String> known = [];

      for (final id in departmentController.departmentIds) {
        final en = departmentController.getEnglishDepartmentNameFromDepartmentId(departmentId: id);
        final ar = departmentController.getArabicDepartmentNameFromDepartmentId(departmentId: id);
        if (en != null && ar != null) {
          enToAr[en] = ar;
          known.add(en);
        }
      }

      enToAr[_otherKey] = 'أخرى';

      emit(state.copyWith(enToArDepartments: enToAr, knownDepartments: known));
    } catch (e) {
      emit(state.copyWith(enToArDepartments: {_otherKey: 'أخرى'}, knownDepartments: []));
    }
  }

  // ─── Private: Data loading ─────────────────────────────────────────────────

  Future<void> _loadFilteredItems({required String selectedServiceName}) async {

    final firestore = FirebaseFirestore.instance;
    final employeeController = Get.find<MainCoreEmployeeController>();
    final departmentController = Get.find<MainCoreDepartmentController>();

    final snapshot = await firestore
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    final List<Map<String, dynamic>> results = [];

    for (int i = 0; i < snapshot.docs.length; i++) {
      final doc = snapshot.docs[i];
      final data = doc.data();
      final docId = doc.id;

      try {
        // ── Email_Requester ──────────────────────────────────────────────────
        final emailRequester = _extractValue(data['Email_Requester']);
        if (emailRequester.isEmpty) continue;

        // ── Service name ─────────────────────────────────────────────────────
        String serviceNameEn = _extractValue(data['Service_Name_English']);
        String serviceNameAr = _extractValue(data['Service_Name_Arabic']);
        final parentServiceId = _extractValue(data['Parent_Service_Id']);

        if ((serviceNameEn.isEmpty || serviceNameAr.isEmpty) && parentServiceId.isNotEmpty) {
          final details = await CreateServicesHelper.getServiceDetailsFromCreateServices(
            parentServiceId: parentServiceId,
            emailRequester: emailRequester,
          );
          if (serviceNameEn.isEmpty) serviceNameEn = details['serviceNameEnglish'] ?? '';
          if (serviceNameAr.isEmpty) serviceNameAr = details['serviceNameArabic'] ?? '';
        }

        if (serviceNameEn != selectedServiceName) continue;

        // ── Requester data ───────────────────────────────────────────────────
        final employee = employeeController.mapOfEmployeesWithEmailKey[emailRequester];
        if (employee == null) continue;

        final normalizedDepartment = (employee.departmentId?.isNotEmpty == true)
            ? (departmentController.getEnglishDepartmentNameFromDepartmentId(
            departmentId: employee.departmentId!) ??
            '')
            : '';

        // ── Provider data (5-method resolution) ─────────────────────────────
        final providerData = _resolveProvider(
          data: data,
          emailRequester: emailRequester,
          employeeController: employeeController,
        );
        final selectedProvider = providerData['map'] as Map<String, dynamic>;
        final firstNameProvider = providerData['firstName'] as String;
        final lastNameProvider = providerData['lastName'] as String;
        final firstNameProviderAr = providerData['firstNameArabic'] as String;
        final lastNameProviderAr = providerData['lastNameArabic'] as String;

        // ── Status ───────────────────────────────────────────────────────────
        final status = _resolveFinalState(data);

        // ── Timestamp ────────────────────────────────────────────────────────
        Timestamp requestTimestamp = Timestamp.now();
        final tsArray = data['timestamps'];
        if (tsArray is List && tsArray.isNotEmpty) {
          final ts = tsArray.last;
          if (ts is int) requestTimestamp = Timestamp.fromMillisecondsSinceEpoch(ts);
        }

        // ── Duration ─────────────────────────────────────────────────────────
        String durationStr = '0';
        String unit = 'minutes';
        if (parentServiceId.isNotEmpty) {
          final details = await CreateServicesHelper.getServiceDetailsFromCreateServices(
            parentServiceId: parentServiceId,
            emailRequester: emailRequester,
          );
          durationStr = details['duration'] ?? '0';
          unit = details['unit'] ?? 'minutes';
        }

        results.add({
          'no': results.length + 1,
          'department': normalizedDepartment,
          'serviceName': serviceNameEn,
          'serviceNameArabic': serviceNameAr,
          'gender': employee.gender ?? '',
          'requestor': '${employee.firstName ?? ''} ${employee.lastName ?? ''}'.trim(),
          'requestorArabic': '${employee.firstNameInArabic ?? ''} ${employee.lastNameInArabic ?? ''}'.trim(),
          'firstNameRequester': employee.firstName ?? '',
          'lastNameRequester': employee.lastName ?? '',
          'firstNameRequesterArabic': employee.firstNameInArabic ?? '',
          'lastNameRequesterArabic': employee.lastNameInArabic ?? '',
          'jobTitleRequester': employee.title ?? '',
          'jobTitleRequesterArabic': employee.titleInArabic ?? '',
          'requestDate': requestTimestamp,
          'status': status,
          'provider': '$firstNameProvider $lastNameProvider'.trim(),
          'firstNameProvider': firstNameProvider,
          'lastNameProvider': lastNameProvider,
          'firstNameProviderArabic': firstNameProviderAr,
          'lastNameProviderArabic': lastNameProviderAr,
          'docId': docId,
          'raw': data,
          'selectedProvider': selectedProvider,
          'duration': durationStr,
          'unit': unit,
        });

      } catch (e, st) {
      }
    }

    emit(state.copyWith(
      filteredItems: results,
      displayedItems: results,
    ));
  }

  Future<void> _loadServiceStatusData() async {
    final Map<String, int> counts = {
      'done': 0,
      'approved': 0,
      'pending': 0,
      'inprogress': 0,
      'branchsla': 0,
      'rejected': 0,
      'canceled': 0,
    };

    for (final item in state.filteredItems) {
      final status = item['status']?.toString().toLowerCase() ?? '';
      if (counts.containsKey(status)) counts[status] = (counts[status] ?? 0) + 1;
    }

    emit(state.copyWith(
      statusCounts: counts,
      isLoadingFirst: false,
    ));
  }

  Future<void> _fetchMonthlyServiceCounts({required String selectedServiceName}) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    final Map<int, double> counts = {for (int i = 0; i < 12; i++) i: 0};

    for (final doc in snapshot.docs) {
      try {
        final data = doc.data();
        String serviceNameEn = _extractValue(data['Service_Name_English']);

        if (serviceNameEn.isEmpty) {
          final parentServiceId = _extractValue(data['Parent_Service_Id']);
          final emailRequester = _extractValue(data['Email_Requester']);
          if (parentServiceId.isNotEmpty && emailRequester.isNotEmpty) {
            final details = await CreateServicesHelper.getServiceDetailsFromCreateServices(
              parentServiceId: parentServiceId,
              emailRequester: emailRequester,
            );
            serviceNameEn = details['serviceNameEnglish'] ?? '';
          }
        }

        if (serviceNameEn != selectedServiceName) continue;

        int? tsValue;
        final tsArray = data['timestamps'];
        if (tsArray is List && tsArray.isNotEmpty) {
          final last = tsArray.last;
          if (last is int) tsValue = last;
          else if (last is Timestamp) tsValue = last.millisecondsSinceEpoch;
          else if (last is String) tsValue = int.tryParse(last);
        }

        if (tsValue != null) {
          final month = DateTime.fromMillisecondsSinceEpoch(tsValue).month - 1;
          counts[month] = (counts[month] ?? 0) + 1;
        }
      } catch (e) {
      }
    }

    emit(state.copyWith(monthCounts: counts, isLoading: false));
  }

  Future<void> _fetchMonthlyDurationInHours({required String selectedServiceName}) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    final Map<int, num> hours = {for (int i = 0; i < 12; i++) i: 0};

    for (final doc in snapshot.docs) {
      try {
        final data = doc.data();
        String serviceNameEn = _extractValue(data['Service_Name_English']);

        if (serviceNameEn.isEmpty) {
          final parentServiceId = _extractValue(data['Parent_Service_Id']);
          final emailRequester = _extractValue(data['Email_Requester']);
          if (parentServiceId.isNotEmpty && emailRequester.isNotEmpty) {
            final details = await CreateServicesHelper.getServiceDetailsFromCreateServices(
              parentServiceId: parentServiceId,
              emailRequester: emailRequester,
            );
            serviceNameEn = details['serviceNameEnglish'] ?? '';
          }
        }

        if (serviceNameEn != selectedServiceName) continue;

        final parentServiceId = _extractValue(data['Parent_Service_Id']);
        final emailRequester = _extractValue(data['Email_Requester']);
        if (parentServiceId.isEmpty || emailRequester.isEmpty) continue;

        final details = await CreateServicesHelper.getServiceDetailsFromCreateServices(
          parentServiceId: parentServiceId,
          emailRequester: emailRequester,
        );

        final val = double.tryParse(details['duration'] ?? '') ?? 0;
        final unit = (details['unit'] ?? '').toLowerCase();
        if (val <= 0 || unit.isEmpty) continue;

        final h = switch (unit) {
          'minutes' => val / 60,
          'hours'   => val,
          'days'    => val * 24,
          'weeks'   => val * 168,
          _         => 0.0,
        };
        if (h <= 0) continue;

        int? tsValue;
        final tsArray = data['timestamps'];
        if (tsArray is List && tsArray.isNotEmpty) {
          final last = tsArray.last;
          if (last is int) tsValue = last;
        }
        if (tsValue == null) continue;

        final month = DateTime.fromMillisecondsSinceEpoch(tsValue).month - 1;
        hours[month] = (hours[month] ?? 0) + h;
      } catch (e) {
      }
    }

    emit(state.copyWith(monthHours: hours, isLoading: false));
  }

  Future<void> _fetchDepartmentCounts({required String selectedServiceName}) async {
    final employeeController = Get.find<MainCoreEmployeeController>();
    final departmentController = Get.find<MainCoreDepartmentController>();

    final snapshot = await FirebaseFirestore.instance
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .get();

    final Map<String, int> counts = {
      for (final dept in state.knownDepartments) dept: 0,
      _otherKey: 0,
    };

    for (final doc in snapshot.docs) {
      try {
        final data = doc.data();
        String serviceNameEn = _extractValue(data['Service_Name_English']);

        if (serviceNameEn.isEmpty) {
          final parentServiceId = _extractValue(data['Parent_Service_Id']);
          final emailRequester = _extractValue(data['Email_Requester']);
          if (parentServiceId.isNotEmpty && emailRequester.isNotEmpty) {
            final details = await CreateServicesHelper.getServiceDetailsFromCreateServices(
              parentServiceId: parentServiceId,
              emailRequester: emailRequester,
            );
            serviceNameEn = details['serviceNameEnglish'] ?? '';
          }
        }

        if (serviceNameEn != selectedServiceName) continue;

        final emailRequester = _extractValue(data['Email_Requester']);
        final employee = employeeController.mapOfEmployeesWithEmailKey[emailRequester];

        String dept = '';
        if (employee != null && employee.departmentId?.isNotEmpty == true) {
          dept = departmentController.getEnglishDepartmentNameFromDepartmentId(
              departmentId: employee.departmentId!) ??
              '';
        }

        final key = _normalizeDepartmentKey(dept);
        counts[key] = (counts[key] ?? 0) + 1;
      } catch (e) {
      }
    }

    emit(state.copyWith(departmentCounts: counts, isLoadingDepartments: false));
  }

  // ─── Private: Filter / search ──────────────────────────────────────────────

  List<Map<String, dynamic>> _computeDisplayedItems(DashboardDetailsState s) {
    final query = s.searchQuery.toLowerCase().trim();

    return s.filteredItems.where((item) {
      final matchesQuery = query.isEmpty ||
          [
            item['department'],
            item['serviceName'],
            item['serviceNameArabic'],
            item['requestor'],
            item['requestorArabic'],
            item['status'],
            item['provider'],
          ].join(' ').toLowerCase().contains(query);

      final matchesDept = s.activeDepartment == null ||
          s.activeDepartment!.isEmpty ||
          item['department'] == s.activeDepartment;

      final matchesStatus = s.activeStatus == null ||
          s.activeStatus!.isEmpty ||
          item['status']?.toString().toLowerCase() == s.activeStatus!.toLowerCase();

      final ts = item['requestDate'] as Timestamp;
      final modelDate = ts.toDate();
      final matchesDate = s.activeDate == null ||
          (modelDate.year == s.activeDate!.year &&
              modelDate.month == s.activeDate!.month &&
              modelDate.day == s.activeDate!.day);

      return matchesQuery && matchesDept && matchesStatus && matchesDate;
    }).toList();
  }

  // ─── Private: Provider resolution (5 methods, mirrors admin_cubit.dart) ────

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
      selectedProvider = map;
      firstName = map['firstName']?.toString() ?? '';
      lastName = map['lastName']?.toString() ?? '';
      firstNameAr = map['firstNameInArabic']?.toString() ?? '';
      lastNameAr = map['lastNameInArabic']?.toString() ?? '';
    }

    // Method 2: Provider_Services JSON
    if (selectedProvider.isEmpty && data['Provider_Services'] is List) {
      final list = data['Provider_Services'] as List;
      if (list.isNotEmpty) {
        final last = list.last;
        String? raw;
        if (last is String) raw = last;
        else if (last is Map) raw = jsonEncode(last);

        if (raw != null) {
          try {
            final decoded = jsonDecode(raw);
            Map<String, dynamic>? provMap;
            if (decoded is List && decoded.isNotEmpty) {
              provMap = Map<String, dynamic>.from(decoded.first as Map);
            } else if (decoded is Map) {
              provMap = Map<String, dynamic>.from(decoded);
            }
            if (provMap != null) {
              final email = provMap['email']?.toString() ?? provMap['providerEmail']?.toString() ?? '';
              final emp = email.isNotEmpty ? employeeController.mapOfEmployeesWithEmailKey[email] : null;
              if (emp != null) {
                selectedProvider = _buildProviderMap(emp);
                firstName = emp.firstName ?? '';
                lastName = emp.lastName ?? '';
                firstNameAr = emp.firstNameInArabic ?? '';
                lastNameAr = emp.lastNameInArabic ?? '';
              }
            }
          } catch (_) {}
        }
      }
    }

    // Method 3: Assigned_Provider_Email
    if (selectedProvider.isEmpty && data['Assigned_Provider_Email'] != null) {
      final assignedEmails = data['Assigned_Provider_Email'];
      String? providerEmail;
      if (assignedEmails is List && assignedEmails.isNotEmpty) {
        providerEmail = assignedEmails[0]?.toString();
        if (providerEmail == null || providerEmail.isEmpty || providerEmail == emailRequester) {
          if (assignedEmails.length > 1) providerEmail = assignedEmails[1]?.toString();
        }
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

    // Method 4: state array — scan providerEmail / assignedTo / provider fields
    if (selectedProvider.isEmpty && data['state'] is List) {
      final stateList = data['state'] as List;
      for (final entry in stateList) {
        if (entry is Map) {
          final email = (entry['providerEmail'] ?? entry['assignedTo'] ?? entry['provider'])?.toString() ?? '';
          if (email.isNotEmpty && email != emailRequester) {
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

    // Method 5: approvalCycle map
    if (selectedProvider.isEmpty && data['approvalCycle'] != null) {
      final cycle = data['approvalCycle'];
      List cycleList = [];
      if (cycle is List) cycleList = cycle;
      else if (cycle is Map) cycleList = [cycle];

      for (final entry in cycleList) {
        if (entry is Map) {
          final email = (entry['email'] ?? entry['approverEmail'])?.toString() ?? '';
          if (email.isNotEmpty && email != emailRequester) {
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

    // Safety: ensure gender key always exists
    if (!selectedProvider.containsKey('gender')) {
      selectedProvider['gender'] = '';
    }

    return {
      'map': selectedProvider,
      'firstName': firstName,
      'lastName': lastName,
      'firstNameArabic': firstNameAr,
      'lastNameArabic': lastNameAr,
      'name': '$firstName $lastName'.trim(),
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

  // ─── Private: State resolution ─────────────────────────────────────────────

  String _resolveFinalState(Map<String, dynamic> data) {
    const finalStates = [
      'done', 'inprogress', 'cancel', 'canceled', 'cancelled',
      'branchsla', 'breached sla', 'approved', 'pending', 'rejected',
    ];

    String _normalize(String s) {
      if (s == 'cancel' || s == 'cancelled') return 'canceled';
      return s;
    }

    // Step 1: outer state field
    String outerState = '';
    if (data['state'] is List) {
      final list = data['state'] as List;
      outerState = list.isNotEmpty ? (list.last?.toString().trim().toLowerCase() ?? '') : '';
    } else if (data['state'] != null) {
      outerState = data['state'].toString().trim().toLowerCase();
    }

    if (outerState.isNotEmpty && finalStates.contains(outerState)) {
      return _normalize(outerState);
    }

    // Step 2: Approval_Cycle JSON
    if (data['Approval_Cycle'] is List) {
      final approvalList = data['Approval_Cycle'] as List;
      if (approvalList.isNotEmpty && approvalList.last is String) {
        try {
          final decoded = jsonDecode(approvalList.last as String);
          List items = decoded is List ? decoded : (decoded is Map ? [decoded] : []);
          final states = items
              .map((e) => (e['state']?.toString().trim().toLowerCase() ?? ''))
              .where((s) => s.isNotEmpty)
              .toList();

          for (final priority in ['cancel', 'canceled', 'cancelled', 'rejected', 'done']) {
            if (states.contains(priority)) return _normalize(priority);
          }
          if (states.every((s) => s == 'approved')) return 'approved';
          if (states.contains('inprogress')) return 'inprogress';
          if (states.contains('pending')) return 'pending';
        } catch (_) {}
      }
    }

    // Step 3: Provider_Services JSON
    if (data['Provider_Services'] is List) {
      final list = data['Provider_Services'] as List;
      if (list.isNotEmpty && list.last is String) {
        try {
          final decoded = jsonDecode(list.last as String);
          List items = decoded is List ? decoded : (decoded is Map ? [decoded] : []);
          final states = items
              .map((e) => (e['state']?.toString().trim().toLowerCase() ?? ''))
              .where((s) => s.isNotEmpty)
              .toList();

          for (final priority in ['cancel', 'canceled', 'cancelled', 'rejected', 'done', 'inprogress', 'pending']) {
            if (states.contains(priority)) return _normalize(priority);
          }
        } catch (_) {}
      }
    }

    // Step 4: status field fallback
    if (data['status'] != null) {
      String statusField = '';
      if (data['status'] is List) {
        final list = data['status'] as List;
        statusField = list.isNotEmpty ? (list.last?.toString().trim().toLowerCase() ?? '') : '';
      } else {
        statusField = data['status'].toString().trim().toLowerCase();
      }
      if (statusField.isNotEmpty && finalStates.contains(statusField)) {
        return _normalize(statusField);
      }
    }

    return 'pending';
  }

  // ─── Private: Helpers ──────────────────────────────────────────────────────

  String _extractValue(dynamic value) {
    if (value == null) return '';
    if (value is List) return value.isEmpty ? '' : (value[0]?.toString() ?? '');
    return value.toString();
  }

  String _normalizeDepartmentKey(String? raw) {
    final dept = (raw ?? '').trim();
    if (dept.isEmpty) return _otherKey;

    final lower = dept.toLowerCase();
    for (final k in state.knownDepartments) {
      if (k.toLowerCase() == lower) return k;
    }

    try {
      final departmentController = Get.find<MainCoreDepartmentController>();
      final en = departmentController.getDepartmentEnglishNameFromArabicName(arabicName: dept);
      if (en != null && state.knownDepartments.contains(en)) return en;
    } catch (_) {}

    return _otherKey;
  }
}
