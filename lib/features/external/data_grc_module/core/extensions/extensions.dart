import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension ContextExtension on BuildContext {
  bool get isArabic => Get.locale?.languageCode == 'ar';
}
