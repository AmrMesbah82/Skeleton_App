/// ***************************** FILE INFO ***************************** ///
/// File Name: service_requester_data_helper.dart
/// Purpose: Helper class to fetch and display service requester information
/// Created: Jan 16, 2026
/// Description: Fetches job title and department from MainCoreEmployeeController
///              and MainCoreDepartmentController based on email requester
/// ********************************************************************* ///

import 'package:get/get.dart';

import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';

class ServiceRequesterDataHelper {
  /// Extracts the email from the Firebase array structure
  /// Firebase stores: emailRequester (array) -> 0 -> "email@domain.com" (string)
  static String getEmailFromArray(dynamic emailRequesterArray) {
    if (emailRequesterArray == null) return '';

    if (emailRequesterArray is List && emailRequesterArray.isNotEmpty) {
      return emailRequesterArray.last.toString();
    }

    if (emailRequesterArray is String) {
      return emailRequesterArray;
    }

    return '';
  }

  /// Extracts department ID from the Firebase array structure
  static String getDepartmentFromArray(dynamic departmentArray) {
    if (departmentArray == null) return '';

    if (departmentArray is List && departmentArray.isNotEmpty) {
      return departmentArray.last.toString();
    }

    if (departmentArray is String) {
      return departmentArray;
    }

    return '';
  }

  /// Gets the job title for a service requester
  /// Returns the localized job title based on current language
  static String getJobTitle({
    required String emailRequester,
    required MainCoreEmployeeController employeeController,
  }) {
    try {
      // Clean the email
      String cleanEmail = getEmailFromArray(emailRequester);

      if (cleanEmail.isEmpty) {
        return '-';
      }

      // Get employee from the map
      EmployeeEntityPro? employee = employeeController.mapOfEmployeesWithEmailKey[cleanEmail];

      if (employee == null) {
        return '-';
      }

      // Return localized job title
      bool isEnglish = Get.locale.toString().contains('en');
      String jobTitle = isEnglish
          ? (employee.title ?? '-')
          : (employee.titleInArabic ?? '-');

      return jobTitle;
    } catch (e) {
      return '-';
    }
  }

  /// Gets the department name for a service requester
  /// Returns the localized department name based on current language
  static String getDepartmentName({
    required String emailRequester,
    required MainCoreEmployeeController employeeController,
    required MainCoreDepartmentController departmentController,
  }) {
    try {
      // Clean the email
      String cleanEmail = getEmailFromArray(emailRequester);

      if (cleanEmail.isEmpty) {
        return '-';
      }

      // Get employee from the map
      EmployeeEntityPro? employee = employeeController.mapOfEmployeesWithEmailKey[cleanEmail];

      if (employee == null) {
        return '-';
      }

      // Get department ID
      String? departmentId = employee.departmentId;

      if (departmentId == null || departmentId.isEmpty) {
        return '-';
      }

      // Return localized department name
      bool isEnglish = Get.locale.toString().contains('en');
      String? departmentName = departmentController.getDepartmentName(departmentId, isEnglish);

      return departmentName ?? '-';
    } catch (e) {
      return '-';
    }
  }

  /// Gets complete requester information for a service request
  /// Returns a map with all relevant requester details
  static Map<String, String> getRequesterInfo({
    required dynamic serviceData,
    required MainCoreEmployeeController employeeController,
    required MainCoreDepartmentController departmentController,
  }) {
    try {
      // Extract email from array
      String emailRequester = getEmailFromArray(serviceData['emailRequester']);

      if (emailRequester.isEmpty) {
        return {
          'email': '-',
          'jobTitle': '-',
          'department': '-',
          'firstName': '-',
          'lastName': '-',
        };
      }

      // Get employee
      EmployeeEntityPro? employee = employeeController.mapOfEmployeesWithEmailKey[emailRequester];

      if (employee == null) {
        // Fallback to Firebase stored data
        return {
          'email': emailRequester,
          'jobTitle': getEmailFromArray(serviceData['jobTitleRequester']) ?? '-',
          'department': getEmailFromArray(serviceData['departmentRequester']) ?? '-',
          'firstName': getEmailFromArray(serviceData['firstNameRequester']) ?? '-',
          'lastName': getEmailFromArray(serviceData['lastNameRequester']) ?? '-',
        };
      }

      // Get localized data
      bool isEnglish = Get.locale.toString().contains('en');

      String jobTitle = isEnglish
          ? (employee.title ?? '-')
          : (employee.titleInArabic ?? '-');

      String departmentName = '-';
      if (employee.departmentId != null && employee.departmentId!.isNotEmpty) {
        departmentName = departmentController.getDepartmentName(
            employee.departmentId!,
            isEnglish
        ) ?? '-';
      }

      String firstName = isEnglish
          ? (employee.firstName ?? '-')
          : (employee.firstNameInArabic ?? '-');

      String lastName = isEnglish
          ? (employee.lastName ?? '-')
          : (employee.lastNameInArabic ?? '-');

      return {
        'email': emailRequester,
        'jobTitle': jobTitle,
        'department': departmentName,
        'firstName': firstName,
        'lastName': lastName,
        'fullName': '$firstName $lastName',
      };
    } catch (e) {
      return {
        'email': '-',
        'jobTitle': '-',
        'department': '-',
        'firstName': '-',
        'lastName': '-',
      };
    }
  }

  /// Validates if employee and department controllers are properly initialized
  static bool controllersAreReady({
    required MainCoreEmployeeController employeeController,
    required MainCoreDepartmentController departmentController,
  }) {
    bool employeeReady = employeeController.mapOfEmployeesWithEmailKey.isNotEmpty;
    bool departmentReady = departmentController.departmentModels.isNotEmpty;

    return employeeReady && departmentReady;
  }
}