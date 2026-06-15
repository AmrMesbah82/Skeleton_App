import 'package:demo_app/features/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/domain/interfaces/module_permissions_sections_permissions.dart';

enum RequestServicesModule implements ModulePermissionsSectionsPermission {
  statusRequested;

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
      case statusRequested:
        return 'Status_Requested';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case statusRequested:
        return AppConstanstForm.statusRequested.tr;
    }
  }
}