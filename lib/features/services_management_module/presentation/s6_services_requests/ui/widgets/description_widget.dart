import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';


Widget descriptionWidget (BuildContext context , String descriptionAr, String descriptionEn)
{
  var lightMode = Theme.of(context).brightness == Brightness.light;
  var isMobile = context.isPhone;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          SizedBox(
            child: SvgPicture.asset(
              "assets/des.svg",
              width: 16.sp,
              height: 16.sp,
              color:
              AppColors.secondaryText.withOpacity(.4),
              fit: BoxFit.scaleDown,
              semanticsLabel: 'Dart Logo',
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            S.of(context).serviceDescription,
            style: isMobile ? AppTextStyles.font12BlackCairoRegular.copyWith(
              color:
              lightMode
                  ? AppColors.secondaryText
                  : AppColors.grey,
            ) :   AppTextStyles.font12BlackCairoRegular.copyWith(
              color:
              lightMode
                  ? AppColors.secondaryText
                  : AppColors.grey,
            ),

          ),
        ],
      ),
      SizedBox(height: 5.sp),
      Text(
        FormatHelper.capitalize(
          Localizations.localeOf(context).languageCode ==
              'ar'
              ? descriptionAr??
              ''
              : descriptionEn ??
              '',
        ),
        style: isMobile ?  AppTextStyles.font12BlackCairoRegular.copyWith(

          wordSpacing: -1.sp,
          color:
          lightMode
              ? AppColors.blackButton
              : AppColors.white,
        ) :  AppTextStyles.font13SecondaryBlackCairo.copyWith(
          color:
          lightMode
              ? AppColors.blackButton
              : AppColors.white,
        ),
        textAlign: TextAlign.start,
        softWrap: true,

        overflow: TextOverflow.visible,
      ),
    ],
  );
}
