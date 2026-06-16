import 'package:demo_app/core/widgets/custom_button_widget.dart';
import 'package:demo_app/core/widgets/filter_bar_item.dart';
import 'package:demo_app/core/widgets/navigation.dart';
import 'package:demo_app/core/widgets/shared_action_widgets.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/custom_validate_textfield.dart';
import 'package:demo_app/core/helper/format_helper.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/form_builder_module/core/configs/extensions/extensions.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/inventory_module/core/navigate.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/inventory_module/core/svg_custom.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/knowledge_hub_module/core/custom_buttons.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/roles/domain/enums/settings/settings_permissions_sections_main_core.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/core/custom_button_with_image.dart' hide customButtonWithImage;
import 'package:demo_app/features/roles/data/repository/user_role_repository.dart';
import 'package:demo_app/features/roles/presentation/ui/pages/user_management/request_page_approval.dart';
import 'package:demo_app/features/roles/presentation/ui/widgets/user_management/warining_dialog.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/helper/cross_axis_count_helper.dart';
import '../../../../../../core/network/api_constants.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/circle_progress.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../employee/presentation/controller/main_core_employee_controller.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/Category/presentation/ui/service_department_manager/tablet/s1_create_service/upload_file/upload_file.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/Category/presentation/ui/service_department_manager/tablet/s2_details_service/details_service/widget/info_text.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/core/new_theme.dart';
import '../../../../data/models/role_model.dart';
import '../../../../domain/enums/modules_enum.dart';
import '../../../../domain/enums/roles/roles_permissions_sections.dart';
import '../../../../domain/enums/roles/user_mangment_permission.dart';
import '../../../../domain/enums/settings/settings_permissions.dart';
import '../../../../utils/user_access_status.dart';
import '../../../controller/role_cubit.dart';
import '../../../controller/user_management_cubit.dart';
import '../../widgets/role_management/grid_table_export.dart';
import '../../widgets/user_management/user_managemnt_export_dialog.dart';
import '../../widgets/user_management/user_managemnt_table_widget.dart';
import '../../widgets/user_management/user_permission_overview.dart';
import 'add_new_users_access.dart';
import 'import_page.dart';
import 'role_user_details.dart';
import '../../../../utils/role_log_service.dart';

class UserManagementHome extends StatefulWidget {
  @override
  State<UserManagementHome> createState() => _UserManagementHomeState();
}

class _UserManagementHomeState extends State<UserManagementHome> {
  late UserManagementAccessCubit controller;
  bool isGridView = true;

  /// Extra safety net: if a role IS present in RoleCubit but its current status
  /// is one of these, hide it anyway.
  static const Set<String> _hiddenRoleStatuses = {'inactive', 'deleted'};

  @override
  void initState() {
    super.initState();
    print("════════════════════════════════════════════════════════");
    print("🖥️  [UI] UserManagementHome initState - START");
    print("════════════════════════════════════════════════════════");
    RoleLogService.log(RoleLogService.pageUserManagementHome);

    try {
      print("🖥️  [UI] Getting controller from context...");
      controller = context.read<UserManagementAccessCubit>();
      print("✅ [UI] Controller obtained successfully");

      print("🖥️  [UI] Scheduling postFrameCallback...");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("┌─────────────────────────────────────────────────────┐");
        print("│ 🖥️  [UI] PostFrameCallback EXECUTING               │");
        print("└─────────────────────────────────────────────────────┘");

        print("🖥️  [UI] Calling initializeWithAllFilter...");
        controller.initializeWithAllFilter();

        print("🖥️  [UI] Calling getUserAccess...");
        controller.getUserAccess();

        print("✅ [UI] PostFrameCallback completed");
      });

      print("🖥️  [UI] initState completed successfully");
    } catch (e, stackTrace) {
      print("════════════════════════════════════════════════════════");
      print("❌❌❌ [UI] ERROR in initState ❌❌❌");
      print("Error: $e");
      print("Stack trace:\n$stackTrace");
      print("════════════════════════════════════════════════════════");
    }

    print("════════════════════════════════════════════════════════");
    print("🖥️  [UI] UserManagementHome initState - END");
    print("════════════════════════════════════════════════════════");
  }

  /// Resolve a role from RoleCubit by its stored access key (case-insensitive).
  RoleHistoryModel? _resolveRole(String roleKey) {
    final String normalizedKey = roleKey.trim().toLowerCase();
    try {
      final RoleCubit roleCubit = context.read<RoleCubit>();
      return roleCubit.roles.firstWhereOrNull(
            (r) =>
        r.currentRoleName.trim().toLowerCase() == normalizedKey ||
            r.roleId.trim().toLowerCase() == normalizedKey,
      );
    } catch (e) {
      return null;
    }
  }

  /// ✅ A role chip is visible ONLY if its key resolves to a role that still
  /// exists in RoleCubit.roles.
  ///
  /// KEY INSIGHT (confirmed via logs): RoleCubit.roles already EXCLUDES
  /// deleted/inactive roles. So a key from `roleFilteredUsersPermissions` that
  /// does NOT resolve means the role was deleted/inactive → hide it (and drop
  /// its users from the count/grid).
  bool _isRoleVisible(String roleKey) {
    try {
      final RoleCubit roleCubit = context.read<RoleCubit>();

      // Roles not loaded yet → don't hide anything (avoids an empty bar flicker
      // on first frame before RoleCubit populates).
      if (roleCubit.roles.isEmpty) return true;

      final RoleHistoryModel? role = _resolveRole(roleKey);

      // Not in the active roles list → deleted / inactive / removed → hide.
      if (role == null) return false;

      // Present, but double-check its current status as a safety net.
      final String statusName = role.currentStatus.name.trim().toLowerCase();
      return !_hiddenRoleStatuses.contains(statusName);
    } catch (e) {
      return true; // fail open on unexpected errors
    }
  }

  List<MapEntry<String, int>> _getSortedRolesWithAll() {
    // ✅ Only roles that still exist (non-deleted/non-inactive) in RoleCubit.
    final visibleEntries = controller.roleFilteredUsersPermissions.entries
        .where((e) => _isRoleVisible(e.key))
        .toList();

    // ✅ "all" count reflects ONLY the visible roles, so the badge matches the
    // grid below.
    int totalCount = 0;
    for (final entry in visibleEntries) {
      totalCount += entry.value.length;
    }

    List<MapEntry<String, int>> sortedRoles = [
      MapEntry('all', totalCount),
    ];

    var otherRoles = visibleEntries
        .map((e) => MapEntry(e.key, e.value.length))
        .toList();

    otherRoles.sort((a, b) => b.value.compareTo(a.value));
    sortedRoles.addAll(otherRoles);

    return sortedRoles;
  }

  /// ✅ Get localized role name from role ID (case-insensitive resolve).
  String _getLocalizedRoleName(String roleId) {
    final role = _resolveRole(roleId);

    if (role != null) {
      return Get.locale.toString().contains('en')
          ? role.currentRoleName
          : role.currentRoleNameAr;
    }

    return FormatHelper.capitalize(roleId);
  }

  bool isTabletLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return size.width >= 600 && isLandscape;
  }

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    var isMobile = context.isPhone;

    return BlocListener<UserManagementAccessCubit, UserManagementAccessState>(
      listenWhen: (_, state) => state is UserManagementAccessError,
      listener: (context, state) {
        if (state is UserManagementAccessError) {
          showWarningDialog(
            context,
            message: state.message,
            lottieAsset: 'assets/lottie/warning.json',
          );
        }
      },
      child: BlocBuilder<UserManagementAccessCubit, UserManagementAccessState>(
        buildWhen: (_, currentState) {
          return currentState is UserPermissionsDataLoaded ||
              currentState is UserPermissionsDataLoading ||
              currentState is UserPermissionsDataError;
        },
        builder: (context, state) {
          if (state is UserPermissionsDataLoading) {
            return Center(child: CircleProgressMaster());
          }

          if (state is UserPermissionsDataError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                  SizedBox(height: 16.sp),
                  Text('Error: ${state.message}'),
                  SizedBox(height: 16.sp),
                  ElevatedButton(
                    onPressed: () => controller.getUserAccess(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final sortedRoles = _getSortedRolesWithAll();

          // ✅ Hide users whose assigned role no longer exists (deleted/inactive),
          // so the grid/table stays consistent with the filter-bar counts.
          final visiblePermissions = controller.filteredUsersPermissions
              .where((p) => _isRoleVisible(p.accessName ?? 'unknown'))
              .toList();

          return Column(
            spacing: 10.sp,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Role filter bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 30.sp,
                  children: [
                    for (var roleEntry in sortedRoles)
                      FilterBarItem(
                        title: FormatHelper.capitalize(
                            roleEntry.key == 'all'
                                ? S.of(context).all
                                : _getLocalizedRoleName(roleEntry.key)
                        ),
                        numberOfItems: roleEntry.value,
                        onTap: () => controller.selectNewRole(roleEntry.key),
                        isSelected: controller.selectedRole == roleEntry.key,
                      ),
                  ],
                ),
              ),

              SizedBox(height: 5.sp),

              // Requests button
              Get.find<MainCoreEmployeeController>().isHasPermission(
                module: Modules.roles,
                section: RolePermissionsSections.userManagement,
                permission: UserManagement.usersRequests,
              )
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  customButton(
                      title: FormatHelper.capitalize(S.of(context).requests),
                      function: () => navigateTo(context, RequestPageApproval()),
                      width: 135.w,
                      height: 38.h,
                      color: AppColors.primary,
                      textStyle: StyleText.fontSize16Weight500.copyWith(
                          color: AppColors.textButton
                      )
                  ),
                ],
              )
                  : SizedBox(),

              // Search and action buttons row
              Row(
                spacing: 10.sp,
                children: [
                  Expanded(
                    child: Customdemo_appTextField(
                      labelEn: '',
                      labelAr: '',
                      hintEn: 'Search',
                      hintAr: 'بحث',

                      controller: controller.homePageSearchController,
                      language: Get.locale?.languageCode == 'ar'
                          ? AppLanguage.arabic
                          : AppLanguage.english,
                      validationType: ValidationType.none,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onChanged: (value) => controller.filterHomePageUser(value),
                      prefixIcon: Icons.search,
                      fillColor: AppColors.card,
                      borderColor: Colors.transparent,
                      focusedBorderColor: AppColors.primary,
                      borderRadius: 8.r,
                      height: 36.h,
                    ),
                  ),

                  Get.find<MainCoreEmployeeController>().isHasPermission(
                    module: Modules.roles,
                    section: RolePermissionsSections.userManagement,
                    permission: UserManagement.giveAccess,
                  )
                      ? customButtonWithImage(
                    title: isMobile ? "" : 'Access'.tr,
                    function: () {
                      RoleCubit roleCubit = context.read<RoleCubit>();
                      final validRoles = roleCubit.roles
                          .where((e) => e.currentRoleName.isNotEmpty)
                          .toList();
                      List<String> roleNames = validRoles
                          .map((e) => e.currentRoleName)
                          .toList();
                      List<String> roleNamesAr = validRoles
                          .map((e) => e.currentRoleNameAr.trim().isNotEmpty
                          ? e.currentRoleNameAr.trim()
                          : e.currentRoleName)
                          .toList();

                      controller.initNewAccessController(roleNames, roleNamesAr);
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                        return BlocProvider<UserManagementAccessCubit>.value(
                          value: controller,
                          child: AddNewUsersAccess(),
                        );
                      }));
                    },
                    width: isMobile ? 38.sp : 100.sp,
                    height: 38.sp,
                    color: AppColors.primary,
                    textStyle: StyleText.fontSize16Weight500.copyWith(
                      color: AppColors.textButton,
                    ),
                    radius: 8.r,
                    heightImage: 16.h,
                    widthImage: 16.w,
                    svgColor: AppColors.textButton,
                    image: "assets/Access_icons.svg",
                    space: 8.sp,
                    colorBorder: Colors.transparent,
                  )
                      : SizedBox(),
                ],
              ),

              // Status filter and export row
              Row(
                spacing: 8.sp,
                children: [
                  for (UserAccessStatus status in UserAccessStatus.values)
                    CustomButton(
                      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
                      buttonColor: controller.selectedUserAccessStatus == status
                          ? AppColors.primary
                          : AppColors.card,
                      textStyle: controller.selectedUserAccessStatus == status
                          ? null
                          : AppTextStyles.font14BlackRegularCairo.copyWith(
                        color: status.getColor(context),
                      ),
                      buttonText: FormatHelper.capitalize(status.name.tr),
                      onTap: () => controller.selectNewAccessStatus(status),
                    ),
                  Spacer(),
                  ViewToggleButtons(
                    isGridView: isGridView,
                    onTableViewTap: () => setState(() => isGridView = false),
                    onGridViewTap: () => setState(() => isGridView = true),
                    showExport: true,
                    onExportTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => UserManagementExportDialog(
                          userPermissions: visiblePermissions,
                        ),
                      );
                    },
                  )
                ],
              ),

              // Grid or Table view
              Expanded(
                child: visiblePermissions.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                          width: 200.w,
                          height: 200.h,
                          "assets/lottie/empty.json",
                          fit: BoxFit.fill,
                          repeat: true
                      ),
                    ],
                  ),
                )
                    : isGridView
                    ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: CrossAxisCountHelper
                          .getCrossAxisCountForDefaultTablet2(context),
                      mainAxisExtent: isMobile ? 96.sp : 96.sp,
                      mainAxisSpacing: 10.sp,
                      crossAxisSpacing: 10.sp,
                    ),
                    itemCount: visiblePermissions.length,
                    itemBuilder: (context, index) {
                      return UserPermissionOverview(
                          userPermissionEntity: visiblePermissions[index]
                      );
                    })
                    : SingleChildScrollView(
                  child: UserManagementTableWidget(
                    userPermissions: visiblePermissions,
                    locale: Get.locale?.languageCode ?? 'en',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


// ✅ DEBUG PANEL - Shows live limit status
  // ✅ SIMPLE DEBUG PANEL - No Either, no Failure
  Widget _buildDebugPanel() {
    return Container(
      margin: EdgeInsets.all(10.sp),
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bug_report, color: Colors.red),
              SizedBox(width: 10.w),
              Text(
                '🐛 DEBUG PANEL - Module Limits',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.red.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Live data display
          FutureBuilder<Map<String, dynamic>>(
            future: _getDebugData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...', style: TextStyle(color: Colors.orange));
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red));
              }

              final data = snapshot.data ?? {};
              final limits = data['limits'] as Map<String, int>? ?? {};
              final counts = data['counts'] as Map<String, int>? ?? {};
              final companyId = data['companyId'] as String? ?? 'unknown';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Company ID: $companyId',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),

                  // Limits table
                  Container(
                    padding: EdgeInsets.all(8.sp),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('Module', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Limit', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Current', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                        Divider(),
                        ...limits.entries.map((entry) {
                          final module = entry.key;
                          final limit = entry.value;
                          final count = counts[module] ?? 0;
                          final remaining = limit - count;
                          final isFull = count >= limit;

                          return Row(
                            children: [
                              Expanded(child: Text(module)),
                              Expanded(child: Text('$limit')),
                              Expanded(child: Text('$count')),
                              Expanded(
                                child: Text(
                                  isFull ? '🔴 FULL' : '🟢 $remaining left',
                                  style: TextStyle(
                                    color: isFull ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),

                        if (limits.isEmpty)
                          Text('⚠️ NO LIMITS SET', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Test buttons
                  Wrap(
                    spacing: 10.w,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _testLimitCheck(context),
                        icon: Icon(Icons.play_arrow),
                        label: Text('TEST LIMIT CHECK'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => setState(() {}),
                        icon: Icon(Icons.refresh),
                        label: Text('REFRESH'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

// ✅ SIMPLE: Get debug data
  Future<Map<String, dynamic>> _getDebugData() async {
    final repo = UserManagementAccessRepository();
    final companyId = _getCompanyId();

    print('🔍 DEBUG: Getting data for company: $companyId');

    final limits = await repo.getModuleUserLimits(companyId);

    // Get counts for all modules
    final counts = <String, int>{};
    for (final module in limits.keys) {
      counts[module] = await repo.getModuleUserCount(companyId, module);
    }

    return {
      'companyId': companyId,
      'limits': limits,
      'counts': counts,
    };
  }

// ✅ SIMPLE: Test limit check with normal strings
  Future<void> _testLimitCheck(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Testing Limit Check'),
        content: FutureBuilder<String>(
          future: _runLimitTest(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Testing limit check for "super admin" role...'),
                ],
              );
            }

            if (snapshot.hasError) {
              return Text('❌ ERROR: ${snapshot.error}');
            }

            final result = snapshot.data ?? 'Unknown result';

            // Check if result contains "limit reached" or similar
            final isBlocked = result.toLowerCase().contains('limit') &&
                result.toLowerCase().contains('reached');

            if (isBlocked) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.block, color: Colors.red, size: 50),
                  SizedBox(height: 10),
                  Text(
                    '✅ LIMIT WORKING!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Blocked with message:'),
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.red.shade100,
                    child: Text(result),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.orange, size: 50),
                  SizedBox(height: 10),
                  Text(
                    '⚠️ LIMIT NOT BLOCKING',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Result: $result'),
                  SizedBox(height: 10),
                  Text('Either:'),
                  Text('• No limits set'),
                  Text('• Limit not reached yet'),
                  Text('• Role has no modules'),
                ],
              );
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

// ✅ SIMPLE: Run limit test, return string result
  Future<String> _runLimitTest() async {
    final repo = UserManagementAccessRepository();
    final companyId = _getCompanyId();

    // Call the check function and get string result
    final result = await repo.checkModuleUserLimitsSimple(
      companyId: companyId,
      roleName: 'Master Admin',  // <-- Change from 'super admin' to 'Master Admin'
    );

    return result;
  }




  String _getCompanyId() {
    String baseUri = ApiConstants.baseUri;
    if (baseUri.contains('/')) {
      return baseUri.split('/').last;
    }
    return baseUri;
  }


  @override
  void dispose() {
    print("🖥️  [UI] UserManagementHome dispose()");
    super.dispose();
  }
}