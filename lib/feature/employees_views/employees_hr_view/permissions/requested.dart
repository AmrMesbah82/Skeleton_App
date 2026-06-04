import 'package:get/get.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employee_hr_profile_components/custom_permissions_table.dart';

// Requested section
List<Function(bool)> generateFunctions(List<String> data) {
  return data.map((string) {
    switch (string) {
      case 'Accepted Requests':
        return (bool value) {
          print("Action for Accepted Requests with value: $value");
        };
      case 'Rejected Requests':
        return (bool value) {
          print("Action for Rejected Requests with value: $value");
        };
      case 'Filter':
        return (bool value) {
          print("Action for Filter with value: $value");
        };
      default:
        return (bool value) {
          print("");
        };
    }
  }).toList();
}

final List<String> initialData = [
  'Accepted Requests'.tr,
  'Rejected Requests'.tr,
  'Filter'.tr,
];
final List<bool> boolValues = List.generate(initialData.length, (_) => false);
final List<dynamic Function(bool)> functionsList =
    generateFunctions(initialData);

final CustomPermissionsTableWidget requestedWidget =
    CustomPermissionsTableWidget(
  initialData: initialData,
  currentValues: boolValues,
  functionsList: functionsList,
  title: 'request',
);
