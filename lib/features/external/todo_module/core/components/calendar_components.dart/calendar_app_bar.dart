//Date Created :18/September/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :4/October/2023 by mazen
// Objectives: this class  created to view the calendar app bar that have forward and backward and picker of the date in some screens
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/external/main_core/core/theme/font_manager.dart';
import 'package:demo_app/features/external/todo_module/core/constants/enum.dart';
import 'package:demo_app/features/external/todo_module/core/constants/haptic_controller.dart';
import 'package:demo_app/features/external/todo_module/core/constants/screen_size.dart';

// ignore: must_be_immutable
class CalendarAppBar extends StatefulWidget {
  CalendarAppBar(
      {super.key,
      required this.isHorizontal,
      required this.showDatePicker,
      required this.selectedDates,
      required this.month,
      required this.prevMonth,
      required this.onMonthChangedState,
      required this.onSelectedDatesVAlueChanged,
      required this.onPervMonthState,
      required this.itemCount,
      required this.itemCountChanged,
      required this.initialScroll,
      required this.initialScrolState,
      // ignore: non_constant_identifier_names
      required this.SelectedDate,
      // ignore: non_constant_identifier_names
      required this.SelectedDateState,
      required this.year,
      required this.yearChangeState,
      this.isMeetings = false,
      required this.onShowDatePickerFunction});
  bool isHorizontal;
  bool showDatePicker;
  String month;
  ValueChanged<String> onMonthChangedState;
  List<DateTime> selectedDates;
  ValueChanged<List<DateTime>> onSelectedDatesVAlueChanged;
  DateTime prevMonth;
  ValueChanged<DateTime> onPervMonthState;
  int itemCount;
  ValueChanged<int> itemCountChanged;
  double initialScroll;
  ValueChanged<double> initialScrolState;
  // ignore: non_constant_identifier_names
  DateTime SelectedDate;
  // ignore: non_constant_identifier_names
  ValueChanged<DateTime> SelectedDateState;
  int year;
  ValueChanged<int> yearChangeState;
  Function() onShowDatePickerFunction;
  final bool isMeetings;

  @override
  State<CalendarAppBar> createState() => _CalendarAppBarState();
}

class _CalendarAppBarState extends State<CalendarAppBar> {
  int getDaysInMonth(int month, int year) {
    // Check for February to handle leap years
    if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        // Leap year, February has 29 days
        return 29;
      } else {
        // Non-leap year, February has 28 days
        return 28;
      }
    }

    // Months with 30 days
    if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    }

    // All other months have 31 days
    return 31;
  }

  void _getPreviousMonth() {
    setState(() {
      DateTime previousDate = widget.selectedDates.last;
      widget.prevMonth =
          DateTime(previousDate.year, previousDate.month - 1, previousDate.day);
      widget.selectedDates.add(widget.prevMonth);
      widget.onSelectedDatesVAlueChanged(widget.selectedDates);
      widget.onPervMonthState(widget.prevMonth);
    });
    // print(_selectedDates.last);
  }

  void _getNextMonth() {
    setState(() {
      DateTime previousDate = widget.selectedDates.last;
      widget.prevMonth =
          DateTime(previousDate.year, previousDate.month + 1, previousDate.day);
      widget.selectedDates.add(widget.prevMonth);
      widget.onPervMonthState(widget.prevMonth);
      widget.itemCount =
          getDaysInMonth(widget.selectedDates.last.month, widget.year);
      widget.itemCountChanged(widget.itemCount);
      widget.onSelectedDatesVAlueChanged(widget.selectedDates);
      //  _selectedDates.remove(_selectedDates.last);
    });
    // print(_selectedDates.last);
  }

  final ToDoHapticController hapticController =
      Get.find<ToDoHapticController>();
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Container(
      width: widget.isMeetings ? 0.9.w : 0.82.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.01.h, horizontal: 0.015.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                widget.showDatePicker == true &&
                        widget.month != DateFormat.MMM().format(DateTime.now())
                    ? setState(() {
                        _getPreviousMonth();
                        widget.month =
                            DateFormat.MMM().format(widget.prevMonth);
                        widget.onPervMonthState(widget.prevMonth);
                        widget.onMonthChangedState(widget.month);

                        widget.itemCount = getDaysInMonth(
                            widget.selectedDates.last.month, widget.year);
                        widget.itemCountChanged(widget.itemCount);
                        widget
                            .onSelectedDatesVAlueChanged(widget.selectedDates);
                        widget.initialScroll = widget.SelectedDate.day >= 26
                            ? 1500.0
                            : widget.SelectedDate.day >= 20
                                ? 1110
                                : widget.SelectedDate.day >= 15
                                    ? 820
                                    : widget.SelectedDate.day >= 10
                                        ? 520
                                        : widget.SelectedDate.day >= 5
                                            ? 230
                                            : 0;
                        widget.initialScrolState(widget.initialScroll);
                      })
                    : widget.showDatePicker == false
                        ? setState(() {
                            _getPreviousMonth();
                            widget.month =
                                DateFormat.MMM().format(widget.prevMonth);
                            widget.onPervMonthState(widget.prevMonth);
                            widget.onMonthChangedState(widget.month);
                            widget.itemCount = getDaysInMonth(
                                widget.selectedDates.last.month, widget.year);
                            widget.itemCountChanged(widget.itemCount);
                            widget.onSelectedDatesVAlueChanged(
                                widget.selectedDates);
                            widget.initialScroll = widget.SelectedDate.day >= 26
                                ? 1500.0
                                : widget.SelectedDate.day >= 20
                                    ? 1110
                                    : widget.SelectedDate.day >= 15
                                        ? 820
                                        : widget.SelectedDate.day >= 10
                                            ? 520
                                            : widget.SelectedDate.day >= 5
                                                ? 230
                                                : 0;
                            widget.initialScrolState(widget.initialScroll);
                          })
                        : null;
              },

              //svg
              child: widget.showDatePicker == true &&
                      widget.month != DateFormat.MMM().format(DateTime.now())
                  ? Transform.rotate(
                      angle: Get.locale.toString().contains('en') ? 0 : 110,
                      child: SvgPicture.asset(
                        'assets/icons/arrowright2.svg',
                        height: isTablet
                            ? widget.isHorizontal == true
                                ? 0.04.h
                                : 0.03.h
                            : 0.025.h,
                        // ignore: deprecated_member_use
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                    )
                  : Transform.rotate(
                      angle: Get.locale.toString().contains('en') ? 0 : 110,
                      child: SvgPicture.asset(
                        'assets/icons/arrowright2.svg',
                        height: isTablet
                            ? widget.isHorizontal == true
                                ? 0.05.h
                                : 0.03.h
                            : 0.025.h,
                        // ignore: deprecated_member_use
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                    ),
            ),
            Center(
              child: InkWell(
                onTap: widget.showDatePicker == false
                    ? widget.onShowDatePickerFunction
                    //_selectDate(context);
                    : null,
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/images/calendar2.svg',
                      // ignore: deprecated_member_use
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      height: widget.isHorizontal == true
                          ? 0.050.h
                          : isTablet
                              ? 0.038.h
                              : 0.025.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                              Get.locale.toString().contains('en') ? 0.04.w : 0,
                          right: Get.locale.toString().contains('en')
                              ? 0
                              : 0.02.w),
                      child: Text(
                        '${widget.month.tr} ${widget.year}',
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                          height: 1.6,
                          fontSize: widget.isHorizontal == true
                              ? FontConstants.fontSize028.h
                              : isTablet
                                  ? FontConstants.fontSize023.h
                                  : FontConstants.fontSize018.h,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                _getNextMonth();
                widget.month = DateFormat.MMM().format(widget.prevMonth);
                widget.onPervMonthState(widget.prevMonth);
                widget.onMonthChangedState(widget.month);
                setState(() {
                  widget.initialScroll = 0;
                  widget.initialScrolState(widget.initialScroll);
                });
              },
              child: Transform.rotate(
                angle: Get.locale.toString().contains('en') ? 0 : 110,
                child: SvgPicture.asset(
                  'assets/icons/arrowleft2.svg',
                  height: isTablet
                      ? widget.isHorizontal == true
                          ? 0.05.h
                          : 0.03.h
                      : 0.025.h,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
