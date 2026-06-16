import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import '../../controller/employee_controller.dart';
import 'custom_employee_chart.dart';

class EmployeesNationalityChart extends StatelessWidget {
  EmployeesNationalityChart({super.key});
  EmployeeController addEmployeeController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    if (isPortrait) {
      return SizedBox(
        width: 0.42.w,
        height: 0.3.h,
        child: CustomEmployeeChartContainer(
          imagePath: "assets/images/case_vertical.svg",
          isEmployeeChart: true,
          isExpandedChart: true,
          isTransparent: true,
          width: double.infinity,
          height: 0.248,
          textSizeTexts: 0.023,
          textSizeValues: 0.021,
          title: 'Employees Nationality',
          texts: [
            addEmployeeController.topCountries.keys.toList()[0].toString(),
            if (addEmployeeController.topCountries.keys.toList().length > 1)
              addEmployeeController.topCountries.keys.toList()[1].toString(),
            if (addEmployeeController.topCountries.keys.toList().length > 2)
              addEmployeeController.topCountries.keys.toList()[2].toString(),
            "Other"
          ],
          mins: const [
            '95',
            '10',
            '10',
            '10',
            '10',
          ],
          values: [
            addEmployeeController.topCountries.values.toList()[0].toString(),
            if (addEmployeeController.topCountries.keys.toList().length > 1)
              addEmployeeController.topCountries.values.toList()[1].toString(),
            if (addEmployeeController.topCountries.keys.toList().length > 2)
              addEmployeeController.topCountries.values.toList()[2].toString(),
            addEmployeeController.allEmployees!
                .where((element) =>
                    element.nationality!.last !=
                        addEmployeeController.topCountries.keys
                            .toList()[0]
                            .toString() &&
                    element.nationality!.last !=
                        addEmployeeController.topCountries.keys
                            .toList()[1]
                            .toString() &&
                    element.nationality!.last !=
                        addEmployeeController.topCountries.keys
                            .toList()[2]
                            .toString())
                .toList()
                .length
                .toString(),
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
          isExpandedChart: true,
          isTransparent: true,
          width: double.infinity,
          height: 0.248,
          textSizeTexts: 0.023,
          textSizeValues: 0.021,
          title: 'Employees Nationality',
          texts: [
            addEmployeeController.topCountries.keys.toList()[0].toString(),
            if (addEmployeeController.topCountries.keys.toList().length > 1)
              addEmployeeController.topCountries.keys.toList()[1].toString(),
            if (addEmployeeController.topCountries.keys.toList().length > 2)
              addEmployeeController.topCountries.keys.toList()[2].toString(),
            "Other"
          ],
          mins: const [
            '95',
            '10',
            '10',
            '10',
            '10',
          ],
          values: [
            addEmployeeController.topCountries.values.toList()[0].toString(),
            if (addEmployeeController.topCountries.keys.toList().length > 1)
              addEmployeeController.topCountries.values.toList()[1].toString(),
            if (addEmployeeController.topCountries.keys.toList().length > 2)
              addEmployeeController.topCountries.values.toList()[2].toString(),
            addEmployeeController.allEmployees!
                .where((element) =>
                    element.nationality!.last !=
                        addEmployeeController.topCountries.keys
                            .toList()[0]
                            .toString() &&
                    element.nationality!.last !=
                        addEmployeeController.topCountries.keys
                            .toList()[1]
                            .toString() &&
                    element.nationality!.last !=
                        addEmployeeController.topCountries.keys
                            .toList()[2]
                            .toString())
                .toList()
                .length
                .toString(),
          ],
        ),
      );
    }
  }
}
