import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class ColumnDataMobile extends StatelessWidget {
  const ColumnDataMobile(
      {super.key, required this.title, required this.subtitle1});
  final String title;
  final String subtitle1;

  @override
  Widget build(BuildContext context) {
    return Column(
     
      children: [
        Text(
          subtitle1,
          style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: FontConstants.fontSize018.h,
              fontWeight: FontWeight.w600,
               letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
              color: Theme.of(context).colorScheme.inverseSurface),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.015.h),
              child: Text(
                title.tr,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: FontConstants.fontSize018.h,
                    fontWeight: FontWeight.w600,
                     letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                    color: MyThemeData.signOut),
              ),
            ),
           
          ],
        ),
      ],
    );
  }
}
