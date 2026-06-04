import 'dart:io';
import 'package:flutter/material.dart';

/// ✅ RESPONSIVE HELPER - Calculates design size BEFORE build phase
/// Uses window.physicalSize which is available immediately, not MediaQuery
class ResponsiveHelper {
  static Size? _cachedDesignSize;
  static bool? _isTablet;
  static bool? _isDesktop;
  static bool? _isFoldable;

  /// ✅ Initialize once in main() before runApp()
  static void initialize() {
    final window = WidgetsBinding.instance.platformDispatcher.views.first;
    final physicalSize = window.physicalSize;
    final pixelRatio = window.devicePixelRatio;

    // Logical size (dp)
    final width = physicalSize.width / pixelRatio;
    final height = physicalSize.height / pixelRatio;
    final shortestSide = width < height ? width : height;

    // Detect device type
    _isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    _isTablet = !_isDesktop! && shortestSide >= 600;
    _isFoldable = _detectFoldable(width, height);

    // Calculate design size based on device type
    _cachedDesignSize = _calculateDesignSize(width, height);

    debugPrint('📱 [RESPONSIVE] Device: ${_getDeviceType()}');
    debugPrint('📱 [RESPONSIVE] Screen: ${width.toInt()}×${height.toInt()}');
    debugPrint('📱 [RESPONSIVE] Design Size: $_cachedDesignSize');
  }

  static bool _detectFoldable(double width, double height) {
    // Foldable detection: unusual aspect ratios or specific dimensions
    final aspectRatio = width / height;
    return (aspectRatio > 1.4 && aspectRatio < 1.6) || // Unfolded
        (aspectRatio > 0.6 && aspectRatio < 0.75);  // Folded
  }

  static String _getDeviceType() {
    if (_isDesktop!) return 'Desktop';
    if (_isFoldable!) return 'Foldable';
    if (_isTablet!) return 'Tablet';
    return 'Mobile';
  }

  static Size _calculateDesignSize(double width, double height) {
    final isLandscape = width > height;

    // Desktop
    if (_isDesktop!) {
      if (width > 1440) {
        return isLandscape ? const Size(1920, 1080) : const Size(1080, 1920);
      }
      if (width > 1024) {
        return isLandscape ? const Size(1440, 900) : const Size(900, 1440);
      }
      return isLandscape ? const Size(1280, 800) : const Size(800, 1280);
    }

    // Foldable (use tablet sizes)
    if (_isFoldable!) {
      return isLandscape ? const Size(1024, 768) : const Size(768, 1024);
    }

    // Tablet
    if (_isTablet!) {
      return isLandscape ? const Size(1024, 768) : const Size(768, 1024);
    }

    // Mobile
    return isLandscape ? const Size(812, 375) : const Size(375, 812);
  }

  /// ✅ Get pre-calculated design size (call after initialize())
  static Size get designSize {
    assert(_cachedDesignSize != null,
    'ResponsiveHelper.initialize() must be called before runApp()');
    return _cachedDesignSize!;
  }

  static bool get isDesktop => _isDesktop ?? false;
  static bool get isTablet => _isTablet ?? false;
  static bool get isMobile => !isDesktop && !isTablet;
  static bool get isFoldable => _isFoldable ?? false;

  /// ✅ Get adaptive value based on device type
  static T getValue<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if ((isTablet || isFoldable) && tablet != null) return tablet;
    return mobile;
  }
}