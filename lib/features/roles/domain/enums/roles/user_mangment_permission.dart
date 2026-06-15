import 'package:demo_app/features/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import '../../interfaces/module_permissions_sections_permissions.dart';

enum UserManagement implements ModulePermissionsSectionsPermission {
  giveAccess,
  editAccess,
  removeAccess,
  importUsersData,
  exportUsersData,
  usersRequests,
  approvedAndRejectedRequest,
  approvedOnly;

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
      case giveAccess:
        return 'Give_Access';
      case editAccess:
        return 'Edit_Access';
      case removeAccess:
        return 'Remove_Access';
      case importUsersData:
        return 'Import_Users_Data';
      case exportUsersData:
        return 'Export_Users_Data';
      case usersRequests:
        return 'Users_Requests';
      case approvedAndRejectedRequest:
        return 'Approved_And_Rejected_Request';
      case approvedOnly:
        return 'Approved_Only';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case giveAccess:
        return AppConstanstForm.giveAccess.tr;
      case editAccess:
        return AppConstanstForm.editAccess.tr;
      case removeAccess:
        return AppConstanstForm.removeAccess.tr;
      case importUsersData:
        return AppConstanstForm.importUsersData.tr;
      case exportUsersData:
        return AppConstanstForm.exportUsersData.tr;
      case usersRequests:
        return AppConstanstForm.usersRequests.tr;
      case approvedAndRejectedRequest:
        return AppConstanstForm.approvedAndRejectedRequest.tr;
      case approvedOnly:
        return AppConstanstForm.approvedOnly.tr;
    }
  }
}