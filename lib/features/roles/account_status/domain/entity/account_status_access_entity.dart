/// **************************** FILE INFO ****************************
/// File: account_status_access_entity.dart
/// Purpose: Account status access entity to isolate employee model from account status ui.
/// Author: Mohamed Elrashidy
/// Date: 22/1/2025

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/onboarding/authentication/domain/enums/employee_status_enum.dart';

import 'package:demo_app/features/employee/data/models/emplyees_model/new_employee_model.dart';
import 'package:demo_app/features/roles/role_management/utils/constants.dart';

class AccountStatusAccessEntity {
  String employeeId;
  String email;
  EmployeeStatusEnum status;
  String? photoUrl;
  DateTime? firstLogin;
  DateTime? lastLogin;
  DateTime? deactivationDate;
  DateTime? reactivationDate;
  String tempPassword;
  String englishName;
  String arabicName;
  String department;
  String englishTitle;
  String arabicTitle;
  String expirationTimeOfPassword;
  String expirationTimeUnit;

  AccountStatusAccessEntity({
    required this.employeeId,
    required this.email,
    required this.status,
    required this.firstLogin,
    required this.lastLogin,
    required this.tempPassword,
    required this.reactivationDate,
    required this.englishName,
    required this.arabicName,
    required this.department,
    required this.arabicTitle,
    required this.englishTitle,
    required this.expirationTimeOfPassword,
    required this.photoUrl,
    required this.deactivationDate,
    required this.expirationTimeUnit,
  });

  static AccountStatusAccessEntity fromEmployeeModelHistory(
      NewEmployeeModelHistory employeeModel) {
    String? photo;

    if (employeeModel.photo.isNotEmpty) {
      String lastPhoto = employeeModel.photo.last;
      if (lastPhoto.isNotEmpty &&
          lastPhoto != "[]" &&
          lastPhoto.trim().isNotEmpty) {
        photo = lastPhoto;
      }
    }

    if (photo == null || photo.isEmpty) {
      if (employeeModel.gender.isNotEmpty &&
          employeeModel.gender.last.toLowerCase() == "female") {
        photo = 'assets/images/female_avatar.png';
      } else {
        photo = 'assets/images/male_avatar.png';
      }
    }

    AccountStatusAccessEntity accessEntity = AccountStatusAccessEntity(
      email: employeeModel.email.isNotEmpty ? employeeModel.email.last : '',
      reactivationDate: employeeModel.activationDate == null
          ? null
          : _parseDateFlexible(employeeModel.activationDate!),
      arabicTitle: employeeModel.titleInArabic.isNotEmpty
          ? employeeModel.titleInArabic.last
          : '',
      englishTitle:
      employeeModel.title.isNotEmpty ? employeeModel.title.last : '',
      deactivationDate: employeeModel.deactivationDate == null
          ? null
          : _parseDateFlexible(employeeModel.deactivationDate!),
      photoUrl: photo,
      employeeId: employeeModel.id ?? '',
      status: employeeModel.status.isNotEmpty
          ? EmployeeStatusEnum.values.firstWhere(
            (element) => element.name == employeeModel.status.last,
        orElse: () => EmployeeStatusEnum.inactive,
      )
          : EmployeeStatusEnum.inactive,
      firstLogin: employeeModel.firstLogin == null
          ? null
          : _parseDateFlexible(employeeModel.firstLogin!),
      lastLogin: employeeModel.lastLogin == null
          ? null
          : _parseDateFlexible(employeeModel.lastLogin!),
      tempPassword: employeeModel.defaultPassword ?? '',
      englishName:
      employeeModel.firstName.isNotEmpty && employeeModel.lastName.isNotEmpty
          ? "${employeeModel.firstName.last} ${employeeModel.lastName.last}"
          : '',
      arabicName: employeeModel.firstNameInArabic.isNotEmpty &&
          employeeModel.lastNameInArabic.isNotEmpty
          ? "${employeeModel.firstNameInArabic.last} ${employeeModel.lastNameInArabic.last}"
          : '',
      expirationTimeOfPassword: employeeModel.passwordExpirationTime ?? "12",
      expirationTimeUnit: employeeModel.passwordExpirationUnit ?? "Week",
      department: employeeModel.departmentId.isNotEmpty
          ? employeeModel.departmentId.last
          : '',
    );

    return accessEntity;
  }

  String departmentName(bool isArabic) {
    if (isArabic) {
      return Get.find<MainCoreDepartmentController>()
          .getArabicDepartmentNameFromDepartmentId(
          departmentId: department) ??
          "";
    } else {
      return Get.find<MainCoreDepartmentController>()
          .getEnglishDepartmentNameFromDepartmentId(
          departmentId: department) ??
          "";
    }
  }

  String jobTitle(bool isArabic) => isArabic ? arabicTitle : englishTitle;

  // ── Formatted date getters (locale-aware) ─────────────────────────────────

  static const _enMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _arMonths = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  /// Formats a DateTime as "23 Aug 2026" (EN) or "23 أغسطس 2026" (AR).
  /// Always uses Western numerals regardless of locale.
  static String _formatDateTime(DateTime? dt, bool isArabic) {
    if (dt == null) return '-';
    final day  = dt.day.toString().padLeft(2, '0');
    final month = isArabic ? _arMonths[dt.month - 1] : _enMonths[dt.month - 1];
    final year = dt.year.toString();
    return '$day $month $year';
  }

  /// "23 Aug 2026"  /  "23 أغسطس 2026"
  String firstLoginDateFormatted(bool isArabic) =>
      _formatDateTime(firstLogin, isArabic);

  /// "23 Aug 2026"  /  "23 أغسطس 2026"
  String lastLoginDateFormatted(bool isArabic) =>
      _formatDateTime(lastLogin, isArabic);

  /// "23 Aug 2026"  /  "23 أغسطس 2026"
  String deactivationDateFormatted(bool isArabic) =>
      _formatDateTime(deactivationDate, isArabic);

  // ── Raw getters kept for backward compatibility ───────────────────────────
  String get firstLoginDate =>
      firstLogin == null ? '' : DateFormat('yyyy-MM-dd').format(firstLogin!);
  String get firstLoginTime =>
      firstLogin == null ? '' : DateFormat('hh:mm a').format(firstLogin!);
  String get lastLoginDate =>
      lastLogin == null ? '' : DateFormat('yyyy-MM-dd').format(lastLogin!);
  String get lastLoginTime =>
      lastLogin == null ? '' : DateFormat('hh:mm a').format(lastLogin!);
  String get deactivationDateDate => deactivationDate == null
      ? ''
      : DateFormat('yyyy-MM-dd').format(deactivationDate!);
  String get deactivationTime => deactivationDate == null
      ? ''
      : DateFormat('hh:mm a').format(deactivationDate!);

  // ── Status helpers ────────────────────────────────────────────────────────
  bool get isActive         => status == EmployeeStatusEnum.active;
  bool get isInactive       => status == EmployeeStatusEnum.inactive;
  bool get isRequestToReset => status == EmployeeStatusEnum.resetPassword;
  bool get isLockedWithRequest =>
      status == EmployeeStatusEnum.lockedWithRequest;
  bool get isLocked      => status == EmployeeStatusEnum.locked;
  bool get isDeactivated => status == EmployeeStatusEnum.deactivated;
  bool get willBeDeactivated => deactivationDate != null;
  bool get willBeActivated   => reactivationDate != null;

  static void _applyScheduledStatusChanges(
      AccountStatusAccessEntity accessEntity) {
    final now = DateTime.now();
    if (accessEntity.isActive && accessEntity.deactivationDate != null) {
      if (now.isAfter(accessEntity.deactivationDate!)) {
        accessEntity.status = EmployeeStatusEnum.deactivated;
      }
    }
    if ((accessEntity.isInactive || accessEntity.isDeactivated) &&
        accessEntity.reactivationDate != null) {
      if (now.isAfter(accessEntity.reactivationDate!)) {
        accessEntity.status = EmployeeStatusEnum.active;
      }
    }
  }

  static DateTime? _parseDateFlexible(String dateString) {
    if (dateString.isEmpty) return null;

    final strategies = [
          () => DateTime.parse(dateString),
          () => DateFormat('MMM dd, yyyy', 'en').parse(dateString),
          () => DateFormat(Constants.userAccessDateFormat, 'en').parse(dateString),
          () => DateFormat('dd MMMM yyyy, hh:mm a', 'en').parse(dateString),
          () => DateFormat('yyyy-MM-dd').parse(dateString),
    ];

    for (var strategy in strategies) {
      try {
        return strategy();
      } catch (_) {
        continue;
      }
    }

    return null;
  }
}