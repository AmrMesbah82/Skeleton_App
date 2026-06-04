// Date Created :21/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :21/November/2023
// Objectives: this is a widget to customize view of workday and assets table
import 'package:flutter/material.dart';
import 'package:demo_app/components/employees_components/employees_components_subwidgets.dart/assets_container.dart';
import 'package:demo_app/components/employees_components/employees_components_subwidgets.dart/employee_table.dart';
import 'package:demo_app/components/employees_components/employees_components_subwidgets.dart/table_info_appbar.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class EmployeeInfoTableContainer extends StatefulWidget {
  const EmployeeInfoTableContainer({super.key});

  @override
  State<EmployeeInfoTableContainer> createState() =>
      _EmployeeInfoTableContainerState();
}

class _EmployeeInfoTableContainerState
    extends State<EmployeeInfoTableContainer> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
   
    return Container(
      height: 0.5.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          TableContainerInfoAppBar(
              selectedIndex: selectedIndex,
              selectedIndexState: (value) {
                setState(() {
                  selectedIndex = value;
                });
              }),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: 0.015.h, horizontal: 0.02.w),
            child: selectedIndex == 0
                ? SizedBox(
                    height: 0.4.h,
                    child: const EmployeeTableData())
                : SizedBox(
                    height: 0.25.w,
                    child: ListView.builder(
padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.015.h),
                          child: const AssetsContainer(),
                        );
                      },
                      itemCount: 2,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
