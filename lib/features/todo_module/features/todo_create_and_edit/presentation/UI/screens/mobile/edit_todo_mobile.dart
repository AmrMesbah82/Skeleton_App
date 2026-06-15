import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_theme.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/column_request_data.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/custom_icon_button.dart';
import 'package:demo_app/features/todo_module/core/constants/app_constanst.dart';
import 'package:demo_app/features/todo_module/core/widgets/add_todo_reminder_section.dart';
import 'package:demo_app/features/todo_module/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/features/todo_module/core/widgets/frequency_section.dart';
import 'package:demo_app/features/todo_module/core/widgets/publishing_section.dart';
import 'package:demo_app/features/todo_module/features/todo_create_and_edit/presentation/UI/widgets/switch_text_row.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/proiority_model.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/todo_model.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';

/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       This file represents the mobile ui for editing an existing To-Do.
///                    It allows the user to update the name, description, priority,
///                    optional schedule (start/end date & time), reminders, and frequency settings.
///
/// Author:            Ahmed Mahmoud,
/// Date:              10/March/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------

class EditTodoMobile extends StatefulWidget {
  const EditTodoMobile({super.key, required this.todoModel});
  final TodoModel todoModel;
  @override
  State<EditTodoMobile> createState() => _EditTodoMobileState();
}

class _EditTodoMobileState extends State<EditTodoMobile> {
  @override
  void initState() {
    final todoController = Get.find<TodoController>();
    todoController.initEditControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoController>(
      builder: (controller) => Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: controller.createTodoFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBarMobile(
                    showIcon: true,
                    title: "Edit ${widget.todoModel.name.name.first}".tr),
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
                              ColumnRequestData(
                                  title: AppConstants.name.tr,
                                  isTextField: true,
                                  hint: AppConstants.typeHere.tr,
                                  isOptional: false,
                                  textController: controller.nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Name cannot be empty".tr;
                                    }
                                    return null;
                                  },
                                  controllerState: (value) {
                                    controller.update();
                                  },
                                  controllerfinishState: (value) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  isExpanded: true),
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
                              ColumnRequestData(
                                title: AppConstants.priority.tr,
                                isTextField: false,
                                hint: AppConstants.choose.tr,
                                controllerfinishState: (value) =>
                                    FocusScope.of(context).unfocus(),
                                isOptional: false,
                                dropdownValue: controller
                                        .selectedPriority.value.isEmpty
                                    ? null
                                    : PriorityModel.getDisplayText(
                                        PriorityModel.fromStoredValue(controller
                                                .selectedPriority.value) ??
                                            TodoPriority.medium),
                                buttonWidth: double.infinity,
                                dropWidth:
                                    MediaQuery.of(context).size.width - 60,
                                isExpanded: true,
                                dropDownValueState: (val) {
                                  // if (val != null) {
                                  controller.selectedPriority.value =
                                      val.toString();
                                  // }
                                  controller.priorityController!.text =
                                      controller.selectedPriority.value;
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
                              const SizedBox(height: 11),
                              SwitchTextRow(
                                onToggle: controller.switchScheduale,
                                title: AppConstants.scheduled.tr,
                                value: controller.isScheduale,
                              ),
                              const SizedBox(height: 11),
                              controller.isScheduale
                                  ? SchedualeSection()
                                  : SizedBox(),
                              SizedBox(height: controller.isScheduale ? 18 : 0),
                              AddTodoReminderSection(),
                              const SizedBox(height: 18),
                              SwitchTextRow(
                                onToggle: controller.switchFrequency,
                                title: AppConstants.setFrequency.tr,
                                value: controller.isFrequency,
                              ),
                              const SizedBox(height: 11),
                              controller.isFrequency
                                  ? FrequencySection()
                                  : SizedBox(),
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
                                todoModel: widget.todoModel, context: context);
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
        ),
      ),
    );
  }
}
