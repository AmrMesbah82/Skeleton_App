import 'package:demo_app/core/theme/grc_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';

/// Date Created :  27/May/2024
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit : 27/May/2024 By Bassem Mohamed
/// Objectives:  this file represents the  custom container for showing the todo details inside the home screen

class CustomToDoContainerHome extends StatefulWidget {
  final String todoTitle;
  final String? time;
  final String? date;
  final String? description;

  final String? totalImagesNum;

  const CustomToDoContainerHome({
    Key? key,
    required this.todoTitle,
    this.time,
    this.date,
    this.description,
    this.totalImagesNum,
  }) : super(key: key);

  @override
  State<CustomToDoContainerHome> createState() =>
      _CustomToDoContainerHomeState();
}

class _CustomToDoContainerHomeState extends State<CustomToDoContainerHome> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      decoration: BoxDecoration(
        color: themeController.currentTheme == MyThemeData.lightTheme
            ? MyThemeData.colorWhite
            : Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      // width: 0.42.h,
      padding: EdgeInsets.symmetric(
          horizontal: 0.03.w, vertical: isTablet ? 0.01.h : 0.01.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isTablet? 0.52.w: 0.565.w,
          //  color: Colors.amber,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.todoTitle,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isTablet
                          ? (orientation
                              ? FontConstants.fontSize016.h
                              : FontConstants.fontSize022.h)
                          : FontConstants.fontSize020.h,
                      color:
                          themeController.currentTheme == MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhiteDark,
                      fontWeight: FontWeight.w600,
                      height: isTablet ? (orientation ? 1.6 : 1.8) : 1.5
                      // height: 0.002.h,
                      ),
                ),
                SizedBox(height: isTablet ? 0.01.h : 0.01.h),
                Text(
                  widget.description!,
                  maxLines: isTablet? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: isTablet
                        ? (orientation
                            ? FontConstants.fontSize014.h
                            : FontConstants.fontSize018.h)
                        : FontConstants.fontSize016.h,
                    color:
                        themeController.currentTheme == MyThemeData.lightTheme
                            ? MyThemeData.colorDarkGrey
                            : MyThemeData.colorGreydark,
                    fontWeight: FontWeight.w400,
                    height: (orientation && isTablet ? 1.8 : 0.002.h),
                  ),
                ),
                // SizedBox(
                //     height:
                //         isTablet ? (orientation ? 0.02.h : 0.01.h) : 0.015.h),
              ],
            ),
          ),
          SizedBox(width: 0.02.w,),
          Spacer(),
          Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/dateIconHome.svg',
                    color:
                        themeController.currentTheme == MyThemeData.lightTheme
                            ? MyThemeData.colorBlack
                            : MyThemeData.colorWhiteDark,
                    height:
                        isTablet ? (orientation ? 0.035.w : 0.04.h) : 0.055.w,
                    matchTextDirection: Get.locale?.languageCode == 'ar',
                  ),
                  SizedBox(
                    width: 0.01.w,
                  ),
                  Container(
                    width: isTablet ? (orientation ? 0.15.w : 0.15.w) : 0.2.w,
                    //   color: Colors.amber,
                    child: Text(
                      widget.date!,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: isTablet
                              ? (orientation
                                  ? FontConstants.fontSize012.h
                                  : FontConstants.fontSize016.h)
                              : FontConstants.fontSize014.h,
                          color: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorDarkGrey
                              : MyThemeData.colorGreydark,
                          fontWeight: FontWeight.w600,
                          height: isTablet ? (orientation ? 1.6 : 1.8) : 1.5
                          // height: 0.002.h,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height:isTablet? 0.06.h : 0.04.h,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/timeIconHome.svg',
                    color:
                        themeController.currentTheme == MyThemeData.lightTheme
                            ? MyThemeData.colorBlack
                            : MyThemeData.colorWhiteDark,
                    height:
                        isTablet ? (orientation ? 0.035.w : 0.04.h) : 0.055.w,
                    matchTextDirection: Get.locale?.languageCode == 'ar',
                  ),
                  SizedBox(
                    width: 0.01.w,
                  ),
                  Container(
                    width: isTablet ? (orientation ? 0.15.w : 0.15.w) : 0.2.w,
                   //     color: Colors.amber,
                    child: Text(
                      widget.time!,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: isTablet
                              ? (orientation
                                  ? FontConstants.fontSize012.h
                                  : FontConstants.fontSize016.h)
                              : FontConstants.fontSize014.h,
                          color: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorDarkGrey
                              : MyThemeData.colorGreydark,
                          fontWeight: FontWeight.w600,
                          height: isTablet ? (orientation ? 1.6 : 1.8) : 1.5
                          // height: 0.002.h,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
