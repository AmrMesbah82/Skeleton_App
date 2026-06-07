// Date Created :15/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :15/November/2023
// Objectives: this is a widget to customize the table of attendance
// ignore_for_file: use_build_context_synchronously

import 'package:demo_app/core/theme/grc_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/external/main_core/features/employee/data/models/emplyees_model/new_employee_model.dart';
import 'package:demo_app/features/skeleton/employees/presentation/ui/widgets/employees_hr_appbar.dart';
import 'package:demo_app/components/job_components/custom_table_body.dart';
import 'package:demo_app/components/job_components/custom_table_header_new.dart';
import 'package:demo_app/core/dummy_data/chats_lists.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/employees/presentation/controller/employee_controller.dart';
import 'package:demo_app/features/skeleton/controllers/attendance_controller.dart';
import 'package:demo_app/features/skeleton/employees/employees_views/employee_detailed_info/employee_detailed_info_screen.dart';
import 'package:demo_app/features/skeleton/models/attendance_model.dart';
import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:page_transition/page_transition.dart';

import '../../../data/models/new_employee_model/emplyees_model/new_employee_model.dart';

class EmployeeTableDataHr extends StatefulWidget {
  const EmployeeTableDataHr({super.key});

  @override
  State<EmployeeTableDataHr> createState() => _EmployeeTableDataHrState();
}

class _EmployeeTableDataHrState extends State<EmployeeTableDataHr> {
  @override
  void initState() {
    getAllAttendances();
    super.initState();
  }

  List<AttendanceModel> filterAttendances = [];
  AttendanceController attendanceController = Get.find();
  Future<void> getAllAttendances() async {
    attendanceController.allAttendances =
        await attendanceController.getAllAttendance();
    attendanceController.allAttendances
        .sort((a, b) => b.date!.compareTo(a.date!));
    filterAttendances = await attendanceController.getAllAttendance();
    filterAttendances.sort((a, b) => b.date!.compareTo(a.date!));
    getAllEmployeeModel(
        attendanceController.allAttendances.map((e) => e.email!).toList());
    setState(() {});
  }

  List<NewEmployeeModelHistory> employeeModels = [];
  Future<void> getAllEmployeeModel(List<String> emails) async {
    employeeModels = [];
    for (var email in emails) {
      NewEmployeeModelHistory? employeeModel = NewEmployeeModelHistory();
      employeeModel = await addEmployeeController.getEmployee(email);
      employeeModels.add(employeeModel!);
    }

    setState(() {});
  }

  String searchText = '';
  String? status;
  String? delay;
  String? date;

  EmployeeController addEmployeeController = Get.find();
  // get the date from the string

  List<DateTime>? dates;
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    print('table data hr ${attendanceController.allAttendances.length}');
    TextStyle tableDataTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: isPortrait
          ? FontConstants.fontSize018.h
          : FontConstants.fontSize020.h,
      color: Theme.of(context).colorScheme.inverseSurface,
      fontWeight: FontWeight.w400,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmployeeHrAppBar(
          statusValue: status,
          dateValue: date,
          delayValue: delay,
          dateValueState: (value) {
            setState(() {
              attendanceController.allAttendances = filterAttendances;
              date = value;
              print('date1111 $date');
              dates = extractDates(value!);
              print("Start Date: ${dates![0]}");
              print("End Date: ${dates![1]}");
              attendanceController.allAttendances = attendanceController
                  .allAttendances
                  .where((element) =>
                      (DateTime.parse(element.date!).isAfter(dates![0]) &&
                          DateTime.parse(element.date!).isBefore(dates![1])) ||
                      (DateTime(
                              DateTime.parse(element.date!).year,
                              DateTime.parse(element.date!).month,
                              DateTime.parse(element.date!).day) ==
                          (DateTime(dates![0].year, dates![0].month,
                              dates![0].day))) ||
                      (DateTime(
                              DateTime.parse(element.date!).year,
                              DateTime.parse(element.date!).month,
                              DateTime.parse(element.date!).day) ==
                          (DateTime(
                              dates![1].year, dates![1].month, dates![1].day))))
                  .toList();
              status != null
                  ? attendanceController.allAttendances = attendanceController
                      .allAttendances
                      .where((element) => element.status!.contains(
                          status == 'On Time'
                              ? 'attendance'
                              : status!.toLowerCase()))
                      .toList()
                  : null;
              delay != null
                  ? attendanceController.allAttendances = attendanceController
                      .allAttendances
                      .where((element) =>
                          element.delay!.contains(delay!.toLowerCase()))
                      .toList()
                  : null;
              searchText != ''
                  ? attendanceController.allAttendances = attendanceController
                      .allAttendances
                      .where((element) =>
                          element.name!.contains(searchText.toLowerCase()))
                      .toList()
                  : null;
            });
          },
          statusState: (value) {
            print('value111111 $value');

            setState(() {
              attendanceController.allAttendances = filterAttendances;
              status = value;
              value != null
                  ? attendanceController.allAttendances = attendanceController
                      .allAttendances
                      .where((element) => element.status!.contains(
                          value == 'On Time'
                              ? 'attendance'
                              : value.toLowerCase()))
                      .toList()
                  : attendanceController.allAttendances = filterAttendances;
              if (date != null && date != 'Date') {
                attendanceController.allAttendances = attendanceController
                    .allAttendances
                    .where((element) =>
                        (DateTime.parse(element.date!).isAfter(dates![0]) &&
                            DateTime.parse(element.date!)
                                .isBefore(dates![1])) ||
                        (DateTime(
                                DateTime.parse(element.date!).year,
                                DateTime.parse(element.date!).month,
                                DateTime.parse(element.date!).day) ==
                            (DateTime(dates![0].year, dates![0].month,
                                dates![0].day))) ||
                        (DateTime(
                                DateTime.parse(element.date!).year,
                                DateTime.parse(element.date!).month,
                                DateTime.parse(element.date!).day) ==
                            (DateTime(dates![1].year, dates![1].month,
                                dates![1].day))))
                    .toList();
              }
              delay != null
                  ? attendanceController.allAttendances = attendanceController
                      .allAttendances
                      .where((element) =>
                          element.delay!.contains(delay!.toLowerCase()))
                      .toList()
                  : null;
              searchText != ''
                  ? attendanceController.allAttendances = attendanceController
                      .allAttendances
                      .where((element) =>
                          element.name!.contains(searchText.toLowerCase()))
                      .toList()
                  : null;
            });
          },
          delayState: (value) {
            print('value2222 $value');

            setState(() {
              attendanceController.allAttendances = filterAttendances;
              delay = value;
              value != null
                  ? attendanceController.allAttendances = attendanceController
                      .allAttendances
                      .where((element) =>
                          element.delay!.contains(value.toLowerCase()))
                      .toList()
                  : attendanceController.allAttendances = filterAttendances;
              if (date != null && date != 'Date') {
                attendanceController.allAttendances = attendanceController
                    .allAttendances
                    .where((element) =>
                        (DateTime.parse(element.date!).isAfter(dates![0]) &&
                            DateTime.parse(element.date!)
                                .isBefore(dates![1])) ||
                        (DateTime(
                                DateTime.parse(element.date!).year,
                                DateTime.parse(element.date!).month,
                                DateTime.parse(element.date!).day) ==
                            (DateTime(dates![0].year, dates![0].month,
                                dates![0].day))) ||
                        (DateTime(
                                DateTime.parse(element.date!).year,
                                DateTime.parse(element.date!).month,
                                DateTime.parse(element.date!).day) ==
                            (DateTime(dates![1].year, dates![1].month,
                                dates![1].day))))
                    .toList();
              }
              status != null
                  ? attendanceController.allAttendances = attendanceController
                      .allAttendances
                      .where((element) => element.status!.contains(
                          status == 'On Time'
                              ? 'attendance'
                              : status!.toLowerCase()))
                      .toList()
                  : null;
              searchText != ''
                  ? attendanceController.allAttendances = attendanceController
                      .allAttendances
                      .where((element) =>
                          element.name!.contains(searchText.toLowerCase()))
                      .toList()
                  : null;
            });
          },
          onChangedSearch: (value) {
            setState(() {
              searchText = value;
              attendanceController.allAttendances = filterAttendances;
              print('searchText $searchText');
              attendanceController.allAttendances = attendanceController
                  .allAttendances
                  .where((element) =>
                      element.name!.contains(searchText.toLowerCase()))
                  .toList();
              delay != null
                  ? attendanceController.allAttendances = attendanceController
                      .allAttendances
                      .where((element) =>
                          element.delay!.contains(delay!.toLowerCase()))
                      .toList()
                  : null;
              if (date != null && date != 'Date') {
                attendanceController.allAttendances = attendanceController
                    .allAttendances
                    .where((element) =>
                        (DateTime.parse(element.date!).isAfter(dates![0]) &&
                            DateTime.parse(element.date!)
                                .isBefore(dates![1])) ||
                        (DateTime(
                                DateTime.parse(element.date!).year,
                                DateTime.parse(element.date!).month,
                                DateTime.parse(element.date!).day) ==
                            (DateTime(dates![0].year, dates![0].month,
                                dates![0].day))) ||
                        (DateTime(
                                DateTime.parse(element.date!).year,
                                DateTime.parse(element.date!).month,
                                DateTime.parse(element.date!).day) ==
                            (DateTime(dates![1].year, dates![1].month,
                                dates![1].day))))
                    .toList();
              }
              status != null
                  ? attendanceController.allAttendances = attendanceController
                      .allAttendances
                      .where((element) => element.status!.contains(
                          status == 'On Time'
                              ? 'attendance'
                              : status!.toLowerCase()))
                      .toList()
                  : null;
            });
          },
          orgView: false,
          chartView: false,
          isFilterDataShow: false,
          isFilterDataState: (bool value) {},
          isSort: false,
          isSortState: (bool value) {},
          depName: TextEditingController(),
          depNameState: (TextEditingController value) {},
          depNameInArabic: TextEditingController(),
          depNameStateInArabic: (TextEditingController value) {},
        ),
        attendanceController.allAttendances.isEmpty || employeeModels.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(top: .26.h),
                  child: SizedBox(
                      width: isPortrait ? 0.055.h : 0.07.h,
                      height: isPortrait ? 0.055.h : 0.07.h,
                      child: const CircleProgressMaster()),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: isPortrait
                      ? 1.5.w
                      : 1.12.w, // width: isPortrait ? 2.0.w : 1.1.w,
                  height: 0.9.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTableHeaderNew(titles: [
                        'Name'.tr,
                        'Status'.tr,
                        'Date'.tr,
                        'Oncoming Time'.tr,
                        'Leaving Time'.tr,
                        'Total Time'.tr,
                        'Action'.tr
                      ], columnsCount: 7),
                      Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount:
                                attendanceController.allAttendances.length,
                            itemBuilder: (context, index) {
                              NewEmployeeModelHistory employeeModel = employeeModels[
                                  employeeModels.indexWhere((element) =>
                                      element.email!.last! ==
                                      attendanceController
                                          .allAttendances[index].email)];
                              return Container(
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(8),
                                  color: index % 2 == 0
                                      ? themeController.currentTheme ==
                                              MyThemeData.lightTheme
                                          ? Color(0xFFf1f1f1)
                                          : MyThemeData.darkBackGround
                                      : themeController.currentTheme ==
                                              MyThemeData.lightTheme
                                          ? MyThemeData.colorWhite
                                          : Color(0xFF28282B),
                                ),
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0.02.w, vertical: 0.025.h),
                                    child: Row(
                                      children: [
                                        CustomTableBody(
                                          text: Get.locale
                                                  .toString()
                                                  .contains('en')
                                              ? capitalize(
                                                  "${employeeModel.firstName!.last!} ${employeeModel.lastName!.last!}")
                                              : "${employeeModel.firstNameInArabic!.last!} ${employeeModel.lastNameInArabic!.last!}",
                                        ),
                                        CustomTableBody(
                                          text: capitalize(
                                            attendanceController
                                                .allAttendances[index].status!,
                                          ).tr,
                                          textColor: attendanceController
                                                      .allAttendances[index]
                                                      .status ==
                                                  "attendance"
                                              ? MyThemeData.unBlock
                                              : attendanceController
                                                          .allAttendances[index]
                                                          .status ==
                                                      "absent"
                                                  ? MyThemeData.colorRed
                                                  : MyThemeData.warning,
                                        ),
                                        CustomTableBody(
                                          text: Get.locale
                                                  .toString()
                                                  .contains('en')
                                              ? DateFormat('MMM dd, yyyy')
                                                  .format(DateTime.parse(
                                                      attendanceController
                                                          .allAttendances[index]
                                                          .date!))
                                              : convertToArabicDate(DateFormat(
                                                      'MMM dd, yyyy')
                                                  .format(DateTime.parse(
                                                      attendanceController
                                                          .allAttendances[index]
                                                          .date!))),
                                        ),
                                        CustomTableBody(
                                          text: Get.locale
                                                  .toString()
                                                  .contains('en')
                                              ? attendanceController
                                                  .allAttendances[index]
                                                  .checkInTime!
                                              : convertTimeToArabic(
                                                  attendanceController
                                                      .allAttendances[index]
                                                      .checkInTime!,
                                                ),
                                        ),
                                        CustomTableBody(
                                          text: Get.locale
                                                  .toString()
                                                  .contains('en')
                                              ? attendanceController
                                                  .allAttendances[index]
                                                  .checkOutTime!
                                              : convertTimeToArabic(
                                                  attendanceController
                                                      .allAttendances[index]
                                                      .checkOutTime!),
                                        ),
                                        CustomTableBody(
                                          text:
                                              '${convertNumberToArabic(attendanceController.allAttendances[index].totalTime!)} ${'Hours'.tr}',
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            NewEmployeeModelHistory? employeeModel =
                                                await addEmployeeController
                                                    .getEmployee(
                                              attendanceController
                                                  .allAttendances[index].email!,
                                            );
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.fade,
                                                child: EmployeeDetailedInfo(
                                                  employee: employeeModel!,
                                                        reviewRating: 4.5,
                                                ),
                                              ),
                                            );
                                          },
                                          child: CustomTableBody(
                                            text: emploData[index].action.tr,
                                            textColor: MyThemeData.colorBlue,
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              )
      ],
    );
  }
}
