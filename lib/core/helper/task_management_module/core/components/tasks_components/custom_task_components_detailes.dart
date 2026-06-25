import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/helper/task_management_module/core/components/selection_user.dart';
import 'package:demo_app/core/theme/app_colors.dart';


class CustomContainerWithImage extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback? onPressed;
  final bool changeColor;
  final bool isShown;

  const CustomContainerWithImage({
    super.key,
    required this.imagePath,
    required this.text,
    this.onPressed,
    this.changeColor = false,
    this.isShown = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isTablet ? null : 0.4.w,
        padding: EdgeInsets.symmetric(
            vertical: 0.005.h,
            horizontal: isTablet
                ? orientation
                ? 0.015.w
                : 0.03.h
                : 0.0.w),
        decoration: BoxDecoration(
          color: changeColor == true
              ? isShown ? AppColors.primary : AppColors.grey
              : themeController.currentTheme == AppColors.lightTheme
              ? AppColors.moreLightGrey
              : AppColors.colorBlack,
          border: Border.all(
            color:
            changeColor == true ? Colors.transparent : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: isTablet ? null : 0.05.w,
              child: SvgPicture.asset(
                imagePath,
                color: changeColor == true
                    ? AppColors.textButton
                    : AppColors.colorDarkGrey,
                height: isTablet ? null : 0.038.h,
              ),
            ),
            SizedBox(width: 0.01.h),
            Text(
              text.tr,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isTablet
                      ? orientation
                      ? FontConstants.fontSize019.h
                      : FontConstants.fontSize022.h
                      : FontConstants.fontSize018.h,
                  fontWeight: FontWeight.w500,
                  color: changeColor == true
                      ? AppColors.textButton
                      : AppColors.colorDarkGrey,
                  height: isTablet ? 1.8 : 0.002.h),
            ),
          ],
        ),
      ),
    );
  }
}
