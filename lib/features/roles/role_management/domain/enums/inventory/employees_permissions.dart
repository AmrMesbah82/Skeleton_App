import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

enum EmployeesPermissions implements ModulePermissionsSectionsPermission {
  addMaintenanceEmployee,
  assignProductToMaintenanceEmployees,
  addReceivingOfficer,
  addStockAuditorOfficer,
  addComplianceAndSafetyOfficer;

  @override
  bool get isChild {
    switch (this) {
      case assignProductToMaintenanceEmployees:
        return true;
      default:
        return false;
    }
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case addMaintenanceEmployee:
        return 'Add Maintenance Employee';
      case assignProductToMaintenanceEmployees:
        return 'Assign Product to Maintenance Employees';
      case addReceivingOfficer:
        return 'Add Receiving Officer';
      case addStockAuditorOfficer:
        return 'Add Stock Auditor Officer';
      case addComplianceAndSafetyOfficer:
        return 'Add Compliance and Safety Officer';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case addMaintenanceEmployee:
        return 'Add Maintenance Employee';
      case assignProductToMaintenanceEmployees:
        return 'Assign Product to Maintenance Employees';
      case addReceivingOfficer:
        return 'Add Receiving Officer';
      case addStockAuditorOfficer:
        return 'Add Stock Auditor Officer';
      case addComplianceAndSafetyOfficer:
        return 'Add Compliance and Safety Officer';
    }
  }
}
