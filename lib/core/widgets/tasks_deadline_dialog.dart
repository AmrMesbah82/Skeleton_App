import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/components/calendar_components.dart/calender_package/calendar_date_picker2.dart';
import 'package:demo_app/components/calendar_components.dart/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/components/calendar_components.dart/custom_calendar_picker.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';

import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class TasksDeadLineDialogue extends StatefulWidget {
  const TasksDeadLineDialogue({super.key});

  @override
  State<TasksDeadLineDialogue> createState() => _TasksDeadLineDialogueState();
}

class _TasksDeadLineDialogueState extends State<TasksDeadLineDialogue> {
  String hintStartDate = "DD/MM/YYYY";
  String hintStartStime = "00:00";
  String hintendDate = "DD/MM/YYYY";
  String hintendStime = "00:00";
  bool startDateSelected = true;
  bool endDateSelected = false;
  List<DateTime?> selectedDate = [];
  final HapticController hapticController = Get.put(HapticController());
  ButtonStyle buttonStyle(Color color, bool borded) {
    return ElevatedButton.styleFrom(
      minimumSize: Size(0.1.w, 0.05.h),
      backgroundColor: color,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: borded
                  ? Theme.of(context).colorScheme.scrim
                  : Colors.transparent,
              width: 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(6),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0.14.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        height: 0.56.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.015.w, vertical: 0.015.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const FiltersAppBar(
                  imageUrl: "assets/images/deadline.svg",
                  title: "Task Deadline"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 0.015.h),
                    child: Container(
                        width: 0.25.w,
                        height: 0.35.h,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: CustomCalendarPicker(
                          calendarType: CalendarDatePicker2Type.range,
                          selectedDate: selectedDate,
                          selectedDateState: (value) {
                            setState(() {
                              selectedDate = value;
                              hintStartDate =
                                  "${selectedDate[0]!.day}/${selectedDate[0]!.month}/${selectedDate[0]!.year}";
                              if (selectedDate[0]!.day !=
                                  selectedDate.last!.day) {
                                endDateSelected = true;
                                hintendDate =
                                    "${selectedDate.last!.day}/${selectedDate.last!.month}/${selectedDate.last!.year}";
                              } else {
                                endDateSelected = false;
                                hintendDate = "DD/MM//YYYY";
                              }
                            });
                          },
                        )),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            MainCustomIconButton(
                              onPressed: () {
                                setState(() {
                                  startDateSelected = !startDateSelected;
                                });
                              },
                              buttonText: "Start Date".tr,
                              widgetIcon: "assets/icons/newCalenderFixed.svg",
                            
                              buttonStyle: buttonStyle(
                                  startDateSelected
                                      ? MyThemeData.lightPrimary
                                      : Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                  startDateSelected ? false : true),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: Get.locale.toString().contains('en')
                                      ? 0.01.w
                                      : 0,
                                  right: Get.locale.toString().contains('en')
                                      ? 0
                                      : 0.01.w),
                              child: MainCustomIconButton(
                                onPressed: () {
                                  setState(() {
                                    endDateSelected = !endDateSelected;
                                    selectedDate.removeRange(
                                        1,
                                        selectedDate
                                                .indexOf(selectedDate.last) +
                                            1);
                                    hintendDate = "DD/MM/YYYY";
                                  });
                                },
                                buttonText: "End Date".tr,
                                
                                widgetIcon: "assets/icons/newCalenderFixed.svg",
                              
                                buttonStyle: buttonStyle(
                                    endDateSelected
                                        ? MyThemeData.lightPrimary
                                        : Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                    endDateSelected ? false : true),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.02.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ColumnRequestData(
                              title: "Start Date",
                              isTextField: true,
                              hint: hintStartDate,
                              isOptional: false,
                              isExpanded: false,
                              hasSuffix: true,
                              suffixUrl: "assets/icons/newCalenderFixed.svg",
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 0.062.h,
                                  left: Get.locale.toString().contains('en')
                                      ? 0.02.w
                                      : 0,
                                  right: Get.locale.toString().contains('en')
                                      ? 0
                                      : 0.02.w),
                              child: ColumnRequestData(
                                title: "Time",
                                isTextField: true,
                                hideTitle: true,
                                hint: hintendStime,
                                isOptional: false,
                                isExpanded: false,
                                hasSuffix: true,
                                suffixUrl: "assets/images/circle_icon.svg",
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ColorFiltered(
                            colorFilter: endDateSelected
                                ? const ColorFilter.mode(
                                    Colors.transparent, BlendMode.color)
                                : const ColorFilter.linearToSrgbGamma(),
                            child: ColumnRequestData(
                              title: "End Date",
                              isTextField: true,
                              hint: hintendDate,
                              isOptional: false,
                              isExpanded: false,
                              hasSuffix: true,
                              suffixUrl: "assets/icons/newCalenderFixed.svg",
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0.062.h,
                                left: Get.locale.toString().contains('en')
                                    ? 0.02.w
                                    : 0,
                                right: Get.locale.toString().contains('en')
                                    ? 0
                                    : 0.02.w),
                            child: ColorFiltered(
                              colorFilter: endDateSelected
                                  ? const ColorFilter.mode(
                                      Colors.transparent, BlendMode.color)
                                  : const ColorFilter.linearToSrgbGamma(),
                              child: ColumnRequestData(
                                title: "Time",
                                isTextField: true,
                                hideTitle: true,
                                hint: hintendStime,
                                isOptional: false,
                                isExpanded: false,
                                hasSuffix: true,
                                suffixUrl: "assets/images/circle_icon.svg",
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.015.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MainCustomIconButton(
                      onPressed: () {
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.heavyImpact,
                            hapticFeedback: HapticFeedback.heavyImpact);
                        Navigator.pop(context);
                      },
                      buttonText: "Add".tr,
                      buttonStyle: ElevatedButton.styleFrom(
                        minimumSize: Size(0.09.w, 0.05.h),
                        backgroundColor: MyThemeData.signOut,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
