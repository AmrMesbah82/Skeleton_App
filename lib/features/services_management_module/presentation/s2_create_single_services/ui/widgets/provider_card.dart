import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/core/custom/23-custom_check_box.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

class ProviderCard extends StatelessWidget {
  final EmployeeEntityPro employee;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isEditMode; // ✅ NEW


  const ProviderCard({
    super.key,
    required this.employee,
    required this.isSelected,
    required this.onTap,
    this.isEditMode = false, // ✅ NEW — default false
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final departmentController = Get.find<MainCoreDepartmentController>();

    final displayName = _getDisplayName(isArabic);
    final displayDepartment = _getDisplayDepartment(departmentController, isArabic);
    final displayRole = _getDisplayJobTitle(isArabic);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8.r),
      //    border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
        ),
        padding: EdgeInsets.only(right: 10.sp, left: 0.sp, top: 10.sp, bottom: 10.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            SizedBox(width: 10.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayName,
                    style: AppTextStyles.font13SecondaryBlackCairo.copyWith(color: AppColors.text),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 3.sp),
                  Text(
                    displayDepartment,
                    style: AppTextStyles.font10SecondaryBlackCairoRegular.copyWith(color: AppColors.secondaryText),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 3.sp),
                  Text(
                    displayRole,
                    style: AppTextStyles.font10SecondaryBlackCairoRegular.copyWith(color: AppColors.secondaryText),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            _buildCheckbox(isArabic),
            SizedBox(width: isArabic ? 10.sp : 0.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 30.r,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: SvgPicture.asset(
          employee.gender == "male" ? 'assets/male.svg' : 'assets/female.svg',
          fit: BoxFit.cover,
          width: 40.sp,
          height: 40.sp,
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool isArabic) {
    // ✅ Hide checkbox in editProvider (single-select) mode
    if (isEditMode) return const SizedBox.shrink();

    return CustomCheckBox(
      isSelected: isSelected,
      size: 20.sp,
      borderColor: AppColors.secondaryText,
    );
  }

  String _getDisplayName(bool isArabic) {
    final nameEn = [employee.firstName, employee.lastName]
        .where((x) => (x ?? '').trim().isNotEmpty)
        .join(' ')
        .trim();
    final nameAr = [employee.firstNameInArabic, employee.lastNameInArabic]
        .where((x) => (x ?? '').trim().isNotEmpty)
        .join(' ')
        .trim();

    return isArabic
        ? (nameAr.isNotEmpty ? nameAr : nameEn)
        : (nameEn.isNotEmpty ? FormatHelper.capitalize(nameEn) : nameAr);
  }

  String _getDisplayDepartment(MainCoreDepartmentController controller, bool isArabic) {
    if (employee.departmentId == null || employee.departmentId!.isEmpty) {
      return isArabic ? 'القسم غير محدد' : 'Department not specified';
    }
    try {
      return controller.getDepartmentName(employee.departmentId!, !isArabic);
    } catch (e) {
      return isArabic ? 'القسم غير محدد' : 'Department not specified';
    }
  }

  String _getDisplayJobTitle(bool isArabic) {
    final titleEn = (employee.title ?? '').trim();
    final titleAr = (employee.titleInArabic ?? '').trim();

    String title = isArabic
        ? (titleAr.isNotEmpty ? titleAr : titleEn)
        : (titleEn.isNotEmpty ? FormatHelper.capitalize(titleEn) : titleAr);

    // Extract abbreviation from parentheses at the end
    final abbreviationRegex = RegExp(r'\(([^)]+)\)\s*$');
    final match = abbreviationRegex.firstMatch(title);

    if (match != null) {
      // Return only what's inside the parentheses
      return match.group(1) ?? title;
    }

    return title;
  }
}
