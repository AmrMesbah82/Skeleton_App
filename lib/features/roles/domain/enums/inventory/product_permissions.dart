import '../../interfaces/module_permissions_sections_permissions.dart';

enum ProductPermissions implements ModulePermissionsSectionsPermission {
  addProduct,
  bulkUpload,
  restock,
  existingBatch,
  newBatch,
  viewAllocatedProduct;

  @override
  bool get isChild {
    switch (this) {
      case ProductPermissions.existingBatch:
        return true;
      case ProductPermissions.newBatch:
        return true;
      default:
        return false;
    }
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case addProduct:
        return 'Add Product';
      case bulkUpload:
        return 'Bulk Upload';
      case restock:
        return 'Restock';
      case existingBatch:
        return 'Existing Batch';
      case newBatch:
        return 'New Batch';
      case viewAllocatedProduct:
        return 'View Allocated Product';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case addProduct:
        return 'Add Product';
      case bulkUpload:
        return 'Bulk Upload';
      case restock:
        return 'Restock';
      case existingBatch:
        return 'Existing Batch';
      case newBatch:
        return 'New Batch';
      case viewAllocatedProduct:
        return 'View Allocated Product';
    }
  }
}
