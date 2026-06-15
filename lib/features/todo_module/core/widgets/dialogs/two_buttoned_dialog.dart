import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/custom_icon_button.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:lottie/lottie.dart';

class TwoButtonedDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;
  final String lottieAsset;

  const TwoButtonedDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    required this.lottieAsset,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: isTablet ? 350 : double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                lottieAsset,
                width: 80,
                height: 80,
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(height: 18),
              Text(
                title.tr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkWhite : AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Text(
                subtitle.tr,
                style: TextStyle(
                    fontSize: 15,
                    color: isDark ? AppColors.lightGrey : AppColors.inverseBase,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              isTablet
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconButton(
                            height: 44,
                            width: 165,
                            isSearchButton: true,
                            buttonColor:
                                isDark ? AppColors.blackShadow : AppColors.grey,
                            textColor:
                                isDark ? AppColors.whiteDark : AppColors.text,
                            buttonText: "No".tr,
                            imagePath: "",
                            hasIcon: false,
                            onPressed: onSecondaryPressed),
                        SizedBox(width: 15),
                        CustomIconButton(
                            height: 44,
                            width: 165,
                            isSearchButton: true,
                            buttonColor: AppColors.primary,
                            textColor: AppColors.text,
                            buttonText: "Yes".tr,
                            imagePath: "",
                            hasIcon: false,
                            onPressed: onPrimaryPressed),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CustomIconButton(
                              height: 44,
                              isSearchButton: true,
                              buttonColor: isDark
                                  ? AppColors.blackShadow
                                  : AppColors.grey,
                              textColor:
                                  isDark ? AppColors.whiteDark : AppColors.text,
                              buttonText: "No".tr,
                              imagePath: "",
                              hasIcon: false,
                              onPressed: onSecondaryPressed),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomIconButton(
                              height: 44,
                              isSearchButton: true,
                              buttonColor: AppColors.primary,
                              textColor: AppColors.text,
                              buttonText: "Yes".tr,
                              imagePath: "",
                              hasIcon: false,
                              onPressed: onPrimaryPressed),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
