import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:get/get.dart';


import 'package:demo_app/core/theme/app_font_size.dart';

/// Subscription screen stub — subscription module not included in demo_app.
class SubscribtionNew extends StatefulWidget {
  const SubscribtionNew({super.key});

  @override
  State<SubscribtionNew> createState() => _SubscribtionNewState();
}

class _SubscribtionNewState extends State<SubscribtionNew> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          'Subscription'.tr,
          style: AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: FontConstants.fontSize018.h,
            color: AppColors.colorGrey,
          ),
        ),
      ),
    );
  }
}
