import 'package:demo_app/features/external/main_core/features/employee/data/models/emplyees_model/new_employee_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Stub: EmployeeDetailedInfo
class EmployeeDetailedInfo extends StatelessWidget {
  final NewEmployeeModelHistory employee;
  final double reviewRating;
  final int? index;
  const EmployeeDetailedInfo({super.key, required this.employee, this.reviewRating = 5, this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Details'.tr)),
      body: Center(child: Text('${employee.firstName?.last ?? ''} ${employee.lastName?.last ?? ''}')),
    );
  }
}
