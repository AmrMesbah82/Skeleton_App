import 'dart:developer';
import 'package:demo_app/core/theme/app_colors.dart';

import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/shared_components/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/core/shared_components/date_picker_class.dart';
import 'package:demo_app/core/widgets/cupertino_time_picker.dart';
import 'package:demo_app/core/shared_components/custom_black_button.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';


import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/guests_container.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

class AddGuests extends StatefulWidget {
  const AddGuests({
    super.key,
    this.isEdit = false,
    this.event,
  });
  final bool isEdit;
  final EventModel? event;

  @override
  State<AddGuests> createState() => _AddGuestsState();
}

class _AddGuestsState extends State<AddGuests> {
  bool isToggled = false;
  DateTime? selectedDate;
  bool isToggled2 = false;
  TextEditingController arabicMaximumCapacity = TextEditingController();
  TextEditingController arabicFirstDate = TextEditingController();
  TextEditingController arabicSecondDate = TextEditingController();
  TextEditingController arabicFirstTime = TextEditingController();
  TextEditingController arabicSecondTime = TextEditingController();
  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [];
  Future<void> _selectDate(BuildContext context, String value) async {
    final List<DateTime?>? picked = await DatePicker().showDatePicker(
        context,
        _rangeDatePickerValueWithDefaultValue,
        DateTime.now(),
        CalendarDatePicker2Type.single);
    DateTime endDate =
        DateFormat('dd MMM yyyy').parse(eventController.date.text);
    log("eventdate : $endDate");
    if (picked != null &&
        picked.isNotEmpty &&
        picked[0] != selectedDate &&
        picked[0]!.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
        picked[0]!.isBefore(endDate)) {
      setState(() {
        log("${picked[0]!.day} ${DateFormat.MMM().format(picked[0]!)} ${picked[0]!.year}");
        _rangeDatePickerValueWithDefaultValue = picked;
        selectedDate = picked[0];
        final DateFormat formatter = DateFormat('dd MMM yyyy');
        String formattedDate = formatter.format(picked[0] as DateTime);
        value == 'first'
            ? eventController.reminderDateFirsrt.text = formattedDate
            : eventController.reminderDateSecond.text = formattedDate;
      });
    }
  }

  final EventController eventController = Get.put(EventController());

  @override
  void initState() {
    if (widget.event == null) {
    } else {
      eventController.reminders = [
        Reminder(
            date: eventController.reminderDateFirsrt.text,
            time: eventController.reminderTimeFirsrt.text)
      ];

      if (widget.isEdit) {
        eventController.sendReminders = widget.event!.sendReminders;
        for (int i = 0; i < widget.event!.reminders.length; i++) {
          if (i == 0) {
            eventController.reminderDateFirsrt.text =
                widget.event!.reminders[i].date;
            eventController.reminderTimeFirsrt.text =
                widget.event!.reminders[i].time;
            arabicFirstDate.text =
                translateDateFormatToArabic(widget.event!.reminders[i].date);
            arabicFirstTime.text =
                convertTimeToArabic(widget.event!.reminders[i].time);
          }
          if (i == 1) {
            eventController.reminderDateSecond.text =
                widget.event!.reminders[i].date;
            eventController.reminderTimeSecond.text =
                widget.event!.reminders[i].time;
            arabicSecondDate.text =
                translateDateFormatToArabic(widget.event!.reminders[i].date);
            arabicSecondTime.text =
                convertTimeToArabic(widget.event!.reminders[i].time);
          }

          if (i >= eventController.reminders.length) {
            eventController.reminders.add(Reminder(
                date: widget.event!.reminders[i].date,
                time: widget.event!.reminders[i].time));
          } else {
            eventController.reminders[i] = (Reminder(
                date: widget.event!.reminders[i].date,
                time: widget.event!.reminders[i].time));
          }
        }
      }
      eventController.maximumCapacity =
          TextEditingController(text: widget.event?.maximumCapacity);
      if (widget.event != null) {
        arabicMaximumCapacity = TextEditingController(
            text: convertNumberToArabic(widget.event!.maximumCapacity));
      }

      eventController.requiredApproval =
          widget.event?.requiredApproval ?? false;
      if (eventController.requiredApproval) {
        eventController.approvalFrom.text =
            widget.isEdit ? widget.event!.approvalEmail!.email : "";
      }

      // edit here for guests

      if (widget.isEdit) {
        if (eventController.maximumCapacity.text != '0' &&
            eventController.maximumCapacity.text != '' &&
            eventController.invitedEmployees.length <=
                int.parse(eventController.maximumCapacity.text)) {
          eventController.invitedEmployees.assignAll(widget.event!.guests);
          eventController.searchEmployeesList.assignAll(widget.event!.guests);
          eventController.requiredEmployee = widget.event!.approvalEmail;
        } else {
          eventController.invitedEmployees.assignAll([]);
          eventController.searchEmployeesList.assignAll([]);
          eventController.requiredApprovalEmployeesList.assignAll([]);
        }
      } else {
        eventController.invitedEmployees.assignAll([]);
        eventController.searchEmployeesList.assignAll([]);
        eventController.requiredApprovalEmployeesList.assignAll([]);
        eventController.requiredEmployee = null;
      }

      eventController.inviteController.text = '';
      eventController.requiredApprovalController.text = '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double height = 0.02.h;
    double width = isVertical ? 0.35.w : 0.37.w;
    return GetBuilder<EventController>(
      builder: (eventController) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.02.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  // width: double.infinity,
                  child: ColumnRequestData(
                    fillColor: Theme.of(context).colorScheme.inversePrimary,
                    title: "Maximum Capacity",
                    mainAxisAlignment: MainAxisAlignment.start,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    isTextField: true,
                    hint: "Text Here",
                    isOptional: false,
                    isExpanded: true,
                    hasPrefix: true,
                    textController: Get.locale.toString().contains('en')
                        ? eventController.maximumCapacity
                        : arabicMaximumCapacity,
                    controllerState: (value) {
                      setState(() {
                        eventController.maximumCapacity.text =
                            convertNumberToEnglish(value!);
                        log('value Delegation ${eventController.maximumCapacity.text}');
                        if (eventController.maximumCapacity.text == '0' ||
                            eventController.maximumCapacity.text == '' ||
                            eventController.invitedEmployees.length >
                                int.parse(
                                    eventController.maximumCapacity.text)) {
                          eventController.invitedEmployees.assignAll([]);
                          eventController.searchEmployeesList.assignAll([]);
                          eventController.requiredApprovalEmployeesList
                              .assignAll([]);
                        } else {
                          eventController.searchEmployeesList
                              .assignAll(eventController.invitedEmployees);
                        }
                        eventController.inviteController.text = "";
                      });
                      eventController.update();
                    },
                  ),
                ),
                SizedBox(
                  width: 0.02.w,
                ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
            SizedBox(height: 0.015.h,),
            SizedBox(
              width: double.infinity,
              child: ColumnRequestData(
                fillColor: Theme.of(context).colorScheme.inversePrimary,
                title: "Invite Guests",
                mainAxisAlignment: MainAxisAlignment.start,
                isRequired: true,
                isTextField: true,
                hint: "Text Here",
                isOptional: false,
                isExpanded: true,
                hasPrefix: true,
                prefixIcon: Transform.scale(
                  scale: 0.6,
                  child: SvgPicture.asset(
                    'assets/images/Search.svg',
                    color: (themeController.currentTheme ==
                            AppColors.lightTheme
                        ? Theme.of(context).colorScheme.scrim.withOpacity(0.6)
                        : AppColors.colorWhite),
                  ),
                ),
                textController: eventController.inviteController,
                controllerState: (value) {
                  eventController.inviteGuests();
                },
              ),
            ),
            eventController.searchEmployeesList.isNotEmpty
                ? SizedBox(
                    height:isVertical? 0.015.h : 0.02.h,
                  )
                : SizedBox(
                    height: 0.00.h,
                  ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    ((eventController.searchEmployeesList.length) / 4).ceil(),
                    (index) {
                  int firstIndex = index * 4;
                  int secondIndex = firstIndex + 1;
                  int thirdIndex = firstIndex + 2;
                  int fourthIndex = firstIndex + 3;
                  return Padding(
                    padding: EdgeInsets.only(right: 0.015.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        firstIndex < eventController.searchEmployeesList.length
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    eventController.appendInvitedEmployee(
                                        eventController
                                            .searchEmployeesList[firstIndex]);
                                  });
                                },
                                child: GuestsContainer(
                                  deleteEmployeeMethod: () {
                                    eventController.deleteInvitedEmployee(
                                        eventController
                                            .searchEmployeesList[firstIndex]);
                                    setState(() {});
                                  },
                                  nameInArabic: eventController
                                      .searchEmployeesList[firstIndex]
                                      .arabicName,
                                  departmentInArabic: eventController
                                      .searchEmployeesList[firstIndex]
                                      .arabicDepartment,
                                  department: eventController
                                      .searchEmployeesList[firstIndex]
                                      .department,
                                  jobTitle: eventController
                                      .searchEmployeesList[firstIndex].role,
                                  name: eventController
                                      .searchEmployeesList[firstIndex].name,
                                  profilePhoto: eventController
                                      .searchEmployeesList[firstIndex].imageUrl,
                                  isEdit:
                                      (eventController.inviteController.text ==
                                              '')
                                          ? true
                                          : false,
                                  isInvited: eventController.alreadyInvited(
                                      eventController
                                          .searchEmployeesList[firstIndex]),
                                ),
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: 0.015.h,
                        ),
                        secondIndex < eventController.searchEmployeesList.length
                            ? GestureDetector(
                                onTap: () {
                                  eventController.appendInvitedEmployee(
                                      eventController
                                          .searchEmployeesList[secondIndex]);
                                },
                                child: GuestsContainer(
                                  deleteEmployeeMethod: () {
                                    eventController.deleteInvitedEmployee(
                                        eventController
                                            .searchEmployeesList[secondIndex]);
                                    setState(() {});
                                  },
                                  nameInArabic: eventController
                                      .searchEmployeesList[secondIndex]
                                      .arabicName,
                                  departmentInArabic: eventController
                                      .searchEmployeesList[secondIndex]
                                      .arabicDepartment,
                                  department: eventController
                                      .searchEmployeesList[secondIndex]
                                      .department,
                                  jobTitle: eventController
                                      .searchEmployeesList[secondIndex].role,
                                  name: eventController
                                      .searchEmployeesList[secondIndex].name,
                                  profilePhoto: eventController
                                      .searchEmployeesList[secondIndex]
                                      .imageUrl,
                                  isEdit:
                                      (eventController.inviteController.text ==
                                              '')
                                          ? true
                                          : false,
                                  isInvited: eventController.alreadyInvited(
                                      eventController
                                          .searchEmployeesList[secondIndex]),
                                ),
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: 0.015.h,
                        ),
                        thirdIndex < eventController.searchEmployeesList.length
                            ? GestureDetector(
                                onTap: () {
                                  eventController.appendInvitedEmployee(
                                      eventController
                                          .searchEmployeesList[thirdIndex]);
                                },
                                child: GuestsContainer(
                                  deleteEmployeeMethod: () {
                                    eventController.deleteInvitedEmployee(
                                        eventController
                                            .searchEmployeesList[thirdIndex]);
                                    setState(() {});
                                  },
                                  nameInArabic: eventController
                                      .searchEmployeesList[thirdIndex]
                                      .arabicName,
                                  departmentInArabic: eventController
                                      .searchEmployeesList[thirdIndex]
                                      .arabicDepartment,
                                  department: eventController
                                      .searchEmployeesList[thirdIndex]
                                      .department,
                                  jobTitle: eventController
                                      .searchEmployeesList[thirdIndex].role,
                                  name: eventController
                                      .searchEmployeesList[thirdIndex].name,
                                  profilePhoto: eventController
                                      .searchEmployeesList[thirdIndex].imageUrl,
                                  isEdit:
                                      (eventController.inviteController.text ==
                                              '')
                                          ? true
                                          : false,
                                  isInvited: eventController.alreadyInvited(
                                      eventController
                                          .searchEmployeesList[thirdIndex]),
                                ),
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: 0.015.h,
                        ),
                        fourthIndex < eventController.searchEmployeesList.length
                            ? GestureDetector(
                                onTap: () {
                                  eventController.appendInvitedEmployee(
                                      eventController
                                          .searchEmployeesList[fourthIndex]);
                                },
                                child: GuestsContainer(
                                  deleteEmployeeMethod: () {
                                    eventController.deleteInvitedEmployee(
                                        eventController
                                            .searchEmployeesList[fourthIndex]);
                                    setState(() {});
                                  },
                                  nameInArabic: eventController
                                      .searchEmployeesList[fourthIndex]
                                      .arabicName,
                                  departmentInArabic: eventController
                                      .searchEmployeesList[fourthIndex]
                                      .arabicDepartment,
                                  department: eventController
                                      .searchEmployeesList[fourthIndex]
                                      .department,
                                  jobTitle: eventController
                                      .searchEmployeesList[fourthIndex].role,
                                  name: eventController
                                      .searchEmployeesList[fourthIndex].name,
                                  profilePhoto: eventController
                                      .searchEmployeesList[fourthIndex]
                                      .imageUrl,
                                  isEdit:
                                      (eventController.inviteController.text ==
                                              '')
                                          ? true
                                          : false,
                                  isInvited: eventController.alreadyInvited(
                                      eventController
                                          .searchEmployeesList[fourthIndex]),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: height,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  eventController.sendReminders =
                      !eventController.sendReminders;
                });
              },
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    eventController.sendReminders
                        ? 'assets/icons/CheckListOn.svg'
                        : 'assets/icons/CheckListOff.svg',
                    color: eventController.sendReminders
                        ? AppColors.signOut
                        : null,
                    //  width: 0.070.w,
                    height: isVertical ? 0.025.h : 0.035.h,
                  ),
                  SizedBox(
                    width: 0.01.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.005.h),
                    child: Text(
                      "Send Reminders".tr,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize015.w,
                        color: eventController.sendReminders
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : AppColors.colorGrey,
                        height: 1.2,
                        fontWeight:
                            isToggled ? FontWeight.w400 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            eventController.reminders.isEmpty
                ? const SizedBox.shrink()
                : SizedBox(
                    height: height,
                  ),
            !eventController.sendReminders
                ? const SizedBox.shrink()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: eventController.reminders.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 0.02.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              index == 0
                                  ? "First Notification".tr
                                  : "Second Notification".tr,
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                  fontSize: isVertical
                                      ? FontConstants.fontSize019.h
                                      : FontConstants.fontSize022.h,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                  height: 1.6),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _selectDate(context,
                                        index == 0 ? 'first' : 'Second')
                                        .then(
                                      (_) {
                                        if (index == 0) {
                                          if (eventController
                                                  .reminderDateFirsrt.text !=
                                              "") {
                                            arabicFirstDate.text =
                                                translateDateFormatToArabic(
                                                    eventController
                                                        .reminderDateFirsrt.text);
                                          }
                                        } else {
                                          if (eventController
                                                  .reminderDateSecond.text !=
                                              "") {
                                            arabicSecondDate.text =
                                                translateDateFormatToArabic(
                                                    eventController
                                                        .reminderDateSecond.text);
                                          }
                                        }
                                      },
                                    );
                                  },
                                  child: SizedBox(
                                    width: width,
                                    child: ColumnRequestData(
                                      fillColor: Colors.transparent,
                                      title: "Date",
                                      textController:
                                          Get.locale.toString().contains('en')
                                              ? (index == 0
                                                  ? eventController
                                                      .reminderDateFirsrt
                                                  : eventController
                                                      .reminderDateSecond)
                                              : (index == 0
                                                  ? arabicFirstDate
                                                  : arabicSecondDate),
                                      isTextField: true,
                                      hint: "Select Date",
                                      isOptional: false,
                                      isExpanded: true,
                                      enabled: false,
                                      hasPrefix: true,
                                      hasSuffix: true,
                                      suffixUrl: "assets/icons/newCalenderFixed.svg",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 0.02.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoTimePicker(
                                          onDateTimeChanged:
                                              (DateTime newDateTime) {
                                            setState(() {
                                              if (index == 0) {
                                                eventController
                                                        .reminderTimeFirsrt
                                                        .text =
                                                    DateFormat('hh:mm a')
                                                        .format(newDateTime);
                                                arabicFirstTime.text =
                                                    convertTimeToArabic(
                                                        DateFormat('hh:mm a')
                                                            .format(
                                                                newDateTime));
                                              } else {
                                                eventController
                                                        .reminderTimeSecond
                                                        .text =
                                                    DateFormat('hh:mm a')
                                                        .format(newDateTime);
                                                arabicSecondTime.text =
                                                    convertTimeToArabic(
                                                        DateFormat('hh:mm a')
                                                            .format(
                                                                newDateTime));
                                              }
                                              // selectedTime1 = TimeOfDay.fromDateTime(newDateTime);
                                            });
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: SizedBox(
                                    width: width,
                                    child: ColumnRequestData(
                                      fillColor: Colors.transparent,
                                      title: "Time",
                                      isTextField: true,
                                      hint: "Select Time",
                                      enabled: false,
                                      isOptional: false,
                                      hasPrefix: true,
                                      isExpanded: true,
                                      hasSuffix: true,
                                      suffixUrl:
                                          "assets/icons/newTimeIconFixed.svg",
                                      textController:
                                          Get.locale.toString().contains('en')
                                              ? (index == 0
                                                  ? eventController
                                                      .reminderTimeFirsrt
                                                  : eventController
                                                      .reminderTimeSecond)
                                              : (index == 0
                                                  ? arabicFirstTime
                                                  : arabicSecondTime),
                                      controllerState: (value) {
                                        setState(() {
                                          print('value description ${value!}');
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(top: 0.025.h),
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          eventController.reminders
                                              .removeAt(index);
                                        });
                                      },
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/icons/trashIcon.svg",
                                          height: 0.04.h,
                                          color: AppColors.block,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
            !eventController.sendReminders
                ? const SizedBox.shrink()
                : SizedBox(
                    height: height,
                  ),
            !eventController.sendReminders
                ? const SizedBox.shrink()
                : eventController.reminders.length == 2
                    ? const SizedBox.shrink()
                    : CustomBlackButton(
                        buttonText: "Add More Notifications".tr,
                        onPressed: () {
                          setState(() {
                            eventController.reminders.isEmpty
                                ? eventController.reminders.add(Reminder(
                                    date:
                                        eventController.reminderDateFirsrt.text,
                                    time: eventController
                                        .reminderTimeFirsrt.text))
                                : eventController.reminders.add(Reminder(
                                    date:
                                        eventController.reminderDateSecond.text,
                                    time: eventController
                                        .reminderTimeSecond.text));
                          });
                        }),
            SizedBox(
              height: height,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  eventController.requiredApproval =
                      !eventController.requiredApproval;
                });
              },
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    eventController.requiredApproval
                        ? 'assets/icons/CheckListOn.svg'
                        : 'assets/icons/CheckListOff.svg',
                    color: eventController.requiredApproval
                        ? AppColors.signOut
                        : null,
                    //  width: 0.070.w,
                    height: isVertical ? 0.025.h : 0.035.h,
                  ),
                  SizedBox(
                    width: 0.01.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.005.h),
                    child: Text(
                      "Requires Approval".tr,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize015.w,
                        color: eventController.requiredApproval
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : AppColors.colorGrey,
                        height: 1.2,
                        fontWeight: eventController.requiredApproval
                            ? FontWeight.w400
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height,
            ),
            !eventController.requiredApproval
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ColumnRequestData(
                          fillColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          title: "Invite Guests",
                          mainAxisAlignment: MainAxisAlignment.start,
                          isTextField: true,
                          hideTitle: true,
                          hint: "Search People",
                          isOptional: false,
                          isExpanded: true,
                          hasPrefix: true,
                          prefixIcon: Transform.scale(
                            scale: 0.4,
                            child: SvgPicture.asset(
                              'assets/images/Search.svg',
                              color: (themeController.currentTheme ==
                                      AppColors.lightTheme
                                  ? Theme.of(context)
                                      .colorScheme
                                      .scrim
                                      .withOpacity(0.6)
                                  : AppColors.colorWhite),
                            ),
                          ),
                          textController:
                              eventController.requiredApprovalController,
                          controllerState: (value) {
                            eventController.inviteRequireGuests();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 0.005.h,
                      ),
                      eventController.requiredApprovalController.text.isEmpty
                          ? eventController.requiredEmployee != null
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      eventController
                                          .appendInvitedRequiredEmployee(
                                              eventController
                                                  .requiredEmployee!);
                                    });
                                  },
                                  child: GuestsContainer(
                                    deleteEmployeeMethod: () {
                                      eventController
                                          .deleteInvitedRequiredEmployee(
                                              eventController
                                                  .requiredEmployee!);
                                      setState(() {});
                                    },
                                    departmentInArabic: eventController
                                        .requiredEmployee!.arabicDepartment,
                                    nameInArabic: eventController
                                        .requiredEmployee!.arabicName,
                                    department: eventController
                                        .requiredEmployee!.department,
                                    jobTitle:
                                        eventController.requiredEmployee!.role,
                                    name:
                                        eventController.requiredEmployee!.name,
                                    profilePhoto: eventController
                                        .requiredEmployee!.imageUrl,
                                    isEdit: (eventController
                                                .requiredApprovalController
                                                .text ==
                                            '')
                                        ? true
                                        : false,
                                    isInvited: eventController
                                        .alreadyInvitedAtRequired(
                                            eventController.requiredEmployee!),
                                  ),
                                )
                              : const SizedBox.shrink()
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    ((eventController
                                                .requiredApprovalEmployeesList
                                                .length) /
                                            4)
                                        .ceil(), (index) {
                                  int firstIndex = index * 4;
                                  int secondIndex = firstIndex + 1;
                                  int thirdIndex = firstIndex + 2;
                                  int fourthIndex = firstIndex + 3;
                                  return Padding(
                                    padding: EdgeInsets.only(right: 0.015.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        firstIndex <
                                                eventController
                                                    .requiredApprovalEmployeesList
                                                    .length
                                            ? GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    eventController
                                                        .appendInvitedRequiredEmployee(
                                                            eventController
                                                                    .requiredApprovalEmployeesList[
                                                                firstIndex]);
                                                  });
                                                },
                                                child: GuestsContainer(
                                                  deleteEmployeeMethod: () {
                                                    eventController
                                                        .deleteInvitedRequiredEmployee(
                                                            eventController
                                                                    .requiredApprovalEmployeesList[
                                                                firstIndex]);
                                                    setState(() {});
                                                  },
                                                  department: eventController
                                                      .requiredApprovalEmployeesList[
                                                          firstIndex]
                                                      .department,
                                                  departmentInArabic:
                                                      eventController
                                                          .requiredApprovalEmployeesList[
                                                              firstIndex]
                                                          .arabicDepartment,
                                                  nameInArabic: eventController
                                                      .requiredApprovalEmployeesList[
                                                          firstIndex]
                                                      .arabicName,
                                                  jobTitle: eventController
                                                      .requiredApprovalEmployeesList[
                                                          firstIndex]
                                                      .role,
                                                  name: eventController
                                                      .requiredApprovalEmployeesList[
                                                          firstIndex]
                                                      .name,
                                                  profilePhoto: eventController
                                                      .requiredApprovalEmployeesList[
                                                          firstIndex]
                                                      .imageUrl,
                                                  isEdit: (eventController
                                                              .requiredApprovalController
                                                              .text ==
                                                          '')
                                                      ? true
                                                      : false,
                                                  isInvited: eventController
                                                      .alreadyInvitedAtRequired(
                                                          eventController
                                                                  .requiredApprovalEmployeesList[
                                                              firstIndex]),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        SizedBox(
                                          height: 0.015.h,
                                        ),
                                        secondIndex <
                                                eventController
                                                    .requiredApprovalEmployeesList
                                                    .length
                                            ? GestureDetector(
                                                onTap: () {
                                                  eventController
                                                      .appendInvitedRequiredEmployee(
                                                          eventController
                                                                  .requiredApprovalEmployeesList[
                                                              secondIndex]);
                                                },
                                                child: GuestsContainer(
                                                  deleteEmployeeMethod: () {
                                                    eventController
                                                        .deleteInvitedRequiredEmployee(
                                                            eventController
                                                                    .requiredApprovalEmployeesList[
                                                                secondIndex]);
                                                    setState(() {});
                                                  },
                                                  department: eventController
                                                      .requiredApprovalEmployeesList[
                                                          secondIndex]
                                                      .department,
                                                  jobTitle: eventController
                                                      .requiredApprovalEmployeesList[
                                                          secondIndex]
                                                      .role,
                                                  departmentInArabic:
                                                      eventController
                                                          .requiredApprovalEmployeesList[
                                                              secondIndex]
                                                          .arabicDepartment,
                                                  nameInArabic: eventController
                                                      .requiredApprovalEmployeesList[
                                                          secondIndex]
                                                      .arabicName,
                                                  name: eventController
                                                      .requiredApprovalEmployeesList[
                                                          secondIndex]
                                                      .name,
                                                  profilePhoto: eventController
                                                      .requiredApprovalEmployeesList[
                                                          secondIndex]
                                                      .imageUrl,
                                                  isEdit: (eventController
                                                              .requiredApprovalController
                                                              .text ==
                                                          '')
                                                      ? true
                                                      : false,
                                                  isInvited: eventController
                                                      .alreadyInvitedAtRequired(
                                                          eventController
                                                                  .requiredApprovalEmployeesList[
                                                              secondIndex]),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        SizedBox(
                                          height: 0.015.h,
                                        ),
                                        thirdIndex <
                                                eventController
                                                    .requiredApprovalEmployeesList
                                                    .length
                                            ? GestureDetector(
                                                onTap: () {
                                                  eventController
                                                      .appendInvitedRequiredEmployee(
                                                          eventController
                                                                  .requiredApprovalEmployeesList[
                                                              thirdIndex]);
                                                },
                                                child: GuestsContainer(
                                                  deleteEmployeeMethod: () {
                                                    eventController
                                                        .deleteInvitedRequiredEmployee(
                                                            eventController
                                                                    .requiredApprovalEmployeesList[
                                                                thirdIndex]);
                                                    setState(() {});
                                                  },
                                                  department: eventController
                                                      .requiredApprovalEmployeesList[
                                                          thirdIndex]
                                                      .department,
                                                  jobTitle: eventController
                                                      .requiredApprovalEmployeesList[
                                                          thirdIndex]
                                                      .role,
                                                  departmentInArabic:
                                                      eventController
                                                          .requiredApprovalEmployeesList[
                                                              thirdIndex]
                                                          .arabicDepartment,
                                                  nameInArabic: eventController
                                                      .requiredApprovalEmployeesList[
                                                          thirdIndex]
                                                      .arabicName,
                                                  name: eventController
                                                      .requiredApprovalEmployeesList[
                                                          thirdIndex]
                                                      .name,
                                                  profilePhoto: eventController
                                                      .requiredApprovalEmployeesList[
                                                          thirdIndex]
                                                      .imageUrl,
                                                  isEdit: (eventController
                                                              .requiredApprovalController
                                                              .text ==
                                                          '')
                                                      ? true
                                                      : false,
                                                  isInvited: eventController
                                                      .alreadyInvitedAtRequired(
                                                          eventController
                                                                  .requiredApprovalEmployeesList[
                                                              thirdIndex]),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        SizedBox(
                                          height: 0.015.h,
                                        ),
                                        fourthIndex <
                                                eventController
                                                    .requiredApprovalEmployeesList
                                                    .length
                                            ? GestureDetector(
                                                onTap: () {
                                                  eventController
                                                      .appendInvitedRequiredEmployee(
                                                          eventController
                                                                  .requiredApprovalEmployeesList[
                                                              fourthIndex]);
                                                },
                                                child: GuestsContainer(
                                                  deleteEmployeeMethod: () {
                                                    eventController
                                                        .deleteInvitedRequiredEmployee(
                                                            eventController
                                                                    .requiredApprovalEmployeesList[
                                                                fourthIndex]);
                                                    setState(() {});
                                                  },
                                                  department: eventController
                                                      .requiredApprovalEmployeesList[
                                                          fourthIndex]
                                                      .department,
                                                  jobTitle: eventController
                                                      .requiredApprovalEmployeesList[
                                                          fourthIndex]
                                                      .role,
                                                  name: eventController
                                                      .requiredApprovalEmployeesList[
                                                          fourthIndex]
                                                      .name,
                                                  departmentInArabic:
                                                      eventController
                                                          .requiredApprovalEmployeesList[
                                                              fourthIndex]
                                                          .arabicDepartment,
                                                  nameInArabic: eventController
                                                      .requiredApprovalEmployeesList[
                                                          fourthIndex]
                                                      .arabicName,
                                                  profilePhoto: eventController
                                                      .requiredApprovalEmployeesList[
                                                          fourthIndex]
                                                      .imageUrl,
                                                  isEdit: (eventController
                                                              .requiredApprovalController
                                                              .text ==
                                                          '')
                                                      ? true
                                                      : false,
                                                  isInvited: eventController
                                                      .alreadyInvitedAtRequired(
                                                          eventController
                                                                  .requiredApprovalEmployeesList[
                                                              fourthIndex]),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
