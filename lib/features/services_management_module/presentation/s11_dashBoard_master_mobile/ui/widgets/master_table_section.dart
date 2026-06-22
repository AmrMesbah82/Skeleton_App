/// ******************* FILE INFO *******************
/// File Name: master_table_section.dart
/// Description: Table / Cards / Employee section for DashBoard Master
/// Created by: Amr Mesbah
/// *************************************************

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/format_helper.dart';
import 'package:demo_app/core/custom/32-custom_svg.dart';
import 'package:demo_app/features/department/presentation/controller/add_department_controller.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/controller/dashboard_master_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/controller/dashboard_master_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/employee_card.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/table_dashboard.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/theme/app_colors.dart';

class MasterTableSection extends StatelessWidget {
  final DashboardMasterState state;
  final DashboardMasterCubit cubit;
  final String locale;
  final bool isTabletLandscape;
  final String Function(dynamic rawDate, String locale) formatDate;
  final Color Function(String status, BuildContext context) getStatusColor;

  const MasterTableSection({
    super.key,
    required this.state,
    required this.cubit,
    required this.locale,
    required this.isTabletLandscape,
    required this.formatDate,
    required this.getStatusColor,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isPhone;

    if (state.showRequestedServices) {
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildServiceCardsMobile(context),
        );
      }
      return _buildServicesTable(context);
    }

    return EmployeeCardDashboard(
      filteredItems: state.filteredItems,
      enToArDepartments: state.enToArDepartments,
      getUniqueProviders: cubit.getUniqueProviderNames,
      calculateProviderStats: cubit.calculateProviderStats,
      servicesDoneText: S.of(context).ServicesDone,
      totalHoursText: S.of(context).TotalHours,
      breachedSLAText: S.of(context).BreachedSLA,
      isTabletLandscape: isTabletLandscape,
      breachedBorderColor: AppColors.red,
    );
  }

  Widget _buildServicesTable(BuildContext context) {
    return ServicesDataTable(
      displayedItems: state.displayedItems,
      enToArDepartments: state.enToArDepartments,
      formatDate: formatDate,
      getStatusColor: getStatusColor,
      noText: S.of(context).NO,
      serviceNameText: S.of(context).ServiceName,
      serviceRequestorText: S.of(context).ServiceRequestor,
      requestedDateText: S.of(context).RequestedDate,
      statusText: S.of(context).Status,
      serviceProviderText: S.of(context).ServiceProvider,
      doneText: S.of(context).Done,
      pendingText: S.of(context).Pending,
      inprogressText: S.of(context).Inprogress,
      breachedSLAText: S.of(context).BreachedSLA,
      rejectedText: S.of(context).Rejected,
      canceledText: S.of(context).Canceled,
      approvedText: S.of(context).Approved,
      jobTitleText: S.of(context).jobTitle,
      requesterDepartmentText: S.of(context).department,
    );
  }

  List<Widget> _buildServiceCardsMobile(BuildContext context) {
    return state.displayedItems.map((item) {
      return _ServiceCardMobile(
        item: item,
        locale: locale,
        formatDate: formatDate,
        getStatusColor: getStatusColor,
      );
    }).toList();
  }
}

class _ServiceCardMobile extends StatelessWidget {
  final Map<String, dynamic> item;
  final String locale;
  final String Function(dynamic rawDate, String locale) formatDate;
  final Color Function(String status, BuildContext context) getStatusColor;

  const _ServiceCardMobile({
    required this.item,
    required this.locale,
    required this.formatDate,
    required this.getStatusColor,
  });

  String _getProviderName(Map<String, dynamic> item, String locale) {

    final selectedProvider =
        item['selectedProvider'] as Map<String, dynamic>? ?? {};

    // ── 1️⃣ selectedProvider map (locale-matched) ──
    String providerName = locale == 'ar'
        ? '${selectedProvider['firstNameInArabic'] ?? ''} ${selectedProvider['lastNameInArabic'] ?? ''}'
        .trim()
        : '${selectedProvider['firstName'] ?? ''} ${selectedProvider['lastName'] ?? ''}'
        .trim();

    if (providerName.isNotEmpty && providerName != 'null') {
      return providerName;
    }

    // ── 2️⃣ selectedProvider map (cross-locale fallback) ──
    providerName = locale == 'ar'
        ? '${selectedProvider['firstName'] ?? ''} ${selectedProvider['lastName'] ?? ''}'
        .trim()
        : '${selectedProvider['firstNameInArabic'] ?? ''} ${selectedProvider['lastNameInArabic'] ?? ''}'
        .trim();

    if (providerName.isNotEmpty && providerName != 'null') {
      return providerName;
    }

    // ── 3️⃣ Direct keys on item map (all possible key variations) ──
    providerName = _tryProviderFromItemKeys(item, locale);
    if (providerName.isNotEmpty && providerName != 'null' && providerName != 'N/A') {
      return providerName;
    }

    // ── 4️⃣ Raw Firestore data from model ──
    final model = item['model'];
    if (model != null) {
      // Try model.selectedProvider map
      try {
        final modelSelectedProvider = model.selectedProvider;
        if (modelSelectedProvider != null && modelSelectedProvider is Map<String, dynamic>) {
          providerName = locale == 'ar'
              ? '${modelSelectedProvider['firstNameInArabic'] ?? modelSelectedProvider['firstName'] ?? ''} ${modelSelectedProvider['lastNameInArabic'] ?? modelSelectedProvider['lastName'] ?? ''}'
              .trim()
              : '${modelSelectedProvider['firstName'] ?? ''} ${modelSelectedProvider['lastName'] ?? ''}'
              .trim();

          if (providerName.isNotEmpty && providerName != 'null') {
            return providerName;
          }

          // Cross-locale
          providerName = locale == 'ar'
              ? '${modelSelectedProvider['firstName'] ?? ''} ${modelSelectedProvider['lastName'] ?? ''}'
              .trim()
              : '${modelSelectedProvider['firstNameInArabic'] ?? ''} ${modelSelectedProvider['lastNameInArabic'] ?? ''}'
              .trim();

          if (providerName.isNotEmpty && providerName != 'null') {
            return providerName;
          }
        }
      } catch (e) {
      }

      // ── 5️⃣ Try Provider_Services from raw Firestore doc ──
      try {
        final providerServices = model.currentProviderServices;
        if (providerServices != null) {
          if (providerServices is Map<String, dynamic>) {
            providerName = locale == 'ar'
                ? '${providerServices['firstNameInArabic'] ?? providerServices['firstName'] ?? ''} ${providerServices['lastNameInArabic'] ?? providerServices['lastName'] ?? ''}'
                .trim()
                : '${providerServices['firstName'] ?? ''} ${providerServices['lastName'] ?? ''}'
                .trim();

            if (providerName.isNotEmpty && providerName != 'null') {
              return providerName;
            }
          } else if (providerServices is List && providerServices.isNotEmpty) {
            final firstProvider = providerServices.first;
            if (firstProvider is Map<String, dynamic>) {
              providerName = locale == 'ar'
                  ? '${firstProvider['firstNameInArabic'] ?? firstProvider['firstName'] ?? ''} ${firstProvider['lastNameInArabic'] ?? firstProvider['lastName'] ?? ''}'
                  .trim()
                  : '${firstProvider['firstName'] ?? ''} ${firstProvider['lastName'] ?? ''}'
                  .trim();

              if (providerName.isNotEmpty && providerName != 'null') {
                return providerName;
              }
            }
          }
        }
      } catch (e) {
      }
    }

    // ── 6️⃣ Try Provider_Services from raw item map ──
    final providerServicesRaw = item['Provider_Services'] ?? item['providerServices'];
    if (providerServicesRaw != null) {
      providerName = _extractProviderFromRaw(providerServicesRaw, locale);
      if (providerName.isNotEmpty && providerName != 'null' && providerName != 'N/A') {
        return providerName;
      }
    }

    return 'N/A';
  }

  /// Helper: try all possible direct key variations on item map
  String _tryProviderFromItemKeys(Map<String, dynamic> item, String locale) {
    final keyPairs = [
      // locale-matched
      if (locale == 'ar') ...[
        ['providerFirstNameArabic', 'providerLastNameArabic'],
        ['providerFirstNameInArabic', 'providerLastNameInArabic'],
      ] else ...[
        ['providerFirstName', 'providerLastName'],
      ],
      // cross-locale fallback
      if (locale == 'ar') ...[
        ['providerFirstName', 'providerLastName'],
      ] else ...[
        ['providerFirstNameArabic', 'providerLastNameArabic'],
        ['providerFirstNameInArabic', 'providerLastNameInArabic'],
      ],
      // Firestore key format
      ['Provider_First_Name', 'Provider_Last_Name'],
      ['Provider_First_Name_Arabic', 'Provider_Last_Name_Arabic'],
    ];

    for (final pair in keyPairs) {
      final first = item[pair[0]]?.toString() ?? '';
      final last = item[pair[1]]?.toString() ?? '';
      final name = '$first $last'.trim();
      if (name.isNotEmpty && name != 'null') return name;
    }

    return '';
  }

  /// Helper: extract provider name from Provider_Services raw data
  String _extractProviderFromRaw(dynamic providerServicesRaw, String locale) {
    if (providerServicesRaw is Map<String, dynamic>) {
      final name = locale == 'ar'
          ? '${providerServicesRaw['firstNameInArabic'] ?? providerServicesRaw['firstName'] ?? ''} ${providerServicesRaw['lastNameInArabic'] ?? providerServicesRaw['lastName'] ?? ''}'
          .trim()
          : '${providerServicesRaw['firstName'] ?? ''} ${providerServicesRaw['lastName'] ?? ''}'
          .trim();
      if (name.isNotEmpty && name != 'null') return name;
    } else if (providerServicesRaw is List && providerServicesRaw.isNotEmpty) {
      final first = providerServicesRaw.first;
      if (first is Map<String, dynamic>) {
        final name = locale == 'ar'
            ? '${first['firstNameInArabic'] ?? first['firstName'] ?? ''} ${first['lastNameInArabic'] ?? first['lastName'] ?? ''}'
            .trim()
            : '${first['firstName'] ?? ''} ${first['lastName'] ?? ''}'.trim();
        if (name.isNotEmpty && name != 'null') return name;
      }
    }
    return '';
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ✅ Provider gender helper with full fallback chain
  // ══════════════════════════════════════════════════════════════════════════
  String _getProviderGender(Map<String, dynamic> item) {
    final selectedProvider =
        item['selectedProvider'] as Map<String, dynamic>? ?? {};
    final gender = selectedProvider['gender']?.toString() ?? '';
    if (gender.isNotEmpty && gender != 'null') return gender;

    // Fallback: direct key on item
    final directGender = item['providerGender']?.toString() ?? '';
    if (directGender.isNotEmpty && directGender != 'null') return directGender;

    // Fallback: model object
    final model = item['model'];
    if (model != null) {
      try {
        // Try model.selectedProvider
        final msp = model.selectedProvider;
        if (msp != null && msp is Map<String, dynamic>) {
          final mGender = msp['gender']?.toString() ?? '';
          if (mGender.isNotEmpty && mGender != 'null') return mGender;
        }
      } catch (_) {}
    }

    return 'male';
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ✅ Department helper with full fallback chain
  // ══════════════════════════════════════════════════════════════════════════
  String _getDepartment(Map<String, dynamic> item, String locale) {
    // 1️⃣ Direct 'department' key
    final dept = item['department']?.toString() ?? '';
    if (dept.isNotEmpty && dept != 'null') {
      return _getDepartmentDisplayName(dept, locale);
    }

    // 2️⃣ requesterData fallback
    final requesterData = item['requesterData'] as Map<String, dynamic>?;
    if (requesterData != null) {
      final deptValue = requesterData['department']?.toString() ?? '';
      if (deptValue.isNotEmpty && deptValue != 'null') {
        return _getDepartmentDisplayName(deptValue, locale);
      }
    }

    // 3️⃣ Model fallback
    final model = item['model'];
    if (model != null) {
      final deptValue = model.currentDepartmentRequester ?? '';
      if (deptValue.isNotEmpty) {
        return _getDepartmentDisplayName(deptValue, locale);
      }
    }

    return '-';
  }

  String _getDepartmentDisplayName(String departmentValue, String locale) {
    if (departmentValue.isEmpty) return '';

    // If it's a numeric department ID, resolve it
    if (int.tryParse(departmentValue) != null) {
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

    return departmentValue;
  }

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final model = item['model'] as ServicesHistoryModel;

    // ── Status ──
    final status = (item['status'] ?? '').toString().toLowerCase();
    final statusColor = getStatusColor(status, context);
    final localizedStatus = _localizeStatus(status, context);

    // ── Service Name ──
    final localizedServiceName = locale == 'ar'
        ? ((item['serviceNameArabic'] ?? '').toString().isNotEmpty
        ? item['serviceNameArabic'].toString()
        : (item['serviceName'] ?? '').toString())
        : ((item['serviceName'] ?? '').toString().isNotEmpty
        ? item['serviceName'].toString()
        : (item['serviceNameArabic'] ?? '').toString());

    // ── Requester Name ──
    final requesterName = locale == 'ar'
        ? (item['requestorArabic'] ?? item['requestor'] ?? '')
        .toString()
        .trim()
        : (item['requestor'] ?? '').toString().trim();

    // ── Provider Name ✅ FIXED: Full fallback chain ──
    final providerName = _getProviderName(item, locale);

    // ── Department ✅ FIXED: With department ID resolution ──
    final department = _getDepartment(item, locale);

    // ── Requested Date ──
    final requestedDate = formatDate(item['requestDate'], locale);

    // ── Gender for avatars ──
    final requesterGender = item['gender']?.toString() ?? 'male';
    final providerGender = _getProviderGender(item);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: lightMode
            ? AppColors.white
            : AppColors.chatBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: Service icon + name | Status ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service icon container
              Container(
                width: 36.sp,
                height: 36.sp,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: CustomSvg(
                    assetPath: "assets/images/headPhone.svg",
                    width: 15.w,
                    height: 15.h,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              // Service Name
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    localizedServiceName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font16BlackMediumCairo.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // Status
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomSvg(
                      assetPath: "assets/status.svg",
                      width: 14.sp,
                      height: 14.sp,
                      fit: BoxFit.scaleDown,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${S.of(context).status}: ',
                      style: AppTextStyles.font12BlackCairoRegular.copyWith(
                        color: lightMode
                            ? AppColors.secondaryText
                            : AppColors.grey,
                      ),
                    ),
                    Text(
                      localizedStatus,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // ── Row 2: Service Requester ──
          _buildInfoRow(
            context,
            svgAsset: "assets/person.svg",
            label: S.of(context).serviceRequester,
            value: requesterName.isNotEmpty ? requesterName : 'N/A',
            showAvatar: true,
            gender: requesterGender,
            lightMode: lightMode,
          ),

          SizedBox(height: 10.h),

          // ── Row 3: Department ──
          _buildInfoRow(
            context,
            svgAsset: "assets/svg/Case.svg",
            label: S.of(context).department,
            value: department.isNotEmpty ? department : 'N/A',
            showAvatar: false,
            lightMode: lightMode,
          ),

          SizedBox(height: 10.h),

          // ── Row 4: Service Provider ──
          _buildInfoRow(
            context,
            svgAsset: "assets/person.svg",
            label: S.of(context).ServiceProvider,
            value: providerName,
            showAvatar: providerName != 'N/A',
            gender: providerGender,
            lightMode: lightMode,
          ),

          SizedBox(height: 12.h),

          // ── Row 5: Requested Date (aligned to end) ──
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${S.of(context).RequestedDate}: ',
                style: AppTextStyles.font12BlackCairoRegular.copyWith(
                  color: lightMode
                      ? AppColors.secondaryText
                      : AppColors.grey,
                ),
              ),
              Text(
                requestedDate,
                style: AppTextStyles.font12BlackCairoRegular.copyWith(
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a labeled info row with optional avatar
  Widget _buildInfoRow(
      BuildContext context, {
        required String svgAsset,
        required String label,
        required String value,
        required bool lightMode,
        bool showAvatar = false,
        String gender = 'male',
      }) {
    return Row(
      children: [
        CustomSvg(
          assetPath: svgAsset,
          width: 16.sp,
          height: 16.sp,
          fit: BoxFit.scaleDown,
          color: AppColors.secondaryText,
        ),
        SizedBox(width: 6.w),
        Text(
          '$label: ',
          style: AppTextStyles.font12BlackCairoRegular.copyWith(
            color: lightMode
                ? AppColors.secondaryText
                : AppColors.grey,
          ),
        ),
        if (showAvatar) ...[
          SizedBox(width: 4.w),
          ClipOval(
            child: SvgPicture.asset(
              gender == 'female' ? 'assets/female.svg' : 'assets/male.svg',
              width: 22.sp,
              height: 22.sp,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 6.w),
        ],
        Expanded(
          child: Text(
            FormatHelper.capitalize(value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font12BlackMediumCairo.copyWith(
              color: lightMode
                  ? AppColors.blackButton
                  : AppColors.white,
            ),
          ),
        ),
      ],
    );
  }

  String _localizeStatus(String status, BuildContext context) {
    return switch (status) {
      'done' => S.of(context).Done,
      'pending' => S.of(context).Pending,
      'inprogress' => S.of(context).Inprogress,
      'branchsla' => S.of(context).BreachedSLA,
      'rejected' => S.of(context).Rejected,
      'canceled' || 'cancel' => S.of(context).Canceled,
      'approved' => S.of(context).Approved,
      _ => status,
    };
  }
}
