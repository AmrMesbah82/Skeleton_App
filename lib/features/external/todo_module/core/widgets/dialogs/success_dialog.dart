import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:lottie/lottie.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
    required this.subtitle,
    required this.title,
    this.lottieAsset,
  });

  final String subtitle;
  final String title;
  final String? lottieAsset;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? 100 : 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Lottie.asset(
              lottieAsset ?? "assets/images/correct.json",
              width: 80.h,
              height: 80.h,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 30),
            Text(
              title.tr,
              style: TextStyle(
                fontSize: 20.h,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Text(
              subtitle.tr,
              style: TextStyle(
                  fontSize: 14.h,
                  color: AppColors.inverseBase,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
