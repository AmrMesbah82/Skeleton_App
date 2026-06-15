import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/todo_module/core/components/calendar_components.dart/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/features/todo_module/core/components/calendar_components.dart/calender_package/src/widgets/calendar_date_picker2.dart';
import 'package:demo_app/core/theme/font_manager.dart';

import 'package:demo_app/features/todo_module/core/constants/screen_size.dart';
import 'package:demo_app/core/theme/my_theme.dart';

// ignore: must_be_immutable
class CustomCalendarPicker extends StatefulWidget {
  CustomCalendarPicker(
      {super.key,
      required this.calendarType,
      required this.selectedDate,
      required this.selectedDateState});
  final CalendarDatePicker2Type calendarType;
  List<DateTime?> selectedDate;
  ValueChanged<List<DateTime?>> selectedDateState;

  @override
  State<CustomCalendarPicker> createState() => _CustomCalendarPickerState();
}

class _CustomCalendarPickerState extends State<CustomCalendarPicker> {
  List<DateTime> selectedDate = [DateTime.now()];

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker2(
      config: CalendarDatePicker2Config(
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        rangeBidirectional: true,
        calendarViewMode: DatePickerMode.day,
        centerAlignModePicker: true,
        dayBorderRadius: BorderRadius.circular(8),
        lastMonthIcon: Transform.rotate(
          angle: Get.locale.toString().contains('en') ? 0 : 3.14,
          child: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            // ignore: deprecated_member_use
            color: const Color(0xFFE5B800),
          ),
        ),
        nextMonthIcon: Transform.rotate(
          angle: Get.locale.toString().contains('en') ? 3.14 : 0,
          child: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            // ignore: deprecated_member_use
            color: const Color(0xFFE5B800),
          ),
        ),
        weekdayLabelTextStyle: AppFontStyle.cairoRegularStyle.copyWith(
          fontSize: FontConstants.fontSize023.h,
          fontWeight: FontWeight.w600,
          color: MyThemeData.switchSettings,
        ),
        controlsTextStyle: AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: FontConstants.fontSize023.h,
            fontWeight: FontWeight.w600,
            color: MyThemeData.switchSettings,
            height: 1.45),
        selectedYearTextStyle: AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: FontConstants.fontSize023.h,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onInverseSurface),
        selectedDayHighlightColor: MyThemeData.switchSettings,
        dayTextStyle: AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: FontConstants.fontSize023.h,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.inverseSurface),
        selectedDayTextStyle: AppFontStyle.cairoRegularStyle.copyWith(
          fontSize: FontConstants.fontSize023.h,
          fontWeight: FontWeight.w500,
          height: 0.0019.h,
          color: MyThemeData.colorWhite,
        ),
        selectedRangeDayTextStyle: AppFontStyle.cairoRegularStyle.copyWith(
          fontSize: FontConstants.fontSize023.h,
          fontWeight: FontWeight.w500,
          color: MyThemeData.colorWhite,
          height: 0.0019.h,
        ),
        yearTextStyle: AppFontStyle.cairoRegularStyle.copyWith(
          fontSize: FontConstants.fontSize023.h,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
        todayTextStyle: AppFontStyle.cairoRegularStyle.copyWith(
          fontSize: FontConstants.fontSize023.h,
          fontWeight: FontWeight.w500,
          height: 0.0019.h,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
        selectedRangeHighlightColor: MyThemeData.bubbleColor,
        customModePickerIcon: Container(),
        calendarType: widget.calendarType,
      ),
      value: widget.selectedDate,
      onValueChanged: ((value) {
        setState(() {
          widget.selectedDate = value;
          widget.selectedDateState(widget.selectedDate);
        });
      }),
    );
  }
}
