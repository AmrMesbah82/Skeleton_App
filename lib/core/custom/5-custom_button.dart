import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import '../theme/app_colors.dart';

Widget customButton({
  required String title,
  required VoidCallback function,
  double? width,
  double? height,
  double radius = 8,
  Color? color,
  Color? textColor,
  Color? borderColor,
  TextStyle? textStyle,
}) {
  final isDark = Get.isDarkMode;

  return GestureDetector(
    onTap: function,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? AppColors.primary,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: textStyle ??
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor ?? (isDark ? Colors.white : Colors.black),
              ),
        ),
      ),
    ),
  );
}

/*
// ── Usage ─────────────────────────────────────────────────────────────────────
customButton(
  title: 'Save',
  function: () {},
  width: 200,
  height: 48,
  radius: 8,
  color: AppColors.primary,
  textColor: AppColors.textButton,
)
*/
