import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/new_theme.dart';

class WarningLottieDialog extends StatelessWidget {
  final String message;
  final String lottieAsset;
  final double? width;

  const WarningLottieDialog({
    Key? key,
    required this.message,
    this.lottieAsset = 'assets/lottie/warning.json',
    this.width = 411,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: WillPopScope(
        onWillPop: () async => true,
        child: Dialog(
          backgroundColor: AppColors.background,
          child: GestureDetector(
            onTap: () {
              // Prevent closing when tapping on the dialog content
            },
            child: Container(
              width: 411.w,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Lottie Animation
                  SizedBox(
                    child: Lottie.asset(
                      lottieAsset,
                      width: 150.w,
                      height: 150.h,
                      repeat: true,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  // Message
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Text(
                      textAlign: TextAlign.center,
                      message,
                      style: StyleText.fontSize16Weight500.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.sp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper function to show the dialog
void showWarningDialog(
    BuildContext context, {
      required String message,
      String lottieAsset = 'assets/lottie/warning.json',
      double width = 411,
    }) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return WarningLottieDialog(
        message: message,
        lottieAsset: lottieAsset,
        width: width,
      );
    },
  );
}