/// ******************* FILE INFO *******************
/// File Name: sla_notification_widgets.dart
/// Description: UI widgets for SLA notification screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/2-custom_textfield.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';


class SlaNotificationWidgets {
  static Widget slaPercentageField({
    required BuildContext context,
    required TextEditingController controller,
    required bool isInvalid,
    required ValueChanged<String> onChanged,
  }) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isMobile = context.isPhone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isMobile ? 100.sp : 150.sp,
          height: 28.sp,
          child: CustomTextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            hint: S.of(context).EnterPercentage,
            // Invalid state is shown by the external message below, so no inline
            // errorText here (keeps the fixed-height field from overflowing).
            fillColor: AppColors.background,
            borderRadius: BorderRadius.circular(4),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 8.sp, vertical: 7.sp),
            valueStyle: AppTextStyles.font10BlackCairoRegular
                .copyWith(color: AppColors.secondaryText.withOpacity(.5)),
            hintStyle: AppTextStyles.font12SecondaryBlackCairoMedium
                .copyWith(color: AppColors.secondaryText),
          ),
        ),
        SizedBox(height: 3.sp),

        AnimatedOpacity(
          opacity: isInvalid ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Text(
            controller.text.contains('.') || controller.text.contains(',')
                ? (Localizations.localeOf(context).languageCode == 'ar'
                ? "الأرقام العشرية غير مسموحة"
                : "Decimals are not allowed")
                : S.of(context).Onlynumbersareallowed,
            style: TextStyle(fontSize: 10.sp, color: AppColors.red, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  static Widget slaRow({
    required BuildContext context,
    required TextEditingController controller,
    required bool isInvalid,
    required ValueChanged<String> onChanged,
    VoidCallback? onRemove,
  }) {
    final isMobile = context.isPhone;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Row(
        children: [
          slaPercentageField(
            context: context,
            controller: controller,
            isInvalid: isInvalid,
            onChanged: onChanged,
          ),
          SizedBox(width: 5.sp),
          Padding(
            padding: EdgeInsets.only(bottom: 15.sp),
            child: Text("%", style: TextStyle(fontSize: 15.sp)),
          ),
          if (onRemove != null && !isMobile) ...[
            SizedBox(width: 10.sp),
            GestureDetector(
              onTap: onRemove,
              child: Icon(Icons.remove_circle, color: AppColors.red, size: 18.sp),
            ),
          ],
        ],
      ),
    );
  }

  static Widget addSlaButton({
    required BuildContext context,
    required VoidCallback onTap,
    required VoidCallback onSave,
  }) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.only(left: isArabic ? 0 : 30.w, bottom: 0.sp, right: isArabic ? 30.w : 0),
      child: GestureDetector(
        onTap: () {
          onTap();
          onSave();
        },
        child: Container(
          width: 110.sp,
          height: 28.sp,
          decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(4.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/plus.svg", width: 12.sp, height: 12.sp),
                SizedBox(width: 8.sp),
                Text(S.of(context).notifications,
                    style: AppTextStyles.font12BlackMediumCairo.copyWith(color: AppColors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget addSlaButtonAlt({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.only(left: isArabic ? 0 : 30.w, bottom: 0.sp, right: isArabic ? 30.w : 0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 110.sp,
          height: 28.sp,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/plus.svg",
                  width: 12.sp,
                  height: 12.sp,
                ),
                SizedBox(width: 8.sp),
                Text(
                  S.of(context).notifications,
                  style: AppTextStyles.font12BlackMediumCairo.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showSlaValidationError(BuildContext context, String sectionName) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 411.w,
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.all(15.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/lottie/attention.json",
                  width: 70.w,
                  height: 70.h,
                  fit: BoxFit.fill,
                  repeat: true,
                ),
                SizedBox(height: 10.h),
                Text(
                  S.of(context).warning,
                  style: AppTextStyles.font18BlackMediumCairo.copyWith(
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      isArabic
                          ? "لا يمكنك إلغاء تحديد '$sectionName' لأنك أدخلت بيانات نسبة اتفاقية مستوى الخدمة. يرجى مسح حقول اتفاقية مستوى الخدمة أولاً أو  إبقاء المربع محددًا."
                          : "You cannot uncheck '$sectionName' because you have entered SLA percentage data. Please clear the SLA fields first or keep the checkbox checked.",
                      style: AppTextStyles.font14BlackCairoMedium.copyWith(
                        height: 1.6,
                        color: AppColors.secondaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showValidationError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? AppColors.white
              : AppColors.chatBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          content: SizedBox(
            height: 200.sp,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                    'assets/lottie/rejected.json',
                    width: 70.sp,
                    height: 70.sp,
                    repeat: true
                ),
                SizedBox(height: 10.sp),
                Text(
                  S.of(context).validationError ?? "Validation Error",
                  style: AppTextStyles.font18BlackMediumCairo.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.blackButton
                        : AppColors.white,
                  ),
                ),
                SizedBox(height: 10.sp),
                Expanded(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font14BlackCairoMedium.copyWith(
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.secondaryText
                          : AppColors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 20.sp),
                customButtonAnimation(
                  color: AppColors.primary,
                  textStyle: AppTextStyles.font14BlackSemiBoldCairo.copyWith(
                      color: AppColors.textButton
                  ),
                  title: S.of(context).ok,
                  function: () { Navigator.of(context).pop(); },
                  width: 135.sp,
                  height: 38.sp,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
