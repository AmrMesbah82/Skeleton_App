import 'package:demo_app/features/roles/helper/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

import 'form_permissions.dart';
import 'results_permissions.dart';

enum FormPermissionsSections implements ModulePermissionsSections, ModulePermissionsSectionsPermission {
  formPermissions,
  resultsPermissions,
  createGroupPermissions;

  @override
  String get getName {
    switch (this) {
      case FormPermissionsSections.formPermissions:
        return AppConstanstForm.formPermissions.tr;
      case FormPermissionsSections.resultsPermissions:
        return AppConstanstForm.resultsPermissions.tr;
      case FormPermissionsSections.createGroupPermissions:
        return AppConstanstForm.createGroupPermissions.tr;
    }
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case FormPermissionsSections.formPermissions:
        return 'Form_Permissions_Module';
      case FormPermissionsSections.resultsPermissions:
        return 'Results_Permissions_Module';
      case FormPermissionsSections.createGroupPermissions:
        return 'Create_Group_Permissions_Module';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case FormPermissionsSections.formPermissions:
        return AppConstanstForm.formPermissionsModule.tr;
      case FormPermissionsSections.resultsPermissions:
        return AppConstanstForm.resultsPermissionsModule.tr;
      case FormPermissionsSections.createGroupPermissions:
        return AppConstanstForm.createGroupPermissionsModule.tr;
    }
  }

  @override
  bool get isChild {
    switch (this) {
      default:
        return false;
    }
  }

  @override
  List<Enum> get sectionPermissions {
    switch (this) {
      case FormPermissionsSections.formPermissions:
        return FormPermissions.values;
      case FormPermissionsSections.resultsPermissions:
        return ResultsPermissions.values;
      case FormPermissionsSections.createGroupPermissions:
        return [];
    }
  }

  static List<Enum> get firstColumnValues {
    return [
      formPermissions,
    ];
  }

  static List<Enum> get lastColumnValues {
    return [
      resultsPermissions,
      createGroupPermissions,
    ];
  }
}