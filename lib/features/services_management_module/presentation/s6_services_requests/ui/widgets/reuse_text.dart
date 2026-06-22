import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/show_requests_shimmer.dart';

import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

Widget textCorner({
  required String image,
  required String label,
  required String content,
  required BuildContext context,
}) {
  final isShimmer = content.trim() == "...";
  var isMobile = context.isPhone;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SvgPicture.asset(image,
        width: 16.w,
        height: 16.h,
        fit: BoxFit.fill,
      ),
      SizedBox(width: 5.w),
      Text(
        FormatHelper.capitalize(label),
        style: AppTextStyles.font14BlackCairoRegular.copyWith(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.secondaryText
              : AppColors.grey,
        ),
      ),

      isShimmer
          ? Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: masterShimmerPlaceholder(context: context, width: 100.w, height: 5.sp),
        ),
      )
          : Expanded(
        child: Text(
          FormatHelper.capitalize(content),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font14BlackCairoRegular.copyWith(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.blackButton
                : AppColors.white,
          ),
        ),
      )

    ],
  );
}
