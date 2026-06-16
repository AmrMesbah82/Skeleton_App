// ignore_for_file: unrelated_type_equality_checks

import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/theme_controller.dart';


class ImagePaths {
  static String getImagePath(BuildContext context, String imageName) {
    final ThemeController themeController = Get.put(ThemeController());

    bool isDarkMode = themeController.currentTheme == AppColors.darkTheme;
    return isDarkMode
        ? getDarkModeImagePath(imageName)
        : getLightModeImagePath(imageName);
  }

  static String getLightModeImagePath(String imageName) {
    String logo = 'assets/images/demo_app_logo.svg';
    // 'assets/images/bmw.svg';
    if (imageName == 'logo') {
      return logo;
      // return 'assets/images/demo_app_logo.svg';
    } else if (imageName == 'edit_data') {
      return 'assets/icons/dialog_card_icon.svg';
    } else if (imageName == 'social_icon') {
      return 'assets/icons/social_dialog_icon.svg';
    } else if (imageName == 'back_icon') {
      return 'assets/icons/back_icon.svg';
    } else if (imageName == 'call_icon') {
      return 'assets/icons/call_icon.svg';
    } else if (imageName == 'mic_icon') {
      return 'assets/icons/mic_chat_icon.svg';
    } else if (imageName == 'camera_icon') {
      return 'assets/icons/camera_icon.svg';
    } else if (imageName == 'add_icon') {
      return 'assets/icons/add_chat_icon.svg';
    } else if (imageName == 'send_icon') {
      return 'assets/icons/send_icon.svg';
    } else if (imageName == 'send_inactive_icon') {
      return 'assets/icons/send_inactive_icon.svg';
    } else if (imageName == 'switch_off_icon') {
      return 'assets/icons/SwitchOff.png';
    } else if (imageName == 'splash') {
      return 'assets/splash.gif';
    } else if (imageName == 'notification') {
      return 'assets/icons/NotificationAppBarRedDot.png';
    } else {
      return '';
    }
  }

  static String getDarkModeImagePath(String imageName) {
    if (imageName == 'logo') {
      return 'assets/images/demo_app_logo_dark.svg';
    } else if (imageName == 'edit_data') {
      return 'assets/icons/dialog_card_icon_dark.svg';
    } else if (imageName == 'social_icon') {
      return 'assets/icons/social_dialog_icon_dark.svg';
    } else if (imageName == 'back_icon') {
      return 'assets/icons/back_icon_dark.svg';
    } else if (imageName == 'call_icon') {
      return 'assets/icons/call_icon_dark.svg';
    } else if (imageName == 'mic_icon') {
      return 'assets/icons/mic_icon_dark.svg';
    } else if (imageName == 'camera_icon') {
      return 'assets/icons/camera_icon_dark.svg';
    } else if (imageName == 'add_icon') {
      return 'assets/icons/add_icon_dark.svg';
    } else if (imageName == 'send_icon') {
      return 'assets/icons/send_icon_dark.svg';
    } else if (imageName == 'send_inactive_icon') {
      return 'assets/icons/send_inactive_dark_icon.svg';
    } else if (imageName == 'switch_off_icon') {
      return 'assets/icons/switch_off_icon.png';
    } else if (imageName == 'splash') {
      return 'assets/splash_dark.gif';
    } else if (imageName == 'notification') {
      return 'assets/icons/NotificationAppBarRedDot_dark.png';
    } else {
      return '';
    }
  }
}
