import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';

import '../../../../../skeleton/onboarding/presentation/ui/pages/onboarding.dart';

// Date Created :4/December/2023
// Developer Name : Bassem Mohamed
// App Version : Version 2
// Date of Last Edit :10/December/2023
// Objectives: this is the widget responsible for the notifications, this widget can be used dynamically to differ between the task reminders
// and the normal notifications, and this can be done according to the name entered to the widget.

class CustomNotificationContainer extends StatefulWidget {
  final String name;
  final String description;
  final String time;
  final String? imagePath;
  final bool isTaskReminder;
  final VoidCallback onNotificationPressed;
  final VoidCallback onNotificationDeniedPressed;

  const CustomNotificationContainer({
    required this.name,
    required this.description,
    required this.onNotificationPressed,
    required this.onNotificationDeniedPressed,
    required this.time,
    this.imagePath,
    this.isTaskReminder = false,
  });

  @override
  State<CustomNotificationContainer> createState() =>
      _CustomNotificationContainerState();
}

class _CustomNotificationContainerState
    extends State<CustomNotificationContainer> {
  @override
  Widget build(BuildContext context) {
    double height = 0.2.h;
    return Padding(
      padding: EdgeInsets.only(top: 0.02.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 0.015.h,
              height: height,
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
            SizedBox(width: 0.02.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.005.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.01.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.imagePath != null &&
                              widget.name.tr != "Task Reminder".tr)
                            CircleAvatar(
                              radius: 0.04.h,
                              backgroundImage: AssetImage(widget.imagePath!),
                            ),
                          if (widget.imagePath != null &&
                              widget.name.tr != "Task Reminder".tr)
                            SizedBox(width: 0.02.h),
                          if (widget.name.tr == "Task Reminder".tr)
                            CircleAvatar(
                              radius: 0.04.h,
                              child: SvgPicture.asset(
                                'assets/icons/taskRemainderCircular.svg',
                                fit: BoxFit.cover,
                                height: 0.08.h,
                              ),
                            ),
                          if (widget.name.tr == "Task Reminder".tr)
                            SizedBox(width: 0.02.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name.tr.capitalize as String,
                                style: AppFontStyle.cairoRegularStyle.copyWith(
                                  fontSize: FontConstants.fontSize024.h,
                                  color: mainCoreThemeController.currentTheme ==
                                          MyThemeData.lightTheme
                                      ? MyThemeData.colorBlack
                                      : MyThemeData.colorWhiteDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.01.h),
                                child: Container(
                                  //color: Colors.amber,
                                  width: 1.1.h,
                                  height: 0.065.h,
                                  child: Text(
                                    widget.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFontStyle.cairoRegularStyle
                                        .copyWith(
                                            fontSize:
                                                FontConstants.fontSize022.h,
                                            color: mainCoreThemeController
                                                        .currentTheme ==
                                                    MyThemeData.lightTheme
                                                ? MyThemeData.colorDarkGrey
                                                : MyThemeData.colorGreydark,
                                            fontWeight: FontWeight.w500,
                                            height: 0.0016.h),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.015.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right:
                            Get.locale.toString().contains('en') ? 0.02.h : 0,
                        bottom: 0.01.h,
                        left: Get.locale.toString().contains('ar') ? 0.02.h : 0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            widget.time.tr,
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: FontConstants.fontSize020.h,
                              color: mainCoreThemeController.currentTheme ==
                                      MyThemeData.lightTheme
                                  ? MyThemeData.colorDarkGrey
                                  : MyThemeData.colorGreydark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: widget.onNotificationPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyThemeData.signOut,
                                  minimumSize: Size(0.02.h, 0.05.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  widget.name.tr == "Task Reminder".tr
                                      ? 'Go to Task'.tr
                                      : 'Approved'.tr,
                                  style:
                                      AppFontStyle.cairoRegularStyle.copyWith(
                                    fontSize: FontConstants.fontSize022.h,
                                    color:
                                        mainCoreThemeController.currentTheme ==
                                                MyThemeData.lightTheme
                                            ? MyThemeData.colorBlack
                                            : MyThemeData.colorBlack,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: 0.03.h),
                              OutlinedButton(
                                onPressed: widget.onNotificationDeniedPressed,
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(0.01.h, 0.05.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: BorderSide(
                                      color: MyThemeData.colorGreydark),
                                ),
                                child: Text(
                                  'Deny'.tr,
                                  style:
                                      AppFontStyle.cairoRegularStyle.copyWith(
                                    fontSize: FontConstants.fontSize022.h,
                                    color:
                                        mainCoreThemeController.currentTheme ==
                                                MyThemeData.lightTheme
                                            ? MyThemeData.colorDarkGrey
                                            : MyThemeData.colorGreydark,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
