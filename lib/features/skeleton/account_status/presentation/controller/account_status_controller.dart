/// *************************** FILE INFO ****************************
/// File: account_status_controller.dart
/// Purpose: controller accounts status ui functionality.
/// Author: Mohamed Elrashidy
/// Date: 22/1/2025
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/account_status/data/repository/account_status_repository.dart';
import 'package:demo_app/features/skeleton/account_status/domain/entity/account_status_access_entity.dart';
import 'package:demo_app/features/skeleton/account_status/domain/use_case/get_accounts_status_entities_use_case.dart';
import 'package:demo_app/features/skeleton/account_status/domain/use_case/schedule_deactivation_time_use_case.dart';
import 'package:demo_app/features/skeleton/authentication/domain/enums/employee_status_enum.dart';
import '../../../../../core/enumeration/enum.dart';
import '../../../../../core/network/failure_model.dart';
import '../../domain/use_case/approve_reset_password_use_case.dart';
import '../../domain/use_case/schedule_reactivation_time_use_case.dart';
import '../../domain/use_case/update_account_status_use_case.dart';
import '../ui/widgets/filter_widget.dart';

class AccountStatusController extends GetxController {
  AccountStatusRepository repository = AccountStatusRepository();
  EmployeeStatusEnum selectedStatus = EmployeeStatusEnum.active;
  SortOptionRole? selectedSortOption;
  Map<EmployeeStatusEnum, List<AccountStatusAccessEntity>>
      accountStatusEntities = {};
  List<AccountStatusAccessEntity> filteredSortedSelectedEntities = [];

  /// Method Name: [getAccountsStatusEntities]
  ///
  /// Purpose: get all employees account status categorized according to status.
  getAccountsStatusEntities() async {
    Either<Failure, dynamic> result =
        await GetAccountsStatusEntitiesUseCase(repository).execute();
    if (result.isRight()) {
      accountStatusEntities = result.getOrElse(() => {});
      filteredSortedSelectedEntities = accountStatusEntities[selectedStatus]!;
      update();
    }
  }

  /// Method Name: [sortAccountsStatusEntities]
  ///
  /// Purpose: sort account status entities according to the selected option.
  sortAccountsStatusEntities(SortOptionRole option) {
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
    print("reach to update ui");
    update();
  }

  /// Method Name: [searchAccountsStatusEntities]
  ///
  /// Purpose: search for account status entities according to the search value.
  searchAccountsStatusEntities(String searchValue, SortOptionRole? option) {
    filteredSortedSelectedEntities = [];
    for (AccountStatusAccessEntity entity
        in accountStatusEntities[selectedStatus]!) {
      if (entity.englishName
              .toLowerCase()
              .contains(searchValue.toLowerCase()) ||
          entity.arabicName.toLowerCase().contains(searchValue.toLowerCase())) {
        filteredSortedSelectedEntities.add(entity);
      }
    }
    if(option != null) {
      sortAccountsStatusEntities(option);
    }
    else {
      update();
    }
  }

  /// Method Name: [selectStatus]
  ///
  /// Purpose: select status to filter account status entities.
  selectStatus(EmployeeStatusEnum newStatus) {
    selectedStatus = newStatus;
    filteredSortedSelectedEntities =
        accountStatusEntities[selectedStatus] ?? [];
    update();
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
      getAccountsStatusEntities();
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
