import 'package:get/get.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employee_hr_profile_components/custom_permissions_table.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

List<Function(bool)> _noopFunctions(List<String> data) =>
    data.map((_) => (bool v) {}).toList();

// ── Home Page ─────────────────────────────────────────────────────────────────

final List<String> _homePageData = [
  'Employees Attendance'.tr,
  'Pending Projects'.tr,
  'In Progress Projects'.tr,
  'Done Projects'.tr,
  'Project Performance'.tr,
  'Create Task from Home Page'.tr,
  'Create Meeting from Home Page'.tr,
  'Task Reminder'.tr,
  'Task Details'.tr,
];

final CustomPermissionsTableWidget homePageWidget = CustomPermissionsTableWidget(
  initialData: _homePageData,
  currentValues: List.generate(_homePageData.length, (_) => false),
  functionsList: _noopFunctions(_homePageData),
  title: 'home',
);

// ── Employee Page ─────────────────────────────────────────────────────────────

final List<String> _employeeData = [
  'Filter'.tr,
  'Add Employee'.tr,
  'Custom Table'.tr,
  'See More'.tr,
];

final CustomPermissionsTableWidget employeeDataWidget = CustomPermissionsTableWidget(
  initialData: _employeeData,
  currentValues: List.generate(_employeeData.length, (_) => false),
  functionsList: _noopFunctions(_employeeData),
  title: 'employee',
);

// ── Chat Page ─────────────────────────────────────────────────────────────────

final List<String> _chatData = [
  'Create Group'.tr,
  'Add Member'.tr,
  'Remove Member'.tr,
  'Delete Message'.tr,
];

final CustomPermissionsTableWidget chatWidget = CustomPermissionsTableWidget(
  initialData: _chatData,
  currentValues: List.generate(_chatData.length, (_) => false),
  functionsList: _noopFunctions(_chatData),
  title: 'chat',
);

// ── Board Page ────────────────────────────────────────────────────────────────

final List<String> _boardData = [
  'Create Board'.tr,
];

final CustomPermissionsTableWidget boardWidget = CustomPermissionsTableWidget(
  initialData: _boardData,
  currentValues: List.generate(_boardData.length, (_) => false),
  functionsList: _noopFunctions(_boardData),
  title: 'board',
);

// ── Check in & out Page (meeting) ─────────────────────────────────────────────

final List<String> _meetingData = [
  'Create Meeting'.tr,
  'Edit Meeting'.tr,
  'Reschedule Meeting'.tr,
  'Cancel Meeting'.tr,
];

final CustomPermissionsTableWidget meetingWidget = CustomPermissionsTableWidget(
  initialData: _meetingData,
  currentValues: List.generate(_meetingData.length, (_) => false),
  functionsList: _noopFunctions(_meetingData),
  title: 'check',
);

// ── Setting Page ──────────────────────────────────────────────────────────────

final List<String> _settingData = [
  'My Profile'.tr,
  'Company Information'.tr,
  'Subscription'.tr,
];

final CustomPermissionsTableWidget settingWidget = CustomPermissionsTableWidget(
  initialData: _settingData,
  currentValues: List.generate(_settingData.length, (_) => false),
  functionsList: _noopFunctions(_settingData),
  title: 'setting',
);
