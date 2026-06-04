import 'dart:math';
import 'package:get/get.dart';
// date:April/6/2023
// lastUpdate:April/7/2023

// This is an extension for the double data type in Flutter/Dart that adds three
// methods (r, w, and h) to simplify the calculation of screen dimensions.
// The r method returns a value that is a fraction (this) of the minimum of the
// screen height and width.
// The w method returns a value that is a fraction (this) of the screen width,
// which can be used to size widgets based on the width of the screen.
// The h method returns a value that is a fraction (this) of the screen height,
// which can be used to size widgets based on the height of the screen.

extension ScreenSizeExtension on double {
  double get r {
    // Ensure Get is initialized properly before using it
    if (Get.context != null) {
      return min(Get.height, Get.width) * this;
    }
    return 0.0; // Fallback value if Get.context is null
  }

  double get w {
    // Ensure Get is initialized properly before using it
    if (Get.context != null) {
      return Get.width * this;
    }
    return 0.0; // Fallback value if Get.context is null
  }

  double get h {
    // Ensure Get is initialized properly before using it
    if (Get.context != null) {
      return Get.height * this;
    }
    return 0.0; // Fallback value if Get.context is null
  }
}
