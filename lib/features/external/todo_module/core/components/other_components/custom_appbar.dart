// ignore_for_file: sdk_version_since

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';
import 'package:demo_app/features/external/todo_module/core/constants/enum.dart';
import 'package:demo_app/features/external/todo_module/core/constants/haptic_controller.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';

class CustomAppBar extends StatefulWidget {
  final bool isNotifications;
  ValueChanged<bool>? isNotState;

  CustomAppBar({
    super.key,
    this.isNotifications = false,
    this.isNotState,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final ToDoHapticController hapticController =
      Get.find<ToDoHapticController>();
  @override
  Widget build(BuildContext context) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container();
    Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
          horizontal: orientation ? 0.02.w : 0.06.h,
          vertical: orientation ? 0.01.h : 0.02.h),
      child: GestureDetector(
        onTap: () {
          hapticController.triggerHapticFeedback(
              vibration: VibrateType.mediumImpact,
              hapticFeedback: HapticFeedback.mediumImpact);
          // Navigator.pushReplacement(
          //   context,
          //   PageTransition(
          //     type: PageTransitionType.fade,
          //     child: const EmployeeAttendanceScreen(),
          //   ),
          // );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.02.h),
              child: GestureDetector(
                onTap: () {
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.mediumImpact,
                      hapticFeedback: HapticFeedback.mediumImpact);
                  /*          widget.isNotifications == false
                      ? Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: const NotificationView(),
                          ),
                        )
                      : Navigator.pop(context);*/
                },
                child: Container(
                  width: widget.isNotifications ? 0.05.h : .04.h,
                  height: widget.isNotifications ? 0.05.h : .04.h,
                  decoration: BoxDecoration(
                      color: widget.isNotifications
                          ? const Color(0xFFE5B800)
                          : null,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/Bell.svg',
                      // ignore: deprecated_member_use
                      color: widget.isNotifications
                          ? AppColors.white
                          : AppColors.darkGrey,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: orientation ? 0.02.w : 0.04.h,
            ),
            // Circular image
            CircleAvatar(
              radius: orientation ? 0.02.h : 0.03.h,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/male_avatar.png'),
            ),

            SizedBox(
              width: 0.02.h,
            ),
            // Texts
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // '${Get.locale.toString().contains('en') ? employee!.firstName!.firstNames!.last!.capitalize : employee!.firstNameInArabic!.firstNamesInArabic!.last!} ${Get.locale.toString().contains('en') ? employee!.lastName!.lastNames!.last!.capitalize : employee!.lastNameInArabic!.lastNamesInArabic!.last!}',
                  "",
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: orientation
                          ? FontConstants.fontSize016.h
                          : FontConstants.fontSize018.h,
                      color: mainCoreThemeController.currentTheme ==
                              MyThemeData.lightTheme
                          ? MyThemeData.colorBlack
                          : MyThemeData.colorWhiteDark,
                      fontWeight: FontWeight.w600,
                      height: orientation ? 2 : 0.002.h),
                ),
                Text(
                  "",

                  // employee!.role!.role!.last! == 'ceo'
                  //     ? 'CEO'.tr
                  //     : employee!.role!.role!.last!.capitalize as String,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: orientation
                        ? FontConstants.fontSize014.h
                        : FontConstants.fontSize016.h,
                    color: mainCoreThemeController.currentTheme ==
                            MyThemeData.lightTheme
                        ? MyThemeData.colorDarkGrey
                        : MyThemeData.colorGreydark,
                    fontWeight: FontWeight.w400,
                    height: orientation ? 1 : 0.0015.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
