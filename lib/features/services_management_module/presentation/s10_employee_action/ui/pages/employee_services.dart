import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_app/core/custom/34-custom_gridview_with_animation.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/core/network/api_constants.dart';
import 'package:demo_app/core/widgets/app_search_text_field.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/core/widgets/services_management/custom_grid_view.dart';
import 'package:demo_app/features/services_management_module/data/helper/custom_table.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/export_file.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/info_text.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/controller/create_services_helper.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/custom_multi.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/request_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/reuse_text.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s10_employee_action/ui/pages/employee_details_services_toggle.dart';

class EmployeeServicesScreenTablet extends StatefulWidget {
  const EmployeeServicesScreenTablet({super.key});

  @override
  State<EmployeeServicesScreenTablet> createState() =>
      _EmployeeServicesScreenTabletState();
}

class _EmployeeServicesScreenTabletState
    extends State<EmployeeServicesScreenTablet> {
  // ─── UI State ────────────────────────────────────────────────────────────────
  bool isGridViewChoose = true;
  bool showFilter = false;

  // ✅ FIX 1: Stable key — never a localized string, works in any language
  String selectStatus = "all";

  // ✅ FIX 2: Loading flag — shows spinner while first Firestore fetch runs
  bool _isLoadingCache = true;

  // ─── Cache ───────────────────────────────────────────────────────────────────
  // ✅ FIX 3: Firestore is fetched ONCE and stored here.
  //           All filtering/searching/counting works from this list instantly.
  List<ServicesHistoryModel> _cachedAllServices = [];
  bool _isCacheLoaded = false;

  // ─── Displayed list ──────────────────────────────────────────────────────────
  List<ServicesHistoryModel> filteredModel = [];

  // ─── Counts (recalculated from cache — zero extra Firestore reads) ────────────
  int totalServices = 0;
  int pendingCount = 0;
  int approvedCount = 0;
  int cancelCount = 0;
  int rejectedCount = 0;
  int doneCount = 0;
  int inProgressCount = 0;
  int branchSlaCount = 0;

  // ─── Controllers ─────────────────────────────────────────────────────────────
  var employeeEntity = Get.find<MainCoreEmployeeController>().employeeEntity!;
  late final MainCoreDepartmentController departmentController;
  late final MainCoreEmployeeController employeeController;
  TextEditingController searchController = TextEditingController();
  Map<String, Map<String, dynamic>> selectedProviders = {};
  List<String> selectedDepartmentKeys = [];

  String get currentProviderEmail =>
      (employeeEntity.email ?? '').trim().toLowerCase();

  String extractValue(dynamic value) {
    if (value == null) return '';
    if (value is List) {
      if (value.isEmpty) return '';
      return value[0]?.toString() ?? '';
    }
    return value.toString();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 1 — Fetch from Firestore ONCE, enrich, and cache
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> _loadAndCacheServices() async {
    final currentEmail = (employeeEntity.email ?? '').trim().toLowerCase();
    if (currentEmail.isEmpty) {
      if (mounted) setState(() => _isLoadingCache = false);
      return;
    }

    final companyId = ApiConstants.baseUri.split("/").last;
    if (companyId.isEmpty) {
      if (mounted) setState(() => _isLoadingCache = false);
      return;
    }

    try {
      final allDocsSnapshot = await FirebaseFirestore.instance
          .collection('Demo')
          .doc(companyId)
          .collection('RequestServices')
          .get();

      if (allDocsSnapshot.docs.isEmpty) {
        if (mounted) {
          setState(() {
            _cachedAllServices = [];
            _isCacheLoaded = true;
            _isLoadingCache = false;
          });
        }
        return;
      }

      final assignedServices = <ServicesHistoryModel>[];

      for (final doc in allDocsSnapshot.docs) {
        final data = doc.data();
        try {
          // ── Check assigned provider email ──────────────────────────────────
          dynamic assignedRaw = data['assignedProviderEmail'] ??
              data['Assigned_Provider_Email'] ??
              data['AssignedProviderEmail'];

          String assignedEmail = '';
          if (assignedRaw is List && assignedRaw.isNotEmpty) {
            assignedEmail =
                assignedRaw.first?.toString().trim().toLowerCase() ?? '';
          } else if (assignedRaw is String) {
            assignedEmail = assignedRaw.trim().toLowerCase();
          }

          if (assignedEmail.isEmpty || assignedEmail != currentEmail) continue;

          // ── Enrich with employee data from controller (no Firestore call) ──
          final requesterEmail =
          extractValue(data['Email_Requester']).isNotEmpty
              ? extractValue(data['Email_Requester'])
              : extractValue(data['emailRequester']).isNotEmpty
              ? extractValue(data['emailRequester'])
              : extractValue(data['email_requester']);

          if (requesterEmail.isNotEmpty) {
            final employee =
            employeeController.getLocaleEmployee(requesterEmail);
            if (employee != null) {
              final nameEn =
              "${employee.firstName ?? ''} ${employee.lastName ?? ''}"
                  .trim();
              final nameAr =
              "${employee.firstNameInArabic ?? ''} ${employee.lastNameInArabic ?? ''}"
                  .trim();
              data['First_Name_Requester'] = nameEn.split(' ').first;
              data['Last_Name_Requester'] =
                  nameEn.split(' ').skip(1).join(' ');
              data['First_Name_Requester_Arabic'] = nameAr.split(' ').first;
              data['Last_Name_Requester_Arabic'] =
                  nameAr.split(' ').skip(1).join(' ');
              data['Job_Title_Requester'] = employee.title ?? '';
              data['Job_Title_Requester_Arabic'] =
                  employee.titleInArabic ?? '';
              data['Department_Requester'] = employee.departmentId ?? '';
            }
          }

          // ── Fetch service name only if missing ─────────────────────────────
          final bool missingName =
              (data['Service_Name_English'] == null ||
                  data['Service_Name_English'].toString().isEmpty) &&
                  (data['Service_Name_Arabic'] == null ||
                      data['Service_Name_Arabic'].toString().isEmpty);

          if (missingName) {
            final parentServiceId = extractValue(data['Parent_Service_Id']);
            if (parentServiceId.isNotEmpty && requesterEmail.isNotEmpty) {
              final details =
              await CreateServicesHelper.getServiceDetailsFromCreateServices(
                parentServiceId: parentServiceId,
                emailRequester: requesterEmail,
              );
              data['Service_Name_English'] =
                  details['serviceNameEnglish'] ?? '-';
              data['Service_Name_Arabic'] =
                  details['serviceNameArabic'] ?? '-';
              data['Service_Description_English'] =
                  details['serviceDescriptionEnglish'] ?? '-';
              data['Service_Description_Arabic'] =
                  details['serviceDescriptionArabic'] ?? '-';
              data['Duration_Of_Services'] = details['duration'] ?? '-';
              data['Selected_Duration_Unit'] = details['unit'] ?? '-';
            } else {
              continue;
            }
          }

          // ── Skip if still no name ──────────────────────────────────────────
          if ((data['Service_Name_English'] == null ||
              data['Service_Name_English'].toString().isEmpty) &&
              (data['Service_Name_Arabic'] == null ||
                  data['Service_Name_Arabic'].toString().isEmpty)) {
            continue;
          }

          assignedServices.add(ServicesHistoryModel.fromJson(data, doc.id));
        } catch (e, stack) {
        }
      }

      // ── Store in cache ────────────────────────────────────────────────────
      _cachedAllServices = assignedServices;
      _isCacheLoaded = true;

      // ── Counts from cache — instant, zero Firestore ───────────────────────
      _recalculateCounts();

      // ── Apply initial filter ──────────────────────────────────────────────
      _applyFilterFromCache();

      if (mounted) setState(() => _isLoadingCache = false);
    } catch (e, stack) {
      if (mounted) setState(() => _isLoadingCache = false);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 2 — Filter instantly from cache (no Firestore, no async)
  // ═══════════════════════════════════════════════════════════════════════════
  void _filterServices() {
    if (!_isCacheLoaded) return;
    _applyFilterFromCache();
  }

  void _applyFilterFromCache() {
    final searchQuery = searchController.text.trim().toLowerCase();
    final selectedDeptKeys = selectedDepartmentKeys
        .map((k) => k.trim().toLowerCase())
        .where((k) => k.isNotEmpty)
        .toSet();

    const allowedStatuses = {
      'done', 'approved', 'inprogress', 'branchsla',
      'breached sla', 'cancel', 'pending', 'rejected',
    };

    final result = _cachedAllServices.where((service) {
      final nameEn = service.currentServiceNameEnglish.toLowerCase();
      final nameAr = service.currentServiceNameArabic.toLowerCase();
      final matchesQuery = searchQuery.isEmpty ||
          nameEn.contains(searchQuery) ||
          nameAr.contains(searchQuery);

      final internalStatus = getFinalStateFromModel(service);
      final isAllowed =
      allowedStatuses.contains(internalStatus.toLowerCase());
      final matchesStatus = _isStatusMatch(
        internalStatus: internalStatus,
        selectedKey: selectStatus,
      );

      bool matchesDept = true;
      if (selectedDeptKeys.isNotEmpty) {
        final serviceDeptKeys =
        service.currentSelectDepartment
            .map((d) => d.toLowerCase().trim())
            .toSet();
        matchesDept =
            serviceDeptKeys.intersection(selectedDeptKeys).isNotEmpty;
      }

      return matchesQuery && isAllowed && matchesStatus && matchesDept;
    }).toList();

    _sortByCustomStatus(result);
    if (mounted) setState(() => filteredModel = result);
  }

  // ── Recalculate counts from cache — instant ──────────────────────────────────
  void _recalculateCounts() {
    doneCount = 0;
    approvedCount = 0;
    inProgressCount = 0;
    branchSlaCount = 0;
    cancelCount = 0;
    pendingCount = 0;
    rejectedCount = 0;

    for (final s in _cachedAllServices) {
      switch (getFinalStateFromModel(s).toLowerCase()) {
        case 'done':          doneCount++;         break;
        case 'approved':      approvedCount++;     break;
        case 'inprogress':    inProgressCount++;   break;
        case 'branchsla':
        case 'breached sla':  branchSlaCount++;    break;
        case 'cancel':        cancelCount++;       break;
        case 'pending':       pendingCount++;      break;
        case 'rejected':      rejectedCount++;     break;
      }
    }
    totalServices = doneCount + approvedCount + inProgressCount + cancelCount;
    if (mounted) setState(() {});
  }

  // ─── Status helpers ───────────────────────────────────────────────────────────
  // ✅ FIX 1: Compare using stable key — not localized label
  bool _isStatusMatch({
    required String internalStatus,
    required String selectedKey,
  }) {
    if (selectedKey == "all") return true;
    return internalStatus.toLowerCase().trim() ==
        selectedKey.toLowerCase().trim();
  }

  String getFinalStateFromModel(ServicesHistoryModel service) {
    final stateField = service.currentState.toLowerCase();
    if (['cancel', 'inprogress', 'done', 'branchsla', 'breached sla']
        .contains(stateField)) return stateField;

    final approvalCycle = service.currentApprovalCycle;
    if (approvalCycle.isEmpty) {
      if (stateField.isEmpty || stateField == 'pending') return 'approved';
      return stateField.isEmpty ? 'approved' : stateField;
    }

    final states = approvalCycle
        .where((e) => e.state != null && e.state!.isNotEmpty)
        .map((e) => e.state!.toLowerCase())
        .toList();

    if (states.contains('cancel')) return 'cancel';
    if (states.contains('rejected')) return 'rejected';
    if (states.every((s) => s == 'approved') && states.isNotEmpty)
      return 'approved';
    if (states.contains('pending')) return 'pending';
    if (stateField.isNotEmpty) return stateField;
    return 'approved';
  }

  int _statusRank(String status) {
    switch (status.toLowerCase()) {
      case 'done':          return 0;
      case 'approved':      return 1;
      case 'inprogress':    return 2;
      case 'branchsla':
      case 'breached sla':  return 3;
      case 'cancel':        return 4;
      default:              return 999;
    }
  }

  void _sortByCustomStatus(List<ServicesHistoryModel> list) {
    list.sort((a, b) {
      final ra = _statusRank(getFinalStateFromModel(a));
      final rb = _statusRank(getFinalStateFromModel(b));
      if (ra != rb) return ra.compareTo(rb);
      final ta = a.currentDurationOfServicesTimestamp.toDate();
      final tb = b.currentDurationOfServicesTimestamp.toDate();
      return tb.compareTo(ta);
    });
  }

  String getLocalizedStatus(BuildContext context, String status) {
    final s = S.of(context);
    switch (status.toLowerCase()) {
      case 'done':
        try { return s.Done; } catch (_) { return 'تم'; }
      case 'approved':      return s.Approved;
      case 'inprogress':    return s.Inprogress;
      case 'branchsla':
      case 'breached sla':  return s.BreachedSLA;
      case 'cancel':        return s.Canceled;
      case 'pending':       return s.status_pending;
      case 'rejected':      return s.status_rejected;
      default:              return status;
    }
  }

  String getLocalizedTimeUnit(String unit, BuildContext context) {
    final s = S.of(context);
    switch (unit.toLowerCase()) {
      case 'minutes': return s.minutes;
      case 'hours':   return s.hours;
      case 'days':    return s.days;
      case 'weeks':   return s.week;
      default:        return unit;
    }
  }

  bool isTabletLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width >= 600 &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  String formatStartDate(dynamic v) {
    if (v == null) return '-';
    DateTime date;
    if (v is Timestamp) {
      date = v.toDate();
    } else if (v is DateTime) {
      date = v;
    } else {
      return '-';
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  // ─── Init / Dispose ───────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    employeeController = Get.find<MainCoreEmployeeController>();
    departmentController = Get.find<MainCoreDepartmentController>();
    searchController.addListener(_filterServices);

    // ✅ Single Firestore call — everything else is instant from cache
    _loadAndCacheServices();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final visible =
    filteredModel.where((m) => m.currentProviderServices.isNotEmpty).toList();
    final gridViewVisible = filteredModel.where((m) {
      if (m.currentProviderServices.isEmpty) return false;
      final state = getFinalStateFromModel(m).toLowerCase();
      return state == 'approved' || state == 'inprogress' || state == 'done' || state == 'cancel' ;
    }).toList();

    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isMobile = context.isPhone;

    return Scaffold(
      body: SafeArea(
        child: SideFrameMasterServices(
          titleText: S.of(context).service,
          onFirstTap: () => navigateTo(context, LayoutScreenServices()),
          secondTitle: S.of(context).requestedServices,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                filterSection(),
                SizedBox(height: 15.sp),
                Row(
                  children: [
                    AppSearchTextField(
                      controller: searchController,
                      onChanged: (_) => _filterServices(),
                    ),
                  ],
                ),
                SizedBox(height: 10.sp),
                if (!isMobile)
                  Row(
                    children: [
                      const Spacer(),
                      // ── Export ────────────────────────────────────────────
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => ExportDialog(
                            filteredModel: visible,
                            selectedProviders: selectedProviders,
                            formatStartDate: formatStartDate,
                          ),
                        ),
                        child: Container(
                          width: isTabletLandscape(context) ? 100.sp : 38.sp,
                          height: 38.sp,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/export.svg",
                                width: 18.sp, height: 18.sp,
                                fit: BoxFit.fill,
                                color: AppColors.textButton,
                                semanticsLabel: 'Export',
                              ),
                              if (isTabletLandscape(context)) ...[
                                SizedBox(width: 8.sp),
                                Text(S.of(context).export,
                                    style: AppTextStyles.font18BlackMediumCairo
                                        .copyWith(color: AppColors.textButton)),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15.sp),
                      // ── Table view ────────────────────────────────────────
                      GestureDetector(
                        onTap: () => setState(() => isGridViewChoose = false),
                        child: Container(
                          width: 38.sp, height: 38.sp,
                          decoration: BoxDecoration(
                            color: isGridViewChoose
                                ? (lightMode ? AppColors.white : AppColors.chatBackground)
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/tableView.svg",
                              width: 18.sp, height: 18.sp, fit: BoxFit.fill,
                              color: !isGridViewChoose
                                  ? AppColors.textButton
                                  : (lightMode ? AppColors.secondaryText : AppColors.grey),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.sp),
                      // ── Grid view ─────────────────────────────────────────
                      GestureDetector(
                        onTap: () => setState(() => isGridViewChoose = true),
                        child: Container(
                          width: 38.sp, height: 38.sp,
                          decoration: BoxDecoration(
                            color: isGridViewChoose
                                ? AppColors.primary
                                : (lightMode ? AppColors.white : AppColors.chatBackground),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/gridView.svg",
                              width: 18.sp, height: 18.sp, fit: BoxFit.fill,
                              color: isGridViewChoose
                                  ? AppColors.textButton
                                  : (lightMode ? AppColors.secondaryText : AppColors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (!isGridViewChoose) SizedBox(height: 20.sp),

                // ── Content area ───────────────────────────────────────────
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ✅ Loading spinner while cache is building
                    if (_isLoadingCache)
                      Padding(
                        padding: EdgeInsets.only(top: 80.sp),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    else if (isGridViewChoose && filteredModel.isEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/lottie/empty.json',
                            width: isMobile ? 200.w : 400.w, height: isMobile ? 200.w : 400.h,
                            fit: BoxFit.fill,
                            repeat: true, animate: true,
                          ),
                        ],
                      )
                    else if (!isGridViewChoose && visible.isEmpty)
                        const SizedBox()
                      else
                        isGridViewChoose
                            ? AnimatedCustomGridView(
                          itemCount: gridViewVisible.length,
                          crossAxisCount: CrossAxisCountHelperResponsive
                              .getCrossAxisCountForDefaultTabletResponsive(context),
                          mainAxisExtent: 260.sp,
                          mainAxisSpacing: 15.sp,
                          crossAxisSpacing: 15.sp,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          animationDuration: const Duration(milliseconds: 600),
                          staggerDelay: const Duration(milliseconds: 100),
                          curve: Curves.easeOutCubic,
                          itemBuilder: (context, index) {
                            final service = gridViewVisible[index];
                            final internalStatus = getFinalStateFromModel(service);
                            final localizedStatus =
                            getLocalizedStatus(context, internalStatus);

                            // Department from controller — no Firestore
                            final requesterEmail =
                                service.currentEmailRequester ?? '';
                            String departmentName = '-';
                            if (requesterEmail.isNotEmpty) {
                              final emp = employeeController
                                  .getLocaleEmployee(requesterEmail);
                              if (emp != null &&
                                  emp.departmentId != null &&
                                  emp.departmentId!.isNotEmpty) {
                                final isAr = Localizations.localeOf(context)
                                    .languageCode == 'ar';
                                departmentName = isAr
                                    ? (departmentController
                                    .getArabicDepartmentNameFromDepartmentId(
                                    departmentId: emp.departmentId!) ?? '-')
                                    : (departmentController
                                    .getEnglishDepartmentNameFromDepartmentId(
                                    departmentId: emp.departmentId!) ?? '-');
                              }
                            }

                            final isAr = Localizations.localeOf(context)
                                .languageCode == 'ar';

                            return GestureDetector(
                              onTap: () => navigateTo(
                                context,
                                EmployeeDetailsServicesToggle(
                                  index: filteredModel.indexOf(service),
                                  approvalModel: service,
                                ),
                              ),
                              child: ServiceCard(
                                department: departmentName,
                                jobTitle: isAr
                                    ? service.currentJobTitleRequesterArabic
                                    : service.currentJobTitleRequester,
                                title: isAr
                                    ? service.currentServiceNameArabic
                                    : service.currentServiceNameEnglish,
                                serviceRequestor: isAr
                                    ? "${service.currentFirstNameRequesterArabic} ${service.currentLastNameRequesterArabic}"
                                    : "${service.currentFirstNameRequester} ${service.currentLastNameRequester}",
                                requestedDate: DateFormat('dd MMM yyyy').format(
                                    service.currentDurationOfServicesTimestamp
                                        .toDate()),
                                durationServices:
                                "${service.currentDurationOfServices} ${getLocalizedTimeUnit(service.currentSelectedDurationUnit, context)}",
                                status: internalStatus,
                                localizedStatus: localizedStatus,
                              ),
                            );
                          },
                        )
                            : ServicesTableWidget(
                          services: visible,
                          locale: Localizations.localeOf(context).languageCode,
                          onRowTap: (service) => navigateTo(
                            context,
                            EmployeeDetailsServicesToggle(
                              index: filteredModel
                                  .indexOf(service as ServicesHistoryModel),
                              approvalModel: service as ServicesHistoryModel,
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Filter chips ─────────────────────────────────────────────────────────────
  Widget filterSection() {
    final s = S.of(context);
    String getDoneLabel() {
      try { return s.Done; } catch (_) { return 'تم'; }
    }
    final doneLabel = getDoneLabel();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _statusChip("$totalServices", s.all,
              statusKey: "all",
              isSelected: selectStatus == "all",
              labelColor: Theme.of(context).brightness == Brightness.light
                  ? AppColors.secondaryText
                  : AppColors.grey),
          _statusChip("$doneCount", doneLabel,
              statusKey: "done",
              isSelected: selectStatus == "done",
              labelColor: AppColors.lightGreen),
          _statusChip("$approvedCount", s.Approved,
              statusKey: "approved",
              isSelected: selectStatus == "approved",
              labelColor: AppColors.lightGreen),
          _statusChip("$inProgressCount", s.Inprogress,
              statusKey: "inprogress",
              isSelected: selectStatus == "inprogress",
              labelColor: AppColors.yellow),
          _statusChip("$branchSlaCount", s.BreachedSLA,
              statusKey: "breached sla",
              isSelected: selectStatus == "breached sla",
              labelColor: AppColors.darkRed!),
          _statusChip("$cancelCount", s.Canceled,
              statusKey: "cancel",
              isSelected: selectStatus == "cancel",
              labelColor: AppColors.red!),
        ],
      ),
    );
  }

  // ✅ statusKey is saved to selectStatus — display label is separate
  Widget _statusChip(
      String count,
      String label, {
        required String statusKey,
        required bool isSelected,
        required Color labelColor,
      }) {
    final light = Theme.of(context).brightness == Brightness.light;
    final isMobile = context.isPhone;

    return GestureDetector(
      onTap: () {
        setState(() => selectStatus = statusKey); // ✅ stable key
        _filterServices();                        // ✅ instant from cache
      },
      child: Row(
        children: [
          Container(
            width: isMobile ? 35.sp : 45.sp,
            height: isMobile ? 35.sp : 45.sp,
            decoration: BoxDecoration(
              color: light
                  ? (isSelected ? AppColors.primary : AppColors.white)
                  : (isSelected ? AppColors.primary : AppColors.chatBackground),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Text(
                count,
                style: (isMobile
                    ? AppTextStyles.font14BlackCairoRegular
                    : AppTextStyles.font20BlackCairoMedium)
                    .copyWith(
                  color: light
                      ? (isSelected ? AppColors.textButton : AppColors.secondaryText)
                      : (isSelected ? AppColors.textButton : AppColors.grey),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.sp),
          Text(
            label,
            style: (isMobile
                ? AppTextStyles.font14BlackSemiBoldCairo
                : AppTextStyles.font16BlackSemiBoldCairo)
                .copyWith(color: labelColor),
          ),
          SizedBox(width: 30.sp),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ServiceCard
// ═══════════════════════════════════════════════════════════════════════════════
class ServiceCard extends StatelessWidget {
  const ServiceCard({
    required this.title,
    required this.serviceRequestor,
    required this.requestedDate,
    required this.durationServices,
    required this.status,
    required this.localizedStatus,
    required this.department,
    required this.jobTitle,
    super.key,
  });

  final String title;
  final String serviceRequestor;
  final String requestedDate;
  final String durationServices;
  final String status;
  final String localizedStatus;
  final String department;
  final String jobTitle;

  Color _getBorderColor(String state) {
    switch (state.toLowerCase()) {
      case 'pending':       return const Color(0xFFFF814A);
      case 'done':
      case 'approved':      return const Color(0xFF4BB609);
      case 'rejected':      return AppColors.red!;
      case 'cancel':        return AppColors.darkRed!;
      case 'inprogress':    return const Color(0xFFFFCC00);
      case 'breached sla':  return const Color(0xFFB00020);
      default:              return AppColors.lightGrey!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 313.sp,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.white
            : AppColors.chatBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50.sp, height: 50.sp,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.secondaryButton
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/smallheadphone.svg",
                      width: 24.sp, height: 24.sp, fit: BoxFit.scaleDown,
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.blackButton
                          : AppColors.white,
                      semanticsLabel: 'Service Icon',
                    ),
                  ),
                ),
                SizedBox(width: 8.sp),
                // ✅ FIX: Expanded prevents overflow on any screen size
                Expanded(
                  child: Text(
                    FormatHelper.capitalize(title),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyles.font16BlackMediumCairo.copyWith(
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.blackButton
                          : AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.sp),
            textCorner(image: "assets/images/details/Calendar.svg",
                label: "${S.of(context).requestDate}: ",
                content: requestedDate, context: context),
            SizedBox(height: 11.sp),
            textCorner(image: "assets/person.svg",
                label: "${S.of(context).serviceRequester}: ",
                content: serviceRequestor, context: context),
            SizedBox(height: 11.sp),
            textCorner(image: "assets/images/details/Case.svg",
                label: "${S.of(context).department}: ",
                content: department, context: context),
            SizedBox(height: 11.sp),
            textCorner(image: "assets/images/details/Case.svg",
                label: "${S.of(context).jobTitle}: ",
                content: jobTitle, context: context),
            SizedBox(height: 11.sp),
            textCorner(image: "assets/images/details/Group 1000004482.svg",
                label: "${S.of(context).durationOfService}: ",
                content: durationServices, context: context),
            SizedBox(height: 11.sp),
            Row(
              children: [
                SvgPicture.asset("assets/status.svg",
                    width: 12.sp, height: 12.sp, fit: BoxFit.fill,
                    semanticsLabel: 'Status Icon'),
                SizedBox(width: 8.sp),
                Text(
                  FormatHelper.capitalize("${S.of(context).Status}: "),
                  style: AppTextStyles.font14BlackCairoRegular.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.secondaryText
                        : AppColors.grey,
                  ),
                ),
                SizedBox(width: 4.sp),
                Text(
                  FormatHelper.capitalize(localizedStatus),
                  style: AppTextStyles.font14BlackCairoRegular.copyWith(
                      color: _getBorderColor(status)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CustomItemCard
// ═══════════════════════════════════════════════════════════════════════════════
class CustomItemCard extends StatelessWidget {
  const CustomItemCard({
    super.key,
    required this.iconLabel,
    required this.textLabel,
    this.imagePerson,
    required this.data,
  });

  final String iconLabel;
  final String textLabel;
  final String? imagePerson;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconLabel, semanticsLabel: 'Icon'),
        SizedBox(width: 6.w),
        Text(textLabel,
            style: AppTextStyles.font14BlackCairoMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.secondaryText
                  : AppColors.grey,
            )),
        if (imagePerson != null) ...[
          SizedBox(width: 6.w),
          Image(image: AssetImage(imagePerson!)),
          SizedBox(width: 4.w),
        ],
        SizedBox(width: 3.w),
        Text(data,
            style: AppTextStyles.font14BlackCairoRegular.copyWith(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.blackButton
                  : AppColors.white,
            )),
      ],
    );
  }
}
