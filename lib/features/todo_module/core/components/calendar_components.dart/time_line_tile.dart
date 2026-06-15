// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/todo_module/core/constants/screen_size.dart';
import 'package:demo_app/core/theme/my_theme.dart';

// ignore: must_be_immutable
class buildTimelineTile extends StatefulWidget {
  buildTimelineTile(
      {super.key,
      required this.isHorizontal,
      required this.onTap,
      required this.date,
      required this.isSelected,
      required this.changeDateState,
      required this.isSelectedState});
  bool isHorizontal;
  Function()? onTap;
  DateTime date;
  bool isSelected;
  ValueChanged<bool> isSelectedState;

  ValueChanged<DateTime> changeDateState;
  @override
  State<buildTimelineTile> createState() => _buildTimelineTileState();
}

class _buildTimelineTileState extends State<buildTimelineTile> {
  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEE').format(widget.date);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.012.w),
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.changeDateState(widget.date);
          });
        },
        child: Container(
          height: widget.isHorizontal == true ? 0.07.h : 0.078.h,
          width: widget.isHorizontal == true ? 0.05.w : 0.095.w,
          decoration: BoxDecoration(
            color: widget.isSelected ? Colors.white : MyThemeData.colorWhite,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            border: Border.all(
              width: widget.isSelected ? 1.2 : 0.001,
              color:
                  widget.isSelected ? MyThemeData.signOut : Colors.transparent,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    // control the color according to selected or previous or next day
                    color: widget.isSelected
                        ? MyThemeData.signOut
                        : widget.date.isAfter(
                                DateTime.now().subtract(Duration(days: 1)))
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
                    '${widget.date.day}',
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
                    dayName,
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
}
