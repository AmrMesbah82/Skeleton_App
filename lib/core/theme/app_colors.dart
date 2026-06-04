// Date: 1/8/2024
// By: Nada Mohammed, Youssef Ashraf, Mohamed Ashraf
// Last update: 11/8/2024
// Objectives: This file is responsible for providing the app colors that are used in the app.

import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppColorsThree {
  static Map<String, Color> currentThemeColors = AppTheme.lightThemeColors;


  static Color get white => currentThemeColors['white']!;
  static Color get black => currentThemeColors['black']!;
  static Color get secondaryBlack => currentThemeColors['secondaryBlack']!;
  static Color get whiteShadow => currentThemeColors['whiteShadow']!;
  static Color get darkWhiteShadow => currentThemeColors['darkWhiteShadow']!;
  static Color get darkWhite => currentThemeColors['darkWhite']!;
  static Color get button => currentThemeColors['button']!;
  static Color get textButton => AppTheme.contrastColor();
  static Color get icon => currentThemeColors['icon']!;

  // ----------------- Primary Colors -----------------
  static Color get text => currentThemeColors['text']!;
  static Color get inputColor => currentThemeColors['inputColor']!;

  static Color get primary => currentThemeColors['primary']!;
  static Color get secondaryPrimary => currentThemeColors['secondaryPrimary']!;
  // ----------------- Components Colors -----------------
  static Color get field => currentThemeColors['field']!;
  static Color get appBar => currentThemeColors['appBar']!;
  static Color get dropShadow => currentThemeColors['dropShadow']!;
  static Color get borderCard => currentThemeColors['borderCard']!;
  static Color get message => currentThemeColors['message']!;
  static Color get messageText => currentThemeColors['messageText']!;
  static Color get background => currentThemeColors['background']!;
  static Color get indicator => currentThemeColors['indicator']!;
  static Color get starredCard => currentThemeColors['starredCard']!;

  // ----------------- Grey Colors -----------------
  static Color get grey => currentThemeColors['grey']!;
  static Color get lightGrey => currentThemeColors['lightGrey']!;
  static Color get moreLightGrey => currentThemeColors['moreLightGrey']!;
  static Color get mediumGrey => currentThemeColors['mediumGrey']!;
  static Color get darkGrey => currentThemeColors['darkGrey']!;

  // ----------------- Basic Colors -----------------
  static Color get blackShadow => currentThemeColors['blackShadow']!;
  static Color get base => currentThemeColors[
      'base']!; // *** anything white and converted to black ***
  static Color get inverseBase => currentThemeColors[
      'inverseBase']!; // *** anything black and converted to white ***
  static Color get border => currentThemeColors['border']!;
  static Color get dialog => currentThemeColors['dialog']!;
  static Color get contentBackground => currentThemeColors['chatBackground']!;
  static Color get chatField => currentThemeColors['chatField']!;
  static Color get mainItemColor => currentThemeColors['mainItemColor']!;

  // ----------------- Secondary Colors -----------------
  static Color get green => currentThemeColors['green']!;
  static Color get red => currentThemeColors['red']!;
  static Color get blue => currentThemeColors['blue']!;
}
