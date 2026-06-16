import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/dummy_data/mode_changer.dart';

import 'package:demo_app/core/theme/app_font_size.dart';

class NoResponseParticipantDialog extends StatelessWidget {
  NoResponseParticipantDialog(
      {super.key, this.isEmployee = false, this.showresponse});
  bool isEmployee;
  bool? showresponse;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? (orientation ? 0.12.w : 0.2.w) : 0.02.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.01.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: orientation ? 0.015.h : 0.015.h),
                child: Text(
                  "No Responses".tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isTablet
                          ? (orientation
                              ? FontConstants.fontSize025.h
                              : FontConstants.fontSize035.h)
                          : FontConstants.fontSize024.h,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.01.h),
                child: Text(
                  (!Mode.hr && !Mode.owner) || isEmployee == true
                      ? showresponse == true
                          ? "This survey not allowed to show other responses".tr
                          : "You didn’t respond to this survey ,yet.".tr
                      : "This Person didn’t respond to this survey ,yet.".tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isTablet
                          ? (orientation
                              ? FontConstants.fontSize020.h
                              : FontConstants.fontSize030.h)
                          : FontConstants.fontSize020.h,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorDarkGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
