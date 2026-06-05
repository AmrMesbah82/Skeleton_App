// Date Created :1/August/2023
// Developer Name : Mazen shabaan
//App Version : Version 1
// Date of Last Edit :8/October/2023
// Objectives: this class named CalendarHorizontal created to make the horizontal calendar date picker with its customization
// if you want to show the bar only or you want to pick multiple dates from calendar
//import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';
import 'package:demo_app/features/external/todo_module/core/components/calendar_components.dart/calendar_app_bar.dart';
import 'package:demo_app/features/external/todo_module/core/components/calendar_components.dart/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/features/external/todo_module/core/components/calendar_components.dart/date_picker_class.dart';
import 'package:demo_app/features/external/todo_module/core/constants/enum.dart';
import 'package:demo_app/features/external/todo_module/core/constants/haptic_controller.dart';
import 'package:demo_app/features/external/todo_module/core/constants/screen_size.dart';

// ignore: must_be_immutable
class CalendarHorizontal extends StatefulWidget {
  bool showDatePicker;
  DateTime? dateTimeNow;
  DateTime? lastDateTime;
  final ValueChanged<bool>? onCheckboxStateChanged;
  final ValueChanged<List<DateTime?>>? onDateChanged;
  final bool isHorizontal;
  CalendarHorizontal(
      {super.key,
      this.showDatePicker = true,
      this.dateTimeNow,
      this.lastDateTime,
      this.onCheckboxStateChanged,
      this.isHorizontal = false,
      this.onDateChanged});

  @override
  State<CalendarHorizontal> createState() => _CalendarHorizontalState();
}

class _CalendarHorizontalState extends State<CalendarHorizontal> {
  // function to handle the days of the month

  // variables that you want to select one day or multiple days
  // ignore: non_constant_identifier_names
  late DateTime SelectedDate;
  late List<DateTime> _selectedDates;
  List<DateTime?> rangeDatePickerValueWithDefaultValue = [];
  @override
  void initState() {
    super.initState();
    // initially the dates is dates of today
    SelectedDate = DateTime.now();
    //DateTime(date.year, date.month - 1, date.day);
    _selectedDates = [DateTime.now()];
  }

  int year = DateTime.now().year;
  String month = DateFormat.MMM().format(DateTime.now());
  DateTime prevMonth = DateTime(DateTime.now().year, DateTime.now().month - 1);
  DateTime currentDate = DateTime.now();
  // function to handle getting the previous month in the bar

  // function to handle getting the next month in the bar

  // function to handle selected date
  void _onDateSelected(DateTime date) {
    // This function will be called when a date item is tapped in the horizontal date picker.
    setState(() {
      SelectedDate = date; // Update the selected date.
    });
  }

  int itemCount = 31;
  double initialScroll = 0;
  // function to handle the date picker of multiple days
  DateTime? selectedDateM;
  final ToDoHapticController hapticController =
      Get.find<ToDoHapticController>();
  @override
  Widget build(BuildContext context) {
    // to handle where the scroll starts its view which is the today date
    initialScroll = SelectedDate.day >= 27
        ? 5.0.w
        : SelectedDate.day >= 23
            ? 3.7.w
            : SelectedDate.day >= 15
                ? 2.86.w
                : SelectedDate.day >= 10
                    ? 1.64.w
                    : SelectedDate.day >= 5
                        ? 0.75.w
                        : 0;
    ScrollController scrollController = ScrollController(
      initialScrollOffset: initialScroll, // or whatever offset you wish
      keepScrollOffset: true,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.035.w),
          child: CalendarAppBar(
            isHorizontal: widget.isHorizontal,
            showDatePicker: widget.showDatePicker,
            month: month,
            selectedDates: _selectedDates,
            onShowDatePickerFunction: () {
              _selectDate(context);
            },
            onSelectedDatesVAlueChanged: (value) {
              setState(() {
                _selectedDates = value;
              });
            },
            prevMonth: prevMonth,
            onPervMonthState: (value) {
              setState(() {
                prevMonth = value;
              });
            },
            onMonthChangedState: (value) {
              setState(() {
                month = value;
              });
            },
            itemCount: itemCount,
            itemCountChanged: (value) {
              setState(() {
                itemCount = value;
              });
            },
            initialScroll: initialScroll,
            initialScrolState: (value) {
              setState(() {
                initialScroll = value;
              });
            },
            SelectedDate: SelectedDate,
            SelectedDateState: (value) {
              setState(() {
                SelectedDate = value;
              });
            },
            year: year,
            yearChangeState: (value) {
              setState(() {
                year = value;
              });
            },
          ),
        ),
        widget.showDatePicker == true
            ? Padding(
                padding: EdgeInsets.only(top: 0.025.h),
                child: SizedBox(
                  height: widget.isHorizontal == true ? 0.12.h : 0.095.h,
                  child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        itemCount, // Replace with the number of days you want to display.
                    itemBuilder: (context, index) {
                      final date = _selectedDates.last
                          .subtract(Duration(days: _selectedDates.last.day - 1))
                          .add(Duration(days: index));
                      // print(_selectedDates.last.month);

                      return buildTimelineTile(
                        date,
                        isSelected: date == _selectedDates.last,
                        onTap: () {
                          // Call the onDateSelected callback when the date item is tapped.
                          hapticController.triggerHapticFeedback(
                              vibration: VibrateType.lightImpact,
                              hapticFeedback: HapticFeedback.lightImpact);
                          _onDateSelected(date);
                        },
                      );
                    },
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  // handler of the timeline tile of the horizantal date picker
  Widget buildTimelineTile(DateTime date,
      {bool isSelected = false, Function()? onTap}) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final dayName = DateFormat('EEE').format(date); //.capitalize();
    isSelected = (date.day == SelectedDate.day &&
        date.month ==
            SelectedDate.month); // Replace with your selected date logic.
    // print('date is $date');
    // print('SelectedDate is $SelectedDate');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 0.012.w : 0.016.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: widget.isHorizontal == true ? 0.07.h : 0.078.h,
          width: widget.isHorizontal == true
              ? Get.locale.toString().contains('en')
                  ? 0.055.w
                  : 0.065.w
              : isTablet
                  ? Get.locale.toString().contains('en')
                      ? 0.095.w
                      : 0.11.w
                  : Get.locale.toString().contains('en')
                      ? 0.14.w
                      : 0.16.w,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : MyThemeData.colorWhite,
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            border: Border.all(
              width: isSelected ? 0.001 : 0.001,
              color: isSelected ? MyThemeData.signOut : Colors.transparent,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    // control the color according to selected or previous or next day
                    color: isSelected
                        ? MyThemeData.signOut
                        : date.isAfter(DateTime.now()
                                .subtract(const Duration(days: 1)))
                            ? Theme.of(context).colorScheme.onTertiaryContainer
                            : MyThemeData.colorGreydark,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(9),
                      topRight: Radius.circular(9),
                    ),
                  ),
                  child: SizedBox(
                    height: 0.022.h,
                    width: 0.95.w,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: widget.isHorizontal == true ? 0.02.h : 0.015.h),
                  child: Text(
                    '${date.day}',
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: widget.isHorizontal == true
                          ? FontConstants.fontSize028.h
                          : FontConstants.fontSize022.h,
                      color: MyThemeData.colorBlack,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.01.h),
                  child: Text(
                    dayName.tr,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: widget.isHorizontal == true
                          ? FontConstants.fontSize025.h
                          : FontConstants.fontSize018.h,
                      color: MyThemeData.colorBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final List<DateTime?>? picked = await DatePicker().showDatePicker(
        context,
        rangeDatePickerValueWithDefaultValue,
        widget.dateTimeNow ?? DateTime.now(),
        CalendarDatePicker2Type.range);
    // handle the picked value
    // ignore: unrelated_type_equality_checks
    if (picked != null && picked != widget.dateTimeNow) {
      setState(() {
        rangeDatePickerValueWithDefaultValue = picked;
        widget.dateTimeNow = rangeDatePickerValueWithDefaultValue[0];
        widget.lastDateTime = rangeDatePickerValueWithDefaultValue.last;
        widget.onCheckboxStateChanged;
        widget.onDateChanged!(rangeDatePickerValueWithDefaultValue);
        month = DateFormat.MMM().format(widget.dateTimeNow as DateTime);
        SelectedDate = widget.dateTimeNow as DateTime;
        // final DateFormat formatter = DateFormat('dd/MM/yyyy');
        // String formattedDate = formatter
        //     .format(rangeDatePickerValueWithDefaultValue[0] as DateTime);
        _selectedDates.add(widget.dateTimeNow as DateTime);
      });
    }
  }
}
