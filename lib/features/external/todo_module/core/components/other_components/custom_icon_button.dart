import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_text_styles.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';

/// Date Created 9/March/2025
/// Developer Name : Ahmed Mahmoud
/// Objectives:  this file represents customization button in creation and edit

class CustomIconButton extends StatefulWidget {
  final String buttonText;
  final String imagePath;
  final VoidCallback onPressed;
  final bool isOwnerHome;
  final Color? buttonColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? imageColor;
  final bool isReviewPage;
  final bool hasIcon;
  final bool? hasText;
  final bool? smallHeight;
  final double? radius;
  final double? width;
  final bool? isSearchButton;
  final double? height;
  final TextStyle? style;
  const CustomIconButton({
    super.key,
    this.hasText,
    required this.buttonText,
    required this.imagePath,
    required this.onPressed,
    this.width,
    this.isReviewPage = false,
    this.buttonColor,
    this.textColor,
    this.borderColor,
    this.imageColor,
    this.height,
    this.radius,
    this.isOwnerHome = false,
    this.hasIcon = true,
    this.smallHeight = false,
    this.isSearchButton = false,
    this.style,
  });

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return SizedBox(
      height: widget.height ?? 38,
      width: isTablet ? widget.width ?? 135 : widget.width ?? 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          foregroundColor: MyThemeData.colorBlack,
          backgroundColor: widget.buttonColor ?? AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              side: BorderSide(
                color: widget.borderColor ?? Colors.transparent,
              )),
        ),
        onPressed: widget.onPressed,
        child: widget.hasText == false
            ? SvgPicture.asset(
                widget.imagePath,
                height: 23,
                color: AppColors.darkGrey,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.hasIcon
                      ? SvgPicture.asset(
                          widget.imagePath,
                          height: 20,
                          color: widget.imageColor ?? AppColors.black,
                        )
                      : const SizedBox.shrink(),
                  widget.hasIcon
                      ? const SizedBox(width: 8)
                      : const SizedBox.shrink(),
                  Baseline(
                    baseline: 16,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      widget.buttonText.tr,
                      style: 
                          AppTextStyles.font23MediumBlackCairo.copyWith(
                            fontSize: 16,
                            height: 1,
                            color:  widget.textColor ?? AppColors.black,
                          ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
