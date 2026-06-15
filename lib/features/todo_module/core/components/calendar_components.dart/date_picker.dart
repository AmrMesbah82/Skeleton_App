// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, unnecessary_string_interpolations, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/todo_module/core/constants/screen_size.dart';
import 'package:demo_app/core/theme/my_theme.dart';

class DualIOSStyleTimePicker extends StatefulWidget {
  @override
  _DualIOSStyleTimePickerState createState() => _DualIOSStyleTimePickerState();
}

class _DualIOSStyleTimePickerState extends State<DualIOSStyleTimePicker> {
  TimeOfDay selectedTime1 = TimeOfDay.now();
  List<TimeOfDay> selectedTimes = [
    TimeOfDay.now()
  ]; // List to store selected times
  bool showSecondRow =
      false; // State variable to track the visibility of the second row

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              'assets/icons/clock.png',
              width: 0.064.w,
              height: 0.044.h,
            ),
            SizedBox(width: 0.015.w),
            Container(
              width: 0.38.w,
              height: 0.039.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Theme.of(context).colorScheme.onInverseSurface),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return SizedBox(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    3,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: DateTime.now(),
                              onDateTimeChanged: (DateTime newDateTime) {
                                setState(() {
                                  selectedTime1 =
                                      TimeOfDay.fromDateTime(newDateTime);
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${selectedTime1.format(context)}",
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: FontConstants.fontSize016.h,
                            color:
                                Theme.of(context).colorScheme.onInverseSurface,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.004.h),
                    child: VerticalDivider(
                      thickness: 0.001.h,
                      width: 0.001.w,
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext builder) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onInverseSurface),
                              ),
                              height: MediaQuery.of(context)
                                      .copyWith()
                                      .size
                                      .height /
                                  3,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                initialDateTime: DateTime.now(),
                                onDateTimeChanged: (DateTime newDateTime) {
                                  setState(() {
                                    selectedTimes[0] =
                                        TimeOfDay.fromDateTime(newDateTime);
                                  });
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${selectedTimes[0].format(context)}",
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: FontConstants.fontSize016.h,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 0.01.w),
            GestureDetector(
              onTap: () {
                if (selectedTimes.length < 4) {
                  setState(() {
                    selectedTimes.add(
                        TimeOfDay.now()); // Add new selected time to the list
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Limit Reached'),
                        content: Text(
                            'You have reached the maximum limit of 5 rows.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Image.asset(
                'assets/icons/add.png',
                width: 0.034.w,
                height: 0.034.h,
              ),
            ),
          ],
        ),
        for (int i = 1;
            i < selectedTimes.length;
            i++) // Loop through selectedTimes list
          Row(
            children: [
              Image.asset(
                'assets/icons/clock.png',
                width: 0.064.w,
                height: 0.044.h,
              ),
              SizedBox(width: 0.015.w),
              Container(
                width: 0.38.w,
                height: 0.039.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: MyThemeData.colorTotalBlack),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext builder) {
                            return Container(
                              height: MediaQuery.of(context)
                                      .copyWith()
                                      .size
                                      .height /
                                  3,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                initialDateTime: DateTime.now(),
                                onDateTimeChanged: (DateTime newDateTime) {
                                  setState(() {
                                    selectedTimes[i] =
                                        TimeOfDay.fromDateTime(newDateTime);
                                  });
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${selectedTimes[i].format(context)}",
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: FontConstants.fontSize016.h,
                              color: MyThemeData.colorTotalBlack,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.004.h),
                      child: VerticalDivider(
                        thickness: 0.001.h,
                        width: 0.001.w,
                        color: MyThemeData.colorTotalBlack,
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext builder) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: MyThemeData.colorTotalBlack),
                                ),
                                height: MediaQuery.of(context)
                                        .copyWith()
                                        .size
                                        .height /
                                    3,
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.time,
                                  initialDateTime: DateTime.now(),
                                  onDateTimeChanged: (DateTime newDateTime) {
                                    setState(() {
                                      selectedTimes[i] =
                                          TimeOfDay.fromDateTime(newDateTime);
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "${selectedTimes[i].format(context)}",
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: FontConstants.fontSize016.h,
                                color: MyThemeData.colorTotalBlack,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 0.01.w),
              GestureDetector(
                onTap: () {
                  // Remove the corresponding row from the list when the icon is pressed
                  setState(() {
                    selectedTimes.removeAt(i);
                  });
                },
                child: SvgPicture.asset(
                  'assets/icons/delete.svg',
                  width: 0.022.w,
                  height: 0.022.h,
                ),
              ),
              //SizedBox(width: 0.045.w),
            ],
          ),
      ],
    );
  }
}
