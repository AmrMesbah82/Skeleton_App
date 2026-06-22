import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';

class ServicesDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> displayedItems;
  final Map<String, String> enToArDepartments;
  final String Function(dynamic, String) formatDate;
  final Color Function(String, BuildContext) getStatusColor;
  final String noText;
  final String jobTitleText;
  final String requesterDepartmentText;
  final String serviceNameText;
  final String serviceRequestorText;
  final String requestedDateText;
  final String statusText;
  final String serviceProviderText;
  final String doneText;
  final String pendingText;
  final String inprogressText;
  final String breachedSLAText;
  final String rejectedText;
  final String canceledText;
  final String approvedText;
  final Color? headerBackgroundColor;
  final Color? headerTextColor;
  final Color? evenRowColor;
  final Color? oddRowColor;
  final Color? textColor;

  const ServicesDataTable({
    Key? key,
    required this.displayedItems,
    required this.enToArDepartments,
    required this.formatDate,
    required this.getStatusColor,
    required this.noText,
    required this.jobTitleText,
    required this.requesterDepartmentText,
    required this.serviceNameText,
    required this.serviceRequestorText,
    required this.requestedDateText,
    required this.statusText,
    required this.serviceProviderText,
    required this.doneText,
    required this.pendingText,
    required this.inprogressText,
    required this.breachedSLAText,
    required this.rejectedText,
    required this.canceledText,
    required this.approvedText,
    this.headerBackgroundColor,
    this.headerTextColor,
    this.evenRowColor,
    this.oddRowColor,
    this.textColor,
  }) : super(key: key);

  // ══════════════════════════════════════════════════════════════════════════
  // ✅ Sort helper – ascending by requestDate (old → new)
  // ══════════════════════════════════════════════════════════════════════════
  List<Map<String, dynamic>> _sortedByRequestDateAscending() {
    final sorted = List<Map<String, dynamic>>.from(displayedItems);
    sorted.sort((a, b) {
      final dateA = a['requestDate'];
      final dateB = b['requestDate'];

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1; // nulls go to end
      if (dateB == null) return -1;

      // ── Firestore Timestamp ──
      if (dateA is Timestamp && dateB is Timestamp) {
        return dateA.compareTo(dateB);
      }

      // ── DateTime ──
      if (dateA is DateTime && dateB is DateTime) {
        return dateA.compareTo(dateB);
      }

      // ── String fallback ──
      return dateA.toString().compareTo(dateB.toString());
    });
    return sorted;
  }

  String _getDepartmentDisplayName(String departmentValue, String locale) {
    if (departmentValue.isEmpty) return '';

    if (departmentValue.contains(RegExp(r'[a-zA-Z]'))) {
      if (locale == 'ar') {
        return enToArDepartments[departmentValue] ?? departmentValue;
      }
      return departmentValue;
    }

    try {
      final departmentController = Get.find<MainCoreDepartmentController>();
      final departmentName = departmentController.getDepartmentName(
        departmentValue,
        locale == 'en',
      );
      return departmentName ?? departmentValue;
    } catch (e) {
      return departmentValue;
    }
  }

  String _getJobTitleFromRequester(Map<String, dynamic> item, String locale) {

    // ✅ Check direct keys first (jobTitleRequester, jobTitleRequesterArabic)
    final jobTitleEnglish = item['jobTitleRequester']?.toString() ?? '';
    final jobTitleArabic = item['jobTitleRequesterArabic']?.toString() ?? '';

    // ✅ Return based on locale
    String jobTitle = locale == 'ar'
        ? (jobTitleArabic.isNotEmpty ? jobTitleArabic : jobTitleEnglish)
        : (jobTitleEnglish.isNotEmpty ? jobTitleEnglish : jobTitleArabic);

    if (jobTitle.isEmpty || jobTitle == 'null') {
      // ✅ Fallback to requesterData (old structure)
      final requesterData = item['requesterData'] as Map<String, dynamic>?;
      if (requesterData != null) {
        final jobTitleFromData = locale == 'ar'
            ? requesterData['jobTitleInArabic']?.toString() ??
            requesterData['jobTitle']?.toString()
            : requesterData['jobTitle']?.toString();

        if (jobTitleFromData != null &&
            jobTitleFromData.isNotEmpty &&
            jobTitleFromData != 'null') {
          jobTitle = jobTitleFromData;
        }
      }
    }

    if (jobTitle.isEmpty || jobTitle == 'null') {
      // ✅ Fallback to model data
      final model = item['model'];
      if (model != null) {
        final jobTitleFromModel = locale == 'ar'
            ? model.currentJobTitleRequesterArabic ??
            model.currentJobTitleRequester
            : model.currentJobTitleRequester ??
            model.currentJobTitleRequesterArabic;

        if (jobTitleFromModel != null &&
            jobTitleFromModel.isNotEmpty &&
            jobTitleFromModel != 'null') {
          jobTitle = jobTitleFromModel;
        }
      }
    }

    // ✅ Extract text between parentheses if it exists
    if (jobTitle.isNotEmpty && jobTitle != 'null') {
      final regex = RegExp(r'\(([^)]+)\)');
      final match = regex.firstMatch(jobTitle);

      if (match != null && match.group(1) != null) {
        final abbreviation = match.group(1)!;
        return abbreviation;
      }

      return jobTitle;
    }

    return '-';
  }

  String _getDepartmentFromRequester(
      Map<String, dynamic> item, String locale) {

    // ✅ Check direct 'department' key first
    final departmentValue = item['department']?.toString() ?? '';

    if (departmentValue.isNotEmpty && departmentValue != 'null') {
      final displayName = _getDepartmentDisplayName(departmentValue, locale);
      return displayName;
    }

    // ✅ Fallback to requesterData (old structure)
    final requesterData = item['requesterData'] as Map<String, dynamic>?;
    if (requesterData != null) {
      final deptValue = requesterData['department']?.toString() ?? '';
      if (deptValue.isNotEmpty) {
        final displayName = _getDepartmentDisplayName(deptValue, locale);
        return displayName;
      }
    }

    // ✅ Fallback to model data
    final model = item['model'];
    if (model != null) {
      final deptValue = model.currentDepartmentRequester ?? '';
      if (deptValue.isNotEmpty) {
        final displayName = _getDepartmentDisplayName(deptValue, locale);
        return displayName;
      }
    }

    return '-';
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ✅ Provider name helper with full fallback chain
  // ══════════════════════════════════════════════════════════════════════════
  String _getProviderName(Map<String, dynamic> item, String locale) {

    // ── 1️⃣ Try selectedProvider map (locale-matched) ──
    final selectedProvider =
        item['selectedProvider'] as Map<String, dynamic>? ?? {};

    String providerName = locale == 'ar'
        ? '${selectedProvider['firstNameInArabic'] ?? ''} ${selectedProvider['lastNameInArabic'] ?? ''}'
        .trim()
        : '${selectedProvider['firstName'] ?? ''} ${selectedProvider['lastName'] ?? ''}'
        .trim();

    if (providerName.isNotEmpty && providerName != 'null') {
      return providerName;
    }

    // ── 2️⃣ Try selectedProvider map (cross-locale fallback) ──
    providerName = locale == 'ar'
        ? '${selectedProvider['firstName'] ?? ''} ${selectedProvider['lastName'] ?? ''}'
        .trim()
        : '${selectedProvider['firstNameInArabic'] ?? ''} ${selectedProvider['lastNameInArabic'] ?? ''}'
        .trim();

    if (providerName.isNotEmpty && providerName != 'null') {
      return providerName;
    }

    // ── 3️⃣ Try direct keys on item map ──
    final directProvider = locale == 'ar'
        ? '${item['providerFirstNameArabic'] ?? item['providerFirstNameInArabic'] ?? ''} ${item['providerLastNameArabic'] ?? item['providerLastNameInArabic'] ?? ''}'
        .trim()
        : '${item['providerFirstName'] ?? ''} ${item['providerLastName'] ?? ''}'
        .trim();

    if (directProvider.isNotEmpty && directProvider != 'null') {
      return directProvider;
    }

    // Cross-locale fallback for direct keys
    final directProviderFallback = locale == 'ar'
        ? '${item['providerFirstName'] ?? ''} ${item['providerLastName'] ?? ''}'
        .trim()
        : '${item['providerFirstNameArabic'] ?? item['providerFirstNameInArabic'] ?? ''} ${item['providerLastNameArabic'] ?? item['providerLastNameInArabic'] ?? ''}'
        .trim();

    if (directProviderFallback.isNotEmpty &&
        directProviderFallback != 'null') {
      return directProviderFallback;
    }

    // ── 4️⃣ Try model object ──
    final model = item['model'];
    if (model != null) {
      try {
        // Try locale-matched from model
        final modelProvider = locale == 'ar'
            ? '${model.providerFirstNameArabic ?? model.providerFirstNameInArabic ?? ''} ${model.providerLastNameArabic ?? model.providerLastNameInArabic ?? ''}'
            .trim()
            : '${model.providerFirstName ?? ''} ${model.providerLastName ?? ''}'
            .trim();

        if (modelProvider.isNotEmpty && modelProvider != 'null') {
          return modelProvider;
        }

        // Cross-locale fallback from model
        final modelProviderFallback = locale == 'ar'
            ? '${model.providerFirstName ?? ''} ${model.providerLastName ?? ''}'
            .trim()
            : '${model.providerFirstNameArabic ?? model.providerFirstNameInArabic ?? ''} ${model.providerLastNameArabic ?? model.providerLastNameInArabic ?? ''}'
            .trim();

        if (modelProviderFallback.isNotEmpty &&
            modelProviderFallback != 'null') {
          return modelProviderFallback;
        }

        // ── 5️⃣ Try selectedProvider inside model ──
        final modelSelectedProvider = model.selectedProvider;
        if (modelSelectedProvider != null &&
            modelSelectedProvider is Map<String, dynamic>) {
          final msp = locale == 'ar'
              ? '${modelSelectedProvider['firstNameInArabic'] ?? ''} ${modelSelectedProvider['lastNameInArabic'] ?? ''}'
              .trim()
              : '${modelSelectedProvider['firstName'] ?? ''} ${modelSelectedProvider['lastName'] ?? ''}'
              .trim();

          if (msp.isNotEmpty && msp != 'null') {
            return msp;
          }

          // Cross-locale
          final mspFallback = locale == 'ar'
              ? '${modelSelectedProvider['firstName'] ?? ''} ${modelSelectedProvider['lastName'] ?? ''}'
              .trim()
              : '${modelSelectedProvider['firstNameInArabic'] ?? ''} ${modelSelectedProvider['lastNameInArabic'] ?? ''}'
              .trim();

          if (mspFallback.isNotEmpty && mspFallback != 'null') {
            return mspFallback;
          }
        }
      } catch (e) {
      }
    }

    return 'N/A';
  }

  // ── Gender helper for provider ──
  String _getProviderGender(Map<String, dynamic> item) {
    final selectedProvider =
        item['selectedProvider'] as Map<String, dynamic>? ?? {};
    final gender = selectedProvider['gender']?.toString() ?? '';
    if (gender.isNotEmpty && gender != 'null') return gender;

    // Fallback to model
    final model = item['model'];
    if (model != null) {
      try {
        final modelSelectedProvider = model.selectedProvider;
        if (modelSelectedProvider != null &&
            modelSelectedProvider is Map<String, dynamic>) {
          final mGender =
              modelSelectedProvider['gender']?.toString() ?? '';
          if (mGender.isNotEmpty && mGender != 'null') return mGender;
        }
      } catch (_) {}
    }

    return 'male';
  }

  double _calculateWidthOfColumn(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double maxLength = 0.0;

    if (displayedItems.isEmpty) {
      return isPortrait ? 120.w : 150.w;
    }

    for (var vision in displayedItems) {
      String displayName;
      if (locale == 'ar') {
        displayName = vision['serviceNameArabic']?.toString() ??
            vision['serviceName']?.toString() ??
            '';
      } else {
        displayName = vision['serviceName']?.toString() ?? '';
      }

      if (displayName.isNotEmpty && displayName != 'null') {
        maxLength = math.max(maxLength, displayName.length.toDouble());
      }
    }

    if (maxLength == 0) return isPortrait ? 120.w : 150.w;

    double calculatedWidth = isPortrait
        ? math.min((maxLength * 13.sp) / 2 + 20, 300.w)
        : math.min((maxLength * 13.sp) / 2 + 20, 400.w);

    double minWidth = isPortrait ? 100.sp : 120.sp;
    return math.max(calculatedWidth, minWidth);
  }

  double _calculateWidthOfRequester(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double maxLength = 0.0;

    if (displayedItems.isEmpty) {
      return isPortrait ? 140.w : 180.w;
    }

    for (var vision in displayedItems) {
      String displayName;
      if (locale == 'ar') {
        displayName = vision['requestorArabic']?.toString() ??
            vision['requestor']?.toString() ??
            '';
      } else {
        displayName = vision['requestor']?.toString() ?? '';
      }

      if (displayName.isNotEmpty && displayName != 'null') {
        maxLength = math.max(maxLength, displayName.length.toDouble());
      }
    }

    if (maxLength == 0) return isPortrait ? 140.w : 180.w;

    double calculatedWidth = isPortrait
        ? math.min((maxLength * 13.sp) / 2 + 80.sp, 300.w)
        : math.min((maxLength * 13.sp) / 2 + 80.sp, 400.w);

    double minWidth = isPortrait ? 160.sp : 160.sp;
    return math.max(calculatedWidth, minWidth);
  }

  double _calculateWidthOfJobTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double maxLength = 0.0;

    if (displayedItems.isEmpty) {
      return isPortrait ? 120.w : 150.w;
    }

    for (final vision in displayedItems) {
      final displayName = _getJobTitleFromRequester(vision, locale);

      if (displayName.isNotEmpty &&
          displayName != 'null' &&
          displayName != '-') {
        maxLength = math.max(maxLength, displayName.length.toDouble());
      }
    }

    if (maxLength == 0) return isPortrait ? 120.w : 150.w;

    final base = (maxLength * 13.sp) / 2 + 50.sp;
    final cap = isPortrait ? 300.w : 400.w;
    final calculatedWidth = math.min(base, cap);

    double minWidth = isPortrait ? 100.sp : 120.sp;
    return math.max(calculatedWidth, minWidth);
  }

  double _calculateWidthOfRequesterDepartment(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double maxLength = 0.0;

    if (displayedItems.isEmpty) {
      return isPortrait ? 120.w : 150.w;
    }

    for (final vision in displayedItems) {
      final displayLabel = _getDepartmentFromRequester(vision, locale);

      if (displayLabel.isNotEmpty &&
          displayLabel != 'null' &&
          displayLabel != '-') {
        maxLength = math.max(maxLength, displayLabel.length.toDouble());
      }
    }

    if (maxLength == 0) return isPortrait ? 120.w : 150.w;

    final base = (maxLength * 13.sp) / 2 + 50.sp;
    final cap = isPortrait ? 300.w : 400.w;
    final calculatedWidth = math.min(base, cap);

    double minWidth = isPortrait ? 100.sp : 120.sp;
    return math.max(calculatedWidth, minWidth);
  }

  double _calculateWidthOfRequestDate(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double maxLength = 0.0;

    if (displayedItems.isEmpty) {
      return isPortrait ? 140.w : 180.w;
    }

    for (var vision in displayedItems) {
      if (vision["requestDate"] != null) {
        String dateText = formatDate(vision["requestDate"], locale);
        if (dateText.isNotEmpty && dateText != 'null') {
          maxLength = math.max(maxLength, dateText.length.toDouble());
        }
      }
    }

    if (maxLength == 0) return isPortrait ? 140.w : 180.w;

    double calculatedWidth = isPortrait
        ? math.min((maxLength * 13.sp) / 2 + 60.sp, 300.w)
        : math.min((maxLength * 13.sp) / 2 + 60.sp, 400.w);

    double minWidth = isPortrait ? 120.sp : 140.sp;
    return math.max(calculatedWidth, minWidth);
  }

  double _calculateWidthOfStatus(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double maxLength = 0.0;

    if (displayedItems.isEmpty) {
      return isPortrait ? 95.w : 120.w;
    }

    for (var vision in displayedItems) {
      if (vision["status"] != null) {
        String statusText =
        _getStatusDisplayText(vision["status"], locale, context);
        if (statusText.isNotEmpty && statusText != 'null') {
          maxLength = math.max(maxLength, statusText.length.toDouble());
        }
      }
    }

    if (maxLength == 0) return isPortrait ? 95.w : 120.w;

    double calculatedWidth = isPortrait
        ? math.min((maxLength * 13.sp) / 2 + 60.sp, 300.w)
        : math.min((maxLength * 13.sp) / 2 + 60.sp, 400.w);

    double minWidth = isPortrait ? 80.sp : 95.sp;
    return math.max(calculatedWidth, minWidth);
  }

  // ✅ UPDATED: Now uses _getProviderName helper
  double _calculateWidthOfServicesProvider(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double maxLength = 0.0;

    if (displayedItems.isEmpty) {
      return isPortrait ? 180.w : 220.w;
    }

    for (var vision in displayedItems) {
      final displayName = _getProviderName(vision, locale);

      if (displayName.isNotEmpty &&
          displayName != 'null' &&
          displayName != 'N/A') {
        maxLength = math.max(maxLength, displayName.length.toDouble());
      }
    }

    if (maxLength == 0) return isPortrait ? 180.w : 220.w;

    double calculatedWidth = isPortrait
        ? math.min((maxLength * 13.sp) / 2 + 60.sp, 300.w)
        : math.min((maxLength * 13.sp) / 2 + 60.sp, 400.w);

    double minWidth = isPortrait ? 160.sp : 180.sp;
    return math.max(calculatedWidth, minWidth);
  }

  Map<int, TableColumnWidth> _calculateColumnWidths(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final noWidth = 50.sp;
    final serviceNameWidth = _calculateWidthOfColumn(context);
    final requesterWidth = _calculateWidthOfRequester(context);
    final jobTitleWidth = _calculateWidthOfJobTitle(context);
    final requesterDepartmentWidth =
    _calculateWidthOfRequesterDepartment(context);
    final requestDateWidth = _calculateWidthOfRequestDate(context);
    final statusWidth = _calculateWidthOfStatus(context);
    final providerWidth = _calculateWidthOfServicesProvider(context);

    final totalWidth = noWidth +
        serviceNameWidth +
        requesterWidth +
        jobTitleWidth +
        requesterDepartmentWidth +
        requestDateWidth +
        statusWidth +
        providerWidth;

    if (totalWidth < screenWidth) {
      final extraSpace = screenWidth - totalWidth - 40.w;

      final flexibleTotal = serviceNameWidth +
          requesterWidth +
          jobTitleWidth +
          requesterDepartmentWidth +
          requestDateWidth +
          statusWidth +
          providerWidth;

      final serviceNameExtra =
          (serviceNameWidth / flexibleTotal) * extraSpace;
      final requesterExtra =
          (requesterWidth / flexibleTotal) * extraSpace;
      final jobTitleExtra =
          (jobTitleWidth / flexibleTotal) * extraSpace;
      final requesterDepartmentExtra =
          (requesterDepartmentWidth / flexibleTotal) * extraSpace;
      final requestDateExtra =
          (requestDateWidth / flexibleTotal) * extraSpace;
      final statusExtra = (statusWidth / flexibleTotal) * extraSpace;
      final providerExtra =
          (providerWidth / flexibleTotal) * extraSpace;

      return {
        0: FixedColumnWidth(noWidth),
        1: FixedColumnWidth(serviceNameWidth + serviceNameExtra),
        2: FixedColumnWidth(requesterWidth + requesterExtra),
        3: FixedColumnWidth(
            requesterDepartmentWidth + requesterDepartmentExtra),
        4: FixedColumnWidth(jobTitleWidth + jobTitleExtra),
        5: FixedColumnWidth(requestDateWidth + requestDateExtra),
        6: FixedColumnWidth(statusWidth + statusExtra),
        7: FixedColumnWidth(providerWidth + providerExtra),
      };
    }

    return {
      0: FixedColumnWidth(noWidth),
      1: FixedColumnWidth(serviceNameWidth),
      2: FixedColumnWidth(requesterWidth),
      3: FixedColumnWidth(requesterDepartmentWidth),
      4: FixedColumnWidth(jobTitleWidth),
      5: FixedColumnWidth(requestDateWidth),
      6: FixedColumnWidth(statusWidth),
      7: FixedColumnWidth(providerWidth),
    };
  }

  String _getStatusDisplayText(
      String status, String locale, BuildContext context) {
    final statusLower = status.toLowerCase();
    if (locale == 'ar') {
      switch (statusLower) {
        case "done":
        case "approved":
          return doneText;
        case "pending":
          return pendingText;
        case "inprogress":
        case "in progress":
          return inprogressText;
        case "branchsla":
        case "breached sla":
          return breachedSLAText;
        case "rejected":
          return rejectedText;
        case "cancel":
        case "canceled":
        case "cancelled":
          return canceledText;
        default:
          return statusLower.isNotEmpty ? statusLower : "-";
      }
    }
    // ✅ English display mapping
    switch (statusLower) {
      case "done":
        return "Done";
      case "approved":
        return "Approved";
      case "pending":
        return "Pending";
      case "inprogress":
      case "in progress":
        return "In Progress";
      case "branchsla":
      case "breached sla":
        return "Breached SLA";
      case "rejected":
        return "Rejected";
      case "cancel":
      case "canceled":
      case "cancelled":
        return "Canceled";
      default:
        return statusLower.isNotEmpty ? _capitalize(statusLower) : "-";
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Widget _tableHeaderCell(String text, Color? bgColor, Color? txtColor) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: txtColor ?? AppColors.white,
        ),
      ),
    );
  }

  Widget _tableCell(String text, BuildContext context, {Color? textColor}) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final defaultColor =
        this.textColor ?? (lightMode ? AppColors.black.withOpacity(0.87) : AppColors.white.withOpacity(0.70));

    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Text(
        _capitalize(text),
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: textColor ?? defaultColor,
        ),
      ),
    );
  }

  Widget _tableCellWithAvatar(
      String name, String? gender, BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final defaultColor =
        textColor ?? (lightMode ? AppColors.black.withOpacity(0.87) : AppColors.white.withOpacity(0.70));

    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipOval(
            child: SvgPicture.asset(
              gender == "male"
                  ? "assets/male.svg"
                  : "assets/female.svg",
              width: 25.sp,
              height: 25.sp,
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              _capitalize(name),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: defaultColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final locale = Localizations.localeOf(context).languageCode;

    final headerBgColor =
        headerBackgroundColor ?? (lightMode ? AppColors.black : AppColors.black.withOpacity(0.54));
    final headerTxtColor = headerTextColor ?? AppColors.white;
    final evenColor =
        evenRowColor ?? (lightMode ? AppColors.lightGrey! : AppColors.darkGrey!);
    final oddColor =
        oddRowColor ?? (lightMode ? AppColors.white : AppColors.black);

    final columnWidths = _calculateColumnWidths(context);

    // ✅ Sort items: oldest requestDate first (ascending)
    final sortedItems = _sortedByRequestDateAscending();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.sp),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          columnWidths: columnWidths,
          children: [
            TableRow(
              decoration: BoxDecoration(color: headerBgColor),
              children: [
                _tableHeaderCell(noText, headerBgColor, headerTxtColor),
                _tableHeaderCell(
                    serviceNameText, headerBgColor, headerTxtColor),
                _tableHeaderCell(
                    serviceRequestorText, headerBgColor, headerTxtColor),
                _tableHeaderCell(requesterDepartmentText, headerBgColor,
                    headerTxtColor),
                _tableHeaderCell(
                    jobTitleText, headerBgColor, headerTxtColor),
                _tableHeaderCell(
                    requestedDateText, headerBgColor, headerTxtColor),
                _tableHeaderCell(statusText, headerBgColor, headerTxtColor),
                _tableHeaderCell(
                    serviceProviderText, headerBgColor, headerTxtColor),
              ],
            ),
            // ✅ CHANGED: Uses sortedItems instead of displayedItems
            ...List.generate(sortedItems.length, (index) {
              final item = sortedItems[index];
              final isEven = index.isEven;
              final rowColor = isEven ? evenColor : oddColor;

              final serviceName = locale == 'ar'
                  ? item["serviceNameArabic"] ??
                  item["serviceName"] ??
                  ''
                  : item["serviceName"] ?? '';

              final requestorName = locale == 'ar'
                  ? item["requestorArabic"] ??
                  item["requestor"] ??
                  ''
                  : item["requestor"] ?? '';

              final jobTitle = _getJobTitleFromRequester(item, locale);
              final requesterDepartment =
              _getDepartmentFromRequester(item, locale);

              // ✅ FIXED: Use _getProviderName with full fallback chain
              final providerDisplayName = _getProviderName(item, locale);

              // ✅ FIXED: Use _getProviderGender with fallback
              final providerGender = _getProviderGender(item);

              final status =
              (item["status"] ?? '').toString().toLowerCase();
              final statusDisplayText =
              _getStatusDisplayText(status, locale, context);

              return TableRow(
                decoration: BoxDecoration(color: rowColor),
                children: [
                  _tableCell((index + 1).toString(), context),
                  _tableCell(serviceName, context),
                  _tableCellWithAvatar(
                      requestorName, item["gender"], context),
                  _tableCell(requesterDepartment, context),
                  _tableCell(jobTitle, context),
                  _tableCell(
                      formatDate(item["requestDate"], locale), context),
                  _tableCell(
                    statusDisplayText,
                    context,
                    textColor: getStatusColor(status, context),
                  ),
                  _tableCellWithAvatar(
                    providerDisplayName,
                    providerGender,
                    context,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}