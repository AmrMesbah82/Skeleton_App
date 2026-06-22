import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/dashboard_permissions.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/services_permissions_sections.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart'; // ✅ ADD THIS IMPORT
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/widgets/services_management/custom_filter.dart';
import 'package:demo_app/core/widgets/services_management/custom_grid_view.dart';
import 'package:demo_app/core/widgets/services_management/custom_pop_up.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/core/widgets/services_management/search_widget.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/features/services_management_module/presentation/s10_employee_action/ui/pages/employee_services_toggle.dart';

import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/pages/dashboard_admin_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/pages/details_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/info_text.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/my_request_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/request_services_details_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/show_requests_service_card.dart';
import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/pages/approval_request_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s8_dashboard/ui/pages/dashboard_management_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/pages/create_new_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/pages/upload_file_toggle.dart';

class RequestServicesWidget extends StatefulWidget {
  final List<ServicesHistoryModel> filteredServices;
  final String selectStatus;
  final Function(String) onStatusSelected;
  final int totalServices;
  final Map<String, int> sortedMap;
  final String userDepartment;
  final bool isArabic;
  final TextEditingController searchController;
  final Function(BuildContext, String?) getLocalizedDurationUnit;
  final Future<Map<String, dynamic>?> Function(String) selectServiceProvider;

  const RequestServicesWidget({
    Key? key,
    required this.filteredServices,
    required this.selectStatus,
    required this.onStatusSelected,
    required this.totalServices,
    required this.sortedMap,
    required this.userDepartment,
    required this.isArabic,
    required this.searchController,
    required this.getLocalizedDurationUnit,
    required this.selectServiceProvider,
  }) : super(key: key);

  @override
  State<RequestServicesWidget> createState() => _RequestServicesWidgetState();
}

class _RequestServicesWidgetState extends State<RequestServicesWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final employeeController = Get.find<MainCoreEmployeeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildActionButtonsRow(context, employeeController),
        SizedBox(height: 15.h),
        if (Get.find<MainCoreEmployeeController>().isHasPermission(
          module: Modules.services,
          section: ServicePermissionsSections.requestServicePermissions,
          permission: null,
        ))
          Column(
            children: [
              DepartmentFilterChips(
                selectedKey: widget.selectStatus,
                onSelected: widget.onStatusSelected,
                totalCount: widget.totalServices,
                departmentCounts: widget.sortedMap,
                userDepartment: widget.userDepartment,
                isArabic: widget.isArabic,
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  AppSearchTextField(
                    controller: widget.searchController,
                    onChanged: (_) {},
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              _buildServicesGrid(context),
            ],
          ),
      ],
    );
  }

  Widget _buildActionButtonsRow(
      BuildContext context,
      MainCoreEmployeeController employeeController,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Spacer(),
            if (Get.find<MainCoreEmployeeController>().isHasPermission(
                module: Modules.services,
                section: ServicePermissionsSections.dashboardPermissions,
                permission: null))
              if (Get.find<MainCoreEmployeeController>().isHasPermission(
                module: Modules.services,
                section: ServicePermissionsSections.dashboardPermissions,
                permission: DashboardPermissions.adminDashboard,
              ))
                customButtonAnimation(
                  title: FormatHelper.capitalize(S.of(context).adminDashboard),
                  function: () {
                    navigateTo(context, AdminDashBordLayout());
                  },
                  textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                    color: AppColors.textButton,
                  ),
                  width: 135.sp,
                  height: 36.sp,
                  radius: 8.r,
                  color: AppColors.primary,
                ),
          ],
        ),
        SizedBox(height: 15.sp),
        Row(
          children: [
            if (Get.find<MainCoreEmployeeController>().isHasPermission(
              module: Modules.services,
              section: ServicePermissionsSections.requestedServices,
              permission: null,
            ))
              if (employeeController.isHasPermission(
                module: Modules.services,
                section: ServicePermissionsSections.requestedServices,
                permission: null,
              ))
                customButtonAnimation(
                  title: FormatHelper.capitalize(S.of(context).requestedServices),
                  function: () {
                    navigateTo(context, EmployeeLayoutScreenServices());
                  },
                  textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                    color: AppColors.textButton,
                  ),
                  width: 155.sp,
                  height: 36.sp,
                  radius: 8.r,
                  color: AppColors.primary,
                ),
            if (!Get.find<MainCoreEmployeeController>().isHasPermission(
              module: Modules.services,
              section: ServicePermissionsSections.requestServicePermissions,
              permission: null,
            ))
              SizedBox(width: 15.w),
            if (Get.find<MainCoreEmployeeController>().isHasPermission(
              module: Modules.services,
              section: ServicePermissionsSections.requestServicePermissions,
              permission: null,
            ))
              SizedBox(width: 15.w),
            customButtonAnimation(
              title: FormatHelper.capitalize(S.of(context).myRequests),
              function: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MyRequestServicesToggle(),
                  ),
                );
              },
              textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                color: AppColors.textButton,
              ),
              width: 135.sp,
              height: 36.sp,
              radius: 8.r,
              color: AppColors.primary,
            ),
            Spacer(),
            if (employeeController.isHasPermission(
              module: Modules.services,
              section: ServicePermissionsSections.approvalPermissions,
              permission: null,
            ))
              customButtonAnimation(
                title: FormatHelper.capitalize(S.of(context).approvals),
                function: () {
                  navigateTo(context, ApprovalToggle());
                },
                textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                  color: AppColors.textButton,
                ),
                width: 135.sp,
                height: 36.sp,
                radius: 8.r,
                color: AppColors.primary,
              ),
            SizedBox(width: 15.w),
            if (Get.find<MainCoreEmployeeController>().isHasPermission(
                module: Modules.services,
                section: ServicePermissionsSections.dashboardPermissions,
                permission: null))
              if (Get.find<MainCoreEmployeeController>().isHasPermission(
                module: Modules.services,
                section: ServicePermissionsSections.dashboardPermissions,
                permission: DashboardPermissions.departmentDashboard,
              ))
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    customButtonAnimation(
                      title: FormatHelper.capitalize(S.of(context).dashboard),
                      function: () {
                        navigateTo(context, DashBordLayout());
                      },
                      textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color: AppColors.textButton,
                      ),
                      width: 135.sp,
                      height: 36.sp,
                      radius: 8.r,
                      color: AppColors.primary,
                    ),
                  ],
                ),
          ],
        ),
      ],
    );
  }

  Widget _buildServicesGrid(BuildContext context) {

    if (widget.filteredServices.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 40.sp),
        child: Column(
          children: [
            Lottie.asset(
              'assets/lottie/empty.json',
              width: 400.sp,
              height: 400.sp,
              fit: BoxFit.fill,
              repeat: true,
              animate: true,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: CrossAxisCountHelperResponsive.getCrossAxisCountForDefaultTabletResponsive(context),
        mainAxisExtent: 250.sp,
        mainAxisSpacing: 15.sp,
        crossAxisSpacing: 15.sp,
      ),
      itemCount: widget.filteredServices.length,
      itemBuilder: (context, index) {
        return _buildServiceCard(context, index);
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, int index) {
    final model = widget.filteredServices[index];

    final serviceName = widget.isArabic
        ? model.currentServiceNameArabic
        : model.currentServiceNameEnglish;

    final durationText =
        '${model.currentDurationOfServices} ${widget.getLocalizedDurationUnit(context, model.currentSelectedDurationUnit)}';

    final approvalCycle = model.currentApprovalCycle;
    final approvalText = approvalCycle.isEmpty
        ? (widget.isArabic ? "لا يحتاج إلى موافقة" : "Doesn't Need Approval")
        : (widget.isArabic ? "يحتاج إلى موافقة" : "Need Approval");

    // ✅ NEW: Get owning department name from departmentRequester
    final departmentController = Get.find<MainCoreDepartmentController>();
    String owningDepartment = '';

    try {
      final departmentId = model.currentDepartmentRequester;
      // Only log for first few cards to avoid spam

      if (departmentId.isNotEmpty) {
        owningDepartment = departmentController.getDepartmentName(
          departmentId,
          !widget.isArabic, // true for English, false for Arabic
        );
      } else {
        owningDepartment = widget.isArabic ? 'غير محدد' : 'Unspecified';
      }
    } catch (e) {
      owningDepartment = widget.isArabic ? 'غير محدد' : 'Unspecified';
    }

    return GestureDetector(
      onTap: () {
        navigateTo(
          context,
          RequestServicesDetailsToggle(requestModel: model),
        );
      },
      child: FutureBuilder<Map<String, dynamic>?>(
        future: widget.selectServiceProvider(model.currentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomServiceCard(
              owningDepartment: owningDepartment, // ✅ FIXED: Pass actual department
              serviceName: serviceName,
              serviceProvider: "...",
              jobTitle: "...",
              durationOfServices: durationText,
              approval: approvalText,
              model: model,
            );
          }

          final provider = snapshot.data;
          final providerName = provider != null
              ? '${provider['firstName${widget.isArabic ? 'InArabic' : ''}'] ?? ''} '
              '${provider['lastName${widget.isArabic ? 'InArabic' : ''}'] ?? ''}'
              : '-';

          final providerTitle = provider != null
              ? (provider[widget.isArabic ? 'titleInArabic' : 'title'] ?? '-')
              : '-';

          return CustomServiceCard(
            owningDepartment: owningDepartment, // ✅ FIXED: Pass actual department
            serviceName: serviceName,
            serviceProvider: providerName.trim(),
            jobTitle: providerTitle,
            durationOfServices: durationText,
            approval: approvalText,
            model: model,
          );
        },
      ),
    );
  }
}
