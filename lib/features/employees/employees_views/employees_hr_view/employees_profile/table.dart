// Date Created :15/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :15/November/2023
// Objectives: this is a widget to customize the table of attendance

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/shared_components/custom_table_appbar.dart';
import 'package:demo_app/core/shared_components/request_escalate_dialog.dart';
import 'package:demo_app/core/dummy_data/chats_lists.dart';
import 'package:demo_app/core/enumeration/enum.dart';

import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/employees/attendance_controller.dart';
import 'package:demo_app/features/requests/leave_request_controller.dart';
import 'package:demo_app/features/home/data/models/attendance_model.dart';
import 'package:demo_app/features/requests/data/models/leave_request_model.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
// ignore: depend_on_referenced_packages

class TableData extends StatefulWidget {
  const TableData({
    super.key,
    this.isEmployeeScreen = false,
    this.isRequestedTable = false,
  });
  final bool isEmployeeScreen;
  final bool isRequestedTable;

  @override
  State<TableData> createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
  final HapticController hapticController = Get.put(HapticController());
  List<AttendanceModel> allAttendances = [];
  List<LeaveRequestsModel> allLeaveRequests = [];
  @override
  void initState() {
    getAttendance();
    getLeaveRequestes();
    super.initState();
  }

  AttendanceController attendanceController = Get.find();
  LeaveRequestController leaveRequestController = Get.find();
  Future<void> getAttendance() async {
    attendanceController.employeeAttendances = await attendanceController
        .getUserAttendances(employee!.email!.last!);
    allAttendances = await attendanceController
        .getUserAttendances(employee!.email!.last!);
    attendanceController.employeeAttendances
        .sort((a, b) => b.date!.compareTo(a.date!));
    setState(() {});
  }

  Future<void> getLeaveRequestes() async {
    leaveRequestController.leaveRequestsList =
        await leaveRequestController.getAllLeaveRequests();
    allLeaveRequests = await leaveRequestController.getAllLeaveRequests();
    leaveRequestController.leaveRequestsList
        .sort((a, b) => b.dateRequest!.compareTo(a.dateRequest!));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    TextStyle tableDataTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: isPortrait
          ? FontConstants.fontSize016.h
          : FontConstants.fontSize020.h,
      color: Theme.of(context).colorScheme.inverseSurface,
      fontWeight: FontWeight.w400,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1.3.w,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widget.isEmployeeScreen ? 0 : 0.02.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTableAppBar(
                  isEmployee: widget.isEmployeeScreen,
                  offset: const Offset(0, 0),
                  isrequested: widget.isRequestedTable,
                  titles: widget.isRequestedTable
                      ? [
                          "Date".tr,
                          "Status".tr,
                          "Type".tr,
                          "Total Time".tr,
                          "Rejected Reason".tr,
                          "Action".tr
                        ]
                      : [
                          "Date".tr,
                          "Status".tr,
                          "Oncoming Time".tr,
                          "Leaving Time".tr,
                          "Take Break".tr,
                          "Total Time".tr
                        ],
                  columnsCount: 6),
              Expanded(
                child: ListView.builder(
padding: EdgeInsets.zero,
                    itemCount: widget.isRequestedTable
                        ? leaveRequestController.leaveRequestsList.length
                        : attendanceController.employeeAttendances.length,
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
                              horizontal:
                                  widget.isEmployeeScreen ? 0.007.w : 0.015.w,
                              vertical:
                                  widget.isRequestedTable ? 0.01.h : 0.025.h),
                          child: Row(
                            children: [
                              SizedBox(
                                width: widget.isRequestedTable
                                    ? isPortrait
                                        ? Get.locale.toString().contains('en')
                                            ? 0.14.w
                                            : 0.16.w
                                        : isPortrait
                                            ? 0.185.w
                                            : 0.195.w
                                    : widget.isEmployeeScreen
                                        ? Get.locale.toString().contains('en')
                                            ? 0.05.w
                                            : 0.06.w
                                        : Get.locale.toString().contains('en')
                                            ? isPortrait
                                                ? 0.15.w
                                                : 0.175.w
                                            : isPortrait
                                                ? 0.17.w
                                                : 0.18.w,
                                child: Text(
                                  widget.isRequestedTable
                                      ? DateFormat('MMM dd, yyyy').format(
                                          DateTime.parse(leaveRequestController
                                              .leaveRequestsList[index]
                                              .dateRequest!))
                                      : DateFormat('MMM dd, yyyy').format(
                                          DateTime.parse(attendanceController
                                              .employeeAttendances[index]
                                              .date!)),
                                  style: tableDataTextStyle,
                                ),
                              ),
                              isPortrait
                                  ? SizedBox(
                                      width:
                                          widget.isRequestedTable ? 0.03.w : 0,
                                    )
                                  : const SizedBox.shrink(),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: SizedBox(
                                  width: widget.isRequestedTable
                                      ? Get.locale.toString().contains('en')
                                          ? isPortrait
                                              ? 0.18.w
                                              : 0.13.w
                                          : 0.15.w
                                      : Get.locale.toString().contains('en')
                                          ? widget.isEmployeeScreen
                                              ? 0.065.w
                                              : isPortrait
                                                  ? 0.17.w
                                                  : 0.18.w
                                          : widget.isEmployeeScreen
                                              ? 0.055.w
                                              : isPortrait
                                                  ? 0.16.w
                                                  : 0.19.w,
                                  child: Text(
                                      widget.isRequestedTable
                                          ? capitalize(leaveRequestController
                                                  .leaveRequestsList[index]
                                                  .status!)
                                              .tr
                                          : capitalize(attendanceController
                                                  .employeeAttendances[index]
                                                  .status!)
                                              .tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: widget.isRequestedTable
                                          ? tableDataTextStyle.copyWith(
                                              color: capitalize(
                                                          leaveRequestController
                                                              .leaveRequestsList[
                                                                  index]
                                                              .status!) ==
                                                      "Approved"
                                                  ? AppColors.unBlock
                                                  : capitalize(leaveRequestController
                                                              .leaveRequestsList[
                                                                  index]
                                                              .status!) ==
                                                          "Rejected"
                                                      ? AppColors.colorRed
                                                      : AppColors.warning,
                                            )
                                          : tableDataTextStyle.copyWith(
                                              color: capitalize(
                                                          attendanceController
                                                              .employeeAttendances[
                                                                  index]
                                                              .status!) ==
                                                      "Attendance"
                                                  ? AppColors.unBlock
                                                  : capitalize(attendanceController
                                                              .employeeAttendances[
                                                                  index]
                                                              .status!) ==
                                                          "Absent"
                                                      ? AppColors.colorRed
                                                      : AppColors.warning,
                                            )),
                                ),
                              ),
                              widget.isRequestedTable
                                  ? SizedBox(
                                      width: isPortrait ? 0 : 0.06.w,
                                    )
                                  : const SizedBox.shrink(),
                              SizedBox(
                                width: widget.isRequestedTable
                                    ? Get.locale.toString().contains('en')
                                        ? isPortrait
                                            ? 0.17.w
                                            : 0.19.w
                                        : 0.19.w
                                    : Get.locale.toString().contains('en')
                                        ? widget.isEmployeeScreen
                                            ? 0.115.w
                                            : isPortrait
                                                ? 0.26.w
                                                : 0.24.w
                                        : widget.isEmployeeScreen
                                            ? 0.1.w
                                            : 0.23.w,
                                child: Text(
                                    widget.isRequestedTable
                                        ? capitalize(leaveRequestController
                                                .leaveRequestsList[index]
                                                .leaveType!)
                                            .tr
                                        : capitalize(attendanceController
                                            .employeeAttendances[index]
                                            .checkInTime!),
                                    style: tableDataTextStyle),
                              ),
                              SizedBox(
                                width: widget.isRequestedTable
                                    ? Get.locale.toString().contains('en')
                                        ? isPortrait
                                            ? 0.23.w
                                            : 0.23.w
                                        : 0.26.w
                                    : widget.isEmployeeScreen
                                        ? 0.105.w
                                        : isPortrait
                                            ? 0.24.w
                                            : 0.23.w,
                                child: Text(
                                    widget.isRequestedTable
                                        ? leaveRequestController
                                            .leaveRequestsList[index].totalTime!
                                        : attendanceController
                                            .employeeAttendances[index]
                                            .checkOutTime!,
                                    style: tableDataTextStyle),
                              ),
                              SizedBox(
                                width: widget.isRequestedTable
                                    ? Get.locale.toString().contains('en')
                                        ? isPortrait
                                            ? 0.27.w
                                            : 0.22.w
                                        : 0.21.w
                                    : widget.isEmployeeScreen
                                        ? Get.locale.toString().contains('en')
                                            ? 0.095.w
                                            : 0.1.w
                                        : 0.2.w,
                                child: Text(
                                    widget.isRequestedTable
                                        ? leaveRequestController
                                                    .leaveRequestsList[index]
                                                    .rejectReason ==
                                                null
                                            ? '----'
                                            : capitalize(leaveRequestController
                                                .leaveRequestsList[index]
                                                .rejectReason!)
                                        : capitalize(attendanceController
                                            .employeeAttendances[index]
                                            .takeBreak!
                                            .toString()),
                                    style: tableDataTextStyle),
                              ),
                              widget.isRequestedTable
                                  ? capitalize(leaveRequestController
                                              .leaveRequestsList[index]
                                              .status!) ==
                                          "Approved"
                                      ? SizedBox(
                                          height: 0.043.h,
                                        )
                                      : MainCustomIconButton(
                                          onPressed: () {
                                            hapticController
                                                .triggerHapticFeedback(
                                                    vibration: VibrateType
                                                        .mediumImpact,
                                                    hapticFeedback:
                                                        HapticFeedback
                                                            .mediumImpact);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return RequestExcalateDialog(
                                                  title: "Escalates Request",
                                                  imageUrl:
                                                      "assets/icons/reqToChange.svg",
                                                  isExclate: true,
                                                );
                                              },
                                            );
                                          },
                                          buttonText:
                                              requestsDat[index].Action.tr,
                                       
                                          buttonStyle: ElevatedButton.styleFrom(
                                            minimumSize: isPortrait
                                                ? Size(0.04.w, 0.043.h)
                                                : Size(0.06.w, 0.043.h),
                                            backgroundColor:
                                                AppColors.signOut,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                          ),
                                        )
                                  : Text(
                                      attendanceController
                                          .employeeAttendances[index]
                                          .totalTime!,
                                      style: tableDataTextStyle),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
