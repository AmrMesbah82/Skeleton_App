/// Migration Utility for converting from RoleModel to RoleHistoryModel with multi-collection architecture
/// This utility helps migrate existing data to the new multi-collection permission structure

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:demo_app/core/network/failure_model.dart';
import 'package:demo_app/features/skeleton/roles/data/models/role_model.dart';
import 'package:demo_app/features/skeleton/roles/data/data_source/remote_data_source/role_remote_data_source.dart';
import 'package:demo_app/features/skeleton/roles/data/repository/role_repository.dart';

class RoleMigrationUtility {
  final RoleRemoteDataSource remoteDataSource = RoleRemoteDataSource();
  final RoleRepository roleRepository = RoleRepository();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Collection names for the new architecture
  static const String ROLES_COLLECTION = 'roles';
  static const String SERVICES_PERMISSIONS = 'services_module_permissions';
  static const String FORM_BUILDER_PERMISSIONS = 'form_builder_module_permissions';
  static const String MESSAGES_PERMISSIONS = 'messages_module_permissions';
  static const String INVENTORY_PERMISSIONS = 'inventory_module_permissions';
  static const String SETTINGS_PERMISSIONS = 'settings_module_permissions';
  static const String QIYAS_PERMISSIONS = 'qiyas_module_permissions';
  static const String KNOWLEDGE_HUB_PERMISSIONS = 'knowledge_hub_module_permissions';

  /// Method Name: migrateAllRolesToMultiCollection
  /// Purpose: Migrate all existing roles_module to the new multi-collection architecture
  Future<Either<Failure, String>> migrateAllRolesToMultiCollection() async {
    try {
      print("Starting migration to multi-collection architecture...");

      // Get all existing roles_module
      QuerySnapshot snapshot = await firestore.collection(ROLES_COLLECTION).get();

      int totalRoles = snapshot.docs.length;
      int migratedCount = 0;
      List<String> failedMigrations = [];

      print("Found $totalRoles roles_module to migrate");

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        try {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String roleId = doc.id;

          // Check if already migrated to new structure
          if (data.containsKey('Selected_Modules') && data['Selected_Modules'] is List) {
            print("Role $roleId already migrated to multi-collection, skipping...");
            continue;
          }

          // Convert old role to new structure
          await _migrateRoleToMultiCollection(roleId, data);
          migratedCount++;
          print("Migrated role: $roleId ($migratedCount/$totalRoles)");

        } catch (e) {
          print("Failed to migrate role ${doc.id}: $e");
          failedMigrations.add(doc.id);
        }
      }

      String result = "Multi-collection migration completed: $migratedCount/$totalRoles roles migrated successfully";
      if (failedMigrations.isNotEmpty) {
        result += "\nFailed migrations: ${failedMigrations.join(', ')}";
      }

      print(result);
      return Right(result);

    } catch (e) {
      print("Multi-collection migration failed: $e");
      return Left(FirebaseFailure("Multi-collection migration failed: $e"));
    }
  }

  /// Method Name: _migrateRoleToMultiCollection
  /// Purpose: Migrate a single role to multi-collection structure
  Future<void> _migrateRoleToMultiCollection(String roleId, Map<String, dynamic> oldData) async {
    WriteBatch batch = firestore.batch();

    try {
      // Parse old role model
      RoleModel legacyRole = RoleModel.fromMap(oldData);

      // Extract selected modules from granted permissions
      List<String> selectedModules = _extractSelectedModules(legacyRole);

      // Create new role document with core data only
      Map<String, dynamic> newRoleData = {
        'Role_Id': roleId,
        'Name': legacyRole.roleName ?? roleId,
        'Name_Ar': legacyRole.roleNameAr ?? '',
        'Description': legacyRole.roleDescription ?? '',
        'Description_Ar': legacyRole.roleDescriptionAr ?? '',
        'Image_Url': legacyRole.roleImage ?? '',
        'Selected_Modules': selectedModules,
        'Status': [legacyRole.status?.name ?? 'active'],
        'Created_At': [legacyRole.createdAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch],
        'Created_By': [legacyRole.createdBy ?? 'system'],
        'Edit_By': ['{"editorEmail": [], "timestamps": []}'],
        'timestamps': [DateTime.now().millisecondsSinceEpoch],
      };

      // Update role document
      DocumentReference roleRef = firestore.collection(ROLES_COLLECTION).doc(roleId);
      batch.update(roleRef, newRoleData);

      // Create permission documents for each selected module
      await _createPermissionDocuments(batch, roleId, selectedModules, legacyRole);

      // Commit all changes
      await batch.commit();
      print("Successfully migrated role $roleId to multi-collection structure");

    } catch (e) {
      print("Error migrating role $roleId: $e");
      throw e;
    }
  }

  /// Method Name: _extractSelectedModules
  /// Purpose: Extract modules that have granted permissions from legacy role
  List<String> _extractSelectedModules(RoleModel legacyRole) {
    List<String> selectedModules = [];

    if (legacyRole.employeeModule?.granted == true) selectedModules.add('employees');
    if (legacyRole.serviceModule?.granted == true) selectedModules.add('services');
    if (legacyRole.taskModule?.granted == true) selectedModules.add('tasks');
    if (legacyRole.todoModule?.granted == true) selectedModules.add('todo');
    if (legacyRole.eventModule?.granted == true) selectedModules.add('events');
    if (legacyRole.noteModule?.granted == true) selectedModules.add('notes');
    if (legacyRole.reqestModule?.granted == true) selectedModules.add('requests');
    if (legacyRole.knowledgeHubModule?.granted == true) selectedModules.add('knowledge_hub');
    if (legacyRole.dataGRCModule?.granted == true) selectedModules.add('qiyas');
    if (legacyRole.trackingModule?.granted == true) selectedModules.add('tracking');
    if (legacyRole.inventoryModule?.granted == true) selectedModules.add('inventory');
    if (legacyRole.messageModule?.granted == true) selectedModules.add('messages');
    if (legacyRole.databaseBuilderModule?.granted == true) selectedModules.add('database_builder');
    if (legacyRole.formBuilderModule?.granted == true) selectedModules.add('form_builder');
    if (legacyRole.roleModule?.granted == true) selectedModules.add('roles');

    return selectedModules;
  }

  /// Method Name: _createPermissionDocuments
  /// Purpose: Create permission documents in separate collections
  Future<void> _createPermissionDocuments(
      WriteBatch batch,
      String roleId,
      List<String> selectedModules,
      RoleModel legacyRole,
      ) async {
    for (String module in selectedModules) {
      String collectionName = _getPermissionCollectionName(module);
      if (collectionName.isNotEmpty) {
        DocumentReference permRef = firestore.collection(collectionName).doc(roleId);

        Map<String, dynamic> permissionData = {
          'Role_Id': roleId,
          'timestamps': [DateTime.now().millisecondsSinceEpoch],
        };

        // Extract permissions from legacy module
        Map<String, bool> modulePermissions = _extractModulePermissions(module, legacyRole);

        // Convert to history format (arrays)
        modulePermissions.forEach((key, value) {
          permissionData[key] = [value];
        });

        batch.set(permRef, permissionData);
        print("Creating permissions for module: $module with ${modulePermissions.length} permissions");
      }
    }
  }

  /// Method Name: _getPermissionCollectionName
  /// Purpose: Get the collection name for a specific module
  String _getPermissionCollectionName(String module) {
    switch (module.toLowerCase()) {
      case 'services':
        return SERVICES_PERMISSIONS;
      case 'form_builder':
        return FORM_BUILDER_PERMISSIONS;
      case 'messages':
        return MESSAGES_PERMISSIONS;
      case 'inventory':
        return INVENTORY_PERMISSIONS;
      case 'settings':
        return SETTINGS_PERMISSIONS;
      case 'qiyas':
      case 'grc':
        return QIYAS_PERMISSIONS;
      case 'knowledge_hub':
        return KNOWLEDGE_HUB_PERMISSIONS;
      default:
        return '';
    }
  }

  /// Method Name: _extractModulePermissions
  /// Purpose: Extract permissions from legacy module models
  Map<String, bool> _extractModulePermissions(String module, RoleModel legacyRole) {
    Map<String, bool> permissions = {};

    switch (module) {
      case 'services':
        if (legacyRole.serviceModule != null) {
          permissions = {
            'Create_Service': _getPermissionValue(legacyRole.serviceModule!, 'Create_Service'),
            'Edit_Service': _getPermissionValue(legacyRole.serviceModule!, 'Edit_Service'),
            'Delete_Service': _getPermissionValue(legacyRole.serviceModule!, 'Delete_Service'),
            'Bulk_Upload': _getPermissionValue(legacyRole.serviceModule!, 'Bulk_Upload'),
            'Export_Service': _getPermissionValue(legacyRole.serviceModule!, 'Export_Service'),
            'Admin_Dashboard': _getPermissionValue(legacyRole.serviceModule!, 'Admin_Dashboard'),
          };
        }
        break;
      case 'form_builder':
        if (legacyRole.formBuilderModule != null) {
          permissions = {
            'Create_New_Form': _getPermissionValue(legacyRole.formBuilderModule!, 'Create_New_Form'),
            'Edit_Form': _getPermissionValue(legacyRole.formBuilderModule!, 'Edit_Form'),
            'Delete_Form': _getPermissionValue(legacyRole.formBuilderModule!, 'Delete_Form'),
            'View_Submissions': _getPermissionValue(legacyRole.formBuilderModule!, 'View_Submissions'),
            'Export_Analytics_Data': _getPermissionValue(legacyRole.formBuilderModule!, 'Export_Analytics_Data'),
          };
        }
        break;
      case 'messages':
        if (legacyRole.messageModule != null) {
          permissions = {
            'Create_Group': _getPermissionValue(legacyRole.messageModule!, 'Create_Group'),
            'Edit_Message': _getPermissionValue(legacyRole.messageModule!, 'Edit_Message'),
            'Delete_Message': _getPermissionValue(legacyRole.messageModule!, 'Delete_Message'),
            'Forward_Messages': _getPermissionValue(legacyRole.messageModule!, 'Forward_Messages'),
          };
        }
        break;
      case 'inventory':
        if (legacyRole.inventoryModule != null) {
          permissions = {
            'Add_Product': _getPermissionValue(legacyRole.inventoryModule!, 'Add_Product'),
            'Edit_Product_Information': _getPermissionValue(legacyRole.inventoryModule!, 'Edit_Product_Information'),
            'View_Storage_Locations': _getPermissionValue(legacyRole.inventoryModule!, 'View_Storage_Locations'),
            'Create_Order': _getPermissionValue(legacyRole.inventoryModule!, 'Create_Order'),
          };
        }
        break;
      default:
      // Default permissions for modules without specific extraction logic
        permissions = {
          'View_Access': true,
          'Edit_Access': false,
        };
    }

    return permissions;
  }

  /// Helper method to get permission value from module
  bool _getPermissionValue(dynamic module, String permissionKey) {
    // This is a simplified extraction - you may need to enhance based on your ModulePermissionModel structure
    // For now, assume basic permissions based on whether module is granted
    if (module.granted == true) {
      return true; // Grant basic permissions if module is granted
    }
    return false;
  }

  /// Method Name: validateMultiCollectionMigration
  /// Purpose: Validate that multi-collection migration was successful
  Future<Either<Failure, Map<String, dynamic>>> validateMultiCollectionMigration() async {
    try {
      QuerySnapshot rolesSnapshot = await firestore.collection(ROLES_COLLECTION).get();

      int totalRoles = rolesSnapshot.docs.length;
      int migratedRoles = 0;
      int legacyRoles = 0;
      List<String> legacyRoleIds = [];
      List<String> invalidRoles = [];
      Map<String, int> permissionCollectionCounts = {};

      for (QueryDocumentSnapshot doc in rolesSnapshot.docs) {
        try {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (data.containsKey('Selected_Modules') && data['Selected_Modules'] is List) {
            migratedRoles++;

            // Check if permission documents exist
            List<String> selectedModules = List<String>.from(data['Selected_Modules']);
            for (String module in selectedModules) {
              String collectionName = _getPermissionCollectionName(module);
              if (collectionName.isNotEmpty) {
                DocumentSnapshot permDoc = await firestore.collection(collectionName).doc(doc.id).get();
                if (permDoc.exists) {
                  permissionCollectionCounts[collectionName] = (permissionCollectionCounts[collectionName] ?? 0) + 1;
                }
              }
            }
          } else {
            legacyRoles++;
            legacyRoleIds.add(doc.id);
          }
        } catch (e) {
          invalidRoles.add(doc.id);
        }
      }

      Map<String, dynamic> validationResult = {
        'totalRoles': totalRoles,
        'migratedRoles': migratedRoles,
        'legacyRoles': legacyRoles,
        'invalidRoles': invalidRoles.length,
        'legacyRoleIds': legacyRoleIds,
        'invalidRoleIds': invalidRoles,
        'permissionCollectionCounts': permissionCollectionCounts,
        'migrationComplete': legacyRoles == 0 && invalidRoles.isEmpty,
      };

      return Right(validationResult);

    } catch (e) {
      return Left(FirebaseFailure("Multi-collection validation failed: $e"));
    }
  }

  /// Method Name: cleanupLegacyFields
  /// Purpose: Remove legacy permission fields from role documents
  Future<Either<Failure, String>> cleanupLegacyFields() async {
    try {
      QuerySnapshot snapshot = await firestore.collection(ROLES_COLLECTION).get();
      WriteBatch batch = firestore.batch();
      int cleanedCount = 0;

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // List of legacy fields to remove
        List<String> legacyFields = [
          'Employee_Module_Granted',
          'Service_Module_Granted',
          'Task_Module_Granted',
          'Todo_Module_Granted',
          'Event_Module_Granted',
          'Note_Module_Granted',
          'Request_Module_Granted',
          'Knowledge_Hub_Module_Granted',
          'Data_GRC_Module_Granted',
          'Tracking_Module_Granted',
          'Inventory_Module_Granted',
          'Message_Module_Granted',
          'Database_Builder_Module_Granted',
          'Form_Builder_Module_Granted',
          'Role_Module_Granted',
          // Add any other legacy permission fields
        ];

        Map<String, dynamic> updates = {};
        bool hasLegacyFields = false;

        for (String field in legacyFields) {
          if (data.containsKey(field)) {
            updates[field] = FieldValue.delete();
            hasLegacyFields = true;
          }
        }

        if (hasLegacyFields) {
          batch.update(doc.reference, updates);
          cleanedCount++;
        }
      }

      if (cleanedCount > 0) {
        await batch.commit();
      }

      return Right("Cleaned up legacy fields from $cleanedCount roles");

    } catch (e) {
      return Left(FirebaseFailure("Legacy cleanup failed: $e"));
    }
  }

  /// Method Name: generateMultiCollectionReport
  /// Purpose: Generate detailed report for multi-collection migration
  Future<Map<String, dynamic>> generateMultiCollectionReport() async {
    Either<Failure, Map<String, dynamic>> validationResult = await validateMultiCollectionMigration();

    if (validationResult.isLeft()) {
      return {
        'error': validationResult.fold((l) => l.errMessage, (r) => ''),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }

    Map<String, dynamic> validation = validationResult.getOrElse(() => {});

    return {
      'migrationReport': validation,
      'recommendations': _generateMultiCollectionRecommendations(validation),
      'timestamp': DateTime.now().toIso8601String(),
      'architecture': 'multi-collection',
    };
  }

  List<String> _generateMultiCollectionRecommendations(Map<String, dynamic> validation) {
    List<String> recommendations = [];

    if (validation['legacyRoles'] > 0) {
      recommendations.add("${validation['legacyRoles']} roles_module still need migration to multi-collection structure");
    }

    if (validation['invalidRoles'] > 0) {
      recommendations.add("${validation['invalidRoles']} roles_module have data issues that need manual review");
    }

    if (validation['migrationComplete'] == true) {
      recommendations.add("Multi-collection migration completed successfully");
      recommendations.add("Consider running legacy field cleanup");
      recommendations.add("Verify all permission collections have expected data");
    }

    Map<String, int> permissionCounts = validation['permissionCollectionCounts'] ?? {};
    if (permissionCounts.isNotEmpty) {
      recommendations.add("Permission documents created in ${permissionCounts.length} collections");
    }

    return recommendations;
  }

  /// Method Name: rollbackToLegacyStructure
  /// Purpose: Rollback from multi-collection to legacy structure (emergency use)
  Future<Either<Failure, String>> rollbackToLegacyStructure(String backupCollectionName) async {
    try {
      print("WARNING: Rolling back to legacy structure from backup: $backupCollectionName");

      QuerySnapshot backupSnapshot = await firestore.collection(backupCollectionName).get();

      if (backupSnapshot.docs.isEmpty) {
        return Left(FirebaseFailure("Backup collection $backupCollectionName not found or empty"));
      }

      WriteBatch batch = firestore.batch();

      // Restore roles_module from backup
      for (QueryDocumentSnapshot doc in backupSnapshot.docs) {
        DocumentReference roleRef = firestore.collection(ROLES_COLLECTION).doc(doc.id);
        batch.set(roleRef, doc.data());
      }

      await batch.commit();

      // Note: This doesn't delete the permission collections - they can be cleaned up separately if needed
      return Right("Rollback completed from backup: $backupCollectionName");

    } catch (e) {
      return Left(FirebaseFailure("Rollback failed: $e"));
    }
  }
}