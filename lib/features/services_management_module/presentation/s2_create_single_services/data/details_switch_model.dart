/// ******************* FILE INFO *******************
/// File Name: details_switch_model.dart
/// Description: Data model for Details Switch Screen
/// Created by: Amr Mesbah
/// Last Update: 01/12/2025

import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/employee_card_item.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';

class DetailsSwitchModel {
  bool limitAvailability = false;
  bool requireApproval = false;
  bool shouldPreventAutoRequester = false;
  bool didInitFromEditModel = false;
  bool navigated = false;
  bool isLoading = true;

  List<String> selectedDepartments = [];
  List<EmployeeEntityPro> allEmployees = [];
  List<EmployeeEntityPro> filteredEmployees = [];
  List<EmployeeEntityPro> selectedEmployees = [];

  final ServicesHistoryModel? editingModel;
  final String? docId;
  final bool isEditMode;

  DetailsSwitchModel({
    this.editingModel,
    this.docId,
  }) : isEditMode = editingModel != null;
}
