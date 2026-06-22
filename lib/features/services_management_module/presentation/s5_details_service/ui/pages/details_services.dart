import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/employees_tab_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/export.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/filter.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/helper_method.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/info_text.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/requested_services_tab_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/service_header_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/service_info_card_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/service_stats_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/success_dialog.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/service_permissions.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/services_permissions_sections.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/helper/circle_progress.dart';
import 'package:demo_app/core/helper/csv_helper.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/14-custom_filter_icon.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/controller/details_services_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/controller/details_services_state.dart';

class DetailsServicesPage extends StatelessWidget {
  final ServicesHistoryModel createServicesModel;

  const DetailsServicesPage({
    required this.createServicesModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsServicesCubit()
        ..initialize(createServicesModel.currentId, createServicesModel, context),
      child: DetailsServicesView(createServicesModel: createServicesModel),
    );
  }
}

class DetailsServicesView extends StatefulWidget {
  final ServicesHistoryModel createServicesModel;

  const DetailsServicesView({required this.createServicesModel, super.key});

  @override
  State<DetailsServicesView> createState() => _DetailsServicesViewState();
}

class _DetailsServicesViewState extends State<DetailsServicesView> {
  final TextEditingController _searchController = TextEditingController();

  final Map<String, String> enToArDepartments = {
    "Executive": "الإدارة التنفيذية",
    "Customer Support": "دعم العملاء",
    "Finance": "المالية",
    "Operations": "العمليات",
    "Information Technology": "تقنية المعلومات",
    "Human Resources": "الموارد البشرية",
    "Marketing": "التسويق",
    "Sales": "المبيعات",
    "Data Management": "إدارة البيانات",
    "Compliance & Legal": "الامتثال والشؤون القانونية",
    "Software": "البرمجيات",
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = DetailsServicesCubit.get(context);
    final isMobile = context.isPhone;
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: SafeArea(
        child: SideFrameMasterServices(
          titleText: S.of(context).service,
          onFirstTap: () {
            navigateTo(context, LayoutScreenServices());
          },
          secondTitle: FormatHelper.capitalize(
            Localizations.localeOf(context).languageCode == 'ar'
                ? widget.createServicesModel.currentServiceNameArabic ?? ''
                : widget.createServicesModel.currentServiceNameEnglish ?? '',
          ),
          child: BlocBuilder<DetailsServicesCubit, DetailsServicesState>(
            builder: (context, state) {
              if (state is DetailsServicesLoading) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: CircleProgressMaster(),
                  ),
                );
              }

              if (state is DetailsServicesError) {
                return Center(
                  child: Text('Error: ${state.message}'),
                );
              }

              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    // Header with Edit/Delete buttons
                    ServiceHeaderWidget(
                      createServicesModel: widget.createServicesModel,
                    ),
                    SizedBox(height: 8.sp),

                    // Service Info Card
                    ServiceInfoCardWidget(
                      createServicesModel: widget.createServicesModel,
                    ),
                    SizedBox(height: 20.sp),

                    // Stats Widget
                    ServiceStatsWidget(stats: cubit.stats),
                    SizedBox(height: 20.sp),

                    // Tabs Section
                    _buildTabsSection(context, cubit),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabsSection(BuildContext context, DetailsServicesCubit cubit) {
    return Column(
      children: [
        _buildTabHeaders(context, cubit),
        SizedBox(height: 20.sp),
        _buildSearchAndFilters(context, cubit),
        SizedBox(height: 15.sp),
        BlocBuilder<DetailsServicesCubit, DetailsServicesState>(
          builder: (context, state) {
            if (cubit.isEmployeesTab) {
              return EmployeesTabWidget(
                searchController: _searchController,
                createServicesModel: widget.createServicesModel,
              );
            } else {
              return RequestedServicesTabWidget(
                createServicesModel: widget.createServicesModel,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildTabHeaders(BuildContext context, DetailsServicesCubit cubit) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    var isMobile = context.isPhone;
    return Row(
      children: [
        // Requested Services Tab
        if (Get.find<MainCoreEmployeeController>().isHasPermission(
          module: Modules.services,
          permission: ServicePermissions.viewRequesters,
          section: ServicePermissionsSections.servicesPermissions,
        ))
          GestureDetector(
            onTap: () => cubit.changeTab(false),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).RequestedServices,
                    style: isMobile ?AppTextStyles.font20BlackSemiBoldCairo.copyWith(
                      fontSize: 18.sp,
                      color: !cubit.isEmployeesTab
                          ? AppColors.secondaryPrimary
                          : lightMode
                          ? const Color(0xFF797979)
                          : AppColors.grey,
                    ):
                    AppTextStyles.font20BlackSemiBoldCairo.copyWith(
                      color: !cubit.isEmployeesTab
                          ? AppColors.secondaryPrimary
                          : lightMode
                          ? const Color(0xFF797979)
                          : AppColors.grey,
                    ),
                  ),
                  if (!cubit.isEmployeesTab)
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      height: 2.h,
                      width: double.infinity,
                      color: AppColors.secondaryPrimary,
                    ),
                ],
              ),
            ),
          ),

        // Spacing
        if (Get.find<MainCoreEmployeeController>().isHasPermission(
          module: Modules.services,
          permission: ServicePermissions.viewRequesters,
          section: ServicePermissionsSections.servicesPermissions,
        ))
          SizedBox(width: 47.w),

        // Employees Tab
        GestureDetector(
          onTap: () => cubit.changeTab(true),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  S.of(context).Employees,
                  style: AppTextStyles.font20BlackSemiBoldCairo.copyWith(
                    color: cubit.isEmployeesTab
                        ? AppColors.secondaryPrimary
                        : lightMode
                        ? const Color(0xFF797979)
                        : AppColors.grey,
                  ),
                ),
                if (cubit.isEmployeesTab)
                  Container(
                    margin: EdgeInsets.only(top: 4.h),
                    height: 2.h,
                    width: double.infinity,
                    color: AppColors.secondaryPrimary,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(BuildContext context, DetailsServicesCubit cubit) {
    final isMobile = context.isPhone;
    final isTablet = context.isTablet;
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isFilterActive = cubit.hasActiveFilters;

    return Row(
      children: [
        // Search Field
        AppSearchTextField(
          controller: _searchController,
          onChanged: (val) => cubit.applySearch(val),
        ),

        SizedBox(width: 15.sp),

        // Filter Button
        CustomFilterIcon(
          color: isFilterActive ? AppColors.primary : AppColors.card,
          borderColor: Colors.transparent,
          svgColor: isFilterActive
              ? AppColors.textButton
              : (lightMode ? AppColors.secondaryText : AppColors.grey),
          title: S.of(context).Filter,
          textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
            color: isFilterActive ? AppColors.textButton : AppColors.secondaryText,
          ),
          onTap: () async {
              if (mounted) {
                try {
                  final result = await showFilterDialog(
                    context,
                    cubit.filteredItems
                        .map((item) => item["model"] as ServicesHistoryModel)
                        .toList(),
                    initialDepartments: cubit.selectedDepartments, // ✅ List
                    initialStatuses: cubit.selectedStatuses, // ✅ List
                    initialDate: cubit.selectedDate,
                    initialSortBy: cubit.selectedSortBy, // ✅ NEW: For employees tab
                    isEmployeesTab: cubit.isEmployeesTab, // ✅ NEW: Determine which fields to show
                  );

                  if (result != null && mounted) {
                    cubit.applyFilter(
                      departments: result['departments'] as List<String>?,
                      statuses: result['statuses'] as List<String>?,
                      date: result['date'] as DateTime?,
                      sortBy: result['sortBy'] as String?, // ✅ NEW: For employees sorting
                    );
                  }
                } catch (e) {
                }
              }
            },
        ),

        // Export Button (Only for Requested Services Tab)
        if (Get.find<MainCoreEmployeeController>().isHasPermission(
          module: Modules.services,
          permission: ServicePermissions.exportRequestedServices,
          section: ServicePermissionsSections.servicesPermissions,
        ) &&
            !cubit.isEmployeesTab) ...[
          SizedBox(width: 15.sp),
          GestureDetector(
            onTap: () async {
              final fileName = await showFileNameDialog(context);
              if (fileName != null && fileName.isNotEmpty) {
                await _exportToCSV(context, cubit, fileName);
              }
            },
            child: !isTabletLandscape(context)
                ? Container(
              width: 38.sp,
              height: 38.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  width: 24.sp,
                  height: 24.sp,
                  color: AppColors.textButton,
                  fit: BoxFit.fill,
                  "assets/upload.svg",
                ),
              ),
            )
                : Container(
              width: 100.sp,
              height: 38.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    width: 24.sp,
                    height: 24.sp,
                    color: AppColors.textButton,
                    fit: BoxFit.scaleDown,
                    "assets/upload.svg",
                  ),
                  SizedBox(width: 8.sp),
                  Text(
                    S.of(context).export,
                    style: AppTextStyles.font16BlackMediumCairo.copyWith(
                      color: AppColors.textButton,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
  Future<void> _exportToCSV(BuildContext context, DetailsServicesCubit cubit, String fileName) async {
    showLoadingIndicator(context);

    List<List<dynamic>> rows = [];

    // Add headers
    rows.add([
      S.of(context).NO,
      S.of(context).serviceRequester,
      S.of(context).department,
      S.of(context).jobTitle,
      S.of(context).RequestedDate,
      S.of(context).status,
      S.of(context).serviceProvider,
    ]);

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final displayedItems = cubit.displayedItems;

    for (int i = 0; i < displayedItems.length; i++) {
      final item = displayedItems[i];
      final model = item["model"] as ServicesHistoryModel;

      final requestor = isArabic
          ? "${model.department_Requester_Arabic ?? ''} ${model.last_Name_Requester_Arabic ?? ''}"
          : "${model.department_Requester ?? ''} ${model.last_Name_Requester ?? ''}"
          .trim();
      final rawDepartment = model.department_Requester ?? "-";
      final department = isArabic ? enToArDepartments[rawDepartment] ?? rawDepartment : rawDepartment;

      final jobTitle = item["jobtitle"] ?? "_";

      final requestDate = model.currentDurationOfServicesTimestamp != null
          ? DateFormat.yMMMMd(Localizations.localeOf(context).languageCode)
          .format(model.currentDurationOfServicesTimestamp.toDate())
          : "-";

      final status = () {
        final status = (item["status"] ?? "").toString().toLowerCase();
        if (isArabic) {
          if (status == "active") return "نشط";
          if (status == "inactive") return "غير نشط";
          return "غير معروف";
        } else {
          return status.isNotEmpty ? status : "-";
        }
      }();

      final provider = item["provider"] ?? "-";

      rows.add([
        i + 1,
        requestor,
        department,
        jobTitle,
        requestDate,
        status,
        provider,
      ]);
    }

    await CSVHelper().exportToCSV(rows, fileName);
    hideLoadingIndicator();
    await showDownloadSuccessDialog(context);
  }
}
