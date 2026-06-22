import 'package:demo_app/core/helper_module/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

enum RequestServicePermission implements ModulePermissionsSectionsPermission {
  requestService,
  cancelService;

  @override
  bool get isChild {
    return false;
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case requestService:
        return 'Request_Service';
      case cancelService:
        return 'Cancel_Service';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case requestService:
        return AppConstanstForm.requestService.tr;
      case cancelService:
        return AppConstanstForm.cancelService.tr;
    }
  }
}