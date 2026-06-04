import 'package:flutter/material.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_text_styles.dart';

/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       This widget is used to display a chip that contains info for todo items.
///                    Such as frequency, scheduled date and time, and deleted status.
///                    This refers to the yellow chips at the top of the todo item.
/// Author:            Ahmed Mahmoud,
/// Date:              March/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------

class TodoItemChipContainer extends StatelessWidget {
  const TodoItemChipContainer({
    super.key,
    required this.title,
    this.color,
    this.textColor,
    this.icon,
    this.xLarge,
  });
  final Color? color;
  final String title;
  final Color? textColor;
  final Widget? icon;
  final bool? xLarge;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: (icon != null || xLarge == true) ? 30 : 20,
          padding: EdgeInsets.symmetric(horizontal: 6.5),
          decoration: BoxDecoration(
            color: color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon ?? SizedBox(),
              icon != null ? SizedBox(width: 5) : const SizedBox(),
              Baseline(
                baseline: 10,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  title,
                  style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    fontSize: 10,
                    color: textColor ?? Colors.black,
                    height: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
