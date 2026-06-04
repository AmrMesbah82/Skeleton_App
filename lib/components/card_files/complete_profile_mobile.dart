//Date Created :8/October/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :8/October/2023 by mazen
// Objectives: this class  created to make the container of complete your profile progress in the mobile
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/settings_screen/views/profile_screen.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:demo_app/nav_bar_package.dart/functions.dart';

class CompelteProfileMobile extends StatefulWidget {
  const CompelteProfileMobile({super.key});

  @override
  State<CompelteProfileMobile> createState() => _CompelteProfileMobileState();
}

class _CompelteProfileMobileState extends State<CompelteProfileMobile> {
  // ignore: non_constant_identifier_names
  double CardHeight = 0.12.h;
  double percentages = 80;
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: CardHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            spreadRadius: .5,
            blurRadius: .2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: .07.w),
            // child: SizedBox(
            //   height: .7 * CardHeight,
            //   width: .7 * CardHeight,
            //   child: SimpleCircularProgressBar(
            //     size: .1.h,
            //     progressStrokeWidth: .025.w,
            //     backStrokeWidth: .025.w,
            //     mergeMode: true,
            //     animationDuration: 3,
            //     onGetText: (value) {
            //       return Text(
            //         '${value.toInt()}%',
            //         style: Theme.of(context).textTheme.bodySmall!.copyWith(
            //             color: const Color(0xff00CB2D)
            //                 .withOpacity(percentages / 100),
            //             height: 0.0021.h),
            //       );
            //     },
            //     progressColors: const [
            //       Colors.yellow,
            //       Color(0xff00CB2D),
            //     ],
            //     backColor: const Color(0xffE9E9E9),
            //   ),
            // ),
          ),
          percentages > 95
              ? SizedBox(
                  width: .55.w,
                  child: FittedBox(
                    alignment: Get.locale.toString().contains('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Your profile was Completed'.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: FontConstants.fontSize025.h,
                          // ignore: unrelated_type_equality_checks
                          color: themeController.currentTheme ==
                                  MyThemeData.darkTheme
                              ? Colors.white
                              : null),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: CardHeight * .093,
                    ),
                    SizedBox(
                      width: .4.w,
                      child: FittedBox(
                        alignment: Get.locale.toString().contains('ar')
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Complete Your Profile'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  fontSize: FontConstants.fontSize025.h,
                                  // ignore: unrelated_type_equality_checks
                                  color: themeController.currentTheme ==
                                          MyThemeData.darkTheme
                                      ? Colors.white
                                      : null),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: CardHeight * .2,
                    ),
                    InkWell(
                      onTap: () {
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.mediumImpact,
                            hapticFeedback: HapticFeedback.mediumImpact);
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          withNavBar: false,
                          screen: const ProfileScreen(),
                        );
                      },
                      child: SizedBox(
                        width: .3.w,
                        child: FittedBox(
                          alignment: Get.locale.toString().contains('ar')
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text('Take Action Now'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: const Color(0xFF1877F2))),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
