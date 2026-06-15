import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/custom_expandable_container.dart';
import 'package:demo_app/features/employees/employees_views/employees_hr_view/employees_profile/custom_performance_chart.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/screen_size.dart';

/// Date Created :4/Dec/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :14/Dec/2023
/// Objectives: this screen is responsible for showing the 3 things about each employee,
///  the first thing is to show his project performance, and his meeting performance and his attendance as well in a chart form

class PerformanceScreen extends StatefulWidget {
  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  bool performance = false;
  bool meeting = false;
  bool attendance = false;
  @override
  Widget build(BuildContext context) {
    final HapticController hapticController = Get.put(HapticController());
    return Padding(
      padding: EdgeInsets.only(top: 0.03.h),
      child: Container(
        height: 0.75.h,
 
      
      child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.lightImpact,
                      hapticFeedback: HapticFeedback.lightImpact);
                  setState(() {
                    performance = !performance;
                  });
                },
                child: ExpandableContainer(
                  expanded: performance,
                  title: 'Project Performance',
                ),
              ),
              if (performance == true)
                SizedBox(
                  height: 0.02.h,
                ),
              if (performance == true)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                  child: Container(
                    //    color: Colors.amber,
                    width: double.infinity,
                    //    height: 0.25.h,
                    child: CustomPerformanceChart(
                      isPerformanceScreen: true,
                      isTransparent: true,
                      width: double.infinity,
                      // height: 0.248,
                      textSizeTexts: 0.023,
                      textSizeValues: 0.021,
                      title: '',
                      texts: [
                        'To Do'.tr,
                        'Doing'.tr,
                        'Done'.tr,
                      ],
                      values: ['50', '30', '30'],
                    ),
                  ),
                ),
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
                  child: Container(
                    //    color: Colors.amber,
                    width: double.infinity,
                    //   height: 0.25.h,
                    child: CustomPerformanceChart(
                      isPerformanceScreen: true,
                      isTransparent: true,
                      width: double.infinity,
                      // height: 0.248,
                      textSizeTexts: 0.023,
                      textSizeValues: 0.021,
                      title: '',
                      texts: [
                        'Attendance'.tr,
                        'Absence'.tr,
                      ],
                      values: ['50', '30'],
                    ),
                  ),
                ),
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
                  padding: EdgeInsets.symmetric(horizontal: 0.02.h),
                  child: Container(
                    //   color: Colors.amber,
                    width: double.infinity,
                    //  height: 0.27.h,
                    child: CustomPerformanceChart(
                      isPerformanceScreen: true,
                      isTransparent: true,
                      width: double.infinity,
                      // height: 0.248,
                      textSizeTexts: 0.023,
                      textSizeValues: 0.021,
                      title: '',
                      texts: [
                        'Attendance'.tr,
                        'Excused Absence'.tr,
                        'Unexcused Absence'.tr,
                      ],
                      values: ['50', '30', '30'],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
