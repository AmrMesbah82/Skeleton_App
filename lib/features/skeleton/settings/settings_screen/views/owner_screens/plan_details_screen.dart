import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/modal_bottom_sheets.dart';
import 'package:demo_app/core/widgets/points_card.dart';
import 'package:demo_app/core/widgets/buttons/yellow_elevated_button.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';
import 'package:demo_app/features/skeleton/settings/settings_screen/views/owner_screens/subscribes_and_services_screen.dart';



///  Developer's Name: Bassel Attia
///  Date: 11/7/2023
///  App Version : Knowticed V1
///  Date of Last Edit: 11/7/2023
///
/// Shows up when clicking on "Choose Plan" button in SubscribesAndServicesScreen.
class PlanDetailsScreen extends StatelessWidget with ModalBottomSheets {
  PlanDetailsScreen(
      {required this.plan,
      required this.planImage,
      required this.price,
      required this.points,
      required this.isSubscribed,
      required this.formattedDate,
      super.key});
  final Plans plan;
  final String planImage;
  final String formattedDate;
  final bool isSubscribed;
  final int price;
  final List<String> points;
  late final String planName = plans[plan]!['name'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: [
         
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  left: 0.055.w, top: 0.005.h, right: 0.055.w, bottom: 0.007.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // Transform.scale(
                      //     scale: 0.0015.h,
                      //     child: SvgPicture.asset(
                      //         'assets/images/Rectangle 20.svg')),
                      Transform.scale(
                        scale: 0.0015.h,
                        child: Container(
                           decoration: BoxDecoration(
                            color: MyThemeData.signOut,
                            borderRadius: BorderRadius.circular(8), 
                          ),
                          child: Transform.scale(
                            scale: 0.0009.h,
                            child: SvgPicture.asset(planImage),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.025.h),
                  Text(
                    Get.locale.toString().contains('ar')
                        ? "${"Welcome to".tr} ${"Plan".tr} ${planName.tr}"
                        : "${"Welcome to".tr} $planName ${"Plan".tr}",
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: 0.064.w,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.010.h),
                  Text(
                    "You're now getting more features at App".tr,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: 0.040.w,
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 0.014.h),
                  Expanded(child: PointsCard()),
                  // SizedBox(height: 0.015.h),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.015.h),
                    child: !isSubscribed
                        ? SubscribeRow(price: price)
                        : AlreadySubscribedColumn(
                            nextPlan: plans[plan]!['nextPlan'],
                          ),
                  ),
                  // SizedBox(height: 0.035.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class AlreadySubscribedColumn extends StatelessWidget {
  // ignore: unused_element
  AlreadySubscribedColumn({
    super.key,
    // ignore: unused_element
    this.daysUntilRenewal,
    this.nextPlan,
  });
  final int? daysUntilRenewal;
  final Plans? nextPlan;
  bool isLightTheme =
      Get.put(ThemeController()).currentTheme.value == MyThemeData.lightTheme;
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final orientation = MediaQuery.of(context).orientation;
     final HapticController hapticController = Get.put(HapticController());

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.008.h),
          child: MainCustomIconButton(
              onPressed: () {
                hapticController.triggerHapticFeedback(
                vibration: VibrateType.mediumImpact,
                hapticFeedback:HapticFeedback.mediumImpact);
              },
           
              buttonStyle: isTablet
                  ? ElevatedButton.styleFrom(
                      minimumSize: Size(
                          orientation == Orientation.portrait ? 0.7.w : 0.7.w,
                          orientation == Orientation.portrait
                              ? 0.042.h
                              : 0.049.h),
                      backgroundColor: MyThemeData.signOut,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      )),
                    )
                  : null,
              buttonText: daysUntilRenewal == null
                  ? "Renew Subscription".tr
                  : "Renew after $daysUntilRenewal Days"),
        ),
        if (nextPlan != null)
          Padding(
            padding: EdgeInsets.only(top:orientation == Orientation.portrait ? 0.008.h : 0),
            child: MainCustomIconButton(
             
                buttonStyle: ElevatedButton.styleFrom(
                  minimumSize: isTablet
                      ? Size(
                          orientation == Orientation.portrait ? 0.7.w : 0.3.w,
                          orientation == Orientation.portrait
                              ? 0.042.h
                              : 0.051.h)
                      : Size(0.94.w, 0.060.h),
                  backgroundColor:
                      isLightTheme ? MyThemeData.colorBlack : MyThemeData.dark,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  )),
                ),
                onPressed: () {
                  hapticController.triggerHapticFeedback(
                                vibration: VibrateType.heavyImpact,
                                hapticFeedback:HapticFeedback.heavyImpact);
                },
                buttonText: "${'Upgrade to'.tr} ${plans[nextPlan]!['name']}"),
          ),
        SizedBox(
          height: 0.005.h,
        ),
        TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft),
            onPressed: () {
               hapticController.triggerHapticFeedback(
                                vibration: VibrateType.heavyImpact,
                                hapticFeedback:HapticFeedback.heavyImpact);
            },
            child: Text(
              "${'Cancel'.tr} ${'Subscription'.tr}",
              style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isTablet ? FontConstants.fontSize018.h : null,
                  decoration: TextDecoration.underline,
                  color: isLightTheme
                      ? MyThemeData.colorGreyDisabled
                      : MyThemeData.colorLightGrey),
            )),
      ],
    );
  }
}

class SubscribeRow extends StatelessWidget with ModalBottomSheets {
  const SubscribeRow({
    super.key,
    required this.price,
  });

  final int price;
  @override
  Widget build(BuildContext context) {
   final HapticController hapticController = Get.put(HapticController());

    final orientation = MediaQuery.of(context).orientation;
    final TextStyle priceStyle = MediaQuery.of(context).size.shortestSide > 600
        ? AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: orientation == Orientation.portrait ? 0.0420.w : 0.0320.w,
            color: Theme.of(context).colorScheme.onInverseSurface,
            fontWeight: FontWeight.w900,
          )
        : AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: 0.0820.w,
            color: Theme.of(context).colorScheme.onInverseSurface,
            fontWeight: FontWeight.w900,
          );
    return MediaQuery.of(context).size.shortestSide > 600
        ? Padding(
            padding: EdgeInsets.only(
              top: orientation == Orientation.portrait ? 0.03.w : 0.015.h,
              bottom: orientation == Orientation.portrait ? 0.0.w : 0.0 .h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "\$$price /",
                        style: priceStyle,
                      ),
                      TextSpan(
                        text: "Month".tr,
                        style: priceStyle.copyWith(
                          fontSize: orientation == Orientation.portrait
                              ? 0.0365.w
                              : 0.0265.w,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyThemeData.signOut,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: orientation == Orientation.portrait
                            ? 0.008.h
                            : 0.01.h,
                        horizontal: orientation == Orientation.portrait
                            ? 0.065.w
                            : 0.1.w),
                  ),
                  onPressed: () {
                    hapticController.triggerHapticFeedback(
                                vibration: VibrateType.heavyImpact,
                                hapticFeedback:HapticFeedback.heavyImpact);
                    showDoneModalBottomSheet(context);
                  },
                  child: Text(
                    "Subscribe".tr,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      color: MyThemeData.colorBlack,
                      fontSize: orientation == Orientation.portrait
                          ? 0.019.h
                          : 0.026.h,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\$$price /",
                      style: priceStyle,
                    ),
                    TextSpan(
                      text: "Month".tr,
                      style: priceStyle.copyWith(
                        fontSize: 0.0665.w,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 0.450.w,
                height: 0.060.h,
                child: YellowElevatedButton(
                    text: Text(
                      "Subscribe".tr,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                        color: MyThemeData.colorBlack,
                        fontSize: 0.029.h,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                         hapticController.triggerHapticFeedback(
                                vibration: VibrateType.heavyImpact,
                                hapticFeedback:HapticFeedback.heavyImpact);
                      showDoneModalBottomSheet(context);
                    }),
              ),
            ],
          );
  }
}
