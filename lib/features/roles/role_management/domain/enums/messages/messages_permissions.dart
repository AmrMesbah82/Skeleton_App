import 'package:demo_app/core/helper_module/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

enum MessagesPermissions implements ModulePermissionsSectionsPermission {
  createGroup,
  seenAndUnseen,
  editMessage,
  deleteMessage,
  reactions,
  forwardMessage;

  @override
  bool get isChild => false;

  @override
  String get getDataBaseName {
    switch (this) {
      case createGroup:
        return 'Create_Group';
      case seenAndUnseen:
        return 'Seen_and_Unseen';
      case editMessage:
        return 'Edit_Message';
      case deleteMessage:
        return 'Delete_Message';
      case reactions:
        return 'Reactions';
      case forwardMessage:
        return 'Forward_Message';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case createGroup:
        return AppConstanstForm.createGroup.tr;
      case seenAndUnseen:
        return AppConstanstForm.seenAndUnseen.tr;
      case editMessage:
        return AppConstanstForm.editMessage.tr;
      case deleteMessage:
        return AppConstanstForm.deleteMessage.tr;
      case reactions:
        return AppConstanstForm.reactions.tr;
      case forwardMessage:
        return AppConstanstForm.forwardMessage.tr;
    }
  }
}