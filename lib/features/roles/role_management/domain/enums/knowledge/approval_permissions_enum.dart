import 'package:get/get.dart';
import 'package:demo_app/features/roles/helper/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

enum ApprovalPermissions implements ModulePermissionsSectionsPermission {
  approvedAndRejected,
  approvedOnly;

  @override
  bool get isChild {
    return false;
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case approvedAndRejected:
        return 'Approved_And_Rejected';
      case approvedOnly:
        return 'Approved_Only';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case approvedAndRejected:
        return AppConstanstForm.approvedAndRejected.tr;
      case approvedOnly:
        return AppConstanstForm.approvedOnly.tr;
    }
  }
}