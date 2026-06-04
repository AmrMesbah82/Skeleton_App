import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'my_theme.dart';

class MainCoreThemeController extends GetxController {
  final storage = GetStorage();
  Rx<ThemeData> currentTheme = MyThemeData.lightTheme.obs;

  ///------------------ animation --------------
  var isAnimateAble = true;
  void toggleAnimation() {
    isAnimateAble = !isAnimateAble;
    Get.forceAppUpdate();
  }

  ///------------------ end animation --------------

  @override
  void onInit() {
    super.onInit();
    loadThemeFromStorage();
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
    if (currentTheme.value == MyThemeData.lightTheme) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: MyThemeData.colorLightGrey,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: MyThemeData.colorBlack,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
    }
  }

  void updateSystemUIOverlayStyleTablet() {
    if (currentTheme.value == MyThemeData.lightTheme) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: MyThemeData.colorWhite,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: MyThemeData.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
    }
  }

  // ✅ NEW: Updated updateFonts method
  void updateFonts() {
    print('🔄 ===== UPDATE FONTS START =====');
    print('🔄 Current font in storage: ${storage.read('font')}');
    print('🔄 Current arabic font in storage: ${storage.read('font_arabic')}');

    // Force theme recreation by reassigning
    if (currentTheme.value.brightness == Brightness.light) {
      print('🔄 Updating light theme...');
      currentTheme.value = MyThemeData.lightTheme;
      Get.changeTheme(MyThemeData.lightTheme);
    } else {
      print('🔄 Updating dark theme...');
      currentTheme.value = MyThemeData.darkTheme;
      Get.changeTheme(MyThemeData.darkTheme);
    }

    // Force complete app update
    Get.forceAppUpdate();
    update();

    print('🔄 Theme updated and app forced to rebuild');
    print('🔄 ===== UPDATE FONTS END =====');
  }

  // ✅ NEW: Updated updatePrimaryColor method
  void updatePrimaryColor() {
    print('🎨 ===== UPDATE PRIMARY COLOR START =====');
    print('🎨 Primary color in storage: ${storage.read('primaryColor')}');

    // Reload the color values
    MyThemeData.action = int.parse(storage.read('primaryColor') ?? '0xFFFFDE59');
    MyThemeData.lightPrimary = Color(MyThemeData.action);
    MyThemeData.signOut = Color(MyThemeData.action);
    MyThemeData.barColor = Color(MyThemeData.action);
    MyThemeData.bubbleColor = Color(MyThemeData.action);

    // Force theme update
    if (currentTheme.value.brightness == Brightness.light) {
      currentTheme.value = MyThemeData.lightTheme;
      Get.changeTheme(MyThemeData.lightTheme);
    } else {
      currentTheme.value = MyThemeData.darkTheme;
      Get.changeTheme(MyThemeData.darkTheme);
    }

    Get.forceAppUpdate();
    update();

    print('🎨 Primary color updated');
    print('🎨 ===== UPDATE PRIMARY COLOR END =====');
  }

  // ✅ NEW: Updated updateSecondaryColor method
  void updateSecondaryColor() {
    print('🖌️ ===== UPDATE SECONDARY COLOR START =====');
    print('🖌️ Secondary color in storage: ${storage.read('secondaryColor')}');

    // Reload the color values
    MyThemeData.primary = int.parse(storage.read('secondaryColor') ?? '0xFFE5B800');
    MyThemeData.switchSettings = Color(MyThemeData.primary);

    // Force theme update
    if (currentTheme.value.brightness == Brightness.light) {
      currentTheme.value = MyThemeData.lightTheme;
      Get.changeTheme(MyThemeData.lightTheme);
    } else {
      currentTheme.value = MyThemeData.darkTheme;
      Get.changeTheme(MyThemeData.darkTheme);
    }

    Get.forceAppUpdate();
    update();

    print('🖌️ Secondary color updated');
    print('🖌️ ===== UPDATE SECONDARY COLOR END =====');
  }

  void toggleTheme() {
    if (currentTheme.value.brightness == Brightness.light) {
      currentTheme.value = MyThemeData.darkTheme;
    } else {
      currentTheme.value = MyThemeData.lightTheme;
    }
    update();
  }

  void loadThemeFromStorage() {
    final savedTheme = storage.read('theme');
    if (savedTheme != null) {
      if (savedTheme == 'darkMode') {
        currentTheme.value = MyThemeData.darkTheme;
        Get.changeTheme(MyThemeData.darkTheme);
      } else {
        currentTheme.value = MyThemeData.lightTheme;
        Get.changeTheme(MyThemeData.lightTheme);
      }
    }
  }
}