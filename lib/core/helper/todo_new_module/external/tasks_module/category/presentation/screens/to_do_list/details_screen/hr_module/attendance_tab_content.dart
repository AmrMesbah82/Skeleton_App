import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import '../../../../../../../../../knowledge_hub_module/core/custom_buttons.dart';
import 'package:demo_app/core/helper/todo_new_module/external/tasks_module/category/presentation/screens/to_do_list/details_screen/hr_module/HR_dashBoard_widget.dart';

class ResponsiveHelper {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1000;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= mobileMaxWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > mobileMaxWidth &&
          MediaQuery.of(context).size.width <= tabletMaxWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > tabletMaxWidth;
}

class AttendanceTabContent extends StatefulWidget {
  const AttendanceTabContent({super.key});

  @override
  State<AttendanceTabContent> createState() => _AttendanceTabContentState();
}

class _AttendanceTabContentState extends State<AttendanceTabContent> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLateHistoryCounts = true; // true = Counts, false = Minutes

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // OVERVIEW SECTION
        Text(
          'Overview',
          style: (isMobile
              ? AppTextStyles.font14BlackCairoMedium
              : AppTextStyles.font16BlackMediumCairo)
              .copyWith(
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 8.h),
        _buildOverviewSection(isMobile, isTablet),
        SizedBox(height: 24.h),

        // Time Filter Dropdown
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 10.w : 12.w,
                  vertical: isMobile ? 6.h : 8.h
              ),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Time',
                    style: (isMobile
                        ? AppTextStyles.font10BlackCairoRegular
                        : AppTextStyles.font12BlackCairoRegular)
                        .copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  SizedBox(width: isMobile ? 6.w : 8.w),
                  SvgPicture.asset(
                    'assets/arrowdown.svg',
                    width: isMobile ? 10.sp : 12.sp,
                    height: isMobile ? 10.sp : 12.sp,
                    colorFilter: ColorFilter.mode(
                      AppColors.secondaryText,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // REQUESTS PIE CHART
        CustomPieChartWithLabelsWidget(
          title: 'Requests',
          iconAsset: 'assets/hrAsset/hrRequests.svg',
          totalValue: '9K',
          totalLabel: 'Total',
          data: [
            ChartDataItem(
              label: 'Approved',
              color: Colors.green,
              value: 513,
            ),
            ChartDataItem(
              label: 'Pending',
              color: Colors.orange,
              value: 513,
            ),
            ChartDataItem(
              label: 'Rejected',
              color: Colors.red,
              value: 513,
            ),
            ChartDataItem(
              label: 'Canceled',
              color: Colors.red.shade900,
              value: 513,
            ),
          ],
          valueLabels: const ['513', '513', '513', '513'],
          lightMode: false,
          height: isMobile ? 220.h : 250.h,
        ),
        SizedBox(height: 15.h),

        // LATE HISTORY CHART
        CustomVerticalBarChartWidget(
          title: 'Late History',
          iconAsset: 'assets/hrAsset/hrLateHistory.svg',
          labels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          values: const [220, 410, 366, 282, 49, 79],
          height: isMobile ? 300 : 400,
          lightMode: false,
          showValuesOnBars: true,
          headerWidget: _buildToggleButton(
            isMobile,
            isTablet,
            'Counts',
            'Minutes',
            _isLateHistoryCounts,
                (value) => setState(() => _isLateHistoryCounts = value),
          ),
        ),
        SizedBox(height: 20.h),

        // ATTENDANCE HISTORY DETAILS
        Text(
          'Attendances History Details',
          style: (isMobile
              ? AppTextStyles.font16BlackMediumCairo
              : AppTextStyles.font18BlackMediumCairo)
              .copyWith(
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 8.h),

        // SEARCH, FILTER, EXPORT ROW - RESPONSIVE
        _buildSearchFilterExportRow(isMobile, isTablet),
        SizedBox(height: 15.h),

        // ATTENDANCE HISTORY DETAILS SECTION
        _buildAttendanceHistoryDetails(isMobile, isTablet),
      ],
    );
  }

  // OVERVIEW SECTION - RESPONSIVE
  Widget _buildOverviewSection(bool isMobile, bool isTablet) {
    if (isMobile) {
      // Mobile: 2x3 grid (2 columns, 3 rows)
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  isMobile: isMobile,
                  items: [
                    _buildOverviewItemData(
                      icon: 'assets/hrAsset/hrPresent.svg',
                      iconColor: Colors.green,
                      label: 'Present',
                      value: '03',
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildOverviewCard(
                  isMobile: isMobile,
                  items: [
                    _buildOverviewItemData(
                      icon: 'assets/hrAsset/hrabcent.svg',
                      iconColor: Colors.red,
                      label: 'Absent',
                      value: '05',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  isMobile: isMobile,
                  items: [
                    _buildOverviewItemData(
                      icon: 'assets/hrAsset/hrLate.svg',
                      iconColor: Colors.orange,
                      label: 'Late',
                      value: '01',
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildOverviewCard(
                  isMobile: isMobile,
                  items: [
                    _buildOverviewItemData(
                      icon: 'assets/hrAsset/hrVacation.svg',
                      iconColor: AppColors.primary,
                      label: 'Vacation',
                      value: '08',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  isMobile: isMobile,
                  items: [
                    _buildOverviewItemData(
                      icon: 'assets/hrAsset/hrSickLeave.svg',
                      iconColor: AppColors.primary,
                      label: 'Sick Leave',
                      value: '02',
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildOverviewCard(
                  isMobile: isMobile,
                  items: [
                    _buildOverviewItemData(
                      icon: 'assets/hrAsset/hrExcuseLeave.svg',
                      iconColor: Colors.grey,
                      label: 'Excuse Leave',
                      value: '06',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Tablet & Desktop: 3 columns
    return Row(
      children: [
        // First Column (Present, Absent)
        Expanded(
          child: _buildOverviewCard(
            isMobile: isMobile,
            items: [
              _buildOverviewItemData(
                icon: 'assets/hrAsset/hrPresent.svg',
                iconColor: Colors.green,
                label: 'Present',
                value: '03',
              ),
              _buildOverviewItemData(
                icon: 'assets/hrAsset/hrabcent.svg',
                iconColor: Colors.red,
                label: 'Absent',
                value: '05',
              ),
            ],
          ),
        ),
        SizedBox(width: 15.w),

        // Second Column (Late, Vacation)
        Expanded(
          child: _buildOverviewCard(
            isMobile: isMobile,
            items: [
              _buildOverviewItemData(
                icon: 'assets/hrAsset/hrLate.svg',
                iconColor: Colors.orange,
                label: 'Late',
                value: '01',
              ),
              _buildOverviewItemData(
                icon: 'assets/hrAsset/hrVacation.svg',
                iconColor: AppColors.primary,
                label: 'Vacation',
                value: '08',
              ),
            ],
          ),
        ),
        SizedBox(width: 15.w),

        // Third Column (Sick Leave, Excuse Leave)
        Expanded(
          child: _buildOverviewCard(
            isMobile: isMobile,
            items: [
              _buildOverviewItemData(
                icon: 'assets/hrAsset/hrSickLeave.svg',
                iconColor: AppColors.primary,
                label: 'Sick Leave',
                value: '02',
              ),
              _buildOverviewItemData(
                icon: 'assets/hrAsset/hrExcuseLeave.svg',
                iconColor: Colors.grey,
                label: 'Excuse Leave',
                value: '06',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper to create overview item data
  Map<String, dynamic> _buildOverviewItemData({
    required String icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return {
      'icon': icon,
      'iconColor': iconColor,
      'label': label,
      'value': value,
    };
  }

  // Overview card container
  Widget _buildOverviewCard({
    required bool isMobile,
    required List<Map<String, dynamic>> items,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12.sp : 16.sp),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              if (index > 0) SizedBox(height: isMobile ? 12.h : 16.h),
              _buildOverviewItem(
                icon: item['icon'],
                iconColor: item['iconColor'],
                label: item['label'],
                value: item['value'],
                isMobile: isMobile,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOverviewItem({
    required String icon,
    required Color iconColor,
    required String label,
    required String value,
    required bool isMobile,
  }) {
    return Row(
      children: [
        Container(
          width: isMobile ? 35.sp : 40.sp,
          height: isMobile ? 35.sp : 40.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor,
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: isMobile ? 20.sp : 24.sp,
              height: isMobile ? 20.sp : 24.sp,
              color: AppColors.textButton,
            ),
          ),
        ),
        SizedBox(width: isMobile ? 8.w : 12.w),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: (isMobile
                      ? AppTextStyles.font13SecondaryBlackCairo
                      : AppTextStyles.font16BlackMediumCairo)
                      .copyWith(
                    color: AppColors.secondaryText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                value,
                style: (isMobile
                    ? AppTextStyles.font18BlackMediumCairo
                    : AppTextStyles.font22BlackCairoSemiBold)
                    .copyWith(
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // TOGGLE BUTTON WIDGET - RESPONSIVE
  Widget _buildToggleButton(
      bool isMobile,
      bool isTablet,
      String option1,
      String option2,
      bool isOption1Selected,
      Function(bool) onChanged,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: isMobile ? 32.h : 36.h,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Option 1 Button
              GestureDetector(
                onTap: () => onChanged(true),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12.w : 16.w,
                      vertical: isMobile ? 6.h : 8.h
                  ),
                  decoration: BoxDecoration(
                    color: isOption1Selected
                        ? AppColors.secondaryPrimary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    option1,
                    style: (isMobile
                        ? AppTextStyles.font12BlackCairoRegular
                        : AppTextStyles.font14BlackCairoRegular)
                        .copyWith(
                      color: isOption1Selected
                          ? AppColors.textButton
                          : AppColors.text,
                    ),
                  ),
                ),
              ),
              // Option 2 Button
              GestureDetector(
                onTap: () => onChanged(false),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12.w : 16.w,
                      vertical: isMobile ? 6.h : 8.h
                  ),
                  decoration: BoxDecoration(
                    color: !isOption1Selected
                        ? AppColors.secondaryPrimary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    option2,
                    style: (isMobile
                        ? AppTextStyles.font12BlackCairoRegular
                        : AppTextStyles.font14BlackCairoRegular)
                        .copyWith(
                      color: !isOption1Selected
                          ? AppColors.textButton
                          : AppColors.text,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // SEARCH, FILTER, EXPORT ROW - RESPONSIVE
  Widget _buildSearchFilterExportRow(bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(
        children: [
          // Search Field
          SizedBox(
            width: double.infinity,
            child: AppSearchTextField(
              controller: _searchController,
              onChanged: (value) {
                // Handle search
              },
              fillColor: AppColors.card,
            ),
          ),
          SizedBox(height: 10.h),
          // Filter & Export Buttons
          Row(
            children: [
              Expanded(
                child: customButtonWithImage(
                  title: 'Filter',
                  function: () {},
                  textStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                  width: double.infinity,
                  height: 35.h,
                  space: 6.w,
                  radius: 4.r,
                  color: AppColors.card,
                  image: 'assets/hrAsset/filter.svg',
                  widthImage: 18.sp,
                  heightImage: 18.sp,
                  colorBorder: Colors.transparent,
                  svgColor: AppColors.secondaryText,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: customButtonWithImage(
                  title: 'Export',
                  function: () {},
                  textStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color: AppColors.textButton,
                  ),
                  width: double.infinity,
                  height: 35.h,
                  space: 6.w,
                  radius: 4.r,
                  color: AppColors.primary,
                  image: 'assets/hrAsset/hrExport.svg',
                  widthImage: 18.sp,
                  heightImage: 18.sp,
                  colorBorder: Colors.transparent,
                  svgColor: AppColors.textButton,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Tablet & Desktop
    return Row(
      children: [
        // Search Field
        Expanded(
          flex: isTablet ? 2 : 3,
          child: AppSearchTextField(
            controller: _searchController,
            onChanged: (value) {
              // Handle search
            },
            fillColor: AppColors.card,
          ),
        ),
        SizedBox(width: 15.w),

        // Filter Button
        customButtonWithImage(
          title: 'Filter',
          function: () {},
          textStyle: (isTablet
              ? AppTextStyles.font16BlackMediumCairo
              : AppTextStyles.font18BlackMediumCairo)
              .copyWith(
            color: AppColors.secondaryText,
          ),
          width: isTablet ? 80.w : 90.w,
          height: isTablet ? 35.h : 38.h,
          space: 8.w,
          radius: 4.r,
          color: AppColors.card,
          image: 'assets/hrAsset/filter.svg',
          widthImage: 20.sp,
          heightImage: 20.sp,
          colorBorder: Colors.transparent,
          svgColor: AppColors.secondaryText,
        ),
        SizedBox(width: 15.w),

        // Export Button
        customButtonWithImage(
          title: 'Export',
          function: () {},
          textStyle: (isTablet
              ? AppTextStyles.font16BlackMediumCairo
              : AppTextStyles.font18BlackMediumCairo)
              .copyWith(
            color: AppColors.textButton,
          ),
          width: isTablet ? 90.w : 100.w,
          height: isTablet ? 35.h : 38.h,
          space: 8.w,
          radius: 4.r,
          color: AppColors.primary,
          image: 'assets/hrAsset/hrExport.svg',
          widthImage: 20.sp,
          heightImage: 20.sp,
          colorBorder: Colors.transparent,
          svgColor: AppColors.textButton,
        ),
      ],
    );
  }

  Widget _buildAttendanceHistoryDetails(bool isMobile, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAttendanceHistoryTable(isMobile, isTablet),
        ],
      ),
    );
  }

  Widget _buildAttendanceHistoryTable(bool isMobile, bool isTablet) {
    final attendances = [
      {
        'no': '1',
        'date': '26 Feb 2022',
        'status': 'Present',
        'statusColor': Colors.green,
        'oncoming': '09:00 AM',
        'leaving': '05:00 AM',
        'break': '30 Mins',
        'total': '7:30 Hrs',
      },
      {
        'no': '2',
        'date': '25 Feb 2022',
        'status': 'Absent',
        'statusColor': Colors.red,
        'oncoming': '-',
        'leaving': '-',
        'break': '-',
        'total': '-',
      },
      {
        'no': '3',
        'date': '24 Feb 2022',
        'status': 'Present',
        'statusColor': Colors.green,
        'oncoming': '09:00 AM',
        'leaving': '05:00 AM',
        'break': '30 Mins',
        'total': '7:30 Hrs',
      },
      {
        'no': '4',
        'date': '23 Feb 2022',
        'status': 'Absent',
        'statusColor': Colors.red,
        'oncoming': '-',
        'leaving': '-',
        'break': '-',
        'total': '-',
      },
      {
        'no': '5',
        'date': '22 Feb 2022',
        'status': 'Present',
        'statusColor': Colors.green,
        'oncoming': '09:00 AM',
        'leaving': '05:00 AM',
        'break': '30 Mins',
        'total': '7:30 Hrs',
      },
      {
        'no': '6',
        'date': '21 Feb 2022',
        'status': 'Excused',
        'statusColor': Colors.grey,
        'oncoming': '09:00 AM',
        'leaving': '01:00 AM',
        'break': '-',
        'total': '2:30 Hrs',
      },
      {
        'no': '7',
        'date': '20 Feb 2022',
        'status': 'Vacation',
        'statusColor': AppColors.primary,
        'oncoming': '-',
        'leaving': '-',
        'break': '-',
        'total': '-',
      },
      {
        'no': '8',
        'date': '19 Feb 2022',
        'status': 'Sick Leave',
        'statusColor': Colors.red.shade300,
        'oncoming': '-',
        'leaving': '-',
        'break': '-',
        'total': '-',
      },
      {
        'no': '9',
        'date': '18 Feb 2022',
        'status': 'Sick Leave',
        'statusColor': Colors.red.shade300,
        'oncoming': '-',
        'leaving': '-',
        'break': '-',
        'total': '-',
      },
      {
        'no': '10',
        'date': '17 Feb 2022',
        'status': 'Sick Leave',
        'statusColor': Colors.red.shade300,
        'oncoming': '-',
        'leaving': '-',
        'break': '-',
        'total': '-',
      },
    ];

    if (isMobile) {
      // Mobile: Card-based layout
      return Column(
        children: attendances.map((attendance) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'NO: ${attendance['no']}',
                      style: AppTextStyles.font12SecondaryBlackCairoMedium.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      attendance['status'].toString(),
                      style: AppTextStyles.font12SecondaryBlackCairoMedium.copyWith(
                        color: attendance['statusColor'] as Color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildMobileAttendanceRow('Date', attendance['date'].toString()),
                _buildMobileAttendanceRow('Oncoming', attendance['oncoming'].toString()),
                _buildMobileAttendanceRow('Leaving', attendance['leaving'].toString()),
                _buildMobileAttendanceRow('Break', attendance['break'].toString()),
                _buildMobileAttendanceRow('Total', attendance['total'].toString()),
              ],
            ),
          );
        }).toList(),
      );
    }

    // Tablet & Desktop: Table layout
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 12.w : 16.w,
                vertical: isTablet ? 10.h : 12.h
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Row(
              children: [
                _buildTableHeaderCell('No', isTablet ? 50.w : 60.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Attendance Date', isTablet ? 130.w : 150.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Status', isTablet ? 100.w : 120.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Oncoming Time', isTablet ? 130.w : 150.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Leaving Time', isTablet ? 130.w : 150.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Break Time', isTablet ? 100.w : 120.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Total Time', isTablet ? 100.w : 120.w, isTablet),
              ],
            ),
          ),

          // Table Rows
          ...attendances.asMap().entries.map((entry) {
            final index = entry.key;
            final attendance = entry.value;
            return _buildTableRow(attendance, index, isTablet);
          }),
        ],
      ),
    );
  }

  Widget _buildMobileAttendanceRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTextStyles.font12BlackCairoRegular.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.font12BlackCairoRegular.copyWith(
                color: AppColors.text,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text, double width, bool isTablet) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: (isTablet
            ? AppTextStyles.font12SecondaryBlackCairoMedium
            : AppTextStyles.font14BlackSemiBoldCairo)
            .copyWith(
          color: AppColors.text,
        ),
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> attendance, int index, bool isTablet) {
    final backgroundColor = index % 2 == 0 ? AppColors.background : AppColors.card;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 12.w : 16.w,
          vertical: isTablet ? 12.h : 16.h
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Row(
        children: [
          // NO
          SizedBox(
            width: isTablet ? 50.w : 60.w,
            child: Text(
              attendance['no'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Date
          SizedBox(
            width: isTablet ? 130.w : 150.w,
            child: Text(
              attendance['date'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Status
          SizedBox(
            width: isTablet ? 100.w : 120.w,
            child: Text(
              attendance['status'],
              style: (isTablet
                  ? AppTextStyles.font12SecondaryBlackCairoMedium
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: attendance['statusColor'],
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Oncoming Time
          SizedBox(
            width: isTablet ? 130.w : 150.w,
            child: Text(
              attendance['oncoming'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Leaving Time
          SizedBox(
            width: isTablet ? 130.w : 150.w,
            child: Text(
              attendance['leaving'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Break Time
          SizedBox(
            width: isTablet ? 100.w : 120.w,
            child: Text(
              attendance['break'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Total Time
          SizedBox(
            width: isTablet ? 100.w : 120.w,
            child: Text(
              attendance['total'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}