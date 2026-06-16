import 'package:demo_app/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


import 'package:demo_app/core/theme/app_font_size.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:demo_app/core/theme/app_colors.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/core/new_theme.dart';

// ignore: must_be_immutable
class CustomField extends StatefulWidget {
  TextEditingController controller;
  final String hintText;
  final String imagePath;
  final bool showSuffix;
  final Function()? onTap;
  String? Function(String?)? validator;
  ValueChanged<TextEditingController>? onfinishState;
  final Color? fillColor; // Optional fillColor parameter

  CustomField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.imagePath,
    this.showSuffix = false,
    this.onTap,
    this.validator,
    this.onfinishState,
    this.fillColor, // Optional parameter
  });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool _obscureText = true;
  bool _isHovering = false; // Track hover state

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    // Use provided fillColor or default based on theme
    Color fillColor = widget.fillColor ??
        AppColors.background;

    // Safe color getter with fallback
    Color getHintColor() {
      try {
        return AppColors.secondaryText;
      } catch (e) {
        // Fallback to theme hint color if custom colors fail
        return Theme.of(context).hintColor;
      }
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          setState(() {});
        },
        onFieldSubmitted: (value) {
          if (widget.onfinishState != null) {
            widget.onfinishState!(widget.controller);
          }
        },
        obscureText: widget.showSuffix ? _obscureText : false,
        style: StyleText.fontSize14Weight400.copyWith(
          color: AppColors.secondaryText
        ),
        decoration: InputDecoration(
          hintText: widget.hintText.tr,
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorStyle: TextStyle(
            fontSize: FontConstants.fontSize018.h,
            color: Colors.red,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: AppColors.lightPrimary,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondaryContainer,
              width: 0.5,
            ),
          ),
          filled: true,
          fillColor: fillColor,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 0.02.h,
              horizontal: isTablet ? 0.015.h : 0.02.w,
            ),
            child: SvgPicture.asset(
              widget.imagePath,
              color: AppColors.lightPrimary,
              height: 0.025.h,
            ),
          ),
          suffixIcon: widget.showSuffix
              ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 0.015.h : 0.02.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                size: 0.027.h,
                color: AppColors.lightPrimary,
              ),
            ),
          )
              : null,
          hintStyle: StyleText.fontSize14Weight500.copyWith(
            color: getHintColor(),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0.01.h),
        ),
        onTap: widget.onTap,
        cursorColor: AppColors.colorGrey,
      ),
    );
  }
}