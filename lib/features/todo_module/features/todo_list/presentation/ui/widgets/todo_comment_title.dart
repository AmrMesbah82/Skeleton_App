import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/status_model.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/todo_model.dart';

/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       This widget displays a comment text and an icon for each todo item.
///
/// Author:            Ahmed Mahmoud,
/// Date:              10/March/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------

class TodoCommentTextAndIcon extends StatelessWidget {
  const TodoCommentTextAndIcon({
    super.key,
    required this.todoModel,
    // required this.isDark,
    required this.index,
    required this.onTap,
    required this.detailsScreen,
    this.onDelete,
  });

  final TodoModel todoModel;

  // final bool isDark;
  final int index;
  final bool detailsScreen;
  final Function()? onDelete;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            height: 20,
            color: todoModel.status?.status == TodoStatus.deleted
                ? AppColors.darkGrey
                : null,
            todoModel.comments?[index]?.itemIsDone!.commentIsDone == true
                ? 'assets/icons/CheckListFilled.svg'
                : 'assets/icons/Check List.svg',
          ),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              todoModel.comments?[index]?.itemName ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font10BlackCairoMediam.copyWith(
                  fontSize: 12,
                  color:
                      //  isDark ? AppColors.moreLightGrey :
                      AppColors.black,
                  fontWeight: FontWeight.w600,
                  decoration:
                      todoModel.comments?[index]?.itemIsDone!.commentIsDone ==
                              true
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                  height: 1.8),
            ),
          ),
          Spacer(),
          if (detailsScreen)
            Padding(
              padding: Get.locale.toString().contains('en')
                  ? const EdgeInsets.only(right: 100)
                  : const EdgeInsets.only(left: 100),
              child: GestureDetector(
                onTap: onDelete,
                child: SvgPicture.asset(
                  'assets/icons/🦆 icon _trash_.svg',
                  height: 16.h,
                  color: todoModel.status!.status == TodoStatus.deleted
                      ? AppColors.darkGrey
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
