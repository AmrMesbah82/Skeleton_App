import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension ContextExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isTablet => MediaQuery.of(this).size.shortestSide >= 600;
  // alias used by some widgets
  bool get isTablett => MediaQuery.of(this).size.shortestSide >= 600;
  bool get isArabic => Get.locale.toString().toLowerCase().contains('ar');
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;
  bool get isPhone => MediaQuery.of(this).size.shortestSide < 600;
}

extension NumberToArabic on String {
  String toArabicNumbers() {
    const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String result = this;
    for (int i = 0; i < englishDigits.length; i++) {
      result = result.replaceAll(englishDigits[i], arabicDigits[i]);
    }
    return result;
  }
}
