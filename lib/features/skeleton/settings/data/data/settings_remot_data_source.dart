import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:demo_app/core/network/api_constants.dart';
import 'package:demo_app/core/services/firebase/repository/firebase_repository.dart';
import 'package:demo_app/features/external/main_core/features/employee/data/models/emplyees_model/new_employee_model.dart';
import 'package:demo_app/features/skeleton/employees/data/models/new_employee_model/emplyees_model/new_employee_model.dart';
class SettingsRemoteDataSource{
  updateEmployeeModel({required employeeId,required NewEmployeeModelHistory employee})
  async {
    return await FirebaseRepository.setDocumentWithId(
        collection: ApiConstants.employeesProfile,
        data: employee.toMap(),
        documentId: employeeId);
  }
}
