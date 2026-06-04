import 'package:get/get.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employee_hr_profile_components/custom_permissions_table.dart';




final List<String> initialDataEmployee = [
  'Filter' ,
  'Add Employee' ,
  'Custom Table' ,
  'See More' ,
];
final List<bool> boolValuesEmployee =
    List.generate(initialDataEmployee.length, (_) => false);
final List<dynamic Function(bool)> functionsListEmployee =
    generateFunctions(initialDataEmployee);


// Employees Data section
List<Function(bool)> generateFunctions(List<String> data) {
  return data.map((string) {
    switch (string) {
      case 'Filter':
        return (bool value) {
          print("Action for Filter with value: $value");
        };
      case 'Add Employee':
        return (bool value) {
          print("Action for Add Employee with value: $value");
        };
      case 'Custom Table':
        return (bool value) {
          print("Action for Custom Table with value: $value");
        };
      case 'See More':
        return (bool value) {
          print("Action for See More with value: $value");
        };

      default:
        return (bool value) {
          print("");
        };
    }
  }).toList();
}
 

final CustomPermissionsTableWidget employeeDataWidget =
    CustomPermissionsTableWidget(
  initialData: initialDataEmployee,
  currentValues: boolValuesEmployee,
  functionsList: functionsListEmployee,
  title: 'employee',
);

List<Function(bool)> generateFunctions2(List<String> data) {
  return data.map((string) {
    switch (string) {
      case 'Employees Overview':
        return (bool value) {
          print("Action for Employees Overview with value: $value");
        };
      case 'Employees Nationality':
        return (bool value) {
          print("Action for Employees Nationality with value: $value");
        };
      case 'Employees Attendance':
        return (bool value) {
          print("Action for Employees Attendance with value: $value");
        };
      case 'Meeting Attendance':
        return (bool value) {
          print("Action for Meeting Attendance with value: $value");
        };
      case 'Employees Rates':
        return (bool value) {
          print("Action for Employees Rates with value: $value");
        };
      case 'Project Achievements':
        return (bool value) {
          print("Action for Project Achievements with value: $value");
        };
      case 'Employees Organization Chart':
        return (bool value) {
          print("Action for Employees Organization Chart with value: $value");
        };
      case 'Add Department':
        return (bool value) {
          print("Action for Add Department with value: $value");
        };

      default:
        return (bool value) {
          print("");
        };
    }
  }).toList();
}

final List<String> initialData2 = [
  'Employees Overview'.tr,
  'Employees Nationality'.tr,
  'Employees Attendance'.tr,
  'Meeting Attendance'.tr,
  'Employees Rates'.tr,
  'Project Achievements'.tr,
  'Employees Organization Chart'.tr,
  'Add Department'.tr,
];
final List<bool> boolValues2 = List.generate(initialData2.length, (_) => false);
final List<dynamic Function(bool)> functionsList2 =
    generateFunctions2(initialData2);

final CustomPermissionsTableWidget employeeChartsWidget =
    CustomPermissionsTableWidget(
  initialData: initialData2,
  currentValues: boolValues2,
  functionsList: functionsList2,
  title: 'employee',
);
