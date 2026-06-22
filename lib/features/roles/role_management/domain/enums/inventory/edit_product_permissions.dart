import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

enum EditProductPermissions implements ModulePermissionsSectionsPermission {
  editProductInformation,
  updateMaintenanceSchedule,
  inventoryAudit,
  temporarilyUnavailable,
  writeOff;

  @override
  bool get isChild {
    return false;
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case editProductInformation:
        return 'Edit Product Information';
      case updateMaintenanceSchedule:
        return 'Update Maintenance Schedule';
      case inventoryAudit:
        return 'Inventory Audit';
      case temporarilyUnavailable:
        return 'Temporarily Unavailable';
      case writeOff:
        return 'Write-Off';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case editProductInformation:
        return 'Edit Product Information';
      case updateMaintenanceSchedule:
        return 'Update Maintenance Schedule';
      case inventoryAudit:
        return 'Inventory Audit';
      case temporarilyUnavailable:
        return 'Temporarily Unavailable';
      case writeOff:
        return 'Write-Off';
    }
  }
}
