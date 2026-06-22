// ----------------------------- 🔍 Search & Filter Dialog (PERSISTENT) -----------------------------
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'dart:ui' as ui;
import 'package:demo_app/core/widgets/DatePicker.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_multi_select.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/widgets/services_management/custom_drop_down.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';

Future<Map<String, dynamic>?> showFilterDialog(
    BuildContext context,
    List<ServicesHistoryModel> models, {
      List<String>? initialDepartments,
      List<String>? initialStatuses,
      DateTime? initialDate,
      String? initialSortBy,
      bool isEmployeesTab = false,
    }) async {
  try {
    // ✅ Get department controller
    final departmentController = Get.find<MainCoreDepartmentController>();

    // ✅ Initialize from parent (persisted values)
    List<String> selectedDepartments = initialDepartments ?? [];
    List<String> selectedStatuses = initialStatuses ?? [];
    String? selectedSortBy = initialSortBy;

    // normalize date to yyyy-mm-dd (drop time)
    DateTime? selectedDate = (initialDate == null)
        ? null
        : DateTime(initialDate.year, initialDate.month, initialDate.day);

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // ✅ UPDATED: Bilingual status map (English key -> Arabic label)
    final Map<String, String> statusMap = {
      "Done": isArabic ? "منجز" : "Done",
      "Approved": isArabic ? "معتمد" : "Approved",
      "In Progress": isArabic ? "قيد التنفيذ" : "In Progress",
      "Pending": isArabic ? "قيد الانتظار" : "Pending",
      "Rejected": isArabic ? "مرفوض" : "Rejected",
      "Canceled": isArabic ? "ملغي" : "Canceled",
      "Breached SLA": isArabic ? "تجاوز الاتفاق" : "Breached SLA",
    };

    // ✅ Get status keys (English - used internally)
    final List<String> statusKeys = statusMap.keys.toList();

    // ✅ Get status display labels (Arabic or English - shown to user)
    final List<String> statusLabels = statusMap.values.toList();

    // ✅ Sort options for employees tab (bilingual)
    final Map<String, String> sortOptionsMap = {
      "Done": isArabic ? "منجز" : "Done",
      "Breached SLA": isArabic ? "تجاوز الاتفاق" : "Breached SLA",
    };

    final List<String> sortKeys = sortOptionsMap.keys.toList();
    final List<String> sortLabels = sortOptionsMap.values.toList();

    // ✅ Get dynamic departments from controller
    final allDepartments = isArabic
        ? departmentController.departmentsArabicName
        : departmentController.departmentsEnglishName;

    // Get date range from models using FieldHistory timestamps
    final allDates = models
        .where((m) => m.timestamps.isNotEmpty)
        .map((m) {
      final timestamp = m.timestamps.first;
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateTime(date.year, date.month, date.day);
    })
        .toList()
      ..sort();

    final DateTime? minDate = allDates.isNotEmpty ? allDates.first : null;
    final DateTime? maxDate = allDates.isNotEmpty ? allDates.last : null;

    return await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final isMobile = dialogContext.isPhone;
        final lightMode = Theme.of(dialogContext).brightness == Brightness.light;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: lightMode ? AppColors.white : AppColors.chatBackground,
          child: StatefulBuilder(
            builder: (builderContext, setDialogState) {
              return Container(
                width: isMobile ? null : 645.sp,
                constraints: BoxConstraints(
                  maxWidth: 645.sp,
                  minWidth: isMobile ? 300.sp : 500.sp,
                ),
                decoration: BoxDecoration(
                  color: lightMode ? AppColors.white : AppColors.chatBackground,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.all(15.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 30.sp,
                          height: 30.sp,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/lottie/smallfilter.svg",
                              width: 13.sp,
                              height: 13.sp,
                              fit: BoxFit.scaleDown,
                              color: AppColors.textButton,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.sp),
                        Text(
                          S.of(builderContext).Filter,
                          style: AppTextStyles.font16BlackMediumCairo.copyWith(
                            color: lightMode ? AppColors.blackButton : AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.sp),

                    // Form Fields
                    _buildFormFields(
                      context: builderContext,
                      isMobile: isMobile,
                      isArabic: isArabic,
                      lightMode: lightMode,
                      isEmployeesTab: isEmployeesTab,
                      selectedDepartments: selectedDepartments,
                      selectedDate: selectedDate,
                      selectedStatuses: selectedStatuses,
                      selectedSortBy: selectedSortBy,
                      minDate: minDate,
                      maxDate: maxDate,
                      allDepartments: allDepartments,
                      statusKeys: statusKeys,
                      statusLabels: statusLabels,
                      statusMap: statusMap,
                      sortKeys: sortKeys,
                      sortLabels: sortLabels,
                      sortOptionsMap: sortOptionsMap,
                      onDepartmentsChanged: (dept) {
                        setDialogState(() {
                          if (selectedDepartments.contains(dept)) {
                            selectedDepartments.remove(dept);
                          } else {
                            selectedDepartments.add(dept);
                          }
                        });
                      },
                      onDateChanged: (val) => setDialogState(() => selectedDate = val),
                      onStatusesChanged: (status) {
                        setDialogState(() {
                          if (selectedStatuses.contains(status)) {
                            selectedStatuses.remove(status);
                          } else {
                            selectedStatuses.add(status);
                          }
                        });
                      },
                      onSortByChanged: (val) => setDialogState(() => selectedSortBy = val),
                    ),

                    SizedBox(height: 25.sp),

                    // Buttons
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: customButtonAnimation(
                            title: S.of(builderContext).Reset,
                            function: () {
                              setDialogState(() {
                                selectedDepartments.clear();
                                selectedStatuses.clear();
                                selectedDate = null;
                                selectedSortBy = null;
                              });
                            },
                            color: lightMode ? AppColors.grey : AppColors.mediumGrey,
                            radius: 8.r,
                            textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(color: lightMode ? AppColors.black : AppColors.white ),
                            height: 42.sp,
                          ),
                        ),
                        SizedBox(width: 15.sp),
                        Expanded(
                          child: customButtonAnimation(
                            title: S.of(builderContext).Apply,
                            function: () {
                              Navigator.of(dialogContext).pop({
                                'departments': selectedDepartments,
                                'statuses': selectedStatuses,
                                'date': selectedDate,
                                'sortBy': selectedSortBy,
                              });
                            },
                            color: AppColors.primary,
                            radius: 8.r,
                            textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
                              color: AppColors.textButton,
                            ),
                            height: 42.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  } catch (e) {
    return null;
  }
}

Widget _buildFormFields({
  required BuildContext context,
  required bool isMobile,
  required bool isArabic,
  required bool lightMode,
  required bool isEmployeesTab,
  required List<String> selectedDepartments,
  required DateTime? selectedDate,
  required List<String> selectedStatuses,
  required String? selectedSortBy,
  required DateTime? minDate,
  required DateTime? maxDate,
  required List<String> allDepartments,
  required List<String> statusKeys,
  required List<String> statusLabels,
  required Map<String, String> statusMap,
  required List<String> sortKeys,
  required List<String> sortLabels,
  required Map<String, String> sortOptionsMap,
  required Function(String) onDepartmentsChanged,
  required Function(DateTime?) onDateChanged,
  required Function(String) onStatusesChanged,
  required Function(String?) onSortByChanged,
}) {
  // ✅ Department Multi-Select Dropdown (BOTH TABS)
  final departmentDropdown = AppMultiSelectDropdown(
    selectedItems: selectedDepartments,
    items: allDepartments,

    textButton: selectedDepartments.isEmpty
        ? null
        : '${selectedDepartments.length} ${S.of(context).department}${selectedDepartments.length > 1 ? 's' : ''} ${isArabic ? 'محددة' : 'Selected'}',
    hintText: S.of(context).department,
    onChanged: (value) => onDepartmentsChanged(value as String),
    width: isMobile ? double.infinity : 300.sp,
    height: 38.sp,
  //  menuWidth: isMobile ? 300.sp : 280.sp,
    fillColor: lightMode ? AppColors.background : AppColors.background,
    textStyle: AppTextStyles.font12BlackCairoRegular.copyWith(
      color: AppColors.secondaryText,
    ),
    textColor: AppColors.secondaryText,
    forceDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
  );

  // ✅ Date Picker Field (REQUESTED SERVICES ONLY)
  final datePickerField = _buildDatePickerField(
    context: context,
    isMobile: isMobile,
    lightMode: lightMode,
    isArabic: isArabic,
    selectedDate: selectedDate,
    minDate: minDate,
    maxDate: maxDate,
    onDateChanged: onDateChanged,
  );

  final statusDropdown = _buildBilingualMultiSelect(
    context: context,
    isMobile: isMobile,
    lightMode: lightMode,
    isArabic: isArabic,
    selectedKeys: selectedStatuses,
    itemKeys: statusKeys,
    itemLabels: statusLabels,
    labelMap: statusMap,
    hintText: S.of(context).status,
    onChanged: onStatusesChanged,
  );

  // ✅ UPDATED: Sort By Dropdown with bilingual support
  final sortByDropdown = _buildBilingualSingleSelect(
    context: context,
    isMobile: isMobile,
    lightMode: lightMode,
    isArabic: isArabic,
    selectedKey: selectedSortBy,
    itemKeys: sortKeys,
    itemLabels: sortLabels,
    labelMap: sortOptionsMap,
    hintText: S.of(context).sort ?? 'Sort By',
    onChanged: onSortByChanged,
  );

  // ✅ CONDITIONAL LAYOUT BASED ON TAB
  if (isEmployeesTab) {
    // EMPLOYEES TAB: Department + Sort By
    if (isMobile) {
      return Column(
        children: [
          departmentDropdown,
          SizedBox(height: 15.sp),
          sortByDropdown,
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(child: departmentDropdown),
          SizedBox(width: 15.sp),
          Expanded(child: sortByDropdown),
        ],
      );
    }
  } else {
    // REQUESTED SERVICES TAB: Department + Date + Status
    if (isMobile) {
      return Column(
        children: [
          departmentDropdown,
          SizedBox(height: 15.sp),
          datePickerField,
          SizedBox(height: 15.sp),
          statusDropdown,
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: departmentDropdown),
              SizedBox(width: 15.sp),
              Expanded(child: datePickerField),
            ],
          ),
          SizedBox(height: 15.sp),
          Row(
            children: [
              Expanded(child: statusDropdown),
              SizedBox(width: 15.sp),
              Expanded(child: SizedBox()),
            ],
          ),
        ],
      );
    }
  }
}

// ✅ NEW: Bilingual Multi-Select Widget
// ✅ NEW: Bilingual Multi-Select Widget
// ✅ NEW: Bilingual Multi-Select Widget
Widget _buildBilingualMultiSelect({
  required BuildContext context,
  required bool isMobile,
  required bool lightMode,
  required bool isArabic,
  required List<String> selectedKeys,
  required List<String> itemKeys,
  required List<String> itemLabels,
  required Map<String, String> labelMap,
  required String hintText,
  required Function(String) onChanged,
}) {
  // ✅ Create display text for selected items
  String? displayText;
  if (selectedKeys.isNotEmpty) {
    final translatedItems = selectedKeys.map((key) => labelMap[key] ?? key).toList();
    displayText = translatedItems.join(', ');

    // If too long, show count instead
    if (displayText.length > 50) {
      displayText = '${selectedKeys.length} ${isArabic ? 'محددة' : 'selected'}';
    }
  }

  return AppMultiSelectDropdown(
    selectedItems: selectedKeys,
    items: itemKeys,
    itemLabelMap: labelMap, // ✅ CRITICAL: Pass translation map
    textButton: displayText,
    hintText: hintText,
    onChanged: (value) => onChanged(value as String),
    width: isMobile ? double.infinity : 300.sp,
    height: 38.sp,
    //menuWidth: isMobile ? 300.sp : 280.sp,
    fillColor: lightMode ? AppColors.background : AppColors.background,
    textStyle: AppTextStyles.font12BlackCairoRegular.copyWith(
      color: AppColors.secondaryText
    ),
    textColor: AppColors.secondaryBlack,
    forceDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
  );
}

// ✅ NEW: Bilingual Single-Select Widget
Widget _buildBilingualSingleSelect({
  required BuildContext context,
  required bool isMobile,
  required bool lightMode,
  required bool isArabic,
  required String? selectedKey,
  required List<String> itemKeys,
  required List<String> itemLabels,
  required Map<String, String> labelMap,
  required String hintText,
  required Function(String?) onChanged,
})
{
  return CustomDropdownFormFieldInv(
    key: ValueKey('dropdown_${selectedKey ?? DateTime.now().millisecondsSinceEpoch}'),
    selectedValue: selectedKey,
    items: itemKeys.map((key) => {
      "key": key,
      "value": labelMap[key] ?? key,
    }).toList(),
    onChanged: onChanged,
    iconPaddingRight: 8.w,
    iconPaddingLeft: 8.w,
    width: isMobile ? double.infinity : 280.sp,  // ✅ FIX
    height: 38,
    dropdownWidth: null,  // ✅ FIX: Let it auto-match trigger width via _popupWidth
    dropdownColor: AppColors.background,
    iconPath: 'assets/arrowdown.svg',
    widthIcon: 20.sp,
    heightIcon: 20.sp,
    hint: Text(
      hintText,
      style: AppTextStyles.font12BlackCairoRegular.copyWith(
        color: AppColors.secondaryText,
      ),
    ),
  );
}

// ✅ Updated date picker field widget using DatePicker class
Widget _buildDatePickerField({
  required BuildContext context,
  required bool isMobile,
  required bool lightMode,
  required bool isArabic,
  required DateTime? selectedDate,
  required DateTime? minDate,
  required DateTime? maxDate,
  required Function(DateTime?) onDateChanged,
}) {
  return GestureDetector(
    onTap: () async {
      final result = await DatePicker().showDatePicker(
        context,
        selectedDate != null ? [selectedDate] : [],
        selectedDate,
        CalendarDatePicker2Type.single,
        firstDate: minDate ?? DateTime(2020),
      );

      if (result != null && result.isNotEmpty && result.first != null) {
        onDateChanged(result.first);
      }
    },
    child: Container(
      width: isMobile ? double.infinity : 300.sp,
      decoration: BoxDecoration(
        color: lightMode ? AppColors.background : AppColors.background,
        borderRadius: BorderRadius.circular(4.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 10.sp),
      child: Row(
        children: [
          Expanded(
            child: Text(
              selectedDate != null
                  ? DateFormat('dd MMM yyyy', isArabic ? 'ar' : 'en').format(selectedDate)
                  : S.of(context).RequestDate,
              style: AppTextStyles.font12BlackCairoRegular.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/images/details/Calendar.svg',
            height: 15.sp,
            width: 15.sp,
            color: lightMode ? AppColors.mediumGrey : AppColors.grey,
          ),
        ],
      ),
    ),
  );
}
