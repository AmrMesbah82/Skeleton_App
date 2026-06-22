import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';

class DashboardChartsSection extends StatelessWidget {
  final Map<String, int> departmentCounts;
  final Map<String, int> statusCounts;
  final Map<String, String> enToArDepartments;

  final bool isLoadingDepartments;
  final bool isLoadingStatus;

  final String departmentText;
  final String statusOfServicesText;
  final String doneText;
  final String approvedText;
  final String pendingText;
  final String inprogressText;
  final String breachedSLAText;
  final String rejectedText;
  final String canceledText;

  final Widget loadingWidget;
  final Widget Function(
      String headerImage,
      String title,
      String total,
      List<String> numberList,
      List<(String, Color, double)> data,
      ) pieChartBuilder;

  final Color? loadingBackgroundColor;
  final Map<String, Color>? departmentColors;
  final Map<String, Color>? statusColors;

  const DashboardChartsSection({
    Key? key,
    required this.departmentCounts,
    required this.statusCounts,
    required this.enToArDepartments,
    required this.isLoadingDepartments,
    required this.isLoadingStatus,
    required this.departmentText,
    required this.statusOfServicesText,
    required this.doneText,
    required this.approvedText,
    required this.pendingText,
    required this.inprogressText,
    required this.breachedSLAText,
    required this.rejectedText,
    required this.canceledText,
    required this.loadingWidget,
    required this.pieChartBuilder,
    this.loadingBackgroundColor,
    this.departmentColors,
    this.statusColors,
  }) : super(key: key);

  /// Normalize department counts (convert IDs to names)
  Map<String, int> _normalizeDepartmentCounts(Map<String, int> rawCounts) {

    try {
      final departmentController = Get.find<MainCoreDepartmentController>();
      final Map<String, int> normalizedCounts = {};

      rawCounts.forEach((key, value) {
        String normalizedKey = key;

        if (int.tryParse(key) != null) {
          final departmentName =
          departmentController.getEnglishDepartmentNameFromDepartmentId(
            departmentId: key,
          );
          if (departmentName != null && departmentName.isNotEmpty) {
            normalizedKey = departmentName;
          }
        }

        normalizedCounts[normalizedKey] =
            (normalizedCounts[normalizedKey] ?? 0) + value;
      });

      return normalizedCounts;
    } catch (e) {
      return rawCounts;
    }
  }

  /// ✅ NEW: Sort by count descending and take top 5
  Map<String, int> _getTop5Departments(Map<String, int> normalizedCounts) {
    final sorted = normalizedCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top5 = sorted.take(5).toList();

    return Map.fromEntries(top5);
  }

  double _getPercentage(Map<String, int> counts, String key) {
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    final value = counts[key] ?? 0;
    return total == 0 ? 0.0 : (value / total) * 100.0;
  }

  Color _getDepartmentColor(String key) {
    if (departmentColors != null && departmentColors!.containsKey(key)) {
      return departmentColors![key]!;
    }
    return AppColors.grey!;
  }

  Map<String, Color> _getStatusColors() {
    return statusColors ??
        {
          'done': const Color(0xff378309),
          'approved': AppColors.green,
          'pending': const Color(0xffFF814A),
          'inprogress': const Color(0xffFFCC00),
          'branchsla': const Color(0xffDF1C1C),
          'rejected': const Color(0xff950E0E),
          'cancel': const Color(0xff730606),
        };
  }

  Widget _buildDepartmentChart(BuildContext context) {
    if (isLoadingDepartments) {
      return _buildLoadingContainer(context, isMobile: _isMobile(context));
    }

    final locale = Localizations.localeOf(context).languageCode;

    // Step 1: Normalize (IDs → names)
    final normalizedCounts = _normalizeDepartmentCounts(departmentCounts);

    // Step 2: ✅ Get top 5 sorted by count descending
    final top5Counts = _getTop5Departments(normalizedCounts);

    // Step 3: Total is from ALL departments (not just top 5)
    final totalAll =
    normalizedCounts.values.fold(0, (a, b) => a + b).toString();

    return pieChartBuilder(
      "assets/svg/Case.svg",
      departmentText,
      totalAll,
      top5Counts.entries.map((e) => e.value.toString()).toList(),
      top5Counts.entries.map((e) {
        final color = _getDepartmentColor(e.key);
        // ✅ Percentage calculated relative to ALL departments total
        final total = normalizedCounts.values.fold<int>(0, (a, b) => a + b);
        final percent = total == 0 ? 0.0 : (e.value / total) * 100.0;
        final displayLabel =
        locale == 'ar' ? (enToArDepartments[e.key] ?? e.key) : e.key;

        return (displayLabel, color, percent);
      }).toList(),
    );
  }

  Widget _buildStatusChart(BuildContext context) {
    if (isLoadingStatus) {
      return _buildLoadingContainer(context, isMobile: _isMobile(context));
    }

    final colors = _getStatusColors();

    return pieChartBuilder(
      "assets/lottie/status.svg",
      statusOfServicesText,
      statusCounts.values.fold(0, (a, b) => a + b).toString(),
      [
        statusCounts['done']?.toString() ?? '0',
        statusCounts['approved']?.toString() ?? '0',
        statusCounts['pending']?.toString() ?? '0',
        statusCounts['inprogress']?.toString() ?? '0',
        statusCounts['branchsla']?.toString() ?? '0',
        statusCounts['rejected']?.toString() ?? '0',
        statusCounts['cancel']?.toString() ?? '0',
      ],
      [
        (doneText, colors['done']!, _getPercentage(statusCounts, 'done')),
        (approvedText, colors['approved']!,
        _getPercentage(statusCounts, 'approved')),
        (pendingText, colors['pending']!,
        _getPercentage(statusCounts, 'pending')),
        (inprogressText, colors['inprogress']!,
        _getPercentage(statusCounts, 'inprogress')),
        (breachedSLAText, colors['branchsla']!,
        _getPercentage(statusCounts, 'branchsla')),
        (rejectedText, colors['rejected']!,
        _getPercentage(statusCounts, 'rejected')),
        (canceledText, colors['cancel']!,
        _getPercentage(statusCounts, 'cancel')),
      ],
    );
  }

  Widget _buildLoadingContainer(BuildContext context,
      {required bool isMobile}) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final bgColor = loadingBackgroundColor ??
        (lightMode
            ? AppColors.white
            : AppColors.chatBackground);

    return Container(
      width: isMobile ? 304.sp : MediaQuery.of(context).size.width * .4,
      height: isMobile ? 283.sp : 235.sp,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(child: loadingWidget),
    );
  }

  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    if (isMobile) {
      return Column(
        children: [
          _buildDepartmentChart(context),
          SizedBox(height: 15.sp),
          _buildStatusChart(context),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(child: _buildDepartmentChart(context)),
          SizedBox(width: 15.sp),
          Expanded(child: _buildStatusChart(context)),
        ],
      );
    }
  }
}