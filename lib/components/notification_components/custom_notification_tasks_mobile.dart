import 'package:demo_app/core/theme/grc_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

import '../../features/skeleton/employees/data/models/notification_model.dart';

class CustomNotificationTasks extends StatefulWidget {
  const CustomNotificationTasks(
      {super.key,
      required this.time,
      required this.isReminder,
      required this.notification});
  final String time;
  final bool isReminder;
  final NotificationModel notification;

  @override
  State<CustomNotificationTasks> createState() =>
      _CustomNotificationTasksState();
}

class _CustomNotificationTasksState extends State<CustomNotificationTasks> {
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
              height: isTablet ? (isPortrait ? 0.22.h : 0.28.h) : 0.22.h,
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
                      child: Center(
                        child: Transform.scale(
                            scale: isTablet ? (isPortrait ? 1.3 : 1.1) : 0.8,
                            child: SvgPicture.asset(
                              "assets/images/tasks_notify_mobile.svg",
                              color: MyThemeData().contrastColor(),
                            )),
                      ),
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
                                // widget.isReminder
                                //     ? "Task Reminder".tr
                                //     : "Assigned Task".tr,
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
                                    padding:
                                        EdgeInsets.symmetric(vertical: 0.0.h),
                                    child: Container(
                                        height:isTablet? ( isPortrait? 0.07.h : 0.07.h) : 0.06.h,
                                    //  color: Colors.amber,
                                      width: isTablet
                                          ? isPortrait
                                              ? 0.65.w
                                              : 0.78.w
                                          : 0.75.w,

                                      child: Text(
                                        Get.locale.toString().contains('en')
                                            ? widget
                                                .notification.body.capitalize!
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
                                                    : FontConstants
                                                        .fontSize018.h,
                                                color: themeController
                                                            .currentTheme ==
                                                        MyThemeData.lightTheme
                                                    ? MyThemeData.colorDarkGrey
                                                    : MyThemeData.colorGreydark,
                                                fontWeight: FontWeight.w500,
                                                height: 0.0016.h),
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
                              //         : FontConstants.fontSize016.h,
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
                Padding(
                  padding: EdgeInsets.only(
                      top: 0.015.h,
                      right: Get.locale.toString().contains('en') ? 0.02.w : 0,
                      left: Get.locale.toString().contains('en') ? 0 : 0.02.w),
                  child: Row(
                    // direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      widget.isReminder
                          ? MainCustomIconButton(
                              buttonStyle:
                                  buttonStyle(MyThemeData.colorWhiteDark),
                              onPressed: () {},
          
                              buttonText: "Remind Me Later".tr,
                            )
                          : const SizedBox.shrink(),
                      widget.isReminder
                          ? Container(width: 0.025.w)
                          : const SizedBox.shrink(),
                      MainCustomIconButton(
                        buttonStyle: buttonStyle(MyThemeData.bubbleColor),
                        onPressed: () {},
                        buttonText: "Go To Task".tr,)
                        
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
