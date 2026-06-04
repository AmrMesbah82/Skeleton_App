import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/network/failure_model.dart';
import '../../../../../feature/controller/notification_controller.dart';
import '../../data/repository/user_role_repository.dart';
import '../entity/user_permission_entity.dart';

import 'package:dartz/dartz.dart';
import 'package:demo_app/core/network/failure_model.dart';
import 'package:demo_app/features/skeleton/roles/data/repository/user_role_repository.dart';
import 'package:demo_app/features/skeleton/roles/domain/entity/user_permission_entity.dart';

class DeleteUserPermissionUseCase {
  final UserManagementAccessRepository repository;

  DeleteUserPermissionUseCase(this.repository);

  Future<Either<Failure, dynamic>> execute({
    required UserPermissionEntity permission,
    required String employeeEmail,
    required String currentUserEmail,
  }) async {
    return await repository.deleteEmployeePermission(
      employeeId: permission.employeeId,
      currentUserEmail: currentUserEmail,
    );
  }
}