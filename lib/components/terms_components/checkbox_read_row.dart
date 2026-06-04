// ignore_for_file: must_be_immutable
//Date Created :15/September/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :13/October/2023 by mazen
// Objectives: this class  created to Customize the checkboxs in whole app
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_checkbox.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';

class CheckBoxReadRow extends StatefulWidget {
  CheckBoxReadRow({
    super.key,
    required this.isChecked,
    required this.checkStateChage,
  });
  bool isChecked;
  ValueChanged<bool> checkStateChage;

  @override
  State<CheckBoxReadRow> createState() => _CheckBoxReadRowState();
}

class _CheckBoxReadRowState extends State<CheckBoxReadRow> {
  final ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Row(
      children: [
        CustomCheckbox(
          isChecked: widget.isChecked,
          onCheckboxState: (value) {
            setState(() {
              widget.isChecked = !widget.isChecked;
              widget.checkStateChage(widget.isChecked);
            });
          },
        ),
        Padding(
          padding: EdgeInsets.only(
              left: Get.locale.toString().contains('en')
                  ? isTablet
                      ? 0.012.w
                      : 0.02.w
                  : 0,
              right: Get.locale.toString().contains('en')
                  ? 0
                  : isTablet
                      ? 0.012.w
                      : 0.02.w,
              top: 0.0058.h),
          child: Text(
            'I have read and accepted the terms  and conditions '.tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: isTablet
                    ? FontConstants.fontSize020.h
                    : FontConstants.fontSize015.h,
                // ignore: unrelated_type_equality_checks
                color: themeController.currentTheme == MyThemeData.lightTheme
                    ? MyThemeData.textdeactivecolor
                    : MyThemeData.colorGreydark,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}
