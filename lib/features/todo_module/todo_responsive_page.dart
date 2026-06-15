import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/responsive_helper.dart';
import 'core/constants/haptic_controller.dart';
import 'features/todo_list/presentation/ui/pages/mobile/todo_home_screen_mobile.dart';
import 'features/todo_list/presentation/ui/pages/tablet/todo_home_screen_tablet.dart';

class TodoResponsivePage extends StatelessWidget {
  const TodoResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
  Get.put(ToDoHapticController());
    return ResponsiveHelper(
        mobileWidget: TodoHomeScreenMobile(),
        tabletWidget: Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
                builder: (context) => TodoHomeScreenTablet());
          },
        ));
  }
}
