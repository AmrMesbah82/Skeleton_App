import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/generated/l10n.dart';

/// ✅ LOCALE HELPER - Single source of truth for locale
/// Initialize once in main(), use everywhere else
class LocaleHelper {
  static Locale? _cachedLocale;
  static bool _isInitialized = false;

  /// ✅ Initialize locale BEFORE runApp() - loads messages synchronously
  static Future<Locale> initialize() async {
    if (_isInitialized) return _cachedLocale!;

    final box = GetStorage();
    String? localeData = box.read<String>('LocaleData');

    // Fallback to device locale
    if (localeData == null || localeData.isEmpty) {
      localeData = Get.deviceLocale?.toString();
    }

    // Final fallback
    localeData ??= 'en_US';

    // Parse locale
    final isArabic = localeData.contains('ar');
    final languageCode = isArabic ? 'ar' : 'en';
    final countryCode = isArabic ? 'EG' : 'US';

    _cachedLocale = Locale(languageCode, countryCode);

    // ✅ CRITICAL: Load messages BEFORE app starts
    try {
      await S.load(_cachedLocale!);
      Intl.defaultLocale = languageCode;
      _isInitialized = true;

      debugPrint('✅ [LOCALE] Initialized: $_cachedLocale');
      debugPrint('✅ [LOCALE] Intl.defaultLocale: ${Intl.defaultLocale}');
      debugPrint('✅ [LOCALE] Messages loaded: ${S.current != null}');

    } catch (e, stack) {
      debugPrint('❌ [LOCALE] Failed to load: $e');
      // Fallback to English
      _cachedLocale = const Locale('en', 'US');
      await S.load(_cachedLocale!);
      Intl.defaultLocale = 'en';
      _isInitialized = true;
    }

    return _cachedLocale!;
  }

  /// ✅ Get pre-calculated locale (call initialize() first)
  static Locale get locale {
    assert(_isInitialized,
    'LocaleHelper.initialize() must be called before runApp()');
    return _cachedLocale!;
  }

  static bool get isArabic => _cachedLocale?.languageCode == 'ar';

  /// ✅ Change locale at runtime (calls S.load() internally)
  static Future<void> changeLocale(Locale newLocale) async {
    final box = GetStorage();
    await box.write('LocaleData', newLocale.toString());

    _cachedLocale = newLocale;
    await S.load(newLocale);
    Intl.defaultLocale = newLocale.languageCode;

    // Force app rebuild via GetX
    Get.updateLocale(newLocale);
  }
}