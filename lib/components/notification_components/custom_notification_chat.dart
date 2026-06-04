import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

import '../../features/skeleton/employees/data/models/notification_model.dart';
// REMOVED_MODULE: import 'package:demo_app/feature/models/notification_model.dart';
// REMOVED_MODULE: import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';

class CustomNotificationChatMobile extends StatefulWidget {
  const CustomNotificationChatMobile(
      {super.key,
      required this.isChat,
      required this.time,
      required this.notification});
  final bool isChat;
  final String time;
  final NotificationModel notification;

  @override
  State<CustomNotificationChatMobile> createState() =>
      _CustomNotificationChatMobileState();
}

class _CustomNotificationChatMobileState
    extends State<CustomNotificationChatMobile> {
  ButtonStyle buttonStyle(Color buttonColor) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return ElevatedButton.styleFrom(
        backgroundColor: buttonColor, //MyThemeData.bubbleColor,
        minimumSize: isPortrait ? Size(0.1.w, 0.045.h) : Size(0.2.w, 0.055.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
  }

  @override
  Widget build(BuildContext context) {
    DateTime notificationTime = widget.notification.timestamp.toDate();
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
              height:(isTablet ? (isPortrait ? 0.14.h : 0.18.h) : 0.15.h),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      timeAgo(notificationTime),
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: isTablet
                            ? isPortrait
                                ? FontConstants.fontSize017.h
                                : FontConstants.fontSize022.h
                            : FontConstants.fontSize016.h,
                        color: themeController.currentTheme ==
                                MyThemeData.lightTheme
                            ? MyThemeData.colorDarkGrey
                            : MyThemeData.colorGreydark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 0.02.w,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                       height:
                          isTablet ? (isPortrait ? 0.045.h : 0.05.h) : 0.04.h,
                      width:
                          isTablet ? (isPortrait ? 0.045.h : 0.05.h) : 0.04.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: MyThemeData.bubbleColor),
                      child: Transform.scale(
                           scale:   isTablet
                                    ? (isPortrait ? 0.6 : 0.7)
                                    : 0.6,
                          child: SvgPicture.asset(
                            "assets/images/chat_notifi_mob.svg",
                            color: MyThemeData().contrastColor(),
                          )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.005.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Get.locale.toString().contains('en')
                                    ? widget.notification.title.tr.capitalize!
                                    : widget.notification.titleArabic.capitalize!,
                                // widget.isChat
                                //     ? "Group Chat".tr
                                //     : "Request Update".tr,
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
                              SizedBox(height: 0.01.h,),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0.0.h),
                                    child: Container(
                                      height: isPortrait? 0.05.h : 0.07.h,
                                 //     color: Colors.amber,
                                      width: isTablet
                                          ? isPortrait
                                              ? 0.65.w
                                              : 0.78.w
                                          : 0.75.w,
                                  
                                      child: Text(
                                        Get.locale.toString().contains('en')
                                            ? widget.notification.body.capitalize!
                                            : widget.notification.bodyArabic,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFontStyle.cairoRegularStyle
                                            .copyWith(
                                                fontSize: isTablet
                                                    ? isPortrait
                                                        ? FontConstants
                                                            .fontSize018.h
                                                        : FontConstants
                                                            .fontSize025.h
                                                    : FontConstants.fontSize020.h,
                                                color:
                                                    themeController.currentTheme ==
                                                            MyThemeData.lightTheme
                                                        ? MyThemeData.colorDarkGrey
                                                        : MyThemeData.colorGreydark,
                                                fontWeight: FontWeight.w500,
                                                height: 1.4
                                                ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 0.02.w,)
                                ],
                              ),
                              // Text(
                              //   DateFormat("yyyy-MM-dd 'at' h:mm aaa").format(
                              //       widget.notification.timestamp.toDate()),
                              //   style: AppFontStyle.cairoRegularStyle.copyWith(
                              //     fontSize: isTablet
                              //         ? isPortrait
                              //             ? FontConstants.fontSize017.h
                              //             : FontConstants.fontSize022.h
                              //         : FontConstants.fontSize017.h,
                              //     color: themeController.currentTheme ==
                              //             MyThemeData.lightTheme
                              //         ? MyThemeData.colorDarkGrey
                              //         : MyThemeData.colorGreydark,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
