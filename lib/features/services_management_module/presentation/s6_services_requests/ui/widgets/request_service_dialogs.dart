/// ******************* FILE INFO *******************
/// File Name: request_service_dialogs.dart
/// Description: Reusable dialogs for service request flow
/// Created by: Amr Mesbah
/// Last Update: 02/02/2026

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:lottie/lottie.dart';

import 'package:demo_app/core/enumeration/enum.dart' as FormatHelper;
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';


class RequestServiceDialogs {
  /// Show confirmation dialog before creating request
  static Future<bool?> showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (confirmDialogContext) {
        final lightMode = Theme.of(confirmDialogContext).brightness == Brightness.light;

        return Dialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            width: 411.sp,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/create request.json',
                  width: 70.w,
                  height: 70.h,
                  fit: BoxFit.scaleDown,
                  repeat: true,
                  animate: true,
                ),
                SizedBox(height: 8.h),
                Text(
                  FormatHelper.capitalize(
                    S.of(confirmDialogContext).RequestService,
                  ),
                  style: AppTextStyles.font20BlackCairoMedium.copyWith(
                    color: AppColors.text
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    FormatHelper.capitalize(
                      S.of(confirmDialogContext).AreYouSureYouWantToRequestThisService,
                    ),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font14BlackCairoMedium.copyWith(
                      color: AppColors.secondaryText
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customButtonAnimation(
                      title: FormatHelper.capitalize(
                        S.of(confirmDialogContext).no,
                      ),
                      function: () => Navigator.of(
                        confirmDialogContext,
                        rootNavigator: true,
                      ).pop(false),
                      textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color: lightMode ? AppColors.black : AppColors.white,
                      ),
                      width: 135.sp,
                      height: 38.sp,
                      color: lightMode ? AppColors.grey : AppColors.mediumGrey,
                    ),
                    SizedBox(width: 15.w),
                    customButtonAnimation(
                      title: FormatHelper.capitalize(
                        S.of(confirmDialogContext).yes,
                      ),
                      function: () => Navigator.of(
                        confirmDialogContext,
                        rootNavigator: true,
                      ).pop(true),
                      textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color: AppColors.textButton,
                      ),
                      width: 135.sp,
                      height: 38.sp,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show loading dialog while processing request
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (loadingContext) {
        final lightMode = Theme.of(loadingContext).brightness == Brightness.light;

        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleProgressMaster(),
                  SizedBox(height: 20.h),
                  Text(
                    FormatHelper.capitalize(S.of(loadingContext).pleaseWait),
                    style: AppTextStyles.font16BlackMediumCairo.copyWith(
                      color: AppColors.text
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Show success dialog after request is created
  static Future<void> showSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (successContext) {
        final lightMode = Theme.of(successContext).brightness == Brightness.light;

        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              width: 411.sp,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/lottie/approved.json',
                    width: 70.w,
                    height: 70.h,
                    fit: BoxFit.scaleDown,
                    repeat: false,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    FormatHelper.capitalize(
                      S.of(successContext).serviceRequested,
                    ),
                    style: AppTextStyles.font20BlackCairoMedium.copyWith(
                      color: AppColors.text
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      FormatHelper.capitalize(
                        S.of(successContext).YouSuccessfullyRequestedThisService,
                      ),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font14BlackCairoMedium.copyWith(
                        color: AppColors.secondaryText
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Show error dialog when request fails
  static void showErrorDialog(
      BuildContext context, {
        String? message,
      }) {
    showDialog(
      context: context,
      builder: (errorContext) {
        final lightMode = Theme.of(errorContext).brightness == Brightness.light;

        return AlertDialog(
          backgroundColor: lightMode
              ? AppColors.white
              : AppColors.chatBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          title: Text(
            FormatHelper.capitalize(S.of(errorContext).error),
            style: AppTextStyles.font20BlackCairoMedium.copyWith(
              color: lightMode
                  ? AppColors.blackButton
                  : AppColors.white,
            ),
          ),
          content: Text(
            message ?? "Failed to create service request. Please try again.",
            style: AppTextStyles.font14BlackCairoMedium.copyWith(
              color: lightMode
                  ? AppColors.secondaryText
                  : AppColors.grey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(errorContext).pop(),
              child: Text(
                FormatHelper.capitalize(S.of(errorContext).ok),
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Close any open dialog
  static void closeDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  /// Close dialog with root navigator
  static void closeDialogWithRoot(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
