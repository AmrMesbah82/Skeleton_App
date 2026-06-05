import 'package:demo_app/core/theme/grc_theme_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/theme/font_manager.dart';

import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';

class CustomNotificationContainerMobile extends StatefulWidget {
  const CustomNotificationContainerMobile(
      {super.key,
      required this.name,
      required this.description,
      required this.time,
      required this.notifyIndex,
      this.meetingIndex});
  final String name;
  final String description;
  final String time;
  final int
      notifyIndex; // 0 for meetings 1 for tasks 2 for board 3 for message 4 for check in
  final int? meetingIndex; // 0 for reminder  1 for cancel 2 for invitation

  @override
  State<CustomNotificationContainerMobile> createState() =>
      _CustomNotificationContainerMobileState();
}

class _CustomNotificationContainerMobileState
    extends State<CustomNotificationContainerMobile> {
  ButtonStyle buttonStyle(Color buttonColor) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return ElevatedButton.styleFrom(
        backgroundColor: buttonColor, //MyThemeData.bubbleColor,
        minimumSize: isTablet
            ? isPortrait
                ? Size(0.1.w, 0.045.h)
                : Size(0.2.w, 0.055.h)
            : Size(0.2.w, 0.048.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: EdgeInsets.only(top: 0.02.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Row(
          children: [
            Container(
              width: 0.01.h,
              height: widget.meetingIndex == 1 ? 0.14.h : 0.22.h,
              decoration: BoxDecoration(
                color: MyThemeData.lightPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      Get.locale.toString().contains('en') ? 7.0 : 0),
                  bottomLeft: Radius.circular(
                      Get.locale.toString().contains('en') ? 7.0 : 0),
                  topRight: Radius.circular(
                      Get.locale.toString().contains('ar') ? 7.0 : 0),
                  bottomRight: Radius.circular(
                      Get.locale.toString().contains('ar') ? 7.0 : 0),
                ),
              ),
            ),
            SizedBox(
              width: 0.02.w,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: isTablet ? (isPortrait? 0.045.h : 0.06.h) : 0.04.h,
                      width: isTablet ? (isPortrait? 0.045.h : 0.06.h) : 0.04.h,
                     
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: MyThemeData.bubbleColor),
                      child: Transform.scale(
                          scale: isPortrait ? 0.75 : 0.95,
                          child: widget.notifyIndex == 0
                              ? SvgPicture.asset(
                                  "assets/images/meeting_notifi_mob.svg",
                                  color: MyThemeData().contrastColor(),
                                )
                              : Container()),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 0.005.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.notifyIndex == 0
                                    ? widget.meetingIndex == 0
                                        ? "Meeting Reminder".tr
                                        : widget.meetingIndex == 1
                                            ? "Canceled Meeting".tr
                                            : "Meeting Invitation".tr
                                    : widget.name.tr.capitalize as String,
                                style: AppFontStyle.cairoRegularStyle.copyWith(
                                  fontSize: isTablet
                                      ? isPortrait
                                          ? FontConstants.fontSize022.h
                                          : FontConstants.fontSize027.h
                                      : FontConstants.fontSize022.h,
                                  color: themeController.currentTheme ==
                                          MyThemeData.lightTheme
                                      ? MyThemeData.colorBlack
                                      : MyThemeData.colorWhiteDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.01.h),
                                child: Container(
                                  //color: Colors.amber,
                                  width: isTablet
                                      ? isPortrait
                                          ? 0.65.w
                                          : 0.78.w
                                      : 0.75.w,

                                  child: Text(
                                    widget.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFontStyle.cairoRegularStyle
                                        .copyWith(
                                            fontSize: isTablet
                                                ? isPortrait
                                                    ? FontConstants
                                                        .fontSize020.h
                                                    : FontConstants
                                                        .fontSize025.h
                                                : FontConstants.fontSize020.h,
                                            color:
                                                themeController.currentTheme ==
                                                        MyThemeData.lightTheme
                                                    ? MyThemeData.colorDarkGrey
                                                    : MyThemeData.colorGreydark,
                                            fontWeight: FontWeight.w500,
                                            height: 0.0016.h),
                                  ),
                                ),
                              ),
                              Text(
                                widget.time.tr,
                                style: AppFontStyle.cairoRegularStyle.copyWith(
                                  fontSize: isTablet
                                      ? isPortrait
                                          ? FontConstants.fontSize017.h
                                          : FontConstants.fontSize022.h
                                      : FontConstants.fontSize017.h,
                                  color: themeController.currentTheme ==
                                          MyThemeData.lightTheme
                                      ? MyThemeData.colorDarkGrey
                                      : MyThemeData.colorGreydark,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                widget.meetingIndex == 1
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(
                            top: 0.025.h,
                            right: Get.locale.toString().contains('en')
                                ? 0.02.w
                                : 0,
                            left: Get.locale.toString().contains('en')
                                ? 0
                                : 0.02.w),
                        child: Row(
                          // direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            MainCustomIconButton(
                              buttonStyle:
                                  buttonStyle(MyThemeData.colorWhiteDark),
                              onPressed: () {},
                             
                               
                              buttonText: widget.meetingIndex == 0
                                  ? "Add Reminder".tr
                                  : "Respond No".tr,
               
                            ),
                            Container(width: 0.025.w),
                            MainCustomIconButton(
                              buttonStyle: buttonStyle(MyThemeData.bubbleColor),
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         const ScheduleDetailesScreenMobile(
                                //       text: 'Basic Meeting',
                                //       description:
                                //           'Tempor elementum quam vitae pellentesque eu. Tristique consectetur ut lacus urna duis eros auctor porta. Euismod nisi suspendisse sed laoreet nulla mauris nunc',
                                //       startTime: "09:00 AM",
                                //       endTime: "10:00 AM",
                                //       firstImage: "assets/images/profile1.png",
                                //     ),
                                //   ),
                                // );
                              },
                              buttonText: widget.meetingIndex == 0
                                  ? "Meeting Link".tr
                                  : "Respond Yes".tr,

                
                            ),
                          ],
                        ),
                      ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
