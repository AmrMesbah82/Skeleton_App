import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

class CustomExperienceBulletPoints extends StatefulWidget {
  final List<String>? titles;
  final List<String>? from;
  final List<String>? to;

  const CustomExperienceBulletPoints(
      {Key? key, this.titles, this.from, this.to})
      : super(key: key);

  @override
  State<CustomExperienceBulletPoints> createState() =>
      _CustomExperienceBulletPointsState();
}

class _CustomExperienceBulletPointsState
    extends State<CustomExperienceBulletPoints> {
  @override
  Widget build(BuildContext context) {
    final bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return isTablet
        ? (isVertical ? _buildVerticalList() : _buildHorizontalList())
        : _buildMobileList();
  }

  Widget _buildMobileList() {
    return ListView.builder(
padding: EdgeInsets.zero,
      itemCount: widget.titles!.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0.02.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '\u25CF',
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize015.h,
                      color:
                          themeController.currentTheme == MyThemeData.lightTheme
                              ? MyThemeData.colorDarkGrey
                              : MyThemeData.colorGreydark,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 0.01.w),
                  Expanded(
                    child: Text(
                      widget.titles![index].capitalize ?? '',
                      style: TextStyle(
                        fontSize: FontConstants.fontSize015.h,
                        color: themeController.currentTheme ==
                                MyThemeData.lightTheme
                            ? MyThemeData.colorBlack
                            : MyThemeData.colorWhiteDark,
                        fontWeight: FontWeight.w400,
                        height: 1.8,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'From: '.tr,
                          style: TextStyle(
                            fontSize: FontConstants.fontSize015.h,
                            color: themeController.currentTheme ==
                                    MyThemeData.lightTheme
                                ? MyThemeData.colorBlack
                                : MyThemeData.colorWhiteDark,
                            fontWeight: FontWeight.w400,
                            height: 1.8,
                          ),
                        ),
                        Text(
                           Get.locale.toString().contains('en')
                        ? widget.from![index].tr.capitalize!
                        : translateMonthYearToArabic(
                            widget.from![index].tr.capitalize!),
                          style: TextStyle(
                            fontSize: FontConstants.fontSize015.h,
                            color: themeController.currentTheme ==
                                    MyThemeData.lightTheme
                                ? MyThemeData.colorBlack
                                : MyThemeData.colorWhiteDark,
                            fontWeight: FontWeight.w400,
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'To: '.tr,
                          style: TextStyle(
                            fontSize: FontConstants.fontSize015.h,
                            color: themeController.currentTheme ==
                                    MyThemeData.lightTheme
                                ? MyThemeData.colorBlack
                                : MyThemeData.colorWhiteDark,
                            fontWeight: FontWeight.w400,
                            height: 1.8,
                          ),
                        ),
                        Text(
                          Get.locale.toString().contains('en')
                        ? widget.to![index].tr.capitalize!
                        : translateMonthYearToArabic(
                            widget.to![index].tr.capitalize!),
                          style: TextStyle(
                            fontSize: FontConstants.fontSize015.h,
                            color: themeController.currentTheme ==
                                    MyThemeData.lightTheme
                                ? MyThemeData.colorBlack
                                : MyThemeData.colorWhiteDark,
                            fontWeight: FontWeight.w400,
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVerticalList() {
    return ListView.builder(
padding: EdgeInsets.zero,
      itemCount: widget.titles!.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0.02.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\u25CF',
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: FontConstants.fontSize015.h,
                  color: themeController.currentTheme == MyThemeData.lightTheme
                      ? MyThemeData.colorDarkGrey
                      : MyThemeData.colorGreydark,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 0.01.w),
              Container(
                // color: Colors.amber,
                width: 0.45.w,
                child: Text(
                  widget.titles![index].capitalize ?? '',
                  style: TextStyle(
                    fontSize: FontConstants.fontSize015.h,
                    color:
                        themeController.currentTheme == MyThemeData.lightTheme
                            ? MyThemeData.colorBlack
                            : MyThemeData.colorWhiteDark,
                    fontWeight: FontWeight.w400,
                    height: 1.8,
                  ),
                ),
              ),
              SizedBox(width: 0.02.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'From: '.tr,
                        style: TextStyle(
                          fontSize: FontConstants.fontSize015.h,
                          color: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhiteDark,
                          fontWeight: FontWeight.w400,
                          height: 1.8,
                        ),
                      ),
                      Text(
                         Get.locale.toString().contains('en')
                        ? widget.from![index].tr.capitalize!
                        : translateMonthYearToArabic(
                            widget.from![index].tr.capitalize!),
                        style: TextStyle(
                          fontSize: FontConstants.fontSize015.h,
                          color: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhiteDark,
                          fontWeight: FontWeight.w400,
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'To: '.tr,
                        style: TextStyle(
                          fontSize: FontConstants.fontSize015.h,
                          color: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhiteDark,
                          fontWeight: FontWeight.w400,
                          height: 1.8,
                        ),
                      ),
                      Text(
                         Get.locale.toString().contains('en')
                        ? widget.to![index].tr.capitalize!
                        : translateMonthYearToArabic(
                            widget.to![index].tr.capitalize!),
                        style: TextStyle(
                          fontSize: FontConstants.fontSize015.h,
                          color: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhiteDark,
                          fontWeight: FontWeight.w400,
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHorizontalList() {
    return ListView.builder(
padding: EdgeInsets.zero,
      itemCount: widget.titles!.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0.01.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\u25CF',
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: FontConstants.fontSize020.h,
                  color: themeController.currentTheme == MyThemeData.lightTheme
                      ? MyThemeData.colorDarkGrey
                      : MyThemeData.colorGreydark,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 0.01.w),
              Container(
                //  color: Colors.amber,
                width: 0.48.w,
                child: Text(
                  widget.titles![index].capitalize ?? '',
                  style: TextStyle(
                    fontSize: FontConstants.fontSize020.h,
                    color:
                        themeController.currentTheme == MyThemeData.lightTheme
                            ? MyThemeData.colorBlack
                            : MyThemeData.colorWhiteDark,
                    fontWeight: FontWeight.w400,
                    height: 1.8,
                  ),
                ),
              ),
              SizedBox(width: 0.02.w),
              Row(
                children: [
                  Text(
                    'From: '.tr,
                    style: TextStyle(
                      fontSize: FontConstants.fontSize020.h,
                      color:
                          themeController.currentTheme == MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhiteDark,
                      fontWeight: FontWeight.w400,
                      height: 1.8,
                    ),
                  ),
                  Text(
                     Get.locale.toString().contains('en')
                        ? widget.from![index].tr.capitalize!
                        : translateMonthYearToArabic(
                            widget.from![index].tr.capitalize!),
                    style: TextStyle(
                      fontSize: FontConstants.fontSize020.h,
                      color:
                          themeController.currentTheme == MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhiteDark,
                      fontWeight: FontWeight.w400,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 0.02.w),
              Row(
                children: [
                  Text(
                    'To: '.tr,
                    style: TextStyle(
                      fontSize: FontConstants.fontSize020.h,
                      color:
                          themeController.currentTheme == MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhiteDark,
                      fontWeight: FontWeight.w400,
                      height: 1.8,
                    ),
                  ),
                  Text(
                    Get.locale.toString().contains('en')
                        ? widget.to![index].tr.capitalize!
                        : translateMonthYearToArabic(
                            widget.to![index].tr.capitalize!),
                    style: TextStyle(
                      fontSize: FontConstants.fontSize020.h,
                      color:
                          themeController.currentTheme == MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhiteDark,
                      fontWeight: FontWeight.w400,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
