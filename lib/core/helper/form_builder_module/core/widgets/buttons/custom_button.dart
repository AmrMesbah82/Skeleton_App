import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import '../../helpers/haptic_feedback_helper.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    required this.buttonText,
    required this.onTap,
    this.buttonColor,
    this.width,
    this.textStyle,
  });
  String buttonText;
  var onTap;
  Color? buttonColor;
  TextStyle? textStyle;
  double? width;
  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedbackHelper.triggerHapticFeedback(
          vibration: VibrateType.mediumImpact,
          hapticFeedback: HapticFeedback.mediumImpact,
        );
        widget.onTap();
      },
      splashColor: Colors.transparent,
      child: Container(
        height: 38.h,
        alignment: Alignment.center,
        width: widget.width?.w,
        padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 0.sp),
        decoration: BoxDecoration(
          color: widget.buttonColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: FittedBox(
          child: Text(
            widget.buttonText,
            style: widget.textStyle ??
                AppTextStyles.font14BlackCairoMedium
                    .copyWith(color: AppColors.black),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
