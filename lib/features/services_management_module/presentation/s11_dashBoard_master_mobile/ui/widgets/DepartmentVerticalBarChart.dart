import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/custom/32-custom_svg.dart';
import 'package:demo_app/core/widgets/services_management/DashBoard_widget.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

class DepartmentVerticalBarChart extends StatelessWidget {
  final String title;
  final String? iconAsset;
  final Map<String, int> departmentCounts;
  final Map<String, Color> departmentColors;
  final Map<String, String> enToArDepartments;
  final Widget? headerWidget;
  final double? maxY;
  final double? height;
  final double? width;
  final double? barWidth;
  final Color? iconBackgroundColor;
  final Color? backgroundColor;
  final double groupsSpace;
  final bool showGrid;
  final bool lightMode;

  const DepartmentVerticalBarChart({
    Key? key,
    required this.title,
    required this.departmentCounts,
    required this.departmentColors,
    required this.enToArDepartments,
    this.iconAsset,
    this.headerWidget,
    this.maxY,
    this.height,
    this.width,
    this.barWidth,
    this.iconBackgroundColor,
    this.backgroundColor,
    this.groupsSpace = 15,
    this.showGrid = true,
    required this.lightMode,
  }) : super(key: key);

  /// ✅ Get department label dynamically from controller
  /// Priority: Arabic name from controller (if isArabic) → English name from controller → key as-is
  String _getDepartmentLabel(String key, bool isArabic) {
    try {
      final controller = Get.find<MainCoreDepartmentController>();

      if (isArabic) {
        // Try Arabic name first
        // key could be an ID or an English name
        if (int.tryParse(key) != null) {
          // It's an ID
          final arabicName = controller.getArabicDepartmentNameFromDepartmentId(
            departmentId: key,
          );
          if (arabicName != null && arabicName.isNotEmpty) return arabicName;
        } else {
          // It's an English name → get ID first → then Arabic
          final deptId = controller.getDepartmentIdFromDepartmentName(
            departmentName: key.toLowerCase(),
          );
          if (deptId != null && deptId != 'none') {
            final arabicName = controller.getArabicDepartmentNameFromDepartmentId(
              departmentId: deptId,
            );
            if (arabicName != null && arabicName.isNotEmpty) return arabicName;
          }
          // Fallback: check enToArDepartments map
          if (enToArDepartments.containsKey(key)) {
            return enToArDepartments[key]!;
          }
        }
      } else {
        // English display
        if (int.tryParse(key) != null) {
          // It's an ID → get English name
          final englishName = controller.getEnglishDepartmentNameFromDepartmentId(
            departmentId: key,
          );
          if (englishName != null && englishName.isNotEmpty) return englishName;
        } else {
          // Already an English name — normalize via controller for consistent casing
          final deptId = controller.getDepartmentIdFromDepartmentName(
            departmentName: key.toLowerCase(),
          );
          if (deptId != null && deptId != 'none') {
            final englishName = controller.getEnglishDepartmentNameFromDepartmentId(
              departmentId: deptId,
            );
            if (englishName != null && englishName.isNotEmpty) return englishName;
          }
        }
      }
    } catch (e) {
    }

    // Final fallback: return key as-is
    return key;
  }

  /// ✅ Prepare labels + values from departmentCounts dynamically
  /// ✅ Filter out departments with zero values
  Map<String, dynamic> _prepareData(bool isArabic) {
    // ✅ Filter out departments with zero values
    final entries = departmentCounts.entries
        .where((e) => e.value > 0)
        .toList();

    List<String> labels = entries
        .map((e) => _getDepartmentLabel(e.key, isArabic))
        .toList();

    List<double> values = entries.map((e) => e.value.toDouble()).toList();

    List<Color> colors = entries
        .map((e) => departmentColors[e.key] ?? AppColors.primary)
        .toList();

    // ✅ Reverse for Arabic RTL display
    if (isArabic) {
      labels = labels.reversed.toList();
      values = values.reversed.toList();
      colors = colors.reversed.toList();
    }

    return {
      'labels': labels,
      'values': values,
      'colors': colors,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final data = _prepareData(isArabic);
    final labels = data['labels'] as List<String>;
    final values = data['values'] as List<double>;

    return CustomVerticalBarChartWidget(
      title: title,
      iconAsset: iconAsset,
      labels: labels,
      values: values,
      headerWidget: headerWidget,
      maxY: maxY,
      height: height,
      width: width,
      barWidth: barWidth,
      barColor: AppColors.primary,
      iconBackgroundColor: iconBackgroundColor,
      backgroundColor: backgroundColor,
      groupsSpace: groupsSpace,
      showGrid: showGrid,
      lightMode: lightMode,
      showAllMonths: false,
    );
  }
}
