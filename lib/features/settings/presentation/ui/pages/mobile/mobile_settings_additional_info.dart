///*************************** FILE INFO **********************************///
/// Purpose: A Mobile Screen that displays the additional info documents and images.
/// Author: Mohamed Elrashidy
/// Refactored At: 13/11/2024

import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/features/settings/presentation/ui/widgets/additional_info_content.dart';
import 'package:demo_app/features/settings/presentation/ui/widgets/settings_header.dart';

import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/settings/presentation/ui/widgets/request_to_change_dialog_mobile.dart';
import '../../../../../../core/enumeration/enum.dart';

class MobileSettingsAdditionalInfo extends StatelessWidget {
  MobileSettingsAdditionalInfo({super.key});

  final HapticController hapticController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBarMobile(
            showIcon: true,
            showMoreIcon: false,
            title: "Additional Information",
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 0.04.w, vertical: 0.0.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.0.w, vertical: 0.0.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.04.w, vertical: 0.01.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: 0.02.h, top: 0.01.h),
                              child: SettingsHeader(
                                imagePath: 'assets/icons/newAddInfo.svg',
                                text: 'Additional Information'.tr,
                              ),
                            ),
                            AdditionalInfoContent()
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.02.h),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.signOut,
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.007.h,
                                    horizontal: isPortrait ? 0.22.w : 0.155.w),
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
                                    color: AppColors.textButton),
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
