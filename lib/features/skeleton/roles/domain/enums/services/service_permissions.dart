import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/constants/strings.dart';
import '../../interfaces/module_permissions_sections_permissions.dart';

enum ServicePermissions implements ModulePermissionsSectionsPermission {
  createService,
  bulkUpload,
  exportService,
  editService,
  deleteService,
  changeServiceStatus,
  viewRequesters,
  exportRequestedServices;

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
      case createService:
        return 'Create_Service';
      case bulkUpload:
        return 'Bulk_Upload';
      case exportService:
        return 'Export_Service';
      case editService:
        return 'Edit_Service';
      case deleteService:
        return 'Delete_Service';
      case changeServiceStatus:
        return 'Change_Service_Status';
      case viewRequesters:
        return 'View_Requesters';
      case exportRequestedServices:
        return 'Export_Requested_Services';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case createService:
        return AppConstanstForm.createService.tr;
      case bulkUpload:
        return AppConstanstForm.bulkUpload.tr;
      case exportService:
        return AppConstanstForm.exportService.tr;
      case editService:
        return AppConstanstForm.editService.tr;
      case deleteService:
        return AppConstanstForm.deleteService.tr;
      case changeServiceStatus:
        return AppConstanstForm.changeServiceStatus.tr;
      case viewRequesters:
        return AppConstanstForm.viewRequesters.tr;
      case exportRequestedServices:
        return AppConstanstForm.exportRequestedServices.tr;
    }
  }
}