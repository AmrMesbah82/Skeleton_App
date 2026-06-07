import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/point.dart';
 import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';
import 'package:demo_app/features/skeleton/settings/settings_screen/views/owner_screens/plan_details_screen.dart';



enum Plans { professional, premium, elite }

///  Developer's Name: Bassel Attia
///  Date: 10/7/2023
///  App Version : Knowticed V1
///  Date of Last Edit: 10/8/2023
///
/// This screen shows membership plans for the user when they press on
/// Subscribes and Services button.
///
/// Note that there are two ways to show membership plans in the app:
/// either when the user presses on Subscribes
/// and Services button or as a popup when the user enters the app.

class SubscribesAndServicesScreen extends StatelessWidget {
  const SubscribesAndServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
      
          Expanded(
            child: Column(
              children: [
                buildPlanCard(plan: Plans.professional, isSubscribed: false),
                buildPlanCard(plan: Plans.premium, isSubscribed: true),
                buildPlanCard(plan: Plans.elite, isSubscribed: false),
                SizedBox(
                  height: 0.032.h,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlanCard({required Plans plan, required bool isSubscribed}) {
    late final Map<String, dynamic> planDict = plans[plan]!;
    return Expanded(
      child: PlanCard(
        isSubscribed: isSubscribed,
        plan: plan,
        price: planDict['price'],
        points: planDict['points'],
        imageAddress: planDict['imageAddress'],
      ),
    );
  }
}

// ignore: must_be_immutable
class PlanCard extends StatelessWidget {
  PlanCard(
      {required this.plan,
      required this.price,
      required this.points,
      required this.imageAddress,
      required this.isSubscribed,
      super.key});
  final Plans plan;
  final bool isSubscribed;
  final int price;
  final String imageAddress;
  final List<String> points;
  final BorderRadius borderRadius = BorderRadius.circular(9);
  bool isLightTheme =
      Get.put(ThemeController()).currentTheme.value == MyThemeData.lightTheme;
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 0.018.h, left: 0.018.h, bottom: 0.010.h),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanDetailsScreen(
                        plan: plan,
                        isSubscribed: isSubscribed,
                        formattedDate: "27/8/2023",
                        planImage: imageAddress,
                        points: points,
                        price: price),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(
                      width: isSubscribed && !isLightTheme ? 1.9 : 0,
                      color: Colors.transparent),
                  boxShadow: Get.put(ThemeController()).currentTheme.value ==
                          MyThemeData.lightTheme
                      ? [
                          BoxShadow(
                            color: MyThemeData.colorGrey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3), // Offset of the shadow
                          ),
                        ]
                      : null,
                ),
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius,
                    side: BorderSide(
                        width: 0.006.w,
                        color: isSubscribed & isLightTheme
                            ? Colors.transparent
                            : isSubscribed
                                ? MyThemeData.dark
                                : Colors.transparent),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: _LeftPolygon(
                            borderRadius: borderRadius,
                            imageAddress: imageAddress,
                            title: plans[plan]!['name'],
                            isSubscribed: isSubscribed,
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: Get.locale.toString().contains('en')
                                  ? 0.02.h
                                  : 0,
                              right: Get.locale.toString().contains('ar')
                                  ? 0.02.h
                                  : 0,
                              top: 0.040.h,
                              bottom: 0.040.h,
                            ),
                            child: _TextColumn(price: price, points: points),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.013.h,
            right: Get.locale.toString().contains('en') ? 0.02.h : null,
            left: Get.locale.toString().contains('ar') ? 0.02.h : null,
            child: _ChoosePlanButton(
              plan: plan,
              isSubscribed: isSubscribed,
              price: price,
              imageAddress: imageAddress,
              points: points,
            ),
          ),
          if (isSubscribed) _IsSelectedCard(),
        ],
      ),
    );
  }
}

class _IsSelectedCard extends StatelessWidget {
  _IsSelectedCard();
  final bool isLightTheme =
      Get.put(ThemeController()).currentTheme.value == MyThemeData.lightTheme;
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Positioned(
        right: Get.locale.toString().contains('en') ? 0.06.w : null,
        left: Get.locale.toString().contains('en') ? null : 0.06.w,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.035.w, vertical: 0.005.h),
          decoration: BoxDecoration(
              border: isLightTheme
                  ? null
                  : Border.all(
                      color: MyThemeData.darkBackGround,
                      width: 1.8,
                    ),
              color: isLightTheme ? MyThemeData.colorBlack : MyThemeData.dark,
              borderRadius: BorderRadius.circular(11)),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: 0.004.h,
              ),
              child: Text(
                "Selected".tr,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    color: MyThemeData.bubbleColor,
                    fontSize: isTablet ? null : FontConstants.fontSize016.h),
              ),
            ),
          ),
        ));
  }
}

class _TextColumn extends StatelessWidget {
  const _TextColumn({
    required this.price,
    required this.points,
  });

  final int price;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "\$$price ${"/ Mon".tr}",
          style: AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: 0.0800.w,
            color: Theme.of(context).colorScheme.onInverseSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 0.020.h,
        ),
        Point(text: points[0], isTickColorBlack: true),
        SizedBox(
          height: 0.005.h,
        ),
        Point(text: points[1], isTickColorBlack: true),
      ],
    );
  }
}

class _LeftPolygon extends StatelessWidget {
  const _LeftPolygon({
    required this.borderRadius,
    required this.imageAddress,
    required this.title,
    required this.isSubscribed,
  });

  final BorderRadius borderRadius;
  final String imageAddress;
  final String title;
  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(
          Get.locale.toString().contains('ar') ? -0.00.h : -0.0006.h, 0),
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(Get.locale.toString().contains('ar') ? -1.0 : 1.0,
                      1.0), // Flip horizontally
                child: SvgPicture.asset(
                  'assets/images/Polygon 1.svg',
                  fit: BoxFit.fill,
                  // ignore: deprecated_member_use
                  color: isSubscribed ? MyThemeData.colorBlack : null,
                ),
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imageAddress,
              // ignore: deprecated_member_use
              color: isSubscribed ? MyThemeData.bubbleColor : null,
            ),
            SizedBox(
              height: 0.018.h,
            ),
            Text(
              title.tr,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: 0.048.w,
                color: isSubscribed
                    ? MyThemeData.bubbleColor
                    : MyThemeData.colorBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChoosePlanButton extends StatelessWidget {
  const _ChoosePlanButton(
      {required this.plan,
      required this.imageAddress,
      required this.points,
      required this.isSubscribed,
      required this.price});
  final Plans plan;
  final String imageAddress;
  final List<String> points;
  final bool isSubscribed;
  final int price;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanDetailsScreen(
                plan: plan,
                isSubscribed: isSubscribed,
                formattedDate: "27/8/2023",
                planImage: imageAddress,
                points: points,
                price: price),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Choose Plan".tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: FontConstants.fontSize018.h,
                color: Theme.of(context).colorScheme.onInverseSurface,
                fontWeight: FontWeight.w400,
                height: 0.002.h),
          ),
          SizedBox(
            width: 0.005.w,
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..scale(Get.locale.toString().contains('ar') ? -1.0 : 1.0,
                  1.0), // Flip horizontally
            child: SvgPicture.asset(
              'assets/icons/arrowleft2.svg',
              fit: BoxFit.fitWidth,
              width: 0.04.w,
            ),
          )
        ],
      ),
    );
  }
}

Map<Plans, Map<String, dynamic>> plans = {
  Plans.professional: {
    'name': 'Professional'.tr,
    'price': 10,
    'points': points,
    'imageAddress': 'assets/icons/kite.svg',
    'nextPlan': Plans.premium
  },
  Plans.premium: {
    'name': 'Premium'.tr,
    'price': 20,
    'points': points,
    'imageAddress': 'assets/icons/plane.svg',
    'nextPlan': Plans.elite
  },
  Plans.elite: {
    'name': 'Elite'.tr,
    'price': 30,
    'points': points,
    'imageAddress': 'assets/icons/rocket.svg',
    'nextPlan': null
  },
};

const List<String> points = [
  "Provide services",
  "60 scheduled services",
  "Can be searched",
  "Retrieve the history of conversations for up to 6 months",
  "Retrieve the history of conversations for up to 6 months",
  "60 scheduled services",
  "Provide service locally only and thus needs to share their location",
  "Add users from the search"
];
