import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/constants/system_actions.dart';
import 'package:demo_app/features/skeleton/system_logs/presentation/controller/system_logs_controller.dart';
import 'package:demo_app/features/external/main_core/features/employee/data/models/emplyees_model/new_employee_model.dart';
import 'package:demo_app/features/skeleton/employees/presentation/controller/main_core_department_controller.dart';
import 'package:demo_app/features/skeleton/employees/presentation/controller/employee_controller.dart';

// REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

import '../../../../features/skeleton/employees/data/models/employee_model/employee_directory_model.dart';
import '../../../../features/skeleton/employees/data/models/new_employee_model/emplyees_model/new_employee_model.dart';

// ignore: must_be_immutable
class MoveMemberDialog extends StatefulWidget {
  MoveMemberDialog({
    super.key,
    this.role,
    this.department,
    this.employee,
    this.employeeDirectory,
  });
  String? role;
  String? department;
  EmployeeDirectoryModel? employeeDirectory;
  NewEmployeeModelHistory? employee;

  @override
  State<MoveMemberDialog> createState() => _MoveMemberDialogState();
}

class _MoveMemberDialogState extends State<MoveMemberDialog> {
  @override
  void initState() {
    newDepartment = null;
    newRole = null;
    super.initState();
  }

  final HapticController hapticController = Get.put(HapticController());
  final SystemLogsController systemLogsController = Get.find<SystemLogsController>();
  AddDepartmentController addDepartmentController = Get.find();
  EmployeeController addEmployeeController = Get.find();
  String? newDepartment;
  String? newRole;
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    List<Widget> MoveContent = [
      ColumnRequestData(
        title: "Choose Department",
        isTextField: false,
        hint: "To",
        isOptional: false,
        isExpanded: true,
        buttonWidth: isTablet
            ? isPortrait
                ? 0.32.w
                : 0.22.w
            : double.infinity,
        dropDownItems: addDepartmentController.departmentsEnglishName,
        dropDownValueState: (value) {
          setState(() {
            newDepartment = value;
          });
        },
        dropdownValue: newDepartment ?? widget.department,
      ),
      isTablet
          ? const SizedBox.shrink()
          : SizedBox(
              height: 0.02.h,
            ),
      ColumnRequestData(
        title: "Choose Role",
        isTextField: false,
        hint: widget.role ?? "Employee",
        isOptional: false,
        isExpanded: true,
        buttonWidth: isTablet
            ? isPortrait
                ? 0.32.w
                : 0.22.w
            : double.infinity,
        dropDownItems: ["Manager".tr, "CEO".tr, "Employee".tr],
        dropDownValueState: (value) {
          setState(() {
            newRole = value;
          });
        },
        dropdownValue: newRole ?? widget.role,
      ),
    ];

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet
              ? isPortrait
                  ? 0.14.w
                  : 0.25.w
              : 0.1.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        height: isTablet
            ? isPortrait
                ? 0.24.h
                : 0.31.h
            : 0.34.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0.02.h),
                child: const FiltersAppBar(
                    imageUrl: "assets/images/movemember.svg",
                    title: "Move Member"),
              ),
              isTablet
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: MoveContent,
                    )
                  : Column(
                      children: MoveContent,
                    ),
              Padding(
                padding: EdgeInsets.only(top: 0.02.h),
                child: Row(
                  mainAxisAlignment: isTablet
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    MainCustomIconButton(
                      onPressed: () async {
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.heavyImpact,
                            hapticFeedback: HapticFeedback.heavyImpact);
                        if (newDepartment != widget.department &&
                            newDepartment != null) {
                          widget.employee!.departmentId!
                              .add(newDepartment!.toLowerCase());
                          widget.employeeDirectory!.department!.department!
                              .add(newDepartment!.toLowerCase());
                          widget.employee!.timestamps!
                              .add(DateTime.now().millisecondsSinceEpoch);
                          widget.employeeDirectory!.department!.timestamps!
                              .add(Timestamp.now());
                          //todo: add supervisor
                          String currentRole = newRole ?? widget.role!;
                          NewEmployeeModelHistory supervisor = addEmployeeController
                              .allEmployees!
                              .firstWhere((element) =>
                                  element.departmentId!.last! ==
                                      newDepartment!.toLowerCase() &&
                                  element!.role!.last == 'admin');
                          if (currentRole.toLowerCase() == 'employee') {
                            widget.employee!.supervisor!.add(
                                "${supervisor.firstName!.last} ${supervisor.lastName!.last}");
                            widget.employee!.timestamps!
                                .add(DateTime.now().millisecondsSinceEpoch);
                          }
                        }
                        if (newRole != widget.role && newRole != null) {
                          widget.employee!.role!
                              .add(newRole!.toLowerCase());
                          widget.employee!.timestamps!
                              .add(DateTime.now().millisecondsSinceEpoch);
                        }
                        await addEmployeeController.createEmployee(
                            widget.employee!,
                            widget.employee!.email!.last!,
                            );
                        systemLogsController
                            .systemLogsAction(SystemActions.updateEmployee);
                        Navigator.pop(context);
                        setState(() {});
                      },
                      buttonText: "Move".tr,
                     
                      buttonStyle: ElevatedButton.styleFrom(
                        minimumSize: isTablet
                            ? Size(0.08.w, 0.05.h)
                            : Size(0.75.w, 0.05.h),
                        backgroundColor: MyThemeData.signOut,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
