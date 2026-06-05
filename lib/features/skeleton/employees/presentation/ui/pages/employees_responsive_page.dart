import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/employees/presentation/ui/pages/mobile/employees_screen_mobile.dart';
import 'package:demo_app/features/skeleton/settings/presentation/controller/settings_controller.dart';

import 'package:demo_app/core/widgets/responsive_helper.dart';
import 'tablet/employees_screen.dart';
GlobalKey employeesNavKey = GlobalKey();

class EmployeesResponsivePage extends StatelessWidget {
   EmployeesResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    return ResponsiveHelper(
        mobileWidget: EmployeesScreenMobile(), tabletWidget:
     Navigator(
       key: employeesNavKey,
      onGenerateRoute: (settings) {

        return MaterialPageRoute(
          builder: (context) => EmployeesScreen(),
        );
      },
     )
    );
  }
}
