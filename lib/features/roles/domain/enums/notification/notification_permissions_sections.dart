import 'package:get/get.dart';
import 'package:demo_app/features/roles/domain/interfaces/module_permissions_sections.dart';
import 'package:demo_app/features/roles/domain/interfaces/module_permissions_sections_permissions.dart';
import 'notification_permissions.dart';

enum NotificationPermissionsSections implements ModulePermissionsSections, ModulePermissionsSectionsPermission {
  notificationModule,
  viewOnly;

  @override
  String get getName {
    bool isArabic = Get.locale?.languageCode == 'ar';

    switch (this) {
      case NotificationPermissionsSections.notificationModule:
        return isArabic ? 'وحدة الإشعارات' : 'Notification Module';
      case NotificationPermissionsSections.viewOnly:
        return isArabic ? 'عرض فقط' : 'View Only';
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
    bool isArabic = Get.locale?.languageCode == 'ar';

    switch (this) {
      case NotificationPermissionsSections.notificationModule:
        return isArabic ? 'وحدة الإشعارات' : 'Notification Module';
      case NotificationPermissionsSections.viewOnly:
        return isArabic ? 'عرض فقط' : 'View Only';
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