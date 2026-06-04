// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';

/// Date Created :9/March/2025
/// Developer Name : Ahmed Mahmoud

class ReusableIconContainer extends StatelessWidget {
  final String imagePath;
  final void Function()? onPressed;
  bool? isDarkBackground;
  Function(TapUpDetails)? onTapUp;
  final bool? filterColor;
  final bool? backgroundRed;
  final bool? foregroundWhite;
  final bool? secondaryColor;
  final double? iconWidth;
  final double? iconHeight;
  ReusableIconContainer({
    this.secondaryColor = false,
    this.backgroundRed = false,
    this.foregroundWhite = false,
    super.key,
    required this.imagePath,
    this.filterColor = false,
    this.onPressed,
    this.onTapUp,
    this.isDarkBackground = false,
    this.iconWidth,
    this.iconHeight,
  });

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GestureDetector(
      onTap: onPressed,
      onTapUp: onTapUp,
      child: Container(
        height: 38,
        width: isPortrait ? 38 : 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundRed == true
              ? Color.fromRGBO(223, 28, 28, 1)
              : filterColor == true
                  ? secondaryColor == true
                      ? AppColors.secondaryPrimary
                      : AppColors.primary
                  : AppColors.white,
        ),
        child: Center(
            child: SvgPicture.asset(
          imagePath,
          height: iconHeight ?? 24,
          width: iconHeight,
          color: foregroundWhite == true
              ? const Color.fromRGBO(255, 255, 255, 1)
              : filterColor == true
                  ? AppColors.black
                  : AppColors.white,
        )),
      ),
    );
  }
}
