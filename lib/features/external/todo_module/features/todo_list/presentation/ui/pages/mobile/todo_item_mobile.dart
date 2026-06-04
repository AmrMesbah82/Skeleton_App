import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/presentation/ui/widgets/todo_details_screen_mobile.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/presentation/ui/widgets/todo_home_container_mobile.dart';

import '../../../../../../../../../nav_bar_package.dart/functions.dart';

/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       non visibile screen in app just to make view more simple contains todo Item and its details navigation
/// Author:            Ahmed Mahmoud,
/// Date:              10/March/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------
class ToDoItemMobile extends StatelessWidget {
  const ToDoItemMobile({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    TodoController controller = Get.find<TodoController>();
    return GestureDetector(
      onTap: () => PersistentNavBarNavigator.pushNewScreen(
        context,
        withNavBar: false,
        screen: TodoDetailsScreenMobile(
          todoModel: controller.filteredTodoList[index],
        ),
      ),
      child: TodoHomeContainerMobile(
        todoModel: controller.filteredTodoList[index],
      ),
    );
  }
}
