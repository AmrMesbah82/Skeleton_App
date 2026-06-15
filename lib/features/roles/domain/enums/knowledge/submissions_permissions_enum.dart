import 'package:demo_app/features/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import '../../interfaces/module_permissions_sections_permissions.dart';

enum SubmissionsPermissions implements ModulePermissionsSectionsPermission {
  editDocumentWithApproval,
  editDocumentWithoutApproval,
  removeDocuments,
  exportStatisticsTable;

  @override
  bool get isChild {
    return false;
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case editDocumentWithApproval:
        return 'Edit_Document_With_Approval';
      case editDocumentWithoutApproval:
        return 'Edit_Document_Without_Approval';
      case removeDocuments:
        return 'Remove_Documents';
      case exportStatisticsTable:
        return 'Export_Statistics_Table';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case editDocumentWithApproval:
        return AppConstanstForm.editDocumentWithApproval.tr;
      case editDocumentWithoutApproval:
        return AppConstanstForm.editDocumentWithoutApproval.tr;
      case removeDocuments:
        return AppConstanstForm.removeDocuments.tr;
      case exportStatisticsTable:
        return AppConstanstForm.exportStatisticsTable.tr;
    }
  }
}