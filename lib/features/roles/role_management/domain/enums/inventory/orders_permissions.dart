import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

enum OrdersPermissions implements ModulePermissionsSectionsPermission {
  createOrder,
  existingProduct,
  newProduct,
  viewOrdersHistory,
  changeOrderStatus,
  cancelOrder;

  @override
  bool get isChild {
    switch (this) {
      case OrdersPermissions.existingProduct:
        return true;
      case OrdersPermissions.newProduct:
        return true;
      default:
        return false;
    }
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case createOrder:
        return 'Create Order';
      case existingProduct:
        return 'Existing Product';
      case newProduct:
        return 'New Product';
      case viewOrdersHistory:
        return 'View Orders History';
      case changeOrderStatus:
        return 'Change Order Status';
      case cancelOrder:
        return 'Cancel Order';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case createOrder:
        return 'Create Order';
      case existingProduct:
        return 'Existing Product';
      case newProduct:
        return 'New Product';
      case viewOrdersHistory:
        return 'View Orders History';
      case changeOrderStatus:
        return 'Change Order Status';
      case cancelOrder:
        return 'Cancel Order';
    }
  }
}
