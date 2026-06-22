/// ******************* FILE INFO *******************
/// File Name: details_action_bar.dart
/// Description: Search + Filter + Export action bar for Dashboard Details
/// Created by: Amr Mesbah
/// *************************************************

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/controller/request_statistics_state.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/14-custom_filter_icon.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/filter_dialog.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/dashboard_admin_details_export_widget.dart';

class DetailsActionBar extends StatelessWidget {
  final DashboardDetailsState state;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterApplied;
  final Function({
  String? department,
  String? status,
  DateTime? date,
  bool clearDepartment,
  bool clearStatus,
  bool clearDate,
  }) onFilterResult;
  final String locale;
  final ServiceRequestExportHelper exportHelper;

  const DetailsActionBar({
    super.key,
    required this.state,
    required this.searchController,
    required this.onSearchChanged,
    required this.onFilterApplied,
    required this.onFilterResult,
    required this.locale,
    required this.exportHelper,
  });

  bool get _hasActiveFilter =>
      (state.activeDepartment?.isNotEmpty == true) ||
          (state.activeStatus?.isNotEmpty == true) ||
          state.activeDate != null;

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isMobile = context.isPhone;

    return Row(
      children: [
        // ── Search ─────────────────────────────────────────────────────────
        AppSearchTextField(
          controller: searchController,
          onChanged: onSearchChanged,
        ),

        SizedBox(width: 10.w),

        // ── Filter ─────────────────────────────────────────────────────────
        CustomFilterIcon(
          color: _hasActiveFilter ? AppColors.primary : AppColors.card,
          borderColor: Colors.transparent,
          svgColor: _hasActiveFilter
              ? AppColors.textButton
              : AppColors.secondaryText,
          title: S.of(context).Filter,
          textStyle: AppTextStyles.font16BlackRegularCairo
              .copyWith(color: AppColors.secondaryText),
          onTap: () async {
            final result = await ServiceRequestFilterDialog.show(
              context,
              state.filteredItems.map((item) {
                return ServicesHistoryModel.fromJson(
                  item['raw'] as Map<String, dynamic>,
                  item['docId'] as String,
                );
              }).toList(),
              currentDepartment: state.activeDepartment,
              currentStatus: state.activeStatus,
              currentDate: state.activeDate,
            );

            if (result != null) {
              onFilterResult(
                department: result['department'],
                status: result['status'],
                date: result['date'],
                clearDepartment: result['department'] == null,
                clearStatus: result['status'] == null,
                clearDate: result['date'] == null,
              );
            }
          },
        ),

        // ── Export (only on Requested Services tab) ─────────────────────────
        if (state.showRequestedServices) ...[
          SizedBox(width: 10.sp),
          GestureDetector(
            onTap: () async {
              final fileName = await exportHelper.showFileNameDialog(context);
              if (fileName != null && fileName.isNotEmpty) {
                await exportHelper.exportFilteredItemsToCSV(
                  context,
                  state.displayedItems,
                  fileName,
                  locale,
                  state.enToArDepartments,
                );
              }
            },
            child: Container(
              width: isMobile ? 38.w : 100.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: isMobile
                  ? Center(
                child: SvgPicture.asset(
                  'assets/upload.svg',
                  width: 20.sp,
                  height: 20.sp,
                  color: AppColors.textButton,
                  fit: BoxFit.scaleDown,
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/upload.svg',
                    width: 20.sp,
                    height: 20.sp,
                    color: AppColors.textButton,
                    fit: BoxFit.scaleDown,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    S.of(context).export,
                    style: AppTextStyles.font16BlackRegularCairo.copyWith(
                      color: AppColors.textButton,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
