import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';
// date:April/3/2023
// by:mohamedFouad
// lastUpdate:April/9/2023

//This is a class named 'MyThemeData' that defines a set of colors and two themes,
// one light and one dark, with specific color schemes and text styles. The color
// values are defined as static fields of the class, making them easily accessible
// without creating an instance of the class. The two themes are also static fields,
// with one representing a light theme and the other a dark theme. The light and
// dark themes are defined with specific color schemes and text styles, using
// the color values previously defined in the class. This code can be used to
// create a consistent and customizable theme for an application.

// date:April/3/2023
// by:mohamedFouad
// lastUpdate:April/9/2023

//This is a class named 'MyThemeData' that defines a set of colors and two themes,
// one light and one dark, with specific color schemes and text styles. The color
// values are defined as static fields of the class, making them easily accessible
// without creating an instance of the class. The two themes are also static fields,
// with one representing a light theme and the other a dark theme. The light and
// dark themes are defined with specific color schemes and text styles, using
// the color values previously defined in the class. This code can be used to
// create a consistent and customizable theme for an application.
class MyThemeData {
  static int action =
      //0xFFE5B800;
      int.parse(storage.read('primaryColor') ?? '0xFFFFDE59');
  // 0xff51abcb;
  static int primary =
      //0xFFFFDE59;
      int.parse(storage.read('secondaryColor') ?? '0xFFE5B800');
  // 0xff66b6d2;
  static String font = Get.locale.toString().contains('ar')
      ? storage.read('font_arabic') ?? 'Vazirmatn'
      : storage.read('font') ?? 'Cairo';

  Color contrastColor() {
    // final Color primaryColor = Color(primary);
    // final Color actionColor = Color(action);

    // Check if the action color is equal to '0xFFFFDE59'

    final double primaryLuminance = lightPrimary.computeLuminance();
    final double actionLuminance = signOut.computeLuminance();

    // Check if both colors are light or dark
    if (primaryLuminance > 0.5 && actionLuminance > 0.5) {
      return MyThemeData.colorBlack; // Return black for light colors
    } else if (primaryLuminance <= 0.5 && actionLuminance <= 0.5) {
      return MyThemeData.colorWhite; // Return white for dark colors
    } else {
      // If one color is light and the other is dark, return a contrasting color
      return MyThemeData
          .colorWhite; // Change this to the desired contrasting color
    }
  }

  static Color colorBorder = const Color(0xFFE5E5ED);
  static Color colorYellow = const Color(0xFFFFDE59);
  static Color colorWhite = const Color(0xFFFFFFFF);
  static Color colorWhiteDark = const Color(0xFFF2F2F2);
  static Color colorLightGrey = const Color(0xFFF5F5F5);
  static Color colorMediumGrey = const Color(0xFFEEEEEE);
  static Color colorGrey = const Color(0xFF9E9E9E);
  static Color colorTotalBlack = const Color(0xFF000000);
  static Color colorDarkGrey = const Color(0xFF797979);
  static Color colorGreydark = const Color(0xFFCCCCCC);
  static Color resendColor = const Color(0xFF289BF6);
  static Color colorGreyReq = const Color(0xFF888888);
  static Color colorGreyDisabled = const Color(0xFF999999);
  static Color colorGreyOpacity = const Color(0xFF767680).withOpacity(.12);
  static Color textfieldColor = const Color.fromRGBO(246, 246, 246, 1);
  static Color iconColor = const Color(0xFF797878);
  static Color colorGreyDark = const Color(0xFF6F6F6F);
  static Color deactivated = const Color(0xFFC9C9C9);
  static Color lightPrimary = Color(primary);
  static Color mainColor = const Color(0xFFFFDE59);

  // static Color lightPrimary = const Color(0xFFE5B800);
  static Color switchSettings = Color(primary);
  // static Color switchSettings = const Color(0xFFE5B800);
  static Color colorBlack = const Color(0xFF2D2D2D);
  static Color dividerGrey = const Color(0xFFDBDCDD);
  static Color delete = const Color(0xFFDF1C1C);
  static Color icon = const Color(0xff2D2D2D);

  static Color signOut = Color(action);
  static Color secondaryColor = Color(0xFFE5B800);
  // static Color signOut = const Color(0xFFFFDE59);
  static Color textGrey = const Color(0xFF8D8D8D);
  static Color textdeactivecolor = const Color.fromRGBO(121, 121, 121, 1);
  static Color cancelButton = const Color(0xFF585858);
  static Color warning = const Color(0xFFFF814A);
  static Color unBlock = const Color(0xFF4BB609);
  static Color menu = const Color(0xFFEBEBEB);
  static Color versionColor = const Color(0xFF979797);
  static Color bulletColor = const Color(0xFF8D8D8D);
  static Color contColor = const Color(0xFFF2F2F2);
  // ignore: non_constant_identifier_names
  static Color InProg = const Color(0x00a3a3a3);
  static Color iconColorBlack = const Color(0xFF303030);
  static Color barColor = Color(action);
  // static Color barColor = const Color(0xFFFEDD58);
  // ignore: use_full_hex_values_for_flutter_colors
  static Color jobColor = const Color(0xFFF606060);
  static Color bubbleColor = Color(action);
  //static Color bubbleColor = const Color(0xFFFFDE59);
  static Color colorRed = const Color(0xFFDF1C1C);
  static Color block = const Color(0xFFDF0C0C);
  static Color bubbleGrey = const Color(0xFFE9E9EB);
  // ignore: non_constant_identifier_names
  static Color GreyBack = const Color(0xFFBBBBBB);
  static Color textCal = const Color(0xFF19181A);
  static Color dark = const Color(0xFF4B4B4B);
  static Color greyLightC = const Color(0xFFF8F7FA);
  static Color darkBackGround = const Color(0xFF545454);
  static Color barrierColor = const Color(0XFFD9D9D9).withOpacity(.9);
  static Color barrierColorBlack = const Color(0XFF252525).withOpacity(.9);
  static Color dotBlack = const Color(0XFF2D2D2D).withOpacity(.2);
  static Color red = const Color(0XFFFF4545);
  static Color dividerColor = const Color(0xFF959090);
  static Color border = const Color(0xFFECECEC);
  static Color blue = const Color(0XFF1877F2);
  static Color colorBlue = const Color(0xFF1877F2);
  static Color divider = const Color(0xFFCFCAE4);
  static Color indicatorColor = const Color(0xFF0A0F0C);
  static Color deactivedot = const Color.fromRGBO(45, 45, 45, 0.2);
  static Color welcomeColor = const Color(0xFF686868);
  static Color level2color = const Color(0xFF4B4B4B);
  static Color level2colorOp = const Color(0xFF4B4B4B).withOpacity(0.5);
  static Color level4 = const Color(0xFFCCCCCC);
  static Color blueNew = const Color(0xFF347AE2);
  static Color blackColor = const Color(0xFF1C1B1A);
  static Color greenN = const Color(0xFF27C470);
  static Color blueN = const Color(0xFF25BAF5);
  static Color violet = const Color(0xFF837EFF);
  static Color darkerViolet = const Color(0xFF615BFE);
  static Color bluelight = const Color(0xFF0ACCC9);
  static Color violetBol = const Color(0xFF8F40DE);
  static Color pink = const Color(0xFFFF647C);
  static Color review = const Color(0xFF564FFD);
  static Color darkGreen = const Color(0xFF39AB03);
  static Color darkOrange = const Color(0xFFFD9F40);
  static Color lightGreenPublic = const Color(0xFF33D980);
  static Color orange = const Color(0xFFFD8E1F);
  static Color brown = const Color(0xFFDB6D07);
  static Color yellow = const Color(0xFFE8E14C);
  static Color green = const Color(0xFF1EC70F);
  static Color purple = const Color(0xFFED12F1);
  static Color darkBlue = const Color(0xFF1820DD);
  static Color lightPurple = const Color(0xFFEEEDFE);
  static Color grey = const Color(0xFF6A6A75);
  static Color blueDivider = const Color(0xFFD8F4FF);
  static Color darkPurple = const Color(0xFF1B175F);
  static Color semiPurple = const Color(0xFF261FA4);
  static Color lightGreen = const Color(0xFFD2F2E1);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    hoverColor: Colors.transparent,
    colorScheme: ColorScheme(
        outlineVariant: border,
        primary: lightPrimary,
        onPrimary: colorWhite,
        onErrorContainer: welcomeColor,
        secondary: colorWhite,
        onSecondary: colorGrey,
        background: colorLightGrey,
        error: colorRed,
        onError: colorRed,
        onSurface: colorGreyOpacity,
        surface: iconColor,
        onBackground: colorMediumGrey,
        onSurfaceVariant: colorMediumGrey,
        onPrimaryContainer: iconColorBlack,
        primaryContainer: barColor,
        brightness: Brightness.light,
        secondaryContainer: colorBlack,
        onSecondaryContainer: bubbleGrey,
        onTertiaryContainer: colorBlack,
        inversePrimary: colorWhite,
        shadow: colorGreydark,
        inverseSurface: darkBackGround,
        surfaceTint: MyThemeData.darkBackGround,
        outline: colorBlack,
        tertiaryContainer: colorGrey,
        errorContainer: colorBlack,
        scrim: colorDarkGrey,
        surfaceVariant: colorLightGrey,
        onInverseSurface: colorBlack,
        tertiary: colorGrey,
        onTertiary: colorGrey),
    scaffoldBackgroundColor: colorLightGrey,
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize055.h,
        color: colorBlack,
        fontWeight: FontWeight.w700,
        height: 1.0,
      ),
      titleMedium: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize031.h,
        color: colorBlack,
        fontWeight: FontWeight.w500,
        height: 1.0,
      ),
      titleSmall: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize030.h,
        color: colorBlack,
        fontWeight: FontWeight.w500,
        height: 1.0,
      ),
      displayLarge: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize020.h,
        fontWeight: FontWeight.w600,
        color: colorBlack,
        height: 1.0,
      ),
      displayMedium: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize020.h,
        fontWeight: FontWeight.w300,
        color: colorGrey,
        height: 1.0,
      ),
      displaySmall: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize020.h,
        fontWeight: FontWeight.w400,
        color: colorBlack,
        height: 1.0,
      ),
      bodySmall: TextStyle(
        fontFamily: font,
        fontSize: FontConstants.fontSize020.h,
        fontWeight: FontWeight.w600,
        color: colorBlack,
        height: 1.0,
      ),
      bodyMedium: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize025.h,
        fontWeight: FontWeight.w500,
        color: colorGrey,
        height: 1.0,
      ),
      labelSmall: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize013.h,
        fontWeight: FontWeight.w500,
        color: colorBlack,
        height: 1.0,
      ),
    ),
  );
  static final ThemeData darkTheme = ThemeData(
    hoverColor: Colors.transparent,
    useMaterial3: true,
    colorScheme: ColorScheme(
        outlineVariant: dark, //border
        primary: lightPrimary,
        onPrimary: colorBlack,
        onErrorContainer: colorGreydark,
        onSurfaceVariant: colorBlack, // colorWhite
        secondary: colorBlack,
        primaryContainer: colorGrey,
        onSecondary: colorGrey,
        tertiary: colorWhite,
        surfaceTint: MyThemeData.colorWhite,
        background: dark,
        error: colorRed,
        onError: colorRed,
        onSurface: colorGreyOpacity,
        onTertiaryContainer: darkBackGround,
        surface: colorBlack,
        onBackground: darkBackGround,
        brightness: Brightness.dark,
        secondaryContainer: colorWhite, // colorBlack
        inversePrimary: dark, // colorWhite
        shadow: dark,
        onSecondaryContainer: barrierColor,
        inverseSurface: colorLightGrey,
        outline: dark,
        tertiaryContainer: colorGreydark,
        errorContainer: colorGreydark, // colorBlack
        scrim: colorWhiteDark,
        surfaceVariant: colorBlack,
        onInverseSurface: colorLightGrey, //colorBlack
        onTertiary: colorWhite),
    scaffoldBackgroundColor: colorBlack,
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize055.h,
        color: colorWhiteDark,
        fontWeight: FontWeight.w700,
        height: 1.0,
      ),
      titleMedium: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize031.h,
        color: colorWhiteDark,
        fontWeight: FontWeight.w500,
        height: 1.0,
      ),
      titleSmall: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize030.h,
        color: colorWhite,
        fontWeight: FontWeight.w500,
        height: 1.0,
      ),
      displayLarge: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize020.h,
        fontWeight: FontWeight.w600,
        color: colorWhiteDark,
        height: 1.0,
      ),
      displayMedium: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize020.h,
        fontWeight: FontWeight.w300,
        color: colorGrey,
        height: 1.0,
      ),
      displaySmall: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize020.h,
        fontWeight: FontWeight.w400,
        color: colorBlack,
        height: 1.0,
      ),
      bodySmall: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize020.h,
        fontWeight: FontWeight.w600,
        color: colorWhite,
        height: 1.0,
      ),
      bodyMedium: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize025.h,
        fontWeight: FontWeight.w500,
        color: colorGrey,
        height: 1.0,
      ),
      labelSmall: TextStyle(
        fontFamily: font,
        fontStyle: FontStyle.normal,
        fontSize: FontConstants.fontSize013.h,
        fontWeight: FontWeight.w500,
        color: colorBlack,
        height: 1.0,
      ),
    ),
  );
}
