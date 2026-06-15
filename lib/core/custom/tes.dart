import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/custom/1-custom_dropdwon.dart' hide AppColors;
import 'package:demo_app/core/custom/11_custom_confirm_diaolog.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/core/custom/2-custom_textfield.dart';
import 'package:demo_app/core/custom/8-custom_filter_app.dart';
import 'package:demo_app/core/custom/5-custom_button.dart';
import 'package:demo_app/core/custom/7_custom_button_with_icon.dart';
import 'package:demo_app/core/custom/6_custom_button_with_svg.dart';
import 'package:demo_app/core/custom/9_filter_tab_with_container.dart';
import 'package:demo_app/core/custom/16-custom_card_styles.dart';
import 'package:demo_app/core/custom/17-custom_service_summary_card.dart';
import 'package:demo_app/core/custom/18-custom_service_request_card.dart';
import 'package:demo_app/core/custom/19-custom_person_chip_card.dart';
import 'package:demo_app/core/custom/20-custom_personal_info_card.dart';
import 'package:demo_app/core/custom/21-custom_contact_card.dart';
import 'package:demo_app/core/custom/22-custom_product_warranty_card.dart';
import 'package:demo_app/core/custom/24-custom_chart_card.dart';
import 'package:demo_app/core/custom/25-custom_overall_stats_card.dart';
import 'package:demo_app/core/custom/26-custom_bar_chart_card.dart';
import 'package:demo_app/core/custom/27-custom_donut_chart_card.dart';
import 'package:demo_app/core/custom/28-custom_horizontal_bar_chart_card.dart';
import 'package:demo_app/core/custom/29-custom_grouped_bar_chart_card.dart';
import 'package:demo_app/core/custom/30-custom_attendance_tiles_card.dart';
import '../theme/app_colors.dart';


class DropdownDemoPage extends StatefulWidget {
  const DropdownDemoPage({super.key});

  @override
  State<DropdownDemoPage> createState() => _DropdownDemoPageState();
}

class _DropdownDemoPageState extends State<DropdownDemoPage> {
  // ── Dropdown state ────────────────────────────────────────────────────────
  String? _country;
  String? _city;
  String? _gender;
  String? _language;
  String? _status;
  String? _priority;
  String? _role;
  String? _currency;

  // ── TextField controllers ─────────────────────────────────────────────────
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();

  // ── Status chip filter ────────────────────────────────────────────────────
  String _selectedChip = 'all';

  // ── Chart tabs (Assets | Consumables) ────────────────────────────────────
  int _allocatedTab = 1;
  int _discrepancyTab = 1;

  // ── Segmented tabs ────────────────────────────────────────────────────────
  int _segTab1 = 0;
  int _segTab2 = 0;
  int _segTab3 = 0;

  bool _submitted = false;

  // ── Validation helpers ────────────────────────────────────────────────────
  String? _requiredError(String? val, String fieldName) {
    if (!_submitted) return null;
    if (val == null || val.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  String? get _emailError {
    if (!_submitted) return null;
    final v = _emailCtrl.text.trim();
    if (v.isEmpty) return 'Email is required';
    if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
    return null;
  }

  String? get _passwordError {
    if (!_submitted) return null;
    if (_passwordCtrl.text.isEmpty) return 'Password is required';
    if (_passwordCtrl.text.length < 8) return 'Min 8 characters';
    return null;
  }

  String? get _confirmError {
    if (!_submitted) return null;
    if (_confirmPasswordCtrl.text.isEmpty) return 'Please confirm your password';
    if (_confirmPasswordCtrl.text != _passwordCtrl.text) return 'Passwords do not match';
    return null;
  }

  void _submit() {
    setState(() => _submitted = true);
    final allDropdownsValid =
        _country != null && _city != null && _gender != null && _language != null;
    final allFieldsValid = _firstNameCtrl.text.trim().isNotEmpty &&
        _lastNameCtrl.text.trim().isNotEmpty &&
        _emailError == null &&
        _passwordError == null &&
        _confirmError == null;
    if (allDropdownsValid && allFieldsValid) {
      showSuccessDialog(
        context: context,
        title: 'Form Submitted',
        subtitle: 'Your form has been submitted successfully.',
        closeLabel: 'Close',
        onClose: () {},
      );
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _bioCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Component Demo'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE5E7EB)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ════════════════════════════════════════════════════════════════
              // SECTION: Figma Cards
              // ════════════════════════════════════════════════════════════════
              _sectionTitle('Figma Cards'),
              SizedBox(height: 12.h),

              // 1 — Service summary card
              ServiceSummaryCard(
                title: 'Market Research Service',
                infoRows: const [
                  CardInfo(label: 'Done Services:', value: '120'),
                  CardInfo(label: 'Total Hours:', value: '40'),
                ],
                footerLabel: 'Start Date:',
                footerValue: '28 Dec 2023',
                onTap: () {},
              ),
              SizedBox(height: 12.h),

              // 2 — Service request card
              ServiceRequestCard(
                title: 'Market Research Service',
                infoRows: [
                  CardInfo(
                      label: 'Service Provider:',
                      value: 'Ahmed Mohammed',
                      icon: CardSvg.icon(CardSvg.serviceProvider,
                          color: AppColors.secondaryText)),
                  CardInfo(
                      label: 'Job Title:',
                      value: 'Marketing Manager',
                      icon: CardSvg.icon(CardSvg.jobTitle,
                          color: AppColors.secondaryText)),
                  CardInfo(
                      label: 'Duration of Service:',
                      value: '1 Week',
                      icon: CardSvg.icon(CardSvg.duration,
                          color: AppColors.secondaryText)),
                  CardInfo(
                      label: 'Approval:',
                      value: 'Needs Approval',
                      icon: CardSvg.icon(CardSvg.approval,
                          color: AppColors.secondaryText)),
                ],
                buttonText: 'Request',
                onPressed: () {},
              ),
              SizedBox(height: 12.h),

              // 3 — Person chip card
              PersonChipCard(
                name: 'Amro Handousa',
                subtitle1: 'Marketing',
                subtitle2: 'Marketing Manager',
                isSelected: true,
                onTap: () {},
              ),
              SizedBox(height: 12.h),

              // 4 — Personal information card (Approve / Reject)
              PersonalInfoCard(
                rejectSvg: CardSvg.reject,
                approveSvg: CardSvg.approve,
                title: 'Personal Information',
                requestDateLabel: 'Request Date:',
                requestDate: '15 Oct 2024',
                requestedByName: 'Ahmed Wael',
                jobTitle: 'Marketing Manager',
                department: 'UI/UX Design',
                onReject: () {},
                onApprove: () {},
              ),
              SizedBox(height: 12.h),

              // 5 — Contact card (responsive: row on wide, stacked on mobile)
              ContactCard(
                name: 'Mona Mohammed',
                jobTitle: 'Technician',
                department: 'IT',
                email: 'Mona.Mohamed@GulfDev.com',
                phone: '+2010258963',
                onMessage: () {},
              ),
              SizedBox(height: 12.h),

              // 6 — Product warranty / attachment card
              ProductWarrantyCard(
                title: 'Product Warranty',
                fileName: 'Watermark.png',
                fileSize: '2.5 MB',
                date: '29 Dec 2023',
                onRemove: () {},
                onTapFile: () {},
              ),
              SizedBox(height: 32.h),

              // ════════════════════════════════════════════════════════════════
              // SECTION: Figma Charts
              // ════════════════════════════════════════════════════════════════
              _sectionTitle('Figma Charts'),
              SizedBox(height: 12.h),

              // 1 — Overall stats tiles
              OverallStatsCard(
                items: [
                  StatItem(label: 'Products', value: '11',
                      icon: CardSvg.icon(ChartSvg.products)),
                  StatItem(label: 'Orders', value: '11',
                      icon: CardSvg.icon(ChartSvg.orders)),
                  StatItem(label: 'Warehouses', value: '11',
                      icon: CardSvg.icon(ChartSvg.warehouse)),
                  StatItem(label: 'Low Stocks', value: '11',
                      icon: CardSvg.icon(ChartSvg.lowStock)),
                  StatItem(label: 'Suppliers', value: '11',
                      icon: CardSvg.icon(ChartSvg.supplier)),
                  StatItem(label: 'Requests', value: '11',
                      icon: CardSvg.icon(ChartSvg.request)),
                ],
              ),
              SizedBox(height: 12.h),

              // 2 — Stocks Overview (full width)
              BarChartCard(
                title: 'Stocks Overview',
                bars: [
                  ChartData(label: 'Product Categories', value: 220,
                      color: AppColors.orange),
                  ChartData(label: 'Product Categories', value: 410,
                      color: AppColors.green),
                  ChartData(label: 'Product Categories', value: 368,
                      color: AppColors.green),
                  ChartData(label: 'Product Categories', value: 280,
                      color: AppColors.orange),
                  ChartData(label: 'Product Categories', value: 40,
                      color: AppColors.red),
                  ChartData(label: 'Product Categories', value: 76,
                      color: AppColors.grey),
                  ChartData(label: 'Product Categories', value: 76,
                      color: AppColors.borderCard),
                  ChartData(label: 'Product Categories', value: 76,
                      color: AppColors.pending),
                  ChartData(label: 'Product Categories', value: 76,
                      color: AppColors.secondaryPrimary),
                  ChartData(label: 'Product Categories', value: 76,
                      color: AppColors.text),
                  ChartData(label: 'Product Categories', value: 76,
                      color: AppColors.text),
                  ChartData(label: 'Product Categories', value: 76,
                      color: AppColors.text),
                  ChartData(label: 'Product Categories', value: 76,
                      color: AppColors.text),
                  ChartData(label: 'Product Categories', value: 76,
                      color: AppColors.text),

                ],
              ),
              SizedBox(height: 12.h),

              // 3 & 4 — Demands + Order Fulfillment (two donuts per row)
              _pairRow(
                left: DonutChartCard(
                dotIcon: CardSvg.email,
                title: 'Demands',
                centerValue: '9K',
                centerLabel: 'Total Product',
                sections: [
                  ChartData(label: 'Assets', value: 513,
                      color: AppColors.primary),
                  ChartData(label: 'Consumables', value: 513,
                      color: AppColors.text),
                ],
              ),
                right: DonutChartCard(
                dotIcon: CardSvg.email,
                title: 'Order Fulfillment Status',
                centerValue: '9K',
                centerLabel: 'Total Orders',
                sections: [
                  ChartData(label: 'Received', value: 513,
                      color: AppColors.green),
                  ChartData(label: 'Received Partially', value: 513,
                      color: AppColors.orange),
                  ChartData(label: 'Cancelled', value: 513,
                      color: AppColors.red),
                  ChartData(label: 'Draft', value: 513,
                      color: AppColors.secondaryBlack),
                ],
              ),
              ),
              SizedBox(height: 12.h),

              // 5 — Inventory Valuation (full width)
              HorizontalBarChartCard(
                dotIcon: CardSvg.email,
                title: 'Inventory Valuation',
                maxX: 3000,
                bars: const [
                  ChartData(label: 'Quarter 1', value: 2620),
                  ChartData(label: 'Quarter 2', value: 1100),
                  ChartData(label: 'Quarter 3', value: 640),
                  ChartData(label: 'Quarter 4', value: 300),
                ],
              ),
              SizedBox(height: 12.h),

              // 6 — Product Consumption (full width)
              BarChartCard(
                dotIcon: CardSvg.email,
                title: 'Product Consumption',
                bars: const [
                  ChartData(label: 'Project', value: 228),
                  ChartData(label: 'Project', value: 410),
                ],
              ),
              SizedBox(height: 12.h),

              // 7 — Asset Condition & Lifecycle (full width)
              GroupedBarChartCard(
                dotIcon: CardSvg.email,
                title: 'Asset Condition & Lifecycle',
                series: [
                  ChartData(label: 'Excellent', value: 0,
                      color: AppColors.green),
                  ChartData(label: 'Good', value: 0,
                      color: AppColors.primary),
                  ChartData(label: 'Fair', value: 0,
                      color: AppColors.orange),
                  ChartData(label: 'Poor', value: 0,
                      color: AppColors.red),
                  ChartData(label: 'Unusable', value: 0,
                      color: AppColors.secondaryBlack),
                ],
                groups: const [
                  GroupedBarData(label: 'iPhone 18',
                      values: [410, 300, 150, 250, 90]),
                  GroupedBarData(label: 'iPhone 16',
                      values: [380, 260, 120, 210, 60]),
                  GroupedBarData(label: 'iPhone 16',
                      values: [300, 220, 100, 180, 40]),
                ],
              ),
              SizedBox(height: 12.h),

              // 8 — Products Allocated (full width)
              BarChartCard(
                title: 'Products Allocated',
                trailing: SizedBox(

                  child: CustomSegmentedTabs(
                    tabs: const ['Assets', 'Consumables'],
                    selectedIndex: _allocatedTab,
                    onTabSelected: (i) => setState(() => _allocatedTab = i),
                    containerColor: AppColors.background,
                    selectedColor: AppColors.primary,
                    unselectedColor: AppColors.background,
                    selectedTextColor: AppColors.textButton,
                    unselectedTextColor: AppColors.secondaryText,
                    spacing: 4.sp,
                  ),
                ),
                bars: const [
                  ChartData(label: 'Marketing', value: 320),
                  ChartData(label: 'HR', value: 410),
                  ChartData(label: 'Finance', value: 286),
                  ChartData(label: 'IT', value: 283),
                  ChartData(label: 'Accounting', value: 48),
                ],
              ),
              SizedBox(height: 12.h),

              // 9 — Products Discrepancy (full width)
              HorizontalBarChartCard(
                title: 'Products Discrepancy',
                trailing: SizedBox(
                  child: CustomSegmentedTabs(
                    tabs: const ['Assets', 'Consumables'],
                    selectedIndex: _discrepancyTab,
                    onTabSelected: (i) => setState(() => _discrepancyTab = i),
                    containerColor: AppColors.background,
                    selectedColor: AppColors.primary,
                    unselectedColor: AppColors.background,
                    selectedTextColor: AppColors.textButton,
                    unselectedTextColor: AppColors.secondaryText,
                    spacing: 4.sp,
                  ),
                ),
                maxX: 300,
                bars: [
                  const ChartData(label: 'Missing', value: 35),
                  ChartData(label: 'Damaged', value: 110,
                      color: AppColors.red),
                  const ChartData(label: 'Expired', value: 53),
                ],
              ),
              SizedBox(height: 12.h),

              // 10 — Attendance tiles (two items stacked per card -> 3 cards)
              AttendanceTilesCard(
                itemsPerCard: 2,
                items: [
                  AttendanceItem(label: 'Present', count: '03',
                      color: AppColors.green,
                      icon: CardSvg.icon(ChartSvg.present)),
                  AttendanceItem(label: 'Absent', count: '05',
                      color: AppColors.red,
                      icon: CardSvg.icon(ChartSvg.absent)),
                  AttendanceItem(label: 'Late', count: '01',
                      color: AppColors.orange,
                      icon: CardSvg.icon(ChartSvg.late)),
                  AttendanceItem(label: 'Vacation', count: '08',
                      color: AppColors.primary,
                      icon: CardSvg.icon(ChartSvg.vacation)),
                  AttendanceItem(label: 'Sick Leave', count: '01',
                      color: AppColors.blue,
                      icon: Icon(Icons.medical_services_outlined,
                          color: AppColors.blue)),
                  AttendanceItem(label: 'Excused', count: '08',
                      color: AppColors.secondaryBlack,
                      icon: CardSvg.icon(ChartSvg.excused)),
                ],
              ),
              SizedBox(height: 32.h),

              // ════════════════════════════════════════════════════════════════
              // SECTION: Status Chip Filter
              // ════════════════════════════════════════════════════════════════
              _sectionTitle('Status Chip Filter'),
              SizedBox(height: 12.h),
              StatusChipFilter(
                selectedKey: _selectedChip,
                onSelected: (key) => setState(() => _selectedChip = key),
                items: const [
                  StatusChipItem(key: 'all',      label: 'All',      count: 124),
                  StatusChipItem(key: 'active',   label: 'Active',   count: 54,  labelColor: Color(0xFF4BB609)),
                  StatusChipItem(key: 'pending',  label: 'Pending',  count: 30,  labelColor: Color(0xFFE5B800)),
                  StatusChipItem(key: 'inactive', label: 'Inactive', count: 20,  labelColor: Color(0xFFDF1C1C)),
                  StatusChipItem(key: 'banned',   label: 'Banned',   count: 20,  labelColor: Color(0xFF797979)),
                ],
              ),
              SizedBox(height: 32.h),

              // ════════════════════════════════════════════════════════════════
              // SECTION: Segmented Tabs
              // ════════════════════════════════════════════════════════════════
              _sectionTitle('Segmented Tabs'),
              SizedBox(height: 12.h),

              // Variant 1 — 2 tabs, default style
              CustomSegmentedTabs(
                tabs: const ['Chart', 'Table'],
                selectedIndex: _segTab1,
                unselectedTextColor: AppColors.secondaryText,
                onTabSelected: (i) => setState(() => _segTab1 = i),
              ),
              SizedBox(height: 12.h),

              // Variant 2 — 3 tabs, custom colors
              CustomSegmentedTabs(
                tabs: const ['Active', 'Completed', 'Archived'],
                selectedIndex: _segTab2,
                onTabSelected: (i) => setState(() => _segTab2 = i),
                selectedColor: AppColors.primary,
                unselectedColor: AppColors.card,
                selectedTextColor: AppColors.textButton,
                unselectedTextColor: AppColors.secondaryText,
                spacing: 6.sp,
              ),
              SizedBox(height: 12.h),

              // Variant 3 — equal width inside fixed container
              SizedBox(
                width: 260.w,
                height: 40.h,
                child: CustomSegmentedTabs(
                  tabs: const ['نشط', 'مكتمل'],
                  selectedIndex: _segTab3,
                  onTabSelected: (i) => setState(() => _segTab3 = i),
                  selectedColor: AppColors.primary,
                  unselectedColor: AppColors.field,
                  equalWidth: true,
                  spacing: 8.sp,
                  tabVerticalPadding: 8.sp,
                  tabHorizontalPadding: 12.sp,
                ),
              ),
              SizedBox(height: 32.h),

              // ════════════════════════════════════════════════════════════════
              // SECTION: Dialogs
              // ════════════════════════════════════════════════════════════════
              _sectionTitle('Dialogs'),
              SizedBox(height: 12.h),

              // Row 1 — Confirm + Success
              Row(
                children: [
                  Expanded(
                    child: customButtonWithIcon(
                      title: 'Confirm Dialog',
                      function: () => showConfirmDialog(
                        context: context,
                        title: 'Request To Cancellation',
                        subtitle: 'Are You Sure You Want to Cancel This Request?',
                        confirmLabel: 'Yes',
                        cancelLabel: 'No',
                        onConfirm: () => showSuccessDialog(
                          context: context,
                          title: 'Request Cancelled',
                          subtitle: 'Your request has been cancelled successfully.',
                          onClose: () {},
                        ),
                      ),
                      textStyle: AppTextStyles.font14BlackCairoRegular
                          .copyWith(color: AppColors.textButton),
                      width: double.infinity,
                      height: 44.h,
                      space: 8.w,
                      radius: 8.r,
                      color: AppColors.primary,
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: AppColors.textButton,
                      iconSize: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: customButtonWithIcon(
                      title: 'Success Dialog',
                      function: () => showSuccessDialog(
                        context: context,
                        title: 'Operation Successful',
                        subtitle: 'Your action has been completed successfully.',
                        closeLabel: 'Close',
                        onClose: () {},
                      ),
                      textStyle: AppTextStyles.font14BlackCairoRegular
                          .copyWith(color: AppColors.text),
                      width: double.infinity,
                      height: 44.h,
                      space: 8.w,
                      radius: 8.r,
                      color: AppColors.card,
                      icon: Icons.task_alt_rounded,
                      iconColor: const Color(0xFF43A047),
                      iconSize: 18.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Row 2 — Comment + Upload
              Row(
                children: [
                  Expanded(
                    child: customButtonWithIcon(
                      title: 'Comment Dialog',
                      function: () => showCommentDialog(
                        context: context,
                        title: 'Reason Of Cancellation',
                        fieldLabel: 'Justifications',
                        hint: 'Write your reason here...',
                        submitLabel: 'Submit',
                        onSubmit: (text) => showSuccessDialog(
                          context: context,
                          title: 'Comment Submitted',
                          subtitle: 'Your comment: "$text"',
                          onClose: () {},
                        ),
                      ),
                      textStyle: AppTextStyles.font14BlackCairoRegular
                          .copyWith(color: AppColors.textButton),
                      width: double.infinity,
                      height: 44.h,
                      space: 8.w,
                      radius: 8.r,
                      color: AppColors.primary,
                      icon: Icons.chat_bubble_outline_rounded,
                      iconColor: AppColors.textButton,
                      iconSize: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: customButtonWithIcon(
                      title: 'Upload Dialog',
                      function: () => showUploadDialog(
                        context: context,
                        dialogTitle: 'Adding Attachment',
                        titleFieldLabel: 'Title Name',
                        titleFieldHint: 'Enter file title...',
                        allowedExtensions: ['pdf', 'png', 'jpg', 'doc', 'docx'],
                        onSubmit: (file, titleName) {},
                      ),
                      textStyle: AppTextStyles.font14BlackCairoRegular
                          .copyWith(color: AppColors.text),
                      width: double.infinity,
                      height: 44.h,
                      space: 8.w,
                      radius: 8.r,
                      color: AppColors.card,
                      icon: Icons.upload_file_outlined,
                      iconColor: AppColors.primary,
                      iconSize: 18.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // ════════════════════════════════════════════════════════════════
              // SECTION: Buttons
              // ════════════════════════════════════════════════════════════════
              _sectionTitle('Buttons'),
              SizedBox(height: 12.h),

              // Row 1 — customButton variants
              Row(
                children: [
                  Expanded(
                    child: customButton(
                      title: 'Save',
                      height: 44.h,
                      function: () {},
                      color: AppColors.primary,
                      textStyle: AppTextStyles.font14BlackCairoRegular
                          .copyWith(color: AppColors.textButton),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: customButton(
                      title: 'Cancel',
                      height: 44.h,
                      function: () {},
                      color: AppColors.secondaryButton,
                      textStyle: AppTextStyles.font14BlackCairoRegular
                          .copyWith(color: AppColors.text),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: customButton(
                      title: 'Delete',
                      height: 44.h,
                      function: () {},
                      color: AppColors.red.withOpacity(0.1),
                      textStyle: AppTextStyles.font14BlackCairoRegular
                          .copyWith(color: AppColors.red),
                      borderColor: AppColors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Row 2 — customButtonWithIcon variants
              Row(
                children: [
                  Expanded(
                    child: customButtonWithIcon(
                      title: 'Add New',
                      function: () {},
                      textStyle: AppTextStyles.font14BlackCairoRegular
                          .copyWith(color: AppColors.textButton),
                      width: double.infinity,
                      height: 44.h,
                      space: 8.w,
                      radius: 8.r,
                      color: AppColors.primary,
                      icon: Icons.add,
                      iconColor: AppColors.textButton,
                      iconSize: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: customButtonWithIcon(
                      title: 'Filter',
                      function: () {},
                      textStyle: AppTextStyles.font14BlackCairoRegular
                          .copyWith(color: AppColors.text),
                      width: double.infinity,
                      height: 44.h,
                      space: 8.w,
                      radius: 8.r,
                      color: AppColors.card,
                      icon: Icons.tune_rounded,
                      iconColor: AppColors.text,
                      iconSize: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: customButtonWithIcon(
                      title: 'Export',
                      function: () {},
                      textStyle: AppTextStyles.font14BlackCairoRegular
                          .copyWith(color: AppColors.primary),
                      width: double.infinity,
                      height: 44.h,
                      space: 8.w,
                      radius: 8.r,
                      color: AppColors.primary.withOpacity(0.1),
                      icon: Icons.upload_outlined,
                      iconColor: AppColors.primary,
                      iconSize: 18.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Row 3 — customButtonWithSvg variants
              Row(
                children: [
                  Expanded(
                    child: customButtonWithSvg(
                      title: 'Delete',
                      function: () {},
                      textStyle: AppTextStyles.font14BlackCairoRegular
                          .copyWith(color: AppColors.red),
                      height: 44.h,
                      space: 8.w,
                      radius: 8.r,
                      color: AppColors.red.withOpacity(0.1),
                      image: 'assets/delete.svg',
                      widthImage: 18.sp,
                      heightImage: 18.sp,
                      colorBorder: AppColors.red,
                      svgColor: AppColors.red,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: customButtonWithSvg(
                      title: 'Import',
                      function: () {},
                      textStyle: AppTextStyles.font14BlackCairoRegular
                          .copyWith(color: AppColors.textButton),
                      height: 44.h,
                      space: 8.w,
                      radius: 8.r,
                      color: AppColors.primary,
                      image: 'assets/delete.svg',
                      widthImage: 18.sp,
                      heightImage: 18.sp,
                      colorBorder: Colors.transparent,
                      svgColor: AppColors.textButton,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  SizedBox(
                    width: 44.w,
                    child: customButtonWithSvg(
                      title: '',
                      function: () {},
                      textStyle: AppTextStyles.font14BlackCairoRegular,
                      height: 44.h,
                      space: 0,
                      radius: 8.r,
                      color: AppColors.red.withOpacity(0.1),
                      image: 'assets/delete.svg',
                      widthImage: 18.sp,
                      heightImage: 18.sp,
                      colorBorder: AppColors.red,
                      svgColor: AppColors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // ════════════════════════════════════════════════════════════════
              // SECTION: Basic
              // ════════════════════════════════════════════════════════════════
              _sectionTitle('Basic'),
              SizedBox(height: 12.h),

              _row(
                left: CustomDropdown<String>(
                  hint: 'Select status',
                  value: _status,
                  items: const [
                    DropdownItem(value: 'active',   label: 'Active'),
                    DropdownItem(value: 'inactive', label: 'Inactive'),
                    DropdownItem(value: 'pending',  label: 'Pending'),
                    DropdownItem(value: 'banned',   label: 'Banned'),
                  ],
                  onChanged: (v) => setState(() => _status = v),
                ),
                right: CustomTextField(
                  controller: _firstNameCtrl,
                  hint: 'First name',
                  prefixIcon: const Icon(Icons.person_outline,
                      size: 18, color: Color(0xFF9CA3AF)),
                  onChanged: (_) => setState(() {}),
                  errorText: _requiredError(_firstNameCtrl.text, 'First name'),
                ),
              ),
              SizedBox(height: 16.h),

              _row(
                left: CustomDropdown<String>(
                  label: 'Priority',
                  hint: 'Choose priority',
                  helperText: 'This affects task ordering.',
                  value: _priority,
                  items: const [
                    DropdownItem(value: 'low',      label: 'Low'),
                    DropdownItem(value: 'medium',   label: 'Medium'),
                    DropdownItem(value: 'high',     label: 'High'),
                    DropdownItem(value: 'critical', label: 'Critical'),
                  ],
                  onChanged: (v) => setState(() => _priority = v),
                ),
                right: CustomTextField(
                  controller: _lastNameCtrl,
                  label: 'Last Name',
                  hint: 'Enter last name',
                  helperText: 'As on your ID.',
                  onChanged: (_) => setState(() {}),
                  errorText: _requiredError(_lastNameCtrl.text, 'Last name'),
                ),
              ),
              SizedBox(height: 32.h),

              // ════════════════════════════════════════════════════════════════
              // SECTION: With Icons
              // ════════════════════════════════════════════════════════════════
              _sectionTitle('With Icons'),
              SizedBox(height: 12.h),

              _row(
                left: CustomDropdown<String>(
                  label: 'Gender',
                  hint: 'Select gender',
                  required: true,
                  prefixIcon: const Icon(Icons.person_outline,
                      size: 18, color: Color(0xFF9CA3AF)),
                  value: _gender,
                  errorText: _submitted && _gender == null
                      ? 'Please select a gender'
                      : null,
                  items: const [
                    DropdownItem(value: 'male',   label: 'Male',
                        leading: Icon(Icons.male,        size: 18, color: Color(0xFF3B82F6))),
                    DropdownItem(value: 'female', label: 'Female',
                        leading: Icon(Icons.female,      size: 18, color: Color(0xFFEC4899))),
                    DropdownItem(value: 'other',  label: 'Other',
                        leading: Icon(Icons.transgender, size: 18, color: Color(0xFF8B5CF6))),
                  ],
                  onChanged: (v) => setState(() => _gender = v),
                ),
                right: CustomTextField(
                  controller: _emailCtrl,
                  label: 'Email',
                  hint: 'example@mail.com',
                  required: true,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined,
                      size: 18, color: Color(0xFF9CA3AF)),
                  onChanged: (_) => setState(() {}),
                  errorText: _emailError,
                ),
              ),
              SizedBox(height: 16.h),

              _row(
                left: CustomDropdown<String>(
                  label: 'Language',
                  hint: 'Select language',
                  required: true,
                  prefixIcon: const Icon(Icons.language,
                      size: 18, color: Color(0xFF9CA3AF)),
                  value: _language,
                  errorText: _submitted && _language == null
                      ? 'Language is required'
                      : null,
                  items: const [
                    DropdownItem(value: 'en', label: 'English',
                        leading: Text('🇺🇸', style: TextStyle(fontSize: 16))),
                    DropdownItem(value: 'ar', label: 'Arabic',
                        leading: Text('🇸🇦', style: TextStyle(fontSize: 16))),
                    DropdownItem(value: 'fr', label: 'French',
                        leading: Text('🇫🇷', style: TextStyle(fontSize: 16))),
                    DropdownItem(value: 'de', label: 'German',
                        leading: Text('🇩🇪', style: TextStyle(fontSize: 16))),
                    DropdownItem(value: 'es', label: 'Spanish',
                        leading: Text('🇪🇸', style: TextStyle(fontSize: 16))),
                  ],
                  onChanged: (v) => setState(() => _language = v),
                ),
                right: CustomTextField(
                  controller: _phoneCtrl,
                  label: 'Phone',
                  hint: '05xxxxxxxx',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  prefixIcon: const Icon(Icons.phone_outlined,
                      size: 18, color: Color(0xFF9CA3AF)),
                ),
              ),
              SizedBox(height: 32.h),

              // ════════════════════════════════════════════════════════════════
              // SECTION: Validation
              // ════════════════════════════════════════════════════════════════
              _sectionTitle('Validation'),
              SizedBox(height: 12.h),

              _row(
                left: CustomDropdown<String>(
                  label: 'Country',
                  hint: 'Select your country',
                  required: true,
                  prefixIcon: const Icon(Icons.flag_outlined,
                      size: 18, color: Color(0xFF9CA3AF)),
                  value: _country,
                  errorText: _submitted && _country == null
                      ? 'Country is required'
                      : null,
                  items: const [
                    DropdownItem(value: 'eg', label: 'Egypt'),
                    DropdownItem(value: 'us', label: 'United States'),
                    DropdownItem(value: 'uk', label: 'United Kingdom'),
                    DropdownItem(value: 'fr', label: 'France'),
                    DropdownItem(value: 'sa', label: 'Saudi Arabia'),
                    DropdownItem(value: 'ae', label: 'UAE'),
                  ],
                  onChanged: (v) => setState(() {
                    _country = v;
                    _city = null;
                  }),
                ),
                right: CustomTextField(
                  controller: _passwordCtrl,
                  label: 'Password',
                  hint: 'Min 8 characters',
                  required: true,
                  obscureText: true,
                  onChanged: (_) => setState(() {}),
                  errorText: _passwordError,
                ),
              ),
              SizedBox(height: 16.h),

              _row(
                left: CustomDropdown<String>(
                  label: 'City',
                  hint: _country == null ? 'Select country first' : 'Select city',
                  required: true,
                  enabled: _country != null,
                  prefixIcon: const Icon(Icons.location_city_outlined,
                      size: 18, color: Color(0xFF9CA3AF)),
                  value: _city,
                  errorText: _submitted && _city == null && _country != null
                      ? 'City is required'
                      : null,
                  items: _citiesFor(_country),
                  onChanged: (v) => setState(() => _city = v),
                ),
                right: CustomTextField(
                  controller: _confirmPasswordCtrl,
                  label: 'Confirm Password',
                  hint: 'Re-enter password',
                  required: true,
                  obscureText: true,
                  onChanged: (_) => setState(() {}),
                  errorText: _confirmError,
                ),
              ),
              SizedBox(height: 32.h),

              // ════════════════════════════════════════════════════════════════
              // SECTION: More Variants
              // ════════════════════════════════════════════════════════════════
              _sectionTitle('More Variants'),
              SizedBox(height: 12.h),

              _row(
                left: CustomDropdown<String>(
                  label: 'Role',
                  hint: 'Assign a role',
                  helperText: 'Controls what the user can access.',
                  showDivider: true,
                  value: _role,
                  items: const [
                    DropdownItem(value: 'admin',  label: 'Admin',
                        trailing: Icon(Icons.shield_outlined,    size: 16, color: Color(0xFFDC2626))),
                    DropdownItem(value: 'editor', label: 'Editor',
                        trailing: Icon(Icons.edit_outlined,      size: 16, color: Color(0xFFF59E0B))),
                    DropdownItem(value: 'viewer', label: 'Viewer',
                        trailing: Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF10B981))),
                    DropdownItem(value: 'guest',  label: 'Guest', enabled: false,
                        trailing: Icon(Icons.lock_outline,       size: 16, color: Color(0xFF9CA3AF))),
                  ],
                  onChanged: (v) => setState(() => _role = v),
                ),
                right: CustomTextField(
                  controller: _websiteCtrl,
                  label: 'Website',
                  hint: 'https://example.com',
                  helperText: 'Your personal or company site.',
                  keyboardType: TextInputType.url,
                  prefixIcon: const Icon(Icons.link,
                      size: 18, color: Color(0xFF9CA3AF)),
                ),
              ),
              SizedBox(height: 16.h),

              _row(
                left: CustomDropdown<String>(
                  label: 'Currency',
                  hint: 'Select currency',
                  fillColor: const Color(0xFFEEF2FF),
                  itemHeight: 52,
                  value: _currency,
                  items: const [
                    DropdownItem(value: 'usd', label: 'USD — US Dollar',
                        leading: Text('💵', style: TextStyle(fontSize: 18))),
                    DropdownItem(value: 'eur', label: 'EUR — Euro',
                        leading: Text('💶', style: TextStyle(fontSize: 18))),
                    DropdownItem(value: 'gbp', label: 'GBP — British Pound',
                        leading: Text('💷', style: TextStyle(fontSize: 18))),
                    DropdownItem(value: 'egp', label: 'EGP — Egyptian Pound',
                        leading: Text('🪙', style: TextStyle(fontSize: 18))),
                  ],
                  onChanged: (v) => setState(() => _currency = v),
                ),
                right: CustomTextField(
                  controller: _bioCtrl,
                  label: 'Bio',
                  hint: 'Tell us about yourself…',
                  maxLines: 4,
                  minLines: 4,
                  maxLength: 200,
                  helperText: 'Short bio shown on your profile.',
                  fillColor: const Color(0xFFEEF2FF),
                ),
              ),
              SizedBox(height: 32.h),

              // ── Submit ──────────────────────────────────────────────────────
              customButton(
                title: 'Submit Form',
                function: _submit,
                width: double.infinity,
                height: 48.h,
                color: AppColors.primary,
                textStyle: AppTextStyles.font14BlackCairoRegular.copyWith(
                    color: AppColors.textButton, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 32.h),

              // ── Live state display ──────────────────────────────────────────
              _StateDisplay(
                status: _status,
                priority: _priority,
                gender: _gender,
                language: _language,
                country: _country,
                city: _city,
                role: _role,
                currency: _currency,
                firstName: _firstNameCtrl.text,
                lastName: _lastNameCtrl.text,
                email: _emailCtrl.text,
                phone: _phoneCtrl.text,
                website: _websiteCtrl.text,
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _row({required Widget left, required Widget right}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        SizedBox(width: 16.w),
        Expanded(child: right),
      ],
    );
  }

  /// Two cards side-by-side in one row, stretched to equal height.
  Widget _pairRow({required Widget left, Widget? right}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: left),
          SizedBox(width: 12.w),
          Expanded(child: right ?? const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Color(0xFF6B7280),
      letterSpacing: 0.8,
    ),
  );

  List<DropdownItem<String>> _citiesFor(String? country) {
    const map = {
      'eg': [
        DropdownItem(value: 'cairo', label: 'Cairo'),
        DropdownItem(value: 'alex',  label: 'Alexandria'),
        DropdownItem(value: 'giza',  label: 'Giza'),
      ],
      'us': [
        DropdownItem(value: 'nyc', label: 'New York'),
        DropdownItem(value: 'la',  label: 'Los Angeles'),
        DropdownItem(value: 'chi', label: 'Chicago'),
      ],
      'uk': [
        DropdownItem(value: 'lon', label: 'London'),
        DropdownItem(value: 'man', label: 'Manchester'),
        DropdownItem(value: 'bir', label: 'Birmingham'),
      ],
      'fr': [
        DropdownItem(value: 'par', label: 'Paris'),
        DropdownItem(value: 'lyo', label: 'Lyon'),
        DropdownItem(value: 'mar', label: 'Marseille'),
      ],
      'sa': [
        DropdownItem(value: 'riy', label: 'Riyadh'),
        DropdownItem(value: 'jed', label: 'Jeddah'),
        DropdownItem(value: 'dam', label: 'Dammam'),
      ],
      'ae': [
        DropdownItem(value: 'dxb', label: 'Dubai'),
        DropdownItem(value: 'auh', label: 'Abu Dhabi'),
        DropdownItem(value: 'shj', label: 'Sharjah'),
      ],
    };
    return (map[country] ?? []).cast<DropdownItem<String>>();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Live state card
// ─────────────────────────────────────────────────────────────────────────────

class _StateDisplay extends StatelessWidget {
  final String? status, priority, gender, language, country, city, role,
      currency, firstName, lastName, email, phone, website;

  const _StateDisplay({
    this.status, this.priority, this.gender, this.language,
    this.country, this.city, this.role, this.currency,
    this.firstName, this.lastName, this.email, this.phone, this.website,
  });

  @override
  Widget build(BuildContext context) {
    final entries = {
      'status':    status,
      'priority':  priority,
      'gender':    gender,
      'language':  language,
      'country':   country,
      'city':      city,
      'role':      role,
      'currency':  currency,
      'firstName': firstName,
      'lastName':  lastName,
      'email':     email,
      'phone':     phone,
      'website':   website,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected values',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 12),
          ...entries.entries.map(
                (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(e.key,
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF9CA3AF))),
                  ),
                  Expanded(
                    child: Text(
                      (e.value?.isNotEmpty == true) ? e.value! : '—',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: (e.value?.isNotEmpty == true)
                            ? AppColors.text
                            : const Color(0xFFD1D5DB),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
