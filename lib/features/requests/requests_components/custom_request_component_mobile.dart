import 'package:demo_app/core/shared_components/custom_schedule_or_now_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/widgets/dialogs/reason_of_rejection_dialog.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/requests/request_controller.dart';
import 'package:demo_app/core/custom/33-custom_haptic.dart';

import '../../onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

class CustomRequestContainerMobile extends StatefulWidget {
  final String? title;
  final bool? isImage;
  final String currentValue;
  final String newValue;
  final VoidCallback acceptOnPressed;
  final VoidCallback rejectOnPressed;
  final bool isReview;
  final String? status;

  const CustomRequestContainerMobile({
    Key? key,
    this.title,
    this.isImage = false,
    required this.currentValue,
    required this.newValue,
    required this.acceptOnPressed,
    required this.rejectOnPressed,
    required this.isReview,
    this.status,
  }) : super(key: key);

  @override
  State<CustomRequestContainerMobile> createState() =>
      _CustomRequestContainerMobileState();
}

class _CustomRequestContainerMobileState
    extends State<CustomRequestContainerMobile> {
  bool isAccepted = false;
  bool isRejected = false;
  String? rejectionReason;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final TextStyle blackTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: isPortrait
          ? FontConstants.fontSize016.h
          : FontConstants.fontSize021.h,
      color: themeController.currentTheme == AppColors.lightTheme
          ? AppColors.colorBlack
          : AppColors.colorWhiteDark,
      fontWeight: Get.locale.toString().contains('en')
          ? FontWeight.w600
          : FontWeight.w500,
    );

    final TextStyle greyTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: isPortrait
          ? FontConstants.fontSize016.h
          : FontConstants.fontSize021.h,
      color: themeController.currentTheme == AppColors.lightTheme
          ? AppColors.colorDarkGrey
          : AppColors.colorGreydark,
      fontWeight: Get.locale.toString().contains('en')
          ? FontWeight.w600
          : FontWeight.w500,
    );

    return GetBuilder<RequestController>(builder: (controller) {
      return   Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.title!,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isTablet
                          ? isPortrait
                              ? FontConstants.fontSize019.h
                              : FontConstants.fontSize022.h
                          : FontConstants.fontSize018.h,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface,
                      height: 1.6),
                ),
                SizedBox(
                  height: 0.02.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 0.015.h, horizontal: 0.02.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        themeController.currentTheme == AppColors.lightTheme
                            ? AppColors.colorLightGrey
                            : AppColors.darkBackGround,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Current:".tr,
                            style: blackTextStyle,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.currentValue,
                              style: greyTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.03.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "New:".tr,
                            style: blackTextStyle,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.newValue,
                              style: greyTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.02.h,
                      ),
                      if (widget.isReview == false)
                        Row(
                          children: [
                            Expanded(
                              child: CustomIconButton(
                                textColor: AppColors.delete,
                                buttonColor: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                buttonText: 'Reject',
                                imagePath: 'assets/icons/rejectIconColored.svg',
                                imageColor: AppColors.delete,
                                borderColor: AppColors.delete,
                                onPressed: () {
                                  // setState(() {
                                  //   isRejected = true;
                                  // });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomScheduleOrNowDialog(
                                        titleText: 'Reject Request?'.tr,
                                        isNow: true,
                                        bodyText:
                                            'Are you sure you want to reject this Request ?',
                                        onDateTimeSelected:
                                            (selectedDateTime) {},
                                        yesOnPressed: () {
                                          Navigator.of(context).pop();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ReasonOfRejectionDialog();
                                            },
                                          ).then((value) {
                                            if (value != null &&
                                                value.isNotEmpty) {
                                              setState(() {
                                                isRejected = true;
                                                rejectionReason = value;
                                              });
                                            }
                                          });
                                          // widget.selectedDateTime =
                                          //     getFormattedDateTime();
                                          // widget.onDateTimeSelected(
                                          //     widget.selectedDateTime!);
                                          // // widget.onButtonPressed();
                                          // Navigator.of(context).pop();
                                          // showDialog(
                                          //     context: context,
                                          //     builder: (context) {
                                          //       return SuccessDialog(
                                          //         title: "Done",
                                          //         subtitle:
                                          //             "You Successfully Rescheduled The ${widget.dialogName} Date",
                                          //         lottieAsset:
                                          //             "assets/images/correct.json",
                                          //       );
                                          //     });
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 0.035.w),
                            Expanded(
                              child: CustomIconButton(
                                buttonColor: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                textColor: AppColors.unBlock,
                                borderColor: AppColors.unBlock,
                                imageColor: AppColors.unBlock,
                                buttonText: 'Accept',
                                imagePath: 'assets/icons/AcceptIconColored.svg',
                                onPressed: () {
                                  widget.acceptOnPressed();
                                },
                              ),
                            ),
                          ],
                        ),
                      if (widget.status == "Approved")
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/AcceptIconColored.svg',
                              height: 0.02.h,
                            ),
                            SizedBox(width: 0.02.w,),
                            Text(
                              'Accepted'.tr,
                              style: blackTextStyle.copyWith(
                                color: AppColors.unBlock,
                                height: 1.8
                              ),
                            ),
                          ],
                        ),
                      if (widget.status ==
                          "Rejected" /* && rejectionReason != null*/)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                 SvgPicture.asset(
                              'assets/icons/rejectIconColored.svg',
                              height: 0.02.h,
                            ),
                            SizedBox(width: 0.02.w,),
                                Text(
                                  'Rejected'.tr,
                                  style: blackTextStyle.copyWith(
                                    color: AppColors.delete,
                                    height: 1.8
                                  ),
                                ),
                              ],
                            ),
                            Text(
                                '${"Reason of Rejection:".tr} $rejectionReason',
                                style: blackTextStyle.copyWith(height: 1.6))
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            );
    });
  }
}
