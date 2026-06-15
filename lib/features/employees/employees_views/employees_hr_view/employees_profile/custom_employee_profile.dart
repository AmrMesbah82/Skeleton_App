import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';

class CustomProfileWidget extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String profession;
  final String mobileNumber;
  final double reviewRating;

  CustomProfileWidget({
    required this.firstName,
    required this.lastName,
    required this.profession,
    required this.mobileNumber,
    required this.reviewRating,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$reviewRating',
                 style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: FontConstants.fontSize018.h,
                  color: themeController.currentTheme == MyThemeData.lightTheme
                      ? MyThemeData.colorBlack
                      : MyThemeData.colorWhiteDark,
                  fontWeight: FontWeight.w600,
                  height: 0.0021.h,
                  letterSpacing: 1.5),
                ),
                SizedBox(width:0.01.h),
                SvgPicture.asset('assets/icons/StarOrange.svg'),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 0.005.h, color: MyThemeData.lightPrimary), // Yellow border
              ),
              padding: EdgeInsets.all(0.007.h),
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: AssetImage('assets/images/profile1.png'),
              ),
            ),
            SizedBox(height: 0.04.h),
            Text(
              '$firstName $lastName'.capitalize as String,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: FontConstants.fontSize028.h,
                  color: themeController.currentTheme == MyThemeData.lightTheme
                      ? MyThemeData.colorBlack
                      : MyThemeData.colorWhiteDark,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5),
            ),
            SizedBox(height: 0.01.h),
            Text(
              profession.capitalize as String,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: FontConstants.fontSize022.h,
                color: themeController.currentTheme == MyThemeData.lightTheme
                    ? MyThemeData.colorDarkGrey
                    : MyThemeData.colorGreydark,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.5,
              ),
            ),
           SizedBox(height: 0.01.h),
            Text(
              mobileNumber,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: FontConstants.fontSize022.h,
                color: themeController.currentTheme == MyThemeData.lightTheme
                    ? MyThemeData.colorDarkGrey
                    : MyThemeData.colorGreydark,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
