import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_text_styles.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_theme.dart';
import 'package:demo_app/features/external/todo_module/core/components/other_components/column_request_data.dart';
import 'package:demo_app/features/external/todo_module/core/components/other_components/custom_appbar.dart';
import 'package:demo_app/features/external/todo_module/core/components/other_components/custom_drawer.dart';
import 'package:demo_app/features/external/todo_module/core/components/other_components/custom_icon_button.dart';
import 'package:demo_app/features/external/todo_module/core/constants/app_constanst.dart';
import 'package:demo_app/features/external/todo_module/core/widgets/add_todo_reminder_section.dart';
import 'package:demo_app/features/external/todo_module/core/widgets/frequency_section.dart';
import 'package:demo_app/features/external/todo_module/core/widgets/publishing_section.dart';
import 'package:demo_app/features/external/todo_module/features/todo_create_and_edit/presentation/UI/widgets/switch_text_row.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/proiority_model.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/todo_model.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';

/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       This file represents the Tablet ui for editing an existing To-Do.
///                    It allows the user to update the name, description, priority,
///                    optional schedule (start/end date & time), reminders, and frequency settings.
///
/// Author:            Ahmed Mahmoud,
/// Date:              10/March/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------

class EditTodoTablet extends StatefulWidget {
  const EditTodoTablet({super.key, required this.todoModel});
  final TodoModel todoModel;

  @override
  State<EditTodoTablet> createState() => _EditTodoTabletState();
}

class _EditTodoTabletState extends State<EditTodoTablet> {
  @override
  void initState() {
    final todoController = Get.find<TodoController>();
    todoController.initEditControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GetBuilder<TodoController>(
      builder: (controller) => Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: controller.createTodoFormKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDrawer(selectedIndex: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            children: [
                              Baseline(
                                baseline: 25,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  widget.todoModel.name.name.first!,
                                  style: AppTextStyles.font28BlackSemiBoldCairo
                                      .copyWith(
                                    color: AppColors.black,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              !Get.locale.toString().contains('ar')
                                  ? SvgPicture.asset(
                                      'assets/icons/arrow_right_mobile.svg',
                                      color: AppColors.black,
                                      width: 30,
                                    )
                                  : SvgPicture.asset(
                                      'assets/icons/arrowright2.svg',
                                      color: AppColors.black,
                                      width: 30,
                                    ),
                              Baseline(
                                baseline: 25,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  AppConstants.edit.tr,
                                  style: AppTextStyles.font28BlackSemiBoldCairo
                                      .copyWith(
                                    color: AppColors.black,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.white),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ColumnRequestData(
                                              title: AppConstants.name.tr,
                                              isTextField: true,
                                              hint: AppConstants.typeHere.tr,
                                              isOptional: false,
                                              textController:
                                                  controller.nameController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Name cannot be empty"
                                                      .tr;
                                                }
                                                return null;
                                              },
                                              controllerState: (value) {
                                                controller.update();
                                              },
                                              controllerfinishState: (value) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              isExpanded: true),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: ColumnRequestData(
                                            title: AppConstants.priority.tr,
                                            isTextField: false,
                                            hint: AppConstants.choose.tr,
                                            controllerfinishState: (value) =>
                                                FocusScope.of(context)
                                                    .unfocus(),
                                            isOptional: false,
                                            dropdownValue: controller
                                                    .selectedPriority
                                                    .value
                                                    .isEmpty
                                                ? null
                                                : PriorityModel.getDisplayText(
                                                    PriorityModel.fromStoredValue(
                                                            controller
                                                                .selectedPriority
                                                                .value) ??
                                                        TodoPriority.medium),
                                            buttonWidth: double.infinity,
                                            dropWidth: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                85,
                                            isExpanded: true,
                                            dropDownValueState: (val) {
                                              // if (val != null) {
                                              controller.selectedPriority
                                                  .value = val.toString();
                                              // }
                                              controller.priorityController!
                                                      .text =
                                                  controller
                                                      .selectedPriority.value;
                                            },
                                            dropDownItems: [
                                              TodoPriority.low
                                                  .toString()
                                                  .split('.')
                                                  .last
                                                  .tr,
                                              TodoPriority.medium
                                                  .toString()
                                                  .split('.')
                                                  .last
                                                  .tr,
                                              TodoPriority.high
                                                  .toString()
                                                  .split('.')
                                                  .last
                                                  .tr,
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 11),
                                    ColumnRequestData(
                                      maxlength: 500,
                                      title: AppConstants.description.tr,
                                      isTextField: true,
                                      hint: AppConstants.typeHere.tr,
                                      hasBeenTouched: true,
                                      isExpanded: true,
                                      isOptional: false,
                                      maxlines: 3,
                                      isSetting: true,
                                      fillColor: AppTheme.isDark == false
                                          ? AppColors.lightGrey
                                          : AppColors.text,
                                      textController:
                                          controller.descriptionController,
                                      controllerState: (value) {
                                        controller.update();
                                      },
                                      controllerfinishState: (value) =>
                                          FocusScope.of(context).unfocus(),
                                    ),
                                    const SizedBox(height: 11),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchTextRow(
                                            onToggle:
                                                controller.switchScheduale,
                                            title: AppConstants.scheduled.tr,
                                            value: controller.isScheduale,
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Spacer(),
                                      ],
                                    ),
                                    const SizedBox(height: 11),
                                    controller.isScheduale
                                        ? SchedualeSection()
                                        : SizedBox(),
                                    SizedBox(
                                        height:
                                            controller.isScheduale ? 10 : 0),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: AddTodoReminderSection()),
                                        const SizedBox(width: 15),
                                        const Spacer(),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchTextRow(
                                            onToggle:
                                                controller.switchFrequency,
                                            title: AppConstants.setFrequency.tr,
                                            value: controller.isFrequency,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        const Spacer(),
                                      ],
                                    ),
                                    const SizedBox(height: 11),
                                    if (controller.isFrequency)
                                      Row(
                                        children: [
                                          Expanded(child: FrequencySection()),
                                          const SizedBox(width: 15),
                                          const Spacer(),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: CustomIconButton(
                                width: 150,
                                buttonText: AppConstants.edit.tr,
                                imagePath: "",
                                hasIcon: false,
                                onPressed: () {
                                  controller.editTodo(
                                      todoModel: widget.todoModel,
                                      context: context);
                                },
                              ),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      )
                    ],
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
