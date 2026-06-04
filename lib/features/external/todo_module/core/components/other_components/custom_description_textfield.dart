import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_text_styles.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';

// ignore: must_be_immutable
class CustomDescriptionTextField extends StatefulWidget {
  final int? maxLength;
  final TextEditingController controller;
  bool enabled;
  final Color? fillColor;
  String? Function(String?)? validator;
  final TextDirection? textDirection;
  final String? hint;
  final int? maxLines;
  final double? buttonHeight;
  bool hasBeenTouched;

  CustomDescriptionTextField(
      {super.key,
      this.maxLength,
      this.hasBeenTouched = false,
      this.buttonHeight,
      this.maxLines,
      this.hint,
      this.fillColor,
      required this.controller,
      this.enabled = true,
      this.textDirection,
      this.validator});

  @override
  State<CustomDescriptionTextField> createState() =>
      _CustomDescriptionTextFieldState();
}

class _CustomDescriptionTextFieldState
    extends State<CustomDescriptionTextField> {
  // late bool _hasBeenTouched; // State-managed variable

  @override
  void initState() {
    super.initState();
    // _hasBeenTouched = widget.hasBeenTouched; // Initialize from widget
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: widget.buttonHeight,
      child: TextFormField(
        maxLength: widget.maxLength ?? 500,
        controller: widget.controller,
        textDirection: widget.textDirection,
        onChanged: (value) => setState(() {
          widget.hasBeenTouched = true;
          // _hasBeenTouched = true; // Modify STATE variable
        }),
        // buildCounter: (
        //   context, {
        //   required currentLength,
        //   required isFocused,
        //   maxLength,
        // }) {
        //   return Row(
        //     textDirection: widget.textDirection,
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Builder(
        //         builder: (context) {
        //           if (_hasBeenTouched || widget.hasBeenTouched) {
        //             final errorText = widget.validator!(widget.controller.text);
        //             return errorText != null
        //                 ? Text(
        //                     errorText,
        //                     style: AppFontStyle.cairoRegularStyle.copyWith(
        //                       fontSize: 13,
        //                       color: MyThemeData.colorRed,
        //                       fontWeight: FontWeight.w500,
        //                     ),
        //                   )
        //                 : const SizedBox.shrink();
        //           }
        //           return const SizedBox.shrink();
        //         },
        //       ),
        //       Spacer(),
        //       Text(
        //         widget.textDirection == TextDirection.ltr
        //             ? "$currentLength/$maxLength"
        //             : "${convertNumberToArabic(currentLength.toString())}/${convertNumberToArabic(maxLength.toString())}",
        //         style: AppFontStyle.cairoRegularStyle.copyWith(
        //           fontSize: 14,
        //           color: MyThemeData.colorGrey,
        //         ),
        //       ),
        //     ],
        //   );
        // },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
          hoverColor: Colors.transparent,
          filled: widget.fillColor != null ? true : false,
          fillColor:
              isDark ? MyThemeData.colorBlack : MyThemeData.colorLightGrey,
          enabled: widget.enabled,
          hintText: widget.hint?.tr ?? "Type Here".tr,
          hintTextDirection: widget.textDirection ?? TextDirection.ltr,
          hintStyle: AppTextStyles.font10BlackCairoRegular.copyWith(
              color: isDark ? AppColors.mediumGrey : AppColors.inverseBase,
              height: 1,
              fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: MyThemeData.lightPrimary),
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent)),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          counterStyle: AppTextStyles.font10BlackCairoRegular
              .copyWith(fontSize: 14, color: MyThemeData.colorGrey),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
          ),
        ),
        maxLines: widget.maxLines ?? 4,
        style: AppTextStyles.font10BlackCairoRegular.copyWith(
          fontSize: 14,
          height: 1.5,
          color: AppColors.text,
        ),
        textAlignVertical: TextAlignVertical.center,
        cursorWidth: 2,
        keyboardType: TextInputType.multiline,
        validator: widget.validator,
      ),
    );
  }
}
