import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/roles/domain/interfaces/module_permissions_sections_permissions.dart';

enum NotificationPermissions implements ModulePermissionsSectionsPermission {
  showEmployeesNotifications,
  showServicesNotifications,
  showTasksNotifications,
  showTodoNotifications,
  showEventsNotifications,
  showNotesNotifications,
  showRequestsNotifications,
  showKnowledgeHubNotifications,
  showQiyasNotifications,
  showTrackingNotifications,
  showInventoryNotifications,
  showMessagesNotifications,
  showDatabaseNotifications,
  showFormBuilderNotifications,
  showRolesNotifications,
  showSettingsNotifications,
  showGRCNotifications,
  showHRNotifications;

  @override
  bool get isChild {
    return false;
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case showEmployeesNotifications:
        return 'Show_Employees_Notifications';
      case showServicesNotifications:
        return 'Show_Services_Notifications';
      case showTasksNotifications:
        return 'Show_Tasks_Notifications';
      case showTodoNotifications:
        return 'Show_Todo_Notifications';
      case showEventsNotifications:
        return 'Show_Events_Notifications';
      case showNotesNotifications:
        return 'Show_Notes_Notifications';
      case showRequestsNotifications:
        return 'Show_Requests_Notifications';
      case showKnowledgeHubNotifications:
        return 'Show_Knowledge_Hub_Notifications';
      case showQiyasNotifications:
        return 'Show_Qiyas_Notifications';
      case showTrackingNotifications:
        return 'Show_Tracking_Notifications';
      case showInventoryNotifications:
        return 'Show_Inventory_Notifications';
      case showMessagesNotifications:
        return 'Show_Messages_Notifications';
      case showDatabaseNotifications:
        return 'Show_Database_Notifications';
      case showFormBuilderNotifications:
        return 'Show_Form_Builder_Notifications';
      case showRolesNotifications:
        return 'Show_Roles_Notifications';
      case showSettingsNotifications:
        return 'Show_Settings_Notifications';
      case showGRCNotifications:
        return 'Show_GRC_Notifications';
      case showHRNotifications:
        return 'Show_HR_Notifications';
    }
  }

  @override
  String get getUiName {
    bool isArabic = Get.locale?.languageCode == 'ar';

    switch (this) {
      case showEmployeesNotifications:
        return isArabic ? 'إظهار إشعارات الموظفين' : 'Show Employees Notifications';
      case showServicesNotifications:
        return isArabic ? 'إظهار إشعارات الخدمات' : 'Show Services Notifications';
      case showTasksNotifications:
        return isArabic ? 'إظهار إشعارات المهام' : 'Show Tasks Notifications';
      case showTodoNotifications:
        return isArabic ? 'إظهار إشعارات المهام السريعة' : 'Show Todo Notifications';
      case showEventsNotifications:
        return isArabic ? 'إظهار إشعارات الأحداث' : 'Show Events Notifications';
      case showNotesNotifications:
        return isArabic ? 'إظهار إشعارات الملاحظات' : 'Show Notes Notifications';
      case showRequestsNotifications:
        return isArabic ? 'إظهار إشعارات الطلبات' : 'Show Requests Notifications';
      case showKnowledgeHubNotifications:
        return isArabic ? 'إظهار إشعارات مركز المعرفة' : 'Show Knowledge Hub Notifications';
      case showQiyasNotifications:
        return isArabic ? 'إظهار إشعارات القياس' : 'Show Qiyas Notifications';
      case showTrackingNotifications:
        return isArabic ? 'إظهار إشعارات التتبع' : 'Show Tracking Notifications';
      case showInventoryNotifications:
        return isArabic ? 'إظهار إشعارات المخزون' : 'Show Inventory Notifications';
      case showMessagesNotifications:
        return isArabic ? 'إظهار إشعارات الرسائل' : 'Show Messages Notifications';
      case showDatabaseNotifications:
        return isArabic ? 'إظهار إشعارات قاعدة البيانات' : 'Show Database Notifications';
      case showFormBuilderNotifications:
        return isArabic ? 'إظهار إشعارات مُنشئ النماذج' : 'Show Form Builder Notifications';
      case showRolesNotifications:
        return isArabic ? 'إظهار إشعارات الأدوار' : 'Show Roles Notifications';
      case showSettingsNotifications:
        return isArabic ? 'إظهار إشعارات الإعدادات' : 'Show Settings Notifications';
      case showGRCNotifications:
        return isArabic ? 'إظهار إشعارات الحوكمة والامتثال' : 'Show GRC Notifications';
      case showHRNotifications:
        return isArabic ? 'إظهار إشعارات الموارد البشرية' : 'Show HR Notifications';
    }
  }
}