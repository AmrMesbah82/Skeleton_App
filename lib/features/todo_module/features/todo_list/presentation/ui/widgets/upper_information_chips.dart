import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/todo_module/core/constants/app_constanst.dart';
import 'package:demo_app/features/todo_module/core/constants/capitalization_functions.dart';
import 'package:demo_app/features/todo_module/core/constants/date_time_in_arabic.dart';
import 'package:demo_app/features/todo_module/core/constants/enum.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/frequency_model.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/status_model.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/todo_model.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/todo_item_chip_container.dart';

import '../../../../../core/constants/haptic_controller.dart';

/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       A widget that displays the list of yellow chips at the top of the todo item.
///                    The widget shows the frequency, scheduled date and time, and deleted status.
///                    this is a list of the widget called TodoItemChipContainer
///
/// Author:            Ahmed Mahmoud,
/// Date:              March/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------

class UpperInformationChips extends StatelessWidget {
  const UpperInformationChips({
    super.key,
    required this.todoModel,
    required this.doneItems,
  });

  final TodoModel todoModel;
  final int? doneItems;

  @override
  Widget build(BuildContext context) {
    TodoController controller = Get.find<TodoController>();

    return ((todoModel.frequencyText!.frequencyText!.last != null) ||
            (todoModel.endDate!.date!.last != AppConstants.empty ||
                todoModel.endTime!.time!.last != AppConstants.empty) ||
            todoModel.status?.status == TodoStatus.deleted ||
            todoModel.comments?.isNotEmpty == true)
        ? SizedBox(
            height: 20,
            child: ListView(
              reverse: (todoModel.status!.status == TodoStatus.deleted)
                  ? true
                  : false,
              scrollDirection: Axis.horizontal,
              children: [
                // Show item Comments number
                if (todoModel.comments?.isNotEmpty == true &&
                    todoModel.status?.status != TodoStatus.deleted)
                  TodoItemChipContainer(
                    title: Get.locale?.languageCode == 'ar'
                        ? "${convertNumberToArabic(todoModel.comments!.length.toString())}/${convertNumberToArabic(doneItems.toString())}"
                        : "$doneItems/${todoModel.comments!.length.toString()}",
                  ),
                if (todoModel.comments?.isNotEmpty == true &&
                    todoModel.status?.status != TodoStatus.deleted)
                  SizedBox(width: 10),

                // Show frequency chip
                if (todoModel.frequencyText != null &&
                    todoModel.frequencyText!.frequencyText!.last != null &&
                    todoModel.status!.status != TodoStatus.deleted)
                  TodoItemChipContainer(
                    title: FrequencyText().getFrequencyText(
                        todoModel.frequencyText?.frequencyText?.last),
                  ),
                if (todoModel.frequencyText != null &&
                    todoModel.frequencyText!.frequencyText!.last != null &&
                    todoModel.status!.status != TodoStatus.deleted)
                  SizedBox(width: 10),
                // Check if item is deleted and show recovery button
                if (todoModel.status!.status == TodoStatus.deleted &&
                    controller.filterIndex == 3)
                  GestureDetector(
                    onTap: () {
                      Get.find<ToDoHapticController>().triggerHapticFeedback(
                          vibration: VibrateType.heavyImpact,
                          hapticFeedback: HapticFeedback.heavyImpact);
                      controller.recoverTodo(todoModel, context);
                    },
                    child: Container(
                      color: AppColors.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SvgPicture.asset("assets/images/Group.svg"),
                      ),
                    ),
                  ),
                if (todoModel.status!.status == TodoStatus.deleted &&
                    controller.filterIndex == 3)
                  SizedBox(width: 10),
                // Show scheduled chip
                if (todoModel.startDate!.date!.last != AppConstants.empty &&
                    todoModel.startTime!.time!.last != AppConstants.empty &&
                    todoModel.status?.status != TodoStatus.deleted)
                  TodoItemChipContainer(
                    title:
                        '${AppConstants.scheduled.tr}: ${Get.locale?.languageCode == 'ar' ? translateDate(todoModel.startDate?.date?.last?.capitalize ?? '') : todoModel.startDate?.date?.last?.capitalize} ${'At'.tr} ${Get.locale?.languageCode == 'ar' ? translateTime(capitalizeAmPm(todoModel.startTime!.time!.last!)) : capitalizeAmPm(todoModel.startTime!.time!.last!)}',
                  ),

                // Show scheduled chip
                if (todoModel.startDate!.date!.last != AppConstants.empty &&
                    todoModel.startTime!.time!.last == AppConstants.empty &&
                    todoModel.status!.status != TodoStatus.deleted)
                  TodoItemChipContainer(
                    title:
                        '${AppConstants.scheduled.tr}: ${Get.locale?.languageCode == 'ar' ? translateDate(todoModel.startDate?.date?.last?.capitalize ?? '') : todoModel.startDate?.date?.last?.capitalize}',
                  ),

                // Show deleted chip if item is deleted
                if (todoModel.status!.status == TodoStatus.deleted &&
                    controller.filterIndex != 3)
                  TodoItemChipContainer(
                    title: AppConstants.deleted.tr,
                    color: AppColors.red,
                    textColor: AppColors.white,
                  ),
                if (todoModel.status!.status == TodoStatus.deleted &&
                    controller.filterIndex != 3)
                  SizedBox(width: 10),
              ],
            ),
          )
        : SizedBox();
  }
}
