import 'package:demo_app/core/theme/grc_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

class EmployeeMobileCard extends StatelessWidget {
  EmployeeMobileCard(
      {super.key,
      required this.cardIcon,
      required this.title,
      required this.onPressed,
      this.isReviw = false,
      this.isOpenedImage = false,
      required this.value});
  final String title;
  final String cardIcon;
  double value;
  Function() onPressed;
  final bool isReviw;
  final bool isOpenedImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.015.h),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 0.99.w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: 0.01.h, horizontal: 0.015.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          cardIcon,
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          height: 0.035.h,
                        ),
                        SizedBox(
                          width: 0.02.w,
                        ),
                        Text(
                          title.tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: FontConstants.fontSize019.h,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              height: 2),
                        ),
                      ],
                    ),
                    isReviw
                        ? isOpenedImage
                            ? SvgPicture.asset(
                                "assets/icons/arrow_up_mobile.svg",
                                height: 0.03.h,
                                color: themeController.currentTheme ==
                                        MyThemeData.lightTheme
                                    ? null
                                    : MyThemeData.colorWhite,
                              )
                            : SvgPicture.asset(
                                "assets/icons/arrow_down_mobile.svg",
                                height: 0.03.h,
                                color: themeController.currentTheme ==
                                        MyThemeData.lightTheme
                                    ? null
                                    : MyThemeData.colorWhite,
                              )
                        : Transform.rotate(
                          angle:  Get.locale.toString().contains('en')?0:3.14,
                          child: SvgPicture.asset(
                              'assets/icons/arrow_right_mobile.svg',
                              color: themeController.currentTheme ==
                                      MyThemeData.lightTheme
                                  ? null
                                  : MyThemeData.colorWhite,
                              height: 0.03.h,
                            ),
                        )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0.015.w, vertical: 0.01.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 0.015.h,
                      borderRadius: BorderRadius.circular(64),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(MyThemeData.signOut),
                      backgroundColor:
                          themeController.currentTheme == MyThemeData.lightTheme
                              ? MyThemeData.indicatorColor.withOpacity(0.1)
                              : MyThemeData.GreyBack.withOpacity(0.4),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
