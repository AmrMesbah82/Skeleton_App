import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';

import 'package:demo_app/core/widgets/custom_check_box.dart';
import 'package:demo_app/core/widgets/services_management/custom_check_box.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';


class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onTap,
    required this.isSelected,
    required this.isLightMode,
    required this.name,
  });

  final dynamic employee;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isLightMode;
  final String name;

  String _getDisplayJobTitle(bool isEnglish) {
    final titleEn = (employee.title ?? '').trim();
    final titleAr = (employee.titleInArabic ?? '').trim();

    String title = isEnglish
        ? (titleEn.isNotEmpty ? FormatHelper.capitalize(titleEn) : titleAr)
        : (titleAr.isNotEmpty ? titleAr : titleEn);

    final abbreviationRegex = RegExp(r'\(([^)]+)\)\s*$');
    final match = abbreviationRegex.firstMatch(title);

    if (match != null) {
      return match.group(1) ?? title;
    }

    return title;
  }

  // Add this method to get department name
  String _getDepartmentName(bool isEnglish) {
    final departmentController = Get.find<MainCoreDepartmentController>();
    final departmentId = employee.departmentId ?? employee.department ?? '';

    if (departmentId.isEmpty) return '';

    return departmentController.getDepartmentName(departmentId, isEnglish);
  }

  @override
  Widget build(BuildContext context) {
    var isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 77.sp,
            padding: EdgeInsets.only(left: 0, top: 10.sp, bottom: 10.sp, right: 10.sp),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: SvgPicture.asset(
                      (employee.gender ?? '').toString().toLowerCase() == 'male'
                          ? 'assets/male.svg'
                          : 'assets/female.svg',
                      semanticsLabel: 'Gender Icon',
                      fit: BoxFit.cover,
                      width: 40.sp,
                      height: 40.sp,
                    ),
                  ),
                ),
                SizedBox(width: 10.sp),
                Expanded(
                  child: _EmployeeTexts(
                    name: isEnglish
                        ? FormatHelper.capitalize("${employee.firstName} ${employee.lastName}")
                        : FormatHelper.capitalize("${employee.firstNameInArabic} ${employee.lastNameInArabic}"),
                    department: _getDepartmentName(isEnglish), // ✅ Pass department here
                    jobTitle: _getDisplayJobTitle(isEnglish),
                    isLightMode: isLightMode,
                  ),
                ),

              ],
            ),
          ),
          Positioned(
            top: 10.sp,
            right: 10.sp,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.sp),
                child: CustomCheckBox(
                  isSelected: isSelected,
                  size: 20.sp,
                  borderColor: AppColors.secondaryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeTexts extends StatelessWidget {
  const _EmployeeTexts({
    required this.name,
    required this.department, // ✅ Add department parameter
    required this.jobTitle,
    required this.isLightMode,
  });

  final String name;
  final String department; // ✅ Add this field
  final String jobTitle;
  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font14BlackCairoMedium.copyWith(
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 3.sp),
        Text(
          department, // ✅ Now this is defined
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font12BlackCairoRegular.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        SizedBox(height: 3.sp),
        Text(
          jobTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font12BlackCairoRegular.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
