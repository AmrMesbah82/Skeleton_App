import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/widgets/services_management/custom_filter.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/data/department_count_model.dart';

class DepartmentFilterChipsWidget extends StatelessWidget {
  final String selectedDepartment;
  final DepartmentCountModel departmentCounts;
  final Function(String) onDepartmentChanged;

  const DepartmentFilterChipsWidget({
    required this.selectedDepartment,
    required this.departmentCounts,
    required this.onDepartmentChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return DepartmentFilterChips(
      selectedKey: selectedDepartment,
      onSelected: (key) {
        onDepartmentChanged(key);
      },
      totalCount: departmentCounts.total,
      departmentCounts: departmentCounts.departmentCounts,
      userDepartment: '', // Pass empty or actual user department if needed
      isArabic: isArabic,
    );
  }
}
