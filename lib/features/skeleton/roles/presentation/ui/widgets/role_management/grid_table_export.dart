import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../generated/l10n.dart';
import '../../../../../../external/main_core/features/employee/presentation/controller/main_core_employee_controller.dart';
import '../../../../../../external/services_mangment_module/core/new_theme.dart';
import '../../../../domain/enums/modules_enum.dart';
import '../../../../domain/enums/roles/role_mangment_permission.dart';
import '../../../../domain/enums/roles/roles_permissions_sections.dart';
import '../../../../domain/enums/roles/user_mangment_permission.dart';

class ViewToggleButtons extends StatelessWidget {
  final bool isGridView;
  final VoidCallback onTableViewTap;
  final VoidCallback onGridViewTap;
  final bool showExport;
  final VoidCallback? onExportTap;

  const ViewToggleButtons({
    super.key,
    required this.isGridView,
    required this.onTableViewTap,
    required this.onGridViewTap,
    this.showExport = false,
    this.onExportTap,
  });

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;

    var isMobile = context.isPhone;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showExport ||
            Get.find<MainCoreEmployeeController>().isHasPermission(
              module: Modules.roles,
              section: RolePermissionsSections.roleManagement,
              permission: RoleManagement.exportRoleData,
            )|| Get.find<MainCoreEmployeeController>().isHasPermission(
          module: Modules.roles,
          section: RolePermissionsSections.userManagement,
          permission: UserManagement.exportUsersData,
        ))

        GestureDetector(
            onTap: onExportTap,
            child: Padding(
              padding: isMobile
                  ? EdgeInsets.symmetric(horizontal: 0.sp)
                  : EdgeInsets.symmetric(horizontal: 8.sp),
              child: Container(
                width: isTabletLandscape(context) ? 100.sp : 38.sp,
                height: 38.sp,
                decoration: BoxDecoration(
                  color: AppColorsThree.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: isTabletLandscape(context)
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        "assets/upload_file.svg",
                        fit: BoxFit.scaleDown,
                        width: 20.sp,
                        height: 20.sp,
                        color: ColorAppLight.buttonTextColor,
                        semanticsLabel: 'Export',
                      ),
                    ),
                    SizedBox(width: 8.sp),
                    Text(
                      S.of(context).export,
                      style: StyleText.fontSize16Weight600.copyWith(
                        color: ColorAppLight.buttonTextColor
                      ),
                    )
                  ],
                )
                    : Center(
                  child: SvgPicture.asset(
                    "assets/upload_file.svg",
                    fit: BoxFit.scaleDown,
                    width: 20.sp,
                    height: 20.sp,
                    color: ColorAppLight.buttonTextColor,
                    semanticsLabel: 'Export',
                  ),
                ),
              ),
            ),
          ),
        isMobile ? SizedBox() :  GestureDetector(
          onTap: onTableViewTap,
          child: Container(
            width: 38.sp,
            height: 38.sp,
            decoration: BoxDecoration(
              color: !isGridView ? AppColorsThree.primary : lightMode ? ColorAppLight.whiteColor : ColorAppDark.chatBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/tableView.svg",
                width: 20.sp,
                height: 20.sp,
                fit: BoxFit.scaleDown,
                semanticsLabel: 'Table View',
                color: !isGridView ? ColorAppLight.buttonTextColor : lightMode ? ColorAppLight.blackButton : ColorAppDark.titleValue,
              ),
            ),
          ),
        ),
        isMobile ? SizedBox() : SizedBox(width: 8.sp),
        isMobile ? SizedBox() : GestureDetector(
          onTap: onGridViewTap,
          child: Container(
            width: 38.sp,
            height: 38.sp,
            decoration: BoxDecoration(
              color: isGridView ? AppColorsThree.primary : lightMode ? ColorAppLight.whiteColor : ColorAppDark.chatBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/gridView.svg",
                width: 20.sp,
                height: 20.sp,
                fit: BoxFit.scaleDown,
                semanticsLabel: 'Grid View',
                color: isGridView ? ColorAppLight.buttonTextColor :  lightMode ? ColorAppLight.blackButton : ColorAppDark.titleValue,
              ),
            ),
          ),
        ),
      ],
    );
  }
  bool isTabletLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return size.width >= 600 && isLandscape;
  }
}