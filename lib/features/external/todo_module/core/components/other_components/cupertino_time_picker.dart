import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/external/todo_module/core/constants/screen_size.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';

class CupertinoTimePicker extends StatefulWidget {
  final Function(DateTime) onDateTimeChanged;
  final CupertinoDatePickerMode mode;
  final DateTime initialDateTime;

  const CupertinoTimePicker({
    super.key,
    required this.onDateTimeChanged,
    required this.mode,
    required this.initialDateTime,
  });

  @override
  _CupertinoTimePickerState createState() => _CupertinoTimePickerState();
}

class _CupertinoTimePickerState extends State<CupertinoTimePicker> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.width > 600;

    return SizedBox(
      child: AlertDialog(
        content: SizedBox(
          height: 280,
          child: CupertinoDatePicker(
            mode: widget.mode,
            initialDateTime: selectedDateTime,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDateTime = newDate;
              });
            },
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 0.055.h,
                      width: isTablet
                          ? isPortrait
                              ? 0.2.w
                              : 0.14.w
                          : 0.38.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: MyThemeData.colorGreydark,
                      ),
                      child: Center(
                        child: Text(
                          'Cancel'.tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: FontConstants.fontSize023.h,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                              height: isTablet ? 0.0014.h : 0.002.h),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.onDateTimeChanged(selectedDateTime);
                      Get.back();
                    },
                    child: Container(
                      height: 0.055.h,
                      width: isTablet
                          ? isPortrait
                              ? 0.2.w
                              : 0.14.w
                          : 0.38.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primary,
                      ),
                      child: Center(
                        child: Text(
                          'Set Date'.tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: FontConstants.fontSize023.h,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                              height: isTablet ? 0.0014.h : 0.002.h),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
