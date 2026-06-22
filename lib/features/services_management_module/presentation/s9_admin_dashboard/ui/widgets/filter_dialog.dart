/// ******************* FILE INFO *******************
/// File Name: service_request_filter_dialog.dart
/// Description: Filter dialog for service requests with department, status, and date filters
/// Created by: Amr Mesbah
/// Last Update: [Current Date]

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/1-custom_dropdwon.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart'; // ✅ Updated import

class ServiceRequestFilterDialog {
  /// Show filter dialog and return selected filters
  static Future<Map<String, dynamic>?> show(
      BuildContext context,
      List<ServicesHistoryModel> models, { // ✅ Updated type
        String? currentDepartment,
        String? currentStatus,
        DateTime? currentDate,
      }) async {
    String? selectedDepartment = currentDepartment;
    String? selectedStatus = currentStatus;
    DateTime? selectedDate = currentDate;

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = context.isPhone;
    final lightMode = Theme.of(context).brightness == Brightness.light;

    final List<String> statuses = [
      "approved",
      "done",
      "cancel",
      "rejected",
      "inprogress",
      "branchsla",
      "pending",
    ];

    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          backgroundColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(15.sp),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: 645.sp,
                  height: isMobile ? 238.sp : 220.sp,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.sp),
                    child: Column(
                      children: [
                        // Header
                        _buildHeader(context, lightMode),
                        SizedBox(height: 15.sp),

                        // Filters
                        isMobile
                            ? _buildMobileFilters(
                          context,
                          setState,
                          selectedDepartment,
                          selectedStatus,
                          selectedDate,
                          statuses,
                          lightMode,
                          isArabic,
                              (val) => selectedDepartment = val,
                              (val) => selectedStatus = val,
                              (val) => selectedDate = val,
                        )
                            : _buildTabletFilters(
                          context,
                          setState,
                          selectedDepartment,
                          selectedStatus,
                          selectedDate,
                          statuses,
                          lightMode,
                          isArabic,
                              (val) => selectedDepartment = val,
                              (val) => selectedStatus = val,
                              (val) => selectedDate = val,
                        ),

                        SizedBox(height: 15.sp),

                        // Buttons
                        _buildButtons(
                          context,
                          setState,
                          selectedDepartment,
                          selectedStatus,
                          selectedDate,
                              () {
                            selectedDepartment = null;
                            selectedStatus = null;
                            selectedDate = null;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ==================== HEADER ====================

  static Widget _buildHeader(BuildContext context, bool lightMode) {
    return Row(
      children: [
        Container(
          width: 30.sp,
          height: 30.sp,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: ClipOval(
              child: SvgPicture.asset(
                "assets/lottie/smallfilter.svg",
                width: 13.sp,
                height: 13.sp,
                fit: BoxFit.fill,
                color: AppColors.textButton,
              ),
            ),
          ),
        ),
        SizedBox(width: 6.sp),
        Text(
          S.of(context).Filter,
          style: AppTextStyles.font16BlackMediumCairo.copyWith(
            color: lightMode ? AppColors.blackButton : AppColors.white,
          ),
        ),
      ],
    );
  }

  // ==================== MOBILE LAYOUT ====================

  static Widget _buildMobileFilters(
      BuildContext context,
      StateSetter setState,
      String? selectedDepartment,
      String? selectedStatus,
      DateTime? selectedDate,
      List<String> statuses,
      bool lightMode,
      bool isArabic,
      ValueChanged<String?> onDepartmentChanged,
      ValueChanged<String?> onStatusChanged,
      ValueChanged<DateTime?> onDateChanged,
      ) {
    return Column(
      children: [
        _buildDepartmentField(
          context,
          selectedDepartment,
              (val) => setState(() => onDepartmentChanged(val)),
          lightMode,
          isArabic,
        ),
        SizedBox(height: 15.sp),
        _buildRequestDateField(
          context,
          selectedDate,
              (val) => setState(() => onDateChanged(val)),
          lightMode,
        ),
        SizedBox(height: 15.sp),
        _buildStatusField(
          context,
          statuses,
          selectedStatus,
              (val) => setState(() => onStatusChanged(val)),
          lightMode,
          isArabic,
        ),
      ],
    );
  }

  // ==================== TABLET LAYOUT ====================

  static Widget _buildTabletFilters(
      BuildContext context,
      StateSetter setState,
      String? selectedDepartment,
      String? selectedStatus,
      DateTime? selectedDate,
      List<String> statuses,
      bool lightMode,
      bool isArabic,
      ValueChanged<String?> onDepartmentChanged,
      ValueChanged<String?> onStatusChanged,
      ValueChanged<DateTime?> onDateChanged,
      ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDepartmentField(
                context,
                selectedDepartment,
                    (val) => setState(() => onDepartmentChanged(val)),
                lightMode,
                isArabic,
              ),
            ),
            SizedBox(width: 20.sp),
            Expanded(
              child: _buildRequestDateField(
                context,
                selectedDate,
                    (val) => setState(() => onDateChanged(val)),
                lightMode,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.sp),
        Row(
          children: [
            Expanded(
              child: _buildStatusField(
                context,
                statuses,
                selectedStatus,
                    (val) => setState(() => onStatusChanged(val)),
                lightMode,
                isArabic,
              ),
            ),
            SizedBox(width: 20.sp),
            Expanded(child: Container())
          ],
        ),
      ],
    );
  }

  // ==================== FILTER FIELDS ====================

  static Widget _buildDepartmentField(
      BuildContext context,
      String? selectedDepartment,
      ValueChanged<String?> onChanged,
      bool lightMode,
      bool isArabic,
      ) {
    final enToAr = {
      "Executive": "الإدارة التنفيذية",
      "Customer Support": "دعم العملاء",
      "Finance": "المالية",
      "Operations": "العمليات",
      "Information Technology": "تقنية المعلومات",
      "Human Resources": "الموارد البشرية",
      "Marketing": "التسويق",
      "Sales": "المبيعات",
      "Data Management": "إدارة البيانات",
      "Compliance & Legal": "الامتثال والشؤون القانونية",
      "Software": "البرمجيات",
    };

    return CustomDropdown<String>(
      value:
          enToAr.keys.contains(selectedDepartment) ? selectedDepartment : null,
      hint: S.of(context).department,
      fillColor: AppColors.background,
      borderRadius: BorderRadius.circular(4.r),
      maxOverlayHeight: 120.sp,
      valueStyle: AppTextStyles.font12BlackCairoRegular.copyWith(
        color: lightMode ? AppColors.blackButton : AppColors.white,
      ),
      itemStyle: AppTextStyles.font12BlackCairoRegular.copyWith(
        color: lightMode ? AppColors.blackButton : AppColors.white,
      ),
      items: enToAr.entries
          .map((e) => DropdownItem<String>(
                value: e.key,
                label: isArabic ? e.value : e.key,
              ))
          .toList(),
      onChanged: (v) => onChanged(v),
    );
  }

  static Widget _buildRequestDateField(
      BuildContext context,
      DateTime? selectedDate,
      ValueChanged<DateTime?> onDatePicked,
      bool lightMode,
      ) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          helpText: S.of(context).RequestDate,
        );
        if (picked != null) onDatePicked(picked);
      },
      child: Container(
        height: 36.sp,
        decoration: BoxDecoration(
          color: lightMode ? AppColors.background : AppColors.background,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: Colors.transparent),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.sp),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              selectedDate != null
                  ? DateFormat('dd MMM yyyy').format(selectedDate)
                  : S.of(context).requestDate,
              style: AppTextStyles.font12BlackCairoRegular.copyWith(
                color: lightMode ? AppColors.secondaryText : AppColors.grey,
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/images/details/Calendar.svg',
              width: 20.sp,
              height: 20.sp,
              color: lightMode ? AppColors.secondaryText : AppColors.whiteShadow,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatusField(
      BuildContext context,
      List<String> statuses,
      String? selectedStatus,
      ValueChanged<String?> onChanged,
      bool lightMode,
      bool isArabic,
      ) {
    String localize(String status) {
      if (!isArabic) return status;
      switch (status) {
        case "approved":
          return "تمت الموافقة";
        case "done":
          return "تم";
        case "cancel":
          return "أُلغي";
        case "rejected":
          return "مرفوض";
        case "inprogress":
          return "قيد التنفيذ";
        case "branchsla":
          return "انتهت المهلة";
        case "pending":
          return "قيد الانتظار";
        default:
          return status;
      }
    }

    return CustomDropdown<String>(
      value: statuses.contains(selectedStatus) ? selectedStatus : null,
      hint: S.of(context).status,
      fillColor: AppColors.background,
      borderRadius: BorderRadius.circular(4.r),
      maxOverlayHeight: 120.sp,
      valueStyle: AppTextStyles.font12BlackCairoRegular.copyWith(
        color: lightMode ? AppColors.blackButton : AppColors.white,
      ),
      itemStyle: AppTextStyles.font12BlackCairoRegular.copyWith(
        color: lightMode ? AppColors.blackButton : AppColors.white,
      ),
      items: statuses
          .map((status) => DropdownItem<String>(
                value: status,
                label:
                    FormatHelper.capitalize(isArabic ? localize(status) : status),
              ))
          .toList(),
      onChanged: (v) => onChanged(v),
    );
  }

  // ==================== BUTTONS ====================

  static Widget _buildButtons(
      BuildContext context,
      StateSetter setState,
      String? selectedDepartment,
      String? selectedStatus,
      DateTime? selectedDate,
      VoidCallback onReset,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customButtonAnimation(
          title: S.of(context).Reset,
          function: () {
            setState(() {
              onReset();
            });
          },
          color: AppColors.grey,
          radius: 8.r,
          textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
            color: AppColors.black,
          ),
          height: 38.sp,
          width: 135.sp,
        ),
        customButtonAnimation(
          title: S.of(context).Apply,
          function: () {
            Navigator.pop(context, {
              'department': selectedDepartment,
              'status': selectedStatus,
              'date': selectedDate,
            });
          },
          color: AppColors.primary,
          radius: 8.r,
          textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
            color: AppColors.textButton,
          ),
          height: 38.sp,
          width: 135.sp,
        ),
      ],
    );
  }
}
