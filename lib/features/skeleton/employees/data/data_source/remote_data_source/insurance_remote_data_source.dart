import 'package:dartz/dartz.dart';
import 'package:demo_app/core/network/api_constants.dart';
import 'package:demo_app/core/network/failure_model.dart';
import 'package:demo_app/core/services/firebase/repository/firebase_repository.dart';

///*********************** FILE INFO ****************************
/// Purpose: This file contains the remote data source for insurance data
/// Author: Mohamed Elrashidy
/// created At: 20/11/2024
class InsuranceRemoteDataSource {
  Future<Either<FirebaseFailure, dynamic>> getEmployeeInsuranceData(
      {required String employeeId}) async {
    return await FirebaseRepository.getDocumentWithId(
        collection: ApiConstants.insurance, documentId: employeeId);
  }

  Future<Either<FirebaseFailure, dynamic>> addEmployeeInsuranceData(
      {required String documentId, required Map<String, dynamic> data}) async {
    return await FirebaseRepository.setDocumentWithId(
        collection: ApiConstants.insurance, data: data, documentId: documentId);
  }
}
