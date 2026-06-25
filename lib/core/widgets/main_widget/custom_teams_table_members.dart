//Date Created :26/November/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :
// Objectives: this class  created to view the table of the employees
import 'dart:isolate';
import 'package:demo_app/core/theme/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/helper/employees/widgets/custom_table_appbar.dart';
import 'package:demo_app/core/widgets/main_widget/delete_member_dialog.dart';
import 'package:demo_app/core/widgets/main_widget/move_member_dialog.dart';
import 'package:demo_app/core/enums/enum.dart';

import 'package:demo_app/core/helper/main_helper/haptic_controller.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/employee/data/models/emplyees_model/new_employee_model.dart';
import 'package:demo_app/core/helper/employees/presentation/controller/main_core_department_controller.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

import 'package:demo_app/core/helper/employees/data/models/employee_model/employee_directory_model.dart';
import 'package:demo_app/core/helper/employees/data/models/new_employee_model/emplyees_model/new_employee_model.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';

// ignore: must_be_immutable
class CustomTable extends StatefulWidget {
  CustomTable({
    super.key,
    required this.employees,
    required this.employeeDirectory,
    required this.employeeState,
  });
  List<NewEmployeeModelHistory> employees;
  List<EmployeeDirectoryModel> employeeDirectory;
  ValueChanged<List<EmployeeData>> employeeState;

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  final HapticController hapticController = Get.put(HapticController());
  AddDepartmentController addDepartmentController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 0.02.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTableAppBar(
                offset: Get.locale.toString().contains('en')
                    ? null
                    : const Offset(-60, 0),
                titles: ["Name".tr, "Date Enroll".tr, "Role".tr, "Action".tr],
                columnsCount: 4),
            SizedBox(
              height: 0.3.h,
              child: ListView.builder(
padding: EdgeInsets.zero,
                  itemCount: widget.employees.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(8),
                           color: index % 2 == 0
                                ? themeController.currentTheme ==
                                        AppColors.lightTheme
                                    ? Color(0xFFf1f1f1)
                                    : AppColors.darkBackGround
                                : themeController.currentTheme ==
                                        AppColors.lightTheme
                                    ? AppColors.colorWhite
                                    : Color(0xFF28282B),),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.015.w, vertical: 0.015.h),
                        child: Row(
                          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: 0.25.w,
                              child: Row(
                                children: [
                                  widget.employees[index].photo?.lastOrNull ==
                                          null
                                      ? CircleAvatar(
                                          backgroundImage: AssetImage(widget
                                                      .employees[index]
                                                      .gender
                                                      ?.lastOrNull ==
                                                  'female'
                                              ? 'assets/images/female_avatar.png'
                                              : 'assets/images/male_avatar.png'),
                                          radius: 0.025.h,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(widget
                                              .employees[index]
                                              .photo
                                              .last!),
                                          radius: 0.025.h,
                                        ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            Get.locale.toString().contains('en')
                                                ? 0.008.w
                                                : 0,
                                        right:
                                            Get.locale.toString().contains('en')
                                                ? 0
                                                : 0.008.w),
                                    child: Text(
                                      capitalize(
                                          "${widget.employees[index].firstName!.last!} ${widget.employees[index].lastName!.last!}"),
                                      style: AppFontStyle.cairoRegularStyle
                                          .copyWith(
                                        fontSize: FontConstants.fontSize016.w,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 0.18.w,
                              child: Transform.translate(
                                offset: Get.locale.toString().contains('en')
                                    ? const Offset(-15, 0)
                                    : const Offset(15, 0),
                                child: Text(
                                  DateFormat.yMMMMd().format(
                                      DateTime.fromMillisecondsSinceEpoch(widget
                                          .employees[index]!
                                          .timestamps!
                                          .first!
                                      )),
                                  style:
                                      AppFontStyle.cairoRegularStyle.copyWith(
                                    fontSize: FontConstants.fontSize016.w,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 0.19.w,
                              child: Transform.translate(
                                offset: Get.locale.toString().contains('en')
                                    ? const Offset(-10, 0)
                                    : const Offset(10, 0),
                                child: Text(
                                  addDepartmentController.containAbbreviation(
                                      widget
                                          .employees[index].role!.last!),
                                  style:
                                      AppFontStyle.cairoRegularStyle.copyWith(
                                    fontSize: FontConstants.fontSize016.w,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Get.locale.toString().contains('en')
                                  ? const Offset(-20, 0)
                                  : const Offset(20, 0),
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      hapticController.triggerHapticFeedback(
                                          vibration: VibrateType.mediumImpact,
                                          hapticFeedback:
                                              HapticFeedback.mediumImpact);
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return MoveMemberDialog(
                                              employee: widget.employees[index],
                                              employeeDirectory: widget
                                                  .employeeDirectory[index],
                                              role: capitalize(
                                                widget.employees[index].role!.last!,
                                              ),
                                              department:
                                                  addDepartmentController
                                                      .containAbbreviation(
                                                          widget
                                                              .employees[index]!
                                                              .departmentId!
                                                              .last!),
                                            );
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.signOut),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.015.h,
                                            vertical: 0.015.h),
                                        child: Transform.scale(
                                          scale: 1.3,
                                          child: SvgPicture.asset(
                                              "assets/images/reverse.svg"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            Get.locale.toString().contains('en')
                                                ? 0.015.w
                                                : 0,
                                        right:
                                            Get.locale.toString().contains('en')
                                                ? 0
                                                : 0.015.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        hapticController.triggerHapticFeedback(
                                            vibration: VibrateType.mediumImpact,
                                            hapticFeedback:
                                                HapticFeedback.mediumImpact);
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DeleteMemberDialog(
                                                employeeDirectory: widget
                                                    .employeeDirectory[index],
                                                employees:
                                                    widget.employees[index],
                                                index: index,
                                                userName:
                                                    "${widget.employees[index].firstName!.last!} ${widget.employees[index].lastName!.last!}",
                                              );
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: AppColors.delete),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0.0155.h,
                                              vertical: 0.016.h),
                                          child: Transform.scale(
                                            scale: 1.3,
                                            child: SvgPicture.asset(
                                                "assets/images/trashd.svg"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container()
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class EmployeeData {
  final String imageUrl;
  final String userName;
  final String dateEnroll;
  String role;

  EmployeeData(
      {required this.imageUrl,
      required this.role,
      required this.dateEnroll,
      required this.userName});
}
