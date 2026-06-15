// ─────────────────────────────────────────────────────────────────────────────
// Custom Components Gallery
//
// One section per file in lib/core/custom/: the file name is shown as a header,
// then that file's UI is rendered right below it. Open this page to browse every
// visual custom widget. (Pure helpers like 16-custom_card_styles, 32-custom_svg,
// 33-custom_haptic and the Firebase-backed 36-custom_comment_widget are noted but
// not rendered.)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/core/custom/1-custom_dropdwon.dart' hide AppColors;
import 'package:demo_app/core/custom/2-custom_textfield.dart';
import 'package:demo_app/core/custom/3-custom_dropdwon_calander.dart';
import 'package:demo_app/core/custom/4-custom_dropdwon_range_calander.dart';
import 'package:demo_app/core/custom/5-custom_button.dart';
import 'package:demo_app/core/custom/6_custom_button_with_svg.dart';
import 'package:demo_app/core/custom/7_custom_button_with_icon.dart';
import 'package:demo_app/core/custom/8-custom_filter_app.dart';
import 'package:demo_app/core/custom/9_filter_tab_with_container.dart';
import 'package:demo_app/core/custom/10_custom_upload_dialog.dart';
import 'package:demo_app/core/custom/11_custom_confirm_diaolog.dart' hide showUploadDialog;
import 'package:demo_app/core/custom/12-custom_delete_icon.dart';
import 'package:demo_app/core/custom/13-custom_edit_icon.dart';
import 'package:demo_app/core/custom/14-custom_filter_icon.dart';
import 'package:demo_app/core/custom/15-custom_sort_icon.dart';
import 'package:demo_app/core/custom/16-custom_card_styles.dart';
import 'package:demo_app/core/custom/17-custom_service_summary_card.dart';
import 'package:demo_app/core/custom/18-custom_service_request_card.dart';
import 'package:demo_app/core/custom/19-custom_person_chip_card.dart';
import 'package:demo_app/core/custom/20-custom_personal_info_card.dart';
import 'package:demo_app/core/custom/21-custom_contact_card.dart';
import 'package:demo_app/core/custom/22-custom_product_warranty_card.dart';
import 'package:demo_app/core/custom/23-custom_check_box.dart';
import 'package:demo_app/core/custom/24-custom_chart_card.dart';
import 'package:demo_app/core/custom/25-custom_overall_stats_card.dart';
import 'package:demo_app/core/custom/26-custom_bar_chart_card.dart';
import 'package:demo_app/core/custom/27-custom_donut_chart_card.dart';
import 'package:demo_app/core/custom/28-custom_horizontal_bar_chart_card.dart';
import 'package:demo_app/core/custom/29-custom_grouped_bar_chart_card.dart';
import 'package:demo_app/core/custom/30-custom_attendance_tiles_card.dart';
import 'package:demo_app/core/custom/31-custom_multi_select_dropdown.dart';
import 'package:demo_app/core/custom/34-custom_gridview_with_animation.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/core/custom/employee_card.dart';
import '../theme/app_colors.dart';

class CustomComponentsGalleryPage extends StatefulWidget {
  const CustomComponentsGalleryPage({super.key});

  @override
  State<CustomComponentsGalleryPage> createState() =>
      _CustomComponentsGalleryPageState();
}

class _CustomComponentsGalleryPageState
    extends State<CustomComponentsGalleryPage> {
  final _textCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  String? _status;
  DateTime? _date;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<String> _multi = [];
  int _segTab = 0;
  String _chip = 'all';
  bool _checked = true;
  bool _providerSelected = true;

  @override
  void dispose() {
    _textCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Custom Components — by file'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE5E7EB)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _file('1-custom_dropdwon.dart',
              CustomDropdown<String>(
                hint: 'Select status',
                value: _status,
                items: const [
                  DropdownItem(value: 'active', label: 'Active'),
                  DropdownItem(value: 'inactive', label: 'Inactive'),
                  DropdownItem(value: 'pending', label: 'Pending'),
                ],
                onChanged: (v) => setState(() => _status = v),
              ),
            ),

            _file('2-custom_textfield.dart',
              CustomTextField(
                controller: _textCtrl,
                label: 'Full name',
                hint: 'Enter your name',
                prefixIcon: const Icon(Icons.person_outline,
                    size: 18, color: Color(0xFF9CA3AF)),
              ),
            ),

            _file('3-custom_dropdwon_calander.dart',
              CustomDropdownCalendar(
                label: 'Date',
                hint: 'Select a date',
                value: _date,
                onChanged: (d) => setState(() => _date = d),
              ),
            ),

            _file('4-custom_dropdwon_range_calander.dart',
              CustomDropdownRangeCalendar(
                label: 'Date range',
                hint: 'Select a range',
                startDate: _rangeStart,
                endDate: _rangeEnd,
                onChanged: (s, e) => setState(() {
                  _rangeStart = s;
                  _rangeEnd = e;
                }),
              ),
            ),

            _file('5-custom_button.dart',
              Row(children: [
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
              ]),
            ),

            _file('6_custom_button_with_svg.dart',
              customButtonWithSvg(
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

            _file('7_custom_button_with_icon.dart',
              customButtonWithIcon(
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

            _file('8-custom_filter_app.dart',
              StatusChipFilter(
                selectedKey: _chip,
                onSelected: (k) => setState(() => _chip = k),
                items: const [
                  StatusChipItem(key: 'all', label: 'All', count: 124),
                  StatusChipItem(key: 'active', label: 'Active', count: 54,
                      labelColor: Color(0xFF4BB609)),
                  StatusChipItem(key: 'pending', label: 'Pending', count: 30,
                      labelColor: Color(0xFFE5B800)),
                  StatusChipItem(key: 'inactive', label: 'Inactive', count: 20,
                      labelColor: Color(0xFFDF1C1C)),
                ],
              ),
            ),

            _file('9_filter_tab_with_container.dart',
              CustomSegmentedTabs(
                tabs: const ['Chart', 'Table'],
                selectedIndex: _segTab,
                unselectedTextColor: AppColors.secondaryText,
                onTabSelected: (i) => setState(() => _segTab = i),
              ),
            ),

            _file('10_custom_upload_dialog.dart',
              customButtonWithIcon(
                title: 'Open Upload Dialog',
                function: () => showUploadDialog(
                  context: context,
                  dialogTitle: 'Adding Attachment',
                  titleFieldLabel: 'Title Name',
                  titleFieldHint: 'Enter file title...',
                  allowedExtensions: const ['pdf', 'png', 'jpg'],
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

            _file('11_custom_confirm_diaolog.dart',
              Row(children: [
                Expanded(
                  child: customButtonWithIcon(
                    title: 'Confirm',
                    function: () => showConfirmDialog(
                      context: context,
                      title: 'Request To Cancellation',
                      subtitle: 'Are you sure you want to cancel?',
                      confirmLabel: 'Yes',
                      cancelLabel: 'No',
                      onConfirm: () {},
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
                    title: 'Success',
                    function: () => showSuccessDialog(
                      context: context,
                      title: 'Operation Successful',
                      subtitle: 'Completed successfully.',
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
              ]),
            ),

            _file('12-15 — delete / edit / filter / sort icons',
              Row(children: [
                CustomDeleteIcon(onTap: () {}),
                SizedBox(width: 12.w),
                CustomEditIcon(onTap: () {}),
                SizedBox(width: 12.w),
                CustomFilterIcon(onTap: () {}),
                SizedBox(width: 12.w),
                CustomSortIcon(onTap: () {}),
              ]),
            ),

            _file('17-custom_service_summary_card.dart',
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
            ),

            _file('18-custom_service_request_card.dart',
              ServiceRequestCard(
                title: 'Market Research Service',
                infoRows: [
                  CardInfo(
                      label: 'Service Provider:',
                      value: 'Ahmed Mohammed',
                      icon: CardSvg.icon(CardSvg.serviceProvider,
                          color: AppColors.secondaryBlack)),
                  CardInfo(
                      label: 'Job Title:',
                      value: 'Marketing Manager',
                      icon: CardSvg.icon(CardSvg.jobTitle,
                          color: AppColors.secondaryBlack)),
                  CardInfo(
                      label: 'Approval:',
                      value: 'Needs Approval',
                      icon: CardSvg.icon(CardSvg.approval,
                          color: AppColors.secondaryBlack)),
                ],
                buttonText: 'Request',
                onPressed: () {},
              ),
            ),

            _file('19-custom_person_chip_card.dart',
              PersonChipCard(
                name: 'Amro Handousa',
                subtitle1: 'Marketing',
                subtitle2: 'Marketing Manager',
                isSelected: true,
                onTap: () {},
              ),
            ),

            _file('20-custom_personal_info_card.dart',
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
            ),

            _file('21-custom_contact_card.dart',
              ContactCard(
                name: 'Mona Mohammed',
                jobTitle: 'Technician',
                department: 'IT',
                email: 'Mona.Mohamed@GulfDev.com',
                phone: '+2010258963',
                onMessage: () {},
              ),
            ),

            _file('22-custom_product_warranty_card.dart',
              ProductWarrantyCard(
                title: 'Product Warranty',
                fileName: 'Watermark.png',
                fileSize: '2.5 MB',
                date: '29 Dec 2023',
                onRemove: () {},
                onTapFile: () {},
              ),
            ),

            _file('23-custom_check_box.dart',
              Row(children: [
                CustomCheckBox(isSelected: _checked),
                SizedBox(width: 16.w),
                CustomCheckBox(isSelected: false),
              ]),
            ),

            _file('24-custom_chart_card.dart',
              ChartCard(
                title: 'Chart Card (base container)',
                child: SizedBox(
                  height: 60.h,
                  child: Center(
                    child: Text('Any chart/content goes here',
                        style: CardStyles.label(12)),
                  ),
                ),
              ),
            ),

            _file('25-custom_overall_stats_card.dart',
              OverallStatsCard(
                items: [
                  StatItem(label: 'Products', value: '11',
                      icon: CardSvg.icon(ChartSvg.products)),
                  StatItem(label: 'Orders', value: '11',
                      icon: CardSvg.icon(ChartSvg.orders)),
                  StatItem(label: 'Warehouses', value: '11',
                      icon: CardSvg.icon(ChartSvg.warehouse)),
                  StatItem(label: 'Suppliers', value: '11',
                      icon: CardSvg.icon(ChartSvg.supplier)),
                ],
              ),
            ),

            _file('26-custom_bar_chart_card.dart',
              BarChartCard(
                title: 'Products Allocated',
                bars: const [
                  ChartData(label: 'Marketing', value: 320),
                  ChartData(label: 'HR', value: 410),
                  ChartData(label: 'Finance', value: 286),
                  ChartData(label: 'IT', value: 283),
                ],
              ),
            ),

            _file('27-custom_donut_chart_card.dart',
              DonutChartCard(
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
            ),

            _file('28-custom_horizontal_bar_chart_card.dart',
              HorizontalBarChartCard(
                dotIcon: CardSvg.email,
                title: 'Inventory Valuation',
                maxX: 3000,
                bars: const [
                  ChartData(label: 'Quarter 1', value: 2620),
                  ChartData(label: 'Quarter 2', value: 1100),
                  ChartData(label: 'Quarter 3', value: 640),
                ],
              ),
            ),

            _file('29-custom_grouped_bar_chart_card.dart',
              GroupedBarChartCard(
                dotIcon: CardSvg.email,
                title: 'Asset Condition & Lifecycle',
                series: [
                  ChartData(label: 'Excellent', value: 0, color: AppColors.green),
                  ChartData(label: 'Good', value: 0, color: AppColors.primary),
                  ChartData(label: 'Poor', value: 0, color: AppColors.red),
                ],
                groups: const [
                  GroupedBarData(label: 'iPhone 18', values: [410, 300, 250]),
                  GroupedBarData(label: 'iPhone 16', values: [380, 260, 210]),
                ],
              ),
            ),

            _file('30-custom_attendance_tiles_card.dart',
              AttendanceTilesCard(
                itemsPerCard: 2,
                items: [
                  AttendanceItem(label: 'Present', count: '03',
                      color: AppColors.green, icon: CardSvg.icon(ChartSvg.present)),
                  AttendanceItem(label: 'Absent', count: '05',
                      color: AppColors.red, icon: CardSvg.icon(ChartSvg.absent)),
                  AttendanceItem(label: 'Late', count: '01',
                      color: AppColors.orange, icon: CardSvg.icon(ChartSvg.late)),
                  AttendanceItem(label: 'Vacation', count: '08',
                      color: AppColors.primary, icon: CardSvg.icon(ChartSvg.vacation)),
                ],
              ),
            ),

            _file('31-custom_multi_select_dropdown.dart',
              CustomMultiSelectDropdown<String>(
                label: 'Departments',
                hint: 'Select departments',
                values: _multi,
                items: const [
                  MultiSelectDropdownItem(value: 'mkt', label: 'Marketing'),
                  MultiSelectDropdownItem(value: 'hr', label: 'HR'),
                  MultiSelectDropdownItem(value: 'fin', label: 'Finance'),
                  MultiSelectDropdownItem(value: 'it', label: 'IT'),
                ],
                onChanged: (v) => setState(() => _multi = v),
              ),
            ),

            _file('34-custom_gridview_with_animation.dart',
              AnimatedCustomGridView(
                itemCount: 6,
                crossAxisCount: 3,
                mainAxisExtent: 70.h,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Text('${index + 1}', style: CardStyles.title(16)),
                ),
              ),
            ),

            _file('35-custom_search_widget_custom.dart',
              Row(children: [
                AppSearchTextField(
                  controller: _searchCtrl,
                  hintText: 'Search...',
                  onChanged: (_) {},
                ),
              ]),
            ),

            _file('employee_card.dart',
              ProviderCard(
                name: 'Ahmed Mohammed',
                avatarAsset: 'assets/male.svg',
                subtitle1: 'Marketing',
                subtitle2: 'Marketing Manager',
                isSelected: _providerSelected,
                onTap: () => setState(() => _providerSelected = !_providerSelected),
              ),
            ),

            _note('36-custom_comment_widget.dart',
                'UniversalCommentSection is a Firebase-backed comment feed — it '
                'needs a live collection path & user, so it is not rendered here.'),
            _note('35-custom_date_pic.dart',
                'DatePicker is a utility that opens a date picker dialog (no '
                'standalone widget to render).'),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  // ── layout helpers ─────────────────────────────────────────────────────────

  /// File name header + the widget below it.
  Widget _file(String fileName, Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fileLabel(fileName),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }

  Widget _note(String fileName, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fileLabel(fileName),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(text,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF6B7280), height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _fileLabel(String fileName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        fileName,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
