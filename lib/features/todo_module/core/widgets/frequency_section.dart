import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/column_request_data.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/frequency_model.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';

/// Date Created 9/March/2025
/// Developer Name : Ahmed Mahmoud
/// Objectives: this file represents customization publishing section in creation and edit

class FrequencySection extends StatefulWidget {
  const FrequencySection({
    super.key,
  });

  @override
  State<FrequencySection> createState() => _FrequencySectionState();
}

class _FrequencySectionState extends State<FrequencySection> {
  TodoController controller = Get.find<TodoController>();

  int counter = 1;
  @override
  void initState() {
    if (controller.selectedFrequencyNumber.value.isNotEmpty) {
      counter = int.tryParse(controller.selectedFrequencyNumber.value) ?? 1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return isTablet
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tablet view - similar structure can be applied.
              Row(
                children: [
                  FrequencyNumberSection(),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Obx(
                      () => ColumnRequestData(
                        title: "Frequency",
                        hideTitle: true,
                        isTextField: false,
                        hint: "Hour",
                        controllerfinishState: (value) =>
                            FocusScope.of(context).unfocus(),
                        isOptional: false,
                        dropdownValue:
                            controller.selectedFrequencyText.value.isEmpty
                                ? null
                                : controller.selectedFrequencyText.value,
                        buttonWidth: double.infinity,
                        dropWidth: MediaQuery.of(context).size.width / 2 - 200,
                        isExpanded: true,
                        dropDownValueState: (val) {
                          if (val != null) {
                            final frequency = FrequencyText()
                                .getFrequencyFromDisplayText(val);
                            controller.selectedFrequencyText.value =
                                frequency.toString().split('.').last;
                            controller.frequencyText!.text =
                                controller.selectedFrequencyText.value;
                          }
                        },
                        dropDownItems: TodoFrequency.values.map((freq) {
                          return FrequencyText().getFrequencyDisplayText(freq);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FrequencyNumberSection(),
                  const SizedBox(width: 15),
                  // Frequency Text
                  Expanded(
                    child: Obx(
                      () => ColumnRequestData(
                        title: "Frequency".tr,
                        hideTitle: true,
                        isTextField: false,
                        hint: "Hour".tr,
                        controllerfinishState: (value) =>
                            FocusScope.of(context).unfocus(),
                        isOptional: false,
                        dropdownValue: controller
                                .selectedFrequencyText.value.isEmpty
                            ? null
                            : FrequencyText().getFrequencyDisplayText(
                                FrequencyText.frequencyFromString(
                                    controller.selectedFrequencyText.value)),
                        buttonWidth: double.infinity,
                        dropWidth: MediaQuery.of(context).size.width - 187,
                        isExpanded: true,
                        dropDownValueState: (val) {
                          if (val != null) {
                            final frequency = FrequencyText()
                                .getFrequencyFromDisplayText(val);
                            controller.selectedFrequencyText.value =
                                frequency.toString().split('.').last;
                            controller.frequencyText!.text =
                                controller.selectedFrequencyText.value;
                          }
                        },
                        dropDownItems: TodoFrequency.values.map((freq) {
                          return FrequencyText().getFrequencyDisplayText(freq);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  IntrinsicWidth FrequencyNumberSection() {
    return IntrinsicWidth(
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
                counter--;
              });
              controller.selectedFrequencyNumber.value = counter.toString();
              controller.frequencyNumber!.text =
                  controller.selectedFrequencyNumber.value;
            }),
            Text(
              '$counter',
              style: AppTextStyles.font10BlackCairoRegular.copyWith(
                fontSize: 14,
                color: AppColors.text,
                height: 1.2,
              ),
            ),
            _buildButton(Icons.add, () {
              setState(() {
                counter++;
              });
              controller.selectedFrequencyNumber.value = counter.toString();
              controller.frequencyNumber!.text =
                  controller.selectedFrequencyNumber.value;
            }),
          ],
        ),
      ),
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
