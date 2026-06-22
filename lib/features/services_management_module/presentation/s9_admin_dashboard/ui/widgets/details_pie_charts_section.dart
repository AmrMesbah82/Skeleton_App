
/// ******************* FILE INFO *******************
/// File Name: details_pie_charts_section.dart
/// Description: Department + Status pie charts for Dashboard Details
/// Created by: Amr Mesbah
/// *************************************************

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/controller/request_statistics_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/controller/request_statistics_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/pie_chart_widget.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/helper/services_management/circle_progress.dart';


class DetailsPieChartsSection extends StatelessWidget {
  final DashboardDetailsState state;
  final DashboardDetailsCubit cubit;
  final String locale;

  const DetailsPieChartsSection({
    super.key,
    required this.state,
    required this.cubit,
    required this.locale,
  });

  Color _yellowGradient(int index) {
    const colors = [
      Color(0xFFFFD700),
      Color(0xFFFFB800),
      Color(0xFFFF9500),
      Color(0xFFD4780A),
      Color(0xFF8B5200),
    ];
    return colors[index.clamp(0, colors.length - 1)];
  }

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isMobile = context.isPhone;

    final pieCharts = [
      _buildDepartmentChart(context, lightMode),
      SizedBox(height: isMobile ? 15.sp : 0, width: isMobile ? 0 : 15.sp),
      _buildStatusChart(context, lightMode),
    ];

    return isMobile
        ? Column(children: pieCharts)
        : Row(children: pieCharts.map((w) => w is SizedBox ? w : Expanded(child: w)).toList());
  }

  Widget _buildDepartmentChart(BuildContext context, bool lightMode) {
    if (state.isLoadingDepartments) {
      return Container(
        width: context.isPhone ? 304.sp : null,
        height: 283.sp,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: const Center(child: CircleProgress()),
      );
    }

    final top5 = cubit.getTop5Departments();
    final top5Entries = top5.entries.toList();
    final totalAll = state.departmentCounts.values.fold(0, (a, b) => a + b);

    return PieChartWithLabels(
      headerImage: 'assets/images/Case.svg',
      title: S.of(context).department,
      total: totalAll.toString(),
      numberList: top5Entries.map((e) => e.value.toString()).toList(),
      data: top5Entries.asMap().entries.map((entry) {
        final color = _yellowGradient(entry.key);
        final percent = totalAll == 0 ? 0.0 : (entry.value.value / totalAll) * 100.0;
        final label = locale == 'ar'
            ? (state.enToArDepartments[entry.value.key] ?? entry.value.key)
            : entry.value.key;
        return (label, color, percent);
      }).toList(),
    );
  }

  Widget _buildStatusChart(BuildContext context, bool lightMode) {
    if (state.isLoadingFirst) {
      return Container(
        width: context.isPhone ? 304.sp : null,
        height: 283.sp,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: const Center(child: CircleProgress()),
      );
    }

    return PieChartWithLabels(
      headerImage: 'assets/lottie/status.svg',
      title: S.of(context).StatusOfServices,
      total: state.statusCounts.values.fold(0, (a, b) => a + b).toString(),
      numberList: [
        state.statusCounts['done']?.toString() ?? '0',
        state.statusCounts['approved']?.toString() ?? '0',
        state.statusCounts['pending']?.toString() ?? '0',
        state.statusCounts['inprogress']?.toString() ?? '0',
        state.statusCounts['branchsla']?.toString() ?? '0',
        state.statusCounts['rejected']?.toString() ?? '0',
        state.statusCounts['canceled']?.toString() ?? '0',
      ],
      data: [
        (S.of(context).Done, const Color(0xff378309), cubit.getPercentage('done')),
        (S.of(context).Approved, AppColors.green, cubit.getPercentage('approved')),
        (S.of(context).Pending, const Color(0xffFF814A), cubit.getPercentage('pending')),
        (S.of(context).Inprogress, const Color(0xffFFCC00), cubit.getPercentage('inprogress')),
        (S.of(context).BreachedSLA, const Color(0xffDF1C1C), cubit.getPercentage('branchsla')),
        (S.of(context).Rejected, const Color(0xff950E0E), cubit.getPercentage('rejected')),
        (S.of(context).Canceled, const Color(0xff730606), cubit.getPercentage('canceled')),
      ],
    );
  }
}
