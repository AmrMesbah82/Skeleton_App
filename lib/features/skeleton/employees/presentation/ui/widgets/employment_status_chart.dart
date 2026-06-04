import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'custom_column_charts.dart';
import '../../controller/employee_controller.dart';

class EmploymentStatusChart extends StatelessWidget {
  EmploymentStatusChart({super.key});
  EmployeeController addEmployeeController = Get.find();
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    if (isPortrait) {
      return SizedBox(
        width: 0.82.w,
        height: 0.48.h,
        child: CustomColumnChartContainer(
          line: true,
          imagePath: "assets/images/case_vertical.svg",
          isTransparent: true,
          width: double.infinity,
          height: 0.248,
          textSizeTexts: 0.023,
          textSizeValues: 0.021,
          isSmallContainer: true,
          title: 'Employees Status',
          texts: [
            'Employees Added'.tr,
            'Employees Terminated'.tr,
          ],
          values: const ['20', '10'],
        ),
      );
    } else {
      return SizedBox(
        width: 0.62.w,
        height: 0.44.h,
        child: CustomColumnChartContainer(
          line: true,
          imagePath: "assets/images/case_vertical.svg",
          isTransparent: true,
          width: double.infinity,
          height: 0.248,
          textSizeTexts: 0.023,
          textSizeValues: 0.021,
          isSmallContainer: true,
          title: 'Employees Status',
          texts: [
            'Employees Added'.tr,
            'Employees Terminated'.tr,
          ],
          values: const ['20', '10'],
        ),
      );
    }
  }
}
