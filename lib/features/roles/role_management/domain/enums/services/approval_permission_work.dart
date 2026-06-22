import 'package:demo_app/core/helper_module/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

enum ApprovalPermissionsServices implements ModulePermissionsSectionsPermission {
  approveAndReject;

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
      case approveAndReject:
        return 'Approve_And_Reject';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case approveAndReject:
        return AppConstanstForm.approveAndReject.tr;
    }
  }
}