import 'package:demo_app/features/external/data_grc_module/feature/nav_bar.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';

/// Date Created :  27/May/2024
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit : 27/May/2024 By Bassem Mohamed
/// Objectives:  this file represents the  custom container for showing the project details inside the home screen

class CustomTaskContainerHome extends StatefulWidget {
  final String taskTitle;
  final String? time;
  final String? description;
  final String? firstImage;
  final String? secondImage;

  final String? totalImagesNum;

  const CustomTaskContainerHome({
    Key? key,
    required this.taskTitle,
    this.time,
    this.description,
    this.firstImage,
    this.secondImage,
    this.totalImagesNum,
  }) : super(key: key);

  @override
  State<CustomTaskContainerHome> createState() =>
      _CustomTaskContainerHomeState();
}

class _CustomTaskContainerHomeState extends State<CustomTaskContainerHome> {
  @override
  Widget build(BuildContext context) {
    
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Stack(
      children: [
        Container(
          width: 0.45.w,
          decoration: BoxDecoration(
            color: orientation
                ? themeController.currentTheme == MyThemeData.lightTheme
                    ? MyThemeData.colorWhite
                    : Theme.of(context).colorScheme.inversePrimary
                : themeController.currentTheme == MyThemeData.lightTheme
                    ? MyThemeData.colorLightGrey
                    : MyThemeData.darkBackGround,
            borderRadius: BorderRadius.circular(8),
          ),
          // width: 0.42.h,
          padding: EdgeInsets.symmetric(
              horizontal: orientation ? 0.03.w : 0.015.w,
              vertical: isTablet ? 0.01.h : 0.01.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.taskTitle,
                maxLines: 1,
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
                maxLines: orientation ? 2 : 4,
                overflow: TextOverflow.ellipsis,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isTablet
                      ? (orientation
                          ? FontConstants.fontSize014.h
                          : FontConstants.fontSize018.h)
                      : FontConstants.fontSize016.h,
                  color: themeController.currentTheme == MyThemeData.lightTheme
                      ? MyThemeData.colorDarkGrey
                      : MyThemeData.colorGreydark,
                  fontWeight: FontWeight.w400,
                  height: (orientation && isTablet ? 1.8 : 0.002.h),
                ),
              ),
              SizedBox(
                  height: isTablet ? (orientation ? 0.02.h : 0.01.h) : 0.015.h),
              // Row(
              //   children: [
              //     SvgPicture.asset(
              //       'assets/icons/timeIconHome.svg',
              //       color:
              //           themeController.currentTheme == MyThemeData.lightTheme
              //               ? MyThemeData.colorBlack
              //               : MyThemeData.colorWhiteDark,
              //       height:
              //           isTablet ? (orientation ? 0.03.h : 0.015.w) : 0.055.w,
              //       matchTextDirection: Get.locale?.languageCode == 'ar',
              //     ),
              //     SizedBox(
              //       width: 0.01.w,
              //     ),
              //     Container(
              //       width: isTablet ? (orientation ? 0.27.w : 0.17.w) : 0.28.w,
              //     //  color: Colors.amber,
              //       child: Text(
              //         widget.time!,
              //         overflow: TextOverflow.ellipsis,
              //         style: AppFontStyle.cairoRegularStyle.copyWith(
              //             fontSize: isTablet
              //                 ? (orientation
              //                     ? FontConstants.fontSize012.h
              //                     : FontConstants.fontSize016.h)
              //                 : FontConstants.fontSize014.h,
              //             color: themeController.currentTheme ==
              //                     MyThemeData.lightTheme
              //                 ? MyThemeData.colorBlack
              //                 : MyThemeData.colorWhiteDark,
              //             fontWeight: FontWeight.w600,
              //             height: isTablet ? (orientation ? 1.6 : 1.8) : 1.5
              //             // height: 0.002.h,
              //             ),
              //       ),
              //     ),
              //   ],
              // ),

              // SizedBox(
              //   height: 0.02.h,
              // ),
              Container(
                //  width: isTablet ? (orientation ? 0.15.w : 0.15.w) : 0.28.w,
          //    color: Colors.amber,
                child: Text(
                  "saas",
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isTablet
                          ? (orientation
                              ? FontConstants.fontSize012.h
                              : FontConstants.fontSize016.h)
                          : FontConstants.fontSize014.h,
                      color: Colors.transparent,
                      fontWeight: FontWeight.w600,
                      height: isTablet ? (orientation ? 1.6 : 1.8) : 1.5
                      // height: 0.002.h,
                      ),
                ),
              ),
            ],
          ),
        ),
        if (widget.totalImagesNum != null)
          Positioned(
            bottom: 0.015.h,
            right: Get.locale.toString().contains('en') ? 0.02.h : null,
            left: Get.locale.toString().contains('ar') ? 0.02.h : null,
            child: Container(
              width: 0.03.h,
              height: 0.03.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyThemeData.lightPrimary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.001.h),
                    child: Text(
                      "+${Get.locale.toString().contains('en') ? widget.totalImagesNum : convertNumberToArabic(widget.totalImagesNum!)}",
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize010.h,
                        height: 2,
                        color: MyThemeData().contrastColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (widget.firstImage != null)
          Positioned(
            bottom: 0.015.h,
            right: Get.locale.toString().contains('en') ? 0.047.h : null,
            left: Get.locale.toString().contains('ar') ? 0.047.h : null,
            child: Container(
              width: 0.03.h,
              height: 0.03.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 0.03.h,
                  backgroundImage: AssetImage(widget.firstImage!),
                ),
              ),
            ),
          ),
        if (widget.secondImage != null)
          Positioned(
            bottom: 0.015.h,
            right: Get.locale.toString().contains('en') ? 0.067.h : null,
            left: Get.locale.toString().contains('ar') ? 0.067.h : null,
            child: Container(
              width: 0.03.h,
              height: 0.03.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 0.03.h,
                  backgroundImage: AssetImage(widget.secondImage!),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
