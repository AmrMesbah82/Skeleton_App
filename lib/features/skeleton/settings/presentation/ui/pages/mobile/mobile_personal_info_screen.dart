///***************************** FILE INFO ****************************/
/// Purpose: This file contains the mobile personal information screen Starting point.
/// Author: Mohamed Elrashidy
/// refactored at: 11/11/2024
import 'package:demo_app/core/widgets/shared_action_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/widgets/personal_information_fields.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/widgets/navigation.dart';
import '../../../../../../external/services_mangment_module/core/new_theme.dart';
import '../tablet/eeit_page_request.dart';

final HapticController hapticController = Get.put(HapticController());

class MobilePersonalInfoScreen extends StatefulWidget {
  const MobilePersonalInfoScreen({super.key});

  @override
  _MobilePersonalInfoScreenState createState() =>
      _MobilePersonalInfoScreenState();
}

class _MobilePersonalInfoScreenState extends State<MobilePersonalInfoScreen> {
  int selectedContainerIndex = 0;
  bool isEnglish = Get.locale.toString().contains('en');
  @override
  void initState() {
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
              title: "Personal Information"
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 0.04.w, vertical: 0.0.w),
                child: Column(
                  children: [
                    Container(
                        child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.0.w, vertical: 0.0.h),
                      child: PersonalInformationFields(),
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customButtonWithImage(
                          title: 'Request to Change'.tr,
                          function: (){
                            hapticController.triggerHapticFeedback(
                                vibration: VibrateType.mediumImpact,
                                hapticFeedback: HapticFeedback.mediumImpact
                            );
                            navigateTo(context, EditPageRequest());
                          },
                          color: AppColorsThree.primary,
                          width: 300.w,
                          height: 36.h,
                          textStyle: StyleText.fontSize16Weight500.copyWith(
                              color: ColorAppLight.buttonTextColor
                          ),
                          image: 'assets/request_chnage.svg',
                          radius: 4.r,
                          svgColor: ColorAppLight.buttonTextColor,
                          widthImage: 16.w,
                          heightImage: 23.h,
                        ),
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
