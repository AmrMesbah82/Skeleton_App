/// ***************************** FILE INFO ***************************** ///
/// File Name: main_core_department_controller.dart
/// Purpose: Manages the department data within the application.
/// Author: Mohamed Fouad
/// Created At: Jan/10/2024
/// Last Updated: 17/1/2025
/// Updated By : Mohammed Yasser
/// Description: Controller for adding and managing departments.
/// ********************************************************************* ///

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../../../../../../core/enumeration/enum.dart';
import '../../../../../../../core/network/failure_model.dart';
import '../../data/model/department_model.dart';
import '../../data/repository/department_repository.dart';

class MainCoreDepartmentController extends GetxController with StateMixin {
  DepartmentRepository departmentRepository = DepartmentRepository();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<DepartmentModelPro> departmentModels = [];
  Map<String, String> _departmentsArabicNameFromDepartmentId = {};
  Map<String, String> _departmentsEnglishNameFromDepartmentId = {};
  Map<String, String> _getDepartmentIdFromDepartmentName = {};
  List<String> _departmentsEnglishName = [];
  List<String> _departmentsArabicName = [];
  List<String> _departmentIds = [];
  List<String> get departmentsEnglishName => _departmentsEnglishName;
  List<String> get departmentsArabicName => _departmentsArabicName;
  List<String> get departmentIds => _departmentIds;

  /// Method Name: [getAllDepartments]
  ///
  /// Purpose: get all company departments
  ///
  /// return type: [List<DepartmentModel>]
  Future<List<DepartmentModelPro>> getAllDepartments() async {
    Either<Failure, dynamic> result =
    await departmentRepository.getDepartments();
    if (result.isRight()) departmentModels = result.getOrElse(() => []);
    _getDepartmentMapsFromDepartmentsList(departmentModels);
    _setDepartmentNamesLists(departmentModels);
    return departmentModels;
  }

  /// Method Name: [getDepartmentName]
  ///
  /// Purpose: Fetches the department name based on the department ID.
  ///
  /// Parameters:
  ///            [departmentId] String - The ID of the department.
  String getDepartmentName(String departmentId, bool? isEnglish) {
    if (isEnglish == null) {
      if (Get.locale.toString().contains('en')) {
        return getEnglishDepartmentNameFromDepartmentId(
            departmentId: departmentId)!;
      } else {
        return getArabicDepartmentNameFromDepartmentId(
            departmentId: departmentId)!;
      }
    } else {
      if (isEnglish) {
        return getEnglishDepartmentNameFromDepartmentId(
            departmentId: departmentId)!;
      } else {
        return getArabicDepartmentNameFromDepartmentId(
            departmentId: departmentId)!;
      }
    }
  }

  /// Fetches the department ID based on the department name or its Arabic counterpart.
  /// [departmentName] - Name of the department.
  /// Returns the department ID if found, otherwise "none".
  String getDepartmentId(String departmentName) {
    List<DepartmentModelPro> departmentModel = departmentModels
        .where((element) =>
    element.departmentName == departmentName ||
        element.departmentNameInArabic == departmentName)
        .toList();

    if (departmentModel.isEmpty) {
      return "none";
    } else {
      return departmentModel.first.departmentID!;
    }
  }

  /// Checks if the given abbreviation is contained in the list of known abbreviations.
  /// [abbreviation] - The abbreviation to check.
  /// Returns the abbreviation in uppercase if it is a known abbreviation, otherwise capitalizes it.
  String containAbbreviation(String abbreviation) {
    return capitalize(abbreviation);
  }

  @override
  void onInit() {
    getAllDepartments();
    super.onInit();
  }

  _getDepartmentMapsFromDepartmentsList(List<DepartmentModelPro> departments) {
    _departmentsArabicNameFromDepartmentId = {};
    _departmentsEnglishNameFromDepartmentId = {};
    _getDepartmentIdFromDepartmentName = {};
    for (DepartmentModelPro department in departments) {
      _departmentsArabicNameFromDepartmentId[department.departmentID!] =
      department.departmentNameInArabic!;
      _departmentsEnglishNameFromDepartmentId[department.departmentID!] =
          containAbbreviation(department.departmentName!);
      _getDepartmentIdFromDepartmentName[
      department.departmentName!.toLowerCase()] = department.departmentID!;
      _getDepartmentIdFromDepartmentName[department.departmentNameInArabic!] =
      department.departmentID!;
    }
  }

  _setDepartmentNamesLists(List<DepartmentModelPro> departments) {
    _departmentsArabicName = [];
    _departmentsEnglishName = [];
    _departmentIds = [];
    for (DepartmentModelPro department in departments) {
      _departmentIds.add(department.departmentID!);
      _departmentsArabicName.add(department.departmentNameInArabic!);
      _departmentsEnglishName
          .add(containAbbreviation(department.departmentName!));
    }
  }

  String? getDepartmentIdFromDepartmentName({required String departmentName}) {
    departmentName.toLowerCase();
    return _getDepartmentIdFromDepartmentName[departmentName];
  }

  String? getEnglishDepartmentNameFromDepartmentId(
      {required String departmentId}) {
    return _departmentsEnglishNameFromDepartmentId[departmentId];
  }

  String? getArabicDepartmentNameFromDepartmentId(
      {required String departmentId}) {
    return _departmentsArabicNameFromDepartmentId[departmentId];
  }

  getDepartmentEnglishNameFromArabicName({required String arabicName}) {
    String departmentId =
    getDepartmentIdFromDepartmentName(departmentName: arabicName)!;
    return getEnglishDepartmentNameFromDepartmentId(departmentId: departmentId);
  }

  getDepartmentArabicNameFromEnglishName({required String englishName}) {
    String departmentId = getDepartmentIdFromDepartmentName(
        departmentName: englishName.toLowerCase())!;
    return getArabicDepartmentNameFromDepartmentId(departmentId: departmentId);
  }
}
