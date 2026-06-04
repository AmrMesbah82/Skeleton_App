// ignore_for_file: must_be_immutable, prefer_const_declarations, unused_local_variable, deprecated_member_use, duplicate_ignore, no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks, unrelated_type_equality_checks, sdk_version_since, use_build_context_synchronously

//import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';

import 'package:demo_app/components/settings_components/custom_black_button.dart';

import 'package:demo_app/components/settings_components/custom_icon_container.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/widgets/settings_header.dart';
import 'package:demo_app/core/widgets/form_fields/profile_textfield.dart';
import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/components/tracking_time_components/track_time_subwidget/request_escalate_dialog.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/widgets/loading.dart';
import 'package:demo_app/core/theme/my_theme.dart';

import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/constants/system_actions.dart';
import 'package:demo_app/core/helper/validator.dart';
import 'package:demo_app/features/skeleton/employees/presentation/controller/employee_controller.dart';
import 'package:demo_app/features/skeleton/system_logs/presentation/controller/system_logs_controller.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/settings_screen.dart';
import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/settings_controller.dart';
import '../../../controller/social_controller.dart';
import '../../widgets/social/academic_history.dart';
import '../../widgets/social/bio.dart';
import '../../widgets/social/certificates.dart';
import '../../widgets/social/hobbies.dart';
import '../../widgets/social/skills.dart';
import '../../widgets/social/update_information_button.dart';

final HapticController hapticController = Get.put(HapticController());

class SocialMobileScreen extends StatefulWidget {
  const SocialMobileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SocialMobileScreenState createState() => _SocialMobileScreenState();
}

class _SocialMobileScreenState extends State<SocialMobileScreen> {
  int selectedContainerIndex = 0;
  bool isEnglish = Get.locale.toString().contains('en');
  SocialController socialController =
      Get.find<SettingsController>().socialController;
  @override
  void initState() {
    socialController.restartController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final HapticController hapticController = Get.put(HapticController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBarMobile(
            showIcon: true,
            showMoreIcon: false,
            title: "Social",
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 0.04.w, vertical: 0.0.w),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bio(),
                        SizedBox(height: 0.02.h),
                        AcademicHistory(),
                        SizedBox(height: 0.02.h),

                        Certificates(),
                        SizedBox(height: 0.02.h),

                        Skills(),
                        SizedBox(height: 0.02.h),

                        Hobbies(),
                        SizedBox(height: 0.02.h),

                        UpdateInformationButton(),
                        SizedBox(height: 15.h),

                      ],
                    ),
                    SizedBox(height: 0.02.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


