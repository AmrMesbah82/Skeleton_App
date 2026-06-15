import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';

import '../../features/onboarding/presentation/ui/pages/onboarding.dart';

/// Date Created :23/November/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :23/November/2023 By Bassem
/// Objectives:  this file represents the custom container for showing three differen types of attachments whether its image, docx, or pdf

class AttachmentPdfContainer extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final void Function() onTapDelete;
  final void Function() onTapDownload;

  AttachmentPdfContainer({
    required this.fileName,
    required this.fileSize,
    required this.onTapDelete,
    required this.onTapDownload,
  });

  Widget _getFileIcon(isTablet, isPortrait) {
    String fileExtension = fileName.split('.').last.toLowerCase();
    if (fileName.contains('.pdf')) {
      return Icon(Icons.picture_as_pdf,
          size: isTablet ? (isPortrait == true ? 0.04.h : 0.05.h) : 0.03.h,
          color: Colors.red);
    } else if (fileName.contains('.docx')) {
      return Icon(Icons.description,
          size: isTablet ? (isPortrait == true ? 0.04.h : 0.05.h) : 0.03.h,
          color: Colors.blue);
    } else {
      return Icon(Icons.image,
          size: isTablet ? (isPortrait == true ? 0.04.h : 0.05.h) : 0.03.h,
          color: Colors.green);
    }
    /*if (fileExtension == 'pdf') {
        return Icon(Icons.picture_as_pdf,
            size: isTablet ? 0.05.h : 0.03.h, color: Colors.red);
      } else if (fileExtension == 'docx') {
        return Icon(Icons.description,
            size: isTablet ? 0.05.h : 0.03.h, color: Colors.blue);
      } else {
        return Icon(Icons.image,
            size: isTablet ? 0.05.h : 0.03.h, color: Colors.green);
      }*/
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 0 : 0.015.h),
      child: Container(
        width: isTablet ? (isPortrait ? 0.39.w : 0.2.w) : null,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: mainCoreThemeController.currentTheme == MyThemeData.lightTheme
                  ? MyThemeData.colorBlack
                  : Colors.transparent,
              width: 1.0,
            )),
        padding: isTablet
            ? (isPortrait
                ? EdgeInsets.only(
                    right: 0.01.w, left: 0.01.w, top: 0.01.h, bottom: 0.005.h)
                : EdgeInsets.symmetric(horizontal: 0.015.h, vertical: 0.01.h))
            : EdgeInsets.symmetric(horizontal: 0.015.w, vertical: 0.006.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getFileIcon(isTablet, isPortrait),
            SizedBox(
              width: isTablet ? (isPortrait ? 0.02.w : 0.02.h) : 0.02.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      // color: Colors.amber,
                      width: isTablet ? (isPortrait ? 0.25.w : 0.1.w) : 0.23.w,
                      child: Text(
                        fileName,
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: isTablet
                                ? (isPortrait
                                    ? FontConstants.fontSize015.h
                                    : FontConstants.fontSize018.h)
                                : FontConstants.fontSize016.h,
                            color: mainCoreThemeController.currentTheme ==
                                    MyThemeData.lightTheme
                                ? MyThemeData.colorBlack
                                : MyThemeData.colorWhiteDark,
                            fontWeight: FontWeight.w600,
                            height: isTablet ? 1.6 : 1.3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: isTablet ? (isPortrait ? 0 : 0.0.h) : 0.005.h),
                  child: Row(
                    children: [
                      Container(
                        // color: Colors.amber,
                        width:
                            isTablet ? (isPortrait ? 0.25.w : 0.1.w) : 0.23.w,
                        child: Text(
                          "$fileSize MB",
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: isTablet
                                  ? (isPortrait
                                      ? FontConstants.fontSize014.h
                                      : FontConstants.fontSize016.h)
                                  : FontConstants.fontSize014.h,
                              color: mainCoreThemeController.currentTheme ==
                                      MyThemeData.lightTheme
                                  ? MyThemeData.colorDarkGrey
                                  : MyThemeData.colorGreydark,
                              fontWeight: FontWeight.w400,
                              height: isPortrait ? 2 : 2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      /* SizedBox(
                        width: 0.02.h,
                      ),
                      SvgPicture.asset(
                        'assets/icons/Eye.svg',
                        width: 0.02.h,
                        height: 0.02.h,
                        color: themeController.currentTheme ==
                                MyThemeData.lightTheme
                            ? MyThemeData.colorBlack
                            : MyThemeData.colorWhiteDark,
                      )*/
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
