import 'package:demo_app/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:lottie/lottie.dart';

import '../../../generated/l10n.dart';

class AccessBlockedDialog extends StatefulWidget {
  AccessBlockedDialog({
    super.key,
    required this.onPressed,
  });
  void Function() onPressed;
  @override
  State<AccessBlockedDialog> createState() => _AccessBlockedDialogState();
}

class _AccessBlockedDialogState extends State<AccessBlockedDialog> {
  ButtonStyle buttonStyle(Color buttonColor) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return ElevatedButton.styleFrom(
        backgroundColor: buttonColor, //MyThemeData.bubbleColor,
        minimumSize: isTablet ? Size(0.1.w, 0.053.h) : Size(0.3.w, 0.05.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
  }

  final HapticController hapticController = Get.put(HapticController());

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? (isVertical ? 0.22.w : 0.33.w) : 0.15.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.02.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical:
                        isTablet ? (isVertical ? 0.03.h : 0.0.h) : 0.04.h),
                child: Transform.scale(
                  scale: isTablet ? (isVertical ? 3.5 : 2) : 6,
                  child: Lottie.asset(
                    "assets/images/blocked.json",
                    width: 0.1.w,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: isVertical ? 0.015.h : 0.015.h),
                child: Text(
                    S.of(context).accessBlocked,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isTablet
                          ? (isVertical
                              ? FontConstants.fontSize025.h
                              : FontConstants.fontSize035.h)
                          : FontConstants.fontSize022.h,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
              ),
              Text(
                "Your Access is Locked Since You Entered The Wrong Credentials 3 Times."
                    .tr,
                textAlign: isTablet ? TextAlign.center : TextAlign.center,
                style: StyleText.fontSize16Weight700.copyWith(
                    color: AppColors.text,
                    height: 1.4
                ),
              ),
              SizedBox(
                height: 0.015.h,
              ),
              Text(
                "Please Contact System Administrator To Reset Your Account.".tr,
                textAlign: isTablet ? TextAlign.center : TextAlign.center,
                style: StyleText.fontSize16Weight700.copyWith(
                  color: AppColors.text,
                  height: 1.4
              ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.025.h),
                child: Row(
                  // direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: MainCustomIconButton(
                        buttonStyle: buttonStyle(MyThemeData.bubbleColor),
                        onPressed: widget.onPressed,
                        buttonText: S.of(context).resetYourAccount,
  
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
