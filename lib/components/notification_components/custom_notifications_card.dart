import 'dart:convert';
import 'dart:io';

import 'package:demo_app/core/theme/grc_theme_controller.dart';
import 'package:demo_app/features/external/main_core/features/notification/presentation/controller/notification_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/controllers/notification_controller.dart';
import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:demo_app/main.dart';

import '../../features/skeleton/employees/data/models/notification_model.dart';

class CusomNotificationscCard extends StatefulWidget {
  CusomNotificationscCard({
    super.key,
    required this.notification,
  });

  final NotificationModel notification;

  @override
  State<CusomNotificationscCard> createState() =>
      _CusomNotificationscCardState();
}

class _CusomNotificationscCardState extends State<CusomNotificationscCard> {
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

    String getImagePath() {
      if (widget.notification.type.toLowerCase() == "board" ||
          widget.notification.type.toLowerCase() == "card") {
        return "assets/images/notify_board_mobile.svg";
      } else if (widget.notification.type.toLowerCase() == "chat") {
        return "assets/images/chat_notifi_mob.svg";
      } else if (widget.notification.type.toLowerCase() == "event" ||
          widget.notification.type.toLowerCase() == 'survey') {
        return "assets/images/events_knwoticed.svg";
      } else if (widget.notification.type.toLowerCase() == "todo") {
        return "assets/icons/List.svg";
      } else if (widget.notification.type.toLowerCase() == "request") {
        return "assets/icons/DocumentAdd.svg";
      } else if (widget.notification.type.toLowerCase() == "service request" ||
          widget.notification.type.toLowerCase() == "my request" ||
          widget.notification.type.toLowerCase() == "service cycle approval" ||
          widget.notification.type.toLowerCase() == "service provider") {
        return "assets/icons/service.svg";
      } else if (widget.notification.type.toLowerCase() == "note") {
        return 'assets/images/Notes.svg';
      } else {
        return "assets/icons/bellIcon.svg";
      }
    }

    String getTextName() {
      if (widget.notification.type.toLowerCase() == "card") {
        return "Go To Card";
      } else if (widget.notification.type.toLowerCase() == "board") {
        return "Go To Board";
      } else if (widget.notification.type.toLowerCase() == "chat") {
        return '';
      } else if (widget.notification.type.toLowerCase() == "event") {
        return "Go To Event";
      } else if (widget.notification.type.toLowerCase() == 'survey') {
        return "Go To Survey";
      } else if (widget.notification.type.toLowerCase() == "todo") {
        return "Go To To-Do List";
      } else if (widget.notification.type.toLowerCase() == "service request") {
        return "Go To Service Request";
      } else if (widget.notification.type.toLowerCase() == "my request") {
        return "Go To My Request";
      } else if (widget.notification.type.toLowerCase() ==
          "service cycle approval") {
        return "Go To Request Approval";
      } else if (widget.notification.type.toLowerCase() == "service provider" &&
          Mode.hr) {
        return "Go To Service";
      } else if (widget.notification.type.toLowerCase() == "note") {
        return "Go To Note";
      } else {
        return '';
      }
    }

    double getIconSize(BuildContext context) {
      double screenHeight = MediaQuery.of(context).size.height;
      bool isDesktop =
          Platform.isLinux || Platform.isMacOS || Platform.isWindows;

      if (isDesktop && screenHeight >= 611 && screenHeight < 810) {
        return 0.9;
      } else if (isDesktop && screenHeight >= 810 && screenHeight < 900) {
        return 1.1;
      } else if (isDesktop && screenHeight >= 900 && screenHeight < 950) {
        return 1.3;
      } else if (isDesktop && screenHeight >= 950 && screenHeight < 1000) {
        return 1.5;
      } else if (isDesktop && screenHeight >= 1000) {
        return 1.5;
      }

      return 1.1;
    }

    String timeStamp(String dateString) {
      final DateTime now = DateTime.now();
      final DateTime inputDate = DateFormat('dd/MM/yyyy').parse(dateString);
      final Duration difference = now.difference(inputDate);
      if (difference.inDays == 0) {
        return 'Today'.tr;
      } else if (difference.inDays == 1) {
        return 'Yesterday'.tr;
      } else {
        return '${difference.inDays} ${"Days Ago".tr}';
      }
    }

    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isDesktop = Platform.isLinux || Platform.isMacOS || Platform.isWindows;
    return Padding(
      padding: EdgeInsets.only(bottom: 0.02.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 0.01.h,
                decoration: BoxDecoration(
                  color: MyThemeData.lightPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        Get.locale.toString().contains('en') ? 8 : 0),
                    bottomLeft: Radius.circular(
                        Get.locale.toString().contains('en') ? 8 : 0),
                    topRight: Radius.circular(
                        Get.locale.toString().contains('ar') ? 8 : 0),
                    bottomRight: Radius.circular(
                        Get.locale.toString().contains('ar') ? 8 : 0),
                  ),
                ),
              ),
              SizedBox(
                width: isTablet ? 0.015.w : 0.02.w,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.02.h),
                child: Container(
                  height: isTablet ? (isPortrait ? 0.045.h : 0.06.h) : 0.04.h,
                  width: isTablet ? (isPortrait ? 0.045.h : 0.06.h) : 0.04.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(6),
                      color: MyThemeData.bubbleColor),
                  child: Center(
                    child: Transform.scale(
                        scale: isDesktop
                            ? getIconSize(context)
                            : (widget.notification.title
                                    .toLowerCase()
                                    .contains('access')
                                ? isTablet
                                    ? (isPortrait ? 1 : 0.7)
                                    : 0.6
                                : isTablet
                                    ? (isPortrait ? 1.2 : 1.2)
                                    : 0.8),
                        child: SvgPicture.asset(
                          getImagePath(),
                          color: MyThemeData().contrastColor(),
                        )),
                  ),
                ),
              ),
              SizedBox(
                width: isTablet ? 0.015.w : 0.02.w,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 0.025.h, bottom: isTablet ? 0.02.h : 0.015.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  Get.locale.toString().contains('en')
                                      ? widget.notification.title.tr.capitalize!
                                      : widget
                                          .notification.titleArabic.capitalize!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      AppFontStyle.cairoRegularStyle.copyWith(
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
                              ),
                              SizedBox(
                                width: 0.015.w,
                              ),
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
                                width: isTablet ? 0.015.w : 0.02.w,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  Get.locale.toString().contains('en')
                                      ? widget.notification.body.capitalize!
                                      : widget
                                          .notification.bodyArabic.capitalize!,
                                  // overflow: TextOverflow.ellipsis,
                                  style: AppFontStyle.cairoRegularStyle
                                      .copyWith(
                                          fontSize: isTablet
                                              ? isPortrait
                                                  ? FontConstants.fontSize018.h
                                                  : FontConstants.fontSize025.h
                                              : FontConstants.fontSize018.h,
                                          color: themeController.currentTheme ==
                                                  MyThemeData.lightTheme
                                              ? MyThemeData.colorDarkGrey
                                              : MyThemeData.colorGreydark,
                                          fontWeight: FontWeight.w500,
                                          height: 1.6),
                                ),
                              ),
                              SizedBox(
                                width: isTablet ? 0.015.w : 0.02.w,
                              ),
                            ],
                          ),
                        ],
                      ),

                      // if (widget.isDefault == false)
                      if (getTextName() != '') ...[
                        SizedBox(
                          height: isTablet ? 0.01.h : 0,
                        ),
                        // if (widget.isDefault == false)
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.015.h,
                              right: Get.locale.toString().contains('en')
                                  ? isTablet
                                      ? 0.015.w
                                      : 0.02.w
                                  : 0,
                              left: Get.locale.toString().contains('en')
                                  ? 0
                                  : isTablet
                                      ? 0.015.w
                                      : 0.02.w),
                          child: Row(
                            // direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              CustomIconButton(
                                buttonHeight: isPortrait ? 0.04.h : 0.055.h,
                                buttonText: getTextName(),
                                hasIcon: false,
                                imagePath: " ",
                                onPressed: () {
                                  NotificationData notificationData =
                                      NotificationData(
                                    type: widget.notification.type,
                                    noteId: widget.notification.noteId,
                                    cardId: widget.notification.cardId,
                                    todoId: widget.notification.todoId,
                                    eventId: widget.notification.eventId,
                                    surveyId: widget.notification.surveyId,
                                    boardId: widget.notification.boardId,
                                    serviceId: widget.notification.serviceId,
                                    serviceRequestId:
                                        widget.notification.serviceRequestId,
                                    clickAction: "FLUTTER_NOTIFICATION_CLICK",
                                    englishTitle: widget.notification.title,
                                    arabicTitle:
                                        widget.notification.titleArabic,
                                    englishBody: widget.notification.body,
                                    arabicBody: widget.notification.bodyArabic,
                                  );
                                  String payload =
                                      jsonEncode(notificationData.toMap());
                                  isTablet
                                      ? onTapOnNotificationTablet(
                                          payload, context)
                                      : onTapOnNotificationMobile(
                                          payload, context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
