import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/features/employees/presentation/controller/employee_controller.dart';
import 'package:demo_app/features/settings/presentation/controller/settings_controller.dart';
import 'package:demo_app/features/settings/presentation/controller/social_controller.dart';

import '../../../../../../core/widgets/custom_button.dart';
// Add the import for CustomButton here
// import 'path/to/custom_button.dart';

class UpdateInformationButton extends StatelessWidget {
  UpdateInformationButton({super.key});

  SocialController socialController = Get.find<SettingsController>().socialController;
  SettingsController settingsController = Get.find();
  EmployeeController addEmployeeController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: Get.locale.toString().contains('ar')
          ? (isPortrait
          ? EdgeInsets.only(
        top: 0.015.w,
        bottom: 0.0.h,
      )
          : EdgeInsets.only(
        top: 0.025.h,
        bottom: 0.0.w,
      ))
          : EdgeInsets.only(
        top: isPortrait ? 0.02.w : 0.025.h,
        bottom: isPortrait ? 0.0 : 0.0.h,
      ),
      child: CustomButton(
        buttonText: 'Update Social Information'.tr,
        onTap: () async {
          print("pressed");
          await socialController.updateAllSocialInformation();
        },
        buttonColor: MyThemeData.signOut,
        width: isPortrait ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          vertical: isPortrait ? 0.01.h : 0.015.h,
          horizontal: isPortrait ? 24.sp : 0.155.w,
        ),
        textStyle: AppFontStyle.cairoRegularStyle.copyWith(
          fontSize: isPortrait
              ? FontConstants.fontSize020.h
              : FontConstants.fontSize025.h,
          fontWeight: FontWeight.w500,
          color: MyThemeData().contrastColor(),
        ),
      ),
    );
  }
}