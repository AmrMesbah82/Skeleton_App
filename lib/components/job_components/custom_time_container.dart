import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CustomTimeContainer extends StatelessWidget {
  final String text;
  final bool isActive;
  const CustomTimeContainer({
    Key? key,
    required this.text,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: EdgeInsets.only(top: isPortrait ? 0.015.h : 0.02.h),
      child: Container(
        width: 0.2.w,
        decoration: BoxDecoration(
          color:
              isActive == true ? MyThemeData.lightPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: MyThemeData.lightPrimary),
        ),
        padding: EdgeInsets.all(0.01.h),
        alignment: Alignment.center,
        child: Text(
          Get.locale.toString().contains('en')
              ? text
              : convertTimeToArabic(text),
          style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isPortrait
                  ? FontConstants.fontSize015.h
                  : FontConstants.fontSize028.h,
              fontWeight: FontWeight.w700,
               letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
              color: isActive == true
                  ? MyThemeData.colorWhite
                  : Theme.of(context).colorScheme.inverseSurface,
              height: 1.8),
        ),
      ),
    );
  }
}
