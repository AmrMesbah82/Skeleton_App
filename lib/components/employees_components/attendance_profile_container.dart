// Date Created :21/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :21/November/2023
// Objectives: this is a widget to customize the view od the container of the attendance request profile
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/components/employees_components/employees_components_subwidgets.dart/employee_content.dart';
import 'package:demo_app/components/employees_components/request_change_dialog.dart';
import 'package:demo_app/components/tracking_time_components/track_time_subwidget/photo_name_job_row.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/settings_screen.dart';

class AttendanceRequestProfileContainer extends StatefulWidget {
  const AttendanceRequestProfileContainer({super.key});

  @override
  State<AttendanceRequestProfileContainer> createState() =>
      _AttendanceRequestProfileContainerState();
}

class _AttendanceRequestProfileContainerState
    extends State<AttendanceRequestProfileContainer> {
  String? valued;
  double spacing = 0.03.h;

  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double widthData = isPortrait ? 0.3.w : 0.4.w;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isPortrait ? 0.022.w : 0.016.w, vertical: 0.015.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PhotoNameRow(
                    imageUrl: "",
                    name:
                        '${Get.locale.toString().contains('en') ? employee!.firstName!.last!.capitalize : employee!.firstNameInArabic!.last!} ${Get.locale.toString().contains('en') ? employee!.lastName!.last!.capitalize : employee!.lastNameInArabic!.last!}',
                    radius: 0.045.h,
                    jobTitle: employee!.role!.last!.capitalize.toString(),
                    checkedIn: true,
                    checkedInState: (value) {}),
                Padding(
                  padding: EdgeInsets.only(top: 0.033.h),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: isPortrait ? 0.3.w :Get.locale.toString().contains("en")?0.21.w :0.18.w,
                          child: EmployeeContent(
                              isAssets: true,
                              title: "Start Date",
                              value: DateFormat.yMMMMd(Get.locale.toString())
                                  .format(DateTime.parse(
                                      employee!.firstLogin.toString()))),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 0.0.w, vertical: isPortrait ? 0.012.h : 0.025.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                    /*  SizedBox(
                        width: isPortrait
                            ? Get.locale.toString().contains("en")
                                ? widthData * 1.2
                                : widthData * 1.6
                            : widthData,
                        child: EmployeeContent(
                            isAssets: true,
                            title: "Department",
                            value: employee!
                                .departmentid!.departmentId!.last!.capitalize!),
                      ),*/
                      SizedBox(
                        width: Get.locale.toString().contains("en")
                            ? isPortrait
                                ? widthData* 1.4
                                : widthData 
                            : widthData,
                        child: EmployeeContent(
                            isAssets: true,
                            title: "Supervisor",
                            value: capitalize(
                                employee?.supervisor?.last??"")),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.02.h),
                    child: Row(
                      children: [
                        SizedBox(
                          width: Get.locale.toString().contains("en")
                              ? isPortrait
                                  ? widthData * 1.2
                                  : widthData
                              : isPortrait
                                  ? widthData * 1.6
                                  : widthData * 1,
                          child: EmployeeContent(
                              isAssets: true,
                              title: "Email",
                              value: employee!.email!.last.toString()),
                        ),
                      /*  SizedBox(
                          width: isPortrait
                              ?Get.locale.toString().contains("en")? widthData * 1.4: widthData*1
                              : Get.locale.toString().contains("en")
                                  ? widthData
                                  : 0.2.w,
                          child: EmployeeContent(
                              isAssets: true,
                              title: "Phone Number",
                              value: employee!.mobilePhone!.phones!.last.toString()),
                        ),*/
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: isPortrait ? 0 : 0.01.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MainCustomIconButton(
                    onPressed: () {
                      hapticController.triggerHapticFeedback(
                          vibration: VibrateType.mediumImpact,
                          hapticFeedback: HapticFeedback.mediumImpact);
                      //  Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const RequestChangeDialog();
                          });
                      //setState(() {});
                    },
                    buttonText: "Request To Modify Data".tr,
                  
                    buttonStyle: ElevatedButton.styleFrom(
                      minimumSize: isPortrait
                          ? Size(0.25.w, 0.04.h)
                          : Size(0.18.w, 0.058.h),
                      backgroundColor: MyThemeData.signOut,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
