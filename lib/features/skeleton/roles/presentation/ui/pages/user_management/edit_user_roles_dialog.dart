import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/skeleton/roles/presentation/ui/widgets/user_management/access_details.dart';
import 'package:demo_app/generated/l10n.dart';

import '../../../../domain/entity/user_permission_entity.dart';
import '../../../controller/user_management_cubit.dart';
import '../../../../utils/role_log_service.dart';
import 'edit_select.dart';

class EditUserAccessDialog extends StatefulWidget {
  final UserPermissionEntity userPermission;

  const EditUserAccessDialog({
    super.key,
    required this.userPermission,
  });

  @override
  State<EditUserAccessDialog> createState() => _EditUserAccessDialogState();
}

class _EditUserAccessDialogState extends State<EditUserAccessDialog> {
  @override
  void initState() {
    super.initState();
    // Initialize the controller with existing data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<UserManagementAccessCubit>();

      // Set existing role if available
      if (widget.userPermission.accessName != null) {
        controller.newAccessSelectedRole = widget.userPermission.accessName;
      }

      // Parse and set existing dates if available
      if (widget.userPermission.startDate != null &&
          widget.userPermission.startDate!.isNotEmpty &&
          widget.userPermission.startDate != '-') {
        try {
          controller.accessGranted = _parseDate(widget.userPermission.startDate!)!;
        } catch (e) {
          print('Error parsing start date: $e');
        }
      }

      if (widget.userPermission.endDate != null &&
          widget.userPermission.endDate!.isNotEmpty &&
          widget.userPermission.endDate != '-') {
        try {
          controller.accessRevoked = _parseDate(widget.userPermission.endDate!)!;
        } catch (e) {
          print('Error parsing end date: $e');
        }
      }

      controller.emit(UserPermissionsDataLoaded());
    });
  }

  DateTime? _parseDate(String dateString) {
    if (dateString.isEmpty || dateString == '-') return null;

    try {
      // Try different date formats
      if (dateString.contains('/')) {
        final parts = dateString.split('/');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        }
      } else if (dateString.contains('-')) {
        return DateTime.parse(dateString);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 100.w : 20.w,
      ),
      child: Container(
        width: 330.w,
        height: 200.h,
        decoration: BoxDecoration(
          color: lightMode ? Colors.white : Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(15.sp),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),

                    // Access Details Widget - NO FIXED WIDTH
                    Expanded(
                      child: EditAccessDetails(),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Buttons
            Container(
              padding: EdgeInsets.all(15.sp),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: lightMode
                        ? Colors.grey.shade300
                        : Colors.grey.shade700,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Discard Button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 10.h,
                      ),
                      backgroundColor: lightMode
                          ? Colors.grey.shade200
                          : Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    child: Text(
                      'Discard'.tr,
                      style: AppTextStyles.font14BlackCairoRegular.copyWith(
                        color: lightMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // Save Button
                  ElevatedButton(
                    onPressed: () {
                      final controller = context.read<UserManagementAccessCubit>();

                      // Validate that required fields are filled
                      if (controller.newAccessSelectedRole == null ||
                          controller.newAccessSelectedRole!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select a role type'.tr),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (controller.accessGranted == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select access granted date'.tr),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (controller.accessRevoked == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select access revoked date'.tr),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Return the updated data
                      RoleLogService.log(RoleLogService.actionUpdateAccess);
                      Navigator.of(context).pop({
                        'role': controller.newAccessSelectedRole,
                        'accessGranted': controller.accessGranted,
                        'accessRevoked': controller.accessRevoked,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 10.h,
                      ),
                      backgroundColor: AppColorsThree.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    child: Text(
                      'Save'.tr,
                      style: AppTextStyles.font14BlackCairoRegular.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}