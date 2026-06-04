import 'package:demo_app/features/external/main_core/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_text_styles.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/core/new_theme.dart';

import '../../features/external/main_core/core/theme/app_colors.dart';

class CustomTitleValueWidget extends StatelessWidget {
  CustomTitleValueWidget(
      {required this.title,
      required this.value,
      this.titleStyle,
      this.valueStyle,
      super.key});
  String title;
  String value;
  TextStyle? titleStyle;
  TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Row(
      children: [
        Text(
          title,
          style: StyleText.fontSize14Weight500.copyWith(
              color: AppColors.secondaryText,
          ),
        ),
        Text(
     value,
          style: StyleText.fontSize14Weight500.copyWith(
              color: AppColors.text,
          ),
        )
      ],
    );
  }
}
