// File: create_services_helper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/network/api_constants.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';

class CreateServicesHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Get company ID from ApiConstants.baseUri
  static String _getCompanyId() {
    String baseUri = ApiConstants.baseUri;

    if (baseUri.isEmpty) {
      return '';
    }

    if (baseUri.startsWith('Demo/')) {
      String companyId = baseUri.substring(5);
      return companyId;
    }

    return baseUri;
  }

  /// ✅ Helper to extract value from array or return as-is
  static String _extractFromArray(dynamic value) {
    if (value == null) return '';

    if (value is List) {
      if (value.isEmpty) return '';
      final extracted = value[0];
      return extracted?.toString() ?? '';
    }

    return value.toString();
  }

  /// ✅ Get requester information from MainCoreEmployeeController
  static Map<String, String> getRequesterInfo({
    required String emailRequester,
  }) {
    try {
      final employeeController = Get.find<MainCoreEmployeeController>();
      final departmentController = Get.find<MainCoreDepartmentController>();

      final employee = employeeController.mapOfEmployeesWithEmailKey[emailRequester];

      if (employee != null) {
        final departmentId = employee.departmentId;

        final departmentEnglish = departmentId != null
            ? departmentController.getEnglishDepartmentNameFromDepartmentId(
          departmentId: departmentId,
        ) ?? ''
            : '';

        final departmentArabic = departmentId != null
            ? departmentController.getArabicDepartmentNameFromDepartmentId(
          departmentId: departmentId,
        ) ?? ''
            : '';

        final requesterNameEnglish = "${employee.firstName ?? ''} ${employee.lastName ?? ''}".trim();
        final requesterNameArabic = "${employee.firstNameInArabic ?? ''} ${employee.lastNameInArabic ?? ''}".trim();

        final jobTitleEnglish = employee.title ?? '';
        final jobTitleArabic = employee.titleInArabic ?? '';

        final gender = employee.gender ?? '';

        return {
          'requesterName': requesterNameEnglish,
          'requesterNameArabic': requesterNameArabic,
          'department': departmentEnglish,
          'departmentArabic': departmentArabic,
          'jobTitle': jobTitleEnglish,
          'jobTitleArabic': jobTitleArabic,
          'gender': gender,
        };
      } else {
        return {
          'requesterName': '',
          'requesterNameArabic': '',
          'department': '',
          'departmentArabic': '',
          'jobTitle': '',
          'jobTitleArabic': '',
          'gender': '',
        };
      }
    } catch (e) {
      return {
        'requesterName': '',
        'requesterNameArabic': '',
        'department': '',
        'departmentArabic': '',
        'jobTitle': '',
        'jobTitleArabic': '',
        'gender': '',
      };
    }
  }

  /// ✅ COMPLETE UPDATED FUNCTION - Fetches from CreateServices collection
  static Future<Map<String, String>> getServiceDetailsFromCreateServices({
    required String parentServiceId,
    required String emailRequester,
  }) async {
    try {

      // Default result
      Map<String, String> result = {
        'serviceNameEnglish': '',
        'serviceNameArabic': '',
        'serviceDescriptionEnglish': '',
        'serviceDescriptionArabic': '',
        'duration': '',
        'unit': '',
        'requesterName': '',
        'requesterNameArabic': '',
        'department': '',
        'departmentArabic': '',
        'jobTitle': '',
        'jobTitleArabic': '',
        'gender': '',
      };

      // ✅ STEP 1: Get requester info from controllers (ALWAYS)
      if (emailRequester.isNotEmpty) {
        final requesterInfo = getRequesterInfo(emailRequester: emailRequester);
        result.addAll(requesterInfo);

      }

      if (parentServiceId.isEmpty) {
        return result;
      }

      final companyId = _getCompanyId();

      if (companyId.isEmpty) {
        return result;
      }

      // ✅ STEP 2: Try to fetch from CreateServices using Parent_Service_Id
      final docPath = '/Demo/$companyId/CreateServices/$parentServiceId'; // ✅ FIXED: Changed to CreateServices

      DocumentSnapshot? docSnapshot;

      try {
        docSnapshot = await _firestore.doc(docPath).get();

        if (docSnapshot.exists) {
        } else {

          // ✅ STEP 3: Search by Email_Requester if direct lookup fails
          final querySnapshot = await _firestore
              .collection('/Demo/$companyId/CreateServices')
              .where('Email_Requester', arrayContains: emailRequester)
              .limit(1)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            docSnapshot = querySnapshot.docs.first;
          } else {
            return result;
          }
        }
      } catch (e) {
        return result;
      }

      if (!docSnapshot.exists) {
        return result;
      }

      final data = docSnapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        return result;
      }

      // ✅ STEP 4: Extract service data from Firebase
      result['serviceNameEnglish'] = data.containsKey('Service_Name_English')
          ? _extractFromArray(data['Service_Name_English'])
          : data.containsKey('serviceNameEnglish')
          ? _extractFromArray(data['serviceNameEnglish'])
          : '';

      result['serviceNameArabic'] = data.containsKey('Service_Name_Arabic')
          ? _extractFromArray(data['Service_Name_Arabic'])
          : data.containsKey('serviceNameArabic')
          ? _extractFromArray(data['serviceNameArabic'])
          : '';

      result['serviceDescriptionEnglish'] = data.containsKey('Service_Description_English')
          ? _extractFromArray(data['Service_Description_English'])
          : data.containsKey('serviceDescriptionEnglish')
          ? _extractFromArray(data['serviceDescriptionEnglish'])
          : '';

      result['serviceDescriptionArabic'] = data.containsKey('Service_Description_Arabic')
          ? _extractFromArray(data['Service_Description_Arabic'])
          : data.containsKey('serviceDescriptionArabic')
          ? _extractFromArray(data['serviceDescriptionArabic'])
          : '';

      result['duration'] = data.containsKey('Duration_Of_Services')
          ? _extractFromArray(data['Duration_Of_Services'])
          : data.containsKey('durationOfServices')
          ? _extractFromArray(data['durationOfServices'])
          : '';

      result['unit'] = data.containsKey('Selected_Duration_Unit')
          ? _extractFromArray(data['Selected_Duration_Unit'])
          : data.containsKey('selectedDurationUnit')
          ? _extractFromArray(data['selectedDurationUnit'])
          : '';

      return result;

    } catch (e, stackTrace) {

      // Still return requester info even if service fetch fails
      final requesterInfo = getRequesterInfo(emailRequester: emailRequester);

      return {
        'serviceNameEnglish': '',
        'serviceNameArabic': '',
        'serviceDescriptionEnglish': '',
        'serviceDescriptionArabic': '',
        'duration': '',
        'unit': '',
        'requesterName': requesterInfo['requesterName']!,
        'requesterNameArabic': requesterInfo['requesterNameArabic']!,
        'department': requesterInfo['department']!,
        'departmentArabic': requesterInfo['departmentArabic']!,
        'jobTitle': requesterInfo['jobTitle']!,
        'jobTitleArabic': requesterInfo['jobTitleArabic']!,
        'gender': requesterInfo['gender']!,
      };
    }
  }
}