import 'dart:developer';

import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/shared_components/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/core/shared_components/date_picker_class.dart';
import 'package:demo_app/core/widgets/cupertino_time_picker.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

class AddInfoEvent extends StatefulWidget {
  const AddInfoEvent({
    super.key,
    this.event,
  });
  final EventModel? event;

  @override
  State<AddInfoEvent> createState() => _AddInfoEventState();
}

class _AddInfoEventState extends State<AddInfoEvent> {
  final EventController eventController = Get.put(EventController());
  TextEditingController arabicEventDate = TextEditingController();
  TextEditingController arabicEventTime = TextEditingController();
  TextEditingController arabicRoomNumber = TextEditingController();
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
    if (picked != null &&
        picked != selectedDate &&
        picked[0]!.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      setState(() {
        _rangeDatePickerValueWithDefaultValue = picked;
        selectedDate = picked[0];
        final DateFormat formatter = DateFormat('dd MMM yyyy');
        String formattedDate = formatter.format(picked[0] as DateTime);
        String formattedDate2 = formatter.format(picked.last as DateTime);
        eventController.date.text =
            "${picked[0]!.day} ${DateFormat.MMM().format(picked[0]!)} ${picked[0]!.year}";
      });
    }
  }

  bool isToggled = false;
  bool isToggled2 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.event == null) {
    } else {
      eventController.date = TextEditingController(text: widget.event?.date);
      if (widget.event != null) {
        arabicEventDate.text = translateDateFormatToArabic(widget.event!.date);
        arabicEventTime.text = convertTimeToArabic(widget.event!.time);
      }
      eventController.time = TextEditingController(text: widget.event?.time);
      eventController.type = widget.event?.type;
      eventController.flyer = TextEditingController(text: widget.event?.flyer);
      eventController.isRemote =
          widget.event == null ? false : widget.event!.isRemote;
      eventController.isOnsite =
          widget.event == null ? false : widget.event!.isOnsite;
      eventController.remoteUrl =
          TextEditingController(text: widget.event?.remoteUrl);
      eventController.onSiteAddress =
          TextEditingController(text: widget.event?.onSiteAddress);
      if (widget.event != null) {
        arabicRoomNumber = TextEditingController(
            text: convertNumberToArabic(widget.event!.onSiteAddress));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double height = 0.01.h;
    double width = isVertical ? 0.38.w : 0.4.w;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.02.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _selectDate(
                    context,
                  ).then((_) {
                    if (eventController.date.text != "") {
                      if (Get.locale.toString().contains("ar")) {
                        arabicEventDate.text = translateDateFormatToArabic(
                            eventController.date.text);
                      }
                    }
                  });
                },
                child: SizedBox(
                  width: width,
                  child: ColumnRequestData(
                    fillColor: Colors.transparent,
                    title: "Date",
                    textController: Get.locale.toString().contains('en')
                        ? eventController.date
                        : arabicEventDate,
                    isRequired: true,
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
              SizedBox(
                width: 0.02.w,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoTimePicker(
                        onDateTimeChanged: (DateTime newDateTime) {
                          setState(() {
                            eventController.time.text =
                                DateFormat('hh:mm a').format(newDateTime);
                            arabicEventTime.text = convertTimeToArabic(
                                DateFormat('hh:mm a').format(newDateTime));
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
                    isRequired: true,
                    hint: "Text here",
                    enabled: false,
                    isOptional: false,
                    hasPrefix: true,
                    isExpanded: true,
                    hasSuffix: true,
                    suffixUrl: "assets/icons/newTimeIconFixed.svg",
                    textController: Get.locale.toString().contains('en')
                        ? eventController.time
                        : arabicEventTime,
                    controllerState: (value) {
                      setState(() {
                        print('value description ${value!}');
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColumnRequestData(
                fillColor:
                    themeController.currentTheme == MyThemeData.lightTheme
                        ? MyThemeData.colorLightGrey
                        : MyThemeData.colorBlack,
                title: "Type",
                isTextField: false,
                buttonWidth: width,
                dropWidth: width,
                isRequired: true,
                hint: "Type",
                hasPrefix: true,
                isOptional: false,
                isExpanded: true,
                dropDownItems: Get.locale.toString().contains('en')
                    ? englishEventType
                    : arabicEventType,
                dropdownValue: eventController.type != null
                    ? (Get.locale.toString().contains('en')
                        ? eventController.type
                        : arabicEventType[
                            englishEventType.indexOf(eventController.type!)])
                    : eventController.type,
                dropDownValueState: (value) {
                  setState(() {
                    eventController.type = Get.locale.toString().contains('en')
                        ? value
                        : englishEventType[arabicEventType.indexOf(value!)];
                  });
                },
              ),
              SizedBox(
                width: 0.02.w,
              ),
              GestureDetector(
                onTap: eventController.addFlyer,
                child: SizedBox(
                  width: width,
                  child: ColumnRequestData(
                    fillColor: Colors.transparent,
                    title: "Flyer",
                    isRequired: true,
                    isTextField: true,
                    hint: "Upload Here",
                    enabled: false,
                    isOptional: false,
                    hasPrefix: true,
                    isExpanded: true,
                    prefixIcon: Transform.scale(
                      scale: 0.6,
                      child: SvgPicture.asset(
                        "assets/images/attachsquare_field.svg",
                        color: (themeController.currentTheme ==
                                MyThemeData.lightTheme
                            ? Theme.of(context)
                                .colorScheme
                                .scrim
                                .withOpacity(0.6)
                            : MyThemeData.colorWhite),
                      ),
                    ),
                    textController: eventController.flyer,
                    // textController: widget.isGroupEdit == true
                    //     ? null
                    //     : desciption,

                    controllerState: (value) {},
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: height * 2,
          ),
          RichText(
              text: TextSpan(
                  text: "Event Venue".tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isVertical
                          ? FontConstants.fontSize019.h
                          : FontConstants.fontSize022.h,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface,
                      height: 1.6),
                  children: [
                WidgetSpan(
                    child: SizedBox(
                  width: 0.01.w,
                )),
                TextSpan(
                    text: "*".tr,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isVertical
                          ? FontConstants.fontSize019.h
                          : FontConstants.fontSize022.h,
                      fontWeight: FontWeight.w600,
                      color: MyThemeData.delete,
                    ))
              ])),
          SizedBox(
            height: height,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      eventController.isRemote = !eventController.isRemote;
                      eventController.isRemote == true
                          ? eventController.isOnsite = false
                          : eventController.isOnsite = true;
                    });
                  },
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        eventController.isRemote
                            ? 'assets/icons/CheckListOn.svg'
                            : 'assets/icons/CheckListOff.svg',
                        color: eventController.isRemote
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
                          "Remote".tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: FontConstants.fontSize015.w,
                            color: eventController.isRemote
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                : MyThemeData.colorGrey,
                            height: 1.2,
                            fontWeight: eventController.isRemote
                                ? FontWeight.w400
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 0.02.w,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      eventController.isOnsite = !eventController.isOnsite;
                      eventController.isOnsite == true
                          ? eventController.isRemote = false
                          : eventController.isRemote = true;
                    });
                  },
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        eventController.isOnsite
                            ? 'assets/icons/CheckListOn.svg'
                            : 'assets/icons/CheckListOff.svg',
                        color: eventController.isOnsite
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
                          "On Site".tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: FontConstants.fontSize015.w,
                            color: eventController.isOnsite
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                : MyThemeData.colorGrey,
                            height: 1.2,
                            fontWeight: eventController.isOnsite
                                ? FontWeight.w400
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 0.01.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              !eventController.isRemote
                  ? Container()
                  : SizedBox(
                      width: width,
                      child: ColumnRequestData(
                        fillColor: Colors.transparent,
                        title: "",
                        hideTitle: true,
                        isTextField: true,
                        hint: "Type Link Here",
                        isOptional: false,
                        isExpanded: true,
                        hasPrefix: true,
                        textController: eventController.remoteUrl,
                        controllerState: (value) {
                          setState(() {
                            print('value Delegation ${value!}');
                          });
                        },
                      ),
                    ),
              !eventController.isOnsite
                  ? Container()
                  : SizedBox(
                      width: width,
                      child: ColumnRequestData(
                        fillColor: Colors.transparent,
                        title: "",
                        hideTitle: true,
                        isTextField: true,
                        hint: "Room Number",
                        isOptional: false,
                        isExpanded: true,
                        hasPrefix: true,
                        textController: Get.locale.toString().contains('en')
                            ? eventController.onSiteAddress
                            : arabicRoomNumber,
                        controllerState: (value) {
                          setState(() {
                            eventController.onSiteAddress.text =
                                convertNumberToEnglish(value!);
                            log('value Delegation ${eventController.onSiteAddress.text}');
                          });
                        },
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}
