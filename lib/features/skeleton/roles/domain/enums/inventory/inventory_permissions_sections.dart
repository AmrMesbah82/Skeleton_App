import '../../interfaces/module_permissions_sections.dart';
import 'approval_permissions.dart';
import 'assign_permissions.dart';
import 'edit_product_permissions.dart';
import 'employees_permissions.dart';
import 'orders_permissions.dart';
import 'product_permissions.dart';
import 'storage_locations_permissions.dart';
import 'supplier_permissions.dart';

enum InventoryPermissionsSections implements ModulePermissionsSections {
  productPermissions,
  editProductPermissions,
  ordersPermissions,
  assignPermissions,
  storageLocationsPermissions,
  supplierPermissions,
  employeesPermissions,
  approvalPermissions;

  @override
  // TODO: implement getName
  String get getName {
    switch (this) {
      case InventoryPermissionsSections.productPermissions:
        return 'Product Permissions';
      case InventoryPermissionsSections.editProductPermissions:
        return 'Edit Product Permissions';
      case InventoryPermissionsSections.ordersPermissions:
        return 'Orders Permissions';
      case InventoryPermissionsSections.assignPermissions:
        return 'Assign Permissions';
      case InventoryPermissionsSections.storageLocationsPermissions:
        return 'Storage Locations Permissions';
      case InventoryPermissionsSections.supplierPermissions:
        return 'Supplier Permissions';
      case InventoryPermissionsSections.employeesPermissions:
        return 'Employees Permissions';
      case InventoryPermissionsSections.approvalPermissions:
        return 'Approval Permissions';
      default:
        return '';
    }
  }

  @override
  // TODO: implement sectionPermissions
  List<Enum> get sectionPermissions {
    switch (this) {
      case InventoryPermissionsSections.productPermissions:
        return ProductPermissions.values;
      case InventoryPermissionsSections.editProductPermissions:
        return EditProductPermissions.values;
      case InventoryPermissionsSections.ordersPermissions:
        return OrdersPermissions.values;
      case InventoryPermissionsSections.assignPermissions:
        return AssignPermissions.values;
      case InventoryPermissionsSections.storageLocationsPermissions:
        return StorageLocationsPermissions.values;
      case InventoryPermissionsSections.supplierPermissions:
        return SupplierPermissions.values;
      case InventoryPermissionsSections.employeesPermissions:
        return EmployeesPermissions.values;
      case InventoryPermissionsSections.approvalPermissions:
        return ApprovalPermissions.values;
      default:
        return [];
    }
  }

  static List<Enum> get lastColumnValues {
    return [
      storageLocationsPermissions,
      supplierPermissions,
      employeesPermissions,
      approvalPermissions
    ];
  }

  static List<Enum> get firstColumnValues {
    return [
      productPermissions,
      editProductPermissions,
      ordersPermissions,
      assignPermissions,
    ];
  }
}
