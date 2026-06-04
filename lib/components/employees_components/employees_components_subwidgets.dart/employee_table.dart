// Date Created :21/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :21/November/2023
// Objectives: this is a widget to customize the Work day table of the employee
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employees_hr_subwidgets/custom_table_appbar.dart';
import 'package:demo_app/core/dummy_data/chats_lists.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';

// ignore: depend_on_referenced_package

class EmployeeTableData extends StatefulWidget {
  const EmployeeTableData({
    super.key,
    this.isEmployeeScreen = false,
  });
  final bool isEmployeeScreen;

  @override
  State<EmployeeTableData> createState() => _EmployeeTableDataState();
}

class _EmployeeTableDataState extends State<EmployeeTableData> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    TextStyle tableDataTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize:
          isTablet ? FontConstants.fontSize014.w : FontConstants.fontSize030.w,
      color: Theme.of(context).colorScheme.inverseSurface,
      fontWeight: FontWeight.w400,
    );
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.isEmployeeScreen
              ? 0
              : isTablet
                  ? 0.01.w
                  : 0.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTableAppBar(
              offset: const Offset(0, 0),
              titles: [
                'Working Days'.tr,
                'Check In Time'.tr,
                'Check Out Time'.tr
              ],
              columnsCount: 3),
          Expanded(
            child: ListView.builder(
padding: EdgeInsets.zero,
                itemCount: workDayDat.length,
                itemBuilder: (context, index) {
                  bool isLastItem = index == workDayDat.length - 1;
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(isLastItem ? 8.0 : 0.0),
                        ),
                        color: index % 2 == 0
                            ? isTablet
                                ? Theme.of(context).colorScheme.surfaceVariant
                                : Theme.of(context).colorScheme.onBackground
                            : Theme.of(context).colorScheme.inversePrimary),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.isEmployeeScreen
                              ? Get.locale.toString().contains('en')
                                  ? 0.018.w
                                  : 0.02.w
                              : 0.015.w,
                          vertical: isTablet ? 0.025.h : 0.015.h),
                      child: Row(
                        children: [
                          Container(
                            width: widget.isEmployeeScreen
                                ? 0.155.w
                                : isTablet
                                    ? 0.262.w
                                    : 0.18.w,
                            child: Text(
                              textAlign: !isTablet ? TextAlign.center : null,
                              workDayDat[index].days.tr,
                              style: tableDataTextStyle,
                            ),
                          ),
                          SizedBox(
                            width: isTablet ? 0 : 0.14.w,
                          ),
                          SizedBox(
                            width: widget.isEmployeeScreen
                                ? 0.155.w
                                : isTablet
                                    ? 0.26.w
                                    : 0.29.w,
                            child: Text(workDayDat[index].checkIn.tr,
                                style: tableDataTextStyle),
                          ),
                          Text(
                            workDayDat[index].checkOut.tr,
                            style: tableDataTextStyle,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
