import 'package:demo_app/core/helper_module/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/request_service_permission.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/service_permissions.dart';

import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';
import 'Employee_services.dart';
import 'approval_permission_work.dart';
import 'dashboard_permissions.dart';

enum ServicePermissionsSections implements ModulePermissionsSections, ModulePermissionsSectionsPermission {
  servicesPermissions,
  requestServicePermissions,
  dashboardPermissions,
  approvalPermissions,
  requestedServices;

  @override
  String get getName {
    switch (this) {
      case ServicePermissionsSections.servicesPermissions:
        return AppConstanstForm.servicesPermissions.tr;
      case ServicePermissionsSections.requestServicePermissions:
        return AppConstanstForm.requestServicePermissions.tr;
      case ServicePermissionsSections.dashboardPermissions:
        return AppConstanstForm.dashboardPermissions.tr;
      case ServicePermissionsSections.approvalPermissions:
        return AppConstanstForm.approvalPermissions.tr;
      case ServicePermissionsSections.requestedServices:
        return AppConstanstForm.requestedServices.tr;
    }
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case ServicePermissionsSections.servicesPermissions:
        return 'Services_Permissions_Module';
      case ServicePermissionsSections.requestServicePermissions:
        return 'Request_Service_Permissions_Module';
      case ServicePermissionsSections.dashboardPermissions:
        return 'Dashboard_Permissions_Module';
      case ServicePermissionsSections.approvalPermissions:
        return 'Approval_Permissions_Module';
      case ServicePermissionsSections.requestedServices:
        return 'Requested_Services_Module';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case ServicePermissionsSections.servicesPermissions:
        return AppConstanstForm.servicesPermissionsModule.tr;
      case ServicePermissionsSections.requestServicePermissions:
        return AppConstanstForm.requestServicePermissionsModule.tr;
      case ServicePermissionsSections.dashboardPermissions:
        return AppConstanstForm.dashboardPermissionsModule.tr;
      case ServicePermissionsSections.approvalPermissions:
        return AppConstanstForm.approvalPermissionsModule.tr;
      case ServicePermissionsSections.requestedServices:
        return AppConstanstForm.requestedServicesModule.tr;
    }
  }

  @override
  bool get isChild {
    switch (this) {
      default:
        return false;
    }
  }

  @override
  List<Enum> get sectionPermissions {
    switch (this) {
      case ServicePermissionsSections.servicesPermissions:
        return ServicePermissions.values;
      case ServicePermissionsSections.requestServicePermissions:
        return RequestServicePermission.values;
      case ServicePermissionsSections.dashboardPermissions:
        return DashboardPermissions.values;
      case ServicePermissionsSections.approvalPermissions:
        return ApprovalPermissionsServices.values;
      case ServicePermissionsSections.requestedServices:
        return RequestServicesModule.values;
    }
  }

  static List<Enum> get lastColumnValues {
    return [
      requestServicePermissions,
      dashboardPermissions,
      approvalPermissions,
      requestedServices
    ];
  }

  static List<Enum> get firstColumnValues {
    return [
      servicesPermissions,
    ];
  }
}