import 'package:demo_app/core/helper_module/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/knowledge/submissions_permissions_enum.dart';

import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/inventory/approval_permissions.dart';
import 'knowledge_hub_permissions_enum.dart';

enum KnowledgeHubPermissionsSections implements ModulePermissionsSections, ModulePermissionsSectionsPermission {
  knowledgeHubPermissions,
  submissions,
  approval,
  dashboard,
  allowsRemovingDocumentsOwnedByAnyone;

  @override
  String get getName {
    switch (this) {
      case KnowledgeHubPermissionsSections.knowledgeHubPermissions:
        return AppConstanstForm.knowledgeHubPermissions.tr;
      case KnowledgeHubPermissionsSections.submissions:
        return AppConstanstForm.submissions.tr;
      case KnowledgeHubPermissionsSections.approval:
        return AppConstanstForm.approval.tr;
      case KnowledgeHubPermissionsSections.dashboard:
        return AppConstanstForm.dashboard.tr;
      case KnowledgeHubPermissionsSections.allowsRemovingDocumentsOwnedByAnyone:
        return AppConstanstForm.allowsRemovingDocumentsOwnedByAnyone.tr;
    }
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case KnowledgeHubPermissionsSections.knowledgeHubPermissions:
        return 'Knowledge_Hub_Permissions';
      case KnowledgeHubPermissionsSections.submissions:
        return 'Submissions';
      case KnowledgeHubPermissionsSections.approval:
        return 'Approval';
      case KnowledgeHubPermissionsSections.dashboard:
        return 'Dashboard';
      case KnowledgeHubPermissionsSections.allowsRemovingDocumentsOwnedByAnyone:
        return 'Allows_Removing_Documents_Owned_By_Anyone';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case KnowledgeHubPermissionsSections.knowledgeHubPermissions:
        return AppConstanstForm.knowledgeHubPermissions.tr;
      case KnowledgeHubPermissionsSections.submissions:
        return AppConstanstForm.submissions.tr;
      case KnowledgeHubPermissionsSections.approval:
        return AppConstanstForm.approval.tr;
      case KnowledgeHubPermissionsSections.dashboard:
        return AppConstanstForm.dashboard.tr;
      case KnowledgeHubPermissionsSections.allowsRemovingDocumentsOwnedByAnyone:
        return AppConstanstForm.allowsRemovingDocumentsOwnedByAnyone.tr;
    }
  }

  @override
  bool get isChild {
    return false;
  }

  @override
  List<Enum> get sectionPermissions {
    switch (this) {
      case KnowledgeHubPermissionsSections.knowledgeHubPermissions:
        return KnowledgeHubPermissions.values;
      case KnowledgeHubPermissionsSections.submissions:
        return SubmissionsPermissions.values;
      case KnowledgeHubPermissionsSections.approval:
        return ApprovalPermissions.values;
      default:
        return [];
    }
  }

  static List<Enum> get firstColumnValues {
    return [
      KnowledgeHubPermissionsSections.knowledgeHubPermissions,
      KnowledgeHubPermissionsSections.allowsRemovingDocumentsOwnedByAnyone,
    ];
  }

  static List<Enum> get lastColumnValues {
    return [
      KnowledgeHubPermissionsSections.submissions,
      KnowledgeHubPermissionsSections.approval,
      KnowledgeHubPermissionsSections.dashboard,
    ];
  }
}