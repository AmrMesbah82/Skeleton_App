/// ******************* FILE INFO *******************
/// File Name: employee_services_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s10_employee_action/ui/pages/employee_services.dart';

class EmployeeLayoutScreenServices extends StatelessWidget {
  const EmployeeLayoutScreenServices({super.key});

  @override
  Widget build(BuildContext context) {

    final isTablet = context.isTablet;
    final isLandscape = context.isLandscape;
    return Scaffold(
      body: Builder(
        builder: (context) {
          final width = MediaQuery.of(context).size.width;
          final height = MediaQuery.of(context).size.height;

          if (isTablet && isLandscape) {
            return EmployeeServicesScreenTablet(); // //
          } else if (isTablet && !isLandscape) {
            return EmployeeServicesScreenTablet(); // //
          } else if (!isTablet && isLandscape) {
            return EmployeeServicesScreenTablet(); // Mobil
          } else {
            return EmployeeServicesScreenTablet(); // Mobil
          }
        },
      ),
    );
  }

}

