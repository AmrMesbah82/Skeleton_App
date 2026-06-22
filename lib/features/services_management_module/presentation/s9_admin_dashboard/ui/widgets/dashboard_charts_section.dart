/// ******************* FILE INFO *******************
/// File Name: dashboard_charts_section.dart
/// Description: Charts section for Admin Dashboard (services offered, monthly counts, comparison)
/// Created by: Amr Mesbah

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/compartion_chart.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/controller/admin_state.dart';
import 'package:demo_app/features/home/presentation/ui/pages/dashboard_view_data/chart_orientation_enum.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/DashBoard_widget.dart';

import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/build_number_services.dart';


class DashboardChartsSection extends StatelessWidget {
  final DashboardAdminState state;

  const DashboardChartsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      children: [
        // ── Services Offered Bar Chart ─────────────────────────────────────
        _buildServicesOfferedWidget(context, lightMode, isArabic),

        SizedBox(height: 15.sp),

        // ── Monthly Comparison Chart ───────────────────────────────────────
        MonthlyComparisonChart(
          orientation: ChartOrientation.vertical,
          lightMode: lightMode,
        ),

        SizedBox(height: 15.sp),

        // ── Number of Services / Hours Card ───────────────────────────────
        NumberOfServicesCardDashBoard(
          monthCounts: state.monthCounts,
          monthHours: state.monthHours,
          isLoading: state.isLoading,
          showServiceCount: state.showServiceCount,
          onToggleServiceCount: () {},
          onToggleToHours: () {},
        ),
      ],
    );
  }

  Widget _buildServicesOfferedWidget(
      BuildContext context,
      bool lightMode,
      bool isArabic,
      ) {
    final labels = <String>[];
    final values = <double>[];

    for (int i = 0; i < state.serviceNames.length; i++) {
      final label = isArabic &&
          i < state.serviceNamesArabic.length &&
          state.serviceNamesArabic[i].isNotEmpty
          ? state.serviceNamesArabic[i]
          : state.serviceNames[i];
      labels.add(label);
      values.add(state.monthCountss[i] ?? 0.0);
    }

    return CustomHorizontalBarChartWidget(
      title: S.of(context).servicesOffered,
      iconAsset: "assets/headphoneDashboard.svg",
      labels: labels,
      values: values,
      lightMode: lightMode,
      height: 310,
      backgroundColor: AppColors.card,
      barColor: AppColors.primary,
    );
  }
}
