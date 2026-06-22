/// ******************* FILE INFO *******************
/// File Name: details_switch_cubit.dart
/// Description: Business logic for Details Switch Screen
/// Created by: Amr Mesbah
/// Last Update: 01/12/2025
/// Updated: Migrated from ServicesManagerCubit to MainCoreEmployeeController

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/data/details_switch_model.dart';
import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/details_switch_state.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DetailsSwitchCubit extends Cubit<DetailsSwitchState> {
  final DetailsSwitchModel model;
  final MainCoreEmployeeController employeeController = Get.find<MainCoreEmployeeController>();

  DetailsSwitchCubit({
    ServicesHistoryModel? editingModel,
    String? docId,
  }) : model = DetailsSwitchModel(
    editingModel: editingModel,
    docId: docId,
  ),
        super(DetailsSwitchInitial());

  Future<void> loadEmployees() async {

    try {
      final employees = employeeController.allEmployeesEntities;

      if (employees != null && employees.isNotEmpty) {
        model.allEmployees = employees;
        model.isLoading = false;

        _updateFilteredEmployees();
        _emitLoaded();
      } else {

        final fetchedEmployees = await employeeController.getAllNewEmployees();

        if (fetchedEmployees != null && fetchedEmployees.isNotEmpty) {
          model.allEmployees = fetchedEmployees;
          model.isLoading = false;

          _updateFilteredEmployees();
          _emitLoaded();
        } else {
          model.isLoading = false;
          _emitLoaded();
        }
      }
    } catch (e, stackTrace) {
      model.isLoading = false;
      _emitLoaded();
    }

  }

  Future<void> loadInitialData() async {
    try {
      // ✅ FIX: Clear stale SharedPrefs for fresh service creation
      if (model.editingModel == null && model.docId == null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('selected_departments');
        await prefs.remove('approval_cycle');
        _emitLoaded();
        return;
      }

      if (model.editingModel != null) {
        if (model.editingModel!.currentApprovalCycle.isNotEmpty) {
          _loadFromEditingModel(model.editingModel!);

          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('selected_departments');
          await prefs.remove('approval_cycle');
          return;
        } else {
          final prefs = await SharedPreferences.getInstance();
          final savedApprovalCycleJson = prefs.getString('approval_cycle');

          if (savedApprovalCycleJson != null) {
            final List<dynamic> decoded = jsonDecode(savedApprovalCycleJson);
            final savedApprovalCycle = decoded
                .map((e) => _employeeFromJson(e as Map<String, dynamic>))
                .toList();

            model.selectedEmployees = savedApprovalCycle
                .map((e) => model.allEmployees.firstWhere(
                  (a) => a.id == e.id,
              orElse: () => EmployeeEntityPro(
                id: e.id ?? '',
                firstName: e.firstName,
                lastName: e.lastName,
                email: e.email,
                role: e.role,
                title: e.title,
                titleInArabic: e.titleInArabic,
              ),
            ))
                .where((employee) => !_isRegularEmployee(employee))
                .toList();

            model.requireApproval = savedApprovalCycle.isNotEmpty;
            _updateFilteredEmployees();
          } else {
            _loadFromEditingModel(model.editingModel!);
          }

          final savedDepartmentsJson = prefs.getString('selected_departments');
          if (model.editingModel!.currentSelectDepartment.isNotEmpty) {
            model.selectedDepartments =
            List<String>.from(model.editingModel!.currentSelectDepartment);
            model.limitAvailability = model.selectedDepartments.isNotEmpty;
          } else if (savedDepartmentsJson != null) {
            final List<dynamic> decoded = jsonDecode(savedDepartmentsJson);
            model.selectedDepartments = decoded.cast<String>();
            model.limitAvailability = model.selectedDepartments.isNotEmpty;
          }

          _emitLoaded();
          return;
        }
      }

      // docId only (continuing a new service mid-flow)
      final prefs = await SharedPreferences.getInstance();
      final savedDepartmentsJson = prefs.getString('selected_departments');
      final savedApprovalCycleJson = prefs.getString('approval_cycle');

      if (savedDepartmentsJson != null) {
        final List<dynamic> decoded = jsonDecode(savedDepartmentsJson);
        model.selectedDepartments = decoded.cast<String>();
      }

      if (savedApprovalCycleJson != null) {
        final List<dynamic> decoded = jsonDecode(savedApprovalCycleJson);
        final savedApprovalCycle = decoded
            .map((e) => _employeeFromJson(e as Map<String, dynamic>))
            .toList();

        model.selectedEmployees = savedApprovalCycle
            .map((e) => model.allEmployees.firstWhere(
              (a) => a.id == e.id,
          orElse: () => EmployeeEntityPro(
            id: e.id ?? '',
            firstName: e.firstName,
            lastName: e.lastName,
            email: e.email,
          ),
        ))
            .where((employee) => !_isRegularEmployee(employee))
            .toList();
      }

      model.limitAvailability = model.selectedDepartments.isNotEmpty;
      model.requireApproval = model.selectedEmployees.isNotEmpty;

      _updateFilteredEmployees();
      _emitLoaded();
    } catch (e, stackTrace) {
      _emitLoaded();
    }
  }

  /// Helper method to create EmployeeEntityPro from JSON
  EmployeeEntityPro _employeeFromJson(Map<String, dynamic> json) {
    return EmployeeEntityPro(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      firstNameInArabic: json['firstNameInArabic'] as String?,
      lastNameInArabic: json['lastNameInArabic'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      title: json['title'] as String?,
      titleInArabic: json['titleInArabic'] as String?,
      gender: json['gender'] as String?,
      photo: json['photo'] as String?,
      departmentId: json['departmentId'] as String?,
    );
  }

  void _loadFromEditingModel(ServicesHistoryModel editingModel) {

    try {
      final currentSelectDepartment = editingModel.currentSelectDepartment;
      final currentApprovalCycle = editingModel.currentApprovalCycle;

      model.selectedDepartments = List<String>.from(currentSelectDepartment);

      model.selectedEmployees = currentApprovalCycle
          .where((approver) => !_isRegularEmployee(
        EmployeeEntityPro(
          id: approver.id,
          firstName: approver.firstName,
          lastName: approver.lastName,
          email: approver.email,
          role: approver.role,
          title: approver.title,
          titleInArabic: approver.titleInArabic,
        ),
      ))
          .map((approver) => EmployeeEntityPro(
        id: approver.id,
        firstName: approver.firstName,
        lastName: approver.lastName,
        firstNameInArabic: approver.firstNameInArabic,
        lastNameInArabic: approver.lastNameInArabic,
        email: approver.email,
        role: approver.role,
        title: approver.title,
        titleInArabic: approver.titleInArabic,
        gender: approver.gender,
        photo: approver.photo,
        departmentId: approver.departmentId,
      ))
          .toList();

      model.limitAvailability = currentSelectDepartment.isNotEmpty;
      model.requireApproval = currentApprovalCycle.isNotEmpty;

      _updateFilteredEmployees();
      _emitLoaded();

    } catch (e, stackTrace) {

      model.selectedDepartments = [];
      model.selectedEmployees = [];
      model.limitAvailability = false;
      model.requireApproval = false;
      _emitLoaded();
    }

  }

  bool _isRegularEmployee(EmployeeEntityPro employee) {

    final roleLower = (employee.role ?? '').toLowerCase().trim();
    final titleLower = (employee.title ?? '').toLowerCase().trim();
    final titleArLower = (employee.titleInArabic ?? '').toLowerCase().trim();

    final leadershipKeywords = [
      'manager', 'director', 'head', 'lead', 'chief', 'supervisor', 'admin',
      'مدير', 'رئيس', 'قائد', 'مشرف',
    ];

    bool hasLeadershipRole = leadershipKeywords.any((keyword) =>
    roleLower.contains(keyword) ||
        titleLower.contains(keyword) ||
        titleArLower.contains(keyword)
    );

    if (hasLeadershipRole) {
      return false;
    }

    final englishEmployeeKeywords = [
      'employee',
      'staff',
      'worker',
      'clerk',
      'junior',
      'trainee',
      'intern',
    ];

    final arabicEmployeeKeywords = [
      'موظف',
      'موظفة',
      'عامل',
      'عاملة',
      'كاتب',
      'كاتبة',
      'متدرب',
      'متدربة',
      'طالب تدريب',
      'طالبة تدريب',
    ];

    bool hasEnglishEmployeeKeyword = englishEmployeeKeywords
        .any((keyword) => roleLower.contains(keyword) || titleLower.contains(keyword));

    bool hasArabicEmployeeKeyword = arabicEmployeeKeywords.any((keyword) =>
    roleLower.contains(keyword) ||
        titleLower.contains(keyword) ||
        titleArLower.contains(keyword));

    bool isRegular = hasEnglishEmployeeKeyword || hasArabicEmployeeKeyword;

    return isRegular;
  }

  // Add this field at the top of the cubit
  String _currentSearchQuery = '';

  void updateSearch(String query) {
    _currentSearchQuery = query; // ✅ Save it
    _updateFilteredEmployees();  // reuse the same logic
    _emitLoaded();
  }

  void toggleLimitAvailability(bool value) {
    if (!value) {
      model.selectedDepartments.clear();
    }
    model.limitAvailability = value;
    _emitLoaded();
  }

  void toggleRequireApproval(bool value) {
    model.requireApproval = value;
    if (!value) {
      model.selectedEmployees.clear();
      model.shouldPreventAutoRequester = true;
    }
    _emitLoaded();
  }

  void addDepartment(String val, bool isEnglish, List<String> en, List<String> ar) {
    if (isEnglish) {
      if (!model.selectedDepartments.contains(val)) {
        model.selectedDepartments.add(val);
      }
    } else {
      final idx = ar.indexOf(val);
      final enName = idx >= 0 ? en[idx] : val;
      if (!model.selectedDepartments.contains(enName)) {
        model.selectedDepartments.add(enName);
      }
    }
    model.limitAvailability = model.selectedDepartments.isNotEmpty;
    _emitLoaded();
  }

  void removeDepartment(String val, bool isEnglish, List<String> en, List<String> ar) {
    if (isEnglish) {
      model.selectedDepartments.remove(val);
    } else {
      final idx = ar.indexOf(val);
      final enName = idx >= 0 ? en[idx] : val;
      model.selectedDepartments.remove(enName);
    }
    model.limitAvailability = model.selectedDepartments.isNotEmpty;
    _emitLoaded();
  }

  bool isSelected(EmployeeEntityPro employee) {
    return model.selectedEmployees.any((e) => e.id == employee.id);
  }

  void toggleEmployeeSelection(EmployeeEntityPro employee) {
    if (isSelected(employee)) {
      model.selectedEmployees.removeWhere((e) => e.id == employee.id);
    } else {
      model.selectedEmployees.add(employee);
    }
    _updateFilteredEmployees();
    _emitLoaded();
  }

  void removeEmployeeAt(int index) {
    model.selectedEmployees.removeAt(index);
    _updateFilteredEmployees();
    _emitLoaded();
  }

  void _updateFilteredEmployees() {
    final q = _currentSearchQuery.trim().toLowerCase(); // add this field
    final eligibleEmployees = model.allEmployees.where((e) => !_isRegularEmployee(e)).toList();
    final sel = eligibleEmployees.where((e) => model.selectedEmployees.any((s) => s.id == e.id)).toList();

    if (q.isEmpty) {
      final rest = eligibleEmployees.where((e) => !sel.contains(e)).toList();
      model.filteredEmployees = [...sel, ...rest];
    } else {
      model.filteredEmployees = eligibleEmployees.where((e) {
        final enFirst = (e.firstName ?? '').trim().toLowerCase();
        final enLast = (e.lastName ?? '').trim().toLowerCase();
        final arFirst = (e.firstNameInArabic ?? '').trim().toLowerCase();
        final arLast = (e.lastNameInArabic ?? '').trim().toLowerCase();
        return enFirst.contains(q) || enLast.contains(q) ||
            '$enFirst $enLast'.contains(q) ||
            arFirst.contains(q) || arLast.contains(q) ||
            '$arFirst $arLast'.contains(q);
      }).toList();
    }
  }

  void checkAndLoadFromEditingModel() {
    if (!model.didInitFromEditModel && model.isEditMode) {
      _loadFromEditingModel(model.editingModel!);
      model.didInitFromEditModel = true;
    }
  }

  void checkAndAutoSelectRequester() async {
    if (!model.isEditMode &&
        model.selectedEmployees.isEmpty &&
        model.requireApproval &&
        !model.shouldPreventAutoRequester) {
      final prefs = await SharedPreferences.getInstance();
      final requesterEmail = prefs.getString("emailRequester");
      final requester = model.allEmployees.firstWhere(
            (e) => e.email == requesterEmail,
        orElse: () => EmployeeEntityPro(id: '', email: requesterEmail),
      );

      if (requester.id?.isNotEmpty == true) {
        model.selectedEmployees = [requester];
        _updateFilteredEmployees();
        _emitLoaded();
      }
    }
  }

  void updateEmployeesFromController(List<EmployeeEntityPro>? employees) {
    if (employees != null && employees.isNotEmpty) {
      model.allEmployees = employees;

      checkAndLoadFromEditingModel();
      checkAndAutoSelectRequester();

      _updateFilteredEmployees();
      _emitLoaded();
    }
  }

  void setNavigated(bool value) {
    model.navigated = value;
  }

  bool validateForm() {
    if (model.limitAvailability && model.selectedDepartments.isEmpty) {
      emit(DetailsSwitchValidationError(
        title: 'validationError',
        message: 'mustSelectDepartment',
        lottiePath: "assets/lottie/attention.json",
      ));
      return false;
    }

    if (model.requireApproval && model.selectedEmployees.isEmpty) {
      emit(DetailsSwitchValidationError(
        title: 'validationError',
        message: 'mustSelectApprovalEmployees',
        lottiePath: "assets/lottie/rejected.json",
      ));
      return false;
    }

    return true;
  }

  void _emitLoaded() {
    emit(DetailsSwitchLoaded(
      allEmployees: model.allEmployees,
      filteredEmployees: model.filteredEmployees,
      selectedEmployees: model.selectedEmployees,
      selectedDepartments: model.selectedDepartments,
      limitAvailability: model.limitAvailability,
      requireApproval: model.requireApproval,
      isLoading: model.isLoading,
    ));
  }
}
