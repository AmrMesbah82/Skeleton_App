/// ************************* FILE INFO *************************
/// File: employee_mixin_remote_data_source.dart
/// Purpose: contains all employees queries that used in different features
/// Author: Mohamed Elrashidy
/// Date: 22/1/2025
/// Updated: Fixed to use Employees_Info collection explicitly

import 'package:demo_app/core/network/api_constants.dart';
import 'package:demo_app/core/services/firebase/repository/firebase_repository.dart';

import '../../../employee/data/models/emplyees_model/new_employee_model.dart';

mixin EmployeeMixinRemoteDataSource {
  /// Get all employees from Employees_Info collection
  /// Returns: Either<Failure, List<Map<String, dynamic>>>
  getEmployees() async {
    // ✅ FIXED: Explicitly use correct collection path
    return await FirebaseRepository.getCollection(
        collectionPath: 'Demo/84763782/Employees_Info');
  }

  /// Get single employee by ID from Employees_Info collection
  /// Returns: Either<Failure, Map<String, dynamic>>
  getEmployeeModel(String employeeId) async {
    print('📥 Getting employee model for ID: $employeeId');
    print('   Collection: Demo/84763782/Employees_Info');

    // ✅ FIXED: Explicitly use correct collection path
    return await FirebaseRepository.getDocumentWithId(
        collection: 'Demo/84763782/Employees_Info',
        documentId: employeeId);
  }

  /// Update employee in Employees_Info collection
  /// Uses NewEmployeeModelHistory with versioned history tracking
  updateEmployeeModel(NewEmployeeModelHistory employeeModel) async {
    print('💾 UPDATING employee in Employees_Info collection');
    print('   Document ID: ${employeeModel.id}');
    print('   Collection: Demo/84763782/Employees_Info');

    // ✅ FIXED: Explicitly use correct collection path
    var result = await FirebaseRepository.setDocumentWithId(
        collection: 'Demo/84763782/Employees_Info',
        data: employeeModel.toMap(),
        documentId: employeeModel.id!);

    if (result.isRight()) {
      print('✅ Successfully updated in Employees_Info collection');
    } else {
      print('❌ Failed to update in Employees_Info collection');
    }

    return result;
  }
}