// In: lib/features/services_management_module/presentation/s2_create_single_services/ui/widgets/select_approval_success_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

class SuccessDialogMaster extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onDismiss;
  final String? lottiePath;

  const SuccessDialogMaster({
    Key? key,
    required this.title,
    required this.message,
    this.onDismiss,
    this.lottiePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              lottiePath ?? 'assets/lottie/approved.json',
              width: 80.w,
              height: 80.h,
              repeat: false,
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              style: AppTextStyles.font20BlackCairoMedium.copyWith(
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.blackButton
                    : AppColors.white,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14BlackCairoMedium.copyWith(
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.secondaryText
                    : AppColors.grey,
              ),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
               // Navigator.pop(context);
                onDismiss?.call();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  S.of(context).ok,
                  style: AppTextStyles.font16BlackMediumCairo.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}