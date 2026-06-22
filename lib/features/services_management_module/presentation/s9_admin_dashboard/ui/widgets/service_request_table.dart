/// ******************* FILE INFO *******************
/// File Name: service_request_table.dart
/// Description: Pure rendering table widget.
///              All data extraction delegated to TableDataExtractors.
///              All cell building delegated to TableCellBuilders.
///              All formatting delegated to TableHelpers.
///              Zero Firebase / business logic here.
/// Created by: Amr Mesbah

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/table_cell_builders.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/table_data_extractors.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/table_helpers.dart';

class ServiceRequestTableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> filteredItems;
  final String locale;
  final String? selectStatus;
  final Function(Map<String, dynamic>)? onRowTap;
  final Map<String, String>? enToArDepartments;

  const ServiceRequestTableWidget({
    Key? key,
    required this.filteredItems,
    required this.locale,
    this.onRowTap,
    this.selectStatus,
    this.enToArDepartments,
  }) : super(key: key);

  bool get _isArabic => Get.locale?.languageCode == 'ar';

  // ─── Column widths ─────────────────────────────────────────────────────────

  Map<int, TableColumnWidth> _columnWidths() {
    if (selectStatus == 'All') {
      return {
        0: const FlexColumnWidth(0.5),  // NO
        1: const FlexColumnWidth(0.9),  // Department
        2: const FlexColumnWidth(1.4),  // Service
        3: const FlexColumnWidth(1.5),  // Requester
        4: const FlexColumnWidth(1.5),  // Req Dept
        5: const FlexColumnWidth(1.5),  // Job Title
        6: const FlexColumnWidth(1.2),  // Date
        7: const FlexColumnWidth(0.8),  // Status
        8: const FlexColumnWidth(1.2),  // Provider
      };
    }
    return {
      0: const FlexColumnWidth(0.5),  // NO
      1: const FlexColumnWidth(1.8),  // Service
      2: const FlexColumnWidth(1.5),  // Requester
      3: const FlexColumnWidth(1.5),  // Req Dept
      4: const FlexColumnWidth(1.0),  // Job Title
      5: const FlexColumnWidth(1.0),  // Date
      6: const FlexColumnWidth(0.8),  // Status
      7: const FlexColumnWidth(1.4),  // Provider
    };
  }

  // ─── Headers ───────────────────────────────────────────────────────────────

  List<String> _headers(BuildContext context) {
    final noCol = S.of(context).NO;
    final dept = S.of(context).Department;
    final service = S.of(context).ServiceName;
    final requestor = S.of(context).ServiceRequestor;
    final reqDept = _isArabic ? 'قسم الطالب' : 'Requester Department';
    final jobTitle = _isArabic ? 'مسمى الوظيفة' : 'Job Title';
    final date = S.of(context).RequestedDate;
    final status = S.of(context).Status;
    final provider = S.of(context).ServiceProvider;

    return selectStatus == 'All'
        ? [noCol, dept, service, requestor, reqDept, jobTitle, date, status, provider]
        : [noCol, service, requestor, reqDept, jobTitle, date, status, provider];
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final bool isArabicLocale =
        Localizations.localeOf(context).languageCode == 'ar';

    bool isArabicText(String t) =>
        RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(t);

    final extractor = TableDataExtractors(
      isArabic: _isArabic,
      enToArDepartments: enToArDepartments,
    );

    return Directionality(
      textDirection:
      _isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.sp),
              child: Table(
                border: TableBorder.all(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: _columnWidths(),
                children: [
                  // ── Header row ─────────────────────────────────────────
                  TableRow(
                    decoration: BoxDecoration(
                      color: lightMode ? AppColors.black : AppColors.black.withOpacity(0.45),
                    ),
                    children: _headers(context).map((name) {
                      return Directionality(
                        textDirection: isArabicText(name)
                            ? ui.TextDirection.rtl
                            : ui.TextDirection.ltr,
                        child: Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: Text(
                            name,
                            style: TableCellBuilders.headerStyle(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // ── Data rows ──────────────────────────────────────────
                  ...List.generate(filteredItems.length, (index) {
                    final item = filteredItems[index];
                    final isEven = index.isEven;

                    final rowColor = lightMode
                        ? (isEven
                        ? const Color(0xFFF7F8FA)
                        : AppColors.white)
                        : (isEven
                        ? const Color(0xFF1E1F24)
                        : AppColors.black);

                    void handleTap() => onRowTap?.call(item);

                    // Extract all data
                    final no = extractor.getRequestNumber(item, index);
                    final dept = extractor.getDepartmentName(item);
                    final service = extractor.getServiceName(item);
                    final requesterName = extractor.getRequesterName(item);
                    final reqDept = extractor.getRequesterDepartment(item);
                    final jobTitle = extractor.getRequesterJobTitle(item);
                    final date = extractor.getRequestDate(item);
                    final rawStatus = extractor.getRawStatus(item);
                    final statusText = TableHelpers.getStatusText(
                      rawStatus, context,
                      isArabic: _isArabic,
                    );
                    final statusColor =
                    TableHelpers.getStatusColor(rawStatus);
                    final providerName = extractor.getProviderName(item);
                    final isRequesterMale =
                    extractor.isMale(extractor.getRequesterGender(item));
                    final isProviderMale =
                    extractor.isMale(extractor.getProviderGender(item));

                    // Build cells
                    Widget t(String v, {int ml = 2}) =>
                        TableCellBuilders.tappable(
                          TableCellBuilders.textCell(context, v, maxLines: ml),
                          handleTap,
                        );

                    Widget tColored(String v, Color color) =>
                        TableCellBuilders.tappable(
                          TableCellBuilders.textCell(
                            context, v,
                            textColor: color,
                            fontWeight: FontWeight.w600,
                          ),
                          handleTap,
                        );

                    Widget person(String name, bool isMale) =>
                        TableCellBuilders.tappable(
                          TableCellBuilders.personCell(
                            context, name, isMale,
                            isArabic: _isArabic,
                          ),
                          handleTap,
                        );

                    final cells = selectStatus == 'All'
                        ? <Widget>[
                      t(no, ml: 1),
                      t(dept),
                      t(service),
                      person(requesterName, isRequesterMale),
                      t(reqDept),
                      t(jobTitle),
                      t(date, ml: 1),
                      tColored(statusText, statusColor),
                      person(providerName, isProviderMale),
                    ]
                        : <Widget>[
                      t(no, ml: 1),
                      t(service),
                      person(requesterName, isRequesterMale),
                      t(reqDept),
                      t(jobTitle),
                      t(date, ml: 1),
                      tColored(statusText, statusColor),
                      person(providerName, isProviderMale),
                    ];

                    return TableRow(
                      decoration: BoxDecoration(color: rowColor),
                      children: cells,
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
