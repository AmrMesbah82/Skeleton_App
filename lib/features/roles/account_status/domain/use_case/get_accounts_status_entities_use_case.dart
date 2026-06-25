import 'package:dartz/dartz.dart';
import 'package:demo_app/features/roles/account_status/data/repository/account_status_repository.dart';
import 'package:demo_app/features/roles/account_status/domain/entity/account_status_access_entity.dart';
import 'package:demo_app/features/onboarding/authentication/domain/enums/employee_status_enum.dart';

import 'package:demo_app/core/network/failure_model.dart';

class GetAccountsStatusEntitiesUseCase {
  AccountStatusRepository repository;

  GetAccountsStatusEntitiesUseCase(this.repository);

  /// Method Name: [execute]
  ///
  /// Purpose: get all employees account status categorized according to status.
  /// ✅ FIXED: Prevent double-counting users with scheduled dates
  ///
  /// return: [Either<Failure, dynamic>]
  ///                                - Failure: if there is an error in the process or  [Map< EmployeeStatusEnum,AccountStatusAccessEntity>] data.
  Future<Either<Failure, dynamic>> execute() async {
    Either<Failure, dynamic> result =
    await repository.getAccountsStatusEntities();
    if (result.isLeft()) result;
    List<AccountStatusAccessEntity> entities = result.getOrElse(() => []);
    Map<EmployeeStatusEnum, List<AccountStatusAccessEntity>> map = {};

    for (EmployeeStatusEnum status in EmployeeStatusEnum.values) {
      map[status] = [];
    }


    for (AccountStatusAccessEntity entity in entities) {
      // ✅ FIXED: Determine the PRIMARY status category
      EmployeeStatusEnum primaryCategory;

      // Priority order: willBeActivated > willBeDeactivated > actual status
      if (entity.willBeActivated) {
        primaryCategory = EmployeeStatusEnum.willBeActivated;
      } else if (entity.willBeDeactivated) {
        primaryCategory = EmployeeStatusEnum.willBeDeactivated;
      } else {
        primaryCategory = entity.status;
      }

      // ✅ Add to PRIMARY category only (never double-add)
      map[primaryCategory]!.add(entity);

      // ✅ ALWAYS add to "All" category
      map[EmployeeStatusEnum.all]!.add(entity);
    }

    map.forEach((status, list) {
      if (list.isNotEmpty) {
      }
    });

    int totalExcludingAll = map.entries
        .where((entry) => entry.key != EmployeeStatusEnum.all)
        .fold<int>(0, (sum, entry) => sum + entry.value.length);

    int allCount = map[EmployeeStatusEnum.all]?.length ?? 0;


    if (totalExcludingAll == allCount) {
    } else {
    }

    result = Right(map);
    return result;
  }
}