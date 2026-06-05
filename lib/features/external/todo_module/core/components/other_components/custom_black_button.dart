import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_theme.dart';

class CustomBlackButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool isYellow;

  const CustomBlackButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isYellow = false,
  });

  @override
  State<CustomBlackButton> createState() => _CustomBlackButtonState();
}

class _CustomBlackButtonState extends State<CustomBlackButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          shadowColor: WidgetStatePropertyAll(Colors.transparent),
          backgroundColor: WidgetStatePropertyAll(
              widget.isYellow == true ? AppColors.primary : AppColors.text),
          foregroundColor: WidgetStatePropertyAll(AppColors.white),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/icons/plusIcon.svg",
              height: 12,
              color: widget.isYellow == true
                  ? AppTheme.contrastColor()
                  : AppColors.white,
            ),
            SizedBox(width: 8),
            Baseline(
              baseline: 13,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                "Item",
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: 13,
                    height: 1,
                    color: widget.isYellow == true
                        ? AppColors.black
                        : AppColors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
