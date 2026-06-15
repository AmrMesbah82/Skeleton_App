import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/employees/presentation/controller/employee_controller.dart';

import 'package:demo_app/core/shared_components/buttons_beside_title_row.dart';

class EmployeesHeader extends StatelessWidget {
  EmployeesHeader({super.key});
  EmployeeController employeeController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: isTablet
              ? isPortrait
                  ? 0.0.h
                  : 0.015.h
              : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Org Chart".tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: isTablet
                    ? isPortrait
                        ? FontConstants.fontSize030.h
                        : FontConstants.fontSize038.h
                    : FontConstants.fontSize026.h,
                fontWeight: FontWeight.w600,
                letterSpacing:
                    Get.locale.toString().contains('en') ? 1.1 : null,
                color: Theme.of(context).colorScheme.inverseSurface),
          ),
          Mode.hr || Mode.owner
              ? ButtonsBesideTitle(
                  chartSelected: employeeController.chartSelected,
                  chartSelectedState: (value) {
                    employeeController.chartSelected = value;
                    employeeController.update();
                  },
                  orgSelected: employeeController.orgSelected,
                  orgSelectedState: (value) {
                    employeeController.orgSelected = value;
                    employeeController.update();
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
