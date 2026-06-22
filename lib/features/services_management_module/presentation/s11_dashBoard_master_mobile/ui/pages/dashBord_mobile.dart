/// ******************* FILE INFO *******************
/// File Name: dash_board_master_mobile.dart
/// Description: Refactored DashBoard Master Mobile UI — uses Cubit + sub-widgets
/// Created by: Amr Mesbah
/// *************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/controller/dashboard_master_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/controller/dashboard_master_state.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/master_action_bar.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/master_charts_section.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/master_tab_bar.dart';
import 'package:demo_app/features/services_management_module/presentation/s11_dashBoard_master_mobile/ui/widgets/master_table_section.dart';
import 'package:demo_app/features/home/presentation/ui/pages/dashboard_view_data/chart_settings_dialog.dart';
import 'package:demo_app/generated/l10n.dart';


import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/widgets/services_management/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';

class DashBoardMasterMobile extends StatefulWidget {
  final String? header;
  final bool? isAdmin;
  final String? adminSelectedDepartment;

  const DashBoardMasterMobile({
    super.key,
    this.header,
    this.isAdmin,
    this.adminSelectedDepartment,
  });

  @override
  State<DashBoardMasterMobile> createState() => _DashBoardMasterMobileState();
}

class _DashBoardMasterMobileState extends State<DashBoardMasterMobile> {
  late final DashboardMasterCubit _cubit;
  final TextEditingController _searchController = TextEditingController();

  bool get _isAdmin => widget.isAdmin == true;

  @override
  void initState() {
    super.initState();
    _cubit = DashboardMasterCubit();
    _bootstrap();
  }

  @override
  void didUpdateWidget(DashBoardMasterMobile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isAdmin &&
        widget.adminSelectedDepartment != oldWidget.adminSelectedDepartment) {
      _bootstrap();
    }
  }

  void _bootstrap() {
    _cubit.bootstrap(
      isAdmin: _isAdmin,
      adminSelectedDepartment: widget.adminSelectedDepartment,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  // ── Chart settings icon ────────────────────────────────────────────────────


  // ── Helpers forwarded from old widget ─────────────────────────────────────

  bool _isTabletLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width >= 600 &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  String _formatDate(dynamic rawDate, String locale) {
    try {
      if (rawDate == null) return '-';
      DateTime date;
      if (rawDate is Timestamp) {
        date = rawDate.toDate();
      } else if (rawDate is DateTime) {
        date = rawDate;
      } else if (rawDate is String) {
        date = DateTime.tryParse(rawDate) ?? DateTime.now();
      } else {
        return '-';
      }
      final formatted = DateFormat('d MMM y', locale).format(date);
      final parts = formatted.split(' ');
      if (parts.length >= 2) {
        parts[1] = parts[1][0].toUpperCase() + parts[1].substring(1);
      }
      return parts.join(' ');
    } catch (_) {
      return '-';
    }
  }

  Color _getStatusColor(String status, BuildContext context) {
    final key = status.trim().toLowerCase().replaceAll('_', ' ');
    final map = <String, Color>{
      'done': const Color(0xFF1B5E20),
      'approved': AppColors.lightGreen,
      'inprogress': AppColors.yellow,
      'pending': AppColors.orange,
      'rejected': const Color(0xFFB71C1C),
      'breached sla': AppColors.red,
      'cancel': const Color(0xFFE53935),
      'canceled': const Color(0xFFE53935),
      'cancelled': const Color(0xFFE53935),
    };
    return map[key] ??
        (Theme.of(context).brightness == Brightness.light
            ? AppColors.mediumGrey
            : AppColors.lightGrey);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<DashboardMasterCubit, DashboardMasterState>(
        builder: (context, state) {
          if (!state.bootstrapped) return  CircleProgressMaster();

          return _isAdmin
              ? _buildAdminLayout(context, state)
              : _buildEmployeeLayout(context, state);
        },
      ),
    );
  }

  // ── Admin layout ───────────────────────────────────────────────────────────

  Widget _buildAdminLayout(BuildContext context, DashboardMasterState state) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            MasterChartsSection(
              state: state,
              cubit: _cubit,
              isAdmin: true,
              adminSelectedDepartment: widget.adminSelectedDepartment,
              isArabic: isArabic,
            ),
            SizedBox(height: 20.sp),
          ],
        ),
      ),
    );
  }

  // ── Employee layout ────────────────────────────────────────────────────────

  Widget _buildEmployeeLayout(BuildContext context, DashboardMasterState state) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final locale = Localizations.localeOf(context).languageCode;

    return SafeArea(
      child: SideFrameMasterServices(
        titleText: S.of(context).services,
        onFirstTap: () => navigateTo(context, LayoutScreenServices()),
        secondTitle: S.of(context).dashboard,
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15.sp),

                // ── Charts ──────────────────────────────────────────────────
                MasterChartsSection(
                  state: state,
                  cubit: _cubit,
                  isAdmin: false,
                  adminSelectedDepartment: widget.adminSelectedDepartment,
                  isArabic: isArabic,
                ),

                SizedBox(height: 20.sp),

                // ── Tab bar ─────────────────────────────────────────────────
                MasterTabBar(
                  state: state,
                  onToggle: () => _cubit.toggleTab(!state.showRequestedServices),
                ),

                SizedBox(height: 12.sp),

                // ── Search / Filter / Export ────────────────────────────────
                MasterActionBar(
                  state: state,
                  cubit: _cubit,
                  searchController: _searchController,
                  locale: locale,
                  showExport: state.showRequestedServices,
                ),

                SizedBox(height: 14.sp),

                // ── Table / Cards / Employee cards ──────────────────────────
                MasterTableSection(
                  state: state,
                  cubit: _cubit,
                  locale: locale,
                  isTabletLandscape: _isTabletLandscape(context),
                  formatDate: _formatDate,
                  getStatusColor: _getStatusColor,
                ),

                SizedBox(height: 20.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
