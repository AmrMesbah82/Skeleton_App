import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/theme/app_font_size.dart';import 'package:demo_app/core/helper/task_management_module/core/components/selection_user.dart';

import 'package:demo_app/core/theme/app_colors.dart';

/// Date Created :21/November/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :23/November/2023 By Bassem
/// Objectives:  this file represents the custom container for the comments section to view the sender name, time , and the message it self

class CustomCommentsContainer extends StatefulWidget {
  final String name;
  final String description;
  final Timestamp startTime;
  final String imagPath;
  const CustomCommentsContainer({
    super.key,
    required this.name,
    required this.description,
    required this.startTime,
    required this.imagPath,
  });

  @override
  State<CustomCommentsContainer> createState() =>
      _CustomCommentsContainerState();
}

class _CustomCommentsContainerState extends State<CustomCommentsContainer> {
  String formatTimestampToString(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateFormat dateFormat = DateFormat("dd MMM yyyy 'at' hh : mm a");
    String formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }

  String formatTimestampArabicToString(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateFormat dateFormat =
        DateFormat("dd MMM yyyy ${'at'.tr}  mm : hh  a", 'ar');
    String formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: isTablet ? (isPortrait ? 0.015.h : 0.01.h) : 0),
          child: Container(
            width: isTablet ? null : null,
            padding: isTablet
                ? EdgeInsets.all(isPortrait ? 0.0.h : 0.01.h)
                : EdgeInsets.symmetric(vertical: 0.01.h),
            decoration: BoxDecoration(
              color: isTablet
                  ? isPortrait
                      ? Colors.transparent
                      : (themeController.currentTheme == AppColors.lightTheme
                          ? AppColors.colorLightGrey
                          : AppColors.darkBackGround)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ClipOval(
                      child: widget.imagPath.isURL
                          ? Image.network(
                              widget.imagPath,
                              width: 0.04.h,
                              height: 0.04.h,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              widget.imagPath,
                              width: 0.04.h,
                              height: 0.04.h,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ],
                ),
                SizedBox(width: 0.015.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name.capitalize as String,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize018.h,
                        color: themeController.currentTheme ==
                                AppColors.lightTheme
                            ? AppColors.colorBlack
                            : AppColors.colorWhiteDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: isTablet ? (isPortrait ? 0.6.w : 0.18.w) : 0.6.w,
                      //   color: Colors.amber,
                      child: Text(
                        widget.description,
                        maxLines: 46,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: FontConstants.fontSize016.h,
                          color: themeController.currentTheme ==
                                  AppColors.lightTheme
                              ? AppColors.colorDarkGrey
                              : AppColors.colorGreydark,
                          fontWeight: FontWeight.w600,
                          height: isTablet
                              ? (isPortrait ? 1.6 : 0.0018.h)
                              : 0.0018.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 0.01.h),
                    Text(
                      Get.locale.toString().contains('en')
                          ? formatTimestampToString(widget.startTime)
                          : formatTimestampArabicToString(widget.startTime),
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize015.h,
                        color: themeController.currentTheme ==
                                AppColors.lightTheme
                            ? AppColors.colorBlack
                            : AppColors.colorWhiteDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 0.02.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
