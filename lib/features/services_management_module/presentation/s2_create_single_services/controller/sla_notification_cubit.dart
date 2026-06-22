/// ******************* FILE INFO *******************
/// File Name: sla_notification_cubit.dart
/// Description: Business logic for SLA notification screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/pages/details_switch_screen_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/controller/sla_notification_state.dart';
import 'package:demo_app/core/utils/shared.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_prefs_employee.dart';

import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/widgets/shared_prefs.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/data/sla_notification_model.dart';

class SlaNotificationCubit extends Cubit<SlaNotificationState> {
  // Function types for dependencies
  final Future<void> Function({
  required String slaOne,
  required String slaTwo,
  required bool notifyRequesterChecked,
  required bool notifyProviderChecked,
  required bool notifyManagerChecked,
  required bool notifyRequesterSwitch0,
  required bool notifyManagerSwitch1,
  required List<String> extraSlaList,
  required List<String> extraSlaTwoList,
  required Map<String, Map<int, bool>> notificationSwitches,

  }) submitSlaData;

  final Future<void> Function(ServicesHistoryModel)? saveDraft;

  SlaNotificationCubit({
    required this.submitSlaData,
    this.saveDraft,
  }) : super(SlaNotificationInitial());

  // Model instance
  final SlaNotificationModel model = SlaNotificationModel();

  // Firestore related
  ServicesHistoryModel? currentModel;
  String? currentDocId;
  bool creatingDraftDoc = false;

  Future<void> initialize(ServicesHistoryModel? editingModel) async {
    emit(SlaNotificationLoading());

    model.notifyRequesterChecked = false;
    model.notifyProviderChecked = false;
    model.notifyManagerChecked = false;

    final dateTime = Timestamp.now().toDate();
    model.formatDate = DateFormat("MMMdd_yyyy").format(dateTime);

    currentDocId = editingModel?.currentId;

    if (editingModel != null) {
      await _loadExistingData(editingModel);
    } else {
      _clearFormForNewService();
      if (currentDocId == null || currentDocId!.isEmpty) {
        await _ensureDraftDoc();
      }
    }

    emit(SlaNotificationLoaded(
      currentDocId: currentDocId,
      notifyRequesterChecked: model.notifyRequesterChecked,
      notifyProviderChecked: model.notifyProviderChecked,
      notifyManagerChecked: model.notifyManagerChecked,
      notifyRequesterSwitch0: model.notifyRequesterSwitch0,
      notifyManagerSwitch1: model.notifyManagerSwitch1,
      extraSlaList: model.extraSlaControllers.map((c) => c.text).toList(),
      extraSlaTwoList: model.extraSlaTwoControllers.map((c) => c.text).toList(),
      notificationSwitches: model.notificationSwitches,
    ));
  }

  Future<void> _ensureDraftDoc() async {
    if (currentDocId != null && currentDocId!.isNotEmpty) {
      if (currentModel == null) {
        await _loadModelFromFirestore(currentDocId!);
      }
      return;
    }

    final restored = await SharedPrefsHelper.getString('current_service_docId');
    if (restored != null && restored.isNotEmpty) {
      currentDocId = restored;
      await _loadModelFromFirestore(currentDocId!);
      return;
    }

    if (creatingDraftDoc) return;
    creatingDraftDoc = true;

    try {
      final now = Timestamp.now();
      final formatted = DateFormat("MMMdd_yyyy").format(now.toDate());
      final randomId = DateTime.now().millisecondsSinceEpoch % 100000;
      currentDocId = "User${randomId}$formatted";

      currentModel = ServicesHistoryModel.createNew(
        id: currentDocId!,
        state: 'draft',
        status: 'draft',
      );

      await FirebaseFirestore.instance
          .collection('Services')
          .doc(currentDocId)
          .set(currentModel!.toJson(), SetOptions(merge: true));

      await SharedPrefsHelper.setString('current_service_docId', currentDocId!);
    } catch (e, st) {
    } finally {
      creatingDraftDoc = false;
    }
  }

  Future<void> _loadModelFromFirestore(String docId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Services')
          .doc(docId)
          .get();

      if (doc.exists && doc.data() != null) {
        currentModel = ServicesHistoryModel.fromJson(doc.data()!, docId);
        _populateUIFromModel();
      }
    } catch (e, st) {
    }
  }

  void _populateUIFromModel() {
    if (currentModel == null) return;

    model.slaOneController.text = currentModel!.currentSlaOneControllerEnglish;
    model.slaTwoController.text = currentModel!.currentSlaTwoControllerEnglish;
    model.notifyRequesterChecked = currentModel!.currentNotifyRequesterChecked;
    model.notifyProviderChecked = currentModel!.currentNotifyProviderChecked;
    model.notifyManagerChecked = currentModel!.currentNotifyManagerChecked;
    model.notifyRequesterSwitch0 = currentModel!.currentNotifyRequesterSwitch0;
    model.notifyManagerSwitch1 = currentModel!.currentNotifyManagerSwitch1;
  }

  Future<void> _loadExistingData(ServicesHistoryModel editingModel) async {

    currentModel = editingModel;
    currentDocId = editingModel.currentId;

    model.slaOneController.text = editingModel.currentSlaOneControllerEnglish;
    model.slaTwoController.text = editingModel.currentSlaTwoControllerEnglish;
    model.notifyRequesterChecked = editingModel.currentNotifyRequesterChecked;
    model.notifyProviderChecked = editingModel.currentNotifyProviderChecked;
    model.notifyManagerChecked = editingModel.currentNotifyManagerChecked;
    model.notifyRequesterSwitch0 = editingModel.currentNotifyRequesterSwitch0;
    model.notifyManagerSwitch1 = editingModel.currentNotifyManagerSwitch1;

  }

  void _clearFormForNewService() {

    model.slaOneController.clear();
    model.slaTwoController.clear();

    model.notifyRequesterChecked = false;
    model.notifyProviderChecked = false;
    model.notifyManagerChecked = false;
    model.notifyRequesterSwitch0 = false;
    model.notifyManagerSwitch1 = false;

    model.notificationSwitches.clear();
    model.isInvalidNumber = false;
    model.isInvalidNumberTwo = false;

    for (var controller in model.extraSlaControllers) {
      controller.dispose();
    }
    for (var controller in model.extraSlaTwoControllers) {
      controller.dispose();
    }
    model.extraSlaControllers.clear();
    model.extraSlaTwoControllers.clear();

    _clearSlaSharedPreferences();
  }

  Future<void> _clearSlaSharedPreferences() async {
    await SharedPrefsHelper.setString('sla_one', '');
    await SharedPrefsHelper.setString('sla_two', '');
    await SharedPrefsHelper.setBool('Notify Service Requester_checked', false);
    await SharedPrefsHelper.setBool('Notify Service Provider_checked', false);
    await SharedPrefsHelper.setBool('Notify Provider Manager_checked', false);
    await SharedPrefsHelper.setBool('notifyRequesterSwitch0', false);
    await SharedPrefsHelper.setBool('notifyManagerSwitch1', false);
    await SharedPrefsHelper.setStringList('extra_sla_list', []);
    await SharedPrefsHelper.setStringList('extra_sla_two_list', []);

  }

  Future<void> updateAndSaveModel() async {
    try {
      await _ensureDraftDoc();

      if (currentModel == null || currentDocId == null) {
        return;
      }

      // ✅ Read toggled status from SharedPrefs (set by page 1)
      final isActive = await SharedPrefsHelper.getBool('service_status') ?? true;
      final status = isActive ? 'active' : 'inactive';

      currentModel = currentModel!.copyWith(
        slaOneControllerEnglish: model.slaOneController.text.trim(),
        slaTwoControllerEnglish: model.slaTwoController.text.trim(),
        notifyRequesterChecked: model.notifyRequesterChecked,
        notifyProviderChecked: model.notifyProviderChecked,
        notifyManagerChecked: model.notifyManagerChecked,
        notifyRequesterSwitch0: model.notifyRequesterSwitch0,
        notifyManagerSwitch1: model.notifyManagerSwitch1,
        status: status, // ✅ Apply correct status
      );

      await FirebaseFirestore.instance
          .collection('Services')
          .doc(currentDocId)
          .set(currentModel!.toJson(), SetOptions(merge: true));

    } catch (e, st) {
    }
  }

  void updateCheckbox(String type, bool value) {
    switch (type) {
      case 'requester':
        model.notifyRequesterChecked = value;
        break;
      case 'provider':
        model.notifyProviderChecked = value;
        break;
      case 'manager':
        model.notifyManagerChecked = value;
        break;
    }
    _emitLoadedState();
  }

  void updateSwitch(String type, bool value) {
    switch (type) {
      case 'requester0':
        model.notifyRequesterSwitch0 = value;
        break;
      case 'manager1':
        model.notifyManagerSwitch1 = value;
        break;
    }
    _emitLoadedState();
  }

  void updateNotificationSwitches(String title, Map<int, bool> switches) {
    model.notificationSwitches[title] = Map<int, bool>.from(switches);
    _emitLoadedState();
  }

  void updateSlaOne(String value) {
    if (value.trim().isNotEmpty) {
      if (value.contains('.') || value.contains(',')) {
        model.isInvalidNumber = true;
      } else if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
        model.isInvalidNumber = true;
      } else {
        model.isInvalidNumber = false;
      }
    } else {
      model.isInvalidNumber = false;
    }
    _emitLoadedState();
  }

  void updateSlaTwo(String value) {
    if (value.trim().isNotEmpty) {
      if (value.contains('.') || value.contains(',')) {
        model.isInvalidNumberTwo = true;
      } else if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
        model.isInvalidNumberTwo = true;
      } else {
        model.isInvalidNumberTwo = false;
      }
    } else {
      model.isInvalidNumberTwo = false;
    }
    _emitLoadedState();
  }

  void addExtraSlaController() {
    if (model.extraSlaControllers.length < SlaNotificationModel.maxSlaInputs) {
      final newController = TextEditingController();
      model.extraSlaControllers.add(newController);
      _setupExtraControllerListener(newController, 'extraSlaList', model.extraSlaControllers.length - 1);
      _emitLoadedState();
    }
  }

  void addExtraSlaTwoController() {
    if (model.extraSlaTwoControllers.length < SlaNotificationModel.maxSlaInputs) {
      final newController = TextEditingController();
      model.extraSlaTwoControllers.add(newController);
      _setupExtraControllerListener(newController, 'extraSlaTwoList', model.extraSlaTwoControllers.length - 1);
      _emitLoadedState();
    }
  }

  void removeExtraSlaController(int index) {
    if (index >= 0 && index < model.extraSlaControllers.length) {
      model.extraSlaControllers[index].dispose();
      model.extraSlaControllers.removeAt(index);
      _saveExtraControllersToSharedPrefs();
      _emitLoadedState();
    }
  }

  void removeExtraSlaTwoController(int index) {
    if (index >= 0 && index < model.extraSlaTwoControllers.length) {
      model.extraSlaTwoControllers[index].dispose();
      model.extraSlaTwoControllers.removeAt(index);
      _saveExtraControllersToSharedPrefs();
      _emitLoadedState();
    }
  }

  void _setupExtraControllerListener(TextEditingController controller, String prefix, int index) {
    Timer? debounceTimer;

    controller.addListener(() {
      final val = controller.text.trim();

      debounceTimer?.cancel();
      debounceTimer = Timer(Duration(milliseconds: 500), () {
        updateAndSaveModel();
        _saveExtraControllersToSharedPrefs();
      });
    });
  }

  Future<void> _saveExtraControllersToSharedPrefs() async {
    final extraSlaValues = model.extraSlaControllers.map((c) => c.text).toList();
    final extraSlaTwoValues = model.extraSlaTwoControllers.map((c) => c.text).toList();

    await SharedPrefsHelper.setStringList('extra_sla_list', extraSlaValues);
    await SharedPrefsHelper.setStringList('extra_sla_two_list', extraSlaTwoValues);
  }

  bool hasProviderSlaData() {
    bool hasSlaOneText = model.slaOneController.text.trim().isNotEmpty;
    bool hasExtraSlaText = model.extraSlaControllers.any((controller) => controller.text.trim().isNotEmpty);
    return hasSlaOneText || hasExtraSlaText;
  }

  bool hasManagerSlaData() {
    bool hasSlaTwoText = model.slaTwoController.text.trim().isNotEmpty;
    bool hasExtraSlaTwoText = model.extraSlaTwoControllers.any((controller) => controller.text.trim().isNotEmpty);
    return hasSlaTwoText || hasExtraSlaTwoText;
  }

  String? validateNotificationSettings(BuildContext context, String requesterTitle, String providerTitle, String managerTitle) {
    List<String> errors = [];

    final requesterSwitches = model.notificationSwitches[requesterTitle] ?? {};
    bool hasRequesterSwitchEnabled = requesterSwitches.values.any((enabled) => enabled == true);

    if (hasRequesterSwitchEnabled && !model.notifyRequesterChecked) {
      errors.add("Please enable '$requesterTitle' checkbox when using its notification options");
    }

    final providerSwitches = model.notificationSwitches[providerTitle] ?? {};
    bool hasProviderSwitchEnabled = providerSwitches.values.any((enabled) => enabled == true);
    bool providerSlaDataExists = this.hasProviderSlaData();

    if ((hasProviderSwitchEnabled || providerSlaDataExists) && !model.notifyProviderChecked) {
      errors.add("Please enable '$providerTitle' checkbox when using notification options or entering SLA percentages");
    }

    final managerSwitches = model.notificationSwitches[managerTitle] ?? {};
    bool hasManagerSwitchEnabled = managerSwitches.values.any((enabled) => enabled == true);
    bool managerSlaDataExists = this.hasManagerSlaData();

    if ((hasManagerSwitchEnabled || managerSlaDataExists) && !model.notifyManagerChecked) {
      errors.add("Please enable '$managerTitle' checkbox when using notification options or entering SLA percentages");
    }

    return errors.isNotEmpty ? errors.first : null;
  }

  bool validateNumericInputs() {
    if (model.slaOneController.text.trim().isNotEmpty) {
      if (model.slaOneController.text.contains('.') || model.slaOneController.text.contains(',') ||
          !RegExp(r'^\d+$').hasMatch(model.slaOneController.text.trim())) {
        return false;
      }
    }

    if (model.slaTwoController.text.trim().isNotEmpty) {
      if (model.slaTwoController.text.contains('.') || model.slaTwoController.text.contains(',') ||
          !RegExp(r'^\d+$').hasMatch(model.slaTwoController.text.trim())) {
        return false;
      }
    }

    for (var controller in model.extraSlaControllers) {
      if (controller.text.trim().isNotEmpty) {
        if (controller.text.contains('.') || controller.text.contains(',') ||
            !RegExp(r'^\d+$').hasMatch(controller.text.trim())) {
          return false;
        }
      }
    }

    for (var controller in model.extraSlaTwoControllers) {
      if (controller.text.trim().isNotEmpty) {
        if (controller.text.contains('.') || controller.text.contains(',') ||
            !RegExp(r'^\d+$').hasMatch(controller.text.trim())) {
          return false;
        }
      }
    }

    return true;
  }

  bool hasAnyNotificationData() {
    bool hasAnySwitchEnabled = model.notificationSwitches.values
        .any((switchMap) => switchMap.values.any((enabled) => enabled == true));

    bool hasAnySlaData = model.slaOneController.text.trim().isNotEmpty ||
        model.slaTwoController.text.trim().isNotEmpty ||
        model.extraSlaControllers.any((c) => c.text.trim().isNotEmpty) ||
        model.extraSlaTwoControllers.any((c) => c.text.trim().isNotEmpty);

    return hasAnySwitchEnabled || hasAnySlaData;
  }

  Future<void> handleSubmit(BuildContext context, String requesterTitle, String providerTitle, String managerTitle) async {
    if (!validateNumericInputs()) {
      emit(const SlaNotificationValidationError("Please enter only whole numbers in percentage fields. Decimals are not allowed."));
      return;
    }

    if (hasAnyNotificationData()) {
      String? validationError = validateNotificationSettings(context, requesterTitle, providerTitle, managerTitle);
      if (validationError != null) {
        emit(SlaNotificationValidationError(validationError));
        return;
      }
    }

    await updateAndSaveModel();

    final extraSlaList = model.extraSlaControllers.map((c) => c.text).toList();
    final extraSlaTwoList = model.extraSlaTwoControllers.map((c) => c.text).toList();

    await submitSlaData(
      slaOne: model.slaOneController.text,
      slaTwo: model.slaTwoController.text,
      notifyRequesterChecked: model.notifyRequesterChecked,
      notifyProviderChecked: model.notifyProviderChecked,
      notifyManagerChecked: model.notifyManagerChecked,
      notifyRequesterSwitch0: model.notifyRequesterSwitch0,
      notifyManagerSwitch1: model.notifyManagerSwitch1,
      extraSlaList: extraSlaList,
      extraSlaTwoList: extraSlaTwoList,
      notificationSwitches: model.notificationSwitches,
    );

    await _saveAllToSharedPrefs(context);

    // ✅ FIX: Ensure currentModel is populated before emitting
    if (currentModel == null && currentDocId != null) {
      await _loadModelFromFirestore(currentDocId!);
    }

    emit(SlaNotificationSaved());
  }

  Future<void> handleSaveForLater(BuildContext context, ServicesHistoryModel? editingModel, VoidCallback onNavigate) async {
    final isEditingSubmittedService = editingModel != null &&
        editingModel.currentState == "submitted";

    if (isEditingSubmittedService) {
      onNavigate();
      return;
    }

    if (!validateNumericInputs()) {
      emit(const SlaNotificationValidationError("Please enter only numbers in percentage fields"));
      return;
    }

    final isDraft = editingModel != null &&
        (editingModel.currentState == "draft" ||
            editingModel.currentDurationOfServices.isEmpty ||
            editingModel.currentDurationOfServices == "-");

    emit(SlaNotificationSaving());

    if (isDraft || editingModel != null) {
      await _saveDraftData();
      emit(SlaNotificationSaved());
    } else {
      await _saveDraftData();
      emit(SlaNotificationSaved());
    }
  }

  Future<void> _saveDraftData() async {

    await SharedPrefsHelper.setString('sla_one', model.slaOneController.text.trim());
    await SharedPrefsHelper.setString('sla_two', model.slaTwoController.text.trim());
    await SharedPrefsHelper.setBool('Notify Service Requester_checked', model.notifyRequesterChecked);
    await SharedPrefsHelper.setBool('Notify Service Provider_checked', model.notifyProviderChecked);
    await SharedPrefsHelper.setBool('Notify Provider Manager_checked', model.notifyManagerChecked);

    final reqMap = model.notificationSwitches['notifyServiceRequester'] ?? {};
    final mgrMap = model.notificationSwitches['notifyProviderManager'] ?? {};
    model.notifyRequesterSwitch0 = reqMap[0] ?? false;
    model.notifyManagerSwitch1 = mgrMap[0] ?? false;

    await SharedPrefsHelper.setBool('notifyRequesterSwitch0', model.notifyRequesterSwitch0);
    await SharedPrefsHelper.setBool('notifyManagerSwitch1', model.notifyManagerSwitch1);
    await _saveExtraControllersToSharedPrefs();

    final extraSlaList = model.extraSlaControllers.map((c) => c.text).toList();
    final extraSlaTwoList = model.extraSlaTwoControllers.map((c) => c.text).toList();

    // Call submitSlaData for draft saving too
    await submitSlaData(
      slaOne: model.slaOneController.text,
      slaTwo: model.slaTwoController.text,
      notifyRequesterChecked: model.notifyRequesterChecked,
      notifyProviderChecked: model.notifyProviderChecked,
      notifyManagerChecked: model.notifyManagerChecked,
      notifyRequesterSwitch0: model.notifyRequesterSwitch0,
      notifyManagerSwitch1: model.notifyManagerSwitch1,
      extraSlaList: extraSlaList,
      extraSlaTwoList: extraSlaTwoList,
      notificationSwitches: model.notificationSwitches,
    );

    await Future.delayed(Duration(milliseconds: 100));

    final isEditingExisting = currentDocId != null && !currentDocId!.startsWith('draft_');

    if (isEditingExisting) {
      await updateAndSaveModel();
    } else {

      final nameEn = await SharedPrefsHelper.getString('service_name_en') ?? '';
      final nameAr = await SharedPrefsHelper.getString('service_name_ar') ?? '';
      final descEn = await SharedPrefsHelper.getString('service_description_en') ?? '';
      final descAr = await SharedPrefsHelper.getString('service_description_ar') ?? '';
      final durationVal = await SharedPrefsHelper.getString('duration_value') ?? '';
      final durationUnit = await SharedPrefsHelper.getString('duration_unit') ?? '';
      final imageUrl = await SharedPrefsHelper.getString('service_image_url') ?? '';
      final status = (await SharedPrefsHelper.getBool('service_status')) == true ? 'active' : 'inactive';

      final providers = await SharedPrefsEmployeeHelper.getSelectedEmployees() ?? [];
      final departments = await SharedPrefsDepartmentsHelper.getDepartments();
      final approvalCycle = await SharedPrefsApprovalHelper.getApprovalCycle();

      final slaOne = await SharedPrefsHelper.getString('sla_one') ?? '';
      final slaTwo = await SharedPrefsHelper.getString('sla_two') ?? '';
      final notifyReqChecked = await SharedPrefsHelper.getBool('Notify Service Requester_checked') ?? false;
      final notifyProvChecked = await SharedPrefsHelper.getBool('Notify Service Provider_checked') ?? false;
      final notifyMgrChecked = await SharedPrefsHelper.getBool('Notify Provider Manager_checked') ?? false;
      final notifyReqSwitch0 = await SharedPrefsHelper.getBool('notifyRequesterSwitch0') ?? false;
      final notifyMgrSwitch1 = await SharedPrefsHelper.getBool('notifyManagerSwitch1') ?? false;

      final completeModel = ServicesHistoryModel.createNew(
        id: currentDocId ?? 'draft_${DateTime.now().millisecondsSinceEpoch}',
        state: "draft",
        status: status,
        serviceNameEnglish: nameEn,
        serviceNameArabic: nameAr,
        serviceDescriptionEnglish: descEn,
        serviceDescriptionArabic: descAr,
        durationOfServices: durationVal,
        selectedDurationUnit: durationUnit,
        imageUrl: imageUrl,
        providerServices: providers,
        selectDepartment: departments,
        approvalCycle: approvalCycle.cast<EmployeeEntityModell>(),
        limitAvailability: departments.isNotEmpty,
        requireApproval: approvalCycle.isNotEmpty,
        slaOneControllerEnglish: slaOne,
        slaTwoControllerEnglish: slaTwo,
        notifyRequesterChecked: notifyReqChecked,
        notifyProviderChecked: notifyProvChecked,
        notifyManagerChecked: notifyMgrChecked,
        notifyRequesterSwitch0: notifyReqSwitch0,
        notifyManagerSwitch1: notifyMgrSwitch1,
      );

      // Use saveDraft if provided, otherwise use SharedPrefs directly
      if (saveDraft != null) {
        await saveDraft!(completeModel);
      } else {
        await SharedPrefsServiceMaster.saveDraft(completeModel);
      }
    }

  }

  Future<void> _saveAllToSharedPrefs(BuildContext context) async {
    await SharedPrefsHelper.setString('sla_one', model.slaOneController.text.trim());
    await SharedPrefsHelper.setString('sla_two', model.slaTwoController.text.trim());
    await SharedPrefsHelper.setBool('Notify Service Requester_checked', model.notifyRequesterChecked);
    await SharedPrefsHelper.setBool('Notify Service Provider_checked', model.notifyProviderChecked);
    await SharedPrefsHelper.setBool('Notify Provider Manager_checked', model.notifyManagerChecked);

    final reqMap = model.notificationSwitches['notifyServiceRequester'] ?? {};
    final mgrMap = model.notificationSwitches['notifyProviderManager'] ?? {};
    model.notifyRequesterSwitch0 = reqMap[0] ?? false;
    model.notifyManagerSwitch1 = mgrMap[0] ?? false;

    await SharedPrefsHelper.setBool('notifyRequesterSwitch0', model.notifyRequesterSwitch0);
    await SharedPrefsHelper.setBool('notifyManagerSwitch1', model.notifyManagerSwitch1);

    await _saveExtraControllersToSharedPrefs();
  }

  String slug(String s) {
    return s
        .replaceAll(RegExp(r"[^\w]+"), "_")
        .replaceAll(RegExp(r"_+"), "_")
        .trim()
        .toLowerCase();
  }

  String getSubmitButtonText(BuildContext context, ServicesHistoryModel? editingModel, String submitText, String saveText) {
    if (editingModel == null) {
      return submitText;
    }

    final isDraft = editingModel.currentState == "draft" ||
        editingModel.currentDurationOfServices.isEmpty ||
        editingModel.currentDurationOfServices == "-";

    return isDraft ? submitText : saveText;
  }

  String getSaveForLaterText(BuildContext context, ServicesHistoryModel? editingModel, String submitText, String saveText) {
    if (editingModel == null) {
      return submitText;
    }

    final isDraft = editingModel.currentState == "draft" ||
        editingModel.currentDurationOfServices.isEmpty ||
        editingModel.currentDurationOfServices == "-";

    final isEditingSubmittedService = editingModel.currentState != "submitted";

    if (isEditingSubmittedService) {
      return saveText;
    } else if (isDraft) {
      return saveText;
    } else {
      return saveText;
    }
  }

  void _emitLoadedState() {
    emit(SlaNotificationLoaded(
      currentDocId: currentDocId,
      notifyRequesterChecked: model.notifyRequesterChecked,
      notifyProviderChecked: model.notifyProviderChecked,
      notifyManagerChecked: model.notifyManagerChecked,
      notifyRequesterSwitch0: model.notifyRequesterSwitch0,
      notifyManagerSwitch1: model.notifyManagerSwitch1,
      extraSlaList: model.extraSlaControllers.map((c) => c.text).toList(),
      extraSlaTwoList: model.extraSlaTwoControllers.map((c) => c.text).toList(),
      notificationSwitches: model.notificationSwitches,
    ));
  }

  @override
  Future<void> close() {
    model.dispose();
    return super.close();
  }
}
