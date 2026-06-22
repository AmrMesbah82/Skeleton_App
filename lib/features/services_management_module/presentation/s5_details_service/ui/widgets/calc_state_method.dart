import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';

final Map<String, String> enToArDepartments = {
  "Executive": "الإدارة التنفيذية",
  "Customer Support": "دعم العملاء",
  "Finance": "المالية",
  "Operations": "العمليات",
  "Information Technology": "تقنية المعلومات",
  "Human Resources": "الموارد البشرية",
  "Marketing": "التسويق",
  "Sales": "المبيعات",
  "Data Management": "إدارة البيانات",
  "Compliance & Legal": "الامتثال والشؤون القانونية",
  "Software": "البرمجيات",
};

Map<String, dynamic> calculateStatsForEmployee(
    EmployeeEntityModell emp,
    BuildContext context,
    List<Map<String, dynamic>> filteredItems, {
      String? parentDuration,
      String? parentDurationUnit,
    }) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final fullName = isArabic
      ? '${emp.firstNameInArabic ?? ''} ${emp.lastNameInArabic ?? ''}'.trim()
      : '${emp.firstName ?? ''} ${emp.lastName ?? ''}'.trim();

  int done = 0;
  int breached = 0;
  double totalMinutes = 0;

  final employeeController = Get.find<MainCoreEmployeeController>();
  final String? email = emp.email;
  final rawDepartment =
  (email != null) ? employeeController.getEmployeeDepartmentName(email) : 'N/A';

  final department =
  isArabic ? enToArDepartments[rawDepartment] ?? rawDepartment : rawDepartment;

  String? jobTitle = isArabic ? emp.titleInArabic : emp.title;

  for (final item in filteredItems) {
    final model = item["model"] as ServicesHistoryModel;
    final data = item["raw"] as Map<String, dynamic>;

    final firstName = isArabic
        ? _extractValue(model.first_Name_Requester_Arabic)
        : _extractValue(model.first_Name_Requester);
    final lastName = isArabic
        ? _extractValue(model.last_Name_Requester_Arabic)
        : _extractValue(model.last_Name_Requester);

    final requesterName = '$firstName $lastName'.trim();

    final rawState = data["state"];
    final state = _extractValue(rawState).toLowerCase().trim();

    if (requesterName == fullName) {
      if (state == 'done') done++;
      if (state == 'branchsla' || state == 'breached sla') breached++;

      if (['inprogress', 'done', 'branchsla'].contains(state)) {
        // ✅ FIX: Try request doc → model → parent service duration
        final rawDuration = data['durationOfServices']
            ?? data['Duration_Of_Services']
            ?? (model.currentDurationOfServices.isNotEmpty
                ? model.currentDurationOfServices
                : null)
            ?? parentDuration
            ?? '0';
        final rawUnit = data['selectedDurationUnit']
            ?? data['Selected_Duration_Unit']
            ?? (model.currentSelectedDurationUnit.isNotEmpty
                ? model.currentSelectedDurationUnit
                : null)
            ?? parentDurationUnit
            ?? 'minutes';

        final duration = double.tryParse(_extractValue(rawDuration)) ?? 0;
        final unit = _extractValue(rawUnit).toLowerCase();

        final minutes = switch (unit) {
          "minutes" => duration,
          "minute" => duration,
          "hours" => duration * 60,
          "hour" => duration * 60,
          "days" => duration * 1440,
          "day" => duration * 1440,
          "weeks" => duration * 10080,
          "week" => duration * 10080,
          _ => 0,
        };
        totalMinutes += minutes;
      }
    }
  }

  return {
    "name": fullName.isEmpty ? 'N/A' : fullName,
    "title": jobTitle ?? 'N/A',
    "department": department,
    "done": done,
    "breached": breached,
    "hours": totalMinutes / 60,
    "gender": emp.gender ?? 'male',
  };
}

String _extractValue(dynamic value) {
  if (value == null) return '';
  if (value is List) {
    for (int i = value.length - 1; i >= 0; i--) {
      final item = value[i]?.toString().trim() ?? '';
      if (item.isNotEmpty) return item;
    }
    return '';
  }
  if (value is Map && value.containsKey('value')) {
    return _extractValue(value['value']);
  }
  return value.toString().trim();
}
