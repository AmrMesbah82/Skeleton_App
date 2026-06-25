import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;


  const SectionTitle({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.tr, // Supports translations
          style: AppTextStyles.font16BlackMediumCairo,
        ),
      ],
    );
  }
}
