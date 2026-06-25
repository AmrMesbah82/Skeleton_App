import 'package:get/get.dart';
import 'package:demo_app/features/roles/helper/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

enum FormPermissions implements ModulePermissionsSectionsPermission {
  createNewForm,
  editForm,
  deleteForm,
  restoreForm,
  duplicateForm,
  convertToPdf,
  fillOutForm,
  share,
  editPermission;

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
      case createNewForm:
        return 'Create_New_Form';
      case editForm:
        return 'Edit_Form';
      case deleteForm:
        return 'Delete_Form';
      case duplicateForm:
        return 'Duplicate_Form';
      case convertToPdf:
        return 'Convert_to_PDF';
      case share:
        return 'Share';
      case restoreForm:
        return 'Restore_Form';
      case fillOutForm:
        return 'Fill_Out_Form';
      case editPermission:
        return 'Edit_Permission';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case createNewForm:
        return AppConstanstForm.createNewForm.tr;
      case editForm:
        return AppConstanstForm.editingForm.tr;
      case deleteForm:
        return AppConstanstForm.deleteForm.tr;
      case duplicateForm:
        return AppConstanstForm.duplicateForm.tr;
      case convertToPdf:
        return AppConstanstForm.convertToPdf.tr;
      case share:
        return AppConstanstForm.share.tr;
      case restoreForm:
        return AppConstanstForm.restoreForm.tr;
      case fillOutForm:
        return AppConstanstForm.fileOut.tr;
      case editPermission:
        return AppConstanstForm.editPresmission.tr;
    }
  }
}