import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employees_hr_subwidgets/custom_teams_table_members.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/dummy_data/chats_lists.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

// ignore: must_be_immutable
class AddMemberDialog extends StatefulWidget {
  AddMemberDialog({
    super.key,
    required this.employees,
    required this.employeesState,
  });
  List<EmployeeData> employees;
  ValueChanged<List<EmployeeData>> employeesState;

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  TextEditingController chooseMember = TextEditingController();
  TextEditingController empTitle = TextEditingController();
  String? dep;
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0.25.w),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        height: 0.4.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.015.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0.02.h),
                child: const FiltersAppBar(
                    imageUrl: "assets/images/department_add.svg",
                    title: "Add Employee"),
              ),
              SizedBox(
                width: 0.6.w,
                child: ColumnRequestData(
                    title: "Choose Member",
                    isTextField: true,
                    hasPrefix: true,
                    prefixIcon: SvgPicture.asset('assets/images/Search.svg'),
                    textController: chooseMember,
                    controllerfinishState: (value) {
                      setState(() {
                        chooseMember = value;
                      });
                    },
                    hint: "Search".tr,
                    isOptional: false,
                    isExpanded: true),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ColumnRequestData(
                    title: "Department Name",
                    isTextField: false,
                    hint: "Department Name",
                    isOptional: false,
                    isExpanded: true,
                    buttonWidth: 0.23.w,
                    dropDownItems: teams,
                    dropdownValue: dep,
                    dropDownValueState: (value) {
                      setState(() {
                        dep = value;
                      });
                    },
                  ),
                  SizedBox(
                    width: 0.23.w,
                    child: ColumnRequestData(
                        title: "Employee Title",
                        isTextField: true,
                        textController: empTitle,
                        controllerfinishState: (value) {
                          setState(() {
                            empTitle = value;
                          });
                        },
                        hint: "Enter Title",
                        isOptional: false,
                        isExpanded: true),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.01.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MainCustomIconButton(
                      onPressed: chooseMember.text == '' ||
                              dep == null ||
                              empTitle.text == ''
                          ? () {}
                          : () {
                              hapticController.triggerHapticFeedback(
                                  vibration: VibrateType.mediumImpact,
                                  hapticFeedback: HapticFeedback.mediumImpact);

                              Navigator.pop(context);
                              setState(() {
                                widget.employees.add(EmployeeData(
                                    imageUrl: "assets/images/male_avatar.png",
                                    role: empTitle.text,
                                    dateEnroll:
                                        "${DateFormat.MMM().format(DateTime.now())} ${DateTime.now().day}, ${DateTime.now().year} ",
                                    userName: chooseMember.text));
                                widget.employeesState(widget.employees);
                              });
                            },
                      buttonText: "Add".tr,
                      buttonStyle: chooseMember.text == '' ||
                              dep == null ||
                              empTitle.text == ''
                          ? ElevatedButton.styleFrom(
                              minimumSize: Size(0.1.w, 0.05.h),
                              backgroundColor: MyThemeData.GreyBack,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              )),
                            )
                          : ElevatedButton.styleFrom(
                              minimumSize: Size(0.1.w, 0.05.h),
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
