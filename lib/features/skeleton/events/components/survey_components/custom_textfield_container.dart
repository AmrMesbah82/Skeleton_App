import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

// ignore: must_be_immutable
class CustomTextFieldContainer extends StatefulWidget {
  CustomTextFieldContainer(
      {super.key,
      required this.hint,
      this.hasPrefix = false,
      this.isPayment = false,
      this.prefixIcon,
      this.hasSuffix = false,
      this.suffixUrl,
      this.textController,
      this.fillColor,
      this.controllerState,
      this.sizerSuffix,
      this.validator,
      this.suffixHasColor = true,
      this.hassSuffixState,
      this.borderColor,
      this.suffixColor,
      this.textFieldHeight,
      this.maxLines,
      this.controllerfinishState,
      this.textStyle,
      this.enabled = true,
      this.hintStyle,
      this.isAssign = false});

  final String hint;
  TextEditingController? textController;
  ValueChanged<TextEditingController?>? controllerState;
  ValueChanged? controllerfinishState;
  final bool? hasPrefix;
  final bool? isPayment;
  final Widget? prefixIcon;
  bool? hasSuffix;
  String? Function(String?)? validator;
  ValueChanged<bool?>? hassSuffixState;
  final String? suffixUrl;
  final Color? fillColor;
  final double? sizerSuffix;
  final int? maxLines;
  final bool? suffixHasColor;
  final Color? borderColor;
  final double? textFieldHeight;
  final Color? suffixColor;
  final bool isAssign;
  TextStyle? textStyle;
  final bool enabled;
  TextStyle? hintStyle;

  @override
  State<CustomTextFieldContainer> createState() =>
      _CustomTextFieldContainerState();
}

class _CustomTextFieldContainerState extends State<CustomTextFieldContainer> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final orientation = MediaQuery.of(context).orientation;

    return Container(
      height: widget.textFieldHeight ??
          (isTablet
              ? widget.maxLines != null
                  ? null
                  : 0.065.h
              : widget.maxLines != null
                  ? null
                  : 0.045.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isTablet
            ? 8
            : widget.isAssign == true
                ? 0
                : 8),
        color: themeController.currentTheme == MyThemeData.lightTheme
            ? MyThemeData.colorLightGrey
            : MyThemeData.colorBlack,
        // border: widget.isAssign
        //     ? Border(
        //         bottom: BorderSide(
        //           color:
        //               widget.borderColor ?? Theme.of(context).colorScheme.scrim,
        //         ),
        //       )
        //     : Border.all(
        //         color:
        //             widget.borderColor ?? Theme.of(context).colorScheme.scrim,
        //       ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: widget.hasPrefix == true
                ? 0.015.h
                : Get.locale.toString().contains('en')
                    ? widget.isPayment == true
                        ? 0
                        : (isTablet ? 0.015.h : 0)
                    : 0.015.h),
        child: TextFormField(
          maxLines: widget.maxLines ?? 1,
          controller: widget.textController,
          enabled: widget.enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          scrollPadding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).viewInsets.bottom),
          decoration: InputDecoration(
            counterStyle: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: orientation == Orientation.portrait
                  ? FontConstants.fontSize012.h
                  : FontConstants.fontSize018.h,
              color: MyThemeData.colorGrey,
            ),
            hintText: widget.hint.tr,
            fillColor: widget.fillColor,
            prefixIcon: widget.hasPrefix == true ? widget.prefixIcon : null,
            suffixIcon: widget.hasSuffix == true
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.textController != null) {
                          widget.textController!.text = '';
                        }
                        widget.hasSuffix = false;
                        if (widget.hassSuffixState != null) {
                          widget.hassSuffixState!(widget.hasSuffix);
                        }
                      });
                    },
                    child: Transform.scale(
                      scale: widget.sizerSuffix ??
                          (isTablet
                              ? (orientation == Orientation.portrait
                                  ? Get.locale.toString().contains('en')
                                      ? 0.6
                                      : 1.8
                                  : Get.locale.toString().contains('en')
                                      ? 0.6
                                      : 1)
                              : Get.locale.toString().contains('en')
                                  ? 0.6
                                  : 1.8),
                      child: widget.suffixUrl != null
                          ? SvgPicture.asset(
                              widget.suffixUrl ?? '',
                              color: widget.suffixHasColor == false
                                  ? null
                                  : widget.suffixColor ??
                                      Theme.of(context).colorScheme.scrim,
                            )
                          : const SizedBox.shrink(),
                    ),
                  )
                : null,
            hintStyle: widget.hintStyle ??
                AppFontStyle.cairoRegularStyle.copyWith(
                    color: MyThemeData.colorGrey,
                    height: widget.hasPrefix == true
                        ? 1
                        : isTablet
                            ? (orientation == Orientation.portrait
                                ? Get.locale.toString().contains('en')
                                    ? 2.3
                                    : 1
                                : Get.locale.toString().contains('en')
                                    ? 2
                                    : 1.6)
                            : Get.locale.toString().contains('en')
                                ? null
                                : 0.3,
                    fontSize: isTablet
                        ? (orientation == Orientation.portrait
                            ? FontConstants.fontSize015.h
                            : FontConstants.fontSize022.h)
                        : FontConstants.fontSize015.h),
            border: widget.isAssign
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.borderColor ??
                          Theme.of(context).colorScheme.scrim,
                    ),
                  )
                : const OutlineInputBorder(borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(
                horizontal: widget.isPayment == true
                    ? 0.01.w
                    : (isTablet ? 0.012.w : 0.04.w),
                vertical: widget.isPayment == true
                    ? 0
                    : orientation == Orientation.portrait
                        ? 0.008.h
                        : 0.01.h),
          ),
          showCursor: false,
          style: widget.textStyle ??
              AppFontStyle.cairoRegularStyle.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface, //Theme.of(context).colorScheme.onInverseSurface,
                  height: isTablet
                      ? null
                      : (widget.maxLines != null
                          ? 1.6
                          : Get.locale.toString().contains('en')
                              ? 1.6
                              : null),
                  fontSize: isTablet
                      ? (orientation == Orientation.portrait
                          ? FontConstants.fontSize018.h
                          : FontConstants.fontSize022.h)
                      : FontConstants.fontSize019.h),
          onChanged: (value) {
            setState(() {
              if (widget.textController != null) {
                if (widget.textController!.text.isNotEmpty) {
                  widget.hasSuffix = true;
                } else {
                  widget.hasSuffix = false;
                }
                widget.hassSuffixState?.call(widget.hasSuffix);
              }
              widget.controllerState?.call(widget.textController);
            });
          },
          onEditingComplete: () {
            setState(() {
              widget.controllerfinishState?.call(widget.textController);
            });
          },
          cursorColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
