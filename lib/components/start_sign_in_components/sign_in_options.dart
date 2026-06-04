//Date Created :10/September/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :10/October/2023 by mazen
// Objectives: this class  created to Customize the Buttons of sign in options
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class SigninOptions extends StatelessWidget {
  SigninOptions(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.backGroundColor,
      required this.textColor,
      required this.textHeight,
      this.isApple = false});
  final String imageUrl;
  final String title;
  final Color backGroundColor;
  final Color textColor;
  final double textHeight;
  final bool isApple;
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 0.078.w : 0.028.w),
      child: MainCustomIconButton(
        buttonStyle: ElevatedButton.styleFrom(
          fixedSize: isTablet
              ? Get.locale.toString().contains('en')
                  ? Size(0.8.w, 0.063.h)
                  : Size(0.9.w, 0.063.h)
              : Size(0.95.w, 0.063.h),
          backgroundColor: backGroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.0),
              side: const BorderSide(color: Colors.grey)),
        ),
        onPressed: () {
          // hapticController.triggerHapticFeedback(
          //     vibration: VibrateType.lightImpact,
          //     hapticFeedback: HapticFeedback.lightImpact);
          // PersistentNavBarNavigator.pushNewScreen(
          //   context,
          //   screen: const CreateProfileUI(),
          //   withNavBar: false,
          // );
        },
      ),
    );
  }
}
