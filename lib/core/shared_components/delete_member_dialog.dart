// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/shared_components/custom_teams_table_members.dart';
import 'package:demo_app/core/enumeration/enum.dart';

import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/constants/system_actions.dart';
import 'package:demo_app/features/employee/data/models/emplyees_model/new_employee_model.dart';
import 'package:demo_app/features/employees/presentation/controller/employee_controller.dart';
import 'package:demo_app/features/roles/system_logs/presentation/controller/system_logs_controller.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:lottie/lottie.dart';

import 'package:demo_app/features/employees/data/models/employee_model/employee_directory_model.dart';
import 'package:demo_app/features/employees/data/models/new_employee_model/emplyees_model/new_employee_model.dart';

// ignore: must_be_immutable
class DeleteMemberDialog extends StatefulWidget {
  DeleteMemberDialog(
      {super.key,
      required this.userName,
      this.employees,
      this.employeeDirectory,
      required this.index});
  final String userName;
  NewEmployeeModelHistory? employees;
  EmployeeDirectoryModel? employeeDirectory;

  int index;

  @override
  State<DeleteMemberDialog> createState() => _DeleteMemberDialogState();
}

class _DeleteMemberDialogState extends State<DeleteMemberDialog> {
  final SystemLogsController systemLogsController = Get.find<SystemLogsController>();
  ButtonStyle buttonStyle(Color buttonColor) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return ElevatedButton.styleFrom(
        backgroundColor: buttonColor, //AppColors.bubbleColor,
        minimumSize: isTablet
            ? isPortrait
                ? Size(0.2.w, 0.045.h)
                : Size(0.1.w, 0.053.h)
            : Size(0.3.w, 0.05.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
  }

  final HapticController hapticController = Get.put(HapticController());
  EmployeeController addEmployeeController = Get.find();
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding:
          EdgeInsets.symmetric(horizontal: isTablet ? 0.25.w : 0.15.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        height: isTablet
            ? isPortrait
                ? 0.33.h
                : 0.39.h
            : 0.36.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: isTablet
                        ? isPortrait
                            ? 0.03.h
                            : 0.015.h
                        : 0.04.h),
                child: Transform.scale(
                  scale: isTablet
                      ? isPortrait
                          ? 1.4
                          : 0.7
                      : 2,
                  child: Lottie.asset(
                    "assets/images/delete_member.json",
                    width: 0.1.w,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.02.h),
                child: Text(
                  "Delete Member".tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isTablet
                          ? isPortrait
                              ? FontConstants.fontSize026.h
                              : FontConstants.fontSize035.h
                          : FontConstants.fontSize022.h,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
              ),
              Text(
                "${'Are you sure you want delete'.tr} ${widget.userName}",
                textAlign: TextAlign.center,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: isTablet
                        ? isPortrait
                            ? FontConstants.fontSize016.h
                            : FontConstants.fontSize025.h
                        : FontConstants.fontSize020.h,
                    fontWeight: FontWeight.w600,
                    height: isTablet ? null : 1.5,
                    color: Theme.of(context).colorScheme.scrim),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.025.h),
                child: Row(
                  // direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MainCustomIconButton(
                      buttonStyle: buttonStyle(AppColors.bubbleColor),
                      onPressed: () async {
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.heavyImpact,
                            hapticFeedback: HapticFeedback.heavyImpact);
                        widget.employees!.status!.last = "deactivated";
                        await addEmployeeController.createEmployee(
                            widget.employees!,

                            widget.employees!.email!.last!,
                            );
                        systemLogsController
                            .systemLogsAction(SystemActions.updateEmployee);
                        Navigator.of(context).pop();
                      },
                      buttonText: "Yes".tr,
                    
                    ),
                    Container(width: 0.025.w),
                    MainCustomIconButton(
                      buttonStyle: buttonStyle(AppColors.colorGreydark),
                      onPressed: () {
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.lightImpact,
                            hapticFeedback: HapticFeedback.lightImpact);
                        Navigator.of(context).pop();
                      },
                    
                      buttonText: "No".tr,
       
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
