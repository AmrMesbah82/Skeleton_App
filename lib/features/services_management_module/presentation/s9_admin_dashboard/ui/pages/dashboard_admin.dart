/// ******************* FILE INFO *******************
/// File Name: dashboard_admin_page.dart
/// Description: Main UI page for Admin Dashboard — thin view, delegates all logic to cubit
/// Created by: Amr Mesbah

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/controller/admin_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/controller/admin_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/dashboard_service_grid.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/dashboard_charts_section.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/dashboard_department_filter.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/dashboard_status_cards.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/dashboard_table_action_bar.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/dashboard_table_section.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';

import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/dashboard_permissions.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/services_permissions_sections.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/helper/services_management/circle_progress.dart';
import 'package:demo_app/core/widgets/services_management/search_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/pages/dashBord_mobile.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/pages/dashboard_details_admin_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/dashboard_tab_bar.dart';



class AdminDashBoardMasterTablet extends StatelessWidget {
  const AdminDashBoardMasterTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardAdminCubit()..bootstrap(),
      child: const _AdminDashBoardView(),
    );
  }
}

class _AdminDashBoardView extends StatelessWidget {
  const _AdminDashBoardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardAdminCubit, DashboardAdminState>(
      builder: (context, state) {
        if (!state.bootstrapped) {
          return Scaffold(
            body: SideFrameMasterServices(
              titleText: S.of(context).services,
              onFirstTap: () => Navigator.pop(context),
              secondTitle: S.of(context).dashboard,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: CircleProgressMaster()),
              ),
            ),
          );
        }

        final isMobile = context.isPhone;
        final lightMode = Theme.of(context).brightness == Brightness.light;

        return Scaffold(
          body: SafeArea(
            child: SideFrameMasterServices(
              titleText: S.of(context).services,
              onFirstTap: () => navigateTo(context, LayoutScreenServices()),
              secondTitle: S.of(context).dashboard,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Department Filter ──────────────────────────────────────
                    if (Get.find<MainCoreEmployeeController>().isHasPermission(
                      module: Modules.services,
                      permission: DashboardPermissions.departmentDashboard,
                      section: ServicePermissionsSections.dashboardPermissions,
                    )) ...[
                      DashboardDepartmentFilter(state: state),
                      SizedBox(height: 20.sp),
                    ],
            
                    // ── Service Grid (filtered dept only) ──────────────────────
                    if (!state.isServiceListLoading &&
                        state.selectStatus != "All" &&
                        state.allServices.isNotEmpty)
                      DashboardServiceGrid(state: state),
            
                    if (state.selectStatus != "All") SizedBox(height: 32.sp),
            
                    // ── Status Cards ───────────────────────────────────────────
                    DashboardStatusCards(
                      statusCounts: state.statusCounts,
                      isMobile: isMobile,
                      lightMode: lightMode,
                    ),
            
                    SizedBox(height: 20.sp),
            
                    // ── Charts (All only) ──────────────────────────────────────
                    if (state.selectStatus == "All") ...[
                      DashboardChartsSection(state: state),
                      SizedBox(height: 20.sp),
                    ],
            
                    // ── Table / Stats (All) ────────────────────────────────────
                    if (state.selectStatus == "All") ...[
                      DashboardTableActionBar(state: state),
                      DashboardTableSection(
                        selectStatus: state.selectStatus,
                        searchQuery: '',
                        activeDepartments: const [],
                        activeStatuses: const [],
                        activeDate: null,
                        isMobile: isMobile,
                        displayedItems: state.displayedItems,
                        isLoadingRequests: state.isLoadingRequests,
                      ),
                    ],
            
                    if (state.selectStatus != "All") SizedBox(height: 20.sp),
            
                    // ── Table / Stats (Filtered dept) ──────────────────────────
                    if (state.selectStatus != "All")
                      _buildFilteredDeptSection(context, state, isMobile, lightMode),
            
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilteredDeptSection(
      BuildContext context,
      DashboardAdminState state,
      bool isMobile,
      bool lightMode,
      ) {
    final cubit = context.read<DashboardAdminCubit>();

    return Column(
      children: [
        DashboardTabBar(
          showRequests: state.showRequests,
          onRequestsTap: () => cubit.toggleShowRequests(true),
          onStatisticsTap: () => cubit.toggleShowRequests(false),
        ),
        SizedBox(height: 20.sp),
        DashboardTableActionBar(state: state),
        if (state.showRequests)
          DashboardTableSection(
            selectStatus: state.selectStatus,
            searchQuery: '',
            activeDepartments: const [],
            activeStatuses: const [],
            activeDate: null,
            isMobile: isMobile,
            displayedItems: state.displayedItems,
            isLoadingRequests: state.isLoadingRequests,
          )
        else
          DashBoardMasterMobile(
            isAdmin: true,
            adminSelectedDepartment: state.selectStatus,
          ),
      ],
    );
  }
}
