import 'dart:developer';
import 'package:demo_app/core/theme/app_colors.dart';

import 'package:demo_app/features/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/shared_components/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/core/shared_components/date_picker_class.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';


import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/controllers/employee_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

class FilterEventDialog extends StatefulWidget {
  FilterEventDialog(
      {super.key,
      required this.departmentDropDownItems,
      required this.departmentState,
      required this.departmentValue,
      required this.typeDropDownItems,
      required this.typeValue,
      required this.typetState,
      required this.dateValue,
      required this.dateValueState,
      this.status,
      this.statusState,
      this.statusDropDownItems,
      required this.onReset,
      required this.isEmployee,
      required this.isSurvey});
  String? departmentValue;
  List<String> departmentDropDownItems;
  ValueChanged<String?>? departmentState;
  String? typeValue;
  List<String> typeDropDownItems;
  ValueChanged<String?>? typetState;
  String dateValue;
  ValueChanged<String>? dateValueState;
  String? status;
  ValueChanged<String?>? statusState;
  List<String>? statusDropDownItems;
  final bool isEmployee;
  final bool isSurvey;
  Function() onReset;

  @override
  State<FilterEventDialog> createState() => _FilterEventDialogState();
}

class _FilterEventDialogState extends State<FilterEventDialog> {
  EventController eventController = Get.put(EventController());
  EventsEmployeeController employeeController = Get.put(EventsEmployeeController());
  SurveyController surveyController = Get.put(SurveyController());

  TextEditingController date = TextEditingController();
  TextEditingController arabicDate = TextEditingController();
  String? tempEnglishDate;
  String? tempEnglishDepOwner;
  String? tempEnglishType;
  String? tempEnglishStatus;
  DateTime? selectedDate;
  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [];
  Future<void> _selectDate(BuildContext context) async {
    final List<DateTime?>? picked = await DatePicker().showDatePicker(
        context,
        _rangeDatePickerValueWithDefaultValue,
        DateTime.now(),
        CalendarDatePicker2Type.range);
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
        tempEnglishDate =
            "${'From'} ${picked[0]!.day} ${DateFormat.MMM().format(picked[0]!)} ${picked[0]!.year} ${'To'} ${picked.last!.day} ${DateFormat.MMM().format(picked.last!)} ${picked.last!.year}";
        // widget.isEmployee
        //     ? employeeController.dateFilter = widget.dateValue
        //     : eventController.dateFilter = widget.dateValue;
        // widget.dateValueState!(widget.dateValue);

        date.text = tempEnglishDate!;
      });
    }
  }

  @override
  void initState() {
    if (widget.isEmployee) {
      tempEnglishStatus = employeeController.statusFilter;
      tempEnglishDepOwner = employeeController.departmetFilter;
      tempEnglishType = employeeController.typeFilter;
      date.text = employeeController.dateFilter;
      if (Get.locale.toString().contains("ar") &&
          employeeController.dateFilter != "") {
        log(" Arabic Date : $date");
        String fromDate;
        String toDate;
        if (employeeController.dateFilter.contains("To")) {
          fromDate = employeeController.dateFilter.split("To ").first;
          fromDate = fromDate.replaceFirst("From ", "");
          toDate = employeeController.dateFilter.split("To ").last;
        } else {
          fromDate = employeeController.dateFilter.replaceFirst("From ", "");
          toDate = fromDate;
        }
        fromDate = translateDateFormatToArabic(fromDate.trim());
        toDate = translateDateFormatToArabic(toDate.trim());
        arabicDate.text = "من $fromDate الي $toDate";
        log(" Arabic Date : $arabicDate");
      }
    } else {
      if (widget.isSurvey) {
        tempEnglishDepOwner = surveyController.departmetFilter;
        tempEnglishType = surveyController.typeFilter;
        date.text = surveyController.dateFilter;

        if (Get.locale.toString().contains("ar") &&
            surveyController.dateFilter != "") {
          log(" Arabic Date : $date");
          String fromDate;
          String toDate;
          if (surveyController.dateFilter.contains("To")) {
            fromDate = surveyController.dateFilter.split("To ").first;
            fromDate = fromDate.replaceFirst("From ", "");
            toDate = surveyController.dateFilter.split("To ").last;
          } else {
            fromDate = surveyController.dateFilter.replaceFirst("From ", "");
            toDate = fromDate;
          }
          fromDate = translateDateFormatToArabic(fromDate.trim());
          toDate = translateDateFormatToArabic(toDate.trim());
          arabicDate.text = "من $fromDate الي $toDate";
          log(" Arabic Date : $arabicDate");
        }
      } else {
        tempEnglishDepOwner = eventController.departmetFilter;
        tempEnglishType = eventController.typeFilter;
        date.text = eventController.dateFilter;

        if (Get.locale.toString().contains("ar") &&
            eventController.dateFilter != "") {
          log(" Arabic Date : $date");
          String fromDate;
          String toDate;
          if (eventController.dateFilter.contains("To")) {
            fromDate = eventController.dateFilter.split("To ").first;
            fromDate = fromDate.replaceFirst("From ", "");
            toDate = eventController.dateFilter.split("To ").last;
          } else {
            fromDate = eventController.dateFilter.replaceFirst("From ", "");
            toDate = fromDate;
          }
          fromDate = translateDateFormatToArabic(fromDate.trim());
          toDate = translateDateFormatToArabic(toDate.trim());
          arabicDate.text = "من $fromDate الي $toDate";
          log(" Arabic Date : $arabicDate");
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    double dropdownWidthVert = 0.365.w;
    double dropdownWidthHori = 0.275.w;
    return Container(); /*Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? (isPortrait ? 0.1.w : 0.2.w) : 0.1.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isPortrait ? 0.025.w : 0.015.w,
              vertical: isPortrait ? 0.015.h : 0.015.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FiltersAppBar(
                imageUrl: "assets/images/filter_table.svg",
                title: "Filter",
                iconColor: AppColors.textButton,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: isTablet
                            ? (isPortrait
                                ? dropdownWidthVert
                                : dropdownWidthHori)
                            : 0.75.w,
                        child: CustomDropdownButton2(
                          hint: "Department Owner",
                          borded: false,
                          buttonHeight: isPortrait ?0.05.h : 0.055.h,
                          dropdownWidth: isTablet
                              ? (isPortrait
                                  ? dropdownWidthVert
                                  : dropdownWidthHori)
                              : 0.75.w,
                          buttonColor: themeController.currentTheme ==
                                  AppColors.lightTheme
                              ? null
                              : AppColors.colorBlack,
                          backColor: themeController.currentTheme ==
                                  AppColors.lightTheme
                              ? Colors.transparent
                              : AppColors.colorBlack,
                          buttonWidth: isTablet
                              ? (isPortrait
                                  ? dropdownWidthVert
                                  : dropdownWidthHori)
                              : double.infinity,
                          buttonPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 0.01.w : 0.02.w),
                          value: tempEnglishDepOwner != null
                              ? (Get.locale.toString().contains('en')
                                  ? tempEnglishDepOwner
                                  : eventController.departmentArabicList[
                                      eventController.departmentList
                                          .indexOf(tempEnglishDepOwner!)])
                              : tempEnglishDepOwner,
                          dropdownItems: Get.locale.toString().contains('en')
                              ? eventController.departmentList
                              : eventController.departmentArabicList,
                          onChanged: (value) {
                            setState(() {
                              tempEnglishDepOwner =
                                  Get.locale.toString().contains('en')
                                      ? value
                                      : eventController.departmentList[
                                          eventController.departmentArabicList
                                              .indexOf(value!)];
                              // widget.departmentState!(widget.departmentValue);
                            });
                          },
                        ),
                      ),
                      isTablet
                          ? SizedBox(
                              width: 0.02.w,
                            )
                          : const SizedBox.shrink(),
                      isTablet
                          ? CustomDropdownButton2(
                              hint: "Type",
                              borded: false,
                              buttonHeight: isPortrait ?0.05.h : 0.055.h,
                              dropdownWidth: isTablet
                                  ? (isPortrait
                                      ? dropdownWidthVert
                                      : dropdownWidthHori)
                                  : 0.35.w,
                              buttonWidth: isTablet
                                  ? (isPortrait
                                      ? dropdownWidthVert
                                      : dropdownWidthHori)
                                  : 0.35.w,
                              buttonColor: themeController.currentTheme ==
                                      AppColors.lightTheme
                                  ? null
                                  : AppColors.colorBlack,
                              backColor: themeController.currentTheme ==
                                      AppColors.lightTheme
                                  ? Colors.transparent
                                  : AppColors.colorBlack,
                              buttonPadding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 0.01.w : 0.02.w),
                              value: tempEnglishType != null
                                  ? (Get.locale.toString().contains('en')
                                      ? tempEnglishType
                                      : arabicEventType[englishEventType
                                          .indexOf(tempEnglishType!)])
                                  : tempEnglishType,
                              dropdownItems:
                                  Get.locale.toString().contains('en')
                                      ? englishEventType
                                      : arabicEventType,
                              onChanged: (value) {
                                setState(() {
                                  tempEnglishType =
                                      Get.locale.toString().contains('en')
                                          ? value
                                          : englishEventType[
                                              arabicEventType.indexOf(value!)];
                                  // widget.typetState!(widget.typeValue);
                                });
                              },
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  SizedBox(
                    height: 0.02.h,
                  ),
                  isTablet
                      ? const SizedBox.shrink()
                      : CustomDropdownButton2(
                          hint: "Type",
                          borded: false,
                          buttonHeight: isPortrait ?0.05.h : 0.055.h,
                          dropdownWidth: isTablet
                              ? (isPortrait
                                  ? dropdownWidthVert
                                  : dropdownWidthHori)
                              : 0.75.w,
                          buttonWidth: isTablet
                              ? (isPortrait
                                  ? dropdownWidthVert
                                  : dropdownWidthHori)
                              : double.infinity,
                          buttonColor: themeController.currentTheme ==
                                  AppColors.lightTheme
                              ? null
                              : AppColors.colorBlack,
                          backColor: themeController.currentTheme ==
                                  AppColors.lightTheme
                              ? Colors.transparent
                              : AppColors.colorBlack,
                          buttonPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 0.01.w : 0.02.w),
                          value: tempEnglishType != null
                              ? (Get.locale.toString().contains('en')
                                  ? tempEnglishType
                                  : arabicEventType[englishEventType
                                      .indexOf(tempEnglishType!)])
                              : tempEnglishType,
                          dropdownItems: Get.locale.toString().contains('en')
                              ? englishEventType
                              : arabicEventType,
                          onChanged: (value) {
                            setState(() {
                              tempEnglishType =
                                  Get.locale.toString().contains('en')
                                      ? value
                                      : englishEventType[
                                          arabicEventType.indexOf(value!)];
                              // widget.typetState!(widget.typeValue);
                            });
                          },
                        ),
                  isTablet
                      ? const SizedBox.shrink()
                      : SizedBox(
                          height: 0.02.h,
                        ),
                  widget.isEmployee
                      ? isTablet
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: isTablet
                                      ? (isPortrait
                                          ? dropdownWidthVert
                                          : dropdownWidthHori)
                                      : 0.75.w,
                                  child: GestureDetector(
                                    onTap: () {
                                      _selectDate(
                                        context,
                                      ).then((_) {
                                        if (date.text != "") {
                                          // log("000000000000001 : $date");
                                          if (Get.locale
                                              .toString()
                                              .contains("ar")) {
                                            // log("000000000000002 : $date");
                                            String fromDate;
                                            String toDate;
                                            if (date.text.contains("To")) {
                                              fromDate =
                                                  date.text.split("To ").first;
                                              fromDate = fromDate.replaceFirst(
                                                  "From ", "");
                                              toDate =
                                                  date.text.split("To ").last;
                                            } else {
                                              fromDate = date.text
                                                  .replaceFirst("From ", "");
                                              toDate = fromDate;
                                            }

                                            fromDate =
                                                translateDateFormatToArabic(
                                                    fromDate.trim());
                                            toDate =
                                                translateDateFormatToArabic(
                                                    toDate.trim());
                                            arabicDate.text =
                                                "من $fromDate الي $toDate";
                                          }
                                          // log("000000000000003 : $arabicDate");
                                        }
                                      });
                                    },
                                    child: ColumnRequestData(
                                      fillColor: Colors.transparent,
                                      title: "Date",
                                      textController:
                                          Get.locale.toString().contains("ar")
                                              ? arabicDate
                                              : date,
                                      hideTitle: true,
                                      sizerSuffix: 0.45,
                                      isTextField: true,
                                      hint: "Date",
                                      isOptional: false,
                                      isExpanded: true,
                                      enabled: false,
                                      hasPrefix: true,
                                      hasSuffix: true,
                                      suffixUrl: "assets/icons/newCalenderFixed.svg",
                                    ),
                                  ),
                                ),
                                CustomDropdownButton2(
                                  hint: "Status",
                                  borded: false,
                                  buttonHeight: isPortrait ?0.05.h : 0.055.h,
                                  dropdownWidth: isTablet
                                      ? (isPortrait
                                          ? dropdownWidthVert
                                          : dropdownWidthHori)
                                      : 0.75.w,
                                  buttonWidth: isTablet
                                      ? (isPortrait
                                          ? dropdownWidthVert
                                          : dropdownWidthHori)
                                      : double.infinity,
                                  buttonColor: themeController.currentTheme ==
                                          AppColors.lightTheme
                                      ? null
                                      : AppColors.colorBlack,
                                  backColor: themeController.currentTheme ==
                                          AppColors.lightTheme
                                      ? Colors.transparent
                                      : AppColors.colorBlack,
                                  buttonPadding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 0.01.w : 0.02.w),
                                  value: tempEnglishStatus != null
                                      ? (Get.locale.toString().contains('en')
                                          ? tempEnglishStatus
                                          : arabicInviteAndApproveStatus[widget
                                              .statusDropDownItems!
                                              .indexOf(tempEnglishStatus!)])
                                      : tempEnglishStatus,
                                  dropdownItems:
                                      Get.locale.toString().contains('en')
                                          ? widget.statusDropDownItems!
                                          : arabicInviteAndApproveStatus,
                                  onChanged: (value) {
                                    setState(() {
                                      tempEnglishStatus =
                                          Get.locale.toString().contains('en')
                                              ? value
                                              : widget.statusDropDownItems![
                                                  arabicInviteAndApproveStatus
                                                      .indexOf(value!)];
                                      // widget.statusState!(widget.status);
                                    });
                                  },
                                )
                              ],
                            )
                          : SizedBox(
                              width: isTablet
                                  ? (isPortrait
                                      ? dropdownWidthVert
                                      : dropdownWidthHori)
                                  : 0.75.w,
                              child: GestureDetector(
                                onTap: () {
                                  _selectDate(
                                    context,
                                  ).then((_) {
                                    if (date.text != "") {
                                      // log("111111111111 : $date");
                                      if (Get.locale
                                          .toString()
                                          .contains("ar")) {
                                        // log("1111111112 : $date");
                                        String fromDate;
                                        String toDate;
                                        if (date.text.contains("To")) {
                                          fromDate =
                                              date.text.split("To ").first;
                                          fromDate = fromDate.replaceFirst(
                                              "From ", "");
                                          toDate = date.text.split("To ").last;
                                        } else {
                                          fromDate = date.text
                                              .replaceFirst("From ", "");
                                          toDate = fromDate;
                                        }

                                        fromDate = translateDateFormatToArabic(
                                            fromDate.trim());
                                        toDate = translateDateFormatToArabic(
                                            toDate.trim());
                                        arabicDate.text =
                                            "من $fromDate الي $toDate";
                                      }
                                    }
                                  });
                                },
                                child: ColumnRequestData(
                                  fillColor: Colors.transparent,
                                  title: "Date",
                                  textController:
                                      Get.locale.toString().contains("ar")
                                          ? arabicDate.text == ""
                                              ? null
                                              : arabicDate
                                          : date.text == ""
                                              ? null
                                              : date,
                                  hideTitle: true,
                                  isTextField: true,
                                  hint: "Date",
                                  isOptional: false,
                                  isExpanded: true,
                                  enabled: false,
                                  hasPrefix: true,
                                  hasSuffix: true,
                                  suffixUrl: "assets/icons/newCalenderFixed.svg",
                                ),
                              ),
                            )
                      : SizedBox(
                          width: isTablet
                              ? (isPortrait
                                  ? dropdownWidthVert
                                  : dropdownWidthHori)
                              : 0.75.w,
                          child: GestureDetector(
                            onTap: () {
                              _selectDate(
                                context,
                              ).then((_) {
                                if (date.text != "") {
                                  // log("22222222221 : $date");
                                  if (Get.locale.toString().contains("ar")) {
                                    // log("22222222222 : $date");

                                    String fromDate;
                                    String toDate;
                                    if (date.text.contains("To")) {
                                      fromDate = date.text.split("To ").first;
                                      fromDate =
                                          fromDate.replaceFirst("From ", "");
                                      toDate = date.text.split("To ").last;
                                    } else {
                                      fromDate =
                                          date.text.replaceFirst("From ", "");
                                      toDate = fromDate;
                                    }

                                    fromDate = translateDateFormatToArabic(
                                        fromDate.trim());
                                    toDate = translateDateFormatToArabic(
                                        toDate.trim());
                                    arabicDate.text =
                                        "من $fromDate الي $toDate";
                                  }
                                  // log("22222222223 : $arabicDate");
                                }
                              });
                            },
                            child: ColumnRequestData(
                              fillColor: Colors.transparent,
                              title: "Date",
                              textController:
                                  Get.locale.toString().contains("ar")
                                      ? arabicDate.text == ""
                                          ? null
                                          : arabicDate
                                      : date.text == ""
                                          ? null
                                          : date,
                              hideTitle: true,
                              isTextField: true,
                              hint: "Date",
                              isOptional: false,
                              isExpanded: true,
                              enabled: false,
                              hasPrefix: true,
                              hasSuffix: true,
                              suffixUrl: "assets/icons/newCalenderFixed.svg",
                            ),
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 0.02.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.015.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MainCustomIconButton(
                      onPressed: widget.onReset,
                      buttonText: "Reset".tr,
       
                      buttonStyle: ElevatedButton.styleFrom(
                        minimumSize: isTablet
                            ? isPortrait
                                ? Size(0.15.w, 0.045.h)
                                : Size(0.07.w, 0.05.h)
                            : Size(0.36.w, 0.05.h),
                        backgroundColor:
                                AppColors.GreyBack,
                        shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          side: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                    MainCustomIconButton(
                      onPressed: () {
                        if (widget.isEmployee) {
                          widget.statusState!(tempEnglishStatus);
                          widget.departmentState!(tempEnglishDepOwner);
                          widget.typetState!(tempEnglishType);
                          widget.dateValueState!(date.text);
                          employeeController.searchforEventByFilterButtom();
                        } else {
                          widget.departmentState!(tempEnglishDepOwner);
                          widget.typetState!(tempEnglishType);
                          widget.dateValueState!(date.text);
                          if (widget.isSurvey) {
                            surveyController.searchforEventByFilterButtom();
                          } else {
                            eventController.searchforEventByFilterButtom();
                          }
                        }
                        eventController.update();
                        Navigator.pop(context);
                      },
                      buttonText: "Apply".tr,
                      buttonStyle: ElevatedButton.styleFrom(
                        minimumSize: isTablet
                            ? isPortrait
                                ? Size(0.15.w, 0.045.h)
                                : Size(0.07.w, 0.05.h)
                            : Size(0.36.w, 0.05.h),
                        backgroundColor: AppColors.signOut,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
*/  }
}
