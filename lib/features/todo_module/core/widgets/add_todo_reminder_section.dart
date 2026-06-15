import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/column_request_data.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/custom_black_button.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';

/// Date Created 9/March/2025
/// Developer Name : Ahmed Mahmoud
/// Objectives: this file represents customization publishing section in creation and edit

class AddTodoReminderSection extends StatefulWidget {
  const AddTodoReminderSection({
    super.key,
  });

  @override
  State<AddTodoReminderSection> createState() => _AddTodoReminderSectionState();
}

class _AddTodoReminderSectionState extends State<AddTodoReminderSection> {
  TodoController controller = Get.find<TodoController>();

  int counter1 = 0;
  int counter2 = 0;
  int counter3 = 0;

  int reminderNumber = Get.find<TodoController>().reminderNumber;

  @override
  void initState() {
    if (controller.firstSelectedReminderNumber.value.isNotEmpty) {
      counter1 =
          int.tryParse(controller.firstSelectedReminderNumber.value) ?? 0;
      reminderNumber = 1;
    }
    if (controller.secondSelectedReminderNumber.value.isNotEmpty) {
      counter2 =
          int.tryParse(controller.secondSelectedReminderNumber.value) ?? 0;
      reminderNumber = 2;
    }
    if (controller.thirdSelectedReminderNumber.value.isNotEmpty) {
      counter3 =
          int.tryParse(controller.thirdSelectedReminderNumber.value) ?? 0;
      reminderNumber = 3;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return !isTablet
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Reminder Section
              if (reminderNumber > 0) ...[
                Text(
                  "First Reminder".tr,
                  style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    IntrinsicWidth(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildButton(Icons.remove, () {
                              setState(() {
                                if (counter1 > 0) counter1--;
                              });
                              controller.firstSelectedReminderNumber.value =
                                  counter1.toString();
                              controller.firstReminderNumber!.text =
                                  controller.firstSelectedReminderNumber.value;
                            }),
                            Text(
                              '$counter1',
                              style: AppTextStyles.font10BlackCairoRegular
                                  .copyWith(
                                height: 1.2,
                                fontSize: 14,
                                color: AppColors.text,
                              ),
                            ),
                            _buildButton(Icons.add, () {
                              setState(() {
                                counter1++;
                              });
                              controller.firstSelectedReminderNumber.value =
                                  counter1.toString();
                              controller.firstReminderNumber!.text =
                                  controller.firstSelectedReminderNumber.value;
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Obx(() => ColumnRequestData(
                            title: "Reminder".tr,
                            hideTitle: true,
                            isTextField: false,
                            hint: "Hour".tr,
                            controllerfinishState: (value) =>
                                FocusScope.of(context).unfocus(),
                            isOptional: false,
                            dropdownValue: controller
                                    .firstSelectedReminderText.value.isEmpty
                                ? null
                                : controller.firstSelectedReminderText.value,
                            buttonWidth: double.infinity,
                            dropWidth: MediaQuery.of(context).size.width - 180,
                            isExpanded: true,
                            dropDownValueState: (val) {
                              if (val != null) {
                                controller.firstSelectedReminderText.value =
                                    val;
                              }
                              controller.firstReminderText!.text =
                                  controller.firstSelectedReminderText.value;
                            },
                            dropDownItems: [
                              "Minute".tr,
                              "Hour".tr,
                              "Day".tr,
                              "Week".tr,
                            ],
                          )),
                    ),
                  ],
                ),
              ],
              SizedBox(height: (reminderNumber > 1) ? 6 : 0),
              // Second Reminder Section
              if (reminderNumber > 1) ...[
                Text(
                  "Second Reminder".tr,
                  style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    IntrinsicWidth(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildButton(Icons.remove, () {
                              setState(() {
                                if (counter2 > 0) counter2--;
                              });
                              controller.secondSelectedReminderNumber.value =
                                  counter2.toString();
                              controller.secondSelectedReminderNumber.value =
                                  counter2.toString();
                              controller.secondReminderNumber!.text =
                                  controller.secondSelectedReminderNumber.value;
                            }),
                            Text(
                              '$counter2',
                              style: AppTextStyles.font10BlackCairoRegular
                                  .copyWith(
                                height: 1.2,
                                fontSize: 14,
                                color: AppColors.text,
                              ),
                            ),
                            _buildButton(Icons.add, () {
                              setState(() {
                                counter2++;
                              });
                              controller.secondSelectedReminderNumber.value =
                                  counter2.toString();
                              controller.secondReminderNumber!.text =
                                  controller.secondSelectedReminderNumber.value;
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Obx(() => ColumnRequestData(
                            title: "Reminder".tr,
                            hideTitle: true,
                            isTextField: false,
                            hint: "Hour".tr,
                            controllerfinishState: (value) =>
                                FocusScope.of(context).unfocus(),
                            isOptional: false,
                            dropdownValue: controller
                                    .secondSelectedReminderText.value.isEmpty
                                ? null
                                : controller.secondSelectedReminderText.value,
                            buttonWidth: double.infinity,
                            dropWidth: MediaQuery.of(context).size.width - 180,
                            isExpanded: true,
                            dropDownValueState: (val) {
                              if (val != null) {
                                controller.secondSelectedReminderText.value =
                                    val;
                                controller.secondReminderText!.text =
                                    controller.secondSelectedReminderText.value;
                              }
                            },
                            dropDownItems: [
                              "Minute".tr,
                              "Hour".tr,
                              "Day".tr,
                              "Week".tr,
                            ],
                          )),
                    ),
                  ],
                ),
              ],
              SizedBox(height: (reminderNumber > 2) ? 6 : 0),
              // Third Reminder Section
              if (reminderNumber > 2) ...[
                Text(
                  "Third Reminder".tr,
                  style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    IntrinsicWidth(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildButton(Icons.remove, () {
                              setState(() {
                                if (counter3 > 0) counter3--;
                              });
                              controller.thirdSelectedReminderNumber.value =
                                  counter3.toString();
                              controller.thirdReminderNumber!.text =
                                  controller.thirdSelectedReminderNumber.value;
                            }),
                            Text(
                              '$counter3',
                              style: AppTextStyles.font10BlackCairoRegular
                                  .copyWith(
                                height: 1.2,
                                fontSize: 14,
                                color: AppColors.text,
                              ),
                            ),
                            _buildButton(Icons.add, () {
                              setState(() {
                                counter3++;
                              });
                              controller.thirdSelectedReminderNumber.value =
                                  counter3.toString();
                              controller.thirdReminderNumber!.text =
                                  controller.thirdSelectedReminderNumber.value;
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Obx(() => ColumnRequestData(
                              title: "Reminder".tr,
                              hideTitle: true,
                              isTextField: false,
                              hint: "Hour".tr,
                              controllerfinishState: (value) =>
                                  FocusScope.of(context).unfocus(),
                              isOptional: false,
                              dropdownValue: controller
                                      .thirdSelectedReminderText.value.isEmpty
                                  ? null
                                  : controller.thirdSelectedReminderText.value,
                              buttonWidth: double.infinity,
                              dropWidth:
                                  MediaQuery.of(context).size.width - 180,
                              isExpanded: true,
                              dropDownValueState: (val) {
                                if (val != null) {
                                  controller.thirdSelectedReminderText.value =
                                      val;
                                  controller.thirdReminderText!.text =
                                      controller
                                          .thirdSelectedReminderText.value;
                                }
                              },
                              dropDownItems: [
                                "Minute".tr,
                                "Hour".tr,
                                "Day".tr,
                                "Week".tr,
                              ])),
                    ),
                  ],
                ),
              ],
              SizedBox(
                  height: (reminderNumber > 0 && reminderNumber < 4) ? 8 : 0),
              if (reminderNumber < 3)
                CustomBlackButton(
                  isYellow: false,
                  buttonText: "Reminder".tr,
                  onPressed: () {
                    setState(() => reminderNumber++);
                  },
                ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Reminder Section
              if (reminderNumber > 0) ...[
                Text(
                  "First Reminder".tr,
                  style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    IntrinsicWidth(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildButton(Icons.remove, () {
                              setState(() {
                                if (counter1 > 0) counter1--;
                              });
                              controller.firstSelectedReminderNumber.value =
                                  counter1.toString();
                              controller.firstReminderNumber!.text =
                                  controller.firstSelectedReminderNumber.value;
                            }),
                            Text(
                              '$counter1',
                              style: AppTextStyles.font10BlackCairoRegular
                                  .copyWith(
                                height: 1.2,
                                fontSize: 14,
                                color: AppColors.text,
                              ),
                            ),
                            _buildButton(Icons.add, () {
                              setState(() {
                                counter1++;
                              });
                              controller.firstSelectedReminderNumber.value =
                                  counter1.toString();
                              controller.firstReminderNumber!.text =
                                  controller.firstSelectedReminderNumber.value;
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Obx(() => ColumnRequestData(
                            title: "Reminder".tr,
                            hideTitle: true,
                            isTextField: false,
                            hint: "Hour".tr,
                            controllerfinishState: (value) =>
                                FocusScope.of(context).unfocus(),
                            isOptional: false,
                            dropdownValue: controller
                                    .firstSelectedReminderText.value.isEmpty
                                ? null
                                : controller.firstSelectedReminderText.value,
                            buttonWidth: double.infinity,
                            dropWidth:
                                MediaQuery.of(context).size.width / 2 - 200,
                            isExpanded: true,
                            dropDownValueState: (val) {
                              if (val != null) {
                                controller.firstSelectedReminderText.value =
                                    val;
                              }
                              controller.firstReminderText!.text =
                                  controller.firstSelectedReminderText.value;
                            },
                            dropDownItems: [
                              "Minute".tr,
                              "Hour".tr,
                              "Day".tr,
                              "Week".tr,
                            ],
                          )),
                    ),
                  ],
                ),
              ],
              SizedBox(height: (reminderNumber > 1) ? 6 : 0),
              // Second Reminder Section
              if (reminderNumber > 1) ...[
                Text(
                  "Second Reminder".tr,
                  style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    IntrinsicWidth(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildButton(Icons.remove, () {
                              setState(() {
                                if (counter2 > 0) counter2--;
                              });
                              controller.secondSelectedReminderNumber.value =
                                  counter2.toString();
                              controller.secondSelectedReminderNumber.value =
                                  counter2.toString();
                              controller.secondReminderNumber!.text =
                                  controller.secondSelectedReminderNumber.value;
                            }),
                            Text(
                              '$counter2',
                              style: AppTextStyles.font10BlackCairoRegular
                                  .copyWith(
                                height: 1.2,
                                fontSize: 14,
                                color: AppColors.text,
                              ),
                            ),
                            _buildButton(Icons.add, () {
                              setState(() {
                                counter2++;
                              });
                              controller.secondSelectedReminderNumber.value =
                                  counter2.toString();
                              controller.secondReminderNumber!.text =
                                  controller.secondSelectedReminderNumber.value;
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Obx(() => ColumnRequestData(
                            title: "Reminder".tr,
                            hideTitle: true,
                            isTextField: false,
                            hint: "Hour".tr,
                            controllerfinishState: (value) =>
                                FocusScope.of(context).unfocus(),
                            isOptional: false,
                            dropdownValue: controller
                                    .secondSelectedReminderText.value.isEmpty
                                ? null
                                : controller.secondSelectedReminderText.value,
                            buttonWidth: double.infinity,
                            dropWidth:
                                MediaQuery.of(context).size.width / 2 - 200,
                            isExpanded: true,
                            dropDownValueState: (val) {
                              if (val != null) {
                                controller.secondSelectedReminderText.value =
                                    val;
                                controller.secondReminderText!.text =
                                    controller.secondSelectedReminderText.value;
                              }
                            },
                            dropDownItems: [
                              "Minute".tr,
                              "Hour".tr,
                              "Day".tr,
                              "Week".tr,
                            ],
                          )),
                    ),
                  ],
                ),
              ],
              SizedBox(height: (reminderNumber > 2) ? 6 : 0),
              // Third Reminder Section
              if (reminderNumber > 2) ...[
                Text(
                  "Third Reminder".tr,
                  style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    IntrinsicWidth(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildButton(Icons.remove, () {
                              setState(() {
                                if (counter3 > 0) counter3--;
                              });
                              controller.thirdSelectedReminderNumber.value =
                                  counter3.toString();
                              controller.thirdReminderNumber!.text =
                                  controller.thirdSelectedReminderNumber.value;
                            }),
                            Text(
                              '$counter3',
                              style: AppTextStyles.font10BlackCairoRegular
                                  .copyWith(
                                height: 1.2,
                                fontSize: 14,
                                color: AppColors.text,
                              ),
                            ),
                            _buildButton(Icons.add, () {
                              setState(() {
                                counter3++;
                              });
                              controller.thirdSelectedReminderNumber.value =
                                  counter3.toString();
                              controller.thirdReminderNumber!.text =
                                  controller.thirdSelectedReminderNumber.value;
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Obx(() => ColumnRequestData(
                              title: "Reminder".tr,
                              hideTitle: true,
                              isTextField: false,
                              hint: "Hour",
                              controllerfinishState: (value) =>
                                  FocusScope.of(context).unfocus(),
                              isOptional: false,
                              dropdownValue: controller
                                      .thirdSelectedReminderText.value.isEmpty
                                  ? null
                                  : controller.thirdSelectedReminderText.value,
                              buttonWidth: double.infinity,
                              dropWidth:
                                  MediaQuery.of(context).size.width / 2 - 200,
                              isExpanded: true,
                              dropDownValueState: (val) {
                                if (val != null) {
                                  controller.thirdSelectedReminderText.value =
                                      val;
                                  controller.thirdReminderText!.text =
                                      controller
                                          .thirdSelectedReminderText.value;
                                }
                              },
                              dropDownItems: [
                                "Minute".tr,
                                "Hour".tr,
                                "Day".tr,
                                "Week".tr,
                              ])),
                    ),
                  ],
                ),
              ],
              SizedBox(
                  height: (reminderNumber > 0 && reminderNumber < 4) ? 8 : 0),
              if (reminderNumber < 3)
                CustomBlackButton(
                  isYellow: false,
                  buttonText: "Reminder".tr,
                  onPressed: () {
                    setState(() => reminderNumber++);
                  },
                ),
            ],
          );
  }
}

Widget _buildButton(IconData icon, VoidCallback onPressed) {
  return IconButton(
    icon: Icon(icon),
    onPressed: onPressed,
    iconSize: 16,
    splashRadius: 20,
    color: AppColors.inputColor,
  );
}
