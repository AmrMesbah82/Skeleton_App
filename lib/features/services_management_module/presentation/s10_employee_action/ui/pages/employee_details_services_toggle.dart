/// ******************* FILE INFO *******************
/// File Name: employee_services_details_toggle.dart
/// Description: toggle in All Platform of this screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';

import 'package:demo_app/features/services_management_module/presentation/s10_employee_action/ui/pages/employee_details_services.dart';

class EmployeeDetailsServicesToggle extends StatelessWidget {
  const EmployeeDetailsServicesToggle({super.key, required this.approvalModel, required this.index});
  final ServicesHistoryModel approvalModel ;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {

          final isTablet = context.isTablet;
          final isLandscape = context.isLandscape;
          final width = MediaQuery.of(context).size.width;
          final height = MediaQuery.of(context).size.height;

          if (isTablet && isLandscape) {
            return EmployeeDetailsServicesScreenTablet(approvalModel:approvalModel , index: index,); //  tablet

          } else if (isTablet && !isLandscape) {
            return EmployeeDetailsServicesScreenTablet(approvalModel:approvalModel , index: index,); //  tablet

          } else if (!isTablet && isLandscape) {
            return EmployeeDetailsServicesScreenTablet(approvalModel:approvalModel , index: index,);  // mobile

          } else {
            return EmployeeDetailsServicesScreenTablet(approvalModel:approvalModel , index: index,);  // mobile

          }
        },
      ),
    );
  }
//CreatingNewServiceMobile()
//CreatingNewServiceScreen()
//CreatingNewServiceDesktop()
}

/*
return Scaffold(
body: LayoutBuilder(
builder: (context, constrain){
if (constrain.maxWidth >= 1200) {
return EmployeeDetailsServicesScreenFullScreen(approvalModel:approvalModel , index: index,); // Desktop
} else if (constrain.maxWidth >= 900) {
return EmployeeDetailsServicesScreenDesktop(approvalModel:approvalModel , index: index,); // Horizontal tablet
} else if (constrain.maxWidth >= 600) {
return EmployeeDetailsServicesScreenTablet(approvalModel:approvalModel , index: index,); //  tablet
} else {
return EmployeeDetailsServicesScreenMobile(approvalModel:approvalModel , index: index,);  // mobile
}

}),
);
 */
