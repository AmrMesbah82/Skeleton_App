import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import '../../interfaces/module_permissions_sections_permissions.dart';

enum UserAccess implements ModulePermissionsSectionsPermission {
  reactiveUser,
  scheduleToReactivate,
  deactivateUser,
  scheduleToDeactivate,
  unlockUserAccount,
  changeDefaultPassword,
  changeExpirationDate;

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
      case reactiveUser:
        return 'Reactive_User';
      case scheduleToReactivate:
        return 'Schedule_To_Reactivate';
      case deactivateUser:
        return 'Deactivate_User';
      case scheduleToDeactivate:
        return 'Schedule_To_Deactivate';
      case unlockUserAccount:
        return 'Unlock_User_Account';
      case changeDefaultPassword:
        return 'Change_Default_Password';
      case changeExpirationDate:
        return 'Change_Expiration_Date';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case reactiveUser:
        return AppConstanstForm.reactiveUser.tr;
      case scheduleToReactivate:
        return AppConstanstForm.scheduleToReactivate.tr;
      case deactivateUser:
        return AppConstanstForm.deactivateUser.tr;
      case scheduleToDeactivate:
        return AppConstanstForm.scheduleToDeactivate.tr;
      case unlockUserAccount:
        return AppConstanstForm.unlockUserAccount.tr;
      case changeDefaultPassword:
        return AppConstanstForm.changeDefaultPassword.tr;
      case changeExpirationDate:
        return AppConstanstForm.changeExpirationDate.tr;
    }
  }
}