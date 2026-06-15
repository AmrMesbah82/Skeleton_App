/// ******************* FILE INFO *******************
/// File Name: default_form_field.dart
/// Description: this is custom DefaultFormField can reuse
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025



import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';


class DefaultFormField extends StatelessWidget {
  DefaultFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.showBorder,
    this.enabledBorder,
    this.textAlign,
    this.width,
    this.inputTextStyle,
    this.hintStyle,
    this.style,
    this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backGroundColor,
    this.onChanged,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.prefixIcon2,
    this.label,
    this.readOnly,
    this.enabled,
    this.onTap,
    this.top,
    this.bottom,
    this.maxLength,
    this.expands,
    this.keyboardType,
    this.autovalidateMode,
    this.height,
    this.labelText,
    this.minLines,
    this.maxLines,
    this.collapsed,
    this.errorHeight,
    this.textDirection,
    this.alignCounterTextLeft = false,
    this.showCounter = false,
    this.helperText,
    this.focusNode,
    this.radius,
    this.initialValue,
  });

  final TextAlign? textAlign;
  final int? maxLength;
  final double? errorHeight;
  final bool? collapsed;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String)? onChanged;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle, style;
  final String? hintText;
  final bool? isObscureText, readOnly, enabled, showBorder;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefixIcon2;
  final Widget? label;
  final Color? backGroundColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double? top, bottom;
  final double? height;
  final double? width;
  final AutovalidateMode? autovalidateMode;
  final void Function()? onTap;
  final bool? expands;
  final TextInputType? keyboardType;
  final String? labelText;
  final int? minLines;
  final int? maxLines;
  final TextDirection? textDirection;
  final bool alignCounterTextLeft;
  final bool showCounter;
  final String? helperText;
  final FocusNode? focusNode;
  final double? radius;
  bool isShowError = false;
  String? errorText = '';
  String? initialValue;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: height?.h,
                child: TextFormField(
                  initialValue: initialValue,
                  buildCounter: (context,
                      {required currentLength,
                        required isFocused,
                        required maxLength}) =>
                  const SizedBox.shrink(),
                  focusNode: focusNode,
                  textDirection: textDirection,
                  textInputAction: TextInputAction.done,
                  keyboardType: keyboardType,
                  expands: expands ?? false,
                  autovalidateMode:
                  autovalidateMode ?? AutovalidateMode.onUserInteraction,
                  onTap: onTap,
                  controller: controller,
                  onChanged: (val) {
                    if (onChanged != null) onChanged!(val);
                    setState(() {});
                  },
                  minLines: minLines,
                  maxLines: maxLines ?? 1,
                  readOnly: readOnly ?? false,
                  enabled: enabled,
                  maxLength: maxLength,
                  textAlignVertical: (height ?? 0) < 60.h
                      ? TextAlignVertical.center
                      : TextAlignVertical.top,
                  textAlign: textAlign ?? TextAlign.start,
                  cursorColor: AppColors.primary,
                  obscureText: isObscureText ?? false,
                  style: style ?? AppTextStyles.font14BlackCairoRegular,
                  validator: (value) {
                    var flag = validator?.call(value);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        isShowError = flag != null;
                        errorText = flag ?? '';
                      });
                    });
                    return flag;
                  },
                  decoration: InputDecoration(
                    hoverColor: Colors.transparent,
                    helperText: helperText,
                    counterStyle: GoogleFonts.cairo(
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: context.isTablett ? 13.sp : 10.sp,
                    ),
                    hintStyle: hintStyle ??
                        AppTextStyles.font12BlackCairo.copyWith(
                          color: AppColors.secondaryText
                        ),
                    isCollapsed: collapsed ?? false,
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                    labelText: labelText,
                    label: label,
                    prefixIcon: prefixIcon != null
                        ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.sp, horizontal: 0.sp),
                      child: prefixIcon,
                    )
                        : null,
                    contentPadding: contentPadding ??
                        EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
                    focusedBorder: focusedBorder ?? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius ?? 6.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    enabledBorder: enabledBorder ?? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius ?? 6.r),
                      borderSide: showBorder ?? true
                          ? BorderSide(color: Colors.transparent)
                          : BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius ?? 6.r),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius ?? 6.r),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    fillColor: backGroundColor ?? AppColors.card,
                    filled: true,
                    hintText: hintText,
                    suffixIcon: suffixIcon != null
                        ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.r, horizontal: 8.r),
                      child: suffixIcon,
                    )
                        : null,
                  ),
                ),
              ),
              if (isShowError)
                Positioned(
                  bottom: -20.sp,
                  left: 8.w,
                  child: Text(
                    errorText ?? '',
                    style: AppTextStyles.font12RedRegularCairo,
                  ),
                ),
            ],
          ),
          if (showCounter)
            Padding(
              padding: EdgeInsets.only(top: 4.sp),
              child: Row(
                children: [
                  if (alignCounterTextLeft) const Spacer(),
                  Text(
                    alignCounterTextLeft
                        ? "${controller?.text.length}/$maxLength"
                        : "${controller?.text.length}/$maxLength",
                    style: GoogleFonts.cairo(
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: context.isTablett ? 13.sp : 14.sp,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
extension ScreenTypeExtension on BuildContext {
  bool get isTablett {
    final width = MediaQuery.of(this).size.width;
    return width >= 600; // Adjust this threshold based on your tablet breakpoint
  }
}