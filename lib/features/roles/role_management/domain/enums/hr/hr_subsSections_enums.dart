import 'package:demo_app/core/helper_module/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/knowledge/submissions_permissions_enum.dart';

import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/inventory/approval_permissions.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/knowledge/knowledge_hub_permissions_enum.dart';

enum HRPermissionsSections implements ModulePermissionsSections, ModulePermissionsSectionsPermission {
  knowledgeHubPermissions,
  submissions,
  approval,
  dashboard,
  allowsRemovingDocumentsOwnedByAnyone;

  @override
  String get getName {
    switch (this) {
      case HRPermissionsSections.knowledgeHubPermissions:
        return AppConstanstForm.knowledgeHubPermissions.tr;
      case HRPermissionsSections.submissions:
        return AppConstanstForm.submissions.tr;
      case HRPermissionsSections.approval:
        return AppConstanstForm.approval.tr;
      case HRPermissionsSections.dashboard:
        return AppConstanstForm.dashboard.tr;
      case HRPermissionsSections.allowsRemovingDocumentsOwnedByAnyone:
        return AppConstanstForm.allowsRemovingDocumentsOwnedByAnyone.tr;
    }
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case HRPermissionsSections.knowledgeHubPermissions:
        return 'Knowledge_Hub_Permissions';
      case HRPermissionsSections.submissions:
        return 'Submissions';
      case HRPermissionsSections.approval:
        return 'Approval';
      case HRPermissionsSections.dashboard:
        return 'Dashboard';
      case HRPermissionsSections.allowsRemovingDocumentsOwnedByAnyone:
        return 'Allows_Removing_Documents_Owned_By_Anyone';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case HRPermissionsSections.knowledgeHubPermissions:
        return AppConstanstForm.knowledgeHubPermissions.tr;
      case HRPermissionsSections.submissions:
        return AppConstanstForm.submissions.tr;
      case HRPermissionsSections.approval:
        return AppConstanstForm.approval.tr;
      case HRPermissionsSections.dashboard:
        return AppConstanstForm.dashboard.tr;
      case HRPermissionsSections.allowsRemovingDocumentsOwnedByAnyone:
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
      case HRPermissionsSections.knowledgeHubPermissions:
        return KnowledgeHubPermissions.values;
      case HRPermissionsSections.submissions:
        return SubmissionsPermissions.values;
      case HRPermissionsSections.approval:
        return ApprovalPermissions.values;
      default:
        return [];
    }
  }

  static List<Enum> get firstColumnValues {
    return [
      HRPermissionsSections.knowledgeHubPermissions,
      HRPermissionsSections.allowsRemovingDocumentsOwnedByAnyone,
    ];
  }

  static List<Enum> get lastColumnValues {
    return [
      HRPermissionsSections.submissions,
      HRPermissionsSections.approval,
      HRPermissionsSections.dashboard,
    ];
  }
}