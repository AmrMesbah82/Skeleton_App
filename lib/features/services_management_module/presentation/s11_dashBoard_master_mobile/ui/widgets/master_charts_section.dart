/// ******************* FILE INFO *******************
/// File Name: master_charts_section.dart
/// Description: All chart widgets for DashBoard Master (admin + employee modes)
/// Created by: Amr Mesbah
/// *************************************************

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/controller/dashboard_master_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/controller/dashboard_master_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/bar_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/canceld_and_rejected_chart.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/dynamic_number_of_services.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/first_section_PieChartWithLabels.dart';
import 'package:demo_app/features/services_management_module/presentation/s8_dashboard/ui/widgets/services_dashboard.dart';
import 'package:demo_app/features/home/presentation/ui/pages/dashboard_view_data/chart_orientation_enum.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/DashBoard_widget.dart';

import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/pie_chart_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/DepartmentVerticalBarChart.dart';


class MasterChartsSection extends StatelessWidget {
  final DashboardMasterState state;
  final DashboardMasterCubit cubit;
  final bool isAdmin;
  final String? adminSelectedDepartment;
  final bool isArabic;

  const MasterChartsSection({
    super.key,
    required this.state,
    required this.cubit,
    required this.isAdmin,
    required this.adminSelectedDepartment,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return Column(
      children: [
        // ── Pie charts (Dept + Status) ────────────────────────────────────
        DashboardChartsSection(
          departmentCounts: state.departmentCounts,
          statusCounts: state.statusCounts,
          enToArDepartments: state.enToArDepartments,
          isLoadingDepartments: state.isLoadingDepartments,
          isLoadingStatus: state.isLoadingFirst,
          departmentText: S.of(context).department,
          statusOfServicesText: S.of(context).StatusOfServices,
          doneText: S.of(context).Done,
          approvedText: S.of(context).Approved,
          pendingText: S.of(context).Pending,
          inprogressText: S.of(context).Inprogress,
          breachedSLAText: S.of(context).BreachedSLA,
          rejectedText: S.of(context).Rejected,
          canceledText: S.of(context).Canceled,
          loadingWidget: const CircleProgressMaster(),
          pieChartBuilder: (headerImage, title, total, numberList, data) =>
              PieChartWithLabels(
                headerImage: headerImage,
                title: title,
                total: total,
                numberList: numberList,
                data: data,
              ),
          loadingBackgroundColor:AppColors.card,
          departmentColors: state.departmentColors,
          statusColors:  {
            'done': Color(0xff378309),
            'approved': AppColors.green,
            'pending': Color(0xffFF814A),
            'inprogress': Color(0xffFFCC00),
            'branchsla': Color(0xffDF1C1C),
            'rejected': Color(0xff950E0E),
            'cancel': Color(0xff730606),
          },
        ),

        SizedBox(height: 15.sp),

        // ── Department bar chart ──────────────────────────────────────────
        DepartmentVerticalBarChart(
          title: S.of(context).department,
          iconAsset: isAdmin
              ? 'assets/svg/Case.svg'
              : 'assets/svg/Case.svg',
          departmentCounts: state.departmentCounts,
          departmentColors: state.departmentColors,
          enToArDepartments: state.enToArDepartments,
          lightMode: lightMode,
          showGrid: true,
          height: isAdmin ? 320 : 300,
        ),

        SizedBox(height: 15.sp),

        // ── Services offered ──────────────────────────────────────────────
        _buildServicesOfferedChart(context, lightMode),

        SizedBox(height: 15.sp),

        // ── Number of services / total hours ──────────────────────────────
        _buildNumberOfServicesChart(context, lightMode),

        SizedBox(height: 15.sp),

        // ── Rejected / Canceled ───────────────────────────────────────────
        _buildRejectedCanceledChart(context, lightMode),

        if (!isAdmin) ...[
          SizedBox(height: 20.sp),
          // ── Monthly comparison (employee mode only) ────────────────────
          MonthlyComparisonServicesChart(
            lightMode: lightMode,
            orientation: cubit.getChartOrientation('monthly_comparison'),
          ),
        ],
      ],
    );
  }

  Widget _buildServicesOfferedChart(BuildContext context, bool lightMode) {
    if (state.isLoadingChartSettings || state.isLoadingServicesName) {
      return _loadingContainer(lightMode);
    }

    final orientation = cubit.getChartOrientation('services_offered');
    final labels = isArabic ? state.serviceNamesArabic : state.serviceNames;
    final values = state.monthCountss.values.toList();

    if (orientation == ChartOrientation.horizontal) {
      return CustomHorizontalBarChartWidget(
        height: 300,
        title: S.of(context).servicesOffered,
        iconAsset: 'assets/headphoneDashboard.svg',
        labels: labels,
        values: values,
        barHeight: 15,
        lightMode: lightMode,
        backgroundColor: AppColors.card,
      );
    }

    return CustomVerticalBarChartWidget(
      title: S.of(context).servicesOffered,
      iconAsset: 'assets/headphoneDashboard.svg',
      labels: labels,
      values: values,
      barWidth: 20,
      lightMode: lightMode,
      height: 300,
      backgroundColor: AppColors.card,
      barColor: AppColors.primary,
      showGrid: true,
      groupsSpace: 30,
    );
  }

  Widget _buildNumberOfServicesChart(BuildContext context, bool lightMode) {
    if (state.isLoadingChartSettings || state.isLoading) {
      return _loadingContainer(lightMode);
    }

    return DynamicNumberOfServicesChart(
      monthCounts: state.monthCounts,
      monthHours: state.monthHours,
      isLoading: state.isLoading,
      buildBarGroups: buildBarGroups,
      onFetchServiceCounts: () => cubit.toggleChartMode(
        showCount: true,
        isAdmin: isAdmin,
        adminSelectedDepartment: adminSelectedDepartment,
      ),
      onFetchDurationHours: () => cubit.toggleChartMode(
        showCount: false,
        isAdmin: isAdmin,
        adminSelectedDepartment: adminSelectedDepartment,
      ),
      numberOfServicesText: S.of(context).numberOfServices,
      noOfServiceText: S.of(context).NoOfService,
      totalHoursText: S.of(context).TotalHours,
      loadingWidget: const CircleProgressMaster(),
      primaryColor: AppColors.primary,
      buttonTextColor: AppColors.textButton,
      lightMode: lightMode,
      orientation: cubit.getChartOrientation('number_of_services'),
      isHours: state.isHoursMode, // ✅ NEW: Pass toggle state from cubit
    );
  }

  Widget _buildRejectedCanceledChart(BuildContext context, bool lightMode) {
    if (state.isLoadingChartSettings || state.isLoadingRejectedCanceled) {
      return _loadingContainer(lightMode);
    }

    return DynamicRejectedCanceledChart(
      monthRejected: state.monthRejected,
      monthCanceled: state.monthCanceled,
      isLoading: state.isLoadingRejectedCanceled,
      buildBarGroups: buildBarGroups,
      onFetchRejectedCounts: () => cubit.fetchMonthlyRejectedCounts(
        isAdmin: isAdmin,
        adminSelectedDepartment: adminSelectedDepartment,
      ),
      onFetchCanceledCounts: () => cubit.fetchMonthlyCanceledCounts(
        isAdmin: isAdmin,
        adminSelectedDepartment: adminSelectedDepartment,
      ),
      titleText: S.of(context).serviceStatus,
      rejectedText: S.of(context).Rejected,
      canceledText: S.of(context).Canceled,
      loadingWidget: const CircleProgressMaster(),
      primaryColor: AppColors.primary,
      buttonTextColor: AppColors.textButton,
      lightMode: lightMode,
      orientation: cubit.getChartOrientation('rejected_canceled'),
    );
  }

  Widget _loadingContainer(bool lightMode) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(6),
    ),
    child: const Center(child: CircleProgressMaster()),
  );
}
