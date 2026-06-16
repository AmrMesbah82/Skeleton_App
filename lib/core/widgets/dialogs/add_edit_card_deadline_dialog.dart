// Date Created :3/April/2024
// Developer Name : Abdullah Ibarhim
//App Version : Version 2
// Objectives: this is a widget to customize create,edit, card deadline
import 'package:flutter/cupertino.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/shared_components/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/core/shared_components/date_picker_class.dart';
import 'package:demo_app/core/widgets/cupertino_time_picker.dart';
import 'package:demo_app/core/widgets/buttons/main_yellow_button copy.dart';
import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

import '../../../features/task_management_module/task/data/model/board_model/board_model.dart';
import '../../../features/task_management_module/task/data/model/card_model/card_model.dart';


/// Date Created :17/April/2024
/// Developer Name : Abdullah Ibrahim
/// App Version : Version 2
/// Date of Last Edit :23/April/2024 By Abdullah Ibrahim
/// Objectives: represents the add edit card deadline dialog
///
class AddEditCardDeadlineDialouge extends StatefulWidget {
  AddEditCardDeadlineDialouge(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.iconUrl,
      this.isEditDates = false,
      this.board,
      this.cardModel,
      required this.boardModel});

  final String title;
  final String iconUrl;
  final bool? isEditDates;
  final String? board;
  final CardModel? cardModel;
  final void Function() onPressed;
  final BoardModel boardModel;

  @override
  State<AddEditCardDeadlineDialouge> createState() =>
      _AddEditCardDeadlineDialougeState();
}

class _AddEditCardDeadlineDialougeState
    extends State<AddEditCardDeadlineDialouge> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final HapticController hapticController = Get.put(HapticController());
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String? hintStartDate;
  String? hintEndDate;
  String hintStartTime = "12:00 AM";
  String hintEndTime = "12:00 AM";

  late TextEditingController controllerStartTime = TextEditingController();
  late TextEditingController controllerEndTime = TextEditingController();
  late TextEditingController controllerStartDate = TextEditingController();
  late TextEditingController controllerEndDate = TextEditingController();

  List<DateTime?> _rangeStartDatePickerValueWithDefaultValue = [];
  List<DateTime?> _rangeEndDatePickerValueWithDefaultValue = [];

  Future<void> _selectStartDate(BuildContext context) async {
    final List<DateTime?>? picked = await DatePicker().showDatePicker(
        context,
        _rangeStartDatePickerValueWithDefaultValue,
        DateTime.now(),
        CalendarDatePicker2Type.single);
    // change the selected the  with the picked date
    // ignore: unrelated_type_equality_checks
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        _rangeStartDatePickerValueWithDefaultValue = picked;
        selectedStartDate = picked[
            0]; // get the first element in the array which is the selected date
        hintStartDate =
            "${picked[0]!.day} ${DateFormat.MMM().format(picked[0]!)} ${picked[0]!.year}";
      });
    }
  }

  Future<void> _selectEndDate(
    BuildContext context,
  ) async {
    final List<DateTime?>? picked = await DatePicker().showDatePicker(
        context,
        _rangeEndDatePickerValueWithDefaultValue,
        DateTime.now(),
        CalendarDatePicker2Type.single);
    // change the selected the  with the picked date
    // ignore: unrelated_type_equality_checks
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        _rangeEndDatePickerValueWithDefaultValue = picked;
        selectedEndDate = picked[0];
        hintEndDate =
            "${picked[0]!.day} ${DateFormat.MMM().format(picked[0]!)} ${picked[0]!.year}";
      });
    }
  }

  @override
  void initState() {
    if (widget.isEditDates == true) {
      hintStartDate = DateFormat("dd/MM/yyyy").format(DateTime.parse(
          widget.cardModel!.startDate!.startDate!.last.toString()));
      hintEndDate = DateFormat("dd/MM/yyyy").format(
          DateTime.parse(widget.cardModel!.endDate!.endDate!.last.toString()));
      hintEndTime = widget.cardModel!.endTime!.endTime!.last.toString();
      hintStartTime = widget.cardModel!.startTime!.startTime!.last.toString();
    }
    controllerStartTime = TextEditingController();
    controllerEndTime = TextEditingController();
    controllerStartDate = TextEditingController();
    controllerEndDate = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controllerStartTime =
        TextEditingController(text: startTime?.format(context));
    controllerEndTime = TextEditingController(text: endTime?.format(context));
    controllerStartDate = TextEditingController(text: hintStartDate);
    controllerEndDate = TextEditingController(text: hintEndDate);

    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return /* GetBuilder<TaskController>(
      builder: (controller) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? (isVertical ? 0.18.w : 0.33.w) : 0.04.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: isTablet ? 0.015.w : 0.04.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.01.h),
                      child: CustomRowWithIcons(
                      //  boardModel: widget.boardModel,
                        iconPath: widget.iconUrl,
                        title: widget.title.tr,
                        hideDelete: true,
                        onArrowPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _selectStartDate(
                                    context,
                                  ).then((value) => print(hintStartDate));
                                },
                                child: ColumnRequestData(
                                  fillColor: themeController.currentTheme ==
                                          AppColors.lightTheme
                                      ? AppColors.colorLightGrey
                                      : AppColors.colorBlack,
                                  title: "Start Date",
                                  isTextField: true,
                                  textController: controllerStartDate,
                                  hint: "DD/MM/YYYY",
                                  isOptional: false,
                                  enabled: false,
                                  isExpanded: true,
                                  hasPrefix: true,
                                  hasSuffix: true,
                                  suffixUrl:
                                      "assets/icons/newCalenderFixed.svg",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: isTablet
                                  ? (isVertical ? 0.03.w : 0.03.h)
                                  : 0.04.w,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoTimePicker(
                                        onDateTimeChanged:
                                            (DateTime newDateTime) {
                                          setState(() {
                                            startTime = TimeOfDay.fromDateTime(
                                                newDateTime);
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
                                  title: "",
                                  isTextField: true,
                                  textController: controllerStartTime,
                                  hint: hintStartTime,
                                  isOptional: false,
                                  isExpanded: true,
                                  hasPrefix: true,
                                  enabled: false,
                                  hasSuffix: true,
                                  suffixUrl: "assets/icons/ClockCircleIcon.svg",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.015.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _selectEndDate(
                                    context,
                                  ).then((value) {
                                    print(hintEndDate);
                                  });
                                },
                                child: ColumnRequestData(
                                  fillColor: themeController.currentTheme ==
                                          AppColors.lightTheme
                                      ? AppColors.colorLightGrey
                                      : AppColors.colorBlack,
                                  title: "End Date",
                                  isTextField: true,
                                  textController: controllerEndDate,
                                  hint: "DD/MM/YYYY",
                                  enabled: false,
                                  isOptional: false,
                                  isExpanded: true,
                                  // textController: ,
                                  hasPrefix: true,
                                  hasSuffix: true,
                                  suffixUrl:
                                      "assets/icons/newCalenderFixed.svg",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: isTablet
                                  ? (isVertical ? 0.03.w : 0.03.h)
                                  : 0.04.w,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoTimePicker(
                                        onDateTimeChanged:
                                            (DateTime newDateTime) {
                                          setState(() {
                                            endTime = TimeOfDay.fromDateTime(
                                                newDateTime);
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
                                  title: "",
                                  isTextField: true,
                                  hint: hintEndTime,
                                  isOptional: false,
                                  textController: controllerEndTime,
                                  isExpanded: true,
                                  hasPrefix: true,
                                  enabled: false,
                                  hasSuffix: true,
                                  suffixUrl: "assets/icons/ClockCircleIcon.svg",
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.02.h, bottom: 0.01.h),
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.0.h),
                        child: ReusableElevatedButton(
                          buttonText:
                              widget.isEditDates == true ? "Save".tr : 'Add'.tr,
                          onPressed: () async {
                            widget.onPressed();
                            hapticController.triggerHapticFeedback(
                                vibration: VibrateType.heavyImpact,
                                hapticFeedback: HapticFeedback.heavyImpact);

                            if (widget.isEditDates == true) {
                              if (startTime != null ||
                                  endTime != null ||
                                  selectedStartDate != null ||
                                  selectedEndDate != null) {
                                await controller
                                    .updateCard(
                                  boardModel: widget.boardModel,
                                  cardModel: widget.cardModel!,
                                  board: widget.board!,
                                  startTime: startTime?.format(context),
                                  endTime: endTime?.format(context),
                                  startDate: selectedStartDate?.toString(),
                                  endDate: selectedEndDate?.toString(),
                                )
                                    .then((value) {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ResponseDialog(
                                        title: "Successful".tr,
                                        subtitle: widget.isEditDates == false
                                            ? "Task Deadlines Are Set Successfully"
                                                .tr
                                            : "Task Deadlines Are Updated Successfully"
                                                .tr,
                                        lottieAsset:
                                            "assets/images/correct.json",
                                      );
                                    },
                                  );
                                });
                              }
                            } else {
                              if (startTime != null &&
                                  endTime != null &&
                                  selectedStartDate != null &&
                                  selectedEndDate != null) {
                                await controller
                                    .updateCard(
                                  boardModel: widget.boardModel,
                                  cardModel: widget.cardModel!,
                                  board: widget.board!,
                                  startTime: startTime?.format(context),
                                  endTime: endTime?.format(context),
                                  startDate: selectedStartDate?.toString(),
                                  endDate: selectedEndDate?.toString(),
                                )
                                    .then(
                                  (value) {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ResponseDialog(
                                          title: "Successful".tr,
                                          subtitle: widget.isEditDates == false
                                              ? "Task Deadlines Are Set Successfully"
                                                  .tr
                                              : "Task Deadlines Are Updated Successfully"
                                                  .tr,
                                          lottieAsset:
                                              "assets/images/correct.json",
                                        );
                                      },
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const ResponseDialog(
                                      title: "Failure",
                                      subtitle: "Please Fill All The Fields",
                                      lottieAsset: "assets/images/error.json",
                                    );
                                  },
                                );
                              }
                            }

                            setState(() {});
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
   */
  Container();
  
  }

  @override
  void dispose() {
    controllerStartTime.dispose();
    controllerEndTime.dispose();
    controllerStartDate.dispose();
    controllerEndDate.dispose();

    super.dispose();
  }
}
