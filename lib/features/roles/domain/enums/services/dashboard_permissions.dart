import 'package:demo_app/features/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/domain/interfaces/module_permissions_sections_permissions.dart';

enum DashboardPermissions implements ModulePermissionsSectionsPermission {
  adminDashboard,
  departmentDashboard;

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
      case adminDashboard:
        return 'Admin_Dashboard';
      case departmentDashboard:
        return 'Department_Dashboard';
      default:
        return '';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case adminDashboard:
        return AppConstanstForm.adminDashboard.tr;
      case departmentDashboard:
        return AppConstanstForm.departmentDashboard.tr;
      default:
        return '';
    }
  }
}