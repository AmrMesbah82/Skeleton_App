import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';

import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/employees/presentation/controller/employee_controller.dart';
import 'package:lottie/lottie.dart';

class RestoreDialog extends StatefulWidget {
  const RestoreDialog({
    super.key,
    required this.firstOnPressed,
    required this.secondOnPressed,
  });

  final void Function() firstOnPressed;
  final void Function() secondOnPressed;

  @override
  State<RestoreDialog> createState() => _RestoreDialogState();
}

class _RestoreDialogState extends State<RestoreDialog> {
  ButtonStyle buttonStyle(Color buttonColor) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return ElevatedButton.styleFrom(
        backgroundColor: buttonColor, //AppColors.bubbleColor,
        minimumSize: isTablet ? Size(0.1.w, 0.053.h) : Size(0.3.w, 0.05.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
  }

  final HapticController hapticController = Get.put(HapticController());
  EmployeeController addEmployeeController = Get.find();
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? (orientation ? 0.12.w : 0.2.w) : 0.15.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.01.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical:
                        isTablet ? (orientation ? 0.03.h : 0.0.h) : 0.04.h),
                child: Transform.scale(
                  scale: isTablet ? (orientation ? 2 : 0.9) : 2,
                  child: Lottie.asset(
                    "assets/images/newAttension.json",
                    width: 0.1.w,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              SizedBox(
                height: isTablet ? (orientation ? 0.03.h : 0.02.h) : 0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: orientation ? 0.015.h : 0.015.h),
                child: Text(
                  'Restore Backup',
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isTablet
                          ? (orientation
                              ? FontConstants.fontSize025.h
                              : FontConstants.fontSize035.h)
                          : FontConstants.fontSize022.h,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
              ),
              Text(
                'Choose which backup you want to restore'.tr,
                textAlign: isTablet ? TextAlign.center : TextAlign.center,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: isTablet
                        ? (orientation
                            ? FontConstants.fontSize022.h
                            : FontConstants.fontSize030.h)
                        : FontConstants.fontSize020.h,
                    fontWeight: FontWeight.w600,
                    height: isTablet ? 1.5 : 1.5,
                    color: Theme.of(context).colorScheme.scrim),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.025.h),
                child: Row(
                  // direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: MainCustomIconButton(
                        buttonStyle: buttonStyle(AppColors.colorGreydark),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      
                        buttonText: "Cancel".tr,
              
                      ),
                    ),
                    Container(width: 0.02.w),
                    Expanded(
                      child: MainCustomIconButton(
                        buttonStyle: buttonStyle(AppColors.bubbleColor),
                        onPressed: widget.secondOnPressed,
                        buttonText: "Second Backup".tr,
          
                      ),
                    ),
                    Container(width: 0.02.w),
                    Expanded(
                      child: MainCustomIconButton(
                        buttonStyle: buttonStyle(AppColors.bubbleColor),
                        onPressed: widget.firstOnPressed,
                        buttonText: "First Backup".tr,
                     
                      ),
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
