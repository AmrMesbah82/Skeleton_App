import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/widgets/approval_request_card.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_app/core/custom/34-custom_gridview_with_animation.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/14-custom_filter_icon.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';
import 'package:demo_app/core/widgets/services_management/custom_filter.dart';
import 'package:demo_app/core/widgets/services_management/custom_grid_view.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/widgets/services_management/search_widget.dart';
import 'package:demo_app/core/helper/services_management/sort.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/custom_multi.dart';
class ApprovalServices extends StatefulWidget {
  const ApprovalServices({super.key});
  @override
  State<ApprovalServices> createState() => _ApprovalServicesState();
}
class _ApprovalServicesState extends State<ApprovalServices> {
  bool isGridViewChoose = true;
  TextEditingController searchController = TextEditingController();
  String? selectedStatus;
  List<String> selectedDepartmentKeys = [];
  bool showFilter = false;
  String selectStatus = "All";
  List<ServicesHistoryModel> filteredModel = [];
  List<ServicesHistoryModel> unsortedCurrent = [];
  List<ServicesHistoryModel> visibleApprovals = [];
/////////////////////////////// My Action ///////////////////////////
  int myTotal = 0;
  int myPending = 0;
  int myApproved = 0;
  int myRejected = 0;
  int myCanceled = 0;
  late final MainCoreEmployeeController employeeController;
  late final MainCoreDepartmentController departmentController;

  String _sanitizeEmail(String email) {
    return email
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[\u200e\u200f\u202a\u202b\u202c\u202d\u202e\u2066\u2067\u2068\u2069]'), '');
  }

  bool _isMyTurn(List<EmployeeEntityModell> approvalList, String myEmail) {
    final idx = approvalList.indexWhere((e) => _sanitizeEmail(e.email ?? '') == _sanitizeEmail(myEmail)
    );

    if (idx == -1) {
      return false;
    }

    for (int i = 0; i < idx; i++) {
      final s = (approvalList[i].state ?? '').toLowerCase();

      if (['rejected', 'cancel'].contains(s)) {
        return false;
      }
      if (['pending', 'normal', ''].contains(s)) {
        return false;
      }
      if (s != 'approved') {
        return false;
      }
    }

    final myState = (approvalList[idx].state ?? '').toLowerCase();
    final result = ['pending', 'normal', ''].contains(myState);
    return result;
  }
  String _myEntryState(List<EmployeeEntityModell> approvalList, String myEmail) {
    final idx = approvalList.indexWhere((e) => _sanitizeEmail(e.email ?? '') == _sanitizeEmail(myEmail)
    );
    if (idx == -1) return '';
    final state = (approvalList[idx].state ?? '').toLowerCase();
    return state;
  }
  void _recountMyActionCounts() {
    final list = ServicesManagerCubit.get(context).myApproval;

    final myEmail = (employeeEntity.email ?? '').toLowerCase();

    int pending = 0, approved = 0, rejected = 0, canceled = 0;

    for (int i = 0; i < list.length; i++) {
      final service = list[i];

      final cycle = service.currentApprovalCycle;

      final hasMe = cycle.any((e) => _sanitizeEmail(e.email ?? '') == _sanitizeEmail(myEmail)
      );

      if (!hasMe) {
        continue;
      }

      final overallState = (service.currentState ?? '').toLowerCase();

      final myState = _myEntryState(cycle, myEmail);

      if (overallState == 'cancel') {
        canceled++;
        continue;
      }

      if (myState == 'approved') {
        approved++;
        continue;
      }
      if (myState == 'rejected') {
        rejected++;
        continue;
      }

      if (_isMyTurn(cycle, myEmail)) {
        pending++;
        continue;
      }

      final hasRejectionBeforeMe = () {
        final myIdx = cycle.indexWhere((e) => _sanitizeEmail(e.email ?? '') == _sanitizeEmail(myEmail)
        );
        if (myIdx == -1) return false;

        for (int i = 0; i < myIdx; i++) {
          if ((cycle[i].state ?? '').toLowerCase() == 'rejected') {
            return true;
          }
        }
        return false;
      }();

      if (hasRejectionBeforeMe && ['pending', 'normal', ''].contains(myState)) {
        continue;
      }

    }

    setState(() {
      myPending = pending;
      myApproved = approved;
      myRejected = rejected;
      myCanceled = canceled;
      myTotal = myPending + myApproved + myRejected + myCanceled;
    });
  }
  String _statusKey = 'all';
  String _statusKeyForLabel(BuildContext ctx, String label) {
    final s = S.of(ctx);
    final l = label.trim().toLowerCase();
    String result;
    if (l == 'all' || l == (s.all).trim().toLowerCase()) result = 'all';
    else if (l == 'approved' || l == (s.Approved).trim().toLowerCase()) result = 'approved';
    else if (l == 'pending' || l == (s.Pending).trim().toLowerCase()) result = 'pending';
    else if (l == 'rejected' || l == (s.Rejected).trim().toLowerCase()) result = 'rejected';
    else if (l == 'canceled' || l == 'cancelled' || l == (s.Canceled).trim().toLowerCase()) result = 'cancel';
    else result = 'all';

    return result;
  }
  void _filterServices() {
    final model = ServicesManagerCubit.get(context).myApproval;

    final currentUserEmail = (employeeEntity.email ?? '').toLowerCase();

    final query = searchController.text.toLowerCase().trim();

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

// ✅ Get department labels from controller
    final selectedDeptLabels = selectedDepartmentKeys.map((deptId) {
      final label = isArabic
          ? departmentController.getArabicDepartmentNameFromDepartmentId(departmentId: deptId)
          : departmentController.getEnglishDepartmentNameFromDepartmentId(departmentId: deptId);
      return (label ?? deptId).toLowerCase().trim();
    }).toSet();

    int passedCount = 0;
    int failedInCycle = 0;
    int failedStatus = 0;
    int failedDepartment = 0;
    int failedSearch = 0;

    final filtered = model.where((service) {
      final serviceId = service.currentId ?? 'no-id';
      final serviceName = service.currentServiceNameEnglish ?? service.currentServiceNameArabic ?? 'no-name';

      final approvalList = service.currentApprovalCycle;

      final myIndex = approvalList.indexWhere(
              (e) => (e.email ?? '').toLowerCase() == currentUserEmail
      );

      if (myIndex == -1) {
        failedInCycle++;
        return false;
      }

      final myState = _myEntryState(approvalList, currentUserEmail);
      final finalState = getFinalStateFromModel(service).toLowerCase();

      bool hasRejectionBeforeMe = false;
      for (int i = 0; i < myIndex; i++) {
        if ((approvalList[i].state ?? '').toLowerCase() == 'rejected') {
          hasRejectionBeforeMe = true;
          break;
        }
      }

      bool matchesChip;
      switch (_statusKey) {
        case 'all':
          matchesChip = (myState == 'approved' ||
              myState == 'rejected' ||
              _isMyTurn(approvalList, currentUserEmail) ||
              ['done', 'cancel', 'inprogress', 'branchsla', 'breached sla'].contains(finalState));
          break;

        case 'approved':
          matchesChip = (myState == 'approved');
          break;

        case 'rejected':
          matchesChip = (myState == 'rejected');
          break;

        case 'pending':
          matchesChip = _isMyTurn(approvalList, currentUserEmail) &&
              !hasRejectionBeforeMe &&
              ['pending', 'normal', ''].contains(myState);
          break;

        case 'cancel':
          matchesChip = (finalState == 'cancel');
          break;

        default:
          matchesChip = (finalState == _statusKey);
      }

      if (!matchesChip) {
        failedStatus++;
        return false;
      }

      // ✅ Get department from employee entity using email
      final requesterEmail = service.currentEmailRequester ?? '';
      String? departmentId;

      if (requesterEmail.isNotEmpty) {
        final employee = employeeController.getLocaleEmployee(requesterEmail);
        if (employee != null) {
          departmentId = employee.departmentId;
        }
      }

      bool matchesDepartment = true;

      if (selectedDeptLabels.isNotEmpty && departmentId != null && departmentId.isNotEmpty) {
        final deptLabel = isArabic
            ? departmentController.getArabicDepartmentNameFromDepartmentId(departmentId: departmentId)
            : departmentController.getEnglishDepartmentNameFromDepartmentId(departmentId: departmentId);

        final normalizedDeptLabel = (deptLabel ?? '').toLowerCase().trim();
        matchesDepartment = selectedDeptLabels.contains(normalizedDeptLabel);

      }

      if (!matchesDepartment) {
        failedDepartment++;
        return false;
      }

      final serviceNameEn = (service.currentServiceNameEnglish ?? '').toLowerCase().trim();
      final serviceNameAr = (service.currentServiceNameArabic ?? '').toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          serviceNameEn.contains(query) ||
          serviceNameAr.contains(query);

      if (!matchesSearch) {
        failedSearch++;
        return false;
      }

      passedCount++;
      return true;
    }).toList();

    setState(() {
      filteredModel = filtered;
      unsortedCurrent = List<ServicesHistoryModel>.from(filteredModel);

      List<ServicesHistoryModel> toDisplay = List<ServicesHistoryModel>.from(unsortedCurrent);

      if (selectedSortOption.isNotEmpty) {
        switch (selectedSortOption) {
          case 'Date Requested':
            toDisplay.sort((a, b) => _dateRequestedOf(a).compareTo(_dateRequestedOf(b)));
            break;
          case 'Duration':
            toDisplay.sort((a, b) => _modelDurationSeconds(a).compareTo(_modelDurationSeconds(b)));
            break;
          case 'Last Update':
            toDisplay.sort((a, b) => _lastUpdateOf(a).compareTo(_lastUpdateOf(b)));
            break;
        }
      }

      visibleApprovals = toDisplay;
    });

  }
  Future<void> _fetchServiceStateCounts(String currentUserEmail) async {
    final firestore = FirebaseFirestore.instance;
    final String targetEmail = currentUserEmail.trim().toLowerCase();
    final String tenantRoot = getBaseUrl(FirestoreCollections.requestServices);

    totalServices = pendingCount = approvedCount = cancelCount =
        doneCount = rejectedCount = inProgressCount = branchSlaCount = 0;

    List<List<String>> _extract(dynamic cycle, {String where = ''}) {
      final states = <String>[];
      final emails = <String>[];

      // Handle array of JSON strings (new format)
      if (cycle is List) {
        for (final item in cycle) {
          if (item is String) {
            try {
              final decoded = jsonDecode(item);
              if (decoded is List) {
                for (final emp in decoded) {
                  if (emp is Map) {
                    states.add((emp['state'] ?? '').toString().toLowerCase());
                    emails.add((emp['email'] ?? '').toString().toLowerCase());
                  }
                }
              }
            } catch (e) {
            }
          } else if (item is Map) {
            states.add((item['state'] ?? '').toString().toLowerCase());
            emails.add((item['email'] ?? '').toString().toLowerCase());
          }
        }
      }

      return [states, emails];
    }

    final userDocs = await firestore.collectionGroup('user').get();

    int seen = 0;
    int processedForTenant = 0;

    for (final d in userDocs.docs) {
      final path = d.reference.path;
      if (!path.startsWith('$tenantRoot/')) {
        continue;
      }

      seen++;
      processedForTenant++;
      final data = d.data();

      dynamic nested = data['approvalCycle'];

      final pair = _extract(nested, where: path);
      var states = pair[0];
      var emails = pair[1];

      final hasEmail = emails.any((e) => e == targetEmail);

      if (!hasEmail) {
        continue;
      }

      String finalState = '';
      final stateField = (data['state'] ?? '').toString().toLowerCase();

      if (stateField == 'done') finalState = 'done';
      if (finalState.isEmpty && stateField == 'cancel') finalState = 'cancel';
      if (finalState.isEmpty && ['inprogress', 'branchsla', 'breached sla'].contains(stateField)) {
        finalState = stateField;
      }

      if (finalState.isEmpty) {
        final filtered = states.where((s) => s.isNotEmpty && s != 'normal').toList();

        if (filtered.contains('cancel')) finalState = 'cancel';
        else if (filtered.contains('rejected')) finalState = 'rejected';
        else if (filtered.isNotEmpty && filtered.every((s) => s == 'approved')) finalState = 'approved';
        else if (filtered.contains('pending')) finalState = 'pending';

        final idx = emails.indexOf(targetEmail);
        bool includeForMe = false;
        const finalized = ['approved', 'rejected', 'cancel', 'inprogress', 'branchsla', 'breached sla', 'done'];

        if (finalized.contains(finalState)) {
          includeForMe = true;
        } else if (idx != -1) {
          includeForMe = true;
          for (int i = 0; i < idx; i++) {
            final prev = states[i];
            if (['rejected', 'cancel', 'pending', 'normal', ''].contains(prev)) {
              includeForMe = false;
              break;
            }
          }
        }

        if (!includeForMe) {
          continue;
        }
      } else {
        const finalized = ['approved', 'rejected', 'cancel', 'inprogress', 'branchsla', 'breached sla', 'done'];

        if (!finalized.contains(finalState)) {
          continue;
        }
      }

      switch (finalState) {
        case 'done': doneCount++; break;
        case 'approved': approvedCount++; break;
        case 'pending': pendingCount++; break;
        case 'rejected': rejectedCount++; break;
        case 'inprogress': inProgressCount++; break;
        case 'branchsla':
        case 'breached sla': branchSlaCount++; break;
        case 'cancel': cancelCount++; break;
      }

      if (['approved', 'pending', 'rejected', 'cancel'].contains(finalState)) {
        totalServices++;
      }

    }

    setState(() {});
  }
  @override
  void initState() {
    super.initState();
// ✅ Initialize controllers
    employeeEntity = Get.find<MainCoreEmployeeController>().employeeEntity!;
    employeeController = Get.find<MainCoreEmployeeController>();
    departmentController = Get.find<MainCoreDepartmentController>();

    searchController.addListener(() {
      _filterServices();
    });

    ServicesManagerCubit.get(context).getMyApprovalServices(employeeEntity.email).then((_) {
      final count = ServicesManagerCubit.get(context).myApproval.length;

      WidgetsBinding.instance.addPostFrameCallback((_) {

        final model = ServicesManagerCubit.get(context).myApproval;

        if (model.isEmpty) {
        } else {
          for (int i = 0; i < model.length; i++) {
            final s = model[i];
            final id = s.currentId;
            final name = s.currentServiceNameEnglish ?? s.currentServiceNameArabic ?? 'no-name';
            final raw = getFinalStateFromModel(s);
            final loc = getLocalizedStatus(raw);
          }
        }

        _recountMyActionCounts();
        _filterServices();
      });
    }).catchError((error, stackTrace) {
    });
  }
  String getLocalizedStatus(String status) {
    final result = switch (status.toLowerCase()) {
      'done' => S.of(context).Done,
      'approved' => S.of(context).Approved,
      'pending' => S.of(context).Pending,
      'rejected' => S.of(context).Rejected,
      'cancel' => S.of(context).Canceled,
      'inprogress' => S.of(context).Inprogress,
      'branchsla' || 'breached sla' => S.of(context).BreachedSLA,
      _ => S.of(context).Pending,
    };
    return result;
  }
  int totalServices = 0;
  int doneCount = 0;
  int pendingCount = 0;
  int approvedCount = 0;
  int cancelCount = 0;
  int rejectedCount = 0;
  int inProgressCount = 0;
  int branchSlaCount = 0;
  String getFinalStateFromModel(ServicesHistoryModel service) {
    final stateField = (service.currentState ?? '').toString().toLowerCase();
    if (stateField == 'done') {
      return 'done';
    }

    if (stateField == 'cancel') {
      return 'cancel';
    }

    if (['inprogress', 'branchsla', 'breached sla'].contains(stateField)) {
      return stateField;
    }

    final cycle = service.currentApprovalCycle;
    final states = cycle
        .map((e) => (e.state ?? '').toLowerCase())
        .where((s) => s.isNotEmpty && s != 'normal')
        .toList();

    if (states.contains('cancel')) return 'cancel';
    if (states.contains('rejected')) return 'rejected';
    if (states.isNotEmpty && states.every((s) => s == 'approved')) return 'approved';
    if (states.contains('pending')) return 'pending';

    return stateField.isNotEmpty ? stateField : 'pending';
  }
  String? selectedDurationUnit;
  bool isTabletLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return size.width >= 600 && isLandscape;
  }
  int _ms(int? timestamp) => timestamp ?? 0;
  DateTime _dateRequestedOf(ServicesHistoryModel m) {
    if (m.timestamps.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.fromMillisecondsSinceEpoch(m.timestamps.first);
  }
  DateTime _lastUpdateOf(ServicesHistoryModel m) {
    if (m.timestamps.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.fromMillisecondsSinceEpoch(m.timestamps.last);
  }
  double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
  int _modelDurationSeconds(ServicesHistoryModel m) {
    final value = _toDouble(m.currentDurationOfServices);
    final unit = (m.currentSelectedDurationUnit ?? '').toLowerCase().trim();
    if (unit.startsWith('s')) return (value).round();
    if (unit.startsWith('min')) return (value * 60).round();
    if (unit == 'm') return (value * 60).round();
    if (unit.startsWith('h')) return (value * 3600).round();
    if (unit.startsWith('d')) return (value * 86400).round();
    if (unit.startsWith('w')) return (value * 604800).round();

    return (value * 60).round();
  }
  List<ServicesHistoryModel> originalList = [];
  void sortServices() {
    setState(() {
      if (selectedSortOption.isEmpty) {
        visibleApprovals = List<ServicesHistoryModel>.from(unsortedCurrent);
        return;
      }

      final toDisplay = List<ServicesHistoryModel>.from(unsortedCurrent);

      switch (selectedSortOption) {
        case 'Date Requested':
          toDisplay.sort((a, b) => _dateRequestedOf(a).compareTo(_dateRequestedOf(b)));
          break;
        case 'Duration':
          toDisplay.sort((a, b) => _modelDurationSeconds(a).compareTo(_modelDurationSeconds(b)));
          break;
        case 'Last Update':
          toDisplay.sort((a, b) => _lastUpdateOf(a).compareTo(_lastUpdateOf(b)));
          break;
      }

      visibleApprovals = toDisplay;
    });
  }
  String getLocalizedDurationUnit(BuildContext context, String key) {
    final localizer = S.of(context);
    switch (key.toLowerCase()) {
      case "hours":
        return localizer.hours;
      case "minutes":
        return localizer.minutes;
      case "week":
        return localizer.week;
      case "seconds":
        return localizer.seconds;
      default:
        return key;
    }
  }
  String? idSelect;
  String? selectServicesName;
  bool isApproved = false;
  bool isRejected = false;
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }
  String selectedSortOption = 'Date Requested';
  String userEmail = '';
  String userDepartment = '';
  List<ServicesHistoryModel> filteredServices = [];
  bool isFilterDialogOpen = false;
  String selectDepartment = "";
  final Map<String, String> approvalStateMap = {};
  String? selectedDepartmentKey;
  var employeeEntity = Get.find<MainCoreEmployeeController>().employeeEntity!;
  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final brightness = Theme.of(context).brightness;
    var lightMode = Theme.of(context).brightness == Brightness.light;
    final isTablet = context.isTablet;
    final isMobile = context.isPhone;
    final isLandscape = context.isLandscape;

    return Scaffold(
      body: SafeArea(
        child: SideFrameMasterServices(
          titleText: S.of(context).services,
          onFirstTap: () {
            navigateTo(context, LayoutScreenServices());
          },
          secondTitle: S.of(context).approvals,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               isMobile ? SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: DepartmentFilterChips(
                   selectedKey: selectStatus,
                   onSelected: (status) {
                     setState(() {
                       selectStatus = status.trim();
                       _statusKey = _statusKeyForLabel(context, status);
                     });
                     _filterServices();
                     _recountMyActionCounts();
                   },
                   totalCount: myTotal,
                   departmentCounts: {
                     S.of(context).Approved: myApproved,
                     S.of(context).Pending: myPending,
                     S.of(context).Rejected: myRejected,
                     S.of(context).Canceled: myCanceled,
                   },
                   labelColors: {
                     S.of(context).Approved: AppColors.lightGreen,
                     S.of(context).Pending: AppColors.orange,
                     S.of(context).Rejected: AppColors.red,
                     S.of(context).Canceled: AppColors.darkRed!,
                   },
                   userDepartment: '',
                   isArabic: isArabic,
                 ),
               ):
               DepartmentFilterChips(
                  selectedKey: selectStatus,
                  onSelected: (status) {
                    setState(() {
                      selectStatus = status.trim();
                      _statusKey = _statusKeyForLabel(context, status);
                    });
                    _filterServices();
                    _recountMyActionCounts();
                  },
                  totalCount: myTotal,
                  departmentCounts: {
                    S.of(context).Approved: myApproved,
                    S.of(context).Pending: myPending,
                    S.of(context).Rejected: myRejected,
                    S.of(context).Canceled: myCanceled,
                  },
                  labelColors: {
                    S.of(context).Approved: AppColors.lightGreen,
                    S.of(context).Pending: AppColors.orange,
                    S.of(context).Rejected: AppColors.red,
                    S.of(context).Canceled: AppColors.darkRed!,
                  },
                  userDepartment: '',
                  isArabic: isArabic,
                ),

                SizedBox(height: 15.h),

                Row(
                  children: [
                    AppSearchTextField(
                        controller: searchController,
                        onChanged: (text) {
                          _filterServices();
                        }
                    ),

                    SizedBox(width: 9.sp),

                    if (!isMobile)
                      DepartmentMultiSelectPage(
                        selectedKeys: selectedDepartmentKeys,
                        onChanged: (keys) {
                          setState(() => selectedDepartmentKeys = keys);
                          _filterServices();
                        },
                      ),

                    if (!isMobile) SizedBox(width: 9.sp),

                    if (!isMobile)
                      SortDropdownMenu(
                        selectedOption: selectedSortOption,
                        onSortSelected: (value) {
                          setState(() => selectedSortOption = value);
                          sortServices();
                        },
                        isMobile: isMobile,
                        isTabletLandscape: isTabletLandscape(context),
                      ),

                    if (isMobile)
                      CustomFilterIcon(
                        color: AppColors.card,
                        borderColor: Colors.transparent,
                        svgColor: AppColors.secondaryText,
                        title: '',
                        onTap: () {},
                      ),
                  ],
                ),

                SizedBox(height: 15.h),

                visibleApprovals.isEmpty
                    ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lottie/empty.json',
                          width: 260.sp,
                          height: 260.sp,
                          fit: BoxFit.contain,
                          repeat: true,
                          animate: true,
                        ),
                      ],
                    ))
                    : AnimatedCustomGridView(
                  itemCount: visibleApprovals.length,
                  crossAxisCount: CrossAxisCountHelperResponsive.getCrossAxisCountForDefaultTabletResponsive(context),
                  mainAxisExtent: 245.sp,
                  mainAxisSpacing: 15.sp,
                  crossAxisSpacing: 15.sp,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  margin: EdgeInsets.only(bottom: 16.sp),
                  animationDuration: const Duration(milliseconds: 800),
                  staggerDelay: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  itemBuilder: (context, index) {
                    final service = visibleApprovals[index];
                    final raw = getFinalStateFromModel(service);
                    final loc = getLocalizedStatus(raw);

                    return ApprovalRequestCard(
                      key: ValueKey(service.currentId),
                      service: service,
                      onRefresh: () async {

                        await ServicesManagerCubit.get(context)
                            .getMyApprovalServices(employeeEntity.email!);

                        await _fetchServiceStateCounts(employeeEntity.email!);

                        _filterServices();

                        _recountMyActionCounts();

                      },
                      isMobile: isMobile,
                      isTablet: isTablet,
                      isLandscape: isLandscape,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
