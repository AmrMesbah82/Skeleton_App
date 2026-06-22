import 'package:demo_app/core/helper_module/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';

import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';
import 'notification_permissions.dart';

enum NotificationPermissionsSections implements ModulePermissionsSections, ModulePermissionsSectionsPermission {
  notificationModule,
  viewOnly;

  @override
  String get getName {
    switch (this) {
      case NotificationPermissionsSections.notificationModule:
        return AppConstanstForm.notificationModule.tr;
      case NotificationPermissionsSections.viewOnly:
        return AppConstanstForm.viewOnly.tr;
    }
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case NotificationPermissionsSections.notificationModule:
        return 'Notification_Module';
      case NotificationPermissionsSections.viewOnly:
        return 'View_Only';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case NotificationPermissionsSections.notificationModule:
        return AppConstanstForm.notificationModule.tr;
      case NotificationPermissionsSections.viewOnly:
        return AppConstanstForm.viewOnly.tr;
    }
  }

  @override
  bool get isChild {
    return false;
  }

  @override
  List<Enum> get sectionPermissions {
    switch (this) {
      case NotificationPermissionsSections.notificationModule:
        return NotificationPermissions.values;
      default:
        return [];
    }
  }

  static List<Enum> get firstColumnValues {
    return [
      NotificationPermissionsSections.notificationModule,
    ];
  }

  static List<Enum> get lastColumnValues {
    return [
      NotificationPermissionsSections.viewOnly,
    ];
  }
}