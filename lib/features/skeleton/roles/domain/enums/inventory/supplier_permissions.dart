import 'package:demo_app/features/skeleton/roles/domain/interfaces/module_permissions_sections_permissions.dart';

enum SupplierPermissions implements ModulePermissionsSectionsPermission {
  viewSuppliers,
  addSuppliers,
  editSuppliers,
  changeSupplierRank,
  supplierPurchaseHistory;

  @override
  bool get isChild {
    return false;
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case viewSuppliers:
        return 'View Suppliers';
      case addSuppliers:
        return 'Add Suppliers';
      case editSuppliers:
        return 'Edit Suppliers';
      case changeSupplierRank:
        return 'Change Supplier Rank';
      case supplierPurchaseHistory:
        return 'Supplier Purchase History';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case viewSuppliers:
        return 'View Suppliers';
      case addSuppliers:
        return 'Add Suppliers';
      case editSuppliers:
        return 'Edit Suppliers';
      case changeSupplierRank:
        return 'Change Supplier Rank';
      case supplierPurchaseHistory:
        return 'Supplier Purchase History';
    }
  }
}
