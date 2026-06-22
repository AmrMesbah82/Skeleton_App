/// ******************* FILE INFO *******************
/// File Name: master_action_bar.dart
/// Description: Search + Filter + Export bar for DashBoard Master
/// Created by: Amr Mesbah
/// *************************************************

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/core/custom/5-custom_button.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/controller/dashboard_master_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/controller/dashboard_master_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/export_widget.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/filter_dialog.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/helper/helper_function.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/6_custom_button_with_svg.dart';
import 'package:demo_app/core/custom/14-custom_filter_icon.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

class MasterActionBar extends StatelessWidget {
  final DashboardMasterState state;
  final DashboardMasterCubit cubit;
  final TextEditingController searchController;
  final String locale;
  final bool showExport;

  const MasterActionBar({
    super.key,
    required this.state,
    required this.cubit,
    required this.searchController,
    required this.locale,
    required this.showExport,
  });

  bool get _hasActiveFilter =>
      (state.activeDepartment?.isNotEmpty == true) ||
          (state.activeStatus?.isNotEmpty == true) ||
          state.activeDate != null;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isPhone;

    return Row(
      children: [
        // ── Search ──
        Expanded(
          child: AppSearchTextField(
            controller: searchController,
            onChanged: cubit.onSearchChanged,
          ),
        ),

        // ── Filter + Export: only on Requested Services tab ──
        if (showExport) ...[
          SizedBox(width: 10.sp),

          // ── Filter ──
          CustomFilterIcon(
            color: _hasActiveFilter ? AppColors.primary : AppColors.card,
            borderColor: Colors.transparent,
            svgColor: _hasActiveFilter
                ? AppColors.textButton
                : AppColors.secondaryText,
            title: isMobile ? '' : S.of(context).filter,
            textStyle: AppTextStyles.font16BlackMediumCairo
                .copyWith(color: AppColors.secondaryText),
            onTap: () async {
              final result = await FilterDialogDashBoard.show(
                context: context,
                currentDepartment: state.activeDepartment,
                currentStatus: state.activeStatus,
                currentDate: state.activeDate,
                departmentEnToAr: state.enToArDepartments,
                filterText: S.of(context).Filter,
                departmentText: S.of(context).department,
                requestDateText: S.of(context).requestDate,
                statusText: S.of(context).status,
                resetText: S.of(context).Reset,
                applyText: S.of(context).Apply,
                primaryColor: AppColors.primary,
              );
              if (result != null) {
                cubit.applyFilters(
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

          SizedBox(width: 10.sp),

          // ── Export ──
          customButtonWithSvg(
            color: AppColors.primary,
            width: !isMobile ? 100.w : 38.w,
            height: 38.h,
            svgColor: AppColors.textButton,
            space: isMobile ? 0.sp : 8.sp,
            title: isMobile ? '' : S.of(context).export,
            function: () async {
              final fileName = await FileNameDialog.show(
                context,
                exportText: S.of(context).export,
                fileNameText: S.of(context).fileName,
                textHereHint: S.of(context).Texthere,
                discardText: S.of(context).discard,
                downloadText: S.of(context).download,
                primaryColor: AppColors.primary,
                buttonTextColor: AppColors.textButton,
              );
              if (fileName != null && fileName.isNotEmpty) {
                final exporter = CSVExporter();
                await exporter.exportFilteredItemsToCSV(
                  context,
                  filteredItems: state.filteredItems,
                  fileName: fileName,
                  locale: locale,
                  enToArDepartments: state.enToArDepartments,
                  csvExportFunction: (rows, name) =>
                      CSVHelper().exportToCSV(rows, name),
                  doneText: S.of(context).Done,
                  pendingText: S.of(context).Pending,
                  inprogressText: S.of(context).Inprogress,
                  breachedSLAText: S.of(context).BreachedSLA,
                  rejectedText: S.of(context).Rejected,
                  canceledText: S.of(context).Canceled,
                  approvedText: S.of(context).Approved,
                );
              }
            },
            textStyle: AppTextStyles.font16BlackMediumCairo
                .copyWith(color: AppColors.textButton),
            image: 'assets/upload.svg',
            widthImage: 20.w,
            heightImage: 20.h,
            radius: 8.r,
            colorBorder: Colors.transparent,
          ),
        ],
      ],
    );
  }
}
