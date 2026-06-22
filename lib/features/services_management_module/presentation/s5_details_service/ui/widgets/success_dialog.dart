import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';


Future<void> showDownloadSuccessDialog(BuildContext context) async {
  final lightMode = Theme.of(context).brightness == Brightness.light;

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 411.sp,
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: lightMode ? AppColors.white : AppColors.chatBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/approved.json',
                width: 70.sp,
                height: 70.sp,
                repeat: true,
              ),
              SizedBox(height: 12.sp),
              Text(
                S.of(context).downloadSuccessTitle,
                style: AppTextStyles.font20BlackCairoMedium.copyWith(
                  color: lightMode ? AppColors.blackButton : AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.sp),
              Text(
                S.of(context).downloadSuccessMessage,
                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                  color: lightMode ? AppColors.secondaryText : AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}
