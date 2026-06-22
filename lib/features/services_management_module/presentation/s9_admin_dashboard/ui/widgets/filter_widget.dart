import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';

class DepartmentFilterWidget extends StatelessWidget {
  final int totalServices;
  final String selectedStatus;
  final Map<String, int> departmentCounts;
  final Function(String) onStatusChanged;
  final Widget Function(String count, String label, String key,
      {required bool isSelected}) statusChipBuilder;

  const DepartmentFilterWidget({
    Key? key,
    required this.totalServices,
    required this.selectedStatus,
    required this.departmentCounts,
    required this.onStatusChanged,
    required this.statusChipBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale == 'ar';

    // ✅ Get Arabic names dynamically from controller
    final departmentController = Get.find<MainCoreDepartmentController>();

    String _getDisplayName(String englishName) {
      if (!isArabic) return englishName;
      try {
        final deptId = departmentController.getDepartmentIdFromDepartmentName(
          departmentName: englishName.toLowerCase(),
        );
        if (deptId != null) {
          return departmentController.getArabicDepartmentNameFromDepartmentId(
              departmentId: deptId) ??
              englishName;
        }
      } catch (_) {}
      return englishName;
    }

    // Create department data list sorted by count descending
    List<Map<String, dynamic>> departmentData = departmentCounts.entries
        .map((entry) => {
      "key": entry.key,
      "count": entry.value,
    })
        .toList();

    departmentData.sort((a, b) => b['count'].compareTo(a['count']));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // First item: All
          GestureDetector(
            onTap: () => onStatusChanged("All"),
            child: statusChipBuilder(
              "$totalServices",
              isArabic ? "الكل" : "All",
              "All",
              isSelected: selectedStatus == "All",
            ),
          ),
          // Dynamic departments
          ...departmentData.map((dept) => GestureDetector(
            onTap: () => onStatusChanged(dept['key']),
            child: statusChipBuilder(
              "${dept['count']}",
              _getDisplayName(dept['key']),
              dept['key'],
              isSelected: selectedStatus == dept['key'],
            ),
          )),
        ],
      ),
    );
  }
}