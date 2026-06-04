import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/comments_model.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/todo_model.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/presentation/ui/widgets/todo_comment_title.dart';

/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       This widget displays a list of comments for a given TodoModel.
///
/// Author:            Ahmed Mahmoud,
/// Date:              10/March/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------

class ItemsListView extends StatelessWidget {
  const ItemsListView({
    super.key,
    required this.todoModel,
    required this.isDark,
  });

  final TodoModel todoModel;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    TodoController controller = Get.find<TodoController>();
    return Padding(
      padding: Get.locale?.languageCode == 'ar'
          ? EdgeInsets.only(right: 25)
          : EdgeInsets.only(left: 25),
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount:
            todoModel.comments!.length <= 2 ? todoModel.comments!.length : 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          // If there are 2 or fewer comments, show all
          if (todoModel.comments!.length <= 2) {
            return TodoCommentTextAndIcon(
              detailsScreen: false,
              onTap: () {
                controller.changeCommentStatus(
                    todoModel: todoModel, index: index);
              },
              todoModel: todoModel,
              index: index,
            );
          } else {
            // Separate done and undone comments
            List<CommentModel> unDoneComments = [];
            List<CommentModel> doneComments = [];

            for (int i = 0; i < todoModel.comments!.length; i++) {
              if (todoModel.comments![i]!.itemIsDone!.commentIsDone == false) {
                unDoneComments.add(todoModel.comments![i]!);
              } else {
                doneComments.add(todoModel.comments![i]!);
              }
            }

            // Determine which comments to display
            List<CommentModel> commentsToDisplay = [];

            if (unDoneComments.length >= 2) {
              // Show first 2 undone comments
              commentsToDisplay = unDoneComments.take(2).toList();
            } else {
              // Show all undone (0 or 1) plus enough done to make 2 total
              commentsToDisplay = [...unDoneComments];
              int needed = 2 - commentsToDisplay.length;
              if (needed > 0 && doneComments.isNotEmpty) {
                commentsToDisplay.addAll(doneComments.take(needed));
              }
            }

            // Only show the comments we decided to display
            if (index < commentsToDisplay.length) {
              // Find the original index of this comment
              int originalIndex =
                  todoModel.comments!.indexOf(commentsToDisplay[index]);

              return TodoCommentTextAndIcon(
                detailsScreen: false,
                onTap: () {
                  controller.changeCommentStatus(
                      todoModel: todoModel, index: originalIndex);
                },
                todoModel: todoModel,
                index: originalIndex,
              );
            } else {
              return SizedBox.shrink(); // Hide extra items
            }
          }
        },
      ),
    );
  }
}
