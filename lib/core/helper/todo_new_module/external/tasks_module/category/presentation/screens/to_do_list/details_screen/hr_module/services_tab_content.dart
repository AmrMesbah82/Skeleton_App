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

class ServicesTabContent extends StatefulWidget {
  const ServicesTabContent({super.key});

  @override
  State<ServicesTabContent> createState() => _ServicesTabContentState();
}

class _ServicesTabContentState extends State<ServicesTabContent> {
  String _selectedTimeFilter = 'time';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SERVICE DETAILS HEADER
        Text(
          'Service Details',
          style: (isMobile
              ? AppTextStyles.font14BlackCairoMedium
              : AppTextStyles.font16BlackMediumCairo)
              .copyWith(
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 8.h),
        _buildServiceDetailsHeader(isMobile, isTablet),
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

        // SERVICES OFFERED CHART
        CustomVerticalBarChartWidget(
          title: 'Services Offered',
          iconAsset: 'assets/hrAsset/hrServicesoffered.svg',
          labels: const [
            'Marketing Research Service',
            'Marketing Research Service'
          ],
          values: const [220, 410],
          height: isMobile ? 300 : 400,
          lightMode: false,
          showValuesOnBars: true,
        ),
        SizedBox(height: 20.h),

        // NUMBER OF SERVICES CHART
        CustomVerticalBarChartWidget(
          title: 'Number of Services',
          iconAsset: 'assets/hrAsset/hrServicesoffered.svg',
          labels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          values: const [220, 410, 366, 282, 49, 79],
          height: isMobile ? 300 : 400,
          lightMode: false,
          showValuesOnBars: true,
          headerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10.w : 12.w,
                    vertical: isMobile ? 6.h : 8.h
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'No. of Service',
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
        ),
        SizedBox(height: 20.h),

        // STATUS OF SERVICES CHART
        CustomVerticalBarChartWidget(
          title: 'Status Of Services',
          iconAsset: 'assets/hrAsset/hrStatusofservice.svg',
          labels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          values: const [220, 410, 366, 282, 49, 79],
          height: isMobile ? 300 : 400,
          lightMode: false,
          showValuesOnBars: true,
          headerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10.w : 12.w,
                    vertical: isMobile ? 6.h : 8.h
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Status',
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
        ),
        SizedBox(height: 20.h),

        // SERVICE HISTORY DETAILS HEADER
        Text(
          'Service History Details',
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

        // SERVICE HISTORY DETAILS SECTION
        _buildServiceHistoryDetails(isMobile, isTablet),
      ],
    );
  }

  // SERVICE DETAILS HEADER - RESPONSIVE
  Widget _buildServiceDetailsHeader(bool isMobile, bool isTablet) {
    if (isMobile) {
      return Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            _buildStatItem('Services Done:', '4', isMobile),
            SizedBox(height: 12.h),
            _buildStatItem('Total Hours:', '500', isMobile),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.red, width: 1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Breached SLA:',
                    style: AppTextStyles.font14BlackCairoMedium.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '3',
                    style: AppTextStyles.font14BlackCairoMedium.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Tablet & Desktop
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 12.sp : 15.sp,
        horizontal: isTablet ? 10.w : 0,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: isTablet
          ? Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Services Done:', '4', isMobile),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildStatItem('Total Hours:', '500', isMobile),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.red, width: 1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Breached SLA:',
                  style: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '3',
                  style: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.sp),
            child: _buildStatItem('Services Done:', '4', isMobile),
          ),
          SizedBox(width: 43.w),
          _buildStatItem('Total Hours:', '500', isMobile),
          SizedBox(width: 43.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.red, width: 1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              children: [
                Text(
                  'Breached SLA:',
                  style: AppTextStyles.font16BlackMediumCairo.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '3',
                  style: AppTextStyles.font16BlackMediumCairo.copyWith(
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 250.w,
      height: isMobile ? 35.h : 38.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: (isMobile
                ? AppTextStyles.font14BlackCairoMedium
                : AppTextStyles.font16BlackMediumCairo)
                .copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            value,
            style: (isMobile
                ? AppTextStyles.font14BlackCairoMedium
                : AppTextStyles.font16BlackMediumCairo)
                .copyWith(
              color: AppColors.text,
            ),
          ),
        ],
      ),
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

  Widget _buildServiceHistoryDetails(bool isMobile, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table
          _buildServiceHistoryTable(isMobile, isTablet),
        ],
      ),
    );
  }

  Widget _buildServiceHistoryTable(bool isMobile, bool isTablet) {
    final services = [
      {
        'no': '1',
        'department': 'Marketing',
        'serviceName': 'Market Research',
        'serviceRequester': 'Ahmed Abd el Rahman',
        'requestDate': '23 Feb 2023',
        'status': 'Approved',
        'statusColor': Colors.green,
      },
      {
        'no': '2',
        'department': 'HR',
        'serviceName': 'Market Research',
        'serviceRequester': 'Ahmed Abd el Rahman',
        'requestDate': '23 Feb 2023',
        'status': 'Rejected',
        'statusColor': Colors.red,
      },
      {
        'no': '3',
        'department': 'Design',
        'serviceName': 'Market Research',
        'serviceRequester': 'Ahmed Abd el Rahman',
        'requestDate': '23 Feb 2023',
        'status': 'In Progress',
        'statusColor': AppColors.primary,
      },
      {
        'no': '4',
        'department': 'Marketing',
        'serviceName': 'Market Research',
        'serviceRequester': 'Ahmed Abd el Rahman',
        'requestDate': '23 Feb 2023',
        'status': 'Rejected',
        'statusColor': Colors.red,
      },
      {
        'no': '5',
        'department': 'Marketing',
        'serviceName': 'Market Research',
        'serviceRequester': 'Ahmed Abd el Rahman',
        'requestDate': '23 Feb 2023',
        'status': 'Approved',
        'statusColor': Colors.green,
      },
      {
        'no': '6',
        'department': 'Marketing',
        'serviceName': 'Market Research',
        'serviceRequester': 'Ahmed Abd el Rahman',
        'requestDate': '23 Feb 2023',
        'status': 'Pending',
        'statusColor': AppColors.primary,
      },
      {
        'no': '7',
        'department': 'Marketing',
        'serviceName': 'Market Research',
        'serviceRequester': 'Ahmed Abd el Rahman',
        'requestDate': '23 Feb 2023',
        'status': 'Pending',
        'statusColor': AppColors.primary,
      },
      {
        'no': '8',
        'department': 'Marketing',
        'serviceName': 'Market Research',
        'serviceRequester': 'Ahmed Abd el Rahman',
        'requestDate': '23 Feb 2023',
        'status': 'Rejected',
        'statusColor': Colors.red,
      },
    ];

    if (isMobile) {
      // Mobile: Card-based layout
      return Column(
        children: services.map((service) {
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
                      'NO: ${service['no']}',
                      style: AppTextStyles.font12SecondaryBlackCairoMedium.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      service['status'].toString(),
                      style: AppTextStyles.font12SecondaryBlackCairoMedium.copyWith(
                        color: service['statusColor'] as Color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildMobileServiceRow('Department', service['department'].toString()),
                _buildMobileServiceRow('Service Name', service['serviceName'].toString()),
                _buildMobileServiceRow('Service Requester', service['serviceRequester'].toString()),
                _buildMobileServiceRow('Request Date', service['requestDate'].toString()),
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
                _buildTableHeaderCell('NO', isTablet ? 50.w : 60.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Department', isTablet ? 100.w : 120.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Service Name', isTablet ? 130.w : 150.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Service Requester', isTablet ? 180.w : 200.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Request Date', isTablet ? 100.w : 120.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Status', isTablet ? 100.w : 120.w, isTablet),
              ],
            ),
          ),

          // Table Rows
          ...services.asMap().entries.map((entry) {
            final index = entry.key;
            final service = entry.value;
            return _buildTableRow(service, index, isTablet);
          }),
        ],
      ),
    );
  }

  Widget _buildMobileServiceRow(String label, String value) {
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

  Widget _buildTableRow(Map<String, dynamic> service, int index, bool isTablet) {
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
              service['no'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Department
          SizedBox(
            width: isTablet ? 100.w : 120.w,
            child: Text(
              service['department'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Service Name
          SizedBox(
            width: isTablet ? 130.w : 150.w,
            child: Text(
              service['serviceName'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Service Requester with Avatar
          SizedBox(
            width: isTablet ? 180.w : 200.w,
            child: Row(
              children: [
                Container(
                  width: isTablet ? 25.sp : 30.sp,
                  height: isTablet ? 25.sp : 30.sp,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background,
                  ),
                  child: ClipOval(
                    child: SvgPicture.asset(
                      'assets/hrAsset/Ellipse.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    service['serviceRequester'],
                    style: (isTablet
                        ? AppTextStyles.font12BlackCairoRegular
                        : AppTextStyles.font13SecondaryBlackCairo)
                        .copyWith(
                      color: AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Request Date
          SizedBox(
            width: isTablet ? 100.w : 120.w,
            child: Text(
              service['requestDate'],
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
              service['status'],
              style: (isTablet
                  ? AppTextStyles.font12SecondaryBlackCairoMedium
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: service['statusColor'],
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