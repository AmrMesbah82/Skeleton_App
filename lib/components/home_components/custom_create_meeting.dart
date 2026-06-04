import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/components/calendar_components.dart/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/components/calendar_components.dart/date_picker_class.dart';
import 'package:demo_app/core/widgets/cupertino_time_picker.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/core/widgets/dialogs/dialogue_switchers_row.dart';

import 'package:demo_app/components/home_components/custom_create_task_container.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_button.dart';
import 'package:demo_app/components/meetings_components/timeline_widget.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';

/// Date Created :14/November/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :19/November/2023 By Bassem
/// Objectives: this widget is for showing the meeting or task name, description and start time for each one in addition to images of the participants and the total number of the members enrolled in this event

class CustomCreateMeetingContainer extends StatefulWidget {
  const CustomCreateMeetingContainer({
    super.key,
    this.isEdit = false,
  });
  final bool isEdit;

  @override
  State<CustomCreateMeetingContainer> createState() =>
      _CustomCreateMeetingContainerState();
}

final List<String> notify = [
  '10 Minutes Before'.tr,
  '30 Minutes Before'.tr,
  '1 Hour Before'.tr,
];

String? selectedNotify = '10 Minutes Before'.tr;

class _CustomCreateMeetingContainerState
    extends State<CustomCreateMeetingContainer> {
  DateTime? selectedDate;
  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [];
  Future<void> _selectDate(BuildContext context) async {
    final List<DateTime?>? picked = await DatePicker().showDatePicker(
        context,
        _rangeDatePickerValueWithDefaultValue,
        DateTime.now(),
        CalendarDatePicker2Type.single);
    // change the selected the  with the picked date
    // ignore: unrelated_type_equality_checks
    if (picked != null && picked != selectedDate) {
      setState(() {
        _rangeDatePickerValueWithDefaultValue = picked;
        selectedDate = picked[
            0]; // get the first element in the array which is the selected date
        // final DateFormat formatter = DateFormat('dd/MM/yyyy');
        // String formattedDate = formatter.format(picked[0] as DateTime);
        // String formattedDate2 = formatter.format(picked.last as DateTime);
        hintDate =
            "${picked[0]!.day} ${DateFormat.MMM().format(picked[0]!)} ${picked[0]!.year}";
        // widget.dateValueState(widget.dateValue);
      });
    }
  }

  String hintDate = "DD/MM/YYYY";
  bool switchValue3 = false;
  String? repeatValue;
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 0.02.h, horizontal: 0.025.w),
          decoration: BoxDecoration(
            // ignore: unrelated_type_equality_checks
            color: isTablet
                ? themeController.currentTheme == MyThemeData.lightTheme
                    ? MyThemeData.colorLightGrey
                    : MyThemeData.darkBackGround
                : Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset("assets/images/imagePickerPhoto.svg"),
              SizedBox(
                height: height,
              ),
              ColumnRequestData(
                fillColor: Colors.transparent,
                title: "Meeting Name",
                isTextField: true,
                hint: "Text here",
                isOptional: false,
                isExpanded: true,
                hasPrefix: true,
                // textController: widget.isGroupEdit == true
                //     ? null
                //     : desciption,

                controllerState: (value) {
                  setState(() {
                    print('value description ${value!}');
                  });
                },
                maxlength: 120,
              ),
              SizedBox(
                height: height,
              ),
              ColumnRequestData(
                title: "Meeting Description",
                isTextField: true,
                hint: "Text here".tr,
                isOptional: false,
                isExpanded: true,
              isDescription: true,
                // textController: widget.isGroupEdit == true
                //     ? null
                //     : desciption,
                maxlines: 2,

                controllerState: (value) {
                  setState(() {
                    print('value description ${value!}');
                  });
                },
                maxlength: 120,
              ),
              SizedBox(
                height: height,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: ColumnRequestData(
                        fillColor: Colors.transparent,
                        title: "Date",
                        isTextField: true,
                        hint: hintDate,
                        enabled: false,
                        isOptional: false,
                        isExpanded: true,
                        hasPrefix: true,
                        hasSuffix: true,
                        suffixUrl: "assets/icons/newCalenderFixed.svg",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.04.w,
                  ),
                  Expanded(
                      child: ColumnRequestData(
                    fillColor: Colors.transparent,
                    title: "Repeat",
                    dropWidth: 0.41.w,
                    isTextField: false,
                    hint: "Weekly".tr,
                    isOptional: false,
                    isExpanded: true,
                    hasSuffix: true,
                    dropDownItems: ['Weekly'.tr, 'Monthly'.tr],
                    dropdownValue: repeatValue,
                    dropDownValueState: (value) {
                      setState(() {
                        repeatValue = value;
                      });
                    },
                  )),
                ],
              ),
              SizedBox(
                height: height,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoTimePicker(
                              onDateTimeChanged: (DateTime newDateTime) {
                                setState(() {
                                  // selectedTime1 = TimeOfDay.fromDateTime(newDateTime);
                                });
                              },
                            );
                          },
                        );
                        // showModalBottomSheet(
                        //   context: context,
                        //   builder: (BuildContext builder) {
                        //     return SizedBox(
                        //       height: MediaQuery.of(context)
                        //               .copyWith()
                        //               .size
                        //               .height /
                        //           3,
                        //       child: CupertinoDatePicker(
                        //         mode: CupertinoDatePickerMode.time,
                        //         initialDateTime: DateTime.now(),
                        //         onDateTimeChanged: (DateTime newDateTime) {
                        //           setState(() {
                        //             // selectedTime1 = TimeOfDay.fromDateTime(newDateTime);
                        //           });
                        //         },
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                      child: ColumnRequestData(
                        fillColor: Colors.transparent,
                        title: "Start Time",
                        isTextField: true,
                        hint: "Text here",
                        enabled: false,
                        isOptional: false,
                        isExpanded: true,
                        hasSuffix: true,
                        suffixUrl: "assets/icons/newTimeIconFixed.svg",
                        // textController: widget.isGroupEdit == true
                        //     ? null
                        //     : desciption,

                        controllerState: (value) {
                          setState(() {
                            print('value description ${value!}');
                          });
                        },
                        maxlength: 120,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.04.w,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                         showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoTimePicker(
                              onDateTimeChanged: (DateTime newDateTime) {
                                setState(() {
                                  // selectedTime1 = TimeOfDay.fromDateTime(newDateTime);
                                });
                              },
                            );
                          },
                        );
                        // showModalBottomSheet(
                        //   context: context,
                        //   builder: (BuildContext builder) {
                        //     return SizedBox(
                        //       height: MediaQuery.of(context)
                        //               .copyWith()
                        //               .size
                        //               .height /
                        //           3,
                        //       child: CupertinoDatePicker(
                        //         mode: CupertinoDatePickerMode.time,
                        //         initialDateTime: DateTime.now(),
                        //         onDateTimeChanged: (DateTime newDateTime) {
                        //           setState(() {
                        //             // selectedTime1 = TimeOfDay.fromDateTime(newDateTime);
                        //           });
                        //         },
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                      child: ColumnRequestData(
                        fillColor: Colors.transparent,
                        title: "End Time",
                        enabled: false,
                        isTextField: true,
                        hint: "Text here",
                        isOptional: false,
                        isExpanded: true,
                        hasSuffix: true,
                        suffixUrl: "assets/icons/newTimeIconFixed.svg",
                        hasPrefix: true,
                        // textController: widget.isGroupEdit == true
                        //     ? null
                        //     : desciption,

                        controllerState: (value) {
                          setState(() {
                            print('value description ${value!}');
                          });
                        },
                        maxlength: 120,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height,
              ),
              Text(
                "Notify Me".tr,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: isTablet
                        ? FontConstants.fontSize022.h
                        : FontConstants.fontSize018.h,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inverseSurface,
                    height: 1.6),
              ),
              CustomDropdownButton2(
                buttonPadding: EdgeInsets.symmetric(horizontal: 0.02.w),
                iconHeight: 0.022.h,
                buttonWidth: double.infinity,
                dropdownWidth: 0.865.w,
                buttonHeight: 0.045.h,
                dropdownHeight: 0.15.h,
                isBottomSheet: true,
                hint: 'Select'.tr,
                dropdownItems: notify,
                value: selectedNotify,
                onChanged: (String? value) {
                  setState(() {
                    selectedNotify = value;
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.02.h),
          child: MainCustomButton(
            buttonText: widget.isEdit ? 'Edit Meeting'.tr : 'Create'.tr,
            onPressed: () {
              hapticController.triggerHapticFeedback(
                vibration: VibrateType.mediumImpact,
                hapticFeedback: HapticFeedback.mediumImpact,
              );
            },
          ),
        ),
      ],
    );
  }
}
