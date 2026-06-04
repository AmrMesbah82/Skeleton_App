import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:lottie/lottie.dart';

class DeletOrArchiveDialog extends StatefulWidget {
  DeletOrArchiveDialog(
      {super.key,
      this.isDelete,
      this.isCheckListElement,
      this.yesOnPressed,
      this.isAttachment});
  bool? isDelete = false;
  bool? isCheckListElement = false;
  bool? isAttachment = false;
  final VoidCallback? yesOnPressed;
  @override
  State<DeletOrArchiveDialog> createState() => _DeletOrArchiveDialogState();
}

class _DeletOrArchiveDialogState extends State<DeletOrArchiveDialog> {
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
          padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.01.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical:
                        isTablet ? (isVertical ? 0.03.h : 0.0.h) : 0.04.h),
                child: Transform.scale(
                  scale: isTablet ? (isVertical ? 2 : 0.9) : 2,
                  child: Lottie.asset(
                    "assets/images/deletion.json",
                    width: 0.1.w,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: isVertical ? 0.015.h : 0.015.h),
                child: Text(
                  widget.isDelete == true
                      ? "Delete Card".tr
                      : widget.isCheckListElement == true
                          ? "Delete Element".tr
                          : widget.isAttachment == true
                              ? "Delete Attachments".tr
                              : "Archive Card".tr,
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
                widget.isDelete == true
                    ? "Are You Sure You Want To Delete This Card?".tr
                    : widget.isCheckListElement == true
                        ? "Are You Sure You Want To Delete This Element?".tr
                        : widget.isAttachment == true
                            ? "Are You Sure You Want To Delete These Attachments?"
                                .tr
                            : "Are You Sure You Want To Archive This Card?".tr,
                textAlign: isTablet ? TextAlign.center : TextAlign.center,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: isTablet
                        ? (isVertical
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
                        buttonStyle: buttonStyle(MyThemeData.colorGreydark),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      
                        buttonText: "No".tr,
         
                      ),
                    ),
                    Container(width: 0.025.w),
                    Expanded(
                      child: MainCustomIconButton(
                        buttonStyle: buttonStyle(MyThemeData.bubbleColor),
                        onPressed: widget.yesOnPressed!,
                        buttonText: "Yes".tr,
                      
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
