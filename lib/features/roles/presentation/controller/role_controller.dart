import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/enums/controller_request_current_state.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/failure_model.dart';
import '../../data/models/role_model.dart';
import '../../data/repository/role_repository.dart';
import '../../domain/enums/role_status.dart';

class RoleController extends GetxController with StateMixin {
  // general variables
  RoleRepository roleRepository = RoleRepository();
  FirebaseFirestore db = FirebaseFirestore.instance;
  // FIXED: Added roleId parameter (using empty string for temporary/new roles_module)
  Rx<RoleHistoryModel> accessType = RoleHistoryModel.createNew(
    roleId: '', // Temporary ID for new roles_module - will be replaced when saved
  ).obs;
  List<RoleHistoryModel> accessTypeList = [];
  RoleHistoryModel? accessTypeByName;
  Rx<ControllerRequestCurrentState> requestCurrentState =
      ControllerRequestCurrentState.none.obs;

  // edit role variables
  int editRoleSelectedTabIndex = 0;
  RoleHistoryModel? selectedRole;

  // users permissions variables
  updateEditRoleSelectedTabIndex(int index) {
    editRoleSelectedTabIndex = index;
    update();
  }

  Future addRole(RoleHistoryModel accessType) async {
    // Implementation for adding role
    requestCurrentState.value = ControllerRequestCurrentState.loading;
    // Add role logic here
    requestCurrentState.value = ControllerRequestCurrentState.loaded;
  }

  /// Method Name : getAllRoles
  /// Parameters : None
  /// Return Type : Future<List<RoleHistoryModel>>
  /// Purpose : This method is used to get all active roles_module from the database.
  Future<List<RoleHistoryModel>> getAllRoles() async {
    requestCurrentState.value = ControllerRequestCurrentState.loading;
    accessTypeList = [];
    Either<Failure, dynamic> result = await roleRepository.getUnDeletedRoles();
    if (result.isLeft()) {
      requestCurrentState.value = ControllerRequestCurrentState.error;
    }
    accessTypeList = result.getOrElse(() => []);
    requestCurrentState.value = ControllerRequestCurrentState.loaded;
    return accessTypeList;
  }

  /// Method Name : deleteRole
  /// Parameters :
  ///             role : RoleHistoryModel - The role to be deleted.
  ///             currentUserEmail : String - The email of the current user to be added as editor
  ///
  ///
  ///
  deleteRole(RoleHistoryModel role, String currentUserEmail) async {
    requestCurrentState.value = ControllerRequestCurrentState.loading;
    Either<Failure, dynamic> result = await roleRepository.deleteRole(
        role: role, currentUserEmail: currentUserEmail);
    if (result.isLeft()) {
      requestCurrentState.value = ControllerRequestCurrentState.error;
      return;
    }
    if (result.isRight()) getAllRoles();
  }

  /// ✅ FIX CORRUPTED QIYAS DOCUMENT
  Future<void> fixQiyasPermissions(String roleId) async {
    print("\n🔧 Fixing qiyas permissions for role: $roleId");

    var result = await roleRepository.fixCorruptedQiyasDocument(roleId);

    result.fold(
          (failure) {
        print("❌ Failed to fix qiyas document: ${failure.errMessage}");
      },
          (success) {
        print("✅ $success");
        print("✅ Please reload the role to see the changes");
        getAllRoles();
      },
    );
  }


  Future<RoleHistoryModel?> getAccessTypeByName(String accessName) async {
    try {
      final CollectionReference accessTypeCollection =
      db.collection(ApiConstants.roles);

      DocumentSnapshot documentSnapshot =
      await accessTypeCollection.doc(accessName).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
        accessTypeByName = RoleHistoryModel.fromMap(data);
        return accessTypeByName;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting access type by name: $e");
      return null;
    }
  }

  /// ********************* add NewRole Section ****************************
  late List<bool> boolValues;
  late List<bool> boolValuesEdit;
  late List<bool> boolValues2;
  late List<bool> boolValues2Edit;
  late List<bool> boolValues3;
  late List<bool> boolValues3Edit;
  bool isEditRole = false;

  List<String> getAllAccessNames() {
    List<String> accessNames = [];
    for (var element in accessTypeList) {
      accessNames.add(capitalize(element.currentRoleName));
    }
    return accessNames;
  }

  Future<void> addNewRole(
      {required String accessName, required String? roleImage}) async {
    // Implementation for adding new role with history tracking
    // This would use the new RoleHistoryModel.createNew() factory with a generated roleId
  }

  /// Method Name: getRoleHistory
  /// Purpose: Get the complete history of changes for a specific role
  List<Map<String, dynamic>> getRoleHistory(RoleHistoryModel role) {
    List<Map<String, dynamic>> history = [];

    for (int i = 0; i < role.timestamps.length; i++) {
      Map<String, dynamic> historyEntry = {
        'timestamp': DateTime.fromMillisecondsSinceEpoch(role.timestamps[i]),
        'roleName': i < role.roleName.length ? role.roleName[i] : '',
        'roleNameAr': i < role.roleNameAr.length ? role.roleNameAr[i] : '',
        'roleDescription': i < role.roleDescription.length ? role.roleDescription[i] : '',
        'roleDescriptionAr': i < role.roleDescriptionAr.length ? role.roleDescriptionAr[i] : '',
        'status': i < role.status.length ? role.status[i] : '',
        'roleImage': i < role.roleImage.length ? role.roleImage[i] : '',
        'createdBy': i < role.createdBy.length ? role.createdBy[i] : '',
      };
      history.add(historyEntry);
    }

    return history;
  }

  /// Method Name: getRoleAtTimestamp
  /// Purpose: Get the state of a role at a specific timestamp
  Map<String, dynamic>? getRoleAtTimestamp(RoleHistoryModel role, DateTime targetDate) {
    int targetTimestamp = targetDate.millisecondsSinceEpoch;

    // Find the latest timestamp that is <= targetTimestamp
    int latestIndex = -1;
    for (int i = 0; i < role.timestamps.length; i++) {
      if (role.timestamps[i] <= targetTimestamp) {
        latestIndex = i;
      } else {
        break;
      }
    }

    if (latestIndex == -1) return null;

    return {
      'timestamp': DateTime.fromMillisecondsSinceEpoch(role.timestamps[latestIndex]),
      'roleName': latestIndex < role.roleName.length ? role.roleName[latestIndex] : '',
      'roleNameAr': latestIndex < role.roleNameAr.length ? role.roleNameAr[latestIndex] : '',
      'roleDescription': latestIndex < role.roleDescription.length ? role.roleDescription[latestIndex] : '',
      'roleDescriptionAr': latestIndex < role.roleDescriptionAr.length ? role.roleDescriptionAr[latestIndex] : '',
      'status': latestIndex < role.status.length ? role.status[latestIndex] : '',
      'roleImage': latestIndex < role.roleImage.length ? role.roleImage[latestIndex] : '',
      'createdBy': latestIndex < role.createdBy.length ? role.createdBy[latestIndex] : '',
    };
  }

  /// Method Name: searchRolesByStatus
  /// Purpose: Filter roles_module by status
  List<RoleHistoryModel> searchRolesByStatus(RoleStatus status) {
    if (status == RoleStatus.all) {
      return accessTypeList;
    }
    return accessTypeList.where((role) => role.currentStatus == status).toList();
  }

  /// Method Name: searchRolesByName
  /// Purpose: Search roles_module by name (English or Arabic)
  List<RoleHistoryModel> searchRolesByName(String searchTerm) {
    if (searchTerm.isEmpty) return accessTypeList;

    String searchLower = searchTerm.toLowerCase();
    return accessTypeList.where((role) =>
    role.currentRoleName.toLowerCase().contains(searchLower) ||
        role.currentRoleNameAr.toLowerCase().contains(searchLower)).toList();
  }

  /// Method Name: getRoleChangesSummary
  /// Purpose: Get a summary of changes made to a role
  Map<String, int> getRoleChangesSummary(RoleHistoryModel role) {
    Map<String, int> summary = {
      'totalChanges': role.timestamps.length,
      'nameChanges': role.roleName.length,
      'descriptionChanges': role.roleDescription.length,
      'statusChanges': role.status.length,
      'imageChanges': role.roleImage.length,
    };

    return summary;
  }

  /// Method Name: getRecentChanges
  /// Purpose: Get roles_module that have been changed recently
  List<RoleHistoryModel> getRecentChanges({int days = 7}) {
    DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));
    int cutoffTimestamp = cutoffDate.millisecondsSinceEpoch;

    return accessTypeList.where((role) {
      return role.currentTimestamp != null && role.currentTimestamp! >= cutoffTimestamp;
    }).toList();
  }

  /// Method Name: exportRoleHistory
  /// Purpose: Export role history data for reporting
  List<Map<String, dynamic>> exportRoleHistory() {
    List<Map<String, dynamic>> exportData = [];

    for (RoleHistoryModel role in accessTypeList) {
      Map<String, dynamic> roleData = {
        'currentRoleName': role.currentRoleName,
        'currentRoleNameAr': role.currentRoleNameAr,
        'currentStatus': role.currentStatus.name,
        'totalChanges': role.timestamps.length,
        'createdAt': role.currentCreatedAt.toDate(),
        'lastModified': role.currentTimestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(role.currentTimestamp!)
            : null,
        'history': getRoleHistory(role),
      };
      exportData.add(roleData);
    }

    return exportData;
  }
}