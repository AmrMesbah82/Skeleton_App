import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/enumeration/enum.dart' as FormatHelper;
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/features/services_management_module/presentation/s7_approvals/ui/pages/approval_request_details_toggle.dart';

class TableDetailsServicesWidget extends StatelessWidget {
  final BuildContext context;
  final ServicesHistoryModel parentModel;
  final List<Map<String, dynamic>> map;
  final String locale;

  TableDetailsServicesWidget({
    Key? key,
    required this.context,
    required this.parentModel,
    required this.map,
    required this.locale,
  }) : super(key: key);

  bool get _isArabic => locale.toLowerCase().startsWith('ar');

  // ✅ Get controllers
  MainCoreEmployeeController get _employeeController => Get.find<MainCoreEmployeeController>();
  MainCoreDepartmentController get _departmentController => Get.find<MainCoreDepartmentController>();

  // Status color mapping
  final Map<String, Color> _statusTextColors = {
    'approved': Color(0xFF16A34A),
    'done': Color(0xFF15803D),
    'rejected': Color(0xFFB91C1C),
    'pending': Color(0xFFF59E0B),
    'inprogress': Color(0xFFEAB308),
    'cancel': Color(0xFFDC2626),
    'canceled': Color(0xFFDC2626),
    'breached sla': Color(0xFFDC2626),
    'branchsla': Color(0xFFDC2626),
  };

  // Status localization map
  final Map<String, String> statusLocalizationMap = {
    "approved": "تمت الموافقة",
    "done": "تم",
    "cancel": "أُلغي",
    "rejected": "مرفوض",
    "inprogress": "قيد التنفيذ",
    "branchsla": "انتهت المهلة",
    "breached sla": "انتهت المهلة",
    "pending": "قيد الانتظار",
    "active": "نشط",
    "inactive": "غير نشط",
  };

  TextStyle get _headerStyle => AppTextStyles.font14BlackSemiBoldCairo.copyWith(
    color: AppColors.white,
  );

  TextStyle _cellStyle(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return AppTextStyles.font13SecondaryBlackCairo.copyWith(
        color: lightMode ? AppColors.blackButton : AppColors.white);
  }

  String _toArabicDigits(String input) {
    if (!_isArabic) return input;
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const ar = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var out = input;
    for (var i = 0; i < en.length; i++) {
      out = out.replaceAll(en[i], ar[i]);
    }
    return out;
  }

  String _fmtInt(int n) => _toArabicDigits(n.toString());

  Widget _cell(BuildContext context, Widget child,
      {EdgeInsets? padding, Alignment? align}) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
      child: DefaultTextStyle.merge(
        style: _cellStyle(context),
        child: child,
      ),
    );
  }

  Widget _textCell(BuildContext context, String text,
      {int maxLines = 2, TextAlign textAlign = TextAlign.start, Color? textColor}) {
    return _cell(
      context,
      Text(
        FormatHelper.capitalize(text.isEmpty ? '-' : text),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        style: textColor != null ? _cellStyle(context).copyWith(color: textColor) : null,
      ),
    );
  }

  Widget _rowTapWrapper(BuildContext context, Widget child, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: child,
    );
  }

  Widget _requesterCell(BuildContext context, Map<String, dynamic> item) {
    final model = item['model'] as ServicesHistoryModel;

    String email = '';
    if (model.currentEmailRequester != null && model.currentEmailRequester.isNotEmpty) {
      email = model.currentEmailRequester;
    }

    String requester = '-';
    String? gender = 'male';

    if (email.isNotEmpty) {
      requester = _employeeController.getEmployeeNameEnglishArabic(email, !_isArabic);
      final employee = _employeeController.mapOfEmployeesWithEmailKey[email];
      gender = employee?.gender?.toLowerCase() ?? 'male';
    }

    final isMale = (gender ?? 'male') == 'male';

    final rowChildrenEn = <Widget>[
      ClipOval(
        child: SvgPicture.asset(
          isMale ? "assets/male.svg" : "assets/female.svg",
          width: 22.sp,
          height: 22.sp,
        ),
      ),
      SizedBox(width: 6.w),
      Flexible(
        child: Text(
          FormatHelper.capitalize(requester.trim().isEmpty ? '-' : requester.trim()),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      ),
    ];

    final rowChildrenAr = <Widget>[
      ClipOval(
        child: SvgPicture.asset(
          isMale ? "assets/male.svg" : "assets/female.svg",
          width: 22.sp,
          height: 22.sp,
        ),
      ),
      SizedBox(width: 6.w),
      Flexible(
        child: Text(
          requester.trim().isEmpty ? '-' : requester.trim(),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      ),
    ];

    return _cell(
      context,
      Directionality(
        textDirection: _isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _isArabic ? rowChildrenAr : rowChildrenEn,
        ),
      ),
    );
  }

  Widget _providerCell(BuildContext context, Map<String, dynamic> item) {
    final model = item['model'] as ServicesHistoryModel;

    String providerName = '-';
    String? providerGender;

    if (model.currentProviderServices != null && model.currentProviderServices.isNotEmpty) {
      // ✅ FIX: Match assigned provider email instead of always using .first
      final assignedEmail = model.currentAssignedProviderEmail?.toLowerCase().trim() ?? '';

      EmployeeEntityModell? provider;

      if (assignedEmail.isNotEmpty) {
        for (final p in model.currentProviderServices) {
          if ((p.email?.toLowerCase().trim() ?? '') == assignedEmail) {
            provider = p;
            break;
          }
        }
      }

      // Fallback to first if no match found
      provider ??= model.currentProviderServices.first;

      if (_isArabic) {
        providerName = "${provider.firstNameInArabic ?? ''} ${provider.lastNameInArabic ?? ''}".trim();
        if (providerName.isEmpty) {
          providerName = "${provider.firstName ?? ''} ${provider.lastName ?? ''}".trim();
        }
      } else {
        providerName = "${provider.firstName ?? ''} ${provider.lastName ?? ''}".trim();
      }

      providerGender = provider.gender?.toLowerCase();
    }

    if (providerName.isEmpty || providerName == '') {
      return _textCell(context, '-');
    }

    final isMale = (providerGender ?? 'male') == 'male';

    final rowChildrenEn = <Widget>[
      ClipOval(
        child: SvgPicture.asset(
          isMale ? "assets/male.svg" : "assets/female.svg",
          width: 22.sp,
          height: 22.sp,
        ),
      ),
      SizedBox(width: 6.w),
      Flexible(
        child: Text(
          FormatHelper.capitalize(providerName),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      ),
    ];

    final rowChildrenAr = <Widget>[
      ClipOval(
        child: SvgPicture.asset(
          isMale ? "assets/male.svg" : "assets/female.svg",
          width: 22.sp,
          height: 22.sp,
        ),
      ),
      SizedBox(width: 6.w),
      Flexible(
        child: Text(
          providerName,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      ),
    ];

    return _cell(
      context,
      Directionality(
        textDirection: _isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _isArabic ? rowChildrenAr : rowChildrenEn,
        ),
      ),
    );
  }


  Color _getStatusColor(String status, BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    return _statusTextColors[status.toLowerCase()] ??
        (lightMode ? AppColors.secondaryText : AppColors.white);
  }

  // ✅ UPDATED - Dynamic department fetching
  String _getDepartmentText(ServicesHistoryModel model) {
    String email = '';
    if (model.currentEmailRequester != null && model.currentEmailRequester.isNotEmpty) {
      email = model.currentEmailRequester;
    }

    if (email.isEmpty) return '-';

    // Get employee from controller
    final employee = _employeeController.mapOfEmployeesWithEmailKey[email];

    if (employee == null || employee.departmentId == null) {
      return '-';
    }

    // ✅ Use department controller to get department name dynamically
    return _departmentController.getDepartmentName(employee.departmentId!, _isArabic ? false : true) ?? '-';
  }

  String _getJobTitle(ServicesHistoryModel model) {
    String email = '';
    if (model.currentEmailRequester != null && model.currentEmailRequester.isNotEmpty) {
      email = model.currentEmailRequester;
    }

    if (email.isEmpty) return '-';

    return _employeeController.getEmployeeJobTitle(email);
  }

  String _formatRequestedDate(ServicesHistoryModel model) {
    if (model.timestamps.isEmpty) return '-';

    final date = DateTime.fromMillisecondsSinceEpoch(model.timestamps.first);
    final formatted = DateFormat('dd MMM yyyy', _isArabic ? 'ar' : 'en').format(date);

    return _isArabic ? _toArabicDigits(formatted) : formatted;
  }

  String _getLocalizedStatus(String status) {
    final lowerStatus = status.toLowerCase();
    return _isArabic
        ? statusLocalizationMap[lowerStatus] ?? 'غير معروف'
        : statusEnglishMap[lowerStatus] ?? FormatHelper.capitalize(lowerStatus);
  }

  final Map<String, String> statusEnglishMap = {
    "approved": "Approved",
    "done": "Done",
    "cancel": "Canceled",
    "canceled": "Canceled",
    "rejected": "Rejected",
    "inprogress": "In progress",
    "branchsla": "Breached SLA",
    "breached sla": "Breached SLA",
    "pending": "Pending",
    "active": "Active",
    "inactive": "Inactive",
  };

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;

    // Column headers
    final headers = <String>[
      S.of(context).NO,
      S.of(context).serviceRequester,
      S.of(context).department,
      S.of(context).jobTitle,
      S.of(context).RequestedDate,
      S.of(context).status,
      S.of(context).serviceProvider,
    ];

    // Calculate flexible column widths that take full width
    final columnWidths = <int, TableColumnWidth>{
      0: FlexColumnWidth(0.8),  // NO
      1: FlexColumnWidth(2.0),  // Service Requester
      2: FlexColumnWidth(1.8),  // Department
      3: FlexColumnWidth(2.2),  // Job Title
      4: FlexColumnWidth(1.5),  // Requested Date
      5: FlexColumnWidth(1.2),  // Status
      6: FlexColumnWidth(2.0),  // Service Provider
    };

    // Build table rows - ALWAYS include header + data rows (no empty state row)
    List<TableRow> tableRows = [
      // Header Row - ALWAYS PRESENT
      TableRow(
        decoration: BoxDecoration(
          color: lightMode ? AppColors.black : AppColors.black.withOpacity(0.45),
        ),
        children: headers
            .map(
              (name) => Container(
            padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
            child: Text(
              name,
              style: _headerStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
        )
            .toList(),
      ),
    ];

    // Add data rows (only if map is not empty)
    if (map.isNotEmpty) {
      tableRows.addAll(
        List.generate(map.length, (index) {
          final item = map[index];
          final model = item['model'] as ServicesHistoryModel;
          final isEven = index.isEven;
          final rowColor = lightMode
              ? (isEven ? const Color(0xFFF7F8FA) : AppColors.white)
              : (isEven ? const Color(0xFF1E1F24) : AppColors.black);

          goToDetails() {
            final detailsIndex = map.indexOf(item);

            if (model.currentProviderServices == null || model.currentProviderServices.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).requestHasNoAssignedProvider),
                  backgroundColor: AppColors.orange,
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            navigateTo(
              context,
              ServicesApprovalDetailsToggle(
                createServicesModel: model,
                index: detailsIndex,
                approvalModel: model,
                fromTable: true,
              ),
            );
          }

          return TableRow(
            decoration: BoxDecoration(color: rowColor),
            children: [
              _rowTapWrapper(
                context,
                _textCell(context, _fmtInt(index + 1), maxLines: 1),
                goToDetails,
              ),
              _rowTapWrapper(
                context,
                _requesterCell(context, item),
                goToDetails,
              ),
              _rowTapWrapper(
                context,
                _textCell(context, _getDepartmentText(model)),
                goToDetails,
              ),
              _rowTapWrapper(
                context,
                _textCell(context, _getJobTitle(model)),
                goToDetails,
              ),
              _rowTapWrapper(
                context,
                _textCell(context, _formatRequestedDate(model), maxLines: 1),
                goToDetails,
              ),
              _rowTapWrapper(
                context,
                _textCell(
                  context,
                  _getLocalizedStatus(item['status']?.toString() ?? ''),
                  textColor: _getStatusColor(item['status']?.toString() ?? '', context),
                ),
                goToDetails,
              ),
              _rowTapWrapper(
                context,
                _providerCell(context, item),
                goToDetails,
              ),
            ],
          );
        }),
      );
    }

    return Column(
      children: [
        Directionality(
          textDirection: _isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
          child: Container(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.sp),
              child: Table(
                border: TableBorder.all(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: columnWidths,
                children: tableRows, // ✅ Use the pre-built list
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

Widget tableDetailsServices(
    BuildContext context,
    ServicesHistoryModel parentModel,
    List<Map<String, dynamic>> map,
    ) {
  final locale = Localizations.localeOf(context).languageCode;

  return TableDetailsServicesWidget(
    context: context,
    parentModel: parentModel,
    map: map,
    locale: locale,
  );
}
