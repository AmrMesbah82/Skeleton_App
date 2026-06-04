import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../external/main_core/core/theme/app_colors.dart';

enum RoleStatus {
  all,
  active,
  inactive,
  draft,
  deleted;

  static List<RoleStatus> get filterStatus => [
    all,
    active,
    inactive,
    draft,
  ];

  Color get color {
    switch (this) {
      case RoleStatus.all:
        return AppColors.text;
      case RoleStatus.active:
        return Colors.green;
      case RoleStatus.inactive:
        return Colors.red;
      case RoleStatus.draft:
        return AppColors.secondaryText;
      case RoleStatus.deleted:
        return Colors.black54;
    }
  }

  // Get localized name (Arabic/English)
  String getLocalizedName(String languageCode) {
    final translations = {
      'en': {
        RoleStatus.all: 'All',
        RoleStatus.active: 'Active',
        RoleStatus.inactive: 'Inactive',
        RoleStatus.draft: 'Draft',
        RoleStatus.deleted: 'Deleted',
      },
      'ar': {
        RoleStatus.all: 'الكل',
        RoleStatus.active: 'نشط',
        RoleStatus.inactive: 'غير نشط',
        RoleStatus.draft: 'مسودة',
        RoleStatus.deleted: 'محذوف',
      },
    };

    return translations[languageCode]?[this] ?? name;
  }

  // Quick access to localized name using current locale
  String get localizedName {
    String currentLang = Get.locale?.languageCode ?? 'en';
    return getLocalizedName(currentLang);
  }
}