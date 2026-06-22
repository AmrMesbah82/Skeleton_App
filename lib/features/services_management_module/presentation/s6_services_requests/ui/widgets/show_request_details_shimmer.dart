import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';


Widget shimmerPlaceholder(  BuildContext context ,{double width = double.infinity, double height = 20}) {
  return Shimmer.fromColors(
    baseColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.background,
    highlightColor: Theme.of(context).brightness == Brightness.light ? AppColors.background : AppColors.chatBackground,
    direction: ShimmerDirection.ltr,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.chatBackground,
        //borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}