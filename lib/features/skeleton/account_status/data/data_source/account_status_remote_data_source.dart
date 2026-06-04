import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:demo_app/core/network/api_constants.dart';
import 'package:demo_app/core/services/firebase/repository/firebase_repository.dart';

import '../../../../../core/network/failure_model.dart';
import '../../../../external/main_core/core/networking/get_base_url.dart';
import '../../../../external/main_core/features/employee/data/models/emplyees_model/new_employee_model.dart';
import '../../../authentication/data/models/demo_user_account_overview.dart';
import '../../../mixin_feature/data/employee_mixin_remote_data_source.dart';

class AccountStatusRemoteDataSource with EmployeeMixinRemoteDataSource {
  WriteBatch _batch = FirebaseFirestore.instance.batch();

  /// Get all employees from Employees_Info collection
  /// getEmployees - ✅ FIXED: Now fetches from server to avoid stale cache
  @override
  Future<Either<Failure, dynamic>> getEmployees() async {
    try {
      print('🔍 Fetching employees from Employees_Info (SERVER SOURCE)...');

      // ✅ CRITICAL FIX: Force server read to get latest data after updates
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl('Employees_Info'))
          .get(GetOptions(source: Source.server));  // ← Force server read!

      print('✅ Found ${querySnapshot.docs.length} employees (from server)');

      List<Map<String, dynamic>> employees = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['Id'] = doc.id;

        // ✅ Debug: Print status for verification
        if (data['Status'] != null && data['Status'] is List) {
          List<dynamic> statusList = data['Status'] as List;
          if (statusList.isNotEmpty) {
            print('   ${doc.id}: status = ${statusList.last}');
          }
        }

        employees.add(data);
      }

      return Right(employees);
    } catch (e) {
      print('❌ Error: $e');
      return Left(FirebaseFailure(e.toString()));
    }
  }

  /// ✅ ADD THIS METHOD - Get single employee by ID
  Future<Either<Failure, dynamic>> getEmployeeModel(String employeeId) async {
    try {
      print('📥 Getting employee model for ID: $employeeId');
      String collectionPath = getBaseUrl('Employees_Info');
      print('   Collection: $collectionPath');

      // ✅ Force server read to get fresh data
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(employeeId)
          .get(GetOptions(source: Source.server));

      if (!docSnapshot.exists) {
        print('❌ Employee document does not exist: $employeeId');
        return Left(FirebaseFailure('Employee not found'));
      }

      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      data['Id'] = employeeId;  // ✅ Ensure ID is in the data

      print('✅ Successfully retrieved employee data');
      print('   Status: ${data['Status']}');
      print('   timestamps: ${data['timestamps']}');

      return Right(data);
    } catch (e) {
      print('❌ Error getting employee model: $e');
      return Left(FirebaseFailure(e.toString()));
    }
  }

  /// ✅ ADD THIS METHOD - Update employee model
  Future<Either<Failure, dynamic>> updateEmployeeModel(
      NewEmployeeModelHistory employeeModel) async {
    try {
      print('💾 Updating employee model: ${employeeModel.id}');
      String collectionPath = getBaseUrl('Employees_Info');

      Map<String, dynamic> dataToSave = employeeModel.toMap();

      print('📤 Data being saved:');
      print('   Status: ${dataToSave['Status']}');
      print('   timestamps: ${dataToSave['timestamps']}');

      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(employeeModel.id)
          .set(dataToSave, SetOptions(merge: true));

      print('✅ Employee model updated successfully');
      return Right(null);
    } catch (e) {
      print('❌ Error updating employee model: $e');
      return Left(FirebaseFailure(e.toString()));
    }
  }

  getDemoUserAccount(String email) async {
    return await FirebaseRepository.getDocumentWithId(
        collection: ApiConstants.demoUsersAccounts, documentId: email);
  }

  startTransaction() {
    _batch = FirebaseFirestore.instance.batch();
  }

  updateEmployeeWithinTransaction(NewEmployeeModelHistory employeeModel) {
    _batch.update(
        FirebaseFirestore.instance
            .collection(getBaseUrl('Employees_Info'))
            .doc(employeeModel.id!),
        employeeModel.toMap());
    print('Employee Updated');
  }

  updateDemoUsersAccountWithinTransaction(
      String email, Map<String, dynamic> data) {
    _batch.update(
        FirebaseFirestore.instance
            .collection(ApiConstants.demoUsersAccounts)
            .doc(email),
        data);
    print('Demo User Account Updated');
  }

  commitTransaction() async {
    Either<FirebaseFailure, dynamic> result;
    try {
      await _batch.commit();
      print('Transaction Completed');
      result = Right(null);
    } catch (e) {
      print('Transaction Failed $e');
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }
}