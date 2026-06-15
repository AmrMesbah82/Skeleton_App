import 'package:demo_app/features/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/domain/interfaces/module_permissions_sections_permissions.dart';

// Knowledge Hub Permissions Enum
enum KnowledgeHubPermissions implements ModulePermissionsSectionsPermission {
  createKnowledgeHub,
  selectOwningDepartment,
  downloadDocuments,
  viewDocuments,
  analytics,
  statistics,
  inquiriesAndComments,
  allowsRemovingDocumentsOwnedByAnyone;

  @override
  bool get isChild {
    return false;
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case createKnowledgeHub:
        return 'Create_Knowledge_Hub';
      case selectOwningDepartment:
        return 'Select_Owning_Department';
      case downloadDocuments:
        return 'Download_Documents';
      case viewDocuments:
        return 'View_Documents';
      case analytics:
        return 'Analytics';
      case statistics:
        return 'Statistics';
      case inquiriesAndComments:
        return 'Inquiries_and_Comments';
      case allowsRemovingDocumentsOwnedByAnyone:
        return 'Allows_Removing_Documents_Owned_By_Anyone';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case createKnowledgeHub:
        return AppConstanstForm.createKnowledgeHub.tr;
      case selectOwningDepartment:
        return AppConstanstForm.selectOwningDepartment.tr;
      case downloadDocuments:
        return AppConstanstForm.downloadDocuments.tr;
      case viewDocuments:
        return AppConstanstForm.viewDocuments.tr;
      case analytics:
        return AppConstanstForm.analytics.tr;
      case statistics:
        return AppConstanstForm.statistics.tr;
      case inquiriesAndComments:
        return AppConstanstForm.inquiriesAndComments.tr;
      case allowsRemovingDocumentsOwnedByAnyone:
        return AppConstanstForm.allowsRemovingDocumentsOwnedByAnyone.tr;
    }
  }
}