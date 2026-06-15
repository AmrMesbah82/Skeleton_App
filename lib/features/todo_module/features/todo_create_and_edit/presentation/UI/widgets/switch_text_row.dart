import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/theme/app_theme.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/flutter_switch.dart';

/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       A reusable row widget with a text label and a toggle switch, used for enabling or disabling settings like scheduling or frequency in forms.
///                    This widget is used in the CreateTodoMobile and CreateTodoTablet screens.
/// Author:            Ahmed Mahmoud,
/// Date:              10/March/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------

class SwitchTextRow extends StatelessWidget {
  const SwitchTextRow({
    super.key,
    required this.title,
    required this.value,
    required this.onToggle,
  });
  final String title;
  final bool value;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    // bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    bool isDark = AppTheme.isDark;

    return Row(
      children: [
        Text(
          title.tr,
          style: AppTextStyles.font10BlackCairoRegular.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.moreLightGrey : AppColors.text,
          ),
        ),

        // Small gap between text and switch

        Spacer(),
        // Switch
        FlutterSwitch(
          width: 38,
          height: 22,
          value: value,
          padding: 3,
          activeColor: AppColors.secondaryPrimary,
          inactiveColor: Color(0xFFe9e9eb),
          onToggle: onToggle,
        ),
      ],
    );
  }
}
