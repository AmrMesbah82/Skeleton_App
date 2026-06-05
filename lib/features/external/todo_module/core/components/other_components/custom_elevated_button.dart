// last Edit :16/August/2923 by mazen
// ignore_for_file: unnecessary_null_in_if_null_operators

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';
import 'package:demo_app/features/external/todo_module/core/constants/enum.dart';
import 'package:demo_app/features/external/todo_module/core/constants/haptic_controller.dart';
import 'package:demo_app/features/external/todo_module/core/constants/screen_size.dart';

// ignore: must_be_immutable
class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? buttonText;
  final bool istrue;
  final double? height;
  final bool isGrey;
  ButtonStyle? buttonStyle;
  Color? textColor;
  final FontWeight? fontweight;
  final double? fontSize;
  final double? letterSpacing;
  final double? textHeight;
  final Widget? buttonWidget;
  final bool isButtonWidget;
  final String? widgetIcon;
  final double? iconHeight;
  final double? scale;
  final bool hasText;

  CustomElevatedButton({
    super.key,
    required this.onPressed,
    this.buttonText,
    this.buttonStyle,
    this.iconHeight,
    this.buttonWidget,
    this.fontSize,
    this.fontweight,
    this.hasText = true,
    this.textColor,
    this.isButtonWidget = false,
    this.height,
    this.letterSpacing,
    this.textHeight,
    this.widgetIcon,
    this.scale,
    this.istrue = false,
    this.isGrey = false,
  });

  @override
  Widget build(BuildContext context) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final ToDoHapticController hapticController =
        Get.find<ToDoHapticController>();
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: () {
          hapticController.triggerHapticFeedback(
              vibration: VibrateType.heavyImpact,
              hapticFeedback: HapticFeedback.heavyImpact);
          onPressed();
        },
        style: buttonStyle ??
            ElevatedButton.styleFrom(
              minimumSize: !istrue
                  ? Size(0.94.w, 0.060.h)
                  : Size(
                      orientation ? 0.7.w : 0.3.w, orientation ? 0.060.h : 0),
              backgroundColor:
                  !isGrey ? MyThemeData.signOut : MyThemeData.GreyBack,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(6),
              )),
            ),
        child: isButtonWidget == true
            ? Row(
                children: <Widget>[
                  Transform.scale(
                    scale: scale ?? 1.1,
                    child: SvgPicture.asset(widgetIcon as String,
                        height: iconHeight ?? null,
                        // ignore: deprecated_member_use
                        color: textColor ?? MyThemeData.colorBlack),
                  ),
                  hasText
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: Get.locale.toString().contains('en')
                                  ? isTablet
                                      ? 0.01.w
                                      : 0.025.w
                                  : 0,
                              right: Get.locale.toString().contains('en')
                                  ? 0
                                  : isTablet
                                      ? 0.01.w
                                      : 0.025.w),
                          child: Text(
                            buttonText as String,
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                                height: textHeight ?? 0.0018.h,
                                fontSize:
                                    fontSize ?? FontConstants.fontSize015.w,
                                fontWeight: FontWeight.w500,
                                color: textColor ?? MyThemeData.colorBlack),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              )
            : Text(
                buttonText as String,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: isTablet
                        ? fontSize ?? FontConstants.fontSize026.h
                        : fontSize ?? FontConstants.fontSize018.h,
                    color: textColor ?? MyThemeData.colorBlack,
                    height: textHeight ?? null,
                    /*color: Myclors.textmaincolor,*/
                    fontWeight: fontweight ??
                        FontWeight.lerp(
                            FontWeight.w500,
                            Get.locale.toString().contains('en')
                                ? FontWeight.w600
                                : FontWeight.w500,
                            0.5)!,
                    letterSpacing: letterSpacing ?? 1.2),
              ),
      ),
    );
  }
}
