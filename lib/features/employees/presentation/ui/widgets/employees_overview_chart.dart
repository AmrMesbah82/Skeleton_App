import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/employees/presentation/controller/employee_controller.dart';

import 'custom_employee_chart.dart';

class EmployeesOverviewChart extends StatelessWidget {
  EmployeesOverviewChart({super.key});
  EmployeeController addEmployeeController = Get.find();
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    if (isPortrait) {
      return SizedBox(
        width: 0.4.w,
        height: 0.3.h,
        child: CustomEmployeeChartContainer(
          imagePath: "assets/images/case_vertical.svg",
          isEmployeeChart: true,
          isTransparent: true,
          width: double.infinity,
          height: 0.248,
          textSizeTexts: 0.023,
          textSizeValues: 0.021,
          title: 'Employees Overview',
          texts: ['Male'.tr, 'Female'.tr],
          values: [
            addEmployeeController.allEmployees!
                .where((element) => element.gender!.last! == 'male')
                .toList()
                .length
                .toString(),
            addEmployeeController.allEmployees!
                .where((element) => element.gender!.last! == 'female')
                .toList()
                .length
                .toString()
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 0.3.w,
        height: 0.32.h,
        child: CustomEmployeeChartContainer(
          imagePath: "assets/images/case_vertical.svg",
          isEmployeeChart: true,
          isTransparent: true,
          width: double.infinity,
          height: 0.248,
          textSizeTexts: 0.023,
          textSizeValues: 0.021,
          title: 'Employees Overview',
          texts: ['Male'.tr, 'Female'.tr],
          values: [
            addEmployeeController.allEmployees!
                .where((element) => element.gender!.last! == 'male')
                .toList()
                .length
                .toString(),
            addEmployeeController.allEmployees!
                .where((element) => element.gender!.last! == 'female')
                .toList()
                .length
                .toString()
          ],
        ),
      );
    }
  }
}
