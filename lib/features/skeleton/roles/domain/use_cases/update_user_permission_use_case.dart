import 'package:dartz/dartz.dart';
import 'package:demo_app/features/skeleton/roles/data/repository/user_role_repository.dart';
import 'package:demo_app/features/skeleton/roles/domain/entity/new_permission_entity.dart';

import '../../../../../core/network/failure_model.dart';

import 'package:dartz/dartz.dart';
import 'package:demo_app/core/network/failure_model.dart';
import 'package:demo_app/features/skeleton/roles/data/repository/user_role_repository.dart';

class UpdateUserPermissionUseCase {
  final UserManagementAccessRepository repository;

  UpdateUserPermissionUseCase(this.repository);

  Future<Either<Failure, dynamic>> execute({
    required String employeeId,
    required String currentUserEmail,
    String? accessName,
    String? accessBegin,
    String? accessEnd,
  }) async {
    return await repository.updateUserPermission(
      employeeId: employeeId,
      currentUserEmail: currentUserEmail,
      accessName: accessName,
      accessBegin: accessBegin,
      accessEnd: accessEnd,
    );
  }
}
