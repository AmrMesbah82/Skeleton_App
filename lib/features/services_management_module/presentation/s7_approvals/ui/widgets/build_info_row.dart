import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';


class InfoRowApproval extends StatelessWidget {
  final String? image;
  final String? title;
  final String? value;

  const InfoRowApproval(
      this.image,
      this.title,
      this.value, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return Padding(
      padding: EdgeInsets.only(bottom: 4.sp),
      child: Row(
        children: [
          if (image != null)
            SvgPicture.asset(
              image!,
              width: 16.sp,
              height: 16.sp,
            ),
          if (image != null) SizedBox(width: 6.sp),
          if (title != null)
            Text(
              "$title ",
              style: AppTextStyles.font14BlackCairoRegular.copyWith(
                color: lightMode ? AppColors.secondaryText : AppColors.grey,
              ),
            ),
          Expanded(
            child: Text(
              FormatHelper.capitalize(value ?? "-"),
              style: AppTextStyles.font14BlackCairoRegular.copyWith(
                color: lightMode ? AppColors.blackButton : AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
