import 'package:demo_app/features/roles/domain/interfaces/module_permissions_sections_permissions.dart';

enum StorageLocationsPermissions
    implements ModulePermissionsSectionsPermission {
  viewStorageLocations,
  addStorageLocation,
  editStorageLocation,
  deactivateStorageLocation,
  assignEmployees,
  changeTitles,
  transferBetweenLocations;

  @override
  bool get isChild {
    switch (this) {
      case changeTitles:
        return true;
      default:
        return false;
    }
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case viewStorageLocations:
        return 'View Storage Locations';
      case addStorageLocation:
        return 'Add Storage Location';
      case editStorageLocation:
        return 'Edit Storage Location';
      case deactivateStorageLocation:
        return 'Deactivate Storage Location';
      case assignEmployees:
        return 'Assign Employees';
      case changeTitles:
        return 'Change Titles';
      case transferBetweenLocations:
        return 'Transfer Between Locations';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case viewStorageLocations:
        return 'View Storage Locations';
      case addStorageLocation:
        return 'Add Storage Location';
      case editStorageLocation:
        return 'Edit Storage Location';
      case deactivateStorageLocation:
        return 'Deactivate Storage Location';
      case assignEmployees:
        return 'Assign Employees';
      case changeTitles:
        return 'Change Titles';
      case transferBetweenLocations:
        return 'Transfer Between Locations';
    }
  }
}
