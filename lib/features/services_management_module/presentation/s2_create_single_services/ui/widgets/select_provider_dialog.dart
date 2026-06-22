import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:lottie/lottie.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/core/custom/37-custom_navigate.dart';




Future<void> updateServiceProviderDialog(BuildContext context, VoidCallback onYesPressed) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? AppColors.white
          : AppColors.chatBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: SizedBox(
          width: 411.sp,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/createServices.json',
                width: 70.w,
                height: 70.h,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(height: 20.h),
              Text(
                S.of(context).changingServiceProvider,
                style: AppTextStyles.font20BlackCairoMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.blackButton
                      : AppColors.white,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                S.of(context).confirmChangeServiceProvider,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.secondaryText
                      : AppColors.grey,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  customButtonAnimation(
                    title: S.of(context).no,
                    function: () {
                      Navigator.of(context).pop(); // Dismiss dialog
                    },
                    textStyle: AppTextStyles.font15BlackCairoRegular,
                    width: 135.w,
                    height: 38.h,
                    radius: 4.r,
                    color: AppColors.secondaryButton,
                  ),
                  customButtonAnimation(
                    title: S.of(context).yes,
                    function: () {
                      Navigator.of(context).pop(); // Close dialog first
                      onYesPressed(); // Run passed function
                    },
                    textStyle: AppTextStyles.font15BlackCairoRegular,
                    width: 135.w,
                    height: 38.h,
                    radius: 4.r,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}



Future<void> updateServiceProviderSuccessDialog(BuildContext context) async {
  final rootContext = context;
  bool navigated = false;

  await showDialog(
    context: rootContext,
    barrierDismissible: true,
    builder: (dialogContext) {
      // Timer for auto-navigation after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        if (!navigated) {
          navigated = true;
          Navigator.of(dialogContext).pop(); // Close dialog
          navigateAndFinish(rootContext, LayoutScreenServices());
        }
      });

      return WillPopScope(
        onWillPop: () async {
          if (!navigated) {
            navigated = true;
            Navigator.of(dialogContext).pop();
            navigateAndFinish(rootContext, LayoutScreenServices());
          }
          return false;
        },
        child: Dialog(
          backgroundColor: Theme.of(dialogContext).brightness == Brightness.light
              ? AppColors.white
              : AppColors.chatBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque, // make the whole dialog tappable
            onTap: () {
              if (!navigated) {
                navigated = true;
                Navigator.of(dialogContext).pop();
                navigateAndFinish(rootContext, LayoutScreenServices());
              }
            },
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: SizedBox(
                width: 410.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/lottie/approved.json',
                      width: 70.w,
                      height: 70.h,
                      fit: BoxFit.scaleDown,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      S.of(context).changingServiceProvider,
                      style: AppTextStyles.font20BlackCairoMedium.copyWith(
                        color: Theme.of(dialogContext).brightness == Brightness.light
                            ? AppColors.blackButton
                            : AppColors.white,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      S.of(context).successChangeServiceProvider,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font14BlackCairoMedium.copyWith(
                        color: Theme.of(dialogContext).brightness == Brightness.light
                            ? AppColors.secondaryText
                            : AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
