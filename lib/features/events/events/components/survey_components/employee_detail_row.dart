// Date Created :21/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :21/November/2023
// Objectives: this is a widget to customize the title and the value in the employee content container
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class EmployeeContent extends StatelessWidget {
  const EmployeeContent(
      {super.key,
      required this.title,
      required this.value,
      this.isAssets = false,
      this.hasIcon = false,
      this.iconUrl,
      this.isReport = false,
      this.isFooter = false,
      this.textColor,
      this.isTest = false,
      this.isPastDue = false,
      this.isEmployeeProfile = false});
  final String title;
  final String value;
  final bool isAssets;
  final bool isEmployeeProfile;
  final bool hasIcon;
  final String? iconUrl;
  final bool isReport;
  final bool isFooter;
  final Color? textColor;
  final bool isTest;
  final bool isPastDue;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SizedBox(
      // height: 0.1.h,
      child: Row(
        children: <Widget>[
          hasIcon
              ? Padding(
                  padding: EdgeInsets.only(
                      left: isFooter
                          ? Get.locale.toString().contains('en')
                              ? 0
                              : 0.008.w
                          : 0.008.w,
                      right: 0.008.w,
                      bottom: isTablet
                          ? isPortrait
                              ? 0.007.h
                              : 0.01.h
                          : 0.01.h),
                  child: Transform.scale(
                      scale: iconUrl == "assets/images/file_status.svg"
                          ? 1.3
                          : isFooter
                              ? 1.3
                              : 1.1,
                      child: SvgPicture.asset(
                        iconUrl!,
                        color:
                            isFooter ? MyThemeData.colorWhite : MyThemeData.lightPrimary,
                        height: isTablet
                            ? isPortrait
                                ? 0.025.h
                                : null
                            : null,
                      )),
                )
              : const SizedBox.shrink(),
          Text(
            "${title.tr}: ",
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isFooter
                  ? FontConstants.fontSize014.w
                  : isAssets == true
                      ? isTablet
                          ? isPortrait
                              ? FontConstants.fontSize016.h
                              : FontConstants.fontSize014.w
                          : FontConstants.fontSize017.h
                      : isTablet
                          ? isPortrait
                              ? FontConstants.fontSize012.h
                              : FontConstants.fontSize011.w
                          : FontConstants.fontSize012.h,
              fontWeight: FontWeight.w500,
              color: isFooter
                  ? MyThemeData.colorWhite
                  : isReport
                      ? MyThemeData.dark
                      : MyThemeData.GreyBack,
            ),
          ),
          if (isEmployeeProfile == false)
            isPastDue
                ? Flexible(
                    child: Text(
                    value.tr,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isFooter
                          ? FontConstants.fontSize014.w
                          : isAssets == true
                              ? isTablet
                                  ? isPortrait
                                      ? FontConstants.fontSize017.h
                                      : FontConstants.fontSize014.w
                                  : FontConstants.fontSize017.h
                              : isTablet
                                  ? isPortrait
                                      ? FontConstants.fontSize012.h
                                      : FontConstants.fontSize011.w
                                  : FontConstants.fontSize012.h,
                      fontWeight: isAssets ? FontWeight.w600 : FontWeight.w500,
                      color: isFooter
                          ? MyThemeData.colorWhite
                          : isReport
                              ? MyThemeData.colorBlack
                              : textColor ??
                                  Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ))
                : Text(
                    value.tr,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isFooter
                          ? FontConstants.fontSize014.w
                          : isAssets == true
                              ? isTablet
                                  ? isPortrait
                                      ? FontConstants.fontSize017.h
                                      : FontConstants.fontSize014.w
                                  : FontConstants.fontSize017.h
                              : isTablet
                                  ? isPortrait
                                      ? FontConstants.fontSize012.h
                                      : FontConstants.fontSize011.w
                                  : FontConstants.fontSize012.h,
                      fontWeight: isAssets ? FontWeight.w600 : FontWeight.w500,
                      color: isFooter
                          ? MyThemeData.colorWhite
                          : isReport
                              ? MyThemeData.colorBlack
                              : textColor ??
                                  Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
          if (isEmployeeProfile == true)
            Flexible(
              child: Text(
                value.tr,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isAssets == true
                      ? isTablet
                          ? isPortrait
                              ? FontConstants.fontSize017.h
                              : FontConstants.fontSize014.w
                          : FontConstants.fontSize017.h
                      : isTablet
                          ? isPortrait
                              ? FontConstants.fontSize013.h
                              : FontConstants.fontSize013.w
                          : FontConstants.fontSize013.h,
                  fontWeight: isAssets ? FontWeight.w600 : FontWeight.w500,
                  color:
                      textColor ?? Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
