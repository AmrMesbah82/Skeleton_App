import 'package:demo_app/features/external/main_core/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_button.dart';
import 'package:demo_app/core/enumeration/enum.dart';
//import 'package:image_crop/image_crop.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/external/grc/core/widgets/custom_button_with_image.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/nav_bar_package.dart/functions.dart';
import 'package:demo_app/nav_bar_package.dart/model.dart';

import '../../../../features/skeleton/roles/domain/enums/modules_enum.dart';
import '../../../../generated/l10n.dart';

class CustomEmployeeAppBarMobile extends StatefulWidget {
  final String? profileImagePath;
  final String? bio;
  final String? jobtitle;
  final String? jobtitleAr;  // ✅ Added Arabic job title
  final String? email;
  final String userName;
  final String userProfession;
  final String userMobile;
  final bool? isEmployeeView;
  final double totalReview;

  const CustomEmployeeAppBarMobile({
    super.key,
    this.profileImagePath,
    this.email,
    this.jobtitle,
    this.jobtitleAr,  // ✅ Added to constructor
    this.bio,
    required this.userName,
    required this.userProfession,
    required this.userMobile,
    this.isEmployeeView = false,
    required this.totalReview,
  });

  @override
  State<CustomEmployeeAppBarMobile> createState() =>
      _CustomEmployeeAppBarMobileState();
}

class _CustomEmployeeAppBarMobileState
    extends State<CustomEmployeeAppBarMobile> {
  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final orientation = MediaQuery.of(context).orientation;
    final HapticController hapticController = Get.put(HapticController());
    var isMobile = context.isPhone;

    // ✅ Get localized job title
    String displayJobTitle = _getLocalizedJobTitle();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.04.w),
      child: Stack(
        alignment: isArabic ?  Alignment.topLeft :Alignment.topRight ,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 0.02.w),
            child: Column(
              children: [
                SizedBox(
                  height: 0.007.h,
                ),


                Column(
                  children: [


                    Row(
                      children: [
                        Container(
                            margin: Get.locale.toString().contains('en')
                                ? EdgeInsets.only(
                                right: orientation == Orientation.portrait
                                    ? 0.036.w
                                    : 0.02.w)
                                : EdgeInsets.only(
                                left: orientation == Orientation.portrait
                                    ? 0.036.w
                                    : 0.02.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: AppColors.primary,),
                            ),
                            child: CircleAvatar(
                              radius: widget.isEmployeeView == true ? 0.06.h : 0.05.h,
                              backgroundImage: AssetImage(
                                // widget.profileImagePath ??
                                    'assets/images/male_avatar.png',
                              ),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userName.capitalize!,
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: FontConstants.fontSize026.h,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text,
                              ),
                            ),

                            SizedBox(
                              height: 10.sp,
                            ),
                            // ✅ Updated job title display with localization
                            Text(
                              displayJobTitle,
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: FontConstants.fontSize014.h,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 15.sp),

                Text(
                  widget.bio?.isNotEmpty == true ? widget.bio! : '-',
                  style: StyleText.fontSize14Weight500.copyWith(
                    height: 1.2
                  ),
                ),

                SizedBox(
                  height: 0.01.h,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.sp),
            child: customButtonWithImageMas(
                title: isMobile ? "" : 'Chat'.tr,
                function: () {
                  hapticController.triggerHapticFeedback(
                    vibration: VibrateType.mediumImpact,
                    hapticFeedback: HapticFeedback.mediumImpact,
                  );
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen:Modules.messages.widget,
                    withNavBar: false,
                    pageTransitionAnimation:
                    PageTransitionAnimation.cupertino,
                  );
                },
                space: 0,
                textStyle: StyleText.fontSize16Weight500.copyWith(
                    color: AppColors.textButton
                ),
                image: "assets/roles_icons/Messages.svg",
                height: 38.h,
                width: isMobile ? 38.w : 100.w ,
                widthImage: 20.h,
                heightImage: 20.h,
                color: AppColors.primary
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Helper method to get localized job title
  String _getLocalizedJobTitle() {
    bool isEnglish = Get.locale.toString().contains('en');

    if (isEnglish) {
      // English locale
      if (widget.jobtitle?.isNotEmpty == true) {
        return widget.jobtitle!.capitalize!;
      }
    } else {
      // Arabic locale
      if (widget.jobtitleAr?.isNotEmpty == true) {
        return widget.jobtitleAr!;
      }
    }

    // Fallback
    return '-';
  }
}