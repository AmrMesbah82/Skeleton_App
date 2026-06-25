/******************** FILE INFO ********************/
/// File Name: settings_permissions.dart
/// Purpose: Enum for Settings Permissions in the application
/// Created by: Mohamed Elrashidy
/// Created on: 3/9/2025
/// Updated: Added debug logging to find translation issue

import 'package:demo_app/features/roles/helper/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';

import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

enum SettingsPermissions implements ModulePermissionsSectionsPermission {
  takeScreenShot,
  restrictedLocation,
  companyInformation,
  animation,
  biometricsForLogin,
  branding,
  screenShare;

  @override
  String get getDataBaseName {
    switch (this) {
      case takeScreenShot:
        return 'Take_Screen_Shot';

      case biometricsForLogin:
        return 'Biometrics_For_Login';

      case restrictedLocation:
        return 'Restricted_Location';

      case companyInformation:
        return 'Company_Information';

      case animation:
        return 'Animation';

      case branding:
        return 'Branding';

      case screenShare:
        return 'Screen_Share';
    }
  }

  @override
  String get getUiName {
    String result;

    switch (this) {
      case takeScreenShot:
        result = AppConstanstForm.takeScreenShot.tr;
        break;

      case biometricsForLogin:
        result = AppConstanstForm.biometricsForLogin.tr;
        break;

      case restrictedLocation:
        result = AppConstanstForm.restrictedLocation.tr;
        break;

      case companyInformation:
        result = AppConstanstForm.companyInformation.tr;
        break;

      case animation:
        result = AppConstanstForm.animation.tr;
        break;

      case branding:
        result = AppConstanstForm.branding.tr;
        break;

      case screenShare:
        result = AppConstanstForm.screenShare.tr;
        break;
    }

    return result;
  }

  @override
  bool get isChild {
    return false;
  }
}