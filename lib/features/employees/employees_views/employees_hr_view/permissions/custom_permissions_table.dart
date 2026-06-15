import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/employees/presentation/ui/pages/add_new_employee_view.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
import 'dart:math' as math;

class CustomPermissionsTableWidget extends StatefulWidget {
  final List<String> initialData;
  final List<bool> currentValues;
  final List<Function(bool)> functionsList;
  final String title;

  CustomPermissionsTableWidget({
    required this.initialData,
    required this.currentValues,
    required this.functionsList,
    required this.title,
  });

  @override
  _CustomPermissionsTableWidgetState createState() =>
      _CustomPermissionsTableWidgetState();
}

class _CustomPermissionsTableWidgetState
    extends State<CustomPermissionsTableWidget> {
  List<Map<String, String>> tableData = [];

  @override
  void initState() {
    super.initState();
    widget.initialData.forEach((data) {
      tableData.add({
        "Permission": data.tr,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final HapticController hapticController = Get.put(HapticController());
    TextStyle customTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
        fontSize: isTablet
            ? isPortrait
                ? FontConstants.fontSize017.h
                : FontConstants.fontSize022.h
            : FontConstants.fontSize018.h,
        color: MyThemeData.colorWhite,
        fontWeight: isTablet ? FontWeight.w600 : FontWeight.w500,
        height: isTablet
            ? isPortrait
                ? 1.6
                : 0.002.h
            : 0.002.h);

    return Padding(
      padding: EdgeInsets.only(
          top: isTablet
              ? isPortrait
                  ? 0
                  : 0.02.h
              : 0.0.h,
          bottom: isTablet ? 0.01.h : 0.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 0.01.h,
                horizontal: isTablet
                    ? isPortrait
                        ? 0.02.h
                        : 0.04.h
                    : 0.04.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              border: Border.all(
                width: 0.001.h,
                color: MyThemeData.colorGrey,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Permission".tr,
                  style: customTextStyle,
                ),
                Text(
                  "Action".tr,
                  style: customTextStyle,
                ),
              ],
            ),
          ),
          // Table Rows
          Container(
            child: ListView.builder(
padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: tableData.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorLightGrey
                              : MyThemeData.colorLightGrey
                          : MyThemeData.colorWhite,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                            index == tableData.length - 1 ? 8.0 : 0),
                        bottomRight: Radius.circular(
                            index == tableData.length - 1 ? 8.0 : 0),
                      ),
                      border: Border.all(
                        width: 0.001.h,
                        color: MyThemeData.colorGrey,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.01.h,
                              horizontal: isTablet
                                  ? isPortrait
                                      ? 0.02.h
                                      : 0.04.h
                                  : 0.04.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  tableData[index]["Permission"]!.tr.capitalize
                                      as String,
                                  style: AppFontStyle.cairoRegularStyle
                                      .copyWith(
                                          fontSize: isTablet
                                              ? isPortrait
                                                  ? FontConstants.fontSize015.h
                                                  : FontConstants.fontSize022.h
                                              : FontConstants.fontSize018.h,
                                          color: themeController.currentTheme ==
                                                  MyThemeData.lightTheme
                                              ? MyThemeData.colorDarkGrey
                                              : MyThemeData.colorBlack,
                                          fontWeight: Get.locale
                                                  .toString()
                                                  .contains('en')
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          height: isTablet
                                              ? isPortrait
                                                  ? 1.8
                                                  : 0.002.h
                                              : 0.002.h),
                                ),
                              ),
                              SizedBox(
                                width: 0.029.h,
                              ),
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(
                                    Get.locale.toString().contains('en')
                                        ? 0
                                        : math.pi),
                                child: FlutterSwitch(
                                  width: isTablet
                                      ? (isPortrait ? 0.06.w : 0.037.w)
                                      : 0.11.w,
                                  height: isTablet
                                      ? (isPortrait ? 0.022.h : 0.04.h)
                                      : 0.05.h,
                                  value: widget.currentValues[index],
                                  padding: isPortrait ? 1 : 1.5,
                                  activeColor: MyThemeData.lightPrimary,
                                  onToggle: (newValue) {
                                    hapticController.triggerHapticFeedback(
                                        vibration: VibrateType.mediumImpact,
                                        hapticFeedback:
                                            HapticFeedback.mediumImpact);

                                    setState(() {
                                      // Toggle the boolean value at index 'index'

                                      widget.currentValues[index] =
                                          !widget.currentValues[index];
                                      if (widget.currentValues[index]) {
                                        widget.title == 'home'
                                            ? homePermission +=
                                                '${tableData[index]["Permission"]}, '
                                                    .toLowerCase()
                                            : widget.title == 'employee'
                                                ? employeePermission +=
                                                    '${tableData[index]["Permission"]}, '
                                                        .toLowerCase()
                                                : widget.title == 'chat'
                                                    ? chatPermission +=
                                                        '${tableData[index]["Permission"]}, '
                                                            .toLowerCase()
                                                    : widget.title == 'board'
                                                        ? boardPermission +=
                                                            '${tableData[index]["Permission"]}, '
                                                                .toLowerCase()
                                                        : widget.title ==
                                                                'check'
                                                            ? checkPermission +=
                                                                '${tableData[index]["Permission"]}, '
                                                                    .toLowerCase()
                                                            : widget.title ==
                                                                    'setting'
                                                                ? settingPermission +=
                                                                    '${tableData[index]["Permission"]}, '
                                                                        .toLowerCase()
                                                                : null;
                                      } else if (!widget.currentValues[index]) {
                                        widget.title == 'home'
                                            ? homePermission =
                                                homePermission.replaceAll(
                                                    '${tableData[index]["Permission"]}, '
                                                        .toLowerCase(),
                                                    "")
                                            : widget.title == 'employee'
                                                ? employeePermission =
                                                    employeePermission.replaceAll(
                                                        '${tableData[index]["Permission"]}, '
                                                            .toLowerCase(),
                                                        "")
                                                : widget.title == 'chat'
                                                    ? chatPermission =
                                                        chatPermission.replaceAll(
                                                            '${tableData[index]["Permission"]}, '
                                                                .toLowerCase(),
                                                            "")
                                                    : widget.title == 'board'
                                                        ? boardPermission =
                                                            boardPermission.replaceAll(
                                                                '${tableData[index]["Permission"]}, '
                                                                    .toLowerCase(),
                                                                "")
                                                        : widget.title ==
                                                                'check'
                                                            ? checkPermission =
                                                                checkPermission.replaceAll(
                                                                    '${tableData[index]["Permission"]}, '
                                                                        .toLowerCase(),
                                                                    "")
                                                            : widget.title ==
                                                                    'setting'
                                                                ? settingPermission =
                                                                    settingPermission.replaceAll(
                                                                        '${tableData[index]["Permission"]}, '.toLowerCase(), "")
                                                                : null;
                                      }
                                    });

                                    // Call the corresponding function
                                    widget.functionsList[index](
                                        widget.currentValues[index]);
                                  },
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     hapticController.triggerHapticFeedback(
                              //         vibration: VibrateType.mediumImpact,
                              //         hapticFeedback:
                              //             HapticFeedback.mediumImpact);

                              //     setState(() {
                              //       // Toggle the boolean value at index 'index'

                              //       widget.currentValues[index] =
                              //           !widget.currentValues[index];
                              //       if (widget.currentValues[index]) {
                              //         widget.title == 'home'
                              //             ? homePermission +=
                              //                 '${tableData[index]["Permission"]}, '
                              //                     .toLowerCase()
                              //             : widget.title == 'employee'
                              //                 ? employeePermission +=
                              //                     '${tableData[index]["Permission"]}, '
                              //                         .toLowerCase()
                              //                 : widget.title == 'chat'
                              //                     ? chatPermission +=
                              //                         '${tableData[index]["Permission"]}, '
                              //                             .toLowerCase()
                              //                     : widget.title == 'board'
                              //                         ? boardPermission +=
                              //                             '${tableData[index]["Permission"]}, '
                              //                                 .toLowerCase()
                              //                         : widget.title == 'check'
                              //                             ? checkPermission +=
                              //                                 '${tableData[index]["Permission"]}, '
                              //                                     .toLowerCase()
                              //                             : widget.title ==
                              //                                     'setting'
                              //                                 ? settingPermission +=
                              //                                     '${tableData[index]["Permission"]}, '
                              //                                         .toLowerCase()
                              //                                 : null;
                              //       } else if (!widget.currentValues[index]) {
                              //         widget.title == 'home'
                              //             ? homePermission =
                              //                 homePermission.replaceAll(
                              //                     '${tableData[index]["Permission"]}, '
                              //                         .toLowerCase(),
                              //                     "")
                              //             : widget.title == 'employee'
                              //                 ? employeePermission =
                              //                     employeePermission.replaceAll(
                              //                         '${tableData[index]["Permission"]}, '
                              //                             .toLowerCase(),
                              //                         "")
                              //                 : widget.title == 'chat'
                              //                     ? chatPermission =
                              //                         chatPermission.replaceAll(
                              //                             '${tableData[index]["Permission"]}, '
                              //                                 .toLowerCase(),
                              //                             "")
                              //                     : widget.title == 'board'
                              //                         ? boardPermission =
                              //                             boardPermission.replaceAll(
                              //                                 '${tableData[index]["Permission"]}, '
                              //                                     .toLowerCase(),
                              //                                 "")
                              //                         : widget.title == 'check'
                              //                             ? checkPermission =
                              //                                 checkPermission.replaceAll(
                              //                                     '${tableData[index]["Permission"]}, '
                              //                                         .toLowerCase(),
                              //                                     "")
                              //                             : widget.title ==
                              //                                     'setting'
                              //                                 ? settingPermission =
                              //                                     settingPermission.replaceAll(
                              //                                         '${tableData[index]["Permission"]}, '
                              //                                             .toLowerCase(),
                              //                                         "")
                              //                                 : null;
                              //       }
                              //     });

                              //     // Call the corresponding function
                              //     widget.functionsList[index](
                              //         widget.currentValues[index]);
                              //   },
                              //   child: Container(
                              //     height: isTablet ? null : 0.025.h,
                              //     child: SvgPicture.asset(
                              //       widget.currentValues[index]
                              //           ? 'assets/icons/NewSwitchOn.svg'
                              //           : themeController.currentTheme ==
                              //                   MyThemeData.lightTheme
                              //               ? 'assets/icons/NewSwitchOff.svg'
                              //               : 'assets/icons/NewSwitchOff.svg',
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        //        if (index != tableData.length - 1) Divider(color: MyThemeData.colorBlack),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
