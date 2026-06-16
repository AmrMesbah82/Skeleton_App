import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:lottie/lottie.dart';


class NoEmployeeWidget extends StatelessWidget {
  const NoEmployeeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Center(
      child: Column(
        children: [
          Lottie.asset("assets/images/no_members_newww.json"),
          SizedBox(height: 0.04.h),
          Text(
            "No Employees added".tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: isPortrait
                    ? FontConstants.fontSize024.h
                    : FontConstants.fontSize032.h,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.inverseSurface),
          )
        ],
      ),
    );
  }
}
