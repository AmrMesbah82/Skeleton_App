// ignore_for_file: must_be_immutable, prefer_const_declarations, unused_local_variable, deprecated_member_use, duplicate_ignore, no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks, unrelated_type_equality_checks, sdk_version_since, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/core/widgets/custom_button_widget.dart';
import 'package:demo_app/core/widgets/side_frame_master.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'package:demo_app/core/shared_components/custom_black_button.dart';

import 'package:demo_app/core/shared_components/custom_icon_container.dart';
import 'package:demo_app/core/helper/file_path_functions.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/Category/presentation/ui/services_admin/Widget/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/settings/presentation/controller/settings_controller.dart';
import 'package:demo_app/features/settings/presentation/ui/widgets/settings_header.dart';
import 'package:demo_app/core/widgets/form_fields/profile_textfield.dart';
import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/core/shared_components/request_escalate_dialog.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/widgets/loading.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/theme/my_theme.dart';

import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/helper/validator.dart';
import 'package:demo_app/features/employees/presentation/controller/employee_controller.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:demo_app/features/settings/presentation/ui/widgets/social/academic_history.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../generated/l10n.dart';
// REMOVED_MODULE: import '../../../../../../external/inventory_module/core/custom_button_widget.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/core/custom_button_with_image.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/core/new_theme.dart';
import '../../../controller/social_controller.dart';
import '../../widgets/social/bio.dart';
import '../../widgets/social/certificates.dart';
import '../../widgets/social/cleaner.dart';
import '../../widgets/social/hobbies.dart';
import '../../widgets/social/skills.dart';
import '../../widgets/social/update_information_button.dart';

final HapticController hapticController = Get.put(HapticController());

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  late final SettingsController settingsController;
  late final SocialController socialController;

  @override
  void initState() {
    super.initState();
    settingsController = Get.find<SettingsController>();
    socialController = settingsController.socialController;

    if (settingsController.employee == null) {
      settingsController.getEmployee().then((_) {
        socialController.restartController();
        setState(() {});
      });
    }
  }

  Future<void> _onUpdatePressed() async {
    await socialController.updateAllSocialInformation();

    // ✅ Force Bio widget to show updated text
    if (mounted) setState(() {});

    final mainCoreEmployeeController = Get.find<MainCoreEmployeeController>();
    await mainCoreEmployeeController.getAllNewEmployees();
    mainCoreEmployeeController.update(['employee_profile']);
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    var lightMode = Theme.of(context).brightness == Brightness.light;
    final HapticController hapticController = Get.find();
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool isDesktop = Platform.isLinux || Platform.isMacOS || Platform.isWindows;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return GetBuilder<EmployeeController>(
      init: Get.find<EmployeeController>(),
      builder: (addEmployeeController) {
        return !isMobile
            ? Column(
          children: [
            SizedBox(
              height: 490.h,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Bio(),
                            SizedBox(height: 15.sp),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.sp),
                              child: AcademicHistory(),
                            ),
                            Padding(
                              padding: EdgeInsets.all(15.sp),
                              child: Skills(),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Hobbies(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customButton(
                  title: 'Update Social Information'.tr,
                  function: _onUpdatePressed, // ✅
                  radius: 4.r,
                  color: AppColors.primary,
                  width: 300.w,
                  height: 36.h,
                  textStyle: StyleText.fontSize16Weight500.copyWith(
                    color: ColorAppLight.buttonTextColor,
                  ),
                ),
              ],
            ),
          ],
        )
            : SideFrameMaster(
          titleText: S.of(context).settings,
          secondTitle: S.of(context).generalInformation,
          onSecondTap: () {},
          onFirstTap: () {},
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bio(),
                    SizedBox(height: 15.sp),
                    AcademicHistory(),
                    SizedBox(height: 15.sp),
                    Skills(),
                    SizedBox(height: 15.sp),
                    Hobbies(),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customButton(
                    title: 'Update Social Information'.tr,
                    function: _onUpdatePressed, // ✅
                    radius: 4.r,
                    color: AppColors.primary,
                    width: isMobile ? 340.sp : 300.w,
                    height: 36.h,
                    textStyle: StyleText.fontSize16Weight500.copyWith(
                      color: ColorAppLight.buttonTextColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
            ],
          ),
        );
      },
    );
  }
}