import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import '../../interfaces/module_permissions_sections_permissions.dart';

enum MessagesMorePermissions implements ModulePermissionsSectionsPermission {
  contact,
  location,
  photo,
  documents,
  poll,
  muteNotifications,
  disappearingMessages,
  scheduleMessages;

  @override
  bool get isChild => false;

  @override
  String get getDataBaseName {
    switch (this) {
      case contact:
        return 'Contact';
      case location:
        return 'Location';
      case photo:
        return 'Photo';
      case documents:
        return 'Documents';
      case poll:
        return 'Poll';
      case muteNotifications:
        return 'Mute_Notifications';
      case disappearingMessages:
        return 'Disappearing_Messages';
      case scheduleMessages:
        return 'Schedule_Messages';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case contact:
        return AppConstanstForm.contact.tr;
      case location:
        return AppConstanstForm.location.tr;
      case photo:
        return AppConstanstForm.photo.tr;
      case documents:
        return AppConstanstForm.downloadDocuments.tr;
      case poll:
        return AppConstanstForm.poll.tr;
      case muteNotifications:
        return AppConstanstForm.muteNotifications.tr;
      case disappearingMessages:
        return AppConstanstForm.disappearingMessages.tr;
      case scheduleMessages:
        return AppConstanstForm.scheduleMessages.tr;
    }
  }
}