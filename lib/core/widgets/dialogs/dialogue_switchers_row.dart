import 'dart:io';
import 'package:demo_app/core/theme/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/switchs_data_column.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class DialogueSwitcher extends StatefulWidget {
  DialogueSwitcher(
      {super.key,
      required this.title,
      this.isDialog = false,
      required this.subtitle,
      required this.switchValue,
      required this.switchValueState});
  final String title;
  final String subtitle;
  bool switchValue;
  bool? isDialog;
  ValueChanged<bool> switchValueState;

  @override
  State<DialogueSwitcher> createState() => _DialogueSwitcherState();
}

class _DialogueSwitcherState extends State<DialogueSwitcher> {
  final HapticController hapticController = Get.put(HapticController());

   double getSwitchSize(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = Platform.isLinux || Platform.isMacOS || Platform.isWindows;

    if (isDesktop && screenHeight >= 611 && screenHeight < 810) {
      return 0;
    } else if (isDesktop && screenHeight >= 810 && screenHeight < 900) {
      return 0.9;
    } else if (isDesktop && screenHeight >= 900 && screenHeight < 950) {
      return 1;
    } else if (isDesktop && screenHeight >= 950 && screenHeight < 1000) {
      return 1.2;
    } else if (isDesktop && screenHeight >= 1000) {
      return 1.3;
    }

    return 1.1;
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Platform.isLinux || Platform.isMacOS || Platform.isWindows;
    bool isLargeTablet = MediaQuery.of(context).size.shortestSide >= 1024;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SwitchColumn(
          title: widget.title,
          isDialog: widget.isDialog,
          subtitle: widget.subtitle,
          numUnread: 0,
        ),
        SizedBox(width: isTablet? (isVertical? 0.01.w : 0.01.w) : 0.04.w,),
        GestureDetector(
            onTap: () {
              hapticController.triggerHapticFeedback(
                  vibration: VibrateType.lightImpact,
                  hapticFeedback: HapticFeedback.lightImpact);
              setState(() {
                setState(() {
                  widget.switchValue = !widget.switchValue;
                  widget.switchValueState(widget.switchValue);
                });
              });
            },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(Get.locale.toString().contains('en') ? 0: math.pi),
              child: FlutterSwitch(
                width: isTablet ? (isVertical ? (isLargeTablet? 0.055.w : 0.06.w) : 0.042.w) : 0.11.w,
                height: isTablet ? (isVertical ? (  0.022.h) : (isLargeTablet? 0.029.h : 0.035.h)) : 0.03.h,
                value: widget.switchValue,
                padding: isDesktop? getSwitchSize(context) : isTablet ? (isVertical ? 1 : 1.5) : 1,
                activeColor: AppColors.lightPrimary,
                onToggle: (newValue) {
                  setState(() {
                    setState(() {
                      widget.switchValue = !widget.switchValue;
                      widget.switchValueState(widget.switchValue);
                    });
                  });
                },
              ),
            )),
      ],
    );
  }
}
