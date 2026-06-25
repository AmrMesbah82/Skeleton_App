import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/helper/task_management_module/core/components/selection_user.dart';
import 'package:lottie/lottie.dart';

import 'package:demo_app/core/theme/app_colors.dart';

class EmptyWidget extends StatefulWidget {
  final String assetPath;
  final double scale;
  const EmptyWidget({super.key, required this.assetPath, required this.scale});

  @override
  State<EmptyWidget> createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: EdgeInsets.only(top: 0.02.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          color: themeController.currentTheme == AppColors.lightTheme
              ? AppColors.colorWhite
              : Theme.of(context).colorScheme.inversePrimary,
          height: !isVertical ? 0.3.h : 0.2.h,
          width: double.infinity,
          child: Transform.scale(
            scale: widget.scale,
            child: Lottie.asset(
              widget.assetPath,
            ),
          ),
        ),
      ),
    );
  }
}
