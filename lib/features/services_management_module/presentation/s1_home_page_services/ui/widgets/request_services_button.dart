import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/dashboard_permissions.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/request_service_permission.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/services_permissions_sections.dart';


import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/features/services_management_module/presentation/s10_employee_action/ui/pages/employee_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/pages/dashboard_admin_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/pages/request_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/pages/approval_request_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s8_dashboard/ui/pages/dashboard_management_toggle.dart';



Widget approvalAndServicesRequest(BuildContext context) {
  final isTablet = context.isTablet;
  final isMobile = context.isPhone;
  final isLandscape = context.isLandscape;
  return Row(
    mainAxisAlignment: isMobile ? MainAxisAlignment.start : MainAxisAlignment.start,
    children: [


      // Service Requests
      if(Get.find<MainCoreEmployeeController>().isHasPermission(module: Modules.services, permission: RequestServicePermission.requestService, section: ServicePermissionsSections.requestServicePermissions))
        customButtonAnimation(
          title: S.of(context).serviceRequests,
          function: () {


            Navigator.push(context, MaterialPageRoute(builder: (_){
              return RequestServicesToggle();
            }));


          //  navigateTo(context, RequestServicesToggle());
          },
          textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
            color: AppColors.textButton,
          ),
         width: isMobile ? 160.w : 160.w,
          paddingHorizontal: 20.w,
          height: 38.h,
          radius: 8.r,
          color: AppColors.primary,
        ),

      SizedBox(width: 15.sp),

      // Req Services
      if (Get.find<MainCoreEmployeeController>().isHasPermission(
        module: Modules.services,
        section:ServicePermissionsSections.requestedServices,
        permission: null,
      ))
       isMobile ? SizedBox(): Row(
          children: [
            customButtonAnimation(
              title: S.of(context).requestedServices,
              function: () {
                navigateTo(context, EmployeeLayoutScreenServices());
              },
              textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                color: AppColors.textButton,
              ),
              paddingHorizontal: 15.w,
              height: 38.h,
              radius: 8.r,
              color: AppColors.primary,
            ),
            SizedBox(width: 10.w),
          ],
        ),



      Spacer(),



      if (Get.find<MainCoreEmployeeController>().isHasPermission(
          module: Modules.services,
          section: ServicePermissionsSections.dashboardPermissions,
          permission: null
      ))
        if (Get.find<MainCoreEmployeeController>().isHasPermission(
          module: Modules.services,
          section:ServicePermissionsSections.dashboardPermissions,
          permission: DashboardPermissions.departmentDashboard ,
        ))
        customButtonAnimation(
          title: S.of(context).dashboard,
          function: () {
            navigateTo(context, DashBordLayout());
          },
          textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
            color: AppColors.textButton,
          ),
          width: isMobile ? 140.w : 134.w,
          height: 38.h,
          radius: 8.r,
          color: AppColors.primary,
        ),

      isMobile ?SizedBox(): SizedBox(width: 15.sp),

     // Approval
     if(Get.find<MainCoreEmployeeController>().isHasPermission(
         module: Modules.services,
         section: ServicePermissionsSections.approvalPermissions,
         permission: null,
      ))
     !isMobile ?   customButtonAnimation(
        title: S.of(context).approvals,
        function: () {
          navigateTo(context, ApprovalToggle());
        },
        textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
          color: AppColors.textButton,
        ),
        width: isMobile ? 120.w : 135.w,
        height: 38.h,
        radius: 8.r,
        color: AppColors.primary,
      ) : SizedBox(),
    ],
  );
}
