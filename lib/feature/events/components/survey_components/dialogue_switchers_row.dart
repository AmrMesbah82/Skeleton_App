import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class DialogueSwitchersRow extends StatefulWidget {
  DialogueSwitchersRow(
      {super.key,
      required this.title,
      this.isAnalytics = false,
      required this.switchValue,
      required this.switchValueState});
  final String title;
  bool? isAnalytics;
  bool switchValue;
  ValueChanged<bool> switchValueState;

  @override
  State<DialogueSwitchersRow> createState() => _DialogueSwitchersRowState();
}

class _DialogueSwitchersRowState extends State<DialogueSwitchersRow> {
  final HapticController hapticController = Get.put(HapticController());

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
         widget.title.tr,
          style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: widget.isAnalytics ==true ? 
              (isVertical? isTablet? FontConstants.fontSize023.w:FontConstants.fontSize018.h : FontConstants.fontSize015.w) :FontConstants.fontSize020.h,
              color: Theme.of(context).colorScheme.onInverseSurface,
              fontWeight: FontWeight.w500,
              height: 1.6),
        ),
        Spacer(),
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
              transform: Matrix4.rotationY(
                  Get.locale.toString().contains('en') ? 0 : math.pi),
              child: FlutterSwitch(
                width: isTablet ? (isVertical ? 0.065.w : 0.045.w) : 0.11.w,
                height: isTablet ? (isVertical ? 0.022.h : 0.035.h) : 0.03.h,
                value: widget.switchValue,
                padding: isTablet ? (isVertical ? 1 : 1.5) : 0.4,
                activeColor: MyThemeData.lightPrimary,
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
