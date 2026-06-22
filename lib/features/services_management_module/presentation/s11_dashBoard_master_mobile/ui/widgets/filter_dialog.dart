import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:demo_app/core/widgets/DatePicker.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/widgets/services_management/multi_select_widget.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

class FilterDialogDashBoard {
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    String? currentDepartment,
    String? currentStatus,
    DateTime? currentDate,
    required Map<String, String> departmentEnToAr,
    required String filterText,
    required String departmentText,
    required String requestDateText,
    required String statusText,
    required String resetText,
    required String applyText,
    Color? primaryColor,
    Color? backgroundColor,
    Color? textColor,
  }) async {
    List<String> selectedDepartments =
    (currentDepartment != null && currentDepartment.isNotEmpty)
        ? [currentDepartment]
        : [];
    List<String> selectedStatuses =
    (currentStatus != null && currentStatus.isNotEmpty)
        ? [currentStatus]
        : [];
    DateTime? selectedDate = currentDate;

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final primColor = primaryColor ?? Theme.of(context).primaryColor;

    final List<String> statuses = [
      "approved",
      "done",
      "cancel",
      "rejected",
      "inprogress",
      "branchsla",
      "pending",
    ];

    String localizeStatus(String status) {
      if (!isArabic) {
        switch (status) {
          case "cancel":
            return "Cancelled";
          case "branchsla":
            return "Branch SLA";
          default:
            return status[0].toUpperCase() + status.substring(1).toLowerCase();
        }
      }
      switch (status) {
        case "approved":
          return "تمت الموافقة";
        case "done":
          return "تم";
        case "cancel":
          return "ملغى";
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

    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          backgroundColor: AppColors.card,
          child: Padding(
            padding: EdgeInsets.all(15.sp),
            child: StatefulBuilder(
              builder: (context, setState) {
                final isMobile = context.isPhone;

                // Department display text
                String deptDisplayText;
                if (selectedDepartments.isEmpty) {
                  deptDisplayText = departmentText;
                } else if (selectedDepartments.length == 1) {
                  final name = selectedDepartments.first;
                  deptDisplayText =
                  isArabic ? (departmentEnToAr[name] ?? name) : name;
                } else {
                  deptDisplayText =
                  '${selectedDepartments.length} ${S.of(context).selected ?? "selected"}';
                }

                // Status display text
                String statusDisplayText;
                if (selectedStatuses.isEmpty) {
                  statusDisplayText = statusText;
                } else if (selectedStatuses.length == 1) {
                  statusDisplayText =
                      localizeStatus(selectedStatuses.first);
                } else {
                  statusDisplayText =
                  '${selectedStatuses.length} ${S.of(context).selected ?? "selected"}';
                }

                // Department items (localized labels)
                final List<String> departmentItems =
                departmentEnToAr.entries.map((e) {
                  return isArabic ? e.value : e.key;
                }).toList();

                // Status items (localized labels)
                final List<String> statusItems =
                statuses.map((s) => localizeStatus(s)).toList();

                // ── Shared widgets ──
                final departmentDropdown = AppMultiSelectDropdownMaster(
                  items: departmentItems,
                  selectedItems: selectedDepartments.map((engName) {
                    return isArabic
                        ? (departmentEnToAr[engName] ?? engName)
                        : engName;
                  }).toList(),
                  textButton: deptDisplayText,
                  hintText: departmentText,
                  fillColor: AppColors.background,
                  onChanged: (item) {
                    String engName = item;
                    if (isArabic) {
                      engName = departmentEnToAr.entries
                          .firstWhere(
                            (e) => e.value == item,
                        orElse: () => MapEntry(item, item),
                      )
                          .key;
                    }
                    setState(() {
                      if (selectedDepartments.contains(engName)) {
                        selectedDepartments.remove(engName);
                      } else {
                        selectedDepartments.add(engName);
                      }
                    });
                  },
                );

                final dateField = _buildDateField(
                  context: context,
                  selectedDate: selectedDate,
                  hintText: requestDateText,
                  onDatePicked: (val) =>
                      setState(() => selectedDate = val),
                );

                final statusDropdown = AppMultiSelectDropdownMaster(
                  items: statusItems,
                  selectedItems: selectedStatuses
                      .map((s) => localizeStatus(s))
                      .toList(),
                  textButton: statusDisplayText,
                  hintText: statusText,
                  fillColor: AppColors.background,
                  onChanged: (item) {
                    final engStatus = statuses.firstWhere(
                          (s) => localizeStatus(s) == item,
                      orElse: () => item,
                    );
                    setState(() {
                      if (selectedStatuses.contains(engStatus)) {
                        selectedStatuses.remove(engStatus);
                      } else {
                        selectedStatuses.add(engStatus);
                      }
                    });
                  },
                );

                return Container(
                  width: isMobile ? double.infinity : 645.sp,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Header ──
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
                                fit: BoxFit.fill,
                                color: AppColors.textButton,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.sp),
                          Text(
                            filterText,
                            style: AppTextStyles.font16BlackMediumCairo
                                .copyWith(color: AppColors.text),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.sp),

                      // ── Filter Fields ──
                      if (isMobile) ...[
                        // ── MOBILE: stacked vertically ──
                        departmentDropdown,
                        SizedBox(height: 12.sp),
                        dateField,
                        SizedBox(height: 12.sp),
                        statusDropdown,
                      ] else ...[
                        // ── TABLET / DESKTOP: rows ──
                        Row(
                          children: [
                            Expanded(child: departmentDropdown),
                            SizedBox(width: 20.sp),
                            Expanded(child: dateField),
                          ],
                        ),
                        SizedBox(height: 15.sp),
                        Row(
                          children: [
                            Expanded(child: statusDropdown),
                            SizedBox(width: 20.sp),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                      ],

                      SizedBox(height: 15.sp),

                      // ── Buttons ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customButtonAnimation(
                            title: resetText,
                            function: () {
                              setState(() {
                                selectedDepartments = [];
                                selectedStatuses = [];
                                selectedDate = null;
                              });
                            },
                            color: lightMode
                                ? AppColors.grey
                                : AppColors.mediumGrey,
                            radius: 8.r,
                            textStyle:
                            AppTextStyles.font16BlackMediumCairo.copyWith(
                              color: lightMode
                                  ? AppColors.black
                                  : AppColors.white,
                            ),
                            height: 38.sp,
                            width: isMobile ? 120.sp : 135.sp,
                          ),
                          customButtonAnimation(
                            title: applyText,
                            function: () {
                              Navigator.pop(dialogContext, {
                                'department':
                                selectedDepartments.isNotEmpty
                                    ? selectedDepartments.first
                                    : null,
                                'status': selectedStatuses.isNotEmpty
                                    ? selectedStatuses.first
                                    : null,
                                'date': selectedDate,
                                'departments': selectedDepartments,
                                'statuses': selectedStatuses,
                              });
                            },
                            color: AppColors.primary,
                            radius: 8.r,
                            textStyle:
                            AppTextStyles.font16BlackMediumCairo.copyWith(
                              color: AppColors.textButton,
                            ),
                            height: 38.sp,
                            width: isMobile ? 120.sp : 135.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ── Date Field ──
  static Widget _buildDateField({
    required BuildContext context,
    required DateTime? selectedDate,
    required String hintText,
    required ValueChanged<DateTime?> onDatePicked,
  }) {
    return GestureDetector(
      onTap: () async {
        final picked = await DatePicker().showDatePicker(
          context,
          selectedDate != null ? [selectedDate] : [],
          selectedDate ?? DateTime.now(),
          CalendarDatePicker2Type.single,
          firstDate: DateTime(2020),
        );
        if (picked != null && picked.isNotEmpty && picked.first != null) {
          onDatePicked(picked.first);
        }
      },
      child: Container(
        height: 38.sp,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.sp),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedDate != null
                    ? DateFormat('dd MMM yyyy').format(selectedDate)
                    : hintText,
                style: AppTextStyles.font12BlackCairoRegular.copyWith(
                  color: selectedDate != null
                      ? AppColors.text
                      : AppColors.secondaryText,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/images/details/Calendar.svg',
              width: 20.sp,
              height: 20.sp,
              color: AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}
