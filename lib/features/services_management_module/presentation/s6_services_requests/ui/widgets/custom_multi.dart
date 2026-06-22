import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/core/widgets/services_management/multi_select_widget.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

class DepartmentMultiSelectPage extends StatefulWidget {
  const DepartmentMultiSelectPage({
    super.key,
    required this.selectedKeys,
    required this.onChanged,
  });

  /// The selected department IDs from parent
  final List<String> selectedKeys;

  /// Callback with the updated list of selected department IDs
  final ValueChanged<List<String>> onChanged;

  @override
  State<DepartmentMultiSelectPage> createState() => _DepartmentMultiSelectPageState();
}

class _DepartmentMultiSelectPageState extends State<DepartmentMultiSelectPage> {
  final MainCoreDepartmentController _departmentController = Get.find<MainCoreDepartmentController>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    // Ensure departments are loaded
    if (_departmentController.departmentModels.isEmpty) {
      await _departmentController.getAllDepartments();
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _toggleDepartment(String departmentId) {
    final List<String> next = List<String>.from(widget.selectedKeys);
    if (next.contains(departmentId)) {
      next.remove(departmentId);
    } else {
      next.add(departmentId);
    }
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (_isLoading) {
      return SizedBox(
        width: 190.sp,
        height: 36.h,
        child: Container(
          decoration: BoxDecoration(
            color: lightMode ? AppColors.white : AppColors.chatBackground,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: SizedBox(
              width: 16.sp,
              height: 16.sp,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      );
    }

    // Get department IDs
    final departmentIds = _departmentController.departmentIds;

    if (departmentIds.isEmpty) {
      return SizedBox(
        width: 190.sp,
        height: 36.h,
        child: Container(
          decoration: BoxDecoration(
            color: lightMode ? AppColors.white : AppColors.chatBackground,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              s.department,
              style: AppTextStyles.font14BlackCairoRegular.copyWith(
                color: lightMode ? AppColors.secondaryText : AppColors.grey,
              ),
            ),
          ),
        ),
      );
    }

    // Build display names based on language
    final itemsDisplay = departmentIds.map((id) {
      return _departmentController.getDepartmentName(id, isArabic ? false : true);
    }).toList();

    // Map selected IDs to display names
    final selectedDisplay = widget.selectedKeys.map((id) {
      return _departmentController.getDepartmentName(id, isArabic ? false : true);
    }).toList();

    return SizedBox(
      width: 190.w,
      height: 34.h,
      child: AppMultiSelectDropdownMaster(
        items: itemsDisplay,
        selectedItems: selectedDisplay,
        onChanged: (displayName) {
          // Find the department ID from the display name
          final index = itemsDisplay.indexOf(displayName.toString());
          if (index != -1) {
            final departmentId = departmentIds[index];
            _toggleDepartment(departmentId);
          }
        },
        textButton: s.department,
        textStyle: AppTextStyles.font14BlackCairoRegular.copyWith(
          color: lightMode ? AppColors.secondaryText : AppColors.grey,
        ),
        hintText: s.department,
        width: double.infinity,
        height: 36.h,
        menuWidth: 190.sp,
      ),
    );
  }
}
