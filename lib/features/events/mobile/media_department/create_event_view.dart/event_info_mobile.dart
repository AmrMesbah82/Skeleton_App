import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

class EventInformationMobile extends StatefulWidget {
  EventInformationMobile({
    super.key,
    this.event,
    this.isEdit = false,
  });

  final EventModel? event;
  bool? isEdit;

  @override
  State<EventInformationMobile> createState() => _EventInformationMobileState();
}

class _EventInformationMobileState extends State<EventInformationMobile> {
  final EventController eventController = Get.put(EventController());

  String? departmentOwner;

  @override
  void initState() {
    // TODO: implement initState

    if (widget.event == null) {
    } else {
      eventController.eventNameEnglish = TextEditingController(
        text: widget.event?.eventNameEnglish,
      );
      eventController.eventNameArabic =
          TextEditingController(text: widget.event?.eventNameArabic);
      eventController.summary =
          TextEditingController(text: widget.event?.summary);
      eventController.summaryArabic =
          TextEditingController(text: widget.event?.summaryArabic);
      eventController.agenda =
          TextEditingController(text: widget.event?.agenda);
      eventController.agendaArabic =
          TextEditingController(text: widget.event?.agendaArabic);
      eventController.departmentOwner = widget.event?.departmentOwner;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double height = 0.01.h;
    return Container(); /*GetBuilder<EventController>(
      builder: (eventController) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.04.w, vertical: 0.0.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.02.h,),
              SizedBox(
                width: double.infinity,
                child: ColumnRequestData(
                  fillColor: Theme.of(context).colorScheme.inversePrimary,
                  title: "Name Of Event (English)",
                   textDirection: TextDirection.ltr,
                                    mainAxisAlignment:
                                        Get.locale.toString().contains('en')
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.end,
                  isTextField: true,
                  hint: "Text Here",
                  isOptional: false,
                  isExpanded: true,
                  isRequired: true,
                  hasPrefix: true,
                  textController: eventController.eventNameEnglish,
                  controllerState: (value) {},
                ),
              ),
              SizedBox(
                height: 0.01.h,
              ),
              SizedBox(
                width: double.infinity,
                child: ColumnRequestData(
                  fillColor: Theme.of(context).colorScheme.inversePrimary,
                  title: "(العربية) اسم الحدث",
                    textDirection: TextDirection.rtl,
                                    mainAxisAlignment:
                                        Get.locale.toString().contains('en')
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                  isTextField: true,
                  hint: "اكتب هنا",
                  isRequired: true,
                  isArabic: true,
                  isOptional: false,
                  isExpanded: true,
                  hasPrefix: true,
                  textController: eventController.eventNameArabic,
                  controllerState: (value) {},
                ),
              ),
              SizedBox(
                height: height,
              ),
              ColumnRequestData(
                title: "Description (English)",
                isTextField: true,
                hint: "Text Here",
                fillColor: themeController.currentTheme ==
                                            AppColors.lightTheme
                                        ? AppColors.colorLightGrey
                                        : AppColors.colorBlack,
                isRequired: true,
                isOptional: false,
                isExpanded: true,
              isDescription: true,
                textController: eventController.summary,
                // textController: widget.isGroupEdit == true
                //     ? null
                //     : desciption,
                maxlines: 16,
                controllerfinishState: (value) {},
                 textDirection: TextDirection.ltr,
                                    mainAxisAlignment:
                                        Get.locale.toString().contains('en')
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.end,
                controllerState: (value) {},
                maxlength: 600,
              ),
              SizedBox(
                height: height,
              ),
              ColumnRequestData(
                title: "ملخص الحدث",
                isTextField: true,
                hint: "اكتب هنا",
                isRequired: true,
                isArabic: true,
                 fillColor: themeController.currentTheme ==
                                            AppColors.lightTheme
                                        ? AppColors.colorLightGrey
                                        : AppColors.colorBlack,
                isOptional: false,
                isExpanded: true,
                isSetting: true,
                textController: eventController.summaryArabic,
                // textController: widget.isGroupEdit == true
                //     ? null
                //     : desciption,
                maxlines: 16,
                controllerfinishState: (value) {},
                 textDirection: TextDirection.rtl,
                                    mainAxisAlignment:
                                        Get.locale.toString().contains('en')
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                controllerState: (value) {},
                maxlength: 600,
              ),
              SizedBox(
                height: height,
              ),
              ColumnRequestData(
                title: "Agenda (English)",
                isTextField: true,
                hint: "Text Here",
                isOptional: false,
                isRequired: true,
                isExpanded: true,
                 fillColor: themeController.currentTheme ==
                                            AppColors.lightTheme
                                        ? AppColors.colorLightGrey
                                        : AppColors.colorBlack,
                isSetting: true,
                textController: eventController.agenda,
                // textController: widget.isGroupEdit == true
                //     ? null
                //     : desciption,
                maxlines: 7,
                controllerfinishState: (value) {},
                 textDirection: TextDirection.ltr,
                                    mainAxisAlignment:
                                        Get.locale.toString().contains('en')
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.end,
                controllerState: (value) {},
                maxlength: 200,
              ),
              SizedBox(
                height: height,
              ),
              ColumnRequestData(
                title: "جدول اعمال الحدث",
                isTextField: true,
                hint: "اكتب هنا",
                 fillColor: themeController.currentTheme ==
                                            AppColors.lightTheme
                                        ? AppColors.colorLightGrey
                                        : AppColors.colorBlack,
                isOptional: false,
                isRequired: true,
                isExpanded: true,
                isArabic: true,
                isSetting: true,
                textController: eventController.agendaArabic,
                // textController: widget.isGroupEdit == true
                //     ? null
                //     : desciption,
                maxlines: 7,
                controllerfinishState: (value) {},
                 textDirection: TextDirection.rtl,
                                    mainAxisAlignment:
                                        Get.locale.toString().contains('en')
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                controllerState: (value) {},
                maxlength: 200,
              ),
               SizedBox(height: 0.01.h,),
              ColumnRequestData(
                fillColor:
                    themeController.currentTheme == AppColors.lightTheme
                        ? AppColors.colorLightGrey
                        : AppColors.colorBlack,
                title: "Department Owner",
                isTextField: false,
                buttonWidth: double.infinity,
                dropWidth: 0.85.w,
                hint: "Name",
                hasPrefix: true,
                isOptional: false,
                isExpanded: true,
                dropDownItems: Get.locale.toString().contains('en')
                    ? eventController.departmentList
                    : eventController.departmentArabicList,
                dropdownValue: eventController.departmentOwner != null
                    ? (Get.locale.toString().contains('en')
                        ? eventController.departmentOwner
                        : eventController.departmentArabicList[eventController
                            .departmentList
                            .indexOf(eventController.departmentOwner!)])
                    : eventController.departmentOwner,
                dropDownValueState: (value) {
                  setState(() {
                    eventController.departmentOwner =
                        Get.locale.toString().contains('en')
                            ? value
                            : eventController.departmentList[eventController
                                .departmentArabicList
                                .indexOf(value!)];
                  });
                },
              ),
              SizedBox(height: 0.01.h,),
            ],
          ),
        ),
      ),
    );
 */ }
}
