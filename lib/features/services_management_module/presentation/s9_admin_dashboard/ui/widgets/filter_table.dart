/// ******************* FILE INFO *******************
/// File Name: table_filter_dialog.dart
/// Description: Reusable filter dialog for table filtering
/// ✅ UPDATED: Mobile responsive layout - fields stacked vertically

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/DatePicker.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/core/widgets/services_management/multi_select_widget.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

class TableFilterDialog extends StatefulWidget {
  final List<String> activeDepartments;
  final List<String> activeStatuses;
  final DateTime? activeDate;

  const TableFilterDialog({
    Key? key,
    this.activeDepartments = const [],
    this.activeStatuses = const [],
    this.activeDate,
  }) : super(key: key);

  @override
  State<TableFilterDialog> createState() => _TableFilterDialogState();

  static Future<Map<String, dynamic>?> show(
      BuildContext context, {
        List<String> activeDepartments = const [],
        List<String> activeStatuses = const [],
        DateTime? activeDate,
      }) async {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => TableFilterDialog(
        activeDepartments: activeDepartments,
        activeStatuses: activeStatuses,
        activeDate: activeDate,
      ),
    );
  }
}

class _TableFilterDialogState extends State<TableFilterDialog> {
  List<String> selectedDepartments = [];
  List<String> selectedStatuses = [];
  DateTime? selectedDate;

  late final MainCoreDepartmentController _deptController;

  final List<String> statuses = [
    "done",
    "approved",
    "pending",
    "rejected",
    "cancel",
    "inprogress",
    "branchsla",
  ];

  @override
  void initState() {
    super.initState();
    selectedDepartments = List.from(widget.activeDepartments);
    selectedStatuses = List.from(widget.activeStatuses);
    selectedDate = widget.activeDate;
    _deptController = Get.find<MainCoreDepartmentController>();
  }

  String _localizeStatus(String status, bool isArabic) {
    if (!isArabic) return FormatHelper.capitalize(status);
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

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isMobile = context.isPhone;

    // ✅ Build department items dynamically
    final List<String> departmentItems = _deptController.departmentsEnglishName
        .asMap()
        .entries
        .map((entry) {
      final engName = entry.value;
      final deptId = _deptController.departmentIds[entry.key];
      if (isArabic) {
        return _deptController.getArabicDepartmentNameFromDepartmentId(
            departmentId: deptId) ??
            engName;
      }
      return engName;
    }).toList();

    // ✅ Build status items dynamically
    final List<String> statusItems =
    statuses.map((s) => _localizeStatus(s, isArabic)).toList();

    // ✅ Department display text
    String deptDisplayText;
    if (selectedDepartments.isEmpty) {
      deptDisplayText = S.of(context).department;
    } else if (selectedDepartments.length == 1) {
      deptDisplayText = isArabic
          ? (_deptController.getArabicDepartmentNameFromDepartmentId(
          departmentId: _deptController
              .getDepartmentId(selectedDepartments.first)) ??
          selectedDepartments.first)
          : selectedDepartments.first;
    } else {
      deptDisplayText =
      '${selectedDepartments.length} ${S.of(context).selected ?? "selected"}';
    }

    // ✅ Status display text
    String statusDisplayText;
    if (selectedStatuses.isEmpty) {
      statusDisplayText = S.of(context).status;
    } else if (selectedStatuses.length == 1) {
      statusDisplayText = _localizeStatus(selectedStatuses.first, isArabic);
    } else {
      statusDisplayText =
      '${selectedStatuses.length} ${S.of(context).selected ?? "selected"}';
    }

    // ✅ Department multi-select widget
    Widget departmentField = AppMultiSelectDropdownMaster(
      items: departmentItems,
      selectedItems: selectedDepartments.map((engName) {
        if (isArabic) {
          final id = _deptController.getDepartmentId(engName);
          return _deptController.getArabicDepartmentNameFromDepartmentId(
              departmentId: id) ??
              engName;
        }
        return engName;
      }).toList(),
      textButton: deptDisplayText,
      hintText: S.of(context).department,
      fillColor: AppColors.background,
      onChanged: (item) {
        String engName = item;
        if (isArabic) {
          engName = _deptController.getDepartmentEnglishNameFromArabicName(
              arabicName: item) ??
              item;
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

    // ✅ Date picker widget
    Widget dateField = _buildRequestDateField(
      selectedDate: selectedDate,
      onDatePicked: (val) => setState(() => selectedDate = val),
    );

    // ✅ Status multi-select widget
    Widget statusField = AppMultiSelectDropdownMaster(
      items: statusItems,
      selectedItems: selectedStatuses
          .map((s) => _localizeStatus(s, isArabic))
          .toList(),
      textButton: statusDisplayText,
      hintText: S.of(context).status,
      fillColor: AppColors.background,
      onChanged: (item) {
        final engStatus = statuses.firstWhere(
              (s) => _localizeStatus(s, isArabic) == item,
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

    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Container(
          width: isMobile ? double.infinity : 645.sp,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──
              _buildHeader(),
              SizedBox(height: 15.sp),

              // ── Fields ──
              if (isMobile) ...[
                // ✅ Mobile: all fields stacked vertically
                departmentField,
                SizedBox(height: 12.sp),
                statusField,
                SizedBox(height: 12.sp),
                dateField,
              ] else ...[
                // ✅ Tablet/Desktop: original row layout
                Row(
                  children: [
                    Expanded(child: departmentField),
                    SizedBox(width: 20.sp),
                    Expanded(child: dateField),
                  ],
                ),
                SizedBox(height: 15.sp),
                Row(
                  children: [
                    Expanded(child: statusField),
                    SizedBox(width: 20.sp),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],

              SizedBox(height: 15.sp),

              // ── Action Buttons ──
              _buildActionButtons(lightMode, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          S.of(context).Filter,
          style: AppTextStyles.font16BlackMediumCairo.copyWith(color: AppColors.text),
        ),
      ],
    );
  }

  Widget _buildRequestDateField({
    required DateTime? selectedDate,
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
                    : S.of(context).requestDate,
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

  Widget _buildActionButtons(bool lightMode, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customButtonAnimation(
          title: S.of(context).Reset,
          function: () {
            setState(() {
              selectedDepartments = [];
              selectedStatuses = [];
              selectedDate = null;
            });
          },
          color: lightMode ? AppColors.grey : AppColors.mediumGrey,
          radius: 8.r,
          textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
            color: lightMode ? AppColors.black : AppColors.white,
          ),
          height: 38.sp,
          width: isMobile ? 120.w : 135.sp,
        ),
        customButtonAnimation(
          title: S.of(context).Apply,
          function: () {
            Navigator.pop(context, {
              'departments': selectedDepartments,
              'statuses': selectedStatuses,
              'date': selectedDate,
            });
          },
          color: AppColors.primary,
          radius: 8.r,
          textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
            color: AppColors.textButton,
          ),
          height: 38.sp,
          width: isMobile ? 120.w : 135.sp,
        ),
      ],
    );
  }
}
