import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/custom_expandable_container.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/custom_permissions_header.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/screen_size.dart';

import '../permissions/board.dart';
import '../permissions/employee.dart';
import '../permissions/permissions_widgets.dart' hide boardWidget, employeeDataWidget;
import '../permissions/requested.dart';


/// Date Created :6/Dec/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :14/Dec/2023
/// Objectives: this screen is responsible for showing permissions of each employee, this option only the hr and owner get to use it, he can enable and disable
/// anything the employee, can do , or view and etc.
///  
/// 

class PermissionsScreen extends StatefulWidget {
  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool home = false;
  bool employeesData = false;
  bool employeesCharts = false;
  bool board = false;
  bool boardView = false;
  bool boardTask = false;
  bool chat = false;
  bool meeting = false;
  bool request = false;
  bool setting = false;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final HapticController hapticController = Get.put(HapticController());
    return Padding(
      padding: EdgeInsets.only(top: 0.03.h),
      child: Column(
        children: [
          // Tabs Widget
              PermissionsHeader(
                selectedIndex: selectedIndex,
                selectedIndexState: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
          Padding(
            padding:   EdgeInsets.only(top: 0.02.h),
            child: Container(
               height: 0.68.h,
               
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                     
                    // Home Section
                    if (selectedIndex == 0)
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.03.h),
                            child: GestureDetector(
                              onTap: () {
                                hapticController.triggerHapticFeedback(
                                    vibration: VibrateType.lightImpact,
                                    hapticFeedback: HapticFeedback.lightImpact);
                                setState(() {
                                  home = !home;
                                });
                              },
                              child: ExpandableContainer(
                                expanded: home,
                                title: 'Home Page',
                              ),
                            ),
                          ),
                          if (home == true)
                            SizedBox(
                              height: 0.02.h,
                            ),
                          if (home == true)
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                                child: homePageWidget),
                        ],
                      ),
                    // Employees Section
                    if (selectedIndex == 1)
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.03.h),
                            child: GestureDetector(
                              onTap: () {
                                  hapticController.triggerHapticFeedback(
                                    vibration: VibrateType.lightImpact,
                                    hapticFeedback: HapticFeedback.lightImpact);
                                setState(() {
                                  employeesData = !employeesData;
                                });
                              },
                              child: ExpandableContainer(
                                expanded: employeesData,
                                title: 'Employees Data',
                              ),
                            ),
                          ),
                          if (employeesData == true)
                            SizedBox(
                              height: 0.02.h,
                            ),
                          if (employeesData == true)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                              child: employeeDataWidget,
                            ),
                          Padding(
                            padding: EdgeInsets.only(top: 0.03.h),
                            child: GestureDetector(
                              onTap: () {
                                  hapticController.triggerHapticFeedback(
                                    vibration: VibrateType.lightImpact,
                                    hapticFeedback: HapticFeedback.lightImpact);
                                setState(() {
                                  employeesCharts = !employeesCharts;
                                });
                              },
                              child: ExpandableContainer(
                                expanded: employeesCharts,
                                title: 'Employees Charts',
                              ),
                            ),
                          ),
                          if (employeesCharts == true)
                            SizedBox(
                              height: 0.02.h,
                            ),
                          if (employeesCharts == true)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                              child: employeeChartsWidget,
                            ),
                        ],
                      ),
                    // Task Section
                    if (selectedIndex == 2)
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.03.h),
                            child: GestureDetector(
                              onTap: () {
                                  hapticController.triggerHapticFeedback(
                                    vibration: VibrateType.lightImpact,
                                    hapticFeedback: HapticFeedback.lightImpact);
                                setState(() {
                                  board = !board;
                                });
                              },
                              child: ExpandableContainer(
                                expanded: board,
                                title: 'Board',
                              ),
                            ),
                          ),
                          if (board == true)
                            SizedBox(
                              height: 0.02.h,
                            ),
                          if (board == true)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                              child: boardWidget,
                            ),
                          Padding(
                            padding: EdgeInsets.only(top: 0.03.h),
                            child: GestureDetector(
                              onTap: () {
                                  hapticController.triggerHapticFeedback(
                                    vibration: VibrateType.lightImpact,
                                    hapticFeedback: HapticFeedback.lightImpact);
                                setState(() {
                                  boardView = !boardView;
                                });
                              },
                              child: ExpandableContainer(
                                expanded: boardView,
                                title: 'Board View',
                              ),
                            ),
                          ),
                          if (boardView == true)
                            SizedBox(
                              height: 0.02.h,
                            ),
                          if (boardView == true)
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                                child: boardViewWidget),
                          Padding(
                            padding: EdgeInsets.only(top: 0.03.h),
                            child: GestureDetector(
                              onTap: () {
                                  hapticController.triggerHapticFeedback(
                                    vibration: VibrateType.lightImpact,
                                    hapticFeedback: HapticFeedback.lightImpact);
                                setState(() {
                                  boardTask = !boardTask;
                                });
                              },
                              child: ExpandableContainer(
                                expanded: boardTask,
                                title: 'Board Task',
                              ),
                            ),
                          ),
                          if (boardTask == true)
                            SizedBox(
                              height: 0.02.h,
                            ),
                          if (boardTask == true)
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                                child: taskWidget),
                        ],
                      ),
                    // Chat Section
                    if (selectedIndex == 3)
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.03.h),
                            child: GestureDetector(
                              onTap: () {
                                  hapticController.triggerHapticFeedback(
                                    vibration: VibrateType.lightImpact,
                                    hapticFeedback: HapticFeedback.lightImpact);
                                setState(() {
                                  chat = !chat;
                                });
                              },
                              child: ExpandableContainer(
                                expanded: chat,
                                title: 'Chat Page',
                              ),
                            ),
                          ),
                          if (chat == true)
                            SizedBox(
                              height: 0.02.h,
                            ),
                          if (chat == true)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                              child: chatWidget,
                            ),
                        ],
                      ),
                    // Meeting Section
                    if (selectedIndex == 4)
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.03.h),
                            child: GestureDetector(
                              onTap: () {
                                  hapticController.triggerHapticFeedback(
                                    vibration: VibrateType.lightImpact,
                                    hapticFeedback: HapticFeedback.lightImpact);
                                setState(() {
                                  meeting = !meeting;
                                });
                              },
                              child: ExpandableContainer(
                                expanded: meeting,
                                title: 'Meeting',
                              ),
                            ),
                          ),
                          if (meeting == true)
                            SizedBox(
                              height: 0.02.h,
                            ),
                          if (meeting == true)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                              child: meetingWidget,
                            ),
                        ],
                      ),
                    // Request Section
                    if (selectedIndex == 5)
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.03.h),
                            child: GestureDetector(
                              onTap: () {
                                  hapticController.triggerHapticFeedback(
                                    vibration: VibrateType.lightImpact,
                                    hapticFeedback: HapticFeedback.lightImpact);
                                setState(() {
                                  request = !request;
                                });
                              },
                              child: ExpandableContainer(
                                expanded: request,
                                title: 'Requested Page',
                              ),
                            ),
                          ),
                          if (request == true)
                            SizedBox(
                              height: 0.02.h,
                            ),
                          if (request == true)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                              child: requestedWidget,
                            ),
                        ],
                      ),
                    // Setting Section
                    if (selectedIndex == 6)
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.03.h),
                            child: GestureDetector(
                              onTap: () {
                                  hapticController.triggerHapticFeedback(
                                    vibration: VibrateType.lightImpact,
                                    hapticFeedback: HapticFeedback.lightImpact);
                                setState(() {
                                  setting = !setting;
                                });
                              },
                              child: ExpandableContainer(
                                expanded: setting,
                                title: 'Setting Page',
                              ),
                            ),
                          ),
                          if (setting == true)
                            SizedBox(
                              height: 0.02.h,
                            ),
                          if (setting == true)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                              child: settingWidget,
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
