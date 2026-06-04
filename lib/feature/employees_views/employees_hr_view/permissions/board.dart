import 'package:get/get.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employee_hr_profile_components/custom_permissions_table.dart';

// Board section
List<Function(bool)> generateFunctions(List<String> data) {
  return data.map((string) {
    switch (string) {
      case 'Create Board':
        return (bool value) {
          print("Action for Create Board with value: $value");
        };

      default:
        return (bool value) {
          print("");
        };
    }
  }).toList();
}

final List<String> initialDataBoard = [
  'Create Board'.tr,
];
final List<bool> boolValuesBoard =
    List.generate(initialDataBoard.length, (_) => false);
final List<dynamic Function(bool)> functionsListBoard =
    generateFunctions(initialDataBoard);

final CustomPermissionsTableWidget boardWidget = CustomPermissionsTableWidget(
  initialData: initialDataBoard,
  currentValues: boolValuesBoard,
  functionsList: functionsListBoard,
  title: 'board',
);

// Board View section
List<Function(bool)> generateFunctions2(List<String> data) {
  return data.map((string) {
    switch (string) {
      case 'Create Task':
        return (bool value) {
          print("Action for Create Task with value: $value");
        };
      case 'Invite Member':
        return (bool value) {
          print("Action for Invite Member with value: $value");
        };

      default:
        return (bool value) {
          print("");
        };
    }
  }).toList();
}

final List<String> initialData2 = [
  'Create Task'.tr,
  'Invite Member'.tr,
];
final List<bool> boolValues2 = List.generate(initialData2.length, (_) => false);
final List<dynamic Function(bool)> functionsList2 =
    generateFunctions2(initialData2);

final CustomPermissionsTableWidget boardViewWidget =
    CustomPermissionsTableWidget(
  initialData: initialData2,
  currentValues: boolValues2,
  functionsList: functionsList2,
  title: 'board',
);

// Board Task section
List<Function(bool)> generateFunctions3(List<String> data) {
  return data.map((string) {
    switch (string) {
      case 'Invite Member':
        return (bool value) {
          print("Action for Invite Member with value: $value");
        };
      case 'Create Task':
        return (bool value) {
          print("Action for Create Task with value: $value");
        };
      case 'Create Check List':
        return (bool value) {
          print("Action for Create Check List with value: $value");
        };
      case 'Create Label':
        return (bool value) {
          print("Action for Create Label with value: $value");
        };
      case 'Upload Attachment':
        return (bool value) {
          print("Action for Upload Attachment with value: $value");
        };
      case 'Create Date':
        return (bool value) {
          print("Action for Create Date with value: $value");
        };
      case 'Copy Card':
        return (bool value) {
          print("Action for Copy Card with value: $value");
        };
      case 'Move Card':
        return (bool value) {
          print("Action for Move Card with value: $value");
        };
      case 'Delete Card':
        return (bool value) {
          print("Action for Delete Card with value: $value");
        };
      default:
        return (bool value) {
          print("");
        };
    }
  }).toList();
}

final List<String> initialData3 = [
  'Invite Member'.tr,
  'Create Task'.tr,
  'Create Check List'.tr,
  'Create Label'.tr,
  'Upload Attachment'.tr,
  'Create Date'.tr,
  'Copy Card'.tr,
  'Move Card'.tr,
  'Delete Card'.tr,
];
final List<bool> boolValues3 = List.generate(initialData3.length, (_) => false);
final List<dynamic Function(bool)> functionsList3 =
    generateFunctions3(initialData3);

final CustomPermissionsTableWidget taskWidget = CustomPermissionsTableWidget(
  initialData: initialData3,
  currentValues: boolValues3,
  functionsList: functionsList3,
  title: 'board',
);
