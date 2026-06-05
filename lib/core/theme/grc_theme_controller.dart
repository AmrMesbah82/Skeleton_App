import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:demo_app/core/widgets/restart_widget.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_theme.dart';

class GRCThemeController extends GetxController {
  final storage = GetStorage();
  Rx<ThemeData> currentTheme = AppTheme.lightTheme.obs;
  RxBool animationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeFromStorage();
    loadAnimationsSetting();
    ever(currentTheme, (_) => updateSystemUIOverlayStyle());
  }

  void updateSystemUIOverlayStyle() {
    if (Get.context != null) {
      bool isTablet = MediaQuery.of(Get.context!).size.shortestSide > 600;
      if (isTablet) {
        updateSystemUIOverlayStyleTablet();
      } else {
        updateSystemUIOverlayStyleMobile();
      }
    }
  }

  void updateSystemUIOverlayStyleMobile() {
    if (currentTheme.value == AppTheme.lightTheme) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppColors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
    }
  }

  void updateSystemUIOverlayStyleTablet() {
    if (currentTheme.value == AppTheme.lightTheme) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppColors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppColors.field,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
    }
  }

  void toggleTheme() {
    if (currentTheme.value == AppTheme.lightTheme) {
      currentTheme.value = AppTheme.darkTheme;
      AppTheme.toggleTheme();
      storage.write('theme', 'darkMode');
      Get.changeTheme(AppTheme.darkTheme);
    } else {
      currentTheme.value = AppTheme.lightTheme;
      AppTheme.toggleTheme();
      storage.write('theme', 'lightMode');
      Get.changeTheme(AppTheme.lightTheme);
    }
    update();
  }

  void loadThemeFromStorage() {
    final savedTheme = storage.read('theme');
    if (savedTheme != null) {
      if (savedTheme == 'darkMode') {
        currentTheme.value = AppTheme.darkTheme;
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            Get.changeTheme(AppTheme.darkTheme);
          },
        );
      } else {
        currentTheme.value = AppTheme.lightTheme;
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            Get.changeTheme(AppTheme.lightTheme);
          },
        );
      }
    }
  }

  void toggleAnimations(bool isEnabled) {
    animationsEnabled.value = isEnabled;
    storage.write('animationsEnabled', isEnabled);
    if (shouldRestartAppForAnimationChange) {
      RestartWidget.restartApp(Get.context!);
    }
    update();
  }

  bool get shouldRestartAppForAnimationChange => false;

  void loadAnimationsSetting() {
    animationsEnabled.value = storage.read('animationsEnabled') ?? true;
  }
}
