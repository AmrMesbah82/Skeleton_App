import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';

Widget customCalendarTimeWidget({
  required BuildContext context,
  required String text,
  required String svgPath,
}) {
  final themeController = Get.find<ThemeController>();
  bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  final TextStyle blackTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
    fontSize:
        isPortrait ? FontConstants.fontSize015.h : FontConstants.fontSize014.w,
    color: themeController.currentTheme == AppColors.lightTheme
        ? AppColors.colorBlack
        : AppColors.colorWhiteDark,
    fontWeight: Get.locale.toString().contains('en')
        ? FontWeight.w600
        : FontWeight.w500,
  );

  return Row(
    children: [
      SvgPicture.asset(
        svgPath,
        color: themeController.currentTheme == AppColors.lightTheme
            ? null
            : AppColors.colorWhite,
            height: isPortrait ? 0.015.h :null,
      ),
      SizedBox(width: isPortrait ?  0.01.w : 0.005.w),
      Text(
        text,
        style: blackTextStyle.copyWith(height: 1.68),
      ),
    ],
  );
}
