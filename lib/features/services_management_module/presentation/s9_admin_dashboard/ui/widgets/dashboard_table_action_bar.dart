/// ******************* FILE INFO *******************
/// File Name: dashboard_table_action_bar.dart
/// Description: Search, Filter, and Export action bar for the dashboard table
/// Created by: Amr Mesbah

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/controller/admin_state.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/14-custom_filter_icon.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/export.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/dashboard_admin_export_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s9_admin_dashboard/ui/widgets/filter_table.dart';



class DashboardTableActionBar extends StatefulWidget {
  final DashboardAdminState state;

  const DashboardTableActionBar({super.key, required this.state});

  @override
  State<DashboardTableActionBar> createState() =>
      _DashboardTableActionBarState();
}

class _DashboardTableActionBarState extends State<DashboardTableActionBar> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _activeDepartments = [];
  List<String> _activeStatuses = [];
  DateTime? _activeDate;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters =>
      _activeDepartments.isNotEmpty ||
          _activeStatuses.isNotEmpty ||
          _activeDate != null;

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isMobile = context.isPhone;

    return Container(
      margin: EdgeInsets.only(bottom: 15.sp),
      child: Row(
        children: [
          // ── Search ──────────────────────────────────────────────────────
          AppSearchTextField(
            controller: _searchController,
            onChanged: (val) => setState(() {}),
          ),
          SizedBox(width: 10.sp),

          // ── Filter ──────────────────────────────────────────────────────
          CustomFilterIcon(
            color: _hasActiveFilters ? AppColors.primary : AppColors.card,
            borderColor: Colors.transparent,
            svgColor: _hasActiveFilters
                ? AppColors.textButton
                : (lightMode ? AppColors.secondaryText : AppColors.grey),
            title: S.of(context).Filter,
            textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
              color: _hasActiveFilters
                  ? AppColors.textButton
                  : (lightMode ? AppColors.secondaryText : AppColors.grey),
            ),
            onTap: () async {
              final result = await TableFilterDialog.show(
                context,
                activeDepartments: _activeDepartments,
                activeStatuses: _activeStatuses,
                activeDate: _activeDate,
              );
              if (result != null) {
                setState(() {
                  _activeDepartments =
                  List<String>.from(result['departments'] ?? []);
                  _activeStatuses =
                  List<String>.from(result['statuses'] ?? []);
                  _activeDate = result['date'];
                });
              }
            },
          ),
          SizedBox(width: 10.sp),

          // ── Export ──────────────────────────────────────────────────────
          GestureDetector(
            onTap: () async {
              final fileName = await ExportFileDialog.show(context);
              if (fileName != null && fileName.isNotEmpty) {
                await AdminExportService.exportRequestsToCSV(
                  context: context,
                  fileName: fileName,
                  displayedItems: widget.state.displayedItems,
                  selectStatus: widget.state.selectStatus,
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
              child: !isMobile
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/upload.svg",
                    width: 20.sp,
                    height: 20.sp,
                    color: AppColors.textButton,
                    fit: BoxFit.scaleDown,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    S.of(context).export,
                    style: AppTextStyles.font16BlackMediumCairo.copyWith(
                      color: AppColors.textButton,
                    ),
                  ),
                ],
              )
                  : Center(
                child: SvgPicture.asset(
                  "assets/upload.svg",
                  width: 20.sp,
                  height: 20.sp,
                  color: AppColors.textButton,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
