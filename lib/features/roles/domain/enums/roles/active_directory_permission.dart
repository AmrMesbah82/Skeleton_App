import 'package:get/get.dart';

import '../../../../form_builder_module/core/constants/strings.dart';
import '../../interfaces/module_permissions_sections_permissions.dart';

enum ActiveDirectory implements ModulePermissionsSectionsPermission {
  uploadDocument,
  restoreData,
  exportData,
  editUploadedDocument,
  removeEmployee;

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
      case uploadDocument:
        return 'Upload_Document';
      case restoreData:
        return 'Restore_Data';
      case exportData:
        return 'Export_Data';
      case editUploadedDocument:
        return 'Edit_Uploaded_Document';
      case removeEmployee:
        return 'Remove_Employee';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case uploadDocument:
        return AppConstanstForm.uploadDocument.tr;  // ✅ With translation
      case restoreData:
        return AppConstanstForm.restoreData.tr;  // ✅ With translation
      case exportData:
        return AppConstanstForm.exportData.tr;  // ✅ With translation
      case editUploadedDocument:
        return AppConstanstForm.editUploadedDocument.tr;  // ✅ With translation
      case removeEmployee:
        return AppConstanstForm.removeEmployee.tr;  // ✅ With translation
    }
  }

}