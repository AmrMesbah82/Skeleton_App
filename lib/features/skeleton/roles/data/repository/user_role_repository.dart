import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/helper/helper_functions.dart';
import 'package:demo_app/core/network/api_constants.dart';
import 'package:demo_app/core/network/failure_model.dart';
import 'package:demo_app/features/skeleton/employees/data/models/new_employee_model/emplyees_model/new_employee_model.dart' hide NewEmployeeModel;
import 'package:demo_app/features/skeleton/employees/presentation/controller/employee_controller.dart';

import '../../../../external/main_core/features/employee/data/models/emplyees_model/new_employee_model.dart';
import '../../../../external/main_core/features/employee/domain/entities/employee_entity.dart';
import '../../../../external/main_core/features/employee/presentation/controller/main_core_employee_controller.dart';
import '../../domain/entity/new_permission_entity.dart';
import '../../domain/entity/user_permission_entity.dart';
import '../../presentation/controller/user_management_cubit.dart';
import '../../utils/constants.dart';
import '../../utils/user_access_status.dart';
import '../data_source/remote_data_source/role_remote_data_source.dart';

class UserManagementAccessRepository {
  final RoleRemoteDataSource remoteDataSource = RoleRemoteDataSource();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getUsersPermissionsData() async {
    final totalStopwatch = Stopwatch()..start();

    try {
      Map<String, NewEmployeeModelHistory> users = await _getEmployees();

      if (users.isEmpty) {
        totalStopwatch.stop();
        return Right(<UserPermissionEntity>[]);
      }

      Either<Failure, dynamic> result = await _getUsersPermissions(users);

      totalStopwatch.stop();
      return result;
    } catch (e, stackTrace) {
      totalStopwatch.stop();
      return Left(FeatureFailure(e.toString()));
    }
  }

  Future<Map<String, NewEmployeeModelHistory>> _getEmployees() async {
    final stopwatch = Stopwatch()..start();

    try {
      if (!Get.isRegistered<MainCoreEmployeeController>()) {
        return {};
      }

      MainCoreEmployeeController controller = Get.find<MainCoreEmployeeController>();
      List<EmployeeEntityPro>? employeesList = controller.allEmployeesEntities;

      if (employeesList == null || employeesList.isEmpty) {
        stopwatch.stop();
        return {};
      }

      Map<String, NewEmployeeModelHistory> users = {};
      int validCount = 0;
      int invalidCount = 0;
      int fetchErrorCount = 0;

      final parallelStopwatch = Stopwatch()..start();

      List<Future<void>> fetchFutures = [];

      for (int i = 0; i < employeesList.length; i++) {
        EmployeeEntityPro entity = employeesList[i];

        if (entity.id == null || entity.id!.isEmpty || entity.email == null || entity.email!.isEmpty) {
          invalidCount++;
          continue;
        }

        fetchFutures.add(
            remoteDataSource.getEmployeeModel(entity.id!).then((result) {
              if (result.isRight()) {
                Map<String, dynamic>? data = result.getOrElse(() => null);
                if (data != null) {
                  NewEmployeeModelHistory employee = NewEmployeeModelHistory.fromMap(data);
                  if (employee.email.isNotEmpty) {
                    String latestEmail = employee.email.last;
                    users[latestEmail] = employee;
                    validCount++;
                  } else {
                    invalidCount++;
                  }
                } else {
                  fetchErrorCount++;
                }
              } else {
                fetchErrorCount++;
              }
            }).catchError((e) {
              fetchErrorCount++;
            })
        );
      }

      await Future.wait(fetchFutures);

      parallelStopwatch.stop();
      stopwatch.stop();

      return users;
    } catch (e, stackTrace) {
      stopwatch.stop();
      return {};
    }
  }

  Future<String> checkModuleUserLimitsSimple({
    required String companyId,
    required String roleName,
  }) async {
    print('\n🔍 checkModuleUserLimitsSimple');
    print('   Company: $companyId');
    print('   Role: $roleName');

    try {
      Map<String, int> limits = await getModuleUserLimits(companyId);

      if (limits.isEmpty) {
        print('   ℹ️ No module limits configured');
        return 'No limits configured';
      }

      print('   📊 Limits: $limits');

      QuerySnapshot rolesSnap = await _firestore
          .collection('Demo/$companyId/Roles')
          .get();

      List<String> roleModules = [];

      for (var roleDoc in rolesSnap.docs) {
        Map<String, dynamic> roleData = roleDoc.data() as Map<String, dynamic>;

        String currentRoleName = '';
        if (roleData.containsKey('roleName') && roleData['roleName'] is List) {
          List<dynamic> names = roleData['roleName'];
          if (names.isNotEmpty) currentRoleName = names.last.toString();
        } else if (roleData.containsKey('roleName') &&
            roleData['roleName'] is String) {
          currentRoleName = roleData['roleName'].toString();
        }

        if (currentRoleName.toLowerCase() != roleName.toLowerCase()) continue;

        if (roleData.containsKey('selectedModules') &&
            roleData['selectedModules'] is List) {
          roleModules = List<String>.from(roleData['selectedModules']);
        }

        print('   ✅ Matched role "$currentRoleName" → modules: $roleModules');
        break;
      }

      if (roleModules.isEmpty) {
        print('   ℹ️ Role has no modules');
        return 'Role has no modules';
      }

      List<String> exceededModules = [];

      for (String moduleName in roleModules) {
        if (!limits.containsKey(moduleName)) {
          print('   ℹ️ No limit for $moduleName');
          continue;
        }

        int maxUsers = limits[moduleName]!;
        int currentCount = await getModuleUserCount(companyId, moduleName);

        print('   📊 $moduleName: $currentCount / $maxUsers');

        if (currentCount >= maxUsers) {
          print('   ❌ $moduleName LIMIT REACHED');
          exceededModules.add(moduleName);
        }
      }

      if (exceededModules.isNotEmpty) {
        String modulesList = exceededModules.join(', ');
        print('   ❌ Assignment BLOCKED for: $modulesList');
        return 'Module user limit reached for: $modulesList';
      }

      print('   ✅ All limits OK');
      return 'All limits OK - can assign';

    } catch (e, st) {
      print('❌ Error: $e');
      return 'Error checking limits: $e';
    }
  }

  Future<Either<Failure, dynamic>> _getUsersPermissions(
      Map<String, NewEmployeeModelHistory> users) async {
    final stopwatch = Stopwatch()..start();

    if (users.isEmpty) {
      return Right(<UserPermissionEntity>[]);
    }

    try {
      List<UserPermissionEntity> userPermissions = [];
      int skippedNoData = 0;
      int skippedRemoved = 0;
      int successCount = 0;
      int errorCount = 0;

      final parallelStopwatch = Stopwatch()..start();

      List<String> userEmails = users.keys.toList();
      List<Future<void>> accessFutures = [];

      for (String userEmail in userEmails) {
        NewEmployeeModelHistory userValue = users[userEmail]!;
        String? employeeId = userValue.id;

        if (employeeId == null || employeeId.isEmpty) {
          errorCount++;
          continue;
        }

        if (userValue.role.isNotEmpty) {
          String currentRole = userValue.role.last;
          if (currentRole == Constants.removedEmployeePermission) {
            skippedRemoved++;
            continue;
          }
        }

        accessFutures.add(
            remoteDataSource.getUserAccessModels(id: employeeId).then((result) {
              if (result.isLeft()) {
                errorCount++;
                return;
              }

              Map<String, dynamic>? data = result.getOrElse(() => null);
              if (data == null) {
                skippedNoData++;
                return;
              }

              try {
                UserPermissionHistoryModel userAccessModel =
                UserPermissionHistoryModel.fromMap(data);

                UserPermissionEntity permission = _getUserPermissions(
                  users: users,
                  userData: userValue,
                  userAccessModel: userAccessModel,
                );

                successCount++;
                userPermissions.add(permission);
              } catch (e) {
                errorCount++;
              }
            }).catchError((e) {
              errorCount++;
            })
        );
      }

      await Future.wait(accessFutures);

      parallelStopwatch.stop();
      stopwatch.stop();

      return Right(userPermissions);
    } catch (e, stackTrace) {
      stopwatch.stop();
      return Left(FeatureFailure(e.toString()));
    }
  }

  UserPermissionEntity _getUserPermissions({
    required Map<String, NewEmployeeModelHistory> users,
    required NewEmployeeModelHistory userData,
    required UserPermissionHistoryModel userAccessModel,
  }) {
    try {
      NewEmployeeModelHistory? grantor = users[userAccessModel.currentEditBy];

      String employeeEmail = userData.email.isNotEmpty ? userData.email.last : '';
      String gender = userData.gender.isNotEmpty ? userData.gender.last : '';
      String departmentId = userData.departmentId.isNotEmpty ? userData.departmentId.last : '';

      return UserPermissionEntity(
        employeeEmail: employeeEmail,
        employeeId: userData.id!,
        gender: userData.gender.isNotEmpty ? userData.gender.last : null,
        departmentId: userData.departmentId.isNotEmpty ? userData.departmentId.last : null,
        arabicJobTitle: userData.titleInArabic.isNotEmpty ? userData.titleInArabic.last : null,
        englishJobTitle: userData.title.isNotEmpty ? userData.title.last : null,
        imagePath: HelperFunctions.getUserImage(
          imagePath: null,
          gender: userData.gender.isNotEmpty ? userData.gender.last : null,
        ),
        englishName: _getEnglishName(userData),
        arabicName: _getArabicName(userData),
        accessName: userAccessModel.currentRole,
        grantorEnglishName: grantor != null ? _getEnglishName(grantor) : 'Unknown',
        grantorArabicName: grantor != null ? _getArabicName(grantor) : 'غير معروف',
        startDate: userAccessModel.currentFromDate,
        accessStatus: getUserAccessStatus(userAccessModel, userData.deactivationDate),
        endDate: userAccessModel.currentToDate,
      );
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  String _getEnglishName(NewEmployeeModelHistory employee) {
    String firstName = employee.firstName.isNotEmpty ? employee.firstName.last : '';
    String lastName = employee.lastName.isNotEmpty ? employee.lastName.last : '';
    return '$firstName $lastName'.trim();
  }

  String _getArabicName(NewEmployeeModelHistory employee) {
    String firstName = employee.firstNameInArabic.isNotEmpty ? employee.firstNameInArabic.last : '';
    String lastName = employee.lastNameInArabic.isNotEmpty ? employee.lastNameInArabic.last : '';
    return '$firstName $lastName'.trim();
  }

  // ✅ FIXED: explicit return types to avoid Right<dynamic,bool> cast errors
  Future<Either<Failure, dynamic>> _deleteEmployeePermission(
      String employeeId, String currentUserEmail) async {
    try {
      final dynamic fetchResult =
      await remoteDataSource.getUserAccessModels(id: employeeId);

      Either<Failure, dynamic> result;
      if (fetchResult is Either<Failure, dynamic>) {
        result = fetchResult;
      } else {
        result = Right<Failure, dynamic>(fetchResult);
      }

      if (result.isLeft()) return result;

      Map<String, dynamic>? data = result.getOrElse(() => null);
      if (data == null) {
        return Right(true);
      }

      UserPermissionHistoryModel userPermissionModel =
      UserPermissionHistoryModel.fromMap(data);

      UserPermissionHistoryModel updatedModel = userPermissionModel.copyWith(
        role: Constants.removedEmployeePermission,
        editBy: currentUserEmail,
      );

      remoteDataSource.updateRoleWithinTransaction(
          id: employeeId, data: updatedModel.toMap());
      return Right(true);
    } catch (e) {
      return Left(FeatureFailure(e.toString()));
    }
  }

  // ✅ FIXED: explicit return types to avoid Right<dynamic,bool> cast errors
  Future<Either<Failure, dynamic>> _updateEmployeeRoles(
      String employeeId, String accessName) async {
    try {
      final dynamic fetchResult =
      await remoteDataSource.getEmployeeModel(employeeId);

      Either<Failure, dynamic> result;
      if (fetchResult is Either<Failure, dynamic>) {
        result = fetchResult;
      } else {
        result = Right<Failure, dynamic>(fetchResult);
      }

      if (result.isLeft()) return result;

      Map<String, dynamic>? data = result.getOrElse(() => null);
      if (data == null) {
        return Left(FeatureFailure("Employee not found"));
      }

      NewEmployeeModelHistory employeeModel =
      NewEmployeeModelHistory.fromMap(data);

      NewEmployeeModelHistory updatedModel =
      employeeModel.copyWithUpdateSynchronized(
        role: accessName,
      );

      remoteDataSource.updateEmployeeModel(
          id: employeeId, data: updatedModel.toMap());

      return Right(true);
    } catch (e) {
      return Left(FeatureFailure(e.toString()));
    }
  }

  // ✅ FIXED: explicit return types to avoid Right<dynamic,bool> cast errors
  Future<Either<Failure, dynamic>> deleteEmployeePermission({
    required String employeeId,
    required String currentUserEmail,
  }) async {
    try {
      remoteDataSource.startTransaction();

      Either<Failure, dynamic> result =
      await _deleteEmployeePermission(employeeId, currentUserEmail);
      if (result.isLeft()) return result;

      Either<Failure, dynamic> result2 = await _updateEmployeeRoles(
          employeeId, Constants.removedEmployeePermission);
      if (result2.isLeft()) return result2;

      final dynamic commitResult = await remoteDataSource.commitTransaction();
      if (commitResult is Either<Failure, dynamic>) {
        return commitResult;
      }
      return Right<Failure, dynamic>(true);
    } catch (e, stackTrace) {
      print('❌ deleteEmployeePermission error: $e');
      return Left(FeatureFailure(e.toString()));
    }
  }

  Future<Either<Failure, dynamic>> checkModuleUserLimitsBeforeAssignment({
    required String companyId,
    required String roleName,
  }) async {
    print('\n🔍 checkModuleUserLimitsBeforeAssignment');
    print('   Company: $companyId');
    print('   Role: $roleName');

    try {
      Map<String, int> limits = await getModuleUserLimits(companyId);

      if (limits.isEmpty) {
        print('   ℹ️ No module limits configured — allowing assignment');
        return Right(null);
      }

      print('   📊 Limits: $limits');

      QuerySnapshot rolesSnap = await _firestore
          .collection('Demo/$companyId/Roles')
          .get();

      List<String> roleModules = [];

      for (var roleDoc in rolesSnap.docs) {
        Map<String, dynamic> roleData = roleDoc.data() as Map<String, dynamic>;

        String currentRoleName = '';
        if (roleData.containsKey('roleName') && roleData['roleName'] is List) {
          List<dynamic> names = roleData['roleName'];
          if (names.isNotEmpty) currentRoleName = names.last.toString();
        } else if (roleData.containsKey('roleName') &&
            roleData['roleName'] is String) {
          currentRoleName = roleData['roleName'].toString();
        }

        if (currentRoleName.toLowerCase() != roleName.toLowerCase()) continue;

        if (roleData.containsKey('selectedModules') &&
            roleData['selectedModules'] is List) {
          roleModules = List<String>.from(roleData['selectedModules']);
        }

        print('   ✅ Matched role "$currentRoleName" → modules: $roleModules');
        break;
      }

      if (roleModules.isEmpty) {
        print('   ℹ️ Role has no modules — allowing assignment');
        return Right(null);
      }

      List<String> exceededModules = [];

      for (String moduleName in roleModules) {
        if (!limits.containsKey(moduleName)) {
          print('   ℹ️ No limit for $moduleName — skipping');
          continue;
        }

        int maxUsers = limits[moduleName]!;
        int currentCount = await getModuleUserCount(companyId, moduleName);

        print('   📊 $moduleName: $currentCount / $maxUsers');

        if (currentCount >= maxUsers) {
          print('   ❌ $moduleName LIMIT REACHED ($currentCount >= $maxUsers)');
          exceededModules.add(moduleName);
        }
      }

      if (exceededModules.isNotEmpty) {
        String modulesList = exceededModules.join(', ');
        print('   ❌ Assignment BLOCKED for modules: $modulesList');
        return Left(FeatureFailure(
            'Module user limit reached for: $modulesList. Please contact your administrator.'));
      }

      print('   ✅ All limits OK — proceeding with assignment');
      return Right(null);
    } catch (e, st) {
      print('❌ checkModuleUserLimitsBeforeAssignment error: $e\n$st');
      return Right(null);
    }
  }

  updateUserPermission({
    required String employeeId,
    required String currentUserEmail,
    String? accessName,
    String? accessBegin,
    String? accessEnd,
    bool isCommit = true,
  }) async {
    print('\n🔍 updateUserPermission called for employee: $employeeId');

    String? currentExistingRole;
    bool isActuallyNewAssignment = true;

    Either<Failure, dynamic> currentCheck =
    await remoteDataSource.getUserAccessModels(id: employeeId);

    if (currentCheck.isRight()) {
      Map<String, dynamic>? currentData = currentCheck.getOrElse(() => null);
      if (currentData != null) {
        try {
          UserPermissionHistoryModel currentModel =
          UserPermissionHistoryModel.fromMap(currentData);
          currentExistingRole = currentModel.currentRole;

          if (currentExistingRole != null &&
              currentExistingRole.isNotEmpty &&
              accessName != null &&
              currentExistingRole.toLowerCase() == accessName.toLowerCase()) {
            isActuallyNewAssignment = false;
            print('   ℹ️ User already has role "$accessName" - treating as date update only');
          } else if (currentExistingRole != null && currentExistingRole.isNotEmpty) {
            print('   ℹ️ Role change: "$currentExistingRole" → "$accessName"');
          }
        } catch (e) {
          print('   ⚠️ Could not parse current role: $e');
        }
      } else {
        print('   ℹ️ No existing access data - this is a NEW user assignment');
      }
    }

    if (isActuallyNewAssignment &&
        accessName != null &&
        accessName.isNotEmpty &&
        accessName != Constants.removedEmployeePermission) {

      String companyId = _getCompanyId();

      if (companyId.isNotEmpty) {
        print('\n🔍 Checking SERVICES module limit for NEW assignment: $accessName in company: $companyId');

        Map<String, int> limits = await getModuleUserLimits(companyId);

        if (limits.containsKey('services')) {
          int servicesLimit = limits['services']!;
          int currentServicesUsers = await getModuleUserCount(companyId, 'services');

          print('   📊 SERVICES module: $currentServicesUsers / $servicesLimit');

          if (currentServicesUsers >= servicesLimit) {
            String errorMsg = 'Cannot assign user to "$accessName". '
                'Services module limit is $servicesLimit, '
                'currently $currentServicesUsers users have services access.';
            print('   ❌❌❌ $errorMsg');

            return Left(FeatureFailure(errorMsg));
          }
        } else {
          print('   ℹ️ No services limit configured - skipping check');
        }

        print('✅ Services module limit check PASSED');
      }
    } else if (!isActuallyNewAssignment) {
      print('   ⏭️ Skipping limit check - existing user with same role');
    }

    if (isCommit) {
      remoteDataSource.startTransaction();
    }

    Either<Failure, dynamic> result =
    await remoteDataSource.getUserAccessModels(id: employeeId);

    if (result.isLeft()) {
      return result;
    }

    Map<String, dynamic>? data = result.getOrElse(() => null);

    if (data == null) {
      await _createNewUserPermission(
        employeeId: employeeId,
        role: accessName!,
        fromDate: accessBegin!,
        toDate: accessEnd!,
        editBy: currentUserEmail,
      );

      await _updateEmployeeRoles(employeeId, accessName);
    } else {
      UserPermissionHistoryModel existingModel =
      UserPermissionHistoryModel.fromMap(data);

      String? effectiveRole = accessName?.isNotEmpty == true
          ? accessName
          : existingModel.currentRole;

      await _updateEmployeePermission(
        existingModel: existingModel,
        employeeId: employeeId,
        role: effectiveRole,
        fromDate: accessBegin,
        toDate: accessEnd,
        editBy: currentUserEmail,
      );

      if (accessName != null &&
          accessName.isNotEmpty &&
          accessName != existingModel.currentRole) {
        await _updateEmployeeRoles(employeeId, accessName);
      }
    }

    if (isCommit) {
      final dynamic commitResult = await remoteDataSource.commitTransaction();
      if (commitResult is Either<Failure, dynamic>) {
        return commitResult;
      }
      return Right<Failure, dynamic>(true);
    }

    return Right(true);
  }

  _updateEmployeePermission({
    required UserPermissionHistoryModel existingModel,
    required String employeeId,
    String? role,
    String? fromDate,
    String? toDate,
    required String editBy,
  }) async {
    if (role != null && role != existingModel.currentRole) {
      await _updateEmployeeRoles(employeeId, role);
    }

    UserPermissionHistoryModel updatedModel = existingModel.copyWith(
      role: role,
      fromDate: fromDate,
      toDate: toDate,
      editBy: editBy,
    );

    remoteDataSource.updateRoleWithinTransaction(
        id: employeeId, data: updatedModel.toMap());
  }

  _createNewUserPermission({
    required String employeeId,
    required String role,
    required String fromDate,
    required String toDate,
    required String editBy,
  }) {
    UserPermissionHistoryModel userPermissionModel =
    UserPermissionHistoryModel.createNew(
      employeeId: employeeId,
      role: role,
      fromDate: fromDate,
      toDate: toDate,
      editBy: editBy,
    );

    remoteDataSource.updateRoleWithinTransaction(
        id: employeeId, data: userPermissionModel.toMap());
  }

  updateSelectedMembersPermission({
    required String currentUserEmail,
    required String accessName,
    required String startDate,
    required String endDate,
    required List<EmployeeEntityPro> selectedMembers,
  }) async {
    print('\n🔍 updateSelectedMembersPermission: ${selectedMembers.length} users to role "$accessName"');

    if (accessName.isNotEmpty && accessName != Constants.removedEmployeePermission) {
      String companyId = _getCompanyId();

      if (companyId.isNotEmpty) {
        print('   🔍 Checking SERVICES module limit for ANY role...');

        Map<String, int> limits = await getModuleUserLimits(companyId);

        if (limits.containsKey('services')) {
          int servicesLimit = limits['services']!;
          int currentServicesUsers = await getModuleUserCount(companyId, 'services');
          int selectedCount = selectedMembers.length;
          int projectedTotal = currentServicesUsers + selectedCount;

          print('   📊 SERVICES module: $currentServicesUsers + $selectedCount = $projectedTotal / $servicesLimit');

          if (projectedTotal > servicesLimit) {
            String errorMsg = 'The Services module has reached its user limit.\n'
                'You cannot assign the "$accessName" role at this time.\n\n'
                'Please contact your administrator to increase the limit.';
            print('   ❌❌❌ $errorMsg');

            return Left(FeatureFailure(errorMsg));
          }
        } else {
          print('   ℹ️ No services limit configured - skipping check');
        }
      } else {
        print('   ⚠️ No company ID found - skipping limit check');
      }
    } else {
      print('   ℹ️ Empty role or removal - skipping limit check');
    }

    print('   ✅ All limit checks passed - starting transaction...');

    remoteDataSource.startTransaction();

    int successCount = 0;
    int errorCount = 0;

    for (EmployeeEntityPro selectedMember in selectedMembers) {
      try {
        await _updateUserPermissionWithoutLimitCheck(
          employeeId: selectedMember.id!,
          currentUserEmail: currentUserEmail,
          accessName: accessName,
          accessBegin: startDate,
          accessEnd: endDate,
        );
        successCount++;
        print('   ✅ Assigned to ${selectedMember.id}');
      } catch (e) {
        print('   ❌ Error updating ${selectedMember.id}: $e');
        errorCount++;
      }
    }

    final dynamic commitResult = await remoteDataSource.commitTransaction();
    print('   ✅ Batch complete: $successCount success, $errorCount errors');
    if (commitResult is Either<Failure, dynamic>) {
      return commitResult;
    }
    return Right<Failure, dynamic>(true);
  }

  Future<List<String>> _getRoleModules(String companyId, String roleName) async {
    try {
      QuerySnapshot rolesSnap = await _firestore
          .collection('Demo/$companyId/Roles')
          .get();

      for (var roleDoc in rolesSnap.docs) {
        Map<String, dynamic> roleData = roleDoc.data() as Map<String, dynamic>;

        String currentRoleName = '';
        if (roleData.containsKey('roleName') && roleData['roleName'] is List) {
          List<dynamic> names = roleData['roleName'];
          if (names.isNotEmpty) currentRoleName = names.last.toString();
        }

        if (currentRoleName.toLowerCase() != roleName.toLowerCase()) continue;

        if (roleData.containsKey('selectedModules') &&
            roleData['selectedModules'] is List) {
          return List<String>.from(roleData['selectedModules']);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  _updateUserPermissionWithoutLimitCheck({
    required String employeeId,
    required String currentUserEmail,
    required String accessName,
    required String accessBegin,
    required String accessEnd,
  }) async {
    Either<Failure, dynamic> result =
    await remoteDataSource.getUserAccessModels(id: employeeId);

    if (result.isLeft()) return result;

    Map<String, dynamic>? data = result.getOrElse(() => null);

    if (data == null) {
      await _createNewUserPermission(
        employeeId: employeeId,
        role: accessName,
        fromDate: accessBegin,
        toDate: accessEnd,
        editBy: currentUserEmail,
      );
      await _updateEmployeeRoles(employeeId, accessName);
    } else {
      UserPermissionHistoryModel existingModel =
      UserPermissionHistoryModel.fromMap(data);
      await _updateEmployeePermission(
        existingModel: existingModel,
        employeeId: employeeId,
        role: accessName,
        fromDate: accessBegin,
        toDate: accessEnd,
        editBy: currentUserEmail,
      );
    }
  }

  /// Arabic (transliterated Gregorian) month name → month number.
  static const Map<String, int> _arabicMonths = {
    'يناير': 1,
    'فبراير': 2,
    'مارس': 3,
    'أبريل': 4, 'ابريل': 4,
    'مايو': 5,
    'يونيو': 6, 'يونيه': 6,
    'يوليو': 7, 'يوليه': 7,
    'أغسطس': 8, 'اغسطس': 8,
    'سبتمبر': 9,
    'أكتوبر': 10, 'اكتوبر': 10,
    'نوفمبر': 11,
    'ديسمبر': 12,
  };

  /// Convert Arabic-Indic (٠-٩) and Persian (۰-۹) digits to Western (0-9).
  String _normalizeDigits(String input) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabicIndic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    String r = input;
    for (int i = 0; i < 10; i++) {
      r = r.replaceAll(arabicIndic[i], western[i]).replaceAll(persian[i], western[i]);
    }
    return r;
  }

  /// Parse a date written in Arabic, e.g. "أكتوبر ١٩, ٢٠٢٦".
  /// Digits are already normalized before this is called.
  DateTime? _tryParseArabic(String normalized) {
    // Treat both Western and Arabic commas as separators.
    final cleaned = normalized.replaceAll(',', ' ').replaceAll('،', ' ');
    final tokens =
    cleaned.split(RegExp(r'\s+')).where((t) => t.trim().isNotEmpty).toList();
    if (tokens.length < 3) return null;

    int? month, day, year;
    for (final t in tokens) {
      if (_arabicMonths.containsKey(t)) {
        month = _arabicMonths[t];
      } else {
        final n = int.tryParse(t);
        if (n == null) continue;
        if (n > 31) {
          year = n; // 4-digit year
        } else if (day == null) {
          day = n; // first 1-2 digit number is the day
        } else {
          year ??= n;
        }
      }
    }

    if (month != null && day != null && year != null) {
      try {
        return DateTime(year, month, day);
      } catch (_) {}
    }
    return null;
  }

  /// ✅ Robust date parser — handles BOTH English and Arabic stored dates.
  /// Some records were saved in Arabic (e.g. "أكتوبر ١٩, ٢٠٢٦") because the
  /// write side formatted with the Arabic locale; this reads them all.
  /// Returns null only if NONE of the formats matched.
  DateTime? _parseAccessDate(String? raw, {String label = ''}) {
    if (raw == null || raw.trim().isEmpty || raw == '-' || raw == 'null') {
      print('   🗓️ [$label] empty/null/"-" → null');
      return null;
    }

    // Normalize Arabic/Persian digits up front so every branch benefits.
    final s = _normalizeDigits(raw.trim());

    // 1) ISO / yyyy-MM-dd (also yyyy-MM-ddTHH:mm:ss)
    try {
      final d = DateTime.parse(s);
      print('   🗓️ [$label] "$s" parsed via ISO → $d');
      return d;
    } catch (_) {}

    // 2) dd/MM/yyyy
    if (s.contains('/')) {
      final parts = s.split('/');
      if (parts.length == 3) {
        try {
          final d = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
          print('   🗓️ [$label] "$s" parsed via dd/MM/yyyy → $d');
          return d;
        } catch (_) {}
      }
    }

    // 3) English named-month formats (with / without comma)
    const formats = [
      'MMM dd, yyyy',
      'dd MMM, yyyy',
      'MMMM dd, yyyy',
      'dd MMMM, yyyy',
      'dd MMM yyyy',
      'MMM dd yyyy',
      'dd MMMM yyyy',
      'MMMM dd yyyy',
    ];
    for (final f in formats) {
      try {
        final d = DateFormat(f, 'en').parse(s);
        print('   🗓️ [$label] "$s" parsed via "$f" → $d');
        return d;
      } catch (_) {}
    }

    // 4) Arabic month names (e.g. "أكتوبر 19, 2026" after digit normalization)
    final ar = _tryParseArabic(s);
    if (ar != null) {
      print('   🗓️ [$label] "$s" parsed via Arabic month names → $ar');
      return ar;
    }

    // 5) the configured app format, last resort
    try {
      final d = DateFormat(Constants.userAccessDateFormat, 'en').parse(s);
      print('   🗓️ [$label] "$s" parsed via Constants.userAccessDateFormat '
          '("${Constants.userAccessDateFormat}") → $d');
      return d;
    } catch (_) {}

    print('   ❌ [$label] COULD NOT PARSE "$s" with ANY known format!');
    return null;
  }

  /// ✅ Status logic:
  ///   - end unparseable                  → active (loud warning, fix data)
  ///   - now > end                        → inactive
  ///   - now < start                      → scheduled (not started yet)
  ///   - deactivated and that date passed → inactive
  ///   - <= 12 days left until end        → expiringSoon
  ///   - between start and end (>12 left) → active
  /// Heavy prints so you can see WHY a card got its status.
  UserAccessStatus getUserAccessStatus(
      UserPermissionHistoryModel userAccessModel, String? deactivationDate) {
    print('\n┌──────────────────────────────────────────────');
    print('│ 📌 getUserAccessStatus');
    print('│   RAW fromDate : "${userAccessModel.currentFromDate}"');
    print('│   RAW toDate   : "${userAccessModel.currentToDate}"');
    print('│   RAW deactivat: "${deactivationDate ?? "null"}"');
    print('│   App format   : "${Constants.userAccessDateFormat}"');
    print('└──────────────────────────────────────────────');

    final now = DateTime.now();
    print('   ⏰ now = $now');

    final DateTime? startDate =
    _parseAccessDate(userAccessModel.currentFromDate, label: 'start');
    final DateTime? endDate =
    _parseAccessDate(userAccessModel.currentToDate, label: 'end');

    // 🔴 If we cannot read the END date, DON'T silently mark inactive.
    if (endDate == null) {
      print('   ⚠️ END date unparseable → cannot decide. Defaulting to ACTIVE. '
          'FIX THE STORED FORMAT for this record.');
      return UserAccessStatus.active;
    }

    // 1) Past the end date → inactive
    if (now.isAfter(endDate)) {
      print('   ➡️ now ($now) IS AFTER end ($endDate) → INACTIVE (غير نشط)');
      return UserAccessStatus.inactive;
    }

    // 2) Hasn't started yet (now < start) → scheduled
    if (startDate != null && now.isBefore(startDate)) {
      print('   ➡️ now ($now) IS BEFORE start ($startDate) → SCHEDULED (مجدول)');
      return UserAccessStatus.scheduled;
    }

    if (startDate == null) {
      print('   ⚠️ START date unparseable — cannot detect "scheduled"; '
          'status computed from end date only.');
    }

    // 3) Deactivated and that date has passed → inactive
    final DateTime? deact = _parseAccessDate(deactivationDate, label: 'deactivation');
    if (deact != null && now.isAfter(deact)) {
      print('   ➡️ now ($now) IS AFTER deactivation ($deact) → INACTIVE (غير نشط)');
      return UserAccessStatus.inactive;
    }

    // 4) 12 days or fewer left until the end date → expiring soon
    final int daysLeft = endDate.difference(now).inDays;
    print('   📏 daysLeft = $daysLeft (end - now)');
    if (daysLeft <= 12) {
      print('   ➡️ daysLeft ($daysLeft) <= 12 → EXPIRING SOON (ينتهي قريبا)');
      return UserAccessStatus.expiringSoon;
    }

    // 5) Between start and end with more than 12 days left → active
    print('   ➡️ between start & end, $daysLeft days left → ACTIVE (نشط)');
    return UserAccessStatus.active;
  }

  Future<List<Map<String, dynamic>>> getUserPermissionHistory(
      String employeeId) async {
    Either<Failure, dynamic> result =
    await remoteDataSource.getUserAccessModels(id: employeeId);

    if (result.isLeft()) return [];

    Map<String, dynamic>? data = result.getOrElse(() => null);
    if (data == null) return [];

    UserPermissionHistoryModel model = UserPermissionHistoryModel.fromMap(data);
    return model.getHistory();
  }

  String _getCompanyId() {
    String baseUri = ApiConstants.baseUri;
    if (baseUri.contains('/')) {
      return baseUri.split('/').last;
    }
    return baseUri;
  }

  Future<Map<String, int>> getModuleUserLimits(String companyId) async {
    print('\n🔍 _getModuleUserLimits: $companyId');

    try {
      DocumentSnapshot doc = await _firestore
          .collection('Demo_Requests')
          .doc(companyId)
          .get();

      if (!doc.exists) {
        print('   ⚠️ Demo_Requests/$companyId not found');
        return {};
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (!data.containsKey('Demo_Details') ||
          data['Demo_Details'] is! Map ||
          !(data['Demo_Details'] as Map).containsKey('Modules_User_Limits')) {
        print('   ℹ️ No Modules_User_Limits — no limits set');
        return {};
      }

      Map<String, dynamic> rawLimits = Map<String, dynamic>.from(
          data['Demo_Details']['Modules_User_Limits']);

      Map<String, int> limits = {};
      rawLimits.forEach((key, value) {
        if (value is int) {
          limits[key] = value;
        } else if (value is num) {
          limits[key] = value.toInt();
        }
      });

      print('✅ _getModuleUserLimits: $limits');
      return limits;
    } catch (e, st) {
      print('❌ _getModuleUserLimits error: $e\n$st');
      return {};
    }
  }

  Future<int> getModuleUserCount(String companyId, String moduleName) async {
    print('\n🔍 _getModuleUserCount: $companyId / $moduleName');

    try {
      QuerySnapshot rolesSnap = await _firestore
          .collection('Demo/$companyId/Roles')
          .get();

      Set<String> roleNamesWithModule = {};

      for (var roleDoc in rolesSnap.docs) {
        Map<String, dynamic> roleData = roleDoc.data() as Map<String, dynamic>;

        List<String> selectedModules = [];
        if (roleData.containsKey('selectedModules') &&
            roleData['selectedModules'] is List) {
          selectedModules = List<String>.from(roleData['selectedModules']);
        }

        if (!selectedModules.contains(moduleName)) continue;

        String roleName = '';
        if (roleData.containsKey('roleName') && roleData['roleName'] is List) {
          List<dynamic> names = roleData['roleName'];
          if (names.isNotEmpty) roleName = names.last.toString();
        } else if (roleData.containsKey('roleName') &&
            roleData['roleName'] is String) {
          roleName = roleData['roleName'].toString();
        }

        if (roleName.isNotEmpty) {
          roleNamesWithModule.add(roleName.toLowerCase());
          print('   Role "$roleName" contains $moduleName');
        }
      }

      if (roleNamesWithModule.isEmpty) {
        print('   ℹ️ No roles contain $moduleName → count = 0');
        return 0;
      }

      QuerySnapshot usersAccessSnap = await _firestore
          .collection('Demo/$companyId/Users_Access')
          .get();

      int count = 0;

      for (var accessDoc in usersAccessSnap.docs) {
        Map<String, dynamic> accessData = accessDoc.data() as Map<String, dynamic>;

        String? currentRole;
        if (accessData.containsKey('Role') && accessData['Role'] is Map) {
          Map<String, dynamic> roleMap =
          Map<String, dynamic>.from(accessData['Role']);
          if (roleMap.containsKey('Values') && roleMap['Values'] is List) {
            List<dynamic> values = roleMap['Values'];
            if (values.isNotEmpty) currentRole = values.last.toString();
          }
        }

        if (currentRole == null || currentRole.isEmpty) continue;
        if (currentRole.toLowerCase() == 'removed') continue;

        if (roleNamesWithModule.contains(currentRole.toLowerCase())) {
          count++;
          print('   ✅ Employee ${accessDoc.id} counted (role: $currentRole)');
        }
      }

      print('✅ _getModuleUserCount: $moduleName = $count users');
      return count;
    } catch (e, st) {
      print('❌ _getModuleUserCount error: $e\n$st');
      return 0;
    }
  }
}