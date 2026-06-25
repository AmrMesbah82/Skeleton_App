import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';


class CustomCheckBox extends StatelessWidget {
  CustomCheckBox(
      {this.size, required this.isSelected, this.borderColor, super.key});
  bool isSelected = false;
  Color? borderColor;
  double? size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 20.sp,
      height: size ?? 20.sp,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondaryPrimary : Colors.transparent,
        borderRadius: BorderRadius.circular(6.r),
        border: isSelected
            ? null
            : Border.all(color: borderColor ?? AppColors.grey, width: 1.5.sp),
      ),
      child: Center(
        child: Icon(Icons.check,
            size: (size ?? 20.sp) - 4.sp,
            color: isSelected ? AppColors.white : AppColors.grey),
      ),
    );
  }
}
