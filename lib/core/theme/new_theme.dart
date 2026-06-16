// legacy_theme_adapter.dart
// Drop this in place of old theme files
// It redirects old names to the new theme system

import 'package:flutter/material.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';




// ===== Legacy TextStyle Redirects (StyleText) =====
abstract class StyleText {
  static TextStyle get fontSize8Weight400 =>
      AppTextStyles.font8SecondaryBlackRegularCairo;
  static TextStyle get fontSize10Weight400 =>
      AppTextStyles.font10BlackCairoRegular;
  static TextStyle get fontSize10Weight500 =>
      AppTextStyles.font10BlackCairoRegular;
  static TextStyle get fontSize10Weight700 =>
      AppTextStyles.font10WhiteSemiBoldCairo;
  static TextStyle get fontSize11Weight400 =>
      AppTextStyles.font10SecondaryBlackCairoRegular;
  static TextStyle get fontSize11Weight600 =>
      AppTextStyles.font12BlackCairoSemiBold;
  static TextStyle get fontSize12Weight400 =>
      AppTextStyles.font12BlackCairoRegular;
  static TextStyle get fontSize12Weight500 =>
      AppTextStyles.font12BlackMediumCairo;
  static TextStyle get fontSize12Weight600 =>
      AppTextStyles.font12SecondaryBlackCairoMedium;
  static TextStyle get fontSize13Weight400 =>
      AppTextStyles.font13SecondaryBlackCairo;
  static TextStyle get fontSize13Weight500 =>
      AppTextStyles.font13SecondaryBlackCairo;
  static TextStyle get fontSize13Weight600 =>
      AppTextStyles.font13SecondaryBlackCairo;
  static TextStyle get fontSize14Weight400 =>
      AppTextStyles.font14BlackCairoRegular;
  static TextStyle get fontSize14Weight500 =>
      AppTextStyles.font14BlackCairoMedium;
  static TextStyle get fontSize14Weight600 =>
      AppTextStyles.font14BlackSemiBoldCairo;
  static TextStyle get fontSize14Weight700 =>
      AppTextStyles.font14BlackSemiBoldCairo;
  static TextStyle get fontSize15Weight400 =>
      AppTextStyles.font15BlackCairoRegular;
  static TextStyle get fontSize15Weight500 =>
      AppTextStyles.font15BlackCairoRegular;
  static TextStyle get fontSize15Weight600 =>
      AppTextStyles.font15BlackCairoRegular;
  static TextStyle get fontSize16Weight400 =>
      AppTextStyles.font16BlackRegularCairo;
  static TextStyle get fontSize16Weight500 =>
      AppTextStyles.font16BlackMediumCairo;
  static TextStyle get fontSize16Weight600 =>
      AppTextStyles.font16BlackSemiBoldCairo;
  static TextStyle get fontSize16Weight700 =>
      AppTextStyles.font16BlackSemiBoldCairo;
  static TextStyle get fontSize18Weight500 =>
      AppTextStyles.font18BlackMediumCairo;
  static TextStyle get fontSize20Weight500 =>
      AppTextStyles.font20BlackCairoMedium;
  static TextStyle get fontSize20Weight600 =>
      AppTextStyles.font20BlackSemiBoldCairo;
  static TextStyle get fontSize22Weight700 =>
      AppTextStyles.font22BlackCairoSemiBold;
  static TextStyle get fontSize24Weight600 =>
      AppTextStyles.font23BlackRegularCairo;
  static TextStyle get fontSize28Weight600 =>
      AppTextStyles.font28BlackMediumCairo;
}

