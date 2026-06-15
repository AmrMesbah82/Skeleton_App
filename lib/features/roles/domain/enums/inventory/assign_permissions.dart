import 'package:demo_app/features/roles/domain/interfaces/module_permissions_sections_permissions.dart';

enum AssignPermissions implements ModulePermissionsSectionsPermission {
  assignProductToEmployee,
  retrieveProduct,
  viewAssignedProduct;

  @override
  bool get isChild {
    return false;
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case assignProductToEmployee:
        return 'Assign Product To Employee';
      case retrieveProduct:
        return 'Retrieve Product';
      case viewAssignedProduct:
        return 'View Assigned Product';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case assignProductToEmployee:
        return 'Assign Product To Employee';
      case retrieveProduct:
        return 'Retrieve Product';
      case viewAssignedProduct:
        return 'View Assigned Product';
    }
  }
}
