import 'dart:developer';

import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/components/calendar_components.dart/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/components/calendar_components.dart/date_picker_class.dart';
import 'package:demo_app/core/widgets/cupertino_time_picker.dart';
import 'package:demo_app/components/settings_components/custom_black_button.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/feature/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/feature/events/tablet/media_departments_view/components/guests_container.dart';
import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';

class AddGuestsMobile extends StatefulWidget {
  AddGuestsMobile({super.key, this.isEdit = false, this.event});
  final EventModel? event;
  bool? isEdit;

  @override
  State<AddGuestsMobile> createState() => _AddGuestsMobileState();
}

class _AddGuestsMobileState extends State<AddGuestsMobile> {
  bool isToggled = false;
  final EventController eventController = Get.put(EventController());

  TextEditingController arabicMaximumCapacity = TextEditingController();
  TextEditingController arabicFirstDate = TextEditingController();
  TextEditingController arabicSecondDate = TextEditingController();
  TextEditingController arabicFirstTime = TextEditingController();
  TextEditingController arabicSecondTime = TextEditingController();

  bool isToggled2 = false;
  DateTime? selectedDate;
  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [];
  Future<void> _selectDate(BuildContext context, String value) async {
    final List<DateTime?>? picked = await DatePicker().showDatePicker(
        context,
        _rangeDatePickerValueWithDefaultValue,
        DateTime.now(),
        CalendarDatePicker2Type.single);
    // change the selected the  with the picked date
    // ignore: unrelated_type_equality_checks
    DateTime endDate =
        DateFormat('dd MMM yyyy').parse(eventController.date.text);
    if (picked != null &&
        picked.isNotEmpty &&
        picked[0] != selectedDate &&
        picked[0]!.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
        picked[0]!.isBefore(endDate)) {
      setState(() {
        _rangeDatePickerValueWithDefaultValue = picked;
        selectedDate = picked[0];
        final DateFormat formatter = DateFormat('dd MMM yyyy');
        String formattedDate = formatter.format(picked[0] as DateTime);
        value == 'first'
            ? eventController.reminderDateFirsrt.text = formattedDate
            : eventController.reminderDateSecond.text = formattedDate;
        // get the first element in the array which is the selected date
        // final DateFormat formatter = DateFormat('dd/MM/yyyy');
        // String formattedDate = formatter.format(picked[0] as DateTime);
        // String formattedDate2 = formatter.format(picked.last as DateTime);
        /*  widget.dateValue =
            "${'From'.tr} ${picked[0]!.day} ${DateFormat.MMM().format(picked[0]!).tr} ${picked[0]!.year} ${'To'.tr} ${picked.last!.day} ${DateFormat.MMM().format(picked.last!).tr} ${picked.last!.year}";
        widget.dateValueState!(widget.dateValue);

        date.text = widget.dateValue.substring(
            widget.dateValue.indexOf('To'.tr) + 2, widget.dateValue.length);*/
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
    } else {
      eventController.reminders = [
        Reminder(
            date: eventController.reminderDateFirsrt.text,
            time: eventController.reminderTimeFirsrt.text)
      ];

      if (widget.isEdit!) {
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

      // edit here for guests

      if (widget.isEdit == true) {
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
  }

  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double height = 0.01.h;
    double width = 0.85.w;
    return GetBuilder<EventController>(
      builder: (eventController) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.04.w, vertical: 0.0.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.01.h,),
              SizedBox(
                width: double.infinity,
                child: ColumnRequestData(
                  fillColor: Theme.of(context).colorScheme.inversePrimary,
                  title: "Maximum Capacity",
                  mainAxisAlignment: MainAxisAlignment.start,
                  isTextField: true,
                  hint: "Text Here",
                  isOptional: false,
                  isRequired: true,
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
                              int.parse(eventController.maximumCapacity.text)) {
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
              SizedBox(height: 0.01.h,),
              SizedBox(
                width: double.infinity,
                child: ColumnRequestData(
                  fillColor: Theme.of(context).colorScheme.inversePrimary,
                  title: "Invite Guests",
                  mainAxisAlignment: MainAxisAlignment.start,
                  isTextField: true,
                  hint: "Text Here",
                  isOptional: false,
                  isRequired: true,
                  isExpanded: true,
                  hasPrefix: true,
                  prefixIcon: Transform.scale(
                    scale: 0.4,
                    child: SvgPicture.asset(
                      'assets/images/Search.svg',
                      color: (themeController.currentTheme ==
                              MyThemeData.lightTheme
                          ? Theme.of(context).colorScheme.scrim.withOpacity(0.6)
                          : MyThemeData.colorWhite),
                    ),
                  ),
                  textController: eventController.inviteController,
                  controllerState: (value) {
                    eventController.inviteGuests();
                  },
                ),
              ),
              SizedBox(
                height: 0.015.h,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
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
                          firstIndex <
                                  eventController.searchEmployeesList.length
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
                                    departmentInArabic: eventController
                                        .searchEmployeesList[firstIndex]
                                        .arabicDepartment,
                                    nameInArabic: eventController
                                        .searchEmployeesList[firstIndex]
                                        .arabicName,
                                    department: eventController
                                        .searchEmployeesList[firstIndex]
                                        .department,
                                    jobTitle: eventController
                                        .searchEmployeesList[firstIndex].role,
                                    name: eventController
                                        .searchEmployeesList[firstIndex].name,
                                    profilePhoto: eventController
                                        .searchEmployeesList[firstIndex]
                                        .imageUrl,
                                    isEdit: (eventController
                                                .inviteController.text ==
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
                          secondIndex <
                                  eventController.searchEmployeesList.length
                              ? GestureDetector(
                                  onTap: () {
                                    eventController.appendInvitedEmployee(
                                        eventController
                                            .searchEmployeesList[secondIndex]);
                                  },
                                  child: GuestsContainer(
                                    deleteEmployeeMethod: () {
                                      eventController.deleteInvitedEmployee(
                                          eventController.searchEmployeesList[
                                              secondIndex]);
                                      setState(() {});
                                    },
                                    departmentInArabic: eventController
                                        .searchEmployeesList[secondIndex]
                                        .arabicDepartment,
                                    nameInArabic: eventController
                                        .searchEmployeesList[secondIndex]
                                        .arabicName,
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
                                    isEdit: (eventController
                                                .inviteController.text ==
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
                          thirdIndex <
                                  eventController.searchEmployeesList.length
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
                                    departmentInArabic: eventController
                                        .searchEmployeesList[thirdIndex]
                                        .arabicDepartment,
                                    nameInArabic: eventController
                                        .searchEmployeesList[thirdIndex]
                                        .arabicName,
                                    department: eventController
                                        .searchEmployeesList[thirdIndex]
                                        .department,
                                    jobTitle: eventController
                                        .searchEmployeesList[thirdIndex].role,
                                    name: eventController
                                        .searchEmployeesList[thirdIndex].name,
                                    profilePhoto: eventController
                                        .searchEmployeesList[thirdIndex]
                                        .imageUrl,
                                    isEdit: (eventController
                                                .inviteController.text ==
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
                          fourthIndex <
                                  eventController.searchEmployeesList.length
                              ? GestureDetector(
                                  onTap: () {
                                    eventController.appendInvitedEmployee(
                                        eventController
                                            .searchEmployeesList[fourthIndex]);
                                  },
                                  child: GuestsContainer(
                                    deleteEmployeeMethod: () {
                                      eventController.deleteInvitedEmployee(
                                          eventController.searchEmployeesList[
                                              fourthIndex]);
                                      setState(() {});
                                    },
                                    departmentInArabic: eventController
                                        .searchEmployeesList[fourthIndex]
                                        .arabicDepartment,
                                    nameInArabic: eventController
                                        .searchEmployeesList[fourthIndex]
                                        .arabicName,
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
                                    isEdit: (eventController
                                                .inviteController.text ==
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
              // SizedBox(
              //   height: height,
              // ),
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
                          ? MyThemeData.signOut
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
                          fontSize: FontConstants.fontSize015.h,
                          color: eventController.sendReminders
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : MyThemeData.colorGrey,
                          height: 1.2,
                          fontWeight: eventController.sendReminders
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
              !eventController.sendReminders
                  ? const SizedBox.shrink()
                  : SizedBox(
                      child: ListView.builder(
padding: EdgeInsets.zero,
                          itemCount: eventController.reminders.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  index == 0
                                      ? "First Notification".tr
                                      : "Second Notification".tr,
                                  style: AppFontStyle.cairoRegularStyle
                                      .copyWith(
                                          fontSize: isVertical
                                              ? FontConstants.fontSize019.h
                                              : FontConstants.fontSize022.h,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface,
                                          height: 1.6),
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _selectDate(context,
                                                index == 0 ? 'first' : 'Second')
                                            .then((_) {
                                          if (index == 0) {
                                            if (eventController
                                                    .reminderDateFirsrt.text !=
                                                "") {
                                              arabicFirstDate.text =
                                                  translateDateFormatToArabic(
                                                      eventController
                                                          .reminderDateFirsrt
                                                          .text);
                                            }
                                          } else {
                                            if (eventController
                                                    .reminderDateSecond.text !=
                                                "") {
                                              arabicSecondDate.text =
                                                  translateDateFormatToArabic(
                                                      eventController
                                                          .reminderDateSecond
                                                          .text);
                                            }
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                        width: width,
                                        child: ColumnRequestData(
                                          fillColor: Colors.transparent,
                                          title: "Date",
                                          textController: Get.locale
                                                  .toString()
                                                  .contains('en')
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
                                          suffixUrl:
                                              "assets/icons/newCalenderFixed.svg",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.015.h,
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
                                                        .text = DateFormat(
                                                            'hh:mm a')
                                                        .format(newDateTime);
                                                    arabicFirstTime.text =
                                                        convertTimeToArabic(
                                                            DateFormat(
                                                                    'hh:mm a')
                                                                .format(
                                                                    newDateTime));
                                                  } else {
                                                    eventController
                                                        .reminderTimeSecond
                                                        .text = DateFormat(
                                                            'hh:mm a')
                                                        .format(newDateTime);
                                                    arabicSecondTime.text =
                                                        convertTimeToArabic(
                                                            DateFormat(
                                                                    'hh:mm a')
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
                                          textController: Get.locale
                                                  .toString()
                                                  .contains('en')
                                              ? (index == 0
                                                  ? eventController
                                                      .reminderTimeFirsrt
                                                  : eventController
                                                      .reminderTimeSecond)
                                              : (index == 0
                                                  ? arabicFirstTime
                                                  : arabicSecondTime),
                                          // textController: widget.isGroupEdit == true
                                          //     ? null
                                          //     : desciption,

                                          controllerState: (value) {
                                            setState(() {
                                              print(
                                                  'value description ${value!}');
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 0.015.h),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  eventController.reminders
                                                      .removeAt(index);
                                                });
                                              },
                                              child: SvgPicture.asset(
                                                "assets/icons/trashIcon.svg",
                                                height: 0.03.h,
                                                color: MyThemeData.block,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                    ),
              !eventController.sendReminders
                  ? const SizedBox.shrink()
                  : CustomBlackButton(
                      buttonText: "Add More Notifications".tr,
                      //: "assets/icons/plusIcon.svg",
                      onPressed: () {
                        setState(() {
                          eventController.reminders.isEmpty
                              ? eventController.reminders.add(Reminder(
                                  date: eventController.reminderDateFirsrt.text,
                                  time:
                                      eventController.reminderTimeFirsrt.text))
                              : eventController.reminders.add(Reminder(
                                  date: eventController.reminderDateSecond.text,
                                  time:
                                      eventController.reminderTimeSecond.text));
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
                          ? MyThemeData.signOut
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
                          fontSize: FontConstants.fontSize015.h,
                          color: eventController.requiredApproval
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : MyThemeData.colorGrey,
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
                                        MyThemeData.lightTheme
                                    ? Theme.of(context)
                                        .colorScheme
                                        .scrim
                                        .withOpacity(0.6)
                                    : MyThemeData.colorWhite),
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
                                      jobTitle: eventController
                                          .requiredEmployee!.role,
                                      name: eventController
                                          .requiredEmployee!.name,
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
                                              eventController
                                                  .requiredEmployee!),
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
                                                    nameInArabic: eventController
                                                        .requiredApprovalEmployeesList[
                                                            firstIndex]
                                                        .arabicName,
                                                    departmentInArabic:
                                                        eventController
                                                            .requiredApprovalEmployeesList[
                                                                firstIndex]
                                                            .arabicDepartment,
                                                    department: eventController
                                                        .requiredApprovalEmployeesList[
                                                            firstIndex]
                                                        .department,
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
                                                    nameInArabic: eventController
                                                        .requiredApprovalEmployeesList[
                                                            secondIndex]
                                                        .arabicName,
                                                    departmentInArabic:
                                                        eventController
                                                            .requiredApprovalEmployeesList[
                                                                secondIndex]
                                                            .arabicDepartment,
                                                    department: eventController
                                                        .requiredApprovalEmployeesList[
                                                            secondIndex]
                                                        .department,
                                                    jobTitle: eventController
                                                        .requiredApprovalEmployeesList[
                                                            secondIndex]
                                                        .role,
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
                                                    nameInArabic: eventController
                                                        .requiredApprovalEmployeesList[
                                                            thirdIndex]
                                                        .arabicName,
                                                    departmentInArabic:
                                                        eventController
                                                            .requiredApprovalEmployeesList[
                                                                thirdIndex]
                                                            .arabicDepartment,
                                                    department: eventController
                                                        .requiredApprovalEmployeesList[
                                                            thirdIndex]
                                                        .department,
                                                    jobTitle: eventController
                                                        .requiredApprovalEmployeesList[
                                                            thirdIndex]
                                                        .role,
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
                                                    nameInArabic: eventController
                                                        .requiredApprovalEmployeesList[
                                                            fourthIndex]
                                                        .arabicName,
                                                    departmentInArabic:
                                                        eventController
                                                            .requiredApprovalEmployeesList[
                                                                fourthIndex]
                                                            .arabicDepartment,
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
      ),
    );
  }
}
