import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/theme/app_theme.dart';
import 'package:demo_app/features/todo_module/core/constants/app_constanst.dart';
import 'package:demo_app/features/todo_module/core/constants/capitalization_functions.dart';
import 'package:demo_app/features/todo_module/core/helper/date_helper.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/items_list_view.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/todo_item_chip_container.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/todo_item_name_and_icon.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/upper_information_chips.dart';

import '../../../data/models/todo_model.dart';
import '../../controllers/todo_controller.dart';

/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       A widget that displays a todo list item.
///                    The widget shows the title, description, date and time of the todo item.
///                    There is also an option to mark the item as done or undone.
///                    The widget is used in the TodoScreen widget.
///
/// Author:            Ahmed Mahmoud,
/// Date:              March/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------

class TodoHomeContainerMobile extends StatelessWidget {
  const TodoHomeContainerMobile({super.key, required this.todoModel});

  final TodoModel todoModel;

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    int? doneItems = (todoModel.comments ?? [])
        .where((comment) => comment!.itemIsDone!.commentIsDone == true)
        .length;

    return GetBuilder<TodoController>(builder: (controller) {
      return SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UpperInformationChips(todoModel: todoModel, doneItems: doneItems),
              // Show space if there is no chips at all

              SizedBox(height: 10),

              //  Todo Title
              ToDoItemNameAndIcon(
                todoModel: todoModel,
                controller: controller,
                // isDark: isDark,
                detailsScreen: false,
              ),

              SizedBox(height: todoModel.comments?.isNotEmpty == true ? 14 : 0),

              // comment list
              if (todoModel.comments?.isNotEmpty == true)
                ItemsListView(todoModel: todoModel, isDark: isDark),

              // Description
              if (todoModel.description?.description?.last! !=
                      AppConstants.empty &&
                  todoModel.comments!.isEmpty)
                Padding(
                  padding: Get.locale?.languageCode == 'ar'
                      ? EdgeInsets.only(left: 70, right: 25)
                      : EdgeInsets.only(right: 70, left: 25),
                  child: Text(
                    todoModel.description?.description?.last?.capitalize ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font10BlackCairoRegular.copyWith(
                        fontSize: 12,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                        height: 1.8),
                  ),
                ),
              (todoModel.endDate?.date?.last != AppConstants.empty ||
                      todoModel.endTime?.time?.last != AppConstants.empty)
                  ? SizedBox(height: 15)
                  : SizedBox(height: 10),

              // End Date & Time
              if (todoModel.endDate?.date?.last != AppConstants.empty)
                Row(
                  children: [
                    TodoItemChipContainer(
                      title: Get.locale.toString().contains('en')
                          ? capitalizeMonth(todoModel.endDate?.date?.last ?? '')
                          : translateDate(capitalizeMonth(
                              todoModel.endDate?.date?.last ?? '')),
                      color: DateHelper.checkIsEnded(
                                date: todoModel.endDate?.date?.last ?? '',
                                time: todoModel.endTime?.time?.last ?? '',
                              ) ==
                              true
                          ? AppColors.red
                          : AppColors.background,
                      textColor: DateHelper.checkIsEnded(
                                date: todoModel.endDate?.date?.last ?? '',
                                time: todoModel.endTime?.time?.last ?? '',
                              ) ==
                              true
                          ? AppColors.white
                          : AppColors.black,
                      icon: SvgPicture.asset('assets/icons/SmallCalendar.svg',
                          color: DateHelper.checkIsEnded(
                                    date: todoModel.endDate?.date?.last ?? '',
                                    time: todoModel.endTime?.time?.last ?? '',
                                  ) ==
                                  true
                              ? AppColors.white
                              : AppTheme.isDark == false
                                  ? null
                                  : AppColors.white),
                    ),
                    const Spacer(),
                    if (todoModel.endTime!.time!.last != AppConstants.empty)
                      TodoItemChipContainer(
                        title: Get.locale.toString().contains('en')
                            ? capitalizeAmPm(
                                todoModel.endTime!.time!.last ?? "")
                            : translateTime(capitalizeAmPm(
                                todoModel.endTime?.time?.last ?? '')),
                        color: AppColors.background,
                        textColor: AppColors.darkGrey,
                        icon: SvgPicture.asset(
                          'assets/icons/ClockCircleSmall.svg',
                          color: AppColors.darkGrey,
                        ),
                      ),
                  ],
                )
            ],
          ),
        ),
      );
    });
  }
}
