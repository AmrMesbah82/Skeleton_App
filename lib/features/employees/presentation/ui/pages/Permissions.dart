import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/custom_expandable_container.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/permissions/permissions_widgets.dart';

class PermissionsView extends StatefulWidget {
  const PermissionsView({super.key});

  @override
  State<PermissionsView> createState() => _PermissionsViewState();
}

class _PermissionsViewState extends State<PermissionsView> {
  bool expanded1 = false;
  bool expanded2 = false;
  bool expanded3 = false;
  bool expanded4 = false;
  bool expanded5 = false;
  bool expanded6 = false;
  Color containerColor = MyThemeData.signOut;
  Color textColor = MyThemeData().contrastColor();
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.02.h),
                child: GestureDetector(
                  onTap: () {
                    hapticController.triggerHapticFeedback(
                        vibration: VibrateType.lightImpact,
                        hapticFeedback: HapticFeedback.lightImpact);
                    setState(() {
                      expanded1 = !expanded1;
                    });
                  },
                  child: ExpandableContainer(
                    expanded: expanded1,
                    paddingV: isTablet
                        ? isPortrait
                            ? 0
                            : 0.013.h
                        : 0.013.h,
                    title: "Home Page",
                    color: containerColor,
                    textColor: textColor,
                  ),
                ),
              ),
              expanded1
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet
                            ? isPortrait
                                ? 0.005.h
                                : 0.015.w
                            : 0.015.w,
                      ),
                      child: homePageWidget,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: expanded2 ? 0.02.h : 0,
              ),
              GestureDetector(
                onTap: () {
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.lightImpact,
                      hapticFeedback: HapticFeedback.lightImpact);
                  setState(() {
                    expanded2 = !expanded2;
                  });
                },
                child: ExpandableContainer(
                  expanded: expanded2,
                  title: "Employee Page",
                  paddingV: isTablet
                      ? isPortrait
                          ? 0
                          : 0.013.h
                      : 0.013.h,
                  color: containerColor,
                  textColor: textColor,
                ),
              ),
              SizedBox(
                height: expanded2 ? 0.02.h : 0,
              ),
              expanded2
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet
                            ? isPortrait
                                ? 0.005.h
                                : 0.015.w
                            : 0.015.w,
                      ),
                      child: employeeDataWidget,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 0.02.h,
              ),
              GestureDetector(
                onTap: () {
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.lightImpact,
                      hapticFeedback: HapticFeedback.lightImpact);
                  setState(() {
                    expanded3 = !expanded3;
                  });
                },
                child: ExpandableContainer(
                  expanded: expanded3,
                  title: "Chat Page",
                  paddingV: isTablet
                      ? isPortrait
                          ? 0
                          : 0.013.h
                      : 0.013.h,
                  color: containerColor,
                  textColor: textColor,
                ),
              ),
              SizedBox(
                height: 0.02.h,
              ),
              expanded3
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet
                            ? isPortrait
                                ? 0.005.h
                                : 0.015.w
                            : 0.015.w,
                      ),
                      child: chatWidget,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: expanded4 ? 0.02.h : 0,
              ),
              GestureDetector(
                onTap: () {
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.lightImpact,
                      hapticFeedback: HapticFeedback.lightImpact);
                  setState(() {
                    expanded4 = !expanded4;
                  });
                },
                child: ExpandableContainer(
                  expanded: expanded4,
                  title: "Board Page",
                  paddingV: isTablet
                      ? isPortrait
                          ? 0
                          : 0.013.h
                      : 0.013.h,
                  color: containerColor,
                  textColor: textColor,
                ),
              ),
              SizedBox(
                height: expanded4 ? 0.02.h : 0,
              ),
              expanded4
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet
                            ? isPortrait
                                ? 0.005.h
                                : 0.015.w
                            : 0.015.w,
                      ),
                      child: boardWidget,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 0.02.h,
              ),
              GestureDetector(
                onTap: () {
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.lightImpact,
                      hapticFeedback: HapticFeedback.lightImpact);
                  setState(() {
                    expanded5 = !expanded5;
                  });
                },
                child: ExpandableContainer(
                  expanded: expanded5,
                  title: "Check in & out Page",
                  color: containerColor,
                  paddingV: isTablet
                      ? isPortrait
                          ? 0
                          : 0.013.h
                      : 0.013.h,
                  textColor: textColor,
                ),
              ),
              SizedBox(
                height: 0.02.h,
              ),
              expanded5
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet
                            ? isPortrait
                                ? 0.005.h
                                : 0.015.w
                            : 0.015.w,
                      ),
                      child: meetingWidget,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: expanded6 ? 0.02.h : 0,
              ),
              GestureDetector(
                onTap: () {
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.lightImpact,
                      hapticFeedback: HapticFeedback.lightImpact);
                  setState(() {
                    expanded6 = !expanded6;
                  });
                },
                child: ExpandableContainer(
                  expanded: expanded6,
                  title: "Setting Page",
                  color: containerColor,
                  paddingV: isTablet
                      ? isPortrait
                          ? 0
                          : 0.013.h
                      : 0.013.h,
                  textColor: textColor,
                ),
              ),
              SizedBox(
                height: expanded6 ? 0.02.h : 0,
              ),
              expanded6
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet
                            ? isPortrait
                                ? 0.005.h
                                : 0.015.w
                            : 0.015.w,
                      ),
                      child: settingWidget,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
