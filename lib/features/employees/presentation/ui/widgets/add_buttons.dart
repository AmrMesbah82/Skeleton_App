import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/employees/presentation/ui/widgets/temp_upload_widget.dart';
import '../../../../roles/presentation/controller/role_cubit.dart';
import '../../../../roles/presentation/ui/pages/role_responsive_page.dart';
import 'add_depratment_dialog.dart';
import '../../../../../core/dummy_data/chats_lists.dart';
import '../../../../../core/theme/font_manager.dart';
import '../../../../../core/theme/my_theme.dart';
import '../../../../../core/widgets/buttons/main_custom_icon_button.dart';
import '../../../../roles/presentation/controller/role_controller.dart';
import '../../../../roles/users_access_controller.dart';
import '../../controller/employee_controller.dart';

class AddButtons extends StatelessWidget {
  AddButtons({super.key});
  EmployeeController addEmployeeController = Get.find();
  UsersAccessController usersAccessController = Get.find();
  RoleCubit addRoleController = roleCubit;

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    if ((Mode.hr || Mode.owner) ) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: isPortrait ? 0.015.h : 0.025.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TempUploadWidget(),
            Padding(
              padding: EdgeInsets.only(
                  left: Get.locale.toString().contains('en') ? 0.015.w : 0,
                  right: Get.locale.toString().contains('en') ? 0 : 0.015.w),
              child: SizedBox(
                height: isPortrait ? null : 0.055.h,
                child: MainCustomIconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Container();
                        });
                  },
                  buttonText: "Add Department".tr,
                 
                  widgetIcon: "assets/images/case.svg",
             
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: MyThemeData.signOut,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Get.locale.toString().contains('en') ? 0.015.w : 0,
                  right: Get.locale.toString().contains('en') ? 0 : 0.015.w),
              child: SizedBox(
                height: isPortrait ? null : 0.055.h,
                child: MainCustomIconButton(
                  onPressed: /*() {
                    addRoleController.accessTypeByName?.oneByOne == true ||
                            addRoleController.accessTypeByName?.addEmployees ==
                                true
                        ? Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: CustomDrawer(
                                initialIndex: 2,
                                screens: [
                                  HomeScreen(),
                                  TaskScreen(),
                                  AddNewEmployeeScreen(),
                                  HomePageHelper(),
                                  RoleScreen(
                                      rowInvalid: [], isFristTime: false),
                                  TodoScreenTablet(),
                                  RequestsScreen(),
                                  SettingsScreen(),
                                ],
                              ),
                            ),
                          )
                        : showDialog(
                            context: context,
                            builder: (context) {
                              return const SuccessDialog(
                                title: "Unsuccessful",
                                subtitle:
                                    "You Don't Have Permission To Add New Employees",
                                lottieAsset: "assets/images/error.json",
                              );
                            });
                  }*/
                      () {},
                  buttonText: "Add Employee".tr,
                 
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: MyThemeData.signOut,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
