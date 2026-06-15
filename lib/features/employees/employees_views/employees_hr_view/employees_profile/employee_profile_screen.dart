// ignore_for_file: must_be_immutable, unused_local_variable, prefer_const_constructors_in_immutables, unrelated_type_equality_checks, avoid_print, non_constant_identifier_names,, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/custom_employee_profile.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/custom_text_widgets.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/theme_controller.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/employee_attendance_screen.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/employee_performance_screen.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/employee_permissions_screen.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/employee_personal_info_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'package:demo_app/features/roles/domain/enums/modules_enum.dart';

/// Date Created :3/Dec/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :14/Dec/2023
/// Objectives: this screen is responsible for showing the each employee profile, and in this screen, the hr can view his
/// personal info, performance, attendance rate, and the permissions
///
///

class employeeProfile extends StatefulWidget {
  final int? index;
  final String firstName;
  final String lastName;
  final String profession;
  final String phoneNumber;

  employeeProfile({
    this.index,
    required this.firstName,
    required this.lastName,
    required this.profession,
    required this.phoneNumber,
    Key? key,
  }) : super(key: key);

  @override
  employeeProfileState createState() => employeeProfileState();
}

class employeeProfileState extends State<employeeProfile> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  int selectedContainerIndexEmployee = 0;
  @override
  void initState() {
    selectedContainerIndexEmployee = widget.index ?? 0;
    super.initState();
  }

  void setSelectedContainerIndexEmployee(int index) {
    setState(() {
      selectedContainerIndexEmployee = index;
    });
  }

  bool notificationEnabled = false;
  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final orientation = MediaQuery.of(context).orientation;

    // Check if the screen width is greater than 600 (tablet)
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    // Conditionally render the widget tree based on whether it's a tablet or not
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Row(
          children: [
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: CustomDrawer(
            //     selectedIndex: 3,
            //   ),
            // ),
            Expanded(
              child: Container(
                child: _buildTabletLayout(orientation, themeController),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(
      Orientation orientation, ThemeController themeController) {
    final HapticController hapticController = Get.put(HapticController());
    return Column(
      children: [
        CustomAppBar(),
        SizedBox(height: 0.02.h),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 0.0.h), //0.14.h
                  //scroll was here
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Get.locale.toString().contains('en') ? 0.02.h : 0,
                      right: Get.locale.toString().contains('ar') ? 0.02.h : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Column(
                              children: [
                                Container(
                                  height: 0.83.h,
                                  padding:
                                      EdgeInsets.symmetric(vertical: 0.02.h),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.02.h),
                                        child: CustomProfileWidget(
                                          firstName: widget.firstName,
                                          lastName: widget.lastName,
                                          profession: widget.profession,
                                          mobileNumber: widget.phoneNumber,
                                          reviewRating: 4.6,
                                        ),
                                      ),
                                      SizedBox(height: 0.04.h),
                                      CustomTextWidget(
                                        text: 'Personal Information',
                                        index: 0,
                                        selectedIndex:
                                            selectedContainerIndexEmployee,
                                      ),
                                      SizedBox(height: 0.01.h),
                                      CustomTextWidget(
                                        text: 'Performance',
                                        index: 1,
                                        selectedIndex:
                                            selectedContainerIndexEmployee,
                                      ),
                                      SizedBox(height: 0.01.h),
                                      CustomTextWidget(
                                        text: 'Attendance',
                                        index: 2,
                                        selectedIndex:
                                            selectedContainerIndexEmployee,
                                      ),
                                      SizedBox(height: 0.01.h),
                                      CustomTextWidget(
                                        text: 'Permissions',
                                        index: 3,
                                        selectedIndex:
                                            selectedContainerIndexEmployee,
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            // horizontal: Get.locale.toString().contains('en') ? 0.145.h : 0.135.h,
                                            vertical: 0.03.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MainCustomIconButton(
                                              onPressed: () {
                                                hapticController
                                                    .triggerHapticFeedback(
                                                        vibration: VibrateType
                                                            .mediumImpact,
                                                        hapticFeedback:
                                                            HapticFeedback
                                                                .mediumImpact);
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child:
                                                         Modules.messages.widget,
                                                  ),
                                                );
                                              },
                                              buttonText: "Chat".tr,
                              
                                              widgetIcon:
                                                  "assets/icons/chatDots.svg",
                                              buttonStyle:
                                                  ElevatedButton.styleFrom(
                                                minimumSize:
                                                    Size(0.02.w, 0.055.h),
                                                backgroundColor:
                                                    MyThemeData.signOut,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                  Radius.circular(8),
                                                )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
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
                ),
              ),
              SizedBox(
                width: orientation == Orientation.portrait ? 0.02.w : 0.02.w,
              ),
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(
                        right:
                            Get.locale.toString().contains('en') ? 0.02.h : 0,
                        left:
                            Get.locale.toString().contains('ar') ? (0.02.h) : 0,
                        bottom: 0.0.h),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: Get.locale.toString().contains('en')
                                ? 0.83.h
                                : 0.83.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 0.01.h,
                                right: 0.02.w,
                                left: 0.02.w,
                                bottom: 0.03.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (selectedContainerIndexEmployee == 0)
                                    PersonalInfoScreen(),
                                  if (selectedContainerIndexEmployee == 1)
                                    PerformanceScreen(),
                                  if (selectedContainerIndexEmployee == 2)
                                    AttendanceScreen(),
                                  if (selectedContainerIndexEmployee == 3)
                                    PermissionsScreen(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void onDeleteAcc() async {}
Future onSignOutConfirmed() async {}
