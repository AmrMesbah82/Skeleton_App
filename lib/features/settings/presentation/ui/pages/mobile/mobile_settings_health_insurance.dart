///********************************** FILE INFO *************************
/// Purpose: Health insurance for mobile setting page .
/// Author: Mohamed Elrashidy
/// Refactored At: 11/11/2024

import 'package:demo_app/features/settings/presentation/ui/widgets/request_to_change_dialog_mobile.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';

import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/app_font_size.dart';

import '../../../../settings_screen/views/profile_screen.dart';
import '../../widgets/health_insurance_fields.dart' hide HealthInsuranceFields;

class MobileSettingsHealthInsurance extends StatefulWidget {
  const MobileSettingsHealthInsurance({super.key});

  @override
  _MobileSettingsHealthInsuranceState createState() =>
      _MobileSettingsHealthInsuranceState();
}

class _MobileSettingsHealthInsuranceState
    extends State<MobileSettingsHealthInsurance> {
  int selectedContainerIndex = 0;
  bool isEnglish = Get.locale.toString().contains('en');
  @override
  void initState() {
    section = null;
    whatChanged = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final HapticController hapticController = Get.find();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBarMobile(
            showIcon: true,
            showMoreIcon: false,
            title: "Health Insurance",
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 0.04.w, vertical: 0.0.w),
                child: Column(
                  children: [
                    HealthInsuranceFields(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.02.h),
                          child: SizedBox(
                            width: 0.95.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.signOut,
                                padding: EdgeInsets.symmetric(
                                  vertical: 0.007.h,
                                  horizontal:
                                      orientation == Orientation.portrait
                                          ? 0.22.w
                                          : 0.155.w,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                hapticController.triggerHapticFeedback(
                                    vibration: VibrateType.heavyImpact,
                                    hapticFeedback: HapticFeedback.heavyImpact);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RequestToChangeDialogMobile(
                                      isSetting: true,
                                      title: "Request to Change",
                                      imageUrl: "assets/icons/reqToChange.svg",
                                      isExclate: false,
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Request to Change'.tr,
                                style: AppFontStyle.cairoRegularStyle.copyWith(
                                  fontSize: FontConstants.fontSize022.h,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textButton,
                                ),
                              ),
                            ),
                          ),
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
