///******************** FILE INFO ********************
/// File Name: module_permission_entity.dart
/// Purpose: Entity for Module Permissions in the application
/// Created by: Mohamed Elrashidy
/// Created on: 18/8/2025

import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

class ModulePermissionEntity {
  Modules module;
  List<ModulePermissionsSectionsEntity> sectionsPermissions;

  ModulePermissionEntity({
    required this.module,
    required this.sectionsPermissions,
  });
}

class ModulePermissionsSectionsEntity {
  ModulePermissionsSections sections;
  List<ModulePermissionsSectionsPermission> permissions;

  ModulePermissionsSectionsEntity({
    required this.sections,
    required this.permissions,
  });
}
