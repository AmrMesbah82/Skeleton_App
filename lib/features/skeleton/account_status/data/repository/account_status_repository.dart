///********************** FILE INFO **********************
/// File: account_status_repository.dart (WITH NOTIFICATIONS)
/// Purpose: repository contains all function related to database for account status feature.
/// Author: Mohamed Elrashidy
/// Date: 22/1/2025
/// Updated: 23/12/2025 - Added comprehensive notification system

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:demo_app/core/network/api_constants.dart';
import 'package:demo_app/features/skeleton/authentication/domain/enums/employee_status_enum.dart';
import '../../../../../core/helper/biometric_controller.dart';
import '../../../../../core/network/failure_model.dart';
import '../../../../external/main_core/core/networking/get_base_url.dart';
import '../../../../external/main_core/features/employee/data/models/emplyees_model/new_employee_model.dart';
import '../../../authentication/data/models/demo_user_account_overview.dart';
import '../../domain/entity/account_status_access_entity.dart';
import '../../presentation/controller/account_status_notification_service.dart';
import '../data_source/account_status_remote_data_source.dart';

class AccountStatusRepository {
  AccountStatusRemoteDataSource remoteDataSource =
  AccountStatusRemoteDataSource();

  /// Method Name: [getAccountsStatusEntities]
  ///
  /// Purpose: get all employees from the database and convert them to AccountStatusAccessEntity
  ///
  /// return: [Either<Failure, dynamic>]
  ///                                 - Failure: if there is an error in the process or [AccountStatusAccessEntity] data.
  getAccountsStatusEntities() async {
    Either<Failure, dynamic> result = await remoteDataSource.getEmployees();
    if (result.isLeft()) return result;

    List<Map<String, dynamic>> employees = result.getOrElse(() => []);
    List<AccountStatusAccessEntity> entities = [];

    for (Map<String, dynamic> employee in employees) {
      entities.add(AccountStatusAccessEntity.fromEmployeeModelHistory(
          NewEmployeeModelHistory.fromMap(employee)));
    }

    result = Right(entities);
    return result;
  }

  /// Method Name: [updateAccountStatus]
  ///
  /// Purpose: Update employee status using synchronized history pattern
  ///
  /// Parameters:
  ///   [AccountStatusAccessEntity] accountStatusAccessEntity
  ///   [EmployeeStatusEnum] status - new status to set
  /// ✅ UPDATED: Now sends notifications based on status change
  updateAccountStatus(AccountStatusAccessEntity accountStatusAccessEntity,
      EmployeeStatusEnum status) async {
    print('');
    print('═══════════════════════════════════════════════════════════');
    print('🔥 REPOSITORY - updateAccountStatus START');
    print('═══════════════════════════════════════════════════════════');
    print('   Employee ID: ${accountStatusAccessEntity.employeeId}');
    print('   Employee Name: ${accountStatusAccessEntity.englishName}');
    print('   Current Status (from entity): ${accountStatusAccessEntity.status.name}');
    print('   NEW Status to set: ${status.name}');
    print('───────────────────────────────────────────────────────────');

    Either<Failure, dynamic> result = await remoteDataSource
        .getEmployeeModel(accountStatusAccessEntity.employeeId);

    if (result.isLeft()) {
      print('❌ FAILED to get employee model from Firebase');
      print('   Error: $result');
      return result;
    }

    var employeeDataOrNull = result.getOrElse(() => null);

    if (employeeDataOrNull == null) {
      print('❌ FAILED - Employee data is NULL');
      return Left(FirebaseFailure(
          'Employee data not found for ID: ${accountStatusAccessEntity.employeeId}'));
    }

    Map<String, dynamic> employeeData =
    employeeDataOrNull as Map<String, dynamic>;

    print('');
    print('📥 RAW DATA FROM FIREBASE:');
    print('   Status field: ${employeeData['Status']}');
    print('   timestamps field: ${employeeData['timestamps']}');
    print('   Deactivation_Date: ${employeeData['Deactivation_Date']}');
    print('   Activation_Date: ${employeeData['Activation_Date']}');

    NewEmployeeModelHistory employeeModel =
    NewEmployeeModelHistory.fromMap(employeeData);

    print('');
    print('📄 PARSED MODEL - BEFORE UPDATE:');
    print('   status list: ${employeeModel.status}');
    print('   timestamps list: ${employeeModel.timestamps}');
    print('   status.length: ${employeeModel.status.length}');
    print('   timestamps.length: ${employeeModel.timestamps.length}');
    print('   deactivationDate: ${employeeModel.deactivationDate}');
    print('   activationDate: ${employeeModel.activationDate}');

    // ✅ Store old values for notification logic
    String oldStatus = employeeModel.status.isNotEmpty
        ? employeeModel.status.last
        : '';
    String? oldActivationDate = employeeModel.activationDate;
    String? oldDeactivationDate = employeeModel.deactivationDate;

    print('');
    print('🔄 CALLING copyWithUpdateSynchronized...');

    // Update the employee model
    employeeModel = employeeModel.copyWithUpdateSynchronized(
      status: status.name,
      deactivationDate: '', // Clear scheduled deactivation
      activationDate: '',   // Clear scheduled activation
    );

    print('');
    print('📄 PARSED MODEL - AFTER UPDATE:');
    print('   status list: ${employeeModel.status}');
    print('   timestamps list: ${employeeModel.timestamps}');
    print('   status.length: ${employeeModel.status.length}');
    print('   timestamps.length: ${employeeModel.timestamps.length}');
    print(
        '   Last status value: ${employeeModel.status.isNotEmpty ? employeeModel.status.last : "EMPTY"}');
    print('   deactivationDate: ${employeeModel.deactivationDate}');
    print('   activationDate: ${employeeModel.activationDate}');

    Map<String, dynamic> mapToSave = employeeModel.toMap();
    print('');
    print('🗺️ MAP TO SAVE TO FIREBASE:');
    print('   Status: ${mapToSave['Status']}');
    print('   timestamps: ${mapToSave['timestamps']}');
    print('   Deactivation_Date: ${mapToSave['Deactivation_Date']}');
    print('   Activation_Date: ${mapToSave['Activation_Date']}');

    print('');
    print('💾 CALLING updateEmployeeModel...');
    var updateResult = await remoteDataSource.updateEmployeeModel(employeeModel);

    print('');
    if (updateResult.isRight()) {
      print('✅ SUCCESS - Status updated in Firebase');
      print('   New status should be: ${status.name}');

      // ═══════════════════════════════════════════════════════════
      // ✅ SEND NOTIFICATIONS BASED ON STATUS CHANGE
      // ═══════════════════════════════════════════════════════════

      String userEmail = accountStatusAccessEntity.email;
      String userName = accountStatusAccessEntity.englishName ?? _buildEmployeeFullName(employeeModel);
      String adminEmail = storage.read('email') ?? "system@company.com";

      // 1. Account Activated
      if (status == EmployeeStatusEnum.active && oldStatus != 'active') {
        await AccountStatusNotificationService.sendAccountActivatedNotification(
          userEmail: userEmail,
          userName: userName,
          senderEmail: adminEmail, // ✅ ADD THIS
        );
      }

      // 2. Account Deactivated
      if (status == EmployeeStatusEnum.deactivated && oldStatus != 'deactivated') {
        await AccountStatusNotificationService.sendAccountDeactivatedNotification(
          userEmail: userEmail,
          userName: userName,
          senderEmail: adminEmail, // ✅ ADD THIS

        );
      }

      // 3. Account Unlocked (from locked to active)
      if (status == EmployeeStatusEnum.active &&
          (oldStatus == 'locked' || oldStatus == 'locked with send request')) {
        await AccountStatusNotificationService.sendAccountUnlockedNotification(
          userEmail: userEmail,
          userName: userName,
          senderEmail: adminEmail, // ✅ ADD THIS
        );
      }

      // 4. Schedule Canceled (if had scheduled dates and now cleared)
      if ((oldActivationDate != null && oldActivationDate.isNotEmpty) ||
          (oldDeactivationDate != null && oldDeactivationDate.isNotEmpty)) {
        await AccountStatusNotificationService.sendScheduleCanceledNotification(
          userEmail: userEmail,
          userName: userName,
          senderEmail: adminEmail, // ✅ ADD THIS
        );
      }

    } else {
      print('❌ FAILED - Could not update Firebase');
      print('   Error: $updateResult');
    }
    print('═══════════════════════════════════════════════════════════');
    print('');

    return updateResult;
  }

  /// Method Name: [scheduleDeactivationTime]
  ///
  /// Purpose: schedule deactivation time for the employee.
  ///
  /// Parameters:
  ///            [AccountStatusAccessEntity] accountStatusAccessEntity
  ///            [String] deactivationTime
  /// ✅ UPDATED: Now sends notifications when scheduling deactivation
  scheduleDeactivationTime(AccountStatusAccessEntity accountStatusAccessEntity,
      String deactivationTime) async {
    print('');
    print('═══════════════════════════════════════════════════════════');
    print('🔥 SCHEDULE DEACTIVATION TIME');
    print('═══════════════════════════════════════════════════════════');

    Either<Failure, dynamic> result = await remoteDataSource
        .getEmployeeModel(accountStatusAccessEntity.employeeId);
    if (result.isLeft()) return result;

    var employeeDataOrNull = result.getOrElse(() => null);

    if (employeeDataOrNull == null) {
      print('❌ FAILED - Employee data is NULL for scheduleDeactivationTime');
      return Left(FirebaseFailure(
          'Employee data not found for ID: ${accountStatusAccessEntity.employeeId}'));
    }

    NewEmployeeModelHistory employeeModel =
    NewEmployeeModelHistory.fromMap(employeeDataOrNull as Map<String, dynamic>);

    print('📋 BEFORE:');
    print('   - deactivationDate: ${employeeModel.deactivationDate}');
    print('   - activationDate: ${employeeModel.activationDate}');

    // ✅ Store old value to detect edit vs new schedule
    String? oldDeactivationDate = employeeModel.deactivationDate;

    // Update dates
    employeeModel.deactivationDate = deactivationTime;
    employeeModel.activationDate = ''; // Clear activation schedule

    print('📋 AFTER:');
    print('   - deactivationDate: ${employeeModel.deactivationDate}');
    print('   - activationDate: ${employeeModel.activationDate}');
    print('═══════════════════════════════════════════════════════════');
    print('');

    var updateResult = await remoteDataSource.updateEmployeeModel(employeeModel);

    // ═══════════════════════════════════════════════════════════
    // ✅ SEND NOTIFICATIONS
    // ═══════════════════════════════════════════════════════════
    if (updateResult.isRight()) {
      String userEmail = accountStatusAccessEntity.email;
      String userName = accountStatusAccessEntity.englishName ?? _buildEmployeeFullName(employeeModel);
      String adminEmail = "admin@company.com";

      // Check if this is a NEW schedule or EDIT
      if (oldDeactivationDate != null && oldDeactivationDate.isNotEmpty) {
        // EDIT - schedule was changed
        await AccountStatusNotificationService.sendScheduleEditedNotification(
          userEmail: userEmail,
          userName: userName,
          newScheduledDate: deactivationTime,
          scheduleType: "deactivation",
          senderEmail: adminEmail, // ✅ ADD THIS
        );
      } else {
        // NEW - first time scheduling
        await AccountStatusNotificationService.sendDeactivationScheduledNotification(
          userEmail: userEmail,
          userName: userName,
          scheduledDate: deactivationTime,
          senderEmail: adminEmail, // ✅ ADD THIS
        );
      }
    }

    return updateResult;
  }

  /// Method Name: [scheduleReactivationTime]
  ///
  /// Purpose: schedule reactivation time for the employee.
  ///
  /// Parameters:
  ///            [AccountStatusAccessEntity] accountStatusAccessEntity
  ///            [String] reactivationTime
  /// ✅ UPDATED: Now sends notifications when scheduling reactivation
  scheduleReactivationTime(AccountStatusAccessEntity accountStatusAccessEntity,
      String reactivationTime) async {
    print('');
    print('═══════════════════════════════════════════════════════════');
    print('🔥 SCHEDULE REACTIVATION TIME');
    print('═══════════════════════════════════════════════════════════');

    Either<Failure, dynamic> result = await remoteDataSource
        .getEmployeeModel(accountStatusAccessEntity.employeeId);
    if (result.isLeft()) return result;

    var employeeDataOrNull = result.getOrElse(() => null);

    if (employeeDataOrNull == null) {
      print('❌ FAILED - Employee data is NULL for scheduleReactivationTime');
      return Left(FirebaseFailure(
          'Employee data not found for ID: ${accountStatusAccessEntity.employeeId}'));
    }

    NewEmployeeModelHistory employeeModel =
    NewEmployeeModelHistory.fromMap(employeeDataOrNull as Map<String, dynamic>);

    print('📋 BEFORE:');
    print('   - deactivationDate: ${employeeModel.deactivationDate}');
    print('   - activationDate: ${employeeModel.activationDate}');

    // ✅ Store old value to detect edit vs new schedule
    String? oldActivationDate = employeeModel.activationDate;

    // Update dates
    employeeModel.activationDate = reactivationTime;
    employeeModel.deactivationDate = ''; // Clear deactivation schedule

    print('📋 AFTER:');
    print('   - deactivationDate: ${employeeModel.deactivationDate}');
    print('   - activationDate: ${employeeModel.activationDate}');
    print('═══════════════════════════════════════════════════════════');
    print('');

    var updateResult = await remoteDataSource.updateEmployeeModel(employeeModel);

    // ═══════════════════════════════════════════════════════════
    // ✅ SEND NOTIFICATIONS
    // ═══════════════════════════════════════════════════════════
    if (updateResult.isRight()) {
      String userEmail = accountStatusAccessEntity.email;
      String userName = accountStatusAccessEntity.englishName ?? _buildEmployeeFullName(employeeModel);
      String adminEmail = "admin@company.com";

      // Check if this is a NEW schedule or EDIT
      if (oldActivationDate != null && oldActivationDate.isNotEmpty) {
        // EDIT - schedule was changed
        await AccountStatusNotificationService.sendScheduleEditedNotification(
          userEmail: userEmail,
          userName: userName,
          newScheduledDate: reactivationTime,
          scheduleType: "activation",
        );
      } else {
        // NEW - first time scheduling
        await AccountStatusNotificationService.sendActivationScheduledNotification(
          userEmail: userEmail,
          userName: userName,
          scheduledDate: reactivationTime,
        );
      }
    }

    return updateResult;
  }

  /// Method Name: [approveResetPassword]
  ///
  /// Purpose: Approve reset password request and deactivate account
  ///
  /// Parameters:
  ///            [AccountStatusAccessEntity] accountStatusAccessEntity
  approveResetPassword(
      AccountStatusAccessEntity accountStatusAccessEntity) async {
    remoteDataSource.startTransaction();

    Either<Failure, dynamic> result = await remoteDataSource
        .getEmployeeModel(accountStatusAccessEntity.employeeId);
    if (result.isLeft()) {
      return result;
    }

    var employeeDataOrNull = result.getOrElse(() => null);

    if (employeeDataOrNull == null) {
      print('❌ FAILED - Employee data is NULL for approveResetPassword');
      return Left(FirebaseFailure(
          'Employee data not found for ID: ${accountStatusAccessEntity.employeeId}'));
    }

    NewEmployeeModelHistory employeeModel =
    NewEmployeeModelHistory.fromMap(employeeDataOrNull as Map<String, dynamic>);

    // Use copyWithUpdateSynchronized for status change
    employeeModel = employeeModel.copyWithUpdateSynchronized(
      status: EmployeeStatusEnum.inactive.name,
      deactivationDate: '',
      activationDate: '',
    );

    remoteDataSource.updateDemoUsersAccountWithinTransaction(
        accountStatusAccessEntity.email,
        {DemoUserAccountOverview.isActivatedField: false});

    remoteDataSource.updateEmployeeWithinTransaction(employeeModel);

    var commitResult = await remoteDataSource.commitTransaction();

    // ═══════════════════════════════════════════════════════════
    // ✅ SEND NOTIFICATION (Password Reset Approved)
    // ═══════════════════════════════════════════════════════════
    if (commitResult.isRight()) {
      String userName = accountStatusAccessEntity.englishName ?? _buildEmployeeFullName(employeeModel);

      await AccountStatusNotificationService.sendAccountDeactivatedNotification(
        userEmail: accountStatusAccessEntity.email,
        userName: userName,
      );
    }

    return commitResult;
  }

  /// Method Name: [updateAccessDetails]
  ///
  /// Purpose: Update default password and expiration time in Firebase
  Future<Either<Failure, dynamic>> updateAccessDetails(
      AccountStatusAccessEntity entity) async {
    print('🔥 FIREBASE UPDATE - START');

    print('📥 RECEIVED VALUES:');
    print('   - tempPassword: ${entity.tempPassword}');
    print('   - expirationTimeOfPassword: ${entity.expirationTimeOfPassword}');
    print('   - expirationTimeUnit: ${entity.expirationTimeUnit}');

    try {
      String? documentId = entity.employeeId;

      if (documentId == null || documentId.isEmpty) {
        print('❌ Document ID is null or empty');
        return Left(FirebaseFailure('Document ID cannot be null or empty'));
      }

      final employeesInfoRef = FirebaseFirestore.instance
          .collection(getBaseUrl('Employees_Info'));

      DocumentSnapshot docSnapshot = await employeesInfoRef
          .doc(documentId)
          .get(const GetOptions(source: Source.server));

      if (!docSnapshot.exists) {
        print('❌ Employee document not found: $documentId');
        return Left(FirebaseFailure('Employee document not found'));
      }

      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      data['Id'] = documentId;
      NewEmployeeModelHistory employeeModel =
      NewEmployeeModelHistory.fromMap(data);

      print('📄 CURRENT FIREBASE VALUES:');
      print('   - defaultPassword: ${employeeModel.defaultPassword}');
      print('   - passwordExpirationTime: ${employeeModel.passwordExpirationTime}');
      print('   - passwordExpirationUnit: ${employeeModel.passwordExpirationUnit}');

      // Update ALL THREE fields
      employeeModel.defaultPassword = entity.tempPassword;
      employeeModel.passwordExpirationTime = entity.expirationTimeOfPassword;
      employeeModel.passwordExpirationUnit = entity.expirationTimeUnit;

      print('💾 VALUES TO SAVE:');
      print('   - defaultPassword: ${employeeModel.defaultPassword}');
      print('   - passwordExpirationTime: ${employeeModel.passwordExpirationTime}');
      print('   - passwordExpirationUnit: ${employeeModel.passwordExpirationUnit}');

      Map<String, dynamic> mapToSave = employeeModel.toMap();
      print('🗺️ MAP VALUES:');
      print('   - Default_Password: ${mapToSave['Default_Password']}');
      print('   - Password_Expiration_Time: ${mapToSave['Password_Expiration_Time']}');
      print('   - Password_Expiration_Unit: ${mapToSave['Password_Expiration_Unit']}');

      await employeesInfoRef.doc(documentId).set(
          mapToSave, SetOptions(merge: true));

      print('✅ FIREBASE UPDATE - SUCCESS');
      return Right(null);
    } catch (e, stackTrace) {
      print('❌ FIREBASE UPDATE - ERROR: $e');
      print('Stack trace: $stackTrace');
      return Left(FirebaseFailure('Failed to update access details: $e'));
    }
  }

  /// ✅ HELPER METHOD: Build full name from employee model
  String _buildEmployeeFullName(NewEmployeeModelHistory employee) {
    List<String> nameParts = [];

    if (employee.firstName.isNotEmpty && employee.firstName.last.isNotEmpty) {
      nameParts.add(employee.firstName.last);
    }

    if (employee.middleName.isNotEmpty && employee.middleName.last.isNotEmpty) {
      nameParts.add(employee.middleName.last);
    }

    if (employee.lastName.isNotEmpty && employee.lastName.last.isNotEmpty) {
      nameParts.add(employee.lastName.last);
    }

    return nameParts.isEmpty ? 'Unknown User' : nameParts.join(' ');
  }
}