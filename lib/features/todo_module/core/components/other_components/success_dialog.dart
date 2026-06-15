import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
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
              const SizedBox(height: 10),
              Lottie.asset(
                lottieAsset ?? "assets/images/correct.json",
                width: 90,
                height: 90,
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(height: 30),
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
