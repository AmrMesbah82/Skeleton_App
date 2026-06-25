import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';


class CustomPopupDialogWithLottie extends StatelessWidget {
  final String lottiePath;
  final String title;
  final String message;
  final List<Widget> actions;

  const CustomPopupDialogWithLottie({
    Key? key,
    required this.lottiePath,
    required this.title,
    required this.message,
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    var lightMode= Theme.of(context).brightness == Brightness.light;
    return AlertDialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      contentPadding: EdgeInsets.all(
        isMobile? 7.w:21.w,
      ),
      content: SizedBox(
        width: 411.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              lottiePath,
              height: 100.h,
              width: 100.w,
              repeat: true,
            ),
            SizedBox(height: 30.h),
            Text(
              title,
              style: AppTextStyles.font20BlackCairoMedium.copyWith(
                color: AppColors.text
              )
            ),
            SizedBox(height: 18.h),
            Text(
              message,
              textAlign: TextAlign.center,
                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color: lightMode ? AppColors.secondaryText : AppColors.grey
                )
            ),
            SizedBox(height: 15.h),
            if (actions.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: actions,
              ),
          ],
        ),
      ),
    );
  }
}
