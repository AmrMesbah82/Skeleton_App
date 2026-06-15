/******************** FILE INFO ********************/
/// File Name: settings_permissions_sections.dart
/// Purpose: Enum for Settings Permission Sections in the application
/// Created by: Mohamed Elrashidy
/// Updated: Fixed to use proper AppConstanstForm constants

import 'package:get/get.dart';

import '../../../../form_builder_module/core/constants/strings.dart';
import '../../interfaces/module_permissions_sections.dart';
import '../../interfaces/module_permissions_sections_permissions.dart';
import 'settings_permissions.dart';
import 'social_permissions.dart';

enum SettingsPermissionsSections implements ModulePermissionsSections, ModulePermissionsSectionsPermission {
  settings,
  socialPermissions;

  @override
  String get getName {
    switch (this) {
      case settings:
        return AppConstanstForm.settings.tr; // ✅ FIXED: Added .tr
      case socialPermissions:
        return AppConstanstForm.socialPermissions.tr; // ✅ FIXED: Added .tr
    }
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case settings:
        return 'Settings_Module';
      case socialPermissions:
        return 'Social_Permissions_Module';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case settings:
        return AppConstanstForm.settingsModule.tr;
      case socialPermissions:
        return AppConstanstForm.socialPermissionsModule.tr;
    }
  }

  @override
  bool get isChild {
    return false;
  }

  @override
  List<Enum> get sectionPermissions {
    switch (this) {
      case settings:
        return SettingsPermissions.values;
      case socialPermissions:
        return SocialPermissions.values;
    }
  }

  static List<Enum> get firstColumnValues {
    return [settings];
  }

  static List<Enum> get lastColumnValues {
    return [socialPermissions];
  }
}