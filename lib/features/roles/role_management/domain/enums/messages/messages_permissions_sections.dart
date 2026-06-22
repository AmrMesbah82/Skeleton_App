import 'package:demo_app/core/helper_module/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections.dart';
import 'messages_more_permissions.dart';
import 'messages_permissions.dart';

enum MessagesPermissionsSections implements ModulePermissionsSections {
  messagesPermissions,
  morePermissions;

  @override
  List<Enum> get sectionPermissions {
    switch (this) {
      case MessagesPermissionsSections.messagesPermissions:
        return MessagesPermissions.values;
      case MessagesPermissionsSections.morePermissions:
        return MessagesMorePermissions.values;
      default:
        return [];
    }
  }

  static List<Enum> get lastColumnValues => [morePermissions];
  static List<Enum> get firstColumnValues => [messagesPermissions];

  String get getName {
    switch (this) {
      case MessagesPermissionsSections.messagesPermissions:
        return AppConstanstForm.messagesPermissions.tr;
      case MessagesPermissionsSections.morePermissions:
        return AppConstanstForm.morePermissions.tr;
      default:
        return '';
    }
  }
}