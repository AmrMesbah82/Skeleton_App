import 'package:dartz/dartz.dart';

import '../../../../core/network/failure_model.dart';
import '../data_source/remote_data_source.dart';
import '../model/department_model.dart';

class DepartmentRepository {
  DepartmentRemoteDataSource departmentRemoteDataSource =
      DepartmentRemoteDataSource();
  getDepartments() async {
    Either<Failure, dynamic> result =
        await departmentRemoteDataSource.getDepartments();
    if (result.isLeft()) return result;
    List<Map<String, dynamic>> departmentsJsons = result.getOrElse(() => []);
    List<DepartmentModelPro> departments =
        departmentsJsons.map((e) => DepartmentModelPro.fromMap(e)).toList();
    return result = Right(departments);
  }
}
