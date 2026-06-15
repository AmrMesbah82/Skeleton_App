import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:lottie/lottie.dart';

// Date: 16/10/2024
// By: Youssef Ashraf, Nada Mohammed, Mohammed Ashraf
// Last update: 16/10/2024
// Objectives: This file is responsible for providing the default no data gif.
class NoDataGif extends StatelessWidget {
  final double? height;
  final double? width;
  const NoDataGif({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LottieBuilder.asset(
          height: height ?? Get.height * 0.35,
          width: width,
          "assets/images/noData.json",
          frameRate: const FrameRate(120),
        ),
        Center(
          child: Text(
            'No Data Found'.tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isPortrait
                  ? FontConstants.fontSize022.h
                  : FontConstants.fontSize028.h,
              fontWeight: FontWeight.w600,
              color: MyThemeData.colorGrey,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
