import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_text_styles.dart';
import 'package:demo_app/features/external/todo_module/core/constants/enum.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/status_model.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/todo_model.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';

import '../../../../../core/constants/haptic_controller.dart';

/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       This is a very simple widget that displays the name and icon of a todo item.
///
/// Author:            Ahmed Mahmoud,
/// Date:              March/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------

class ToDoItemNameAndIcon extends StatelessWidget {
  const ToDoItemNameAndIcon({
    super.key,
    required this.todoModel,
    required this.controller,
    // required this.isDark,
    this.detailsScreen,
  });

  final TodoModel todoModel;
  final TodoController controller;
  // final bool isDark;
  final bool? detailsScreen;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        GestureDetector(
          onTap: () {
            Get.find<ToDoHapticController>().triggerHapticFeedback(
              vibration: VibrateType.lightImpact,
              hapticFeedback: HapticFeedback.lightImpact,
            );
            controller.changeToDoStatus(todoModel: todoModel);
          },
          child: todoModel.status!.status == TodoStatus.done
              ? SvgPicture.asset(
                  'assets/icons/CheckListFilled.svg',
                  height: detailsScreen == true ? 24 : 20,
                  width: detailsScreen == true ? 24 : 20,
                )
              : SvgPicture.asset(
                  'assets/icons/Check List.svg',
                  height: detailsScreen == true ? 24 : 20,
                  width: detailsScreen == true ? 24 : 20,
                ),
        ),
        Expanded(
          child: Align(
            alignment: Get.locale.toString().contains('en')
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Baseline(
              baseline: detailsScreen == true ? 15 : 14,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                todoModel.name.name.last!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font10BlackCairoRegular.copyWith(
                    fontSize: detailsScreen == true ? 15 : 14,
                    color:
                        // isDark ? AppColors.moreLightGrey :
                        AppColors.black,
                    fontWeight: FontWeight.w600,
                    decoration: todoModel.status!.status == TodoStatus.done
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
          ),
        ),
        SizedBox(width: 25),
      ],
    );
  }
}
