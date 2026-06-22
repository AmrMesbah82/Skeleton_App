  // ignore_for_file: unnecessary_string_interpolations
  import 'dart:math' as math;
  import 'dart:ui' as ui;

  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:get/get.dart';
  import 'package:intl/intl.dart';

  import 'package:demo_app/generated/l10n.dart';
  import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

  import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
  import 'package:demo_app/core/custom/37-custom_navigate.dart';
  import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/pages/details_services_toggle.dart';

  class ServiceTableWidget extends StatelessWidget {
    final List<ServicesHistoryModel> filteredModel;
    final Map<String, dynamic> selectedProviders;
    final String locale; // "ar" or "en"

    const ServiceTableWidget({
      Key? key,
      required this.filteredModel,
      required this.selectedProviders,
      required this.locale,
    }) : super(key: key);

    bool get _isArabic => locale.toLowerCase().startsWith('ar');

    // ---------- helpers ----------
    get _headerStyle => AppTextStyles.font14BlackSemiBoldCairo.copyWith(
        color: AppColors.white
    );

    TextStyle _cellStyle(BuildContext context) => TextStyle(
      fontSize: 13.sp,
      color: Theme.of(context).brightness == Brightness.light
          ? AppColors.text
          : AppColors.white,
    );

    String _toArabicDigits(String input) {
      if (!_isArabic) return input;
      const en = ['0','1','2','3','4','5','6','7','8','9'];
      const ar = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
      var out = input;
      for (var i = 0; i < en.length; i++) {
        out = out.replaceAll(en[i], ar[i]);
      }
      return out;
    }

    String _fmtInt(int n) => _toArabicDigits(n.toString());

    String _statusText(ServicesHistoryModel item, BuildContext context) {
      final raw = (item.currentStatus.isEmpty ? item.currentState : item.currentStatus)
          .toLowerCase()
          .trim();
      if (raw == 'active') return _isArabic ? 'نشط' : 'Active';
      if (raw == 'inactive') return _isArabic ? 'غير نشط' : 'Inactive';
      return _isArabic ? 'مسودة' : 'Draft';
    }

    Color _statusColor(BuildContext context, ServicesHistoryModel item) {
      final s = _statusText(item, context);
      if (s == 'Active' || s == 'نشط') return AppColors.lightGreen;
      if (s == 'Inactive' || s == 'غير نشط') return AppColors.red;
      return Theme.of(context).brightness == Brightness.light
          ? AppColors.text
          : AppColors.white;
    }

    String _localizedUnit(BuildContext context, String? key) {
      final k = (key ?? '').toLowerCase().trim();
      final l = S.of(context);
      switch (k) {
        case 'hour':
        case 'hours':
          return l.hours;
        case 'minute':
        case 'minutes':
          return l.minutes;
        case 'second':
        case 'seconds':
          return l.seconds;
        case 'day':
        case 'days':
          return l.day;
        case 'week':
        case 'weeks':
          return l.week;
        default:
          return _isArabic ? (key ?? '') : FormatHelper.capitalize(key ?? '');
      }
    }

    String _yesNo(BuildContext context, bool yes) {
      if (_isArabic) return yes ? 'نعم' : 'لا';
      return yes ? 'Yes' : 'No';
    }

    String _formatStartDate(dynamic timestampOrDateTime) {
      if (timestampOrDateTime == null) return '-';
      DateTime date;
      if (timestampOrDateTime is DateTime) {
        date = timestampOrDateTime;
      } else if (timestampOrDateTime is Timestamp) {
        date = timestampOrDateTime.toDate();
      } else if (timestampOrDateTime is int) {
        date = DateTime.fromMillisecondsSinceEpoch(timestampOrDateTime);
      } else {
        return '-';
      }
      final formatted = DateFormat('dd MMM yyyy', _isArabic ? 'ar' : 'en')
          .format(date);
      return _isArabic ? _toArabicDigits(formatted) : formatted;
    }

    String _fmtDuration(BuildContext context, ServicesHistoryModel m) {
      final value = m.currentDurationOfServices.trim();
      final unit = _localizedUnit(context, m.currentSelectedDurationUnit);
      final txt = value.isEmpty ? '-' : value;
      return _isArabic ? _toArabicDigits(txt) : txt;
    }

    // Basic padded cell builder
    Widget _cell(BuildContext context, Widget child,
        {EdgeInsets? padding, Alignment? align}) {
      return Container(
        // alignment: align ?? Alignment.centerLeft,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
        child: DefaultTextStyle.merge(
          style: _cellStyle(context),
          child: child,
        ),
      );
    }

    // Text cell with ellipsis and optional maxLines
    Widget _textCell(BuildContext context, String text,
        {int maxLines = 2, TextAlign textAlign = TextAlign.start}) {
      return _cell(
        context,
        Text(
          text.isEmpty ? '-' : text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
        ),
      );
    }

    // Wrap a row child to make the whole row tappable
    Widget _rowTapWrapper(BuildContext context, Widget child, VoidCallback onTap) {
      // Each Table child is wrapped with InkWell so tapping anywhere in the row works.
      return InkWell(
        onTap: onTap,
        child: child,
      );
    }

    // Provider name + avatar cell
    Widget _providerCell(BuildContext context, Map<String, dynamic>? selected) {
      final isArabic = Get.locale?.languageCode == 'ar';
      final isAr = _isArabic;
      if (selected == null) {
        return _cell(
          context,
          Text(isAr ? '—' : '—',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.red,
              )),
          align: Alignment.center,
        );
      }
      final firstAr = (selected['firstNameInArabic'] ?? selected['firstNameArabic'] ?? '').toString().trim();
      final lastAr  = (selected['lastNameInArabic']  ?? selected['lastNameArabic']  ?? '').toString().trim();
      final firstEn = (selected['firstName'] ?? '').toString().trim();
      final lastEn  = (selected['lastName']  ?? '').toString().trim();

      String name;
      if (isAr) {
        name = ('$firstAr $lastAr').trim();
        if (name.isEmpty) name = ('$firstEn $lastEn').trim();
      } else {
        final raw = ('$firstEn $lastEn').trim();
        name = raw.isEmpty ? ('$firstAr $lastAr').trim() : FormatHelper.capitalize(raw);
      }
      if (name.isEmpty) {
        final email = (selected['email']?.toString() ?? '');
        name = email.contains('@') ? email.split('@').first : '-';
      }
      final isMale = (selected['gender']?.toString().toLowerCase() ?? '') == 'male';

      // Arabic: Image LEFT, Text RIGHT (using LTR direction)
      final rowChildrenAr = <Widget>[
        ClipOval(
          child: SvgPicture.asset(
            isMale ? "assets/male.svg" : "assets/female.svg",
            width: 22.sp, height: 22.sp,
          ),
        ),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ),
      ];

      // English: Image RIGHT, Text LEFT (using LTR direction)
      final rowChildrenEn = <Widget>[
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(width: 6.w),
        ClipOval(
          child: SvgPicture.asset(
            isMale ? "assets/male.svg" : "assets/female.svg",
            width: 22.sp, height: 22.sp,
          ),
        ),
      ];

      return _cell(
        context,
        Directionality(
          // Always use LTR direction and control order through children array
          textDirection: ui.TextDirection.ltr,
          child: Row(
            mainAxisAlignment: !isArabic ? MainAxisAlignment.start :  MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: isAr ? rowChildrenEn :rowChildrenAr ,
          ),
        ),
      );
    }

    // New method for department cell
    Widget _departmentCell(BuildContext context, ServicesHistoryModel m) {
      if (m.currentSelectDepartment.isEmpty) {
        return _textCell(context, '-');
      }

      final departments = m.currentSelectDepartment;
      final isDark = Theme.of(context).brightness == Brightness.dark;

      // Show max 2 departments per row, then scroll horizontally
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            direction: Axis.horizontal,
            children: departments.map((dept) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkGrey : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(6.r),

                ),
                child: Text(
                  dept,
                  style: _cellStyle(context).copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    // Replace the existing width calculation methods with these improved versions:

    double calculateWidthOfServicesNameEn(BuildContext context, List<ServicesHistoryModel> visionsList) {
      double maxLength = 0;
      for (var vision in visionsList) {
        final name = vision.currentServiceNameEnglish ?? '';
        if (name.isNotEmpty) {
          maxLength = math.max(maxLength, name.length.toDouble());
        }
      }
      if (maxLength == 0) return context.isPortrait ? 120.w : 150.w;
      double calculatedWidth = math.min((maxLength * 8.sp) + 0.sp, 300.w);
      double minWidth = context.isPortrait ? 120.sp : 140.sp;
      return math.max(calculatedWidth, minWidth);
    }

    double calculateWidthOfServicesNameAR(BuildContext context, List<ServicesHistoryModel> visionsList) {
      double maxLength = 0;
      for (var vision in visionsList) {
        final name = vision.currentServiceNameArabic ?? '';
        if (name.isNotEmpty) {
          maxLength = math.max(maxLength, name.length.toDouble());
        }
      }
      if (maxLength == 0) return context.isPortrait ? 120.w : 150.w;
      double calculatedWidth = math.min((maxLength * 8.sp) + 0.sp, 300.w);
      double minWidth = context.isPortrait ? 120.sp : 140.sp;
      return math.max(calculatedWidth, minWidth);
    }

    double calculateWidthOfServicesDesEN(BuildContext context, List<ServicesHistoryModel> visionsList) {
      double maxLength = 0;
      for (var vision in visionsList) {
        final desc = vision.currentServiceDescriptionEnglish ?? '';
        if (desc.isNotEmpty) {
          maxLength = math.max(maxLength, desc.length.toDouble());
        }
      }
      if (maxLength == 0) return context.isPortrait ? 150.w : 180.w;
      double calculatedWidth = math.min((maxLength * 8.sp) + 0.sp, 300.w);
      double minWidth = context.isPortrait ? 150.sp : 180.sp;
      return math.max(calculatedWidth, minWidth);
    }

    double calculateWidthOfServicesDesAR(BuildContext context, List<ServicesHistoryModel> visionsList) {
      double maxLength = 0;
      for (var vision in visionsList) {
        final desc = vision.currentServiceDescriptionArabic ?? '';
        if (desc.isNotEmpty) {
          maxLength = math.max(maxLength, desc.length.toDouble());
        }
      }
      if (maxLength == 0) return context.isPortrait ? 150.w : 180.w;
      double calculatedWidth = math.min((maxLength * 8.sp) + 0.sp, 300.w);
      double minWidth = context.isPortrait ? 150.sp : 180.sp;
      return math.max(calculatedWidth, minWidth);
    }

    @override
    Widget build(BuildContext context) {
      var lightMode = Theme.of(context).brightness == Brightness.light;
      final isLight = Theme.of(context).brightness == Brightness.light;
      bool isArabic(String text) => RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(text);

      // ---- Column headers - order changes based on locale ----
      final headers = _isArabic
          ? <String>[
        'رقم',
        'اسم الخدمة',
        'Service Name',
        'وصف الخدمة',
        'Service Description',
        S.of(context).status,
        S.of(context).duration,
        S.of(context).timeUnit,
        S.of(context).limitServiceAvailability,
        _isArabic ? 'الأقسام المحددة' : 'Selected Departments', // New column header
        S.of(context).requiresApproval,
        S.of(context).startDate,
        S.of(context).serviceProvider,
      ]
          : <String>[
        'No',
        'Service Name',
        'اسم الخدمة',
        'Service Description',
        'وصف الخدمة',
        S.of(context).status,
        S.of(context).duration,
        S.of(context).timeUnit,
        S.of(context).limitServiceAvailability,
        _isArabic ? 'الأقسام المحددة' : 'Selected Departments', // New column header
        S.of(context).requiresApproval,
        S.of(context).creationDate,
        S.of(context).serviceProvider,
      ];

      final columnWidths = _isArabic
          ? <int, TableColumnWidth>{
        0: FixedColumnWidth(60.sp),
        1: FixedColumnWidth(calculateWidthOfServicesNameAR(context, filteredModel)),
        2: FixedColumnWidth(calculateWidthOfServicesNameEn(context, filteredModel)),
        3: FixedColumnWidth(calculateWidthOfServicesDesAR(context, filteredModel)),
        4: FixedColumnWidth(calculateWidthOfServicesDesEN(context, filteredModel)),
        5: FixedColumnWidth(80.sp),
        6: FixedColumnWidth(55.sp),
        7: FixedColumnWidth(80.sp),
        8: FixedColumnWidth(120.sp),
        9: FixedColumnWidth(200.sp), // New department column
        10: FixedColumnWidth(180.sp),
        11: FixedColumnWidth(120.sp),
        12: FixedColumnWidth(130.sp),
      }
          : <int, TableColumnWidth>{
        0: FixedColumnWidth(60.sp),
        1: FixedColumnWidth(calculateWidthOfServicesNameEn(context, filteredModel)),
        2: FixedColumnWidth(calculateWidthOfServicesNameAR(context, filteredModel)),
        3: FixedColumnWidth(calculateWidthOfServicesDesEN(context, filteredModel)),
        4: FixedColumnWidth(calculateWidthOfServicesDesAR(context, filteredModel)),
        5: FixedColumnWidth(80.sp),
        6: FixedColumnWidth(90.sp),
        7: FixedColumnWidth(90.sp),
        8: FixedColumnWidth(180.sp),
        9: FixedColumnWidth(220.sp), // New department column
        10: FixedColumnWidth(180.sp),
        11: FixedColumnWidth(120.sp),
        12: FixedColumnWidth(180.sp),
      };

      return Directionality(
        textDirection: _isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.sp),
            child: Table(
              border: TableBorder.all(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: columnWidths,
              children: [
                // ---------- Header Row ----------
                TableRow(
                  decoration: BoxDecoration(color: lightMode ? AppColors.black : AppColors.dividerGrey),
                  children: headers
                      .map(
                        (name) => Directionality(
                      textDirection: isArabic(name) ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                      child: Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: Text(
                          name,
                          style: _headerStyle,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),

                // ---------- Data Rows ----------
                ...List.generate(filteredModel.length, (index) {
                  final m = filteredModel[index];
                  final isEven = index.isEven;
                  final rowColor = isLight
                      ? (isEven ? AppColors.oddRowColor : AppColors.white)
                      : (isEven ? AppColors.darkDashboardTable : AppColors.black);

                  VoidCallback _goDetails = () {
                    navigateTo(context, ToggleDetailsServicesLayout(createServicesModel: m));
                  };

                  // Build cells in the correct order based on locale
                  final cells = _isArabic
                      ? [
                    // No.
                    _textCell(context, _fmtInt(index + 1), maxLines: 1),

                    // Service Name (AR) - FIRST in Arabic
                    _cell(
                      context,
                      Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: Text(
                          m.currentServiceNameArabic.isEmpty ? '-' : m.currentServiceNameArabic,
                          textAlign: TextAlign.start,
                          style: _cellStyle(context),
                        ),
                      ),
                    ),

                    // Service Name (EN) - SECOND in Arabic
                    _cell(
                      context,
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: Text(
                          m.currentServiceNameEnglish.isEmpty ? '-' : m.currentServiceNameEnglish,
                          textAlign: TextAlign.start,
                          style: _cellStyle(context),
                        ),
                      ),
                    ),

                    // Arabic Description - FIRST in Arabic
                    _cell(
                      context,
                      Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: Text(
                          m.currentServiceDescriptionArabic.isEmpty ? '-' : m.currentServiceDescriptionArabic,
                          textAlign: TextAlign.start,
                          style: _cellStyle(context),
                        ),
                      ),
                    ),

                    // English Description - SECOND in Arabic
                    _cell(
                      context,
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: Text(
                          m.currentServiceDescriptionEnglish.isEmpty ? '-' : m.currentServiceDescriptionEnglish,
                          textAlign: TextAlign.start,
                          style: _cellStyle(context),
                        ),
                      ),
                    ),

                    // Status
                    _cell(
                      context,
                      Text(
                        _statusText(m, context),
                        style: _cellStyle(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: _statusColor(context, m),
                        ),
                      ),
                    ),
                    // Duration
                    _textCell(context, _fmtDuration(context, m), maxLines: 1),
                    // Time Unit
                    _textCell(context, _localizedUnit(context, m.currentSelectedDurationUnit), maxLines: 1),
                    // Limit Service Availability
                    _textCell(context, _yesNo(context, m.currentSelectDepartment.isNotEmpty)),
                    // NEW: Selected Departments
                    _departmentCell(context, m),
                    // Requires Approval
                    _textCell(context, _yesNo(context, m.currentApprovalCycle.isNotEmpty)),
                    // Start Date
                    _textCell(context, _formatStartDate(m.getTimestampAt(0)), maxLines: 1),
                    // Service Provider
                    _providerCell(context, selectedProviders[m.currentId]),
                  ]
                      : [
                    // No.
                    _textCell(context, _fmtInt(index + 1), maxLines: 1),

                    // Service Name (EN) - FIRST in English
                    _cell(
                      context,
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: Text(
                          m.currentServiceNameEnglish.isEmpty ? '-' : m.currentServiceNameEnglish,
                          textAlign: TextAlign.start,
                          style: _cellStyle(context),
                        ),
                      ),
                    ),

                    // Service Name (AR) - SECOND in English
                    _cell(
                      context,
                      Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: Text(
                          m.currentServiceNameArabic.isEmpty ? '-' : m.currentServiceNameArabic,
                          textAlign: TextAlign.start,
                          style: _cellStyle(context),
                        ),
                      ),
                    ),

                    // English Description - FIRST in English
                    _cell(
                      context,
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: Text(
                          m.currentServiceDescriptionEnglish.isEmpty ? '-' : m.currentServiceDescriptionEnglish,
                          textAlign: TextAlign.start,
                          style: _cellStyle(context),
                        ),
                      ),
                    ),

                    // Arabic Description - SECOND in English
                    _cell(
                      context,
                      Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: Text(
                          m.currentServiceDescriptionArabic.isEmpty ? '-' : m.currentServiceDescriptionArabic,
                          textAlign: TextAlign.start,
                          style: _cellStyle(context),
                        ),
                      ),
                    ),

                    // Status
                    _cell(
                      context,
                      Text(
                        _statusText(m, context),
                        style: _cellStyle(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: _statusColor(context, m),
                        ),
                      ),
                    ),
                    // Duration
                    _textCell(context, _fmtDuration(context, m), maxLines: 1),
                    // Time Unit
                    _textCell(context, _localizedUnit(context, m.currentSelectedDurationUnit), maxLines: 1),
                    // Limit Service Availability
                    _textCell(context, _yesNo(context, m.currentSelectDepartment.isNotEmpty)),
                    // NEW: Selected Departments
                    _departmentCell(context, m),
                    // Requires Approval
                    _textCell(context, _yesNo(context, m.currentApprovalCycle.isNotEmpty)),
                    // Start Date
                    _textCell(context, _formatStartDate(m.getTimestampAt(0)), maxLines: 1),
                    // Service Provider
                    _providerCell(context, selectedProviders[m.currentId]),
                  ];

                  return TableRow(
                    decoration: BoxDecoration(color: rowColor),
                    children: cells.map((cell) => _rowTapWrapper(context, cell, _goDetails)).toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    }
  }
