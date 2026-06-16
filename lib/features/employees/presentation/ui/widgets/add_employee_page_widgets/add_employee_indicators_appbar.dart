import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/employees/presentation/ui/widgets/add_employee_page_widgets/indicator_column.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import '../../../../../../core/dummy_data/mode_changer.dart';
import '../../../controller/add_new_employee_controller.dart';

// ignore: must_be_immutable
class AddNewEmployeeIndicators extends StatefulWidget {
  AddNewEmployeeIndicators(
      {super.key,
      //  required this.permissions,
      required this.selectedIndex,
 });

  int selectedIndex;

  @override
  State<AddNewEmployeeIndicators> createState() =>
      _AddNewEmployeeIndicatorsState();
}

class _AddNewEmployeeIndicatorsState extends State<AddNewEmployeeIndicators> {
  AddNewEmployeeController addNewEmployeeController = Get.find();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Mode.addNewEmployeeIndex == 2
              ? 0.01.h
              : Mode.addNewEmployeeIndex == 5
                  ? 0.025.h
                  : 0.03.h),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.inversePrimary),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.01.w, vertical: 0.03.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IndicatorColumn(
                title: "Personal Information",
                value: addNewEmployeeController.personalInfoValue,
                widthStrok: 0.145.w,
                currentIndex: widget.selectedIndex == 0,
              ),
              IndicatorColumn(
                title: "Health Insurance",
                value: addNewEmployeeController.healthInsuranceValue,
                widthStrok: 0.115.w,
                currentIndex: widget.selectedIndex == 1,
              ),
              IndicatorColumn(
                title: "Position Details",
                value: addNewEmployeeController.psitionDetailsValue,
                widthStrok: 0.11.w,
                currentIndex: widget.selectedIndex == 2,
              ),
              IndicatorColumn(
                title: "Additional Information",
                value: addNewEmployeeController.additionalInfo,
                widthStrok: 0.155.w,
                currentIndex: widget.selectedIndex == 4,
              ),
              IndicatorColumn(
                title: "Preview",
                value: addNewEmployeeController.preview,
                widthStrok: 0.06.w,
                currentIndex: widget.selectedIndex == 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
