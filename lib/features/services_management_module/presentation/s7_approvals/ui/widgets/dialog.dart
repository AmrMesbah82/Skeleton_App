import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_helper_function.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/request_filter_dialog.dart';

Future<void> commentRejectDialogActionApproval(BuildContext context, String? id) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).brightness == Brightness.light ?  AppColors.white : AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: SizedBox(
          width: 405.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              //Reason Of Rejection
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                      width: 30.sp,
                      height:30.sp ,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.yellow
                      ),
                      child: Icon(Icons.close,color: AppColors.black, size: 20.sp,)),


                  SizedBox(width: 5.sp),

                  Text(S.of(context).reasonOfRejection,style: AppTextStyles.font16BlackMediumCairo.copyWith(
                      color: Theme.of(context).brightness == Brightness.light?
                      AppColors.blackButton:
                      AppColors.white
                  ),),

                ],
              ),

              //space
              SizedBox(height: 20.sp),

              //Justifications
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Text(S.of(context).Justifications,style: AppTextStyles.font14BlackCairoMedium.copyWith(
                      color: Theme.of(context).brightness == Brightness.light?
                      AppColors.blackButton:
                      AppColors.white
                  ),),

                ],
              ),

              SizedBox(height: 8.sp),


              Container(
                width: 499.sp,
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.white
                    : AppColors.background,
                child: TextFormField(
                  maxLines: 2,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: "Text here",
                    hintStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.secondaryText
                          : AppColors.grey,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.light
                        ? AppColors.white
                        : AppColors.chatBackground,
                    hoverColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    counterStyle: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),



              SizedBox(height: 20.sp),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  customButtonAnimation(
                      title: "Submit",
                      function: () async {
                        ServicesManagerCubit.get(context).updateApprovalState(
                          docID: id!,
                          email: employeeFunctionHelper.email!,
                          newState: "Rejected",
                        );
                        Navigator.pop(context);
                        await showSuccessDialog(
                          lottiePath: "assets/lottie/approved.json",
                          context: context,
                          title: "Successful",
                          subtitle: "You Successfully Rejected This Request.",
                        );

                        ServicesManagerCubit.get(context).getMyRequestServices();
                      },
                      textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                          color: Theme.of(context).brightness == Brightness.light?
                          AppColors.blackButton:
                          AppColors.blackButton
                      ),
                      width: 130.sp,
                      height: 30.sp,
                      radius: 8.r,
                      color: AppColors.yellow
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    ),
  );
}




Future<void> showConfirmationDialogApproval({
  required String lottiePath,
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) async {
  final isTablet = context.isTablet;
  final isMobile = context.isPhone;
  final isLandscape = context.isLandscape;
  return showDialog(
    context: context,
    barrierDismissible: true,
    useRootNavigator: true, // 👈 Important!
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).brightness == Brightness.light ?  AppColors.white : AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: SizedBox(
          width: 405.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Lottie.asset(
                lottiePath, // Replace with your Lottie URL
                width: 60.sp,
                height: 60.sp,
                fit: BoxFit.scaleDown,
                repeat: true, // Set to false if you don't want it to loop
                animate: true, // Set to false to pause the animation
              ),

              SizedBox(height: 10.sp),
              Text(title, style: AppTextStyles.font20BlackCairoMedium.copyWith(
                color: Theme.of(context).brightness == Brightness.light ?  AppColors.blackButton : AppColors.white,
              )),
              SizedBox(height: 10.sp),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.light ?  AppColors.secondaryText : AppColors.grey,
                ),
              ),
              SizedBox(height: 10.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 19.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customButtonAnimation(
                      title: "No",
                      function: () => Navigator.pop(context),
                      textStyle: AppTextStyles.font15BlackCairoRegular,
                      width: isMobile ? 100.sp :  isTablet&&!isLandscape ? 130.sp : 130.sp,
                      height: 30.sp,
                      radius: 4.r,
                      color: AppColors.secondaryButton,
                    ),
                    SizedBox(width: 20.w),
                    customButtonAnimation(
                      title: "Yes",
                      function: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      textStyle: AppTextStyles.font15BlackCairoRegular,
                      width: isMobile ? 100.sp :  isTablet&&!isLandscape ? 130.sp : 130.sp,
                      height: 30.sp,
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





Future<void> showSuccessDialogApproval({
  required String lottiePath,
  required String title,
  required BuildContext context,
  required String subtitle,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? AppColors.white
          : AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: SizedBox(
          width: 405.w,
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
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.blackButton
                      : AppColors.white,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
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
