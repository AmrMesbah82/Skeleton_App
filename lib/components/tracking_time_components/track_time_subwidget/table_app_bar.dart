// Date Created :14/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :14/November/2023
// Objectives: this is a widget to customize the app bar of the table in track time screen
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

// ignore: must_be_immutable
class TableContainerAppBar extends StatefulWidget {
  TableContainerAppBar(
      {super.key,
      required this.selectedIndex,
      required this.selectedIndexState,
      this.isEmployeeProfile = false,
      this.title1,
      this.title2,
      this.title3,
      this.title1Width,
      this.title3Width,
      this.isEmployeesub = false,
      this.isEmployeesScreen = false,
      this.title2Width});
  bool isEmployeeProfile;
  int selectedIndex;
  ValueChanged<int> selectedIndexState;
  bool isEmployeesScreen;
  bool isEmployeesub;
  String? title1;
  String? title2;
  String? title3;
  double? title1Width;
  double? title2Width;
  double? title3Width;

  @override
  State<TableContainerAppBar> createState() => _TableContainerAppBarState();
}

class _TableContainerAppBarState extends State<TableContainerAppBar> {
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final TextStyle unselectedStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: isTablet
          ? FontConstants.fontSize028.r
          : widget.isEmployeesScreen
              ? FontConstants.fontSize025.h
              : FontConstants.fontSize018.h,
      color: MyThemeData.colorGrey,
      fontWeight: FontWeight.w400,
    );
    final TextStyle selectedStyle = AppFontStyle.cairoRegularStyle.copyWith(
      color: MyThemeData.lightPrimary,
      /*Theme.of(context).colorScheme.onInverseSurface,*/
      fontWeight: widget.isEmployeeProfile == true
          ? FontWeight.w500
          : Get.locale.toString().contains('en')
              ? FontWeight.w800
              : FontWeight.w500,
      fontSize: isTablet
          ? FontConstants.fontSize028.r
          : widget.isEmployeesScreen
              ? FontConstants.fontSize025.h
              : FontConstants.fontSize018.h,
    );
    return Padding(
      padding: EdgeInsets.only(
          left: widget.isEmployeeProfile == true
              ? 0
              : isTablet
                  ? 0.02.w
                  : 0,
          right: widget.isEmployeeProfile == true
              ? 0
              : isTablet
                  ? 0.02.w
                  : 0,
          top: widget.isEmployeeProfile == true ? 0 : 0.015.h),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.lightImpact,
                      hapticFeedback: HapticFeedback.lightImpact);
                  setState(() {
                    widget.selectedIndex = 0;
                    widget.selectedIndexState(widget.selectedIndex);
                  });
                },
                child: Text(
                  widget.title1 ?? "Attendance History".tr,
                  // textAlign: TextAlign.start,
                  style: widget.selectedIndex == 0
                      ? isTablet
                          ? selectedStyle
                          : selectedStyle.copyWith(
                              fontSize: widget.isEmployeesScreen
                                  ? widget.isEmployeesub
                                      ? FontConstants.fontSize019.h
                                      : FontConstants.fontSize022.h
                                  : widget.isEmployeesub
                                      ? FontConstants.fontSize015.h
                                      : FontConstants.fontSize019.h,
                              height: 1.8,
                              shadows: [
                                Shadow(
                                    color: MyThemeData.lightPrimary,
                                    offset: Offset(0, -5))
                              ],
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                              decorationColor: MyThemeData.lightPrimary,
                              decorationThickness: 2.5)
                      : isTablet
                          ? unselectedStyle
                          : unselectedStyle.copyWith(
                              fontSize: widget.isEmployeesScreen
                                  ? FontConstants.fontSize022.h
                                  : widget.isEmployeesub
                                      ? FontConstants.fontSize015.h
                                      : FontConstants.fontSize019.h,
                            ),
                ),
              ),
              SizedBox(
                width: widget.isEmployeesScreen ? 0.06.w : 0.03.w,
              ),
              GestureDetector(
                onTap: () {
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.lightImpact,
                      hapticFeedback: HapticFeedback.lightImpact);
                  setState(() {
                    widget.selectedIndex = 1;
                    widget.selectedIndexState(widget.selectedIndex);
                  });
                },
                child: Text(
                  widget.title2 ?? "Requested and Approved".tr,
                  textAlign: TextAlign.end,
                  style: widget.selectedIndex == 1
                      ? isTablet
                          ? selectedStyle
                          : selectedStyle.copyWith(
                              fontSize: widget.isEmployeesScreen
                                  ? FontConstants.fontSize022.h
                                  : widget.isEmployeesub
                                      ? FontConstants.fontSize015.h
                                      : FontConstants.fontSize019.h,
                              height: 1.8,
                              shadows: [
                                Shadow(
                                    color: MyThemeData.lightPrimary,
                                    offset: Offset(0, -5))
                              ],
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                              decorationColor: MyThemeData.lightPrimary,
                              decorationThickness: 2.5)
                      : isTablet
                          ? unselectedStyle
                          : unselectedStyle.copyWith(
                              fontSize: widget.isEmployeesScreen
                                  ? FontConstants.fontSize022.h
                                  : widget.isEmployeesub
                                      ? FontConstants.fontSize015.h
                                      : FontConstants.fontSize019.h,
                            ),
                ),
              ),
              SizedBox(
                width: 0.03.w,
              ),
              GestureDetector(
                onTap: () {
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.lightImpact,
                      hapticFeedback: HapticFeedback.lightImpact);
                  setState(() {
                    widget.selectedIndex = 2;
                    widget.selectedIndexState(widget.selectedIndex);
                  });
                },
                child: Text(widget.title3 ?? "",
                    textAlign: TextAlign.end,
                    style: widget.selectedIndex == 2
                        ? selectedStyle
                        : unselectedStyle),
              ),
            ],
          ),
          SizedBox(
            height: 0.01.r,
          ),
          // SizedBox(
          //   height: isTablet ? 0.005.h : 0.003.h,
          //   child: Row(
          //     children: [
          //       Container(
          //         width: widget.title1 != null
          //             ? widget.title1Width ??
          //                 (Get.locale.toString().contains('en')
          //                     ? 0.09.w
          //                     : 0.045.w)
          //             : Get.locale.toString().contains('en')
          //                 ? isTablet
          //                     ? 0.156.w
          //                     : 0.325.w
          //                 : 0.095.w,
          //         color: widget.selectedIndex == 0
          //             ? MyThemeData.lightPrimary
          //             : Colors.transparent,
          //       ),
          //       Container(
          //         width: widget.title1 != null &&
          //                 Get.locale.toString().contains('ar')
          //             ? 0.023.w
          //             : 0.021.w,
          //         color: Colors.transparent,
          //       ),
          //       Container(
          //         width: Get.locale.toString().contains('en')
          //             ? widget.title2 != null
          //                 ? widget.title2Width ?? 0.11.w
          //                 : isTablet
          //                     ? 0.2.w
          //                     : 0.425.w
          //             : widget.title2Width ??
          //                 (Get.locale.toString().contains('en')
          //                     ? 0.13.w
          //                     : 0.2.h),
          //         color: widget.selectedIndex == 1
          //             ? MyThemeData.lightPrimary
          //             : Colors.transparent,
          //       ),
          //       Container(
          //         width: widget.title2 != null &&
          //                 Get.locale.toString().contains('ar')
          //             ? 0.023.w
          //             : 0.028.w,
          //         color: Colors.transparent,
          //       ),
          //       widget.title3 != null
          //           ? Padding(
          //               padding: EdgeInsets.only(
          //                 left:
          //                     Get.locale.toString().contains('ar') ? 0 : .055.w,
          //                 right:
          //                     Get.locale.toString().contains('en') ? 0 : .055.w,
          //               ),
          //               child: Container(
          //                 width: Get.locale.toString().contains('en')
          //                     ? widget.title3 != null
          //                         ? widget.title3Width ?? 0.11.w
          //                         : 0.2.w
          //                     : widget.title3Width ??
          //                         (Get.locale.toString().contains('en')
          //                             ? 0.13.w
          //                             : 0.2.h),
          //                 color: widget.selectedIndex == 2
          //                     ? MyThemeData.lightPrimary
          //                     : Colors.transparent,
          //               ),
          //             )
          //           : SizedBox(),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
