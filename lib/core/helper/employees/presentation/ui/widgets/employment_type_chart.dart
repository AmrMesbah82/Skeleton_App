import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/helper/employees/presentation/controller/employee_controller.dart';
import 'package:demo_app/core/helper/employees/presentation/ui/widgets/custom_vertical_chart.dart';

class EmploymentTypeChart extends StatelessWidget {
  EmploymentTypeChart({super.key});
  EmployeeController addEmployeeController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    if (isPortrait) {
      return SizedBox(
        width: 0.42.w,
        height: 0.4.h,
        child: CustomVerticalChart(
          innerTitle: "Employees",
          imagePath: "assets/images/case_vertical.svg",
          isTransparent: true,
          width: double.infinity,
          height: 0.248,
          textSizeTexts: 0.023,
          textSizeValues: 0.021,
          title: 'Employment Type',
          texts: ["Full-time".tr, "Part-time".tr, "Contract".tr],
          values: [
           /* addEmployeeController.allEmployees!
                .where((element) =>
                    element.jobCompensation!.jobCompensation!.last ==
                    'full-time')
                .toList()
                .length
                .toString(),
            addEmployeeController.allEmployees!
                .where((element) =>
                    element.jobCompensation!.jobCompensation!.last ==
                    'part-time')
                .toList()
                .length
                .toString(),
            addEmployeeController.allEmployees!
                .where((element) =>
                    element.jobCompensation!.jobCompensation!.last ==
                    'contract')
                .toList()
                .length
                .toString(),*/
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 0.205.w,
        height: 0.44.h,
        child: CustomVerticalChart(
          innerTitle: "Employees",
          imagePath: "assets/images/case_vertical.svg",
          isTransparent: true,
          width: double.infinity,
          height: 0.248,
          textSizeTexts: 0.023,
          textSizeValues: 0.021,
          title: 'Employment Type',
          texts: ["Full-time".tr, "Part-time".tr, "Contract".tr],
          values: [
         /*   addEmployeeController.allEmployees!
                .where((element) =>
                    element.jobCompensation!.jobCompensation!.last ==
                    'full-time')
                .toList()
                .length
                .toString(),
            addEmployeeController.allEmployees!
                .where((element) =>
                    element.jobCompensation!.jobCompensation!.last ==
                    'part-time')
                .toList()
                .length
                .toString(),
            addEmployeeController.allEmployees!
                .where((element) =>
                    element.jobCompensation!.jobCompensation!.last ==
                    'contract')
                .toList()
                .length
                .toString(),*/
          ],
        ),
      );
    }
  }
}
