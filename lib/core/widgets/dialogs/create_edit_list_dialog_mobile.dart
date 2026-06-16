
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/shared_components/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/core/shared_components/date_picker_class.dart';
import 'package:demo_app/core/widgets/cupertino_time_picker.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_button.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';


import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

class CreateEditListDialogMobile extends StatefulWidget {
  CreateEditListDialogMobile({
    super.key,
    this.isEdit = false,
  });
  bool? isEdit;

  @override
  State<CreateEditListDialogMobile> createState() =>
      _CreateEditListDialogMobileState();
}

class _CreateEditListDialogMobileState
    extends State<CreateEditListDialogMobile> {
  DateTime? selectedDate;
  String? hintDate;
  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [];
  Future<void> _selectDate(BuildContext context) async {
    final List<DateTime?>? picked = await DatePicker().showDatePicker(
        context,
        _rangeDatePickerValueWithDefaultValue,
        DateTime.now(),
        CalendarDatePicker2Type.single);
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
        hintDate =
            "${picked[0]!.day} ${DateFormat.MMM().format(picked[0]!)} ${picked[0]!.year}";
        // widget.dateValueState(widget.dateValue);
      });
    }
  }

  TimeOfDay? time;
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextEditingController date = TextEditingController(text: hintDate);
    TextEditingController controllerEndStart =
        TextEditingController(text: time?.format(context));
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double hightSpace = 0.01.h;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: orientation ? 0.1.w : 0.2.w,
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
          child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        height: null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.015.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FiltersAppBar(
                  imageUrl: widget.isEdit == true
                      ? "assets/icons/editList.svg"
                      : "assets/images/create_board.svg",
                  title: widget.isEdit == true
                      ? "Edit To Do List"
                      : "Create To Do List"),
              ColumnRequestData(
                  title: "Name",
                  hasPrefix: true,
                  isTextField: true,
                  fillColor: themeController.currentTheme ==
                                  AppColors.lightTheme
                              ? AppColors.colorLightGrey
                              : AppColors.colorBlack,
                  textController: name,
                  controllerState: (value) {
                    setState(() {});
                  },
                  hint: "Enter Board Name",
                  isOptional: false,
                  isExpanded: true),
              SizedBox(
                height: hightSpace,
              ),
              ColumnRequestData(
                  title: "Description",
                  isTextField: true,
                  hasPrefix: true,
              isDescription: true,
                  fillColor: themeController.currentTheme ==
                                  AppColors.lightTheme
                              ? AppColors.colorLightGrey
                              : AppColors.colorBlack,
                  textController: description,
                  controllerState: (value) {
                    setState(() {});
                  },
                  hint: "Enter Board Description",
                  isOptional: false,
                  isExpanded: true),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: ColumnRequestData(
                     fillColor: themeController.currentTheme ==
                                  AppColors.lightTheme
                              ? AppColors.colorLightGrey
                              : AppColors.colorBlack,
                  title: "Due Date",
                  isTextField: true,
                  hint: "DD/MM/YYYY",
                  textController: date,
                  isOptional: false,
                  isExpanded: true,
                  enabled: false,
                  hasPrefix: true,
                  hasSuffix: true,
                  suffixUrl: "assets/icons/newCalenderFixed.svg",
                ),
              ),
              SizedBox(
                height: hightSpace,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoTimePicker(
                        onDateTimeChanged: (DateTime newDateTime) {
                              setState(() {
                                time = TimeOfDay.fromDateTime(newDateTime);
                              });
                            },
                      );
                    },
                  );
                   
                },
                child: ColumnRequestData(
                    fillColor: themeController.currentTheme ==
                                  AppColors.lightTheme
                              ? AppColors.colorLightGrey
                              : AppColors.colorBlack,
                  title: "Time",
                  isTextField: true,
                  hint: "12:00 PM",
                  textController: controllerEndStart,
                  isOptional: false,
                  enabled: false,
                  isExpanded: true,
                  hasPrefix: true,
                  hasSuffix: true,
                  suffixUrl: "assets/icons/ClockCircleIcon.svg",
                ),
              ),
              SizedBox(
                height: 0.01.h,
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.02.h, bottom: 0.01.h),
                child: MainCustomButton(
                  buttonText: widget.isEdit == true ? 'Edit'.tr : 'Create'.tr,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
