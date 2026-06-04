// Date Created :21/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :21/November/2023
// Objectives: this is a widget to customize the app bar of the workday and assets container in employee attendace screen 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

// ignore: must_be_immutable
class TableContainerInfoAppBar extends StatefulWidget {
  TableContainerInfoAppBar({
    super.key,
    required this.selectedIndex,
    required this.selectedIndexState,
  });
  int selectedIndex;
  ValueChanged<int> selectedIndexState;

  @override
  State<TableContainerInfoAppBar> createState() =>
      _TableContainerInfoAppBarState();
}

class _TableContainerInfoAppBarState extends State<TableContainerInfoAppBar> {
  final TextStyle unselectedStyle = AppFontStyle.cairoRegularStyle.copyWith(
    fontSize: FontConstants.fontSize015.w,
    color: MyThemeData.colorGrey,
    fontWeight: FontWeight.w400,
  );
  final TextStyle selectedStyle = AppFontStyle.cairoRegularStyle.copyWith(
    color: MyThemeData.lightPrimary,
    /*Theme.of(context).colorScheme.onInverseSurface,*/
    fontWeight: FontWeight.w800,
    fontSize: FontConstants.fontSize015.w,
  );
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0.02.w, right: 0.02.w, top: 0.02.h),
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
                child: Text("Workday Table".tr,
                    // textAlign: TextAlign.start,
                    style: widget.selectedIndex == 0
                        ? selectedStyle
                        : unselectedStyle),
              ),
              SizedBox(
                width: 0.04.r,
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
                child: Text("Assets".tr,
                    textAlign: TextAlign.end,
                    style: widget.selectedIndex == 1
                        ? selectedStyle
                        : unselectedStyle),
              ),
            ],
          ),
          SizedBox(
            height: 0.01.r,
          ),
          SizedBox(
            height: 0.005.h,
            child: Row(
              children: [
                Container(
                  width: Get.locale.toString().contains('en') ? 0.095.w : 0.105.w,
                  color: widget.selectedIndex == 0
                      ? MyThemeData.lightPrimary
                      : Colors.transparent,
                ),
                Container(
                  width: 0.024.w,
                  color: Colors.transparent,
                ),
                Container(
                  width:
                      Get.locale.toString().contains('en') ? 0.045.w : 0.04.w,
                  color: widget.selectedIndex == 1
                      ? MyThemeData.lightPrimary
                      : Colors.transparent,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
