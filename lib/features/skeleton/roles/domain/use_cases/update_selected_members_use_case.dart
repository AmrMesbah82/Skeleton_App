import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/controllers/notification_controller.dart';
import 'package:demo_app/features/skeleton/roles/data/repository/user_role_repository.dart';

import '../../../../../core/helper/date_time_in_arabic.dart';
import '../../../../../core/network/failure_model.dart';
import '../../../../external/main_core/features/employee/domain/entities/employee_entity.dart';
import '../../../employees/data/models/new_employee_model/emplyees_model/new_employee_model.dart';

import 'package:dartz/dartz.dart';
import 'package:demo_app/core/network/failure_model.dart';
import 'package:demo_app/features/skeleton/roles/data/repository/user_role_repository.dart';
import 'package:demo_app/features/external/main_core/features/employee/domain/entities/employee_entity.dart';

class UpdateSelectedMembersUseCase {
  final UserManagementAccessRepository repository;

  UpdateSelectedMembersUseCase(this.repository);

  Future<Either<Failure, dynamic>> execute({
    required String currentUserEmail,
    required String accessName,
    required String startDate,
    required String endDate,
    required List<EmployeeEntityPro> selectedMembers,
  }) async {
    return await repository.updateSelectedMembersPermission(
      currentUserEmail: currentUserEmail,
      accessName: accessName,
      startDate: startDate,
      endDate: endDate,
      selectedMembers: selectedMembers,
    );
  }
}