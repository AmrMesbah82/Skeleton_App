import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';



bool isTabletLandscape(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final isLandscape =
      MediaQuery.of(context).orientation == Orientation.landscape;
  return size.width >= 600 && isLandscape;
}

Widget infoBox(
    BuildContext context,
    String title,
    String value,
    Color colorBorder,
    ) {
  var isMobile = context.isPhone;
  return Container(
    height: isMobile ? 30.sp : 38.sp,
    width: isMobile ? 100.sp : !isTabletLandscape(context) ? 130.sp : 150.sp,
    decoration: BoxDecoration(
      color:
      Theme.of(context).brightness == Brightness.light
          ? AppColors.background
          : AppColors.background,
      borderRadius: BorderRadius.circular(4.r),
      border: Border.all(color: colorBorder),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          FormatHelper.capitalize(title),
          style: isMobile ? AppTextStyles.font10BlackCairoRegular.copyWith(
            color:
            Theme.of(context).brightness == Brightness.light
                ? AppColors.secondaryText
                : AppColors.grey,
          ): AppTextStyles.font14BlackCairoMedium.copyWith(
            color:
            Theme.of(context).brightness == Brightness.light
                ? AppColors.secondaryText
                : AppColors.grey,
          ),
        ),
        SizedBox(width: 6.sp),
        Text(
          FormatHelper.capitalize(value),
          style: isMobile ? AppTextStyles.font10BlackCairoRegular.copyWith(
            color:
            Theme.of(context).brightness == Brightness.light
                ? AppColors.blackButton
                : AppColors.white,
          ):  AppTextStyles.font14BlackCairoMedium.copyWith(
            color:
            Theme.of(context).brightness == Brightness.light
                ? AppColors.blackButton
                : AppColors.white,
          ),
        ),
      ],
    ),
  );
}
