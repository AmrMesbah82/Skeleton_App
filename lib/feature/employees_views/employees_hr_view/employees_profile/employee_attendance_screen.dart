import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/components/employees_components/employees_components_subwidgets.dart/employee_table.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employee_hr_profile_components/custom_expandable_container.dart';
import 'package:demo_app/components/tracking_time_components/filter_dialog.dart';
import 'package:demo_app/components/tracking_time_components/track_time_subwidget/table.dart';
import 'package:demo_app/components/tracking_time_components/track_time_subwidget/table_app_bar.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/screen_size.dart';

/// Date Created :5/Dec/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :14/Dec/2023
/// Objectives: this screen is responsible for the working days of the employee, and also his attendance throughout a certain period of time

class AttendanceScreen extends StatefulWidget {
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool workingDays = false;
  bool attendance = false;
  int selectedIndex = 0;
  bool isFilterDataShow = false;
  String? status;
  String? status2;
  String dateValue = "Date";
  String dateValue2 = "Date";
  @override
  Widget build(BuildContext context) {
    final HapticController hapticController = Get.put(HapticController());
    return Padding(
      padding: EdgeInsets.only(top: 0.03.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TableContainerAppBar(
            selectedIndex: selectedIndex,
            title1: "Attendance".tr,
            title2: "Working Days".tr,
            isEmployeeProfile: true,
            selectedIndexState: (value) {
              setState(() {
                selectedIndex = value;
                isFilterDataShow = selectedIndex == 1 && isFilterDataShow
                    ? (status2 == null && dateValue2 == "Date")
                        ? false
                        : true
                    : isFilterDataShow
                        ? (status == null && dateValue == "Date")
                            ? false
                            : true
                        : (status == null && dateValue == "Date")
                            ? false
                            : true;
              });
            },
          ),
          if (selectedIndex == 0)
            Padding(
              padding: EdgeInsets.only(top: 0.0.h),
              child: Container(
                height: 0.71.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.03.h),
                        child: GestureDetector(
                          onTap: () {
                            hapticController.triggerHapticFeedback(
                                vibration: VibrateType.lightImpact,
                                hapticFeedback: HapticFeedback.lightImpact);
                            setState(() {
                              attendance = !attendance;
                            });
                          },
                          child: ExpandableContainer(
                            expanded: attendance,
                            title: 'Attendance',
                          ),
                        ),
                      ),
                      if (attendance == true)
                        SizedBox(
                          height: 0.02.h,
                        ),
                      if (attendance == true)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0..h),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: 0.015.h),
                                child: Transform.scale(
                                  scale: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          hapticController
                                              .triggerHapticFeedback(
                                                  vibration:
                                                      VibrateType.lightImpact,
                                                  hapticFeedback: HapticFeedback
                                                      .lightImpact);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return FilterDialog(
                                                statusValue: status,
                                                dropDownItems: const [
                                                  'Attendance',
                                                  'Absent',
                                                  'Late'
                                                ],
                                                statusState: (value) {
                                                  setState(() {
                                                    status = value;

                                                    status == null
                                                        ? dateValue == "Date"
                                                            ? isFilterDataShow =
                                                                false
                                                            : isFilterDataShow =
                                                                true
                                                        : isFilterDataShow =
                                                            true;
                                                  });
                                                },
                                                dateValue: dateValue,
                                                dateValueState: (value) {
                                                  setState(() {
                                                    dateValue = value;
                                                    dateValue == "Date"
                                                        ? status == null
                                                            ? isFilterDataShow =
                                                                false
                                                            : isFilterDataShow =
                                                                true
                                                        : isFilterDataShow =
                                                            true;
                                                  });
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 0.055.h,
                                          width: 0.1.w,
                                          decoration: BoxDecoration(
                                              color: isFilterDataShow
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondaryContainer
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .scrim,
                                              )),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SvgPicture.asset(
                                                  "assets/images/filter_table.svg",
                                                  // ignore: deprecated_member_use
                                                  color: isFilterDataShow
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .scrim),
                                              Text(
                                                "Filter".tr,
                                                style: AppFontStyle
                                                    .cairoRegularStyle
                                                    .copyWith(
                                                        fontSize: FontConstants
                                                            .fontSize024.h,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0.0018.h,
                                                        color: isFilterDataShow
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .onPrimary
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .scrim),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 0.5.h,
                                  child: TableData(
                                    isEmployeeScreen: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //put your logic here for the Attendance
                        ),
                    ],
                  ),
                ),
              ),
            ),
          if (selectedIndex == 1)
            Container(
              height: 0.71.h,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.03.h),
                      child: GestureDetector(
                        onTap: () {
                          hapticController.triggerHapticFeedback(
                              vibration: VibrateType.lightImpact,
                              hapticFeedback: HapticFeedback.lightImpact);
                          setState(() {
                            workingDays = !workingDays;
                          });
                        },
                        child: ExpandableContainer(
                          expanded: workingDays,
                          title: 'Working Days',
                        ),
                      ),
                    ),
                    if (workingDays == true)
                      SizedBox(
                        height: 0.02.h,
                      ),
                    if (workingDays == true)
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                          child: Container(
                            width: double.infinity,
                            height: 0.65.h,
                            child: const EmployeeTableData(
                              isEmployeeScreen: true,
                            ),
                          )
                          //put your logic here for the Working Days
                          ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
