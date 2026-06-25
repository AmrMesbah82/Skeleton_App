import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_colors.dart';

class ReusableIconContainer extends StatelessWidget {
  final String imagePath;
  final void Function()? onPressed;
  bool? isDarkBackground;
  Function(TapUpDetails)? onTapUp;
  final bool? filterColor;

  ReusableIconContainer({
    super.key,
    required this.imagePath,
    this.filterColor = false,
    this.onPressed,
    this.onTapUp,
    this.isDarkBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GestureDetector(
      onTap: onPressed,
      onTapUp: onTapUp,
      child: Container(
        width: isTablet
            ? orientation
                ? 0.06.w
                : 0.045.w
            : 0.12.w,
        height: isTablet
            ? orientation
                ? 0.04.h
                : 0.052.h
            : 0.055.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: filterColor == true
              ? AppColors.signOut
              : isDarkBackground == true
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Center(
          child: Transform.scale(
            scale: 1,
            child: SvgPicture.asset(
              imagePath,
              color: filterColor == true
                  ? AppColors.textButton
                  : Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ),
      ),
    );
  }
}
