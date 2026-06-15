/// ************************* FILE INFO *************************
/// File Name: 35-custom_search_widget_custom.dart
/// purpose: app custom search text field (uses CustomTextField)
/// Created by: Mohamed Elrashidy
/// Created on: 5/5/2025

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/33-custom_haptic.dart';
import 'package:demo_app/core/theme/app_theme.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/custom/2-custom_textfield.dart';
import '../theme/app_colors.dart';

class AppSearchTextField extends StatelessWidget {
  AppSearchTextField({
    required this.controller,
    required this.onChanged,
    super.key,
    this.fillColor,
    this.hintText, // ✅ Added optional hint parameter
  });

  final TextEditingController controller;
  final Color? fillColor;
  final dynamic Function(String)? onChanged;
  final String? hintText; // ✅ Optional hint text

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        controller: controller,
        onChanged: onChanged,
        hint: hintText ?? S.of(context).search, // ✅ Use custom hint or default to search
        maxLines: 1,
        fillColor: fillColor ?? AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        hintStyle: AppTextStyles.font14SecondaryBlackCairo.copyWith(
          height: 1,
          color: AppTheme.isDark
              ? AppColors.lightGrey
              : AppColors.secondaryBlack,
        ),
        prefixIcon: SvgPicture.asset(
          "assets/images/search_icon.svg",
          width: 24.w,
          height: 24.h,
          color: AppTheme.isDark
              ? AppColors.lightGrey
              : AppColors.secondaryBlack,
        ),
        onTap: () {
          hapticController.triggerHapticFeedback(
            vibration: VibrateType.lightImpact,
            hapticFeedback: HapticFeedback.lightImpact,
          );
        },
      ),
    );
  }
}
