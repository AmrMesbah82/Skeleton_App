import 'package:demo_app/core/nav_bar_package.dart/functions.dart' show PersistentNavBarNavigator;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/todo_details_screen_tablet.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/todo_home_container_tablet.dart';


/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       non visibile screen in app just to make view more simple contains todo Item and its details navigation
/// Author:            Ahmed Mahmoud,
/// Date:              10/March/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------

class TodoItemTablet extends StatelessWidget {
  const TodoItemTablet({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    TodoController controller = Get.find<TodoController>();
    return GestureDetector(
      onTap: () => PersistentNavBarNavigator.pushNewScreen(
        context,
        withNavBar: false,
        screen: TodoDetailsScreenTablet(
          todoModel: controller.filteredTodoList[index],
        ),
      ),
      child: TodoHomeContainerTablet(
        todoModel: controller.filteredTodoList[index],
      ),
    );
  }
}
