import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/roles/account_status/presentation/controller/custom_create_board.dart';
import 'package:demo_app/features/roles/account_status/data/repository/account_status_repository.dart';
import 'package:demo_app/features/roles/account_status/domain/entity/account_status_access_entity.dart';
import 'package:demo_app/features/roles/account_status/domain/use_case/get_accounts_status_entities_use_case.dart';
import 'package:demo_app/features/roles/account_status/domain/use_case/schedule_deactivation_time_use_case.dart';
import 'package:demo_app/features/onboarding/authentication/domain/enums/employee_status_enum.dart';
import '../../../../../core/network/failure_model.dart';
import '../../domain/use_case/approve_reset_password_use_case.dart';
import '../../domain/use_case/schedule_reactivation_time_use_case.dart';
import '../../domain/use_case/update_account_status_use_case.dart';
import '../ui/widgets/filter_widget.dart'; // ✅ Import SortOptionRole from here
import 'account_status_state.dart';


class AccountStatusCubit extends Cubit<AccountStatusState> {
  AccountStatusCubit() : super(AccountStatusInitial());
  AccountStatusRepository repository = AccountStatusRepository();
  EmployeeStatusEnum selectedStatus = EmployeeStatusEnum.all;
  SortOptionRole? selectedSortOption; // ✅ Use SortOptionRole
  Map<EmployeeStatusEnum, List<AccountStatusAccessEntity>>
  accountStatusEntities = {};
  List<AccountStatusAccessEntity> filteredSortedSelectedEntities = [];
  TextEditingController searchController = TextEditingController();
  String? selectedDepartment;

  /// Method Name: [getAccountsStatusEntities]
  ///
  /// Purpose: get all employees account status categorized according to status.
  getAccountsStatusEntities() async {
    Either<Failure, dynamic> result =
    await GetAccountsStatusEntitiesUseCase(repository).execute();
    if (result.isRight()) {
      accountStatusEntities = result.getOrElse(() => {});
      searchAccountsStatusEntities(searchController.text, selectedSortOption);
    }
  }

  /// Method Name: [sortAccountsStatusEntities]
  ///
  /// Purpose: sort account status entities according to the selected option.
  sortAccountsStatusEntities(SortOptionRole? option) { // ✅ Changed parameter type
    if (option == null) return; // ✅ Handle null case

    selectedSortOption = option;
    switch (option) {
      case SortOptionRole.firstName:
        filteredSortedSelectedEntities.sort((a, b) => a.englishName
            .split(" ")
            .first
            .compareTo(b.englishName.split(" ").first));
        break;
      case SortOptionRole.lastName:
        filteredSortedSelectedEntities.sort((a, b) => a.englishName
            .split(" ")
            .last
            .compareTo(b.englishName.split(" ").last));
        break;
      case SortOptionRole.firstLogin:
        filteredSortedSelectedEntities.sort((a, b) {
          if (a.firstLogin == null) {
            return 1;
          }
          if (b.firstLogin == null) {
            return -1;
          }
          return a.firstLogin!.compareTo(b.firstLogin!);
        });

        break;
      case SortOptionRole.lastLogin:
        filteredSortedSelectedEntities.sort((a, b) {
          if (a.lastLogin == null) {
            return 1;
          }
          if (b.lastLogin == null) {
            return -1;
          }

          return a.lastLogin!.compareTo(b.lastLogin!);
        });

        break;
    }
    // print("reach to update ui");
    emit(AccountStatusLoaded());
  }

  /// Method Name: [searchAccountsStatusEntities]
  ///
  /// Purpose: search for account status entities according to the search value.
  searchAccountsStatusEntities(String searchValue, SortOptionRole? option) { // ✅ Changed parameter type
    filteredSortedSelectedEntities = [];
    for (AccountStatusAccessEntity entity
    in accountStatusEntities[selectedStatus]!) {
      if (entity.englishName
          .toLowerCase()
          .contains(searchValue.toLowerCase()) ||
          entity.arabicName.toLowerCase().contains(searchValue.toLowerCase())) {
        if(selectedDepartment == null || selectedDepartment == entity.department)
          filteredSortedSelectedEntities.add(entity);
      }
    }
    if(option != null) {
      sortAccountsStatusEntities(option);
    }
    else {
      // print('reach to update ui and filter list lenght is ${filteredSortedSelectedEntities.length}');
      emit(AccountStatusLoaded());
    }
  }

  /// Method Name: [selectStatus]
  ///
  /// Purpose: select status to filter account status entities.
  selectStatus(EmployeeStatusEnum newStatus) {
    selectedStatus = newStatus;
    searchAccountsStatusEntities(searchController.text, selectedSortOption);
  }

  /// Method Name: [updateAccountStatus]
  ///
  /// Purpose: update account status in the database.
  updateAccountStatus(
      AccountStatusAccessEntity accountStatusAccessEntity) async
  {
    Either<Failure, dynamic> result =
    await UpdateAccountStatusUseCase(repository)
        .execute(accountStatusAccessEntity);
    if (result.isRight()) {
      // print('reach to update ui and filter list lenght is ${filteredSortedSelectedEntities.length}');
      getAccountsStatusEntities();
    }
  }

  /// Method Name: [updateAccessDetails]
  ///
  /// Purpose: update access details (expiration time and default password) in the database.
  ///
  /// Parameters: [AccountStatusAccessEntity] accountStatusAccessEntity
  updateAccessDetails(AccountStatusAccessEntity accountStatusAccessEntity) async {
    // print('');
    // print('========================================');
    // print('🔄 UPDATE ACCESS DETAILS - START');
    // print('========================================');
    // print('📋 Entity Details:');
    // print('   - Employee ID: ${accountStatusAccessEntity.employeeId}');
    // print('   - UID: ${accountStatusAccessEntity.employeeId}');
    // print('   - Name: ${accountStatusAccessEntity.englishName}');
    // print('   - Expiration Time: ${accountStatusAccessEntity.expirationTimeOfPassword}');
    // print('   - Password: ${accountStatusAccessEntity.tempPassword}');
    // print('   - Department: ${accountStatusAccessEntity.department}');
    // print('========================================');

    try {
      emit(AccountStatusLoading());
      // print('✅ State changed to: AccountStatusLoading');

      // print('🔄 Calling repository.updateAccessDetails...');
      await repository.updateAccessDetails(accountStatusAccessEntity);
      // print('✅ Repository update completed successfully');

      // print('🔄 Refreshing account status entities...');
      await getAccountsStatusEntities();
      // print('✅ Account status entities refreshed');

      emit(AccountStatusLoaded());
      // print('✅ State changed to: AccountStatusLoaded');

      // print('========================================');
      // print('✅ UPDATE ACCESS DETAILS - SUCCESS');
      // print('========================================');
      // print('');
    } catch (e) {
      // print('');
      // print('========================================');
      // print('❌ UPDATE ACCESS DETAILS - ERROR');
      // print('========================================');
      // print('❌ Error message: $e');
      // print('❌ Error type: ${e.runtimeType}');
      // print('========================================');
      // print('');
      emit(AccountStatusError('Failed to update access details: ${e.toString()}'));
    }
  }

  /// Method Name: [scheduleReactivation]
  ///
  /// Purpose: schedule reactivation time for the account.
  ///
  /// Parameters: [AccountStatusAccessEntity] accountStatusAccessEntity
  ///             [String] reactivationTime
  scheduleReactivation(AccountStatusAccessEntity accountStatusAccessEntity,
      String reactivationTime) async {
    Either<Failure, dynamic> result =
    await ScheduleReactivationTimeUseCase(repository)
        .execute(accountStatusAccessEntity, reactivationTime);
    if (result.isRight()) {
      getAccountsStatusEntities();
    }
  }

  /// Method Name: [scheduleDeactivation]
  ///
  /// Purpose: schedule deactivation time for the account.
  ///
  /// Parameters: [AccountStatusAccessEntity] accountStatusEntity
  ///            [String] selectedDateTime
  scheduleDeactivation(AccountStatusAccessEntity accountStatusEntity,
      String selectedDateTime) async {
    Either<Failure, dynamic> result =
    await ScheduleDeactivationTimeUseCase(repository)
        .execute(accountStatusEntity, selectedDateTime);

    if (result.isRight()) {
      getAccountsStatusEntities();
    }
  }

  approveRequestToResetPassword(
      AccountStatusAccessEntity accountStatusEntity) async {
    Either<Failure, dynamic> result =
    await ApproveResetPasswordUseCase(repository)
        .execute(accountStatusEntity);
    if (result.isRight()) {
      getAccountsStatusEntities();
    }
  }
}