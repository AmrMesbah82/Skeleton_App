import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/app_colors.dart';

import '../../../features/employee/presentation/controller/main_core_employee_controller.dart';
import '../../../features/roles/domain/enums/modules_enum.dart';
import '../../../features/roles/domain/enums/roles/active_directory_permission.dart';
import '../../../features/roles/domain/enums/roles/roles_permissions_sections.dart';

class CustomFloatingButton extends StatefulWidget {
  final String imagePath;
  final int currentSelectedIndex;
  final VoidCallback onExportPressed;
  final VoidCallback onUploadPressed;
  final VoidCallback onRestorePressed;

  const CustomFloatingButton({
    Key? key,
    required this.imagePath,
    required this.currentSelectedIndex,
    required this.onExportPressed,
    required this.onUploadPressed,
    required this.onRestorePressed,
  }) : super(key: key);

  @override
  _CustomFloatingButtonState createState() => _CustomFloatingButtonState();
}

class _CustomFloatingButtonState extends State<CustomFloatingButton> {
  bool _isExpanded = false;

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

  }

  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: Get.locale.toString().contains('en') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        if (_isExpanded) ...[
          // if (Get.find<MainCoreEmployeeController>().isHasPermission(
          //   module: Modules.roles,
          //   section: RolePermissionsSections.activeDirectory,
          //   permission: ActiveDirectory.exportData,
          // ))
          _buildAdditionalContainer(
            context,
            "assets/icons/exportImage.svg",
            "Export",
            widget.onExportPressed,
          ),
          // if (Get.find<MainCoreEmployeeController>().isHasPermission(
          //   module: Modules.roles,
          //   section: RolePermissionsSections.activeDirectory,
          //   permission: ActiveDirectory.uploadDocument,
          // ))
          _buildAdditionalContainer(
            context,
            "assets/images/uploadImage.svg",
            "Upload",
            widget.onUploadPressed,
          ),
          // if (Get.find<MainCoreEmployeeController>().isHasPermission(
          //   module: Modules.roles,
          //   section: RolePermissionsSections.activeDirectory,
          //   permission: ActiveDirectory.restoreData,
          // ))
          _buildAdditionalContainer(
            context,
            "assets/icons/restoreImage.svg",
            "Restore",
            widget.onRestorePressed,
          ),
        ],
        InkWell(
          onTap: _handleTap,
          child: Container(
            decoration: BoxDecoration(
             // border: Border.all(color: _isExpanded ? Colors.transparent : Colors.grey),
              color: _isExpanded
                  ? MyThemeData.signOut
                  : AppColors.card,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isVertical ? 0.015.h : 0.015.h,
                vertical: 0.015.h,
              ),
              child: Center(
                child: Transform.scale(
                  scale: isVertical ? 1.2 : 1,
                  child: SvgPicture.asset(
                    widget.imagePath,
                    color:  _isExpanded
                        ? MyThemeData().contrastColor()
                        : AppColors.secondaryText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalContainer(
      BuildContext context, String imagePath, String text, VoidCallback onPressed) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: EdgeInsets.only(bottom: 0.015.h),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: isVertical ? 0.18.w : 0.1.w,
          padding: EdgeInsets.all(isVertical ? 0.005.h : 0.01.h),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          //  border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                imagePath,
                color: AppColors.text,
                width: isVertical ? 0.035.w : 0.02.w,
                height: isVertical ? 0.035.w : 0.02.w,
              ),
              SizedBox(width: 0.01.w),
              Text(
                text.tr,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isVertical
                      ? FontConstants.fontSize026.w
                      : FontConstants.fontSize014.w,
                  fontWeight: FontWeight.w600,
                  height: 1.8,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
