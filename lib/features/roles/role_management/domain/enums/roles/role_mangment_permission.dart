import 'package:demo_app/core/helper_module/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

enum RoleManagement implements ModulePermissionsSectionsPermission {
  createRoleManagement,
  editRole,
  deleteRole,
  changeRoleStatus,
  exportRoleData;

  @override
  bool get isChild {
    switch (this) {
      default:
        return false;
    }
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case createRoleManagement:
        return 'Create_Role_Management';
      case editRole:
        return 'Edit_Role';
      case deleteRole:
        return 'Delete_Role';
      case changeRoleStatus:
        return 'Change_Role_Status';
      case exportRoleData:
        return 'Export_Role_Data';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case createRoleManagement:
        return AppConstanstForm.createRoleManagement.tr;
      case editRole:
        return AppConstanstForm.editRole.tr;
      case deleteRole:
        return AppConstanstForm.deleteRole.tr;
      case changeRoleStatus:
        return AppConstanstForm.changeRoleStatus.tr;
      case exportRoleData:
        return AppConstanstForm.exportRoleData.tr;
    }
  }
}