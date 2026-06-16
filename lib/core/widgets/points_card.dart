import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/my_switch.dart';
import 'package:demo_app/core/widgets/point.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/settings/settings_screen/views/owner_screens/subscribes_and_services_screen.dart';


import '../theme/theme_controller.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

///  Developer's Name: Bassel Attia
///  Date: 21/7/2023
///  App Version : demo_app V1
///  Date of Last Edit: 27/7/2023
///
/// Shows the Points (description points) of a plan in SubscribesAndServicesScreen
/// and PlanDetailsScreen. It uses the Point widget to show text with a
/// tick beside it.
class PointsCard extends StatelessWidget {
  PointsCard({this.planName, this.onTap, this.isSelected, super.key});
  final bool? isSelected;
  final String? planName;
  final VoidCallback? onTap;
  late final bool isPopup = planName != null;
  final ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isPopup ? popUpWidgets(context) : Container(),
        Expanded(
          child: ListView(padding: EdgeInsets.zero, children: [
            ...List.generate(points.length * 2 - 1, (index) {
              if (index.isOdd) {
                return Container(
                  height: 0.01.h,
                );
              } else {
                int pointIndex = index ~/ 2;
                String point = points[pointIndex];
                return Point(
                  fontSizeMultiplicationFactor: MediaQuery.of(context).size.shortestSide > 600
                   ? 0.0004.h : 0.00115.h,
                  text: point,
                  isPopup: isPopup,
                );
              }
            }),
          ]),
        ),
      ],
    );
  }

  Widget popUpWidgets(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${planName!.capitalizeFirst!} Plan",
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: 0.056.w,
                    color: AppColors.colorGrey,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(height: 0.013.h),
              Text("\$${plans[planName!.toLowerCase()]!['price']}/ Month",
                  style: AppFontStyle.cairoRegularStyle.copyWith( 
                    fontSize: 0.080.w,
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 0.001.h, right: 0.020.w),
              child: GestureDetector(
                onTap: onTap,
                child: MySwitch(
                  isBlack: true,
                  switchSize: 0.01.h,
                  isSelected: isSelected!,
                ),
              )),
        ],
      ),
      SizedBox(height: 0.019.h),
      Text(
        "You're now getting more features at App",
        style: AppFontStyle.cairoRegularStyle.copyWith(
          fontSize: 0.034.w,
          color: AppColors.colorGrey,
          fontWeight: FontWeight.w300,
        ),
      ),
      SizedBox(height: 0.017.h),
    ]);
  }
}
