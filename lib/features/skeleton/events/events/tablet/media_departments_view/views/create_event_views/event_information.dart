import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/skeleton/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

class EventInformation extends StatefulWidget {
  const EventInformation({super.key, this.event});
  final EventModel? event;

  @override
  State<EventInformation> createState() => _EventInformationState();
}

class _EventInformationState extends State<EventInformation> {
  final EventController eventController = Get.put(EventController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double height = 0.01.h;
    return GetBuilder<EventController>(
      builder: (eventController) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.02.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ColumnRequestData(
                    fillColor: Theme.of(context).colorScheme.inversePrimary,
                    title: "Name Of Event (English)",
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: Get.locale.toString().contains('en')
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    isTextField: true,
                    hint: "Text Here ",
                    isOptional: false,
                    isExpanded: true,
                    hasPrefix: true,
                    isRequired: true,
                    textController: eventController.eventNameEnglish,
                    controllerState: (value) {},
                  ),
                ),
                SizedBox(
                  width: 0.02.w,
                ),
                Expanded(
                  child: ColumnRequestData(
                    fillColor: Theme.of(context).colorScheme.inversePrimary,
                    title: "(العربية) اسم الحدث",
                    mainAxisAlignment: Get.locale.toString().contains('en')
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    isArabic: true,
                    isTextField: true,
                    hint: "اكتب هنا",
                    isOptional: false,
                    isRequired: true,
                    isExpanded: true,
                    hasPrefix: true,
                    textController: eventController.eventNameArabic,
                    controllerState: (value) {},
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height,
            ),
            ColumnRequestData(
              title: "Summary (English)",
              isTextField: true,
              hint: "Text Here",
              isOptional: false,
              fillColor: themeController.currentTheme == MyThemeData.lightTheme
                  ? MyThemeData.colorLightGrey
                  : MyThemeData.colorBlack,
              isRequired: true,
              isExpanded: true,
              isDescription: true,
              textController: eventController.summary,
              // textController: widget.isGroupEdit == true
              //     ? null
              //     : desciption,
              maxlines: 16,
              controllerfinishState: (value) {},
              textDirection: TextDirection.ltr,
              mainAxisAlignment: Get.locale.toString().contains('en')
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
              fillColor: themeController.currentTheme == MyThemeData.lightTheme
                  ? MyThemeData.colorLightGrey
                  : MyThemeData.colorBlack,
              isOptional: false,
              isExpanded: true,
              isDescription: true,
              textController: eventController.summaryArabic,
              maxlines: 16,
              controllerfinishState: (value) {},
              mainAxisAlignment: Get.locale.toString().contains('en')
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              textDirection: TextDirection.rtl,
              controllerState: (value) {},
              maxlength: 600,
            ),
            SizedBox(
              height: height,
            ),
            ColumnRequestData(
              title: "Agenda (English)",
              isRequired: true,
               fillColor: themeController.currentTheme == MyThemeData.lightTheme
                  ? MyThemeData.colorLightGrey
                  : MyThemeData.colorBlack,
              isTextField: true,
              hint: "Text Here",
              isOptional: false,
              isExpanded: true,
              isDescription: true,
              textController: eventController.agenda,
              // textController: widget.isGroupEdit == true
              //     ? null
              //     : desciption,
              maxlines: 7,
              controllerfinishState: (value) {},
              textDirection: TextDirection.ltr,
              mainAxisAlignment: Get.locale.toString().contains('en')
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
              isRequired: true,
              hint: "اكتب هنا",
               fillColor: themeController.currentTheme == MyThemeData.lightTheme
                  ? MyThemeData.colorLightGrey
                  : MyThemeData.colorBlack,
              isOptional: false,
              isExpanded: true,
              isArabic: true,
              isDescription: true,
              textController: eventController.agendaArabic,
              maxlines: 7,
              controllerfinishState: (value) {},
              mainAxisAlignment: Get.locale.toString().contains('en')
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              textDirection: TextDirection.rtl,
              controllerState: (value) {},
              maxlength: 200,
            ),
            Row(
              children: [
                Expanded(
                  child: ColumnRequestData(
                    fillColor:
                        themeController.currentTheme == MyThemeData.lightTheme
                            ? MyThemeData.colorLightGrey
                            : MyThemeData.colorBlack,
                    isRequired: true,
                    title: "Department Owner",
                    isTextField: false,
                    buttonWidth: double.infinity,
                    dropWidth: isVertical ? 0.2.w : 0.4.w,
                    hint: "Name",
                    hasPrefix: true,
                    isOptional: false,
                    isExpanded: true,
                    dropDownItems: Get.locale.toString().contains('en')
                        ? eventController.departmentList
                        : eventController.departmentArabicList,
                    dropdownValue: eventController.departmentOwner != null
                        ? (Get.locale.toString().contains('en')
                            ? eventController.departmentOwner!.capitalize
                            : eventController.departmentArabicList[
                                eventController.departmentList.indexOf(
                                    eventController
                                        .departmentOwner!.capitalize!)])
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
                ),
                SizedBox(
                  width: 0.02.w,
                ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
