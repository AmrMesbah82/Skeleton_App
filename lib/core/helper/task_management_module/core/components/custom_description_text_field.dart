import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_font_size.dart';import 'package:demo_app/core/theme/app_colors.dart';

class CustomDescriptionTextField extends StatefulWidget {
  final int? maxLength;
  final TextEditingController controller;
  final bool enabled;
  final String hint;

  const CustomDescriptionTextField({
    super.key,
    this.maxLength,
    required this.controller,
    required this.hint,
    this.enabled = true,
  });

  @override
  State<CustomDescriptionTextField> createState() =>
      _CustomDescriptionTextFieldState();
}

class _CustomDescriptionTextFieldState
    extends State<CustomDescriptionTextField> {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return TextField(
      maxLength: widget.maxLength ?? 200,
      controller: widget.controller,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        enabled: widget.enabled,
        hintText: widget.hint.tr,
        hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
            color: AppColors.colorGrey,
            height: Get.locale.toString().contains('en')
                ? isTablet
                ? 2
                : 1.8
                : 1.2,
            fontSize: isTablet
                ? FontConstants.fontSize021.h
                : FontConstants.fontSize016.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppColors.signOut),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: orientation == Orientation.portrait ? 0.01.h : 0.015.h,
          horizontal: isTablet ? 0.012.w : 0.02.w,
        ),
        counter: Align(
          alignment: Alignment.centerRight, // Aligns the counter to the right
          child: Text(
            '${widget.controller.text.length}/${widget.maxLength ?? 200}',
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: orientation == Orientation.portrait
                  ? FontConstants.fontSize012.h
                  : FontConstants.fontSize018.h,
              color: AppColors.colorGrey,
            ),
          ),
        ),
      ),

      maxLines: 10,
      style: AppFontStyle.cairoRegularStyle.copyWith(
        fontSize: isTablet
            ? orientation == Orientation.portrait
                ? FontConstants.fontSize015.h
                : FontConstants.fontSize020.h
            : FontConstants.fontSize016.h,
        color: Theme.of(context).colorScheme.onInverseSurface,
      ),
      textAlignVertical: TextAlignVertical.center,
      cursorHeight: orientation == Orientation.portrait ? 0.015.h : 0.02.h,
      cursorWidth: 0.002.w,
      keyboardType: TextInputType.multiline,
    );
  }
}
