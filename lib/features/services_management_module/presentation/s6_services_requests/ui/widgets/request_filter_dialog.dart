import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/widgets/services_management/custom_textformfield.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';


Future<void> showSuccessDialog({
  required String lottiePath,
  required String title,
  required BuildContext context,
  required String subtitle,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => Dialog(
      backgroundColor:
      Theme.of(context).brightness == Brightness.light
          ? AppColors.white
          : AppColors.chatBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: SizedBox(
          width: 411.sp,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                lottiePath,
                width: 70.w,
                height: 70.h,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(height: 20.h),
              Text(
                title,
                style: AppTextStyles.font20BlackCairoMedium.copyWith(
                  color:
                  Theme.of(context).brightness == Brightness.light
                      ? AppColors.blackButton
                      : AppColors.white,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                  color:
                  Theme.of(context).brightness == Brightness.light
                      ? AppColors.secondaryText
                      : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> showConfirmationDialog({
  required String lottiePath,
  required String title,
  required BuildContext context,
  required String message,
  required VoidCallback onConfirm,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => Dialog(

      backgroundColor:
      Theme.of(context).brightness == Brightness.light
          ? AppColors.white
          : AppColors.chatBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: SizedBox(
          width: 411.sp,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Lottie.asset(
                lottiePath, // Replace with your Lottie URL
                width: 70.sp,
                height: 70.sp,
                fit: BoxFit.scaleDown,
                repeat: true,
                // Set to false if you don't want it to loop
                animate: true, // Set to false to pause the animation
              ),

              SizedBox(height: 20.sp),
              Text(
                title,
                style: AppTextStyles.font20BlackCairoMedium.copyWith(
                  color:
                  Theme.of(context).brightness == Brightness.light
                      ? AppColors.blackButton
                      : AppColors.white,
                ),
              ),
              SizedBox(height: 18.sp),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                  color:
                  Theme.of(context).brightness == Brightness.light
                      ? AppColors.secondaryText
                      : AppColors.grey,
                ),
              ),
              SizedBox(height: 15.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 56.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    customButtonAnimation(
                      title: "No",
                      function: () => Navigator.pop(context),
                      textStyle: AppTextStyles.font15BlackCairoRegular.copyWith(
                          color: Color(0xff2D2D2D)
                      ),
                      width: 135.sp,
                      height: 38.sp,
                      radius: 4.r,
                      color: AppColors.secondaryButton,
                    ),
                    SizedBox(width: 20.sp),
                    customButtonAnimation(
                      title: "Yes",
                      function: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      textStyle: AppTextStyles.font15BlackCairoRegular.copyWith(
                          color: AppColors.textButton
                      ),
                      width: 135.sp,
                      height: 38.sp,
                      radius: 4.r,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


String? cancelReason;

Future<void> commentRejectDialogAction(
    TextEditingController canselController,
    BuildContext context,
    Function () onTap ,

    ) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => Dialog(
      backgroundColor:
      Theme.of(context).brightness == Brightness.light
          ? AppColors.white
          : AppColors.chatBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: SizedBox(
          width: 411.sp,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Reason Of Rejection
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 30.sp,
                    height: 30.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.textButton,
                      size: 20.sp,
                    ),
                  ),

                  SizedBox(width: 5.sp),

                  Text(
                    S.of(context).ReasonOfCancelation,
                    style: AppTextStyles.font16BlackMediumCairo.copyWith(
                      color:AppColors.text
                    ),
                  ),
                ],
              ),

              //space
              SizedBox(height: 20.sp),

              Container(
                color:
                Theme.of(context).brightness == Brightness.light
                    ? AppColors.white
                    : AppColors.chatBackground,
                child: CustomValidatedTextFieldMaster(
                  label: S.of(context).Justifications,
                  hint: S.of(context).Texthere,
                  controller: canselController,

                  height: 72.sp,
                  maxLines: 3,
                  showCharCount: true,
                  onChanged: (val) => cancelReason = val.trim(),
                  textStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.blackButton
                        : AppColors.white,
                  ),
                ),
              ),

              SizedBox(height: 15.sp),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  customButtonAnimation(
                    title: S.of(context).discard,
                    function: (){
                      Navigator.pop(context);
                    },
                    textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                      color: Color(0xff2D2D2D),
                    ),
                    width: 150.sp,
                    height: 38.sp,
                    radius: 8.r,
                    color: Color(0xffcccccccc),
                  ),

                  Spacer(),
                  customButtonAnimation(
                    title: S.of(context).submit,
                    function: onTap,
                    textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color:AppColors.textButton
                    ),
                    width: 150.sp,
                    height: 38.sp,
                    radius: 8.r,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
