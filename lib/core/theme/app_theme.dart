// Date: 1/8/2024
// By: Youssef Ashraf, Mohamed Ashraf, Nada Mohammed
// Last update: 20/8/2024
// Objectives: This file is responsible for providing the app themes that is used in the app.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

abstract class AppTheme {
  static bool isDark= false;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: AppColorsThree.primary,
    scaffoldBackgroundColor: AppColorsThree.background,
    colorScheme: ColorScheme.light(
      primary: AppColorsThree.secondaryPrimary,
      onPrimary: Colors.white,
      outlineVariant: AppColorsThree.lightGrey,
      onSurface: AppColorsThree.inverseBase,
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      headerHeadlineStyle: AppTextStyles.font23BlackRegularCairo,
      weekdayStyle: AppTextStyles.font12DarkGrayCairo,
      headerBackgroundColor: AppColorsThree.secondaryPrimary,
      headerForegroundColor: Colors.white,
      backgroundColor: AppColorsThree.field,
      todayBackgroundColor: WidgetStatePropertyAll(AppColorsThree.field),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      dayStyle: AppTextStyles.font14BlackCairoMedium,
      dayBackgroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorsThree.secondaryPrimary;
          }
          return AppColorsThree.field;
        },
      ),
      dayForegroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          } else if (states.contains(WidgetState.disabled)) {
            return AppColorsThree.lightGrey;
          }
          return AppColorsThree.text;
        },
      ),
      yearBackgroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorsThree.secondaryPrimary;
          }
          return AppColorsThree.field;
        },
      ),
      yearForegroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return AppColorsThree.text;
        },
      ),
      dividerColor: AppColorsThree.secondaryPrimary,
      dayShape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      todayForegroundColor: WidgetStateProperty.all(
        AppColorsThree.secondaryPrimary,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppColorsThree.primary,
    scaffoldBackgroundColor: AppColorsThree.background,
    colorScheme: ColorScheme.dark(
      primary: AppColorsThree.secondaryPrimary,
      onPrimary: Colors.white,
      outlineVariant: AppColorsThree.lightGrey,
      onSurface: AppColorsThree.inverseBase,
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      headerHeadlineStyle: AppTextStyles.font23BlackRegularCairo,
      weekdayStyle: AppTextStyles.font12DarkGrayCairo,
      headerBackgroundColor: AppColorsThree.secondaryPrimary,
      headerForegroundColor: Colors.white,
      backgroundColor: AppColorsThree.field,
      todayBackgroundColor: WidgetStatePropertyAll(AppColorsThree.field),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      dayStyle: AppTextStyles.font14BlackCairoMedium,
      dayBackgroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorsThree.secondaryPrimary;
          }
          return AppColorsThree.white;
        },
      ),
      dayForegroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          } else if (states.contains(WidgetState.disabled)) {
            return AppColorsThree.lightGrey;
          }
          return AppColorsThree.black;
        },
      ),
      yearBackgroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorsThree.secondaryPrimary;
          }
          return AppColorsThree.field;
        },
      ),
      yearForegroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return AppColorsThree.text;
        },
      ),
      dividerColor: AppColorsThree.secondaryPrimary,
      dayShape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      todayForegroundColor: WidgetStateProperty.all(
        AppColorsThree.secondaryPrimary,
      ),
    ),
  );

  // ****************** DEFINE COLOR PALETTE HERE ******************

  static Map<String, Color> lightThemeColors = {
    'secondaryPrimary': const Color(0xffE5B800),
    'primary': const Color(0xffFF0000),
    'inputColor': const Color(0xff8D8D8D),
    'grey': const Color(0xffD9D9D9),
    'lightGrey': const Color(0xffC3C3C3),
    'moreLightGrey': const Color(0xffEFEFEF),
    'mediumGrey': const Color(0xffA6A6A6),
    'darkGrey': const Color(0xff858585),
    'blackShadow': const Color.fromRGBO(0, 0, 0, 0.4),
    'green': const Color(0xff008000),
    'red': const Color(0xffFF0000),
    'blue': const Color(0xff1F78D1),
    'field': Colors.white,
    'text': const Color(0xff2D2D2D),
    'base': Colors.white,
    'inverseBase': const Color(0xff797979),
    'dropShadow': const Color(0xffC3C3C3).withOpacity(0.5),
    'borderCard': const Color(0xffFFFFFF),
    'message': const Color(0xffEFEFEF),
    'messageText': const Color(0xff858585),
    'border': const Color(0xffD9D9D9),
    'background': const Color(0xffF5F5F5),
    'appBar': const Color(0xffF5F5F5),
    'indicator': const Color(0xffE9E9E9),
    'starredCard': Colors.white,
    'black': const Color(0xff2D2D2D),
    'secondaryBlack': const Color(0xff797979),
    'whiteShadow': const Color(0xD9D9D9E0),
    'darkWhiteShadow': const Color(0x9E9E9E9E),
    'white': Colors.white,
    'darkWhite': const Color(0xffF2F2F2),
    'dialog': Colors.white,
    'button': const Color(0xffF2F2F2),
    'icon': const Color(0xff2D2D2D),
    'chatBackground': const Color(0xffF5F5F5),
    'chatField': Colors.white,
    'mainItemColor': Colors.white,
  };

  // ****************** DEFINE DARK COLOR PALETTE HERE ******************
  static Map<String, Color> darkThemeColors = {
    'secondaryPrimary': const Color(0xffE5B800),
    'primary': const Color(0xffFFDE59),
    'inputColor': const Color(0xff8D8D8D),
    'grey': const Color(0xffD9D9D9),
    'lightGrey': const Color(0xffC3C3C3),
    'moreLightGrey': const Color(0xffEFEFEF),
    'mediumGrey': const Color(0xffA6A6A6),
    'darkGrey': const Color(0xff858585),
    'blackShadow': const Color.fromRGBO(0, 0, 0, 0.4),
    'green': const Color(0xff008000),
    'red': const Color(0xffFF0000),
    'blue': const Color(0xff1F78D1),
    'field': const Color(0xff4B4B4B),
    'text': Colors.white,
    'base': Colors.white,
    'inverseBase': Colors.white,
    'dropShadow': const Color(0xffC3C3C3).withOpacity(0.5),
    'borderCard': const Color(0xffFFFFFF),
    'message': const Color(0xffEFEFEF),
    'messageText': const Color(0xff858585),
    'border': Colors.transparent,
    'background': const Color(0xff2D2D2D),
    'appBar': const Color(0xff2D2D2D),
    'indicator': const Color(0xffE9E9E9),
    'starredCard': Colors.white,
    'black': const Color(0xff2D2D2D),
    'secondaryBlack': const Color(0xff797979),
    'whiteShadow': const Color(0xD9D9D9E0),
    'darkWhiteShadow': const Color(0x9E9E9E9E),
    'white': Colors.white,
    'darkWhite': const Color(0xffF2F2F2),
    'dialog': const Color(0xff2D2D2D),
    'button': const Color(0xD9D9D9E0),
    'icon': const Color(0xD9D9D9E0),
    'chatBackground': const Color(0xff4B4B4B),
    'chatField': const Color(0xff2D2D2D),
    'mainItemColor': const Color(0xff545454),
  };

  static void setCurrentThemeColors() {
    AppColorsThree.currentThemeColors = !isDark! ? lightThemeColors : darkThemeColors;
  }

  static void toggleTheme() async {
    if (isDark!) {
      isDark = false;
    } else {

      isDark = true;
    }
    setCurrentThemeColors();

   // Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);

    Get.forceAppUpdate();
  }

  static void interfaceToggleTheme() async {
    isDark = !isDark!;
    setCurrentThemeColors();
  }

  static void interfaceInitTheme(
      Color primaryColor, Color secondaryColor, bool isDarkMode) async {
    // print text has color of primary Color in console

    print('at app theme controller primaryColor $primaryColor');
    isDark = isDarkMode;
    interfaceUpdateBrandingColors(primaryColor, secondaryColor);
    Get.forceAppUpdate();
  }

  static void interfaceUpdateBrandingColors(
      Color primaryColor, Color secondaryColor) {


    lightThemeColors['secondaryPrimary'] = secondaryColor;
    lightThemeColors['primary'] = primaryColor;
    darkThemeColors['secondaryPrimary'] = secondaryColor;
    darkThemeColors['primary'] = primaryColor;

    setCurrentThemeColors();
    Get.forceAppUpdate();

  }

  static Color contrastColor() {
    final double primaryLuminance = AppColorsThree.primary.computeLuminance();
    final double secondaryPrimaryLuminance =
        AppColorsThree.secondaryPrimary.computeLuminance();

    // Check if both colors are light or dark
    if (primaryLuminance > 0.5 && secondaryPrimaryLuminance > 0.5) {
      return AppColorsThree.black; // Return black for light colors
    } else if (primaryLuminance <= 0.5 && secondaryPrimaryLuminance <= 0.5) {
      return AppColorsThree.white; // Return white for dark colors
    } else {
      return AppColorsThree.white; // Change this to the desired contrasting color
    }
  }

  static Color contrastGreyColor() {
    final double primaryLuminance = AppColorsThree.primary.computeLuminance();
    final double secondaryPrimaryLuminance =
        AppColorsThree.secondaryPrimary.computeLuminance();

    // Check if both colors are light or dark
    if (primaryLuminance > 0.5 && secondaryPrimaryLuminance > 0.5) {
      return AppColorsThree.secondaryBlack; // Return black for light colors
    } else if (primaryLuminance <= 0.5 && secondaryPrimaryLuminance <= 0.5) {
      return AppColorsThree.white; // Return white for dark colors
    } else {
      // If one color is light and the other is dark, return a contrasting color
      return AppColorsThree.white; // Change this to the desired contrasting color
    }
  }
}
