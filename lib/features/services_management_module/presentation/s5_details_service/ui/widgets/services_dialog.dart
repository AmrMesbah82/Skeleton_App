import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';


class OurServicesDialog extends StatelessWidget {
  const OurServicesDialog({
    super.key,
    required this.color,
    required this.image,
    required this.title,
    required this.number,
    this.crossAxisAlignment = CrossAxisAlignment.center, // ✅ Added parameter with default
  });

  final Color color;
  final String image;
  final String title;
  final String number;
  final CrossAxisAlignment crossAxisAlignment; // ✅ New parameter

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    return Row(
      crossAxisAlignment: crossAxisAlignment, // ✅ Use the parameter
      children: [
        SvgPicture.asset(
          image,
          width: 30.w,
          height: 30.h,
          fit: BoxFit.fill,
        ),
        SizedBox(width: 8.w),
        Container(
          width: isMobile ? 70.w : 130.w,
          child: Text(
            FormatHelper.capitalize(title),
            style: isMobile
                ? AppTextStyles.font12BlackMediumCairo.copyWith(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.secondaryText
                  : AppColors.grey,
            )
                : AppTextStyles.font16BlackMediumCairo.copyWith(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.secondaryText
                  : AppColors.grey,
            ),
          ),
        ),
        Spacer(),
        Text(
          FormatHelper.capitalize(number),
          style: isMobile
              ? AppTextStyles.font20BlackSemiBoldCairo.copyWith(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.blackButton
                : AppColors.white,
          )
              : AppTextStyles.font22BlackCairoSemiBold.copyWith(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.blackButton
                : AppColors.white,
          ),
        ),
      ],
    );
  }
}
