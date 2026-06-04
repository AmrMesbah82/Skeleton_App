import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

/// Date Created :27/November/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :27/November/2023 by Bassem
/// Objectives: this is a widget to customize the header of the permissions section located in the profile screen

// ignore: must_be_immutable
class PermissionsHeader extends StatefulWidget {
  PermissionsHeader({
    super.key,
    required this.selectedIndex,
    required this.selectedIndexState,
  });
  int selectedIndex;
  ValueChanged<int> selectedIndexState;

  @override
  State<PermissionsHeader> createState() => _PermissionsHeaderState();
}

class _PermissionsHeaderState extends State<PermissionsHeader> {
  final TextStyle unselectedStyle = AppFontStyle.cairoRegularStyle.copyWith(
    fontSize: FontConstants.fontSize026.h,
    color: MyThemeData.colorGrey,
    fontWeight: FontWeight.w400,
  );
  final TextStyle selectedStyle = AppFontStyle.cairoRegularStyle.copyWith(
    color: MyThemeData.lightPrimary,
    /*Theme.of(context).colorScheme.onInverseSurface,*/
    fontWeight: FontWeight.w800,
    fontSize: FontConstants.fontSize026.h,
  );
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  widget.selectedIndex = 0;
                  widget.selectedIndexState(widget.selectedIndex);
                });
              },
              child: Text("Home".tr,
                  // textAlign: TextAlign.start,
                  style: widget.selectedIndex == 0
                      ? selectedStyle
                      : unselectedStyle),
            ),
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  widget.selectedIndex = 1;
                  widget.selectedIndexState(widget.selectedIndex);
                });
              },
              child: Text("Employees".tr,
                  textAlign: TextAlign.end,
                  style: widget.selectedIndex == 1
                      ? selectedStyle
                      : unselectedStyle),
            ),
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  widget.selectedIndex = 2;
                  widget.selectedIndexState(widget.selectedIndex);
                });
              },
              child: Text("Task".tr,
                  textAlign: TextAlign.end,
                  style: widget.selectedIndex == 2
                      ? selectedStyle
                      : unselectedStyle),
            ),
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  widget.selectedIndex = 3;
                  widget.selectedIndexState(widget.selectedIndex);
                });
              },
              child: Text("Chat".tr,
                  textAlign: TextAlign.end,
                  style: widget.selectedIndex == 3
                      ? selectedStyle
                      : unselectedStyle),
            ),
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  widget.selectedIndex = 4;
                  widget.selectedIndexState(widget.selectedIndex);
                });
              },
              child: Text("Meeting".tr,
                  textAlign: TextAlign.end,
                  style: widget.selectedIndex == 4
                      ? selectedStyle
                      : unselectedStyle),
            ),
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  widget.selectedIndex = 5;
                  widget.selectedIndexState(widget.selectedIndex);
                });
              },
              child: Text("Request".tr,
                  textAlign: TextAlign.end,
                  style: widget.selectedIndex == 5
                      ? selectedStyle
                      : unselectedStyle),
            ),
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  widget.selectedIndex = 6;
                  widget.selectedIndexState(widget.selectedIndex);
                });
              },
              child: Text("Setting".tr,
                  textAlign: TextAlign.end,
                  style: widget.selectedIndex == 6
                      ? selectedStyle
                      : unselectedStyle),
            ),
          ],
        ),
        SizedBox(
          height: 0.01.r,
        ),
        SizedBox(
          height: 0.005.h,
          child: Row(
            children: [
              Container(
                width: Get.locale.toString().contains('en') ? 0.044.w : 0.055.w,
                color: widget.selectedIndex == 0
                    ? MyThemeData.lightPrimary
                    : Colors.transparent,
              ),
              Container(
                width: Get.locale.toString().contains('en') ? 0.029.w : 0.034.w,
                color: Colors.transparent,
              ),
              Container(
                width: Get.locale.toString().contains('en') ? 0.078.w : 0.06.w,
                color: widget.selectedIndex == 1
                    ? MyThemeData.lightPrimary
                    : Colors.transparent,
              ),
              Container(
                width:Get.locale.toString().contains('en')? 0.028.w:0.037.w,
                color: Colors.transparent,
              ),
              Container(
                width: Get.locale.toString().contains('en') ? 0.035.w : 0.04.w,
                color: widget.selectedIndex == 2
                    ? MyThemeData.lightPrimary
                    : Colors.transparent,
              ),
              Container(
                width: Get.locale.toString().contains('en') ? 0.027.w : 0.037.w,
                color: Colors.transparent,
              ),
              Container(
                width: Get.locale.toString().contains('en') ? 0.033.w : 0.047.w,
                color: widget.selectedIndex == 3
                    ? MyThemeData.lightPrimary
                    : Colors.transparent,
              ),
              Container(
                width: Get.locale.toString().contains('en') ? 0.027.w : 0.037.w ,
                color: Colors.transparent,
              ),
              Container(
                width: Get.locale.toString().contains('en') ? 0.059.w : 0.045.w,
                color: widget.selectedIndex == 4
                    ? MyThemeData.lightPrimary
                    : Colors.transparent,
              ),
              Container(
                width: Get.locale.toString().contains('en') ? 0.0285.w : 0.034.w,
                color: Colors.transparent,
              ),
              Container(
                width: Get.locale.toString().contains('en') ? 0.06.w : 0.03.w,
                color: widget.selectedIndex == 5
                    ? MyThemeData.lightPrimary
                    : Colors.transparent,
              ),
              Container(
                width: Get.locale.toString().contains('en') ? 0.027.w : 0.037.w,
                color: Colors.transparent,
              ),
              Container(
                width: Get.locale.toString().contains('en') ? 0.051.w : 0.035.w,
                color: widget.selectedIndex == 6
                    ? MyThemeData.lightPrimary
                    : Colors.transparent,
              ),
            ],
          ),
        )
      ],
    );
  }
}
