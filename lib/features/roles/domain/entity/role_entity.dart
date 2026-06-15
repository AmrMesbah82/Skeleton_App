/*
/// ************************* FILE INFO *************************
/// File Name: role_entity.dart
/// purpose: Entity for Role in the application
/// Created by: Mohamed Elrashidy
/// Created on: 18/8/2025

import 'package:demo_app/features/roles_module/domain/enums/role_status.dart';

import '../../data/models/role_model.dart';
import 'module_permission_entity.dart';

class RoleEntity {
  String roleName;
  String roleDescription;
  String? roleImage;
  String createdBy;
  DateTime createdAt;
  RoleStatus status;
  List<ModulePermissionEntity> modulesPermissions;

  RoleEntity({
    required this.roleName,
    required this.roleDescription,
    this.roleImage,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.modulesPermissions,
  });

  factory RoleEntity.fromRoleModel(RoleModel model) {
    return RoleEntity(
        roleName: model.roleName!,
        roleDescription: model.roleDescription ?? "",
        roleImage: model.roleImage,
        status: model.status!,
        createdBy: model.createdBy!,
        createdAt: model.createdAt!.toDate(),
        modulesPermissions: getModulePermissions(model));
  }

  static List<ModulePermissionEntity> getModulePermissions(RoleModel model) {
    List<ModulePermissionEntity> modulePermissions = [];

    return modulePermissions;
  }
}
*/
