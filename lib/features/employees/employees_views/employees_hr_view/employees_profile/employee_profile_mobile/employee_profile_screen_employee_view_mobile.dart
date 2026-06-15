import 'package:demo_app/features/employee/data/models/emplyees_model/new_employee_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Stub: EmployeeProfileScreenMobileEmployeeViewScreen
class EmployeeProfileScreenMobileEmployeeViewScreen extends StatelessWidget {
  final NewEmployeeModelHistory employee;
  const EmployeeProfileScreenMobileEmployeeViewScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Profile'.tr)),
      body: Center(child: Text('${employee.firstName?.last ?? ''} ${employee.lastName?.last ?? ''}')),
    );
  }
}
