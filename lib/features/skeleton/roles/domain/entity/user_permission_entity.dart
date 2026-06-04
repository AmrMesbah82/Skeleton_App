import 'package:get/get.dart';
import 'package:demo_app/core/helper/employee_helper.dart';
import 'package:demo_app/features/skeleton/roles/utils/user_access_status.dart';
import 'package:demo_app/features/skeleton/roles/presentation/controller/role_cubit.dart';

import '../../../../external/main_core/features/department/presentation/controller/add_department_controller.dart';
import '../../../../external/main_core/features/employee/domain/entities/employee_entity.dart';

class UserPermissionEntity {
  String employeeEmail;
  String imagePath;
  String employeeId;
  String? gender;
  String englishName;
  String arabicName;
  String? accessName;
  String? grantorEnglishName;
  String? grantorArabicName;
  String? startDate;
  String? endDate;
  UserAccessStatus accessStatus;
  String? departmentId;
  String? arabicJobTitle;
  String? englishJobTitle;

  UserPermissionEntity(
      {required this.imagePath,
        required this.employeeEmail,
        required this.employeeId,
        required this.gender,
        required this.englishName,
        required this.arabicName,
        required this.accessName,
        required this.grantorEnglishName,
        required this.grantorArabicName,
        required this.startDate,
        required this.accessStatus,
        this.departmentId,
        this.arabicJobTitle,
        this.englishJobTitle,
        required this.endDate});

  String get userName =>
      Get.locale.toString().contains('en') ? englishName : arabicName;

  String get grantorName => Get.locale.toString().contains('en')
      ? (grantorEnglishName ?? "")
      : (grantorArabicName ?? "");

  /// ✅ NEW: Get localized role name from RoleCubit
  String getLocalizedRoleName() {
    // Handle null or empty accessName
    if (accessName == null || accessName!.isEmpty) {
      return 'No Role';
    }

    try {
      final roleCubit = Get.find<RoleCubit>();
      final role = roleCubit.roles.firstWhereOrNull(
              (r) => r.roleId == accessName || r.currentRoleName == accessName
      );

      if (role != null) {
        // Return localized role name based on current language
        return Get.locale?.languageCode == 'ar'
            ? (role.currentRoleNameAr ?? role.currentRoleName)
            : role.currentRoleName;
      }

      return accessName!;
    } catch (e) {
      print('⚠️ Error getting localized role name: $e');
      // If RoleCubit is not available, return the accessName directly
      return accessName!.isEmpty ? 'No Role' : accessName!;
    }
  }

  static UserPermissionEntity fromEmployeeEntity(EmployeeEntityPro employee) {
    return UserPermissionEntity(
      employeeEmail: employee.email!,
      employeeId: employee.id!,
      gender: employee.gender,
      imagePath: EmployeeHelper.getEmployeeImage(employee: employee),
      englishName: employee.firstName! + ' ' + employee.lastName!,
      arabicName:
      employee.firstNameInArabic! + ' ' + employee.lastNameInArabic!,
      accessName: null,
      grantorEnglishName: null,
      grantorArabicName: null,
      startDate: null,
      accessStatus: UserAccessStatus.all,
      endDate: null,
      departmentId: employee.departmentId,
      arabicJobTitle: employee.titleInArabic,
      englishJobTitle: employee.title,
    );
  }

  String departmentName (bool isArabic){
    if(departmentId== null) return '';
    return isArabic?(Get.find<MainCoreDepartmentController>().getArabicDepartmentNameFromDepartmentId(departmentId: departmentId!)??""):(Get.find<MainCoreDepartmentController>().getEnglishDepartmentNameFromDepartmentId(departmentId: departmentId!)??"");
  }

  String jobTitle (bool isArabic){
    return (isArabic ? arabicJobTitle : englishJobTitle)??'';
  }
}