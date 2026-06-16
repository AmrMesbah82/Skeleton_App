import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';

//import 'package:image_crop/image_crop.dart';


import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';

import 'package:demo_app/core/widgets/restart_widget.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';

class CustomSettingsAppBar extends StatefulWidget {
  final String? profileImagePath;
  final String userName;
  final VoidCallback? onPressed;
  final int selectedContainer;

  const CustomSettingsAppBar({
    super.key,
    this.profileImagePath,
    required this.userName,
    this.onPressed,
    required this.selectedContainer,
  });

  @override
  State<CustomSettingsAppBar> createState() => _CustomSettingsAppBarState();
}

class _CustomSettingsAppBarState extends State<CustomSettingsAppBar> {
  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final HapticController hapticController = Get.put(HapticController());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.043.w),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                margin: Get.locale.toString().contains('en')
                    ? EdgeInsets.only(
                        right: orientation == Orientation.portrait
                            ? 0.036.w
                            : 0.02.w)
                    : EdgeInsets.only(
                        left: orientation == Orientation.portrait
                            ? 0.036.w
                            : 0.02.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: _buildProfileImage(),

    ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Get.locale.toString().contains('en')
                        ? '${employee!.firstName!.last!.capitalize} ${employee!.lastName!.last!.capitalize}'
                        : '${employee!.firstNameInArabic!.last!} ${employee!.lastNameInArabic!.last!}',
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: orientation == Orientation.portrait
                          ? FontConstants.fontSize028.h
                          : FontConstants.fontSize030.h,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.shortestSide > 600
                        ? (orientation == Orientation.portrait
                            ? 0.04.h
                            : 0.02.h)
                        : 0.02.h,
                  ),
                  Text(
                    capitalize(employee!.role!.last!).tr,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize022.h,
                        color: themeController.currentTheme ==
                                AppColors.lightTheme
                            ? AppColors.colorDarkGrey
                            : AppColors.colorGreydark,
                        fontWeight: FontWeight.w400,
                        height: 0.0015.h),
                  ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: AppColors.signOut,
                  //     padding: EdgeInsets.symmetric(
                  //       vertical: 0.01.h,
                  //       horizontal: 0.02.w,
                  //     ),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     widget.onPressed;
                  //     hapticController.triggerHapticFeedback(
                  //       vibration: VibrateType.lightImpact,
                  //       hapticFeedback: HapticFeedback.lightImpact,
                  //     );
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       SvgPicture.asset(
                  //         'assets/icons/solar_camera-linear.svg',
                  //         width: 0.028.w,
                  //         height: 0.023.h,
                  //         color: AppColors.textButton,
                  //       ),
                  //       SizedBox(width: 0.008.w),
                  //       Text(
                  //         'Edit Photo'.tr,
                  //         style: AppFontStyle.cairoRegularStyle.copyWith(
                  //           fontSize: orientation == Orientation.portrait
                  //               ? FontConstants.fontSize018.h
                  //               : FontConstants.fontSize021.h,
                  //           fontWeight: FontWeight.w400,
                  //           color: AppColors.textButton,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          MediaQuery.of(context).size.shortestSide > 600
              ? Positioned(
                  right: Get.locale.toString().contains('en') ? 0 : null,
                  left: Get.locale.toString().contains('ar') ? 0 : null,
                  top: orientation == Orientation.portrait ? 0.078.h : 0.055.h,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: Get.locale.toString().contains('en') ? 0.02.w : 0,
                        right:
                            Get.locale.toString().contains('ar') ? 0.02.w : 0,
                        top: 0.005.h,
                        bottom: 0.005.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Freelancer Mode'.tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: orientation == Orientation.portrait
                                ? FontConstants.fontSize018.h
                                : FontConstants.fontSize026.h,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            //height: 0.0012.h
                          ),
                        ),
                        SizedBox(
                          width: 0.04.w,
                        ),
                        SizedBox(
                          // color: Colors.amber,
                          width: 0.09.w,
                          child: Transform.scale(
                            scale: 1.1,
                            child: GestureDetector(
                              onTap: () {
                                hapticController.triggerHapticFeedback(
                                    vibration: VibrateType.lightImpact,
                                    hapticFeedback: HapticFeedback.lightImpact);
                                setState(() {
                                  setState(() {
                                    switchValue = !switchValue;
                                    Mode.freelancer = !Mode.freelancer;
                                  });
                                  RestartWidget.restartApp(context);
                                });
                              },
                              child: SvgPicture.asset(
                                switchValue
                                    ? 'assets/icons/SwitchOn.svg'
                                    // ignore: unrelated_type_equality_checks
                                    : themeController.currentTheme ==
                                            AppColors.lightTheme
                                        ? 'assets/icons/SwitchOff.svg'
                                        : 'assets/icons/SwitchDark.svg',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
  Widget _buildProfileImage() {
    final orientation = MediaQuery.of(context).orientation;
    final imagePath = widget.profileImagePath;
    final bool isNetworkImage = imagePath != null &&
        imagePath.isNotEmpty &&
        imagePath != '[]' &&
        (imagePath.startsWith('http://') ||
            imagePath.startsWith('https://'));

    final fallbackImage = employee?.gender?.lastOrNull == 'female'
        ? 'assets/images/female_avatar.png'
        : 'assets/images/male_avatar.png';

    final width = MediaQuery.of(context).size.shortestSide > 600
        ? (orientation == Orientation.portrait ? 0.190.w : 0.1.w)
        : 0.270.w;

    final height = MediaQuery.of(context).size.shortestSide > 600
        ? (orientation == Orientation.portrait ? 0.190.w : 0.135.h)
        : 0.130.h;

    if (isNetworkImage) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to asset image if network image fails
          return Image.asset(
            fallbackImage,
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    }

    return Image.asset(
      fallbackImage,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
