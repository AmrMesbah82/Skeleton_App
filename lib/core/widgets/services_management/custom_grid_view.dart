import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class CrossAxisCountHelperResponsive {
  static int getCrossAxisCountForDefaultTabletResponsive(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    // ==================== DESKTOP PLATFORMS ====================
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      // Large desktop (≥ 1920)
      if (screenWidth >= 1920) {
        return isLandscape ? 5 : 4;
      }

      // Laptop desktop (1366 – 1919)
      if (screenWidth >= 1366) {
        return isLandscape ? 4 : 3;
      }

      // Tablet desktop (768 – 1365)
      if (screenWidth >= 768) {
        return isLandscape ? 3 : 2;
      }

      // Small desktop (< 768)
      return isLandscape ? 1 : 1;
    }

    // ==================== LARGE DESKTOP / TV (≥ 1920) ====================
    if (screenWidth >= 1920) {
      return isLandscape ? 6 : 5;
    }

    // ==================== LAPTOP (1366 – 1919) ====================
    if (screenWidth >= 1366) {
      return isLandscape ? 5 : 4;
    }

    // ==================== TABLET (768 – 1365) ====================
    if (screenWidth >= 768) {
      return isLandscape ? 3 : 2;
    }

    // ==================== MOBILE (< 768) ====================
    return isLandscape ? 2 : 1;
  }
}