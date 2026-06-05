import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:demo_app/core/theme/my_theme.dart';

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

  void updateFonts() {
    if (currentTheme.value.brightness == Brightness.light) {
      currentTheme.value = MyThemeData.lightTheme;
      Get.changeTheme(MyThemeData.lightTheme);
    } else {
      currentTheme.value = MyThemeData.darkTheme;
      Get.changeTheme(MyThemeData.darkTheme);
    }
    Get.forceAppUpdate();
    update();
  }

  void updatePrimaryColor() {
    MyThemeData.action = int.parse(storage.read('primaryColor') ?? '0xFFFFDE59');
    MyThemeData.lightPrimary = Color(MyThemeData.action);
    MyThemeData.signOut = Color(MyThemeData.action);
    MyThemeData.barColor = Color(MyThemeData.action);
    MyThemeData.bubbleColor = Color(MyThemeData.action);

    if (currentTheme.value.brightness == Brightness.light) {
      currentTheme.value = MyThemeData.lightTheme;
      Get.changeTheme(MyThemeData.lightTheme);
    } else {
      currentTheme.value = MyThemeData.darkTheme;
      Get.changeTheme(MyThemeData.darkTheme);
    }
    Get.forceAppUpdate();
    update();
  }

  void updateSecondaryColor() {
    MyThemeData.primary = int.parse(storage.read('secondaryColor') ?? '0xFFE5B800');
    MyThemeData.switchSettings = Color(MyThemeData.primary);

    if (currentTheme.value.brightness == Brightness.light) {
      currentTheme.value = MyThemeData.lightTheme;
      Get.changeTheme(MyThemeData.lightTheme);
    } else {
      currentTheme.value = MyThemeData.darkTheme;
      Get.changeTheme(MyThemeData.darkTheme);
    }
    Get.forceAppUpdate();
    update();
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
