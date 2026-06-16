import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/core/widgets/dialogs/confirmation_dialog.dart';
import 'package:demo_app/core/widgets/shared_action_widgets.dart';
import 'package:demo_app/core/widgets/side_frame_master.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/core/widgets/custom_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/helper/circle_progress.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/Category/presentation/ui/services_admin/Widget/W3_Frame_Screen_tablet.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/core/custom_button_with_image.dart';
import 'package:demo_app/features/roles/presentation/controller/user_management_cubit.dart';
import 'package:demo_app/features/roles/presentation/ui/pages/user_management/showEditUserAccessDialog.dart';
import 'dart:ui' as ui;

import 'package:demo_app/core/shared_components/timeline_widget.dart';
import '../../../../../../core/enumeration/enum.dart' as FormatHelper;
import '../../../../../../core/enumeration/enum.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../generated/l10n.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../employee/data/models/emplyees_model/new_employee_model.dart';
import '../../../../../employee/domain/entities/employee_entity.dart';
import '../../../../../employee/presentation/controller/main_core_employee_controller.dart';
import '../../../../../messaging/interface/message_interface_consumer.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/Category/presentation/ui/service_department_manager/mobile/dashBoard_master_mobile/widget/dialog.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/core/new_theme.dart';
import '../../../../domain/entity/user_permission_entity.dart';
import '../../../../domain/enums/modules_enum.dart';
import '../../../../domain/enums/roles/roles_permissions_sections.dart';
import '../../../../domain/enums/roles/user_mangment_permission.dart';
import '../../../../utils/constants.dart';
import '../../../controller/role_cubit.dart';
import '../../../../utils/role_log_service.dart';
import '../../widgets/user_management/user_widget].dart';

class RoleEmployeeDetailsPage extends StatefulWidget {
  final UserPermissionEntity userPermission;

  const RoleEmployeeDetailsPage({super.key, required this.userPermission});

  @override
  State<RoleEmployeeDetailsPage> createState() =>
      _RoleEmployeeDetailsPageState();
}

class _RoleEmployeeDetailsPageState extends State<RoleEmployeeDetailsPage> {
  final MainCoreEmployeeController employeeController =
  Get.find<MainCoreEmployeeController>();

  EmployeeEntityPro? currentEmployeeEntity;

  bool _permissionsLoaded = false;
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, List<String>> _modulePermissions = {};
  List<String> activeModuleStrings = [];

  // ── Shared month lists ────────────────────────────────────────────────────
  static const _enMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _arMonths = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  // ── Master date formatter ─────────────────────────────────────────────────
  /// Always returns Western numerals: "24 Aug 2023" / "24 أغسطس 2023"
  String _formatDate(String? rawDate, bool isArabic) {
    if (rawDate == null || rawDate.isEmpty || rawDate == '-') return '-';

    DateTime? parsed;
    try {
      // 1. ISO with T  e.g. "2023-08-24T10:30:00"
      if (rawDate.contains('T')) {
        parsed = DateTime.parse(rawDate);
      }
      // 2. Space-separated timestamp  e.g. "2026-01-09 16:20:58.514133"
      else if (rawDate.contains('-') && rawDate.contains(' ')) {
        parsed = DateTime.parse(rawDate.replaceFirst(' ', 'T'));
      }
      // 3. Pure date  e.g. "2023-08-24"
      else if (rawDate.contains('-') && !rawDate.contains(' ')) {
        parsed = DateTime.parse(rawDate);
      }
      // 4. dd/MM/yyyy
      else if (rawDate.contains('/')) {
        final parts = rawDate.split('/');
        if (parts.length == 3) {
          parsed = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      }
      // 5. Already a readable string — try common EN formats
      else if (rawDate.contains(' ') || rawDate.contains(',')) {
        final formats = [
          'dd MMM yyyy',
          'MMM dd, yyyy',
          'dd MMMM yyyy',
          'MMMM dd, yyyy',
          'MMM dd yyyy',
          'dd MMM yyyy, hh:mm a',
        ];
        for (final fmt in formats) {
          try {
            parsed = DateFormat(fmt, 'en').parse(rawDate);
            break;
          } catch (_) {}
        }
      }
    } catch (_) {}

    if (parsed == null) return rawDate; // give up — return as-is

    // Build string manually → always Western numerals
    final day   = parsed.day.toString().padLeft(2, '0');
    final month = isArabic
        ? _arMonths[parsed.month - 1]
        : _enMonths[parsed.month - 1];
    final year  = parsed.year.toString();
    return '$day $month $year';
  }

  @override
  void initState() {
    super.initState();
    RoleLogService.log(RoleLogService.pageEmployeeDetails);
    _loadEmployeeData();
    _initializePage();
  }

  Future<void> _initializePage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final roleCubit = context.read<RoleCubit>();
      if (roleCubit.roles.isEmpty) {
        await roleCubit.getUnDeletedRoles();
      }
      await _loadPermissions();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _loadEmployeeData() {
    try {
      currentEmployeeEntity =
          employeeController.allEmployeesEntities?.firstWhereOrNull(
                (employee) => employee.id == widget.userPermission.employeeId,
          );
      if (currentEmployeeEntity != null && mounted) setState(() {});
    } catch (e) {
      debugPrint('❌ Error loading employee data: $e');
    }
  }

  Future<void> _loadPermissions() async {
    if (_permissionsLoaded) return;

    final roleName = widget.userPermission.accessName;

    if (roleName == null || roleName.isEmpty) {
      setState(() {
        _permissionsLoaded = true;
        _isLoading = false;
      });
      return;
    }

    try {
      final roleCubit = context.read<RoleCubit>();

      if (roleCubit.roles.isEmpty) {
        await roleCubit.getUnDeletedRoles();
      }

      if (roleCubit.roles.isEmpty) {
        setState(() {
          _errorMessage = 'No roles found. Please try again.';
          _isLoading = false;
        });
        return;
      }

      final role = roleCubit.roles.firstWhereOrNull(
            (r) => r.roleId == roleName || r.currentRoleName == roleName,
      );

      if (role == null) {
        setState(() {
          _errorMessage = 'Role "$roleName" not found';
          _isLoading = false;
        });
        return;
      }

      activeModuleStrings = role.currentSelectedModules;

      var result = await roleCubit.roleRepository.getAllRolePermissions(
        roleId: role.roleId,
        selectedModules: activeModuleStrings,
      );

      if (result.isRight()) {
        Map<String, Map<String, dynamic>> allPermissions =
        result.getOrElse(() => {});

        for (String moduleName in activeModuleStrings) {
          List<String> activePermissions = [];

          if (allPermissions.containsKey(moduleName)) {
            Map<String, dynamic> moduleData = allPermissions[moduleName]!;

            moduleData.forEach((key, value) {
              if (key != 'Role_Id' && key != 'timestamps') {
                bool isActive = false;
                if (value is List && value.isNotEmpty) {
                  var lastValue = value.last;
                  isActive =
                  (lastValue == true || lastValue == 1 || lastValue == '1');
                } else if (value is bool) {
                  isActive = value;
                }
                if (isActive) activePermissions.add(key);
              }
            });
          }

          _modulePermissions[moduleName] = activePermissions;
        }
      }

      setState(() {
        _permissionsLoaded = true;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading permissions: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatPermissionName(String permissionKey) {
    String formatted = permissionKey
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
        ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
        : '')
        .join(' ');
    return formatted.tr;
  }

  String _getModuleDisplayName(String moduleName) {
    switch (moduleName.toLowerCase()) {
      case 'services':         return 'Services'.tr;
      case 'todo':             return 'To Do List'.tr;
      case 'notes':            return 'Notes'.tr;
      case 'knowledge_hub':    return 'Knowledge Hub'.tr;
      case 'notification':
      case 'notifications':    return S.of(context).notifications;
      case 'qiyas':
      case 'grc':              return 'Qiyas'.tr;
      case 'inventory':        return 'Inventory'.tr;
      case 'messages':         return 'Messages'.tr;
      case 'form_builder':     return 'Form Builder'.tr;
      case 'roles':            return 'Roles'.tr;
      case 'settings':         return 'Settings'.tr;
      case 'employees':        return 'Employees'.tr;
      case 'tasks':            return 'Tasks'.tr;
      case 'events':           return 'Events'.tr;
      case 'requests':         return 'Requests'.tr;
      case 'tracking':         return 'Tracking'.tr;
      case 'database_builder': return 'Database Builder'.tr;
      default:
        return moduleName
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1)}'
            : '')
            .join(' ')
            .tr;
    }
  }

  Modules? _getModuleEnum(String moduleName) {
    switch (moduleName.toLowerCase().trim()) {
      case 'employees':         return Modules.employees;
      case 'services':          return Modules.services;
      case 'tasks':             return Modules.tasks;
      case 'todo':              return Modules.todo;
      case 'events':            return Modules.events;
      case 'notes':             return Modules.notes;
      case 'requests':          return Modules.requests;
      case 'knowledge_hub':
      case 'knowledgehub':      return Modules.knowledgeHub;
      case 'qiyas':             return Modules.qiyas;
      case 'grc':               return Modules.grc;
      case 'tracking':          return Modules.tracking;
      case 'inventory':         return Modules.inventory;
      case 'messages':          return Modules.messages;
      case 'database_builder':
      case 'database':          return Modules.database;
      case 'form_builder':
      case 'formbuilder':       return Modules.formBuilder;
      case 'roles':             return Modules.roles;
      case 'settings':          return Modules.settings;
      case 'home':              return Modules.home;
      case 'notification':
      case 'notifications':     return Modules.notification;
      default:                  return null;
    }
  }

  String _getSupervisorName() {
    if (currentEmployeeEntity?.supervisor == null ||
        currentEmployeeEntity!.supervisor!.isEmpty) return '-';
    return employeeController
        .getEmployeeName(currentEmployeeEntity!.supervisor!);
  }

  String _getCurrentRoleName() {
    if (currentEmployeeEntity != null &&
        currentEmployeeEntity!.role != null &&
        currentEmployeeEntity!.role!.isNotEmpty) {
      final currentRole = currentEmployeeEntity!.role!;
      if (currentRole.isEmpty) return 'No Role'.tr;

      try {
        final roleCubit = context.read<RoleCubit>();
        final role = roleCubit.roles.firstWhereOrNull(
                (r) => r.roleId == currentRole || r.currentRoleName == currentRole);

        if (role != null) {
          final isArabic =
              Localizations.localeOf(context).languageCode == 'ar';
          return isArabic
              ? (role.currentRoleNameAr ?? role.currentRoleName)
              : role.currentRoleName;
        }
        return currentRole;
      } catch (e) {
        return currentRole;
      }
    }

    final roleName = widget.userPermission.getLocalizedRoleName();
    return roleName.isEmpty ? 'No Role'.tr : roleName;
  }

  String _getTotalModules() {
    if (widget.userPermission.accessName == null ||
        widget.userPermission.accessName!.isEmpty) return '0';
    try {
      final roleCubit = context.read<RoleCubit>();
      final role = roleCubit.roles.firstWhereOrNull((r) =>
      r.roleId == widget.userPermission.accessName ||
          r.currentRoleName == widget.userPermission.accessName);
      if (role != null && role.currentSelectedModules.isNotEmpty) {
        return role.currentSelectedModules.length.toString();
      }
      return '0';
    } catch (e) {
      return '0';
    }
  }

  Future<bool> _removeUserAccess({required String employeeId}) async {
    try {
      final userMgmtCubit = context.read<UserManagementAccessCubit>();
      final currentUserEmail =
      Get.find<MainCoreEmployeeController>().employeeEntity!.email!;

      final dynamic result =
      await userMgmtCubit.repository.deleteEmployeePermission(
        employeeId: employeeId,
        currentUserEmail: currentUserEmail,
      );

      final resultStr = result.toString();
      if (resultStr.startsWith('Left(')) return false;
      return true;
    } catch (e) {
      debugPrint('❌ Error removing user access: $e');
      return false;
    }
  }

  void _showTimedSuccessDialog({
    required BuildContext context,
    required String lottiePath,
    required String title,
    required String message,
    int seconds = 3,
    required VoidCallback onAfterDismiss,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        Future.delayed(Duration(seconds: seconds), () {
          if (Navigator.of(dialogCtx, rootNavigator: true).canPop()) {
            Navigator.of(dialogCtx, rootNavigator: true).pop();
          }
          onAfterDismiss();
        });
        return ConfirmationDialog(
          lottiePath: lottiePath,
          title: title,
          message: message,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SafeArea(
        child: SideFrameMaster(
          titleText: 'Platform Controls and Management'.tr,
          onFirstTap: () => Navigator.pop(context),
          secondTitle: S.of(context).employeeDetails,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 200.h,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleProgressMaster(),
                  SizedBox(height: 16.sp),
                  Text(
                    S.of(context).loadingEmployeeDetails,
                    style: StyleText.fontSize16Weight400
                        .copyWith(color: AppColors.text),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return SafeArea(
        child: SideFrameMasterServices(
          titleText: 'Platform Controls and Management'.tr,
          onFirstTap: () => Navigator.pop(context),
          secondTitle: S.of(context).employeeDetails,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                SizedBox(height: 16.sp),
                Text('Error loading data'.tr,
                    style: StyleText.fontSize16Weight400),
                SizedBox(height: 8.sp),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.sp),
                  child: Text(
                    _errorMessage!,
                    style: AppTextStyles.font12BlackCairoRegular,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16.sp),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });
                    _initializePage();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  child: Text('Retry'.tr),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _buildContent();
  }

  Widget _buildContent() {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isTablet = context.isTablet;
    final isMobile = context.isPhone;
    final isLandscape = context.isLandscape;

    return SafeArea(
      child: SideFrameMasterServices(
        titleText: 'Platform Controls and Management'.tr,
        onFirstTap: () => Navigator.pop(context),
        secondTitle: S.of(context).employeeDetails,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // ── Edit / Delete buttons ────────────────────────────────────
              Row(
                children: [
                  const Spacer(),
                  if (Get.find<MainCoreEmployeeController>().isHasPermission(
                    module: Modules.roles,
                    section: RolePermissionsSections.userManagement,
                    permission: UserManagement.editAccess,
                  ))
                    customButtonWithImage(
                      title: context.isPhone ? '' : S.of(context).edit,
                      function: () async {
                        final result = await showEditUserAccessDialog(
                          context: context,
                          userPermission: widget.userPermission,
                        );

                        if (result == null || result is! Map<String, dynamic>)
                          return;
                        if (!mounted) return;

                        final nav = Navigator.of(context);
                        final rootNav =
                        Navigator.of(context, rootNavigator: true);
                        final messenger = ScaffoldMessenger.of(context);
                        final userMgmtCubit =
                        context.read<UserManagementAccessCubit>();
                        final currentUserEmail =
                        Get.find<MainCoreEmployeeController>()
                            .employeeEntity!
                            .email!;

                        rootNav.push(PageRouteBuilder(
                          opaque: false,
                          barrierDismissible: false,
                          barrierColor: Colors.black38,
                          pageBuilder: (_, __, ___) => WillPopScope(
                            onWillPop: () async => false,
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primary),
                            ),
                          ),
                        ));

                        try {
                          final String selectedRole = result['role'] ?? '';
                          final DateTime accessGranted =
                          result['accessGranted'];
                          final DateTime accessRevoked =
                          result['accessRevoked'];

                          final String startDateStr = DateFormat(
                              Constants.userAccessDateFormat)
                              .format(accessGranted);
                          final String endDateStr =
                          DateFormat(Constants.userAccessDateFormat)
                              .format(accessRevoked);

                          final updateResult = await userMgmtCubit.repository
                              .updateUserPermission(
                            employeeId: widget.userPermission.employeeId,
                            currentUserEmail: currentUserEmail,
                            accessName: selectedRole,
                            accessBegin: startDateStr,
                            accessEnd: endDateStr,
                          );

                          if (updateResult.isLeft()) {
                            final errMsg = updateResult.fold(
                                    (l) => l.errMessage, (r) => 'Unknown error');
                            throw Exception(errMsg);
                          }

                          rootNav.pop();

                          Get.find<MainCoreEmployeeController>()
                              .getAllNewEmployees()
                              .ignore();
                          try {
                            userMgmtCubit.getUserAccess();
                          } catch (_) {}

                          if (!mounted) return;
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (dialogCtx) {
                              Future.delayed(const Duration(seconds: 2), () {
                                if (Navigator.of(dialogCtx,
                                    rootNavigator: true)
                                    .canPop()) {
                                  Navigator.of(dialogCtx, rootNavigator: true)
                                      .pop();
                                }
                                nav.pop(true);
                              });
                              return ConfirmationDialog(
                                lottiePath: 'assets/lottie/approved.json',
                                title: 'Access Updated'.tr,
                                message:
                                'User access has been successfully updated'
                                    .tr,
                              );
                            },
                          );
                        } catch (e) {
                          rootNav.pop();
                          messenger.showSnackBar(SnackBar(
                            content: Text(
                                'Failed to update access: ${e.toString()}'),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          ));
                        }
                      },
                      textStyle: StyleText.fontSize16Weight500.copyWith(
                        color: AppColors.textButton,
                      ),
                      width: context.isPhone ? 38.sp : 135.sp,
                      height: 38.sp,
                      space: context.isPhone ? 0 : 8.sp,
                      radius: 8.r,
                      color: AppColors.primary,
                      image: 'assets/skeleton/common/icons/edit.svg',
                      svgColor: AppColors.textButton,
                      widthImage: 15.sp,
                      heightImage: 15.sp,
                      colorBorder: Colors.transparent,
                    ),

                  if (Get.find<MainCoreEmployeeController>().isHasPermission(
                    module: Modules.roles,
                    section: RolePermissionsSections.userManagement,
                    permission: UserManagement.removeAccess,
                  ))
                    SizedBox(width: 15.sp),

                  if (Get.find<MainCoreEmployeeController>().isHasPermission(
                    module: Modules.roles,
                    section: RolePermissionsSections.userManagement,
                    permission: UserManagement.removeAccess,
                  ))
                    customButtonWithImage(
                      title: context.isPhone ? "" : S.of(context).delete,
                      function: () async {
                        final confirmed = await CustomConfirmationDialog.show(
                          context: context,
                          title: S.of(context).remove_access,
                          message: S.of(context).remove_access_confirmation,
                          lottieAsset: 'assets/lottie/delete.json',
                          confirmText: S.of(context).yes,
                          cancelText: S.of(context).no,
                          confirmButtonColor: AppColors.primary,
                        );

                        if (!confirmed) return;
                        if (!mounted) return;

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (dialogContext) => WillPopScope(
                            onWillPop: () async => false,
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primary),
                            ),
                          ),
                        );

                        try {
                          final success = await _removeUserAccess(
                              employeeId: widget.userPermission.employeeId);

                          if (mounted) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }

                          if (success) {
                            await employeeController.getAllNewEmployees();
                            await Future.delayed(
                                const Duration(milliseconds: 300));

                            if (!mounted) return;

                            _showTimedSuccessDialog(
                              context: context,
                              lottiePath: 'assets/lottie/approved.json',
                              title: S.of(context).access_removed,
                              message: S.of(context).access_removed_success,
                              seconds: 3,
                              onAfterDismiss: () {
                                if (!mounted) return;
                                try {
                                  context
                                      .read<UserManagementAccessCubit>()
                                      .getUserAccess();
                                } catch (e) {
                                  debugPrint(
                                      '⚠️ Could not refresh user access list: $e');
                                }
                                Navigator.of(context).pop(true);
                              },
                            );
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Failed to remove user access. Please try again.'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          debugPrint('❌ Error in delete button handler: $e');
                          if (mounted) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                Text('An error occurred: ${e.toString()}'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      },
                      textStyle: StyleText.fontSize16Weight500.copyWith(
                        color: AppColors.white,
                      ),
                      width: context.isPhone ? 38.sp : 135.sp,
                      height: 38.sp,
                      space: context.isPhone ? 0 : 8.sp,
                      radius: 8.r,
                      color: const Color(0xffDF1C1C),
                      image: "assets/images/delete_person.svg",
                      svgColor: Colors.white,
                      widthImage: 15.sp,
                      heightImage: 15.sp,
                      colorBorder: Colors.transparent,
                    ),
                ],
              ),

              // ── Employee Details title ────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).employeeDetails,
                    style: StyleText.fontSize16Weight500.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.sp),

              _buildEmployeeHeader(
                  lightMode, isArabic, isMobile, isTablet, isLandscape),

              SizedBox(height: 16.sp),

              // ── Info container ────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.card,
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Column(
                    children: [
                      // ── Row 1: access grantor | supervisor | access granted ──
                      Row(
                        children: [
                          AccessGrantorWidget(
                            title: S.of(context).access_grantor,
                            name: widget.userPermission.grantorName.isNotEmpty
                                ? widget.userPermission.grantorName
                                : '-',
                          ),
                          SizedBox(width: 10.w),
                          AccessGrantorWidget(
                            title: S.of(context).supervisor,
                            name: _getSupervisorName(),
                          ),
                          SizedBox(width: 10.w),
                          AccessGrantorWidget(
                            title: S.of(context).access_granted,
                            name: _formatDate(
                              widget.userPermission.startDate,
                              isArabic,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          AccessGrantorWidget(
                            title: S.of(context).access_revoked,
                            name: _formatDate(
                              widget.userPermission.endDate,
                              isArabic,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          AccessGrantorWidget(
                            title: S.of(context).last_login,
                            name: _formatDate(
                              currentEmployeeEntity?.lastLogin,
                              isArabic,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          AccessGrantorWidget(
                            title: S.of(context).total_modules,
                            name: _getTotalModules(),
                          ),
                        ],
                      ),



                      SizedBox(height: 16.h),

                      _buildPermissionsSection(lightMode),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String statusName) {
    final normalizedStatus = statusName.toLowerCase().replaceAll(' ', '');
    switch (normalizedStatus) {
      case 'active':        return const Color(0xFF4BB609);
      case 'inactive':      return const Color(0xFFDF1C1C);
      case 'scheduled':     return const Color(0xFFFF814A);
      case 'expiringsoon':  return const Color(0xFF991010);
      default:              return AppColors.text;
    }
  }

  Widget _buildPermissionsSection(bool lightMode) {
    if (!_permissionsLoaded) {
      return Container(
        decoration: BoxDecoration(
          color: lightMode
              ? AppColors.white
              : AppColors.chatBackground,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    if (_modulePermissions.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: lightMode
              ? AppColors.white
              : AppColors.chatBackground,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Text(
              'No permissions found'.tr,
              style: AppTextStyles.font14BlackCairoRegular.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color:
        lightMode ? AppColors.white : AppColors.chatBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 10.sp,
            children: [
              for (String moduleString in activeModuleStrings)
                _buildModulePermissionRow(
                  lightMode: lightMode,
                  moduleString: moduleString,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModulePermissionRow({
    required bool lightMode,
    required String moduleString,
  }) {
    Modules? module = _getModuleEnum(moduleString);
    if (module == null) return const SizedBox.shrink();

    List<String> actions = _modulePermissions[moduleString] ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 32.sp,
            alignment: Alignment.center,
            width: 20.sp,
            child: SvgPicture.asset(
              module.iconPathRole,
              width: 20.sp,
              height: 20.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 10.sp),
          Expanded(
            child: actions.isEmpty
                ? Container(
              height: 32.sp,
              alignment: Alignment.centerLeft,
              child: Text(
                'No specific permissions'.tr,
                style: AppTextStyles.font12BlackCairoRegular.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
                : LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth;
                if (maxW <= 0 || maxW.isInfinite) {
                  return _buildPermissionChipsWrap(actions, lightMode);
                }
                return _buildPermissionChips(actions, maxW, lightMode);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionChipsWrap(List<String> permissions, bool lightMode) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: permissions.map((p) => _buildChip(p, lightMode)).toList(),
    );
  }

  Widget _buildPermissionChips(
      List<String> permissions, double maxWidth, bool lightMode) {
    if (maxWidth < 200) {
      return _buildPermissionChipsWrap(permissions, lightMode);
    }

    List<Widget> firstRowChips = [];
    List<Widget> secondRowChips = [];
    double firstRowWidth = 0;
    double secondRowWidth = 0;
    final double spacing = 8.w;
    bool firstRowFull = false;

    for (int i = 0; i < permissions.length; i++) {
      final chipWidth = _calculateChipWidth(permissions[i]);
      final spaceNeeded = firstRowChips.isEmpty ? 0 : spacing;

      if (!firstRowFull &&
          firstRowWidth + spaceNeeded + chipWidth <= maxWidth - 5) {
        if (firstRowChips.isNotEmpty) {
          firstRowChips.add(SizedBox(width: spacing));
          firstRowWidth += spacing;
        }
        firstRowChips.add(_buildChip(permissions[i], lightMode));
        firstRowWidth += chipWidth;
      } else if (!firstRowFull) {
        firstRowFull = true;
        secondRowChips.add(_buildChip(permissions[i], lightMode));
        secondRowWidth += chipWidth;
      } else {
        if (firstRowWidth <= secondRowWidth) {
          firstRowChips.add(SizedBox(width: spacing));
          firstRowChips.add(_buildChip(permissions[i], lightMode));
          firstRowWidth += spacing + chipWidth;
        } else {
          if (secondRowChips.isNotEmpty) {
            secondRowChips.add(SizedBox(width: spacing));
            secondRowWidth += spacing;
          }
          secondRowChips.add(_buildChip(permissions[i], lightMode));
          secondRowWidth += chipWidth;
        }
      }
    }

    bool needsScroll = firstRowWidth > maxWidth || secondRowWidth > maxWidth;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: firstRowChips),
        if (secondRowChips.isNotEmpty) ...[
          SizedBox(height: 8.w),
          Row(mainAxisSize: MainAxisSize.min, children: secondRowChips),
        ],
      ],
    );

    if (needsScroll) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: content,
      );
    }
    return content;
  }

  Widget _buildChip(String permissionKey, bool lightMode) {
    return Container(
      height: 32.sp,
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(4.sp),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      alignment: Alignment.center,
      child: Text(
        _formatPermissionName(permissionKey),
        style: StyleText.fontSize12Weight500.copyWith(
          color: lightMode
              ? AppColors.blackButton
              : AppColors.white,
        ),
      ),
    );
  }

  double _calculateChipWidth(String permissionKey) {
    final textPainter = TextPainter(
      text: TextSpan(
          text: _formatPermissionName(permissionKey),
          style: StyleText.fontSize12Weight500),
      textDirection: ui.TextDirection.ltr,
      maxLines: 1,
    );
    textPainter.layout();
    return textPainter.width + 20.sp + 4;
  }

  Widget itemText({
    required String label,
    required String value,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
  }) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          FormatHelper.capitalize(label),
          style: labelStyle ??
              StyleText.fontSize10Weight500.copyWith(
                color: lightMode
                    ? AppColors.secondaryText
                    : AppColors.grey,
              ),
        ),
        Text(
          FormatHelper.capitalize(value),
          style: valueStyle ??
              StyleText.fontSize10Weight500.copyWith(
                color: lightMode
                    ? AppColors.blackButton
                    : AppColors.white,
              ),
        ),
      ],
    );
  }

  Widget itemTextProduct({
    required String label,
    required String value,
    required String image,
    Color? valueColor,
  }) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomSvg(
          assetPath: image,
          width: 15.sp,
          height: 15.sp,
          fit: BoxFit.fill,
        ),
        SizedBox(width: 3.sp),
        Text(
          FormatHelper.capitalize(label),
          style: context.isPhone
              ? StyleText.fontSize12Weight500
              .copyWith(color: AppColors.secondaryText)
              : StyleText.fontSize14Weight500
              .copyWith(color: AppColors.secondaryText),
        ),
        Text(
          FormatHelper.capitalize(value),
          style: context.isPhone
              ? StyleText.fontSize12Weight500
              .copyWith(color: valueColor ?? AppColors.text)
              : StyleText.fontSize14Weight500
              .copyWith(color: valueColor ?? AppColors.text),
        ),
      ],
    );
  }

  Widget _buildEmployeeHeader(
      bool lightMode,
      bool isArabic,
      bool isMobile,
      bool isTablet,
      bool isLandscape,
      ) {
    final fullName = isArabic
        ? "${currentEmployeeEntity?.firstNameInArabic ?? ''} ${currentEmployeeEntity?.middleNameInArabic ?? ''} ${currentEmployeeEntity?.lastNameInArabic ?? ''}"
        .trim()
        : "${currentEmployeeEntity?.firstName ?? ''} ${currentEmployeeEntity?.middleName ?? ''} ${currentEmployeeEntity?.lastName ?? ''}"
        .trim();

    final title = isArabic
        ? currentEmployeeEntity?.titleInArabic ?? '-'
        : currentEmployeeEntity?.title ?? '-';

    final departmentName = currentEmployeeEntity?.departmentId != null
        ? employeeController.departmentController
        .getDepartmentName(currentEmployeeEntity!.departmentId!, !isArabic)
        : '-';

    final email = currentEmployeeEntity?.email ?? '-';

    String phoneNumber = '-';
    if (currentEmployeeEntity?.mobilePhone != null) {
      final countryCode =
          currentEmployeeEntity!.mobilePhone!.countryCode ?? '';
      final phone = currentEmployeeEntity!.mobilePhone!.phone ?? '';
      final cleanCC = countryCode
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .trim();
      final cleanPhone =
      phone.toString().replaceAll('[', '').replaceAll(']', '').trim();
      if (cleanCC.isNotEmpty && cleanPhone.isNotEmpty) {
        phoneNumber = '+$cleanCC $cleanPhone';
      } else if (cleanPhone.isNotEmpty) {
        phoneNumber = cleanPhone;
      }
    }

    final gender = currentEmployeeEntity?.gender ?? 'male';

    if (isMobile) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.sp),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22.5.sp,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(child: _buildEmployeeImage(gender)),
                  ),
                  SizedBox(width: 5.sp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName.isEmpty
                              ? 'Unknown'
                              : FormatHelper.capitalize(fullName),
                          style: StyleText.fontSize14Weight500
                              .copyWith(color: AppColors.text),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.sp),
                        Text(
                          FormatHelper.capitalize(departmentName),
                          style: StyleText.fontSize12Weight500
                              .copyWith(color: AppColors.secondaryText),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.sp),
                        Text(
                          FormatHelper.capitalize(title),
                          style: StyleText.fontSize12Weight500
                              .copyWith(color: AppColors.secondaryText),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  customButtonWithImage(
                    title: "",
                    function: () {},
                    width: 40.sp,
                    height: 40.sp,
                    color: AppColors.primary,
                    textStyle: StyleText.fontSize14Weight500
                        .copyWith(color: AppColors.textButton),
                    radius: 8.r,
                    heightImage: 16.sp,
                    widthImage: 16.sp,
                    svgColor: AppColors.textButton,
                    image: "assets/icons_drawer_news/message_new_icon.svg",
                    space: isMobile ? 0.sp : 8.sp,
                    colorBorder: Colors.transparent,
                  ),
                ],
              ),
              SizedBox(height: 10.sp),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemTextProduct(
                        value: phoneNumber,
                        label: "${S.of(context).phoneNumber}: ",
                        image: "assets/images/phone_number.svg",
                      ),
                      SizedBox(height: 10.sp),
                      itemTextProduct(
                        value: email,
                        label: "${S.of(context).email}: ",
                        image: "assets/images/email.svg",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (isTablet && !isLandscape) {
      return Container(
        decoration: BoxDecoration(
          color: lightMode
              ? AppColors.white
              : AppColors.chatBackground,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 15.sp,
            bottom: 15.sp,
            left: isArabic ? 15.sp : 0,
            right: isArabic ? 0 : 15.sp,
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.sp,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                        child: _buildEmployeeImage(gender, size: 80.sp)),
                  ),
                  SizedBox(width: 10.sp),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName.isEmpty ? 'Unknown' : fullName,
                        style: StyleText.fontSize16Weight500.copyWith(
                          color: lightMode
                              ? AppColors.blackButton
                              : AppColors.white,
                        ),
                      ),
                      SizedBox(height: 10.sp),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              itemTextProduct(
                                  value: title,
                                  label: "Title: ",
                                  image: "assets/images/page.svg"),
                              SizedBox(height: 10.sp),
                              itemTextProduct(
                                  value: email,
                                  label: "Email: ",
                                  image: "assets/images/email.svg"),
                            ],
                          ),
                          SizedBox(width: 38.sp),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              itemTextProduct(
                                  value: departmentName,
                                  label: "Department: ",
                                  image: "assets/images/department.svg"),
                              SizedBox(height: 10.sp),
                              itemTextProduct(
                                  value: phoneNumber,
                                  label: "Phone Number: ",
                                  image: "assets/images/phone_number.svg"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              customButtonWithImage(
                title: "Message",
                function: () {
                  MessageInterfaceConsumer.openSingleChat(
                      widget.userPermission.employeeEmail, context);
                },
                textStyle: StyleText.fontSize16Weight500
                    .copyWith(color: AppColors.textButton),
                width: 135.sp,
                height: 38.sp,
                space: 8.sp,
                radius: 8.r,
                color: AppColors.primary,
                image: "assets/roles_module/Messages.svg",
                widthImage: 24.sp,
                heightImage: 24.sp,
                colorBorder: Colors.transparent,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: lightMode
              ? AppColors.white
              : AppColors.chatBackground,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.sp),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40.sp,
                backgroundColor: Colors.transparent,
                child:
                ClipOval(child: _buildEmployeeImage(gender, size: 80.sp)),
              ),
              SizedBox(width: 10.sp),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FormatHelper.capitalize(
                        fullName.isEmpty ? 'Unknown' : fullName),
                    style: StyleText.fontSize16Weight500.copyWith(
                      color: lightMode
                          ? AppColors.blackButton
                          : AppColors.white,
                    ),
                  ),
                  SizedBox(height: 10.sp),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          itemTextProduct(
                              value: title,
                              label: "${S.of(context).title}: ",
                              image: "assets/images/page.svg"),
                          SizedBox(height: 10.sp),
                          itemTextProduct(
                              value: email,
                              label: "${S.of(context).email}: ",
                              image: "assets/images/email.svg"),
                        ],
                      ),
                      SizedBox(width: 38.sp),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          itemTextProduct(
                              value: departmentName,
                              label: "${S.of(context).department}: ",
                              image: "assets/images/department.svg"),
                          SizedBox(height: 10.sp),
                          itemTextProduct(
                              value: phoneNumber,
                              label: "${S.of(context).phoneNumber}: ",
                              image: "assets/images/phone_number.svg"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              customButtonWithImage(
                title: S.of(context).message,
                function: () {
                  MessageInterfaceConsumer.openSingleChat(
                      widget.userPermission.employeeEmail, context);
                },
                textStyle: StyleText.fontSize16Weight500
                    .copyWith(color: AppColors.textButton),
                width: 135.sp,
                height: 38.sp,
                space: 8.sp,
                radius: 8.r,
                color: AppColors.primary,
                image: "assets/roles_module/Messages.svg",
                widthImage: 15.sp,
                heightImage: 15.sp,
                colorBorder: Colors.transparent,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildEmployeeImage(String gender, {double? size}) {
    final imageSize = size ?? 45.sp;

    if (currentEmployeeEntity?.photo != null &&
        currentEmployeeEntity!.photo!.isNotEmpty &&
        currentEmployeeEntity!.photo != '[]') {
      if (currentEmployeeEntity!.photo!.contains('http')) {
        return Image.network(
          currentEmployeeEntity!.photo!,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildDefaultAvatar(gender, imageSize),
        );
      } else {
        return Image.asset(
          currentEmployeeEntity!.photo!,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildDefaultAvatar(gender, imageSize),
        );
      }
    }

    return _buildDefaultAvatar(gender, imageSize);
  }

  Widget _buildDefaultAvatar(String gender, double size) {
    return SvgPicture.asset(
      gender.toLowerCase() == 'female'
          ? 'assets/images/female.svg'
          : 'assets/images/male.svg',
      semanticsLabel: 'Gender Icon',
      fit: BoxFit.cover,
      width: size,
      height: size,
    );
  }
}