import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/custom_validate_textfield.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/core/widgets/pagination_app_bar.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/knowledge_hub_module/core/theming/new_theme.dart';
import 'package:demo_app/features/roles/domain/enums/modules_enum.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/enumeration/enum.dart';
import '../../../../../../core/helper/haptic_controller.dart';
import '../../../../../../core/network/api_constants.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/role_model.dart';
import '../../../controller/role_cubit.dart';
import '../../../controller/modules_controller.dart';
import '../../widgets/role_management/role_image_editor.dart';
import 'role_permission_switches.dart';
import 'package:flutter/src/services/haptic_feedback.dart';
import '../../../../utils/role_log_service.dart';

class AddingNewRole extends StatefulWidget {
  AddingNewRole({super.key});

  @override
  State<AddingNewRole> createState() => _AddingNewRoleState();
}

class _AddingNewRoleState extends State<AddingNewRole> {
  late RoleCubit controller;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final controller = context.read<RoleCubit>();

      if (!controller.isEditing && controller.selectedRole == null) {
        controller.initAddingRoleController();
      }
    });
    RoleLogService.log(RoleLogService.pageAddNewRole);
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _containsArabic(String text) {
    
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  bool _containsEnglish(String text) {
    return RegExp(r'[a-zA-Z]').hasMatch(text);
  }

  // ─────────────────────────────────────────────
  // STATUS TOGGLE DIALOG — same style as services
  // ─────────────────────────────────────────────
  Future<bool> _showStatusConfirmDialog(BuildContext context, bool newValue) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _RoleStatusChangeDialog(activating: newValue),
    );
    return result ?? false;
  }

  // ── module loading helpers (unchanged) ──────────────────────────────────

  Future<List<String>> _getAllowedModulesForRoleCreation() async {
    try {
      ModulesController modulesController = Get.find<ModulesController>();
      List<String> masterAdminModules = modulesController.getDemoActiveModules();
      masterAdminModules.removeWhere((m) => m == 'home' || m == 'settings');

      Map<String, bool> companyLicensedModules = await _loadCompanyLicensedModules();

      List<String> allowedModules = [];
      for (var entry in companyLicensedModules.entries) {
        if (entry.value) allowedModules.add(entry.key);
      }
      return allowedModules;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, bool>> _loadCompanyLicensedModules() async {
    try {
      String? companyId = _extractCompanyId();

      if (companyId == null || companyId.isEmpty) {
        return {
          'services': true, 'tasks': true, 'tracking': true,
          'inventory': true, 'messages': true, 'roles': true,
          'knowledge_hub': true, 'knowledgehub': true, 'qiyas': true,
          'grc': true, 'form_builder': true, 'formbuilder': true,
          'todo': true, 'employees': true, 'events': true,
          'notes': true, 'requests': true, 'database': true,
          'notification': true, 'hr': true, 'database_builder': true,
        };
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('Demo_Requests')
          .doc(companyId)
          .get();

      if (!snapshot.exists) return {};

      final data = snapshot.data();
      if (data == null) return {};

      Map? modulesData;
      if (data['Demo_Details'] is Map &&
          (data['Demo_Details'] as Map)['Modules'] is Map) {
        modulesData = (data['Demo_Details'] as Map)['Modules'] as Map;
      } else if (data['Modules'] is Map) {
        modulesData = data['Modules'] as Map;
      }

      if (modulesData == null) return {};

      Map<String, bool> licensedModules = {};
      for (var entry in modulesData.entries) {
        final moduleName = entry.key.toString().toLowerCase();
        final moduleData = entry.value;
        bool isLicensed = false;

        if (moduleData is Map) {
          final values = moduleData['Values'];
          if (values is List && values.isNotEmpty) {
            isLicensed = values.last == true;
          }
        } else if (moduleData is bool) {
          isLicensed = moduleData;
        } else if (moduleData is List && moduleData.isNotEmpty) {
          isLicensed = moduleData.last == true;
        }

        licensedModules[moduleName] = isLicensed;
      }

      return licensedModules;
    } catch (e) {
      return {};
    }
  }

  String? _extractCompanyId() {
    if (ApiConstants.baseUri.isEmpty) return null;
    if (ApiConstants.baseUri.contains('/')) {
      List<String> parts = ApiConstants.baseUri.split('/');
      if (parts.length >= 2) return parts[1];
    }
    return null;
  }

  final HapticController hapticController = Get.put(HapticController());

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;
    bool isArabic = Get.locale?.languageCode == 'ar';
    controller = context.read<RoleCubit>();
    var isMobile = context.isPhone;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaginationAppBar(
                  screensTitles: (controller.isEditing)
                      ? [
                    'Platform Controls and Management'.tr,
                    'Role Details'.tr,
                    'Editing Role'.tr,
                  ]
                      : [
                    'Platform Controls and Management'.tr,
                    'Adding New Role'.tr,
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15.sp),
                    decoration: BoxDecoration(
                      color: AppColors.field,
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ── STATUS SWITCH ──────────────────────────────
                          BlocBuilder<RoleCubit, RoleState>(
                            buildWhen: (_, state) =>
                            state is RoleModuleSelected ||
                                state is RoleSelected,
                            builder: (context, state) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    S.of(context).active,
                                    style: StyleText.fontSize16Weight400.copyWith(
                                      color: AppColors.text,
                                    ),
                                  ),
                                  SizedBox(width: 10.sp),
                                  Transform(
                                    alignment: Alignment.center,
                                    transform: isArabic
                                        ? Matrix4.rotationY(3.14159)
                                        : Matrix4.identity(),
                                    child: FlutterSwitch(
                                      width: 38.sp,
                                      height: 22.sp,
                                      padding: 3.sp,
                                      borderRadius: 20.sp,
                                      toggleSize: 16.sp,
                                      activeColor: AppColors.secondaryPrimary,
                                      inactiveColor:
                                      Colors.grey.withOpacity(.16),
                                      // ✅ reads from cubit
                                      value: controller.isActive,
                                      onToggle: (newValue) async {
                                        // ✅ show confirmation dialog first
                                        final confirmed =
                                        await _showStatusConfirmDialog(
                                            context, newValue);
                                        if (confirmed) {
                                          controller
                                              .toggleActiveStatus(newValue);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          SizedBox(height: 15.sp),
                          RoleImageEditor(),
                          SizedBox(height: 15.sp),

                          // ── NAME FIELDS ────────────────────────────────
                          if (isMobile)
                            Column(
                              children: isArabic
                                  ? [
                                _buildArabicNameField(),
                                SizedBox(height: 15.sp),
                                _buildEnglishNameField(),
                              ]
                                  : [
                                _buildEnglishNameField(),
                                SizedBox(height: 15.sp),
                                _buildArabicNameField(),
                              ],
                            )
                          else
                            Row(
                              children: isArabic
                                  ? [
                                Expanded(child: _buildArabicNameField()),
                                SizedBox(width: 20.sp),
                                Expanded(child: _buildEnglishNameField()),
                              ]
                                  : [
                                Expanded(child: _buildEnglishNameField()),
                                SizedBox(width: 20.sp),
                                Expanded(child: _buildArabicNameField()),
                              ],
                            ),

                          SizedBox(height: 15.sp),

                          // ── DESCRIPTION FIELDS ─────────────────────────
                          if (isArabic) ...[
                            _buildArabicDescriptionField(),
                            SizedBox(height: 15.sp),
                            _buildEnglishDescriptionField(),
                          ] else ...[
                            _buildEnglishDescriptionField(),
                            SizedBox(height: 15.sp),
                            _buildArabicDescriptionField(),
                          ],

                          SizedBox(height: 15.sp),

                          Text(
                            S.of(context).selectModules,
                            style: AppTextStyles.font16BlackRegularCairo,
                          ),

                          SizedBox(height: 15.sp),

                          // ── MODULE GRID ────────────────────────────────
                          FutureBuilder<List<String>>(
                            future: _getAllowedModulesForRoleCreation(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: CircleProgressMaster(),
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    "Error loading modules: ${snapshot.error}",
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }

                              List<String> allowedModuleNames =
                                  snapshot.data ?? [];

                              if (allowedModuleNames.isEmpty) {
                                return Container(
                                  padding: const EdgeInsets.all(20),
                                  child: const Text(
                                    "No modules available. Please contact your administrator.",
                                    style: TextStyle(
                                        color: Colors.orange, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }

                              List<Modules> activeModules = [];
                              for (var moduleName in allowedModuleNames) {
                                try {
                                  activeModules
                                      .add(_stringToModuleEnum(moduleName));
                                } catch (e) {
                                  // skip unknown modules
                                }
                              }

                              return BlocBuilder<RoleCubit, RoleState>(
                                buildWhen: (_, state) =>
                                state is RoleModuleSelected,
                                builder: (context, state) {
                                  return GridView.builder(
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: activeModules.length,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isTablet ? 14 : 4,
                                      mainAxisSpacing: 10.sp,
                                      crossAxisSpacing: 10.sp,
                                      mainAxisExtent: 55.w,
                                      childAspectRatio: 1,
                                    ),
                                    itemBuilder: (_, index) {
                                      return _moduleItem(
                                          activeModules[index], context);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.sp),

                BlocBuilder<RoleCubit, RoleState>(
                  buildWhen: (_, state) => state is RoleModuleSelected,
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          width: isTablet ? 135 : 120,
                          onTap: () => Navigator.of(context).pop(),
                          buttonText: 'Discard'.tr,
                          buttonColor: AppColors.secondaryButton,
                          textStyle: AppTextStyles.font16BlackRegularCairo,
                        ),
                        CustomButton(
                          width: isTablet ? 135 : 120,
                          onTap: () => _onNextPressed(context),
                          buttonText: 'Next'.tr,
                          buttonColor: AppColors.primary,
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 20.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── field builders (unchanged) ──────────────────────────────────────────

  Widget _buildEnglishNameField() {
    return Customdemo_appTextField(
      labelEn: 'Role Name',
      labelAr: 'اسم الدور',
      hintEn: 'Role Name',
      hintAr: 'Role Name',
      controller: controller.roleNameController,
      language: AppLanguage.english,
      isRequired: true,
      validationType: ValidationType.custom,
      fillColor: AppColors.background,
      borderColor: AppColors.secondaryText.withOpacity(0.2),
      focusedBorderColor: AppColors.primary,
      errorBorderColor: Colors.red,
      borderRadius: 8,
      height: 65.h,
      inputStyle: StyleText.fontSize14Weight500.copyWith(
          color: AppColors.secondaryText),
      hintStyle: StyleText.fontSize14Weight500
          .copyWith(color: AppColors.secondaryText.withOpacity(.5)),
      labelStyle:
      AppTextStyles.font16BlackRegularCairo.copyWith(fontSize: 14.sp),
      onChanged: (value) => controller.emit(RoleModuleSelected()),
      customValidator: (value) {
        if (value == null || value.trim().isEmpty)
          return 'Role Name is required'.tr;
        if (!_containsEnglish(value)) return 'Please write in English'.tr;
        if (_containsArabic(value))
          return 'Arabic characters not allowed here'.tr;
        if (controller.isEditing || controller.selectedRole != null) {
          String? originalRoleName = controller.selectedRole?.currentRoleName;
          if (originalRoleName?.toLowerCase() == value.trim().toLowerCase())
            return null;
          bool nameExists = controller.roles.any((role) =>
          role.currentRoleName.toLowerCase() ==
              value.trim().toLowerCase() &&
              role.currentRoleName != originalRoleName);
          if (nameExists) return 'Role Name Already Exists'.tr;
          return null;
        }
        bool nameExists = controller.roles.any((role) =>
        role.currentRoleName.toLowerCase() == value.trim().toLowerCase());
        if (nameExists) return 'Role Name Already Exists'.tr;
        return null;
      },
    );
  }

  Widget _buildArabicNameField() {
    return Customdemo_appTextField(
      labelEn: 'Role Name',
      labelAr: 'اسم الدور',
      hintEn: 'اسم الدور',
      hintAr: 'اسم الدور',
      controller: controller.roleNameControllerAr,
      language: AppLanguage.arabic,
      isRequired: true,

      validationType: ValidationType.custom,
      fillColor: AppColors.background,
      borderColor: AppColors.secondaryText.withOpacity(0.2),
      focusedBorderColor: AppColors.primary,
      errorBorderColor: Colors.red,
      borderRadius: 8,
      height: 65.h,
      inputStyle: StyleText.fontSize14Weight500.copyWith(
          color: AppColors.secondaryText),
      hintStyle: StyleText.fontSize14Weight500
          .copyWith(color: AppColors.secondaryText.withOpacity(.5)),
      labelStyle:
      AppTextStyles.font16BlackRegularCairo.copyWith(fontSize: 14.sp),
      onChanged: (value) => controller.emit(RoleModuleSelected()),
      customValidator: (value) {
        if (value == null || value.trim().isEmpty) return 'اسم الدور مطلوب';
        if (!_containsArabic(value)) return 'يرجى الكتابة بالعربية';
        if (_containsEnglish(value)) return 'الأحرف الإنجليزية غير مسموحة هنا';
        if (controller.isEditing || controller.selectedRole != null) {
          String? originalRoleNameAr =
              controller.selectedRole?.currentRoleNameAr;
          if (originalRoleNameAr?.toLowerCase() == value.trim().toLowerCase())
            return null;
          bool nameExists = controller.roles.any((role) =>
          role.currentRoleNameAr.toLowerCase() ==
              value.trim().toLowerCase() &&
              role.currentRoleNameAr != originalRoleNameAr);
          if (nameExists) return 'اسم الدور موجود مسبقاً';
          return null;
        }
        bool nameExists = controller.roles.any((role) =>
        role.currentRoleNameAr.toLowerCase() == value.trim().toLowerCase());
        if (nameExists) return 'اسم الدور موجود مسبقاً';
        return null;
      },
    );
  }

  Widget _buildEnglishDescriptionField() {
    return Customdemo_appTextField(
      labelEn: 'Role Description',
      labelAr: 'وصف الدور',
      hintEn: 'Role Description',
      hintAr: 'Role Description',
      controller: controller.roleDescriptionController,
      language: AppLanguage.english,
      isRequired: true,
      validationType: ValidationType.custom,
      maxLines: 3,
      minLines: 3,
      maxLength: 500,
      showCharacterCount: true,
      fillColor: AppColors.background,
      borderColor: AppColors.secondaryText.withOpacity(0.2),
      focusedBorderColor: AppColors.primary,
      errorBorderColor: Colors.red,
      borderRadius: 8,
      inputStyle: StyleText.fontSize14Weight500.copyWith(
          color: AppColors.secondaryText),
      hintStyle: StyleText.fontSize14Weight500
          .copyWith(color: AppColors.secondaryText.withOpacity(.5)),
      labelStyle:
      AppTextStyles.font16BlackRegularCairo.copyWith(fontSize: 14.sp),
      customValidator: (value) {
        if (value == null || value.trim().isEmpty)
          return 'Description is required'.tr;
        if (!_containsEnglish(value)) return 'Please write in English'.tr;
        if (_containsArabic(value))
          return 'Arabic characters not allowed here'.tr;
        return null;
      },
    );
  }

  Widget _buildArabicDescriptionField() {
    return Customdemo_appTextField(
      labelEn: 'Role Description',
      labelAr: 'وصف الدور',
      hintEn: 'اكتب وصف',
      hintAr: 'اكتب وصف',
      controller: controller.roleDescriptionControllerAr,
      language: AppLanguage.arabic,
      isRequired: true,
      validationType: ValidationType.custom,
      maxLines: 3,
      minLines: 3,
      maxLength: 500,
      showCharacterCount: true,
      fillColor: AppColors.background,
      borderColor: AppColors.secondaryText.withOpacity(0.2),
      focusedBorderColor: AppColors.primary,
      errorBorderColor: Colors.red,
      borderRadius: 8,
      inputStyle: StyleText.fontSize14Weight500.copyWith(
          color: AppColors.secondaryText),
      hintStyle: StyleText.fontSize14Weight500
          .copyWith(color: AppColors.secondaryText.withOpacity(.5)),
      labelStyle:
      AppTextStyles.font16BlackRegularCairo.copyWith(fontSize: 14.sp),
      customValidator: (value) {
        if (value == null || value.trim().isEmpty) return 'الوصف مطلوب';
        if (!_containsArabic(value)) return 'يرجى الكتابة بالعربية';
        if (_containsEnglish(value)) return 'الأحرف الإنجليزية غير مسموحة هنا';
        return null;
      },
    );
  }

  Widget _moduleItem(Modules module, BuildContext context) {
    String moduleString = _moduleEnumToString(module);
    bool isSelected = controller.selectedModules.contains(moduleString);

    return InkWell(
      onTap: () async {
        if (module != Modules.settings) {
          await controller.selectModule(moduleString);
        }
      },
      child: Container(
        width: 40.sp,
        height: 40.sp,
        padding: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          color: (isSelected || module == Modules.settings)
              ? AppColors.primary
              : AppColors.background,
          borderRadius: BorderRadius.circular(4.sp),
        ),
        child: SvgPicture.asset(
          module.iconPath,
          height: 30.sp,
          width: 30.sp,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
            (isSelected || module == Modules.settings)
                ? AppColors.textButton
                : AppColors.secondaryBlack,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  void _onNextPressed(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    RoleLogService.log(RoleLogService.actionCreateRole);

    hapticController.triggerHapticFeedback(
        vibration: VibrateType.mediumImpact,
        hapticFeedback: HapticFeedback.mediumImpact);

    await controller.ensureSettingsSelected();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider<RoleCubit>.value(
          value: controller,
          child: RolePermissionSwitches(),
        ),
      ),
    );
  }

  Modules _stringToModuleEnum(String moduleName) {
    switch (moduleName.toLowerCase()) {
      case 'services': return Modules.services;
      case 'employees': return Modules.employees;
      case 'tasks': return Modules.tasks;
      case 'todo': return Modules.todo;
      case 'notes': return Modules.notes;
      case 'events': return Modules.events;
      case 'requests': return Modules.requests;
      case 'knowledge_hub':
      case 'knowledgehub': return Modules.knowledgeHub;
      case 'qiyas': return Modules.qiyas;
      case 'inventory': return Modules.inventory;
      case 'tracking': return Modules.tracking;
      case 'grc': return Modules.grc;
      case 'database': return Modules.database;
      case 'messages': return Modules.messages;
      case 'form_builder':
      case 'formbuilder': return Modules.formBuilder;
      case 'roles': return Modules.roles;
      case 'settings': return Modules.settings;
      case 'notification': return Modules.notification;
      default: throw Exception("Unknown module: $moduleName");
    }
  }

  String _moduleEnumToString(Modules module) {
    switch (module) {
      case Modules.services: return 'services';
      case Modules.employees: return 'employees';
      case Modules.tasks: return 'tasks';
      case Modules.todo: return 'todo';
      case Modules.notes: return 'notes';
      case Modules.events: return 'events';
      case Modules.requests: return 'requests';
      case Modules.knowledgeHub: return 'knowledge_hub';
      case Modules.qiyas: return 'qiyas';
      case Modules.inventory: return 'inventory';
      case Modules.messages: return 'messages';
      case Modules.database: return 'database';
      case Modules.formBuilder: return 'form_builder';
      case Modules.grc: return 'grc';
      case Modules.tracking: return 'tracking';
      case Modules.notification: return 'notification';
      case Modules.hr: return 'hr';
      case Modules.roles: return 'roles';
      case Modules.settings: return 'settings';
      default: return 'settings';
    }
  }
}

// ════════════════════════════════════════════════════════════════
// DIALOG — matches StatusChangeDialog from services exactly
// ════════════════════════════════════════════════════════════════

class _RoleStatusChangeDialog extends StatelessWidget {
  final bool activating;

  const _RoleStatusChangeDialog({required this.activating});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Container(
        width: 411.sp,
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/Edit Document.json',
              width: 70.w,
              height: 70.h,
              fit: BoxFit.scaleDown,
              repeat: true,
              animate: true,
            ),
            SizedBox(height: 20.sp),
            Text(
              S.of(context).changingStatus,
              style: StyleText.fontSize20Weight500.copyWith(
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 18.sp),
            Text(
              activating
                  ? S.of(context).areYouSureYouWantToActivateThisRole
                  : S.of(context).areYouSureYouWantToDeactivateThisRole,
              textAlign: TextAlign.center,
              style: StyleText.fontSize14Weight500.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            SizedBox(height: 15.sp),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      height: 38.sp,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryText,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        S.of(context).no,
                        style: StyleText.fontSize16Weight500
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 28.sp),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Container(
                      height: 38.sp,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        S.of(context).yes,
                        style: StyleText.fontSize16Weight500.copyWith(
                          color: AppColors.textButton,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}