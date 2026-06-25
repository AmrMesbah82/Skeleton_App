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

class TasksTabContent extends StatefulWidget {
  const TasksTabContent({super.key});

  @override
  State<TasksTabContent> createState() => _TasksTabContentState();
}

class _TasksTabContentState extends State<TasksTabContent> {
  final TextEditingController _searchController = TextEditingController();
  bool _isTaskStatusOwner = true; // true = Owner, false = Contributor
  bool _isTimelineBoards = true; // true = Boards, false = Cards
  bool _isStatusDropdown = false; // for Status chart dropdown

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TASK DETAILS HEADER
        Text(
          'Task Details',
          style: (isMobile
              ? AppTextStyles.font14BlackCairoMedium
              : AppTextStyles.font16BlackMediumCairo)
              .copyWith(
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 8.h),
        _buildTaskDetailsHeader(isMobile, isTablet),
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

        // OVERALL PERFORMANCE SECTION
        _buildOverallPerformance(isMobile, isTablet),
        SizedBox(height: 20.h),

        // PIE CHARTS ROW (Open Tasks and Status)
        _buildPieChartsRow(isMobile, isTablet),
        SizedBox(height: 20.h),

        // COLLABORATING DEPARTMENTS CHART
        CustomVerticalBarChartWidget(
          title: 'Collaborating Departments',
          iconAsset: 'assets/hrAsset/hrCase.svg',
          labels: const ['Marketing', 'Marketing', 'Marketing', 'Marketing', 'Marketing', 'Marketing'],
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
                      'Board',
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
              SizedBox(width: 10.w),
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
                      'Card',
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

        // TASK STATUS CHART
        CustomVerticalBarChartWidget(
          title: 'Task Status',
          iconAsset: 'assets/hrAsset/hrTaskstatus.svg',
          labels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          values: const [220, 410, 366, 282, 49, 79],
          height: isMobile ? 300 : 400,
          lightMode: false,
          showValuesOnBars: true,
          headerWidget: _buildToggleButton(
            isMobile,
            isTablet,
            'Owner',
            'Contributor',
            _isTaskStatusOwner,
                (value) => setState(() => _isTaskStatusOwner = value),
          ),
        ),
        SizedBox(height: 20.h),

        // TIMELINE CHART
        CustomVerticalBarChartWidget(
          title: 'Timeline',
          iconAsset: 'assets/hrAsset/hrTimeline.svg',
          labels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          values: const [220, 410, 366, 282, 49, 79],
          height: isMobile ? 300 : 400,
          lightMode: false,
          showValuesOnBars: true,
          headerWidget: _buildToggleButton(
            isMobile,
            isTablet,
            'Boards',
            'Cards',
            _isTimelineBoards,
                (value) => setState(() => _isTimelineBoards = value),
          ),
        ),
        SizedBox(height: 20.h),

        // STATUS CHART
        CustomVerticalBarChartWidget(
          title: 'Status',
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

        // TASK HISTORY DETAILS HEADER
        Text(
          'Task History Details',
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

        // TASK HISTORY DETAILS SECTION
        _buildTaskHistoryDetails(isMobile, isTablet),
      ],
    );
  }

  // TASK DETAILS HEADER - RESPONSIVE
  Widget _buildTaskDetailsHeader(bool isMobile, bool isTablet) {
    if (isMobile) {
      return Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            _buildStatItem('Done:', '4', isMobile),
            SizedBox(height: 12.h),
            _buildStatItem('Not Started:', '500', isMobile),
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
                    'Exceeded Deadline:',
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
                child: _buildStatItem('Done:', '4', isMobile),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildStatItem('Not Started:', '500', isMobile),
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
                  'Exceeded Deadline:',
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
            child: _buildStatItem('Done:', '4', isMobile),
          ),
          SizedBox(width: 43.w),
          _buildStatItem('Not Started:', '500', isMobile),
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
                  'Exceeded Deadline:',
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

  // OVERALL PERFORMANCE - RESPONSIVE
  Widget _buildOverallPerformance(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12.sp : 16.sp),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Performance',
            style: (isMobile
                ? AppTextStyles.font16BlackSemiBoldCairo
                : AppTextStyles.font22BlackCairoSemiBold)
                .copyWith(
              color: AppColors.text,
            ),
          ),
          SizedBox(height: isMobile ? 12.h : 16.h),

          // Mobile: 2x2 grid
          if (isMobile)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCardContent(
                        icon: 'assets/hrAsset/hrTotaltask.svg',
                        label: 'Total Task',
                        value: '11',
                        labelColor: AppColors.text,
                        isMobile: isMobile,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildStatCardContent(
                        icon: 'assets/hrAsset/hrBoards.svg',
                        label: 'Boards',
                        value: '11',
                        labelColor: AppColors.text,
                        isMobile: isMobile,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCardContent(
                        icon: 'assets/hrAsset/hrCards.svg',
                        label: 'Cards',
                        value: '11',
                        labelColor: AppColors.text,
                        isMobile: isMobile,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildStatCardContent(
                        icon: 'assets/hrAsset/hrDepart.svg',
                        label: 'Departments',
                        value: '11',
                        labelColor: AppColors.text,
                        isMobile: isMobile,
                      ),
                    ),
                  ],
                ),
              ],
            )
          // Tablet & Desktop: Single row
          else
            Row(
              children: [
                Expanded(
                  child: _buildStatCardContent(
                    icon: 'assets/hrAsset/hrTotaltask.svg',
                    label: 'Total Task',
                    value: '11',
                    labelColor: AppColors.text,
                    isMobile: isMobile,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCardContent(
                    icon: 'assets/hrAsset/hrBoards.svg',
                    label: 'Boards',
                    value: '11',
                    labelColor: AppColors.text,
                    isMobile: isMobile,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCardContent(
                    icon: 'assets/hrAsset/hrCards.svg',
                    label: 'Cards',
                    value: '11',
                    labelColor: AppColors.text,
                    isMobile: isMobile,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCardContent(
                    icon: 'assets/hrAsset/hrDepart.svg',
                    label: 'Departments',
                    value: '11',
                    labelColor: AppColors.text,
                    isMobile: isMobile,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatCardContent({
    required String icon,
    required String label,
    required String value,
    Color? labelColor,
    required bool isMobile,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isMobile ? 35.sp : 40.sp,
          height: isMobile ? 35.sp : 40.sp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: isMobile ? 35.sp : 40.sp,
              height: isMobile ? 35.sp : 40.sp,
            ),
          ),
        ),
        SizedBox(width: isMobile ? 6.w : 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: (isMobile
                    ? AppTextStyles.font12SecondaryBlackCairoMedium
                    : AppTextStyles.font14BlackSemiBoldCairo)
                    .copyWith(
                  color: labelColor ?? AppColors.text,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isMobile ? 4.h : 8.h),
              Text(
                value,
                style: (isMobile
                    ? AppTextStyles.font16BlackSemiBoldCairo
                    : AppTextStyles.font20BlackSemiBoldCairo)
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

  // PIE CHARTS ROW - RESPONSIVE
  Widget _buildPieChartsRow(bool isMobile, bool isTablet) {
    final openTasksChart = CustomPieChartWithLabelsWidget(
      title: 'Open Tasks',
      iconAsset: 'assets/hrAsset/hrOpentask.svg',
      totalValue: '9K',
      totalLabel: 'Total',
      data: [
        ChartDataItem(
          label: 'Urgent',
          color: Color(0xFFB41010),
          value: 513,
        ),
        ChartDataItem(
          label: 'Important',
          color: Color(0xFFDF1C1C),
          value: 513,
        ),
        ChartDataItem(
          label: 'Medium',
          color: Color(0xFFFFDE59),
          value: 513,
        ),
        ChartDataItem(
          label: 'Low',
          color: Color(0xFF73A2FF),
          value: 513,
        ),
      ],
      valueLabels: const ['513', '513', '513', '513'],
      lightMode: false,
      height: isMobile ? 220.h : 250.h,
    );

    final statusChart = CustomPieChartWithLabelsWidget(
      title: 'Status',
      iconAsset: 'assets/hrAsset/hrStatusofservice.svg',
      totalValue: '9K',
      totalLabel: 'Total',
      data: [
        ChartDataItem(
          label: 'Done',
          color: Color(0xFF4BB609),
          value: 513,
        ),
        ChartDataItem(
          label: 'Not started',
          color: Color(0xFFFFCC00),
          value: 513,
        ),
        ChartDataItem(
          label: 'Exceeded deadline',
          color: Color(0xFFDF1C1C),
          value: 513,
        ),
      ],
      valueLabels: const ['513', '513', '513'],
      lightMode: false,
      height: isMobile ? 220.h : 250.h,
    );

    if (isMobile) {
      // Mobile: Stacked vertically
      return Column(
        children: [
          openTasksChart,
          SizedBox(height: 15.h),
          statusChart,
        ],
      );
    }

    // Tablet & Desktop: Side by side
    return Row(
      children: [
        Expanded(child: openTasksChart),
        SizedBox(width: 15.w),
        Expanded(child: statusChart),
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

  Widget _buildTaskHistoryDetails(bool isMobile, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table
          _buildTaskHistoryTable(isMobile, isTablet),
        ],
      ),
    );
  }

  Widget _buildTaskHistoryTable(bool isMobile, bool isTablet) {
    final tasks = [
      {
        'no': '1',
        'board': 'Card 1',
        'card': 'Card 1',
        'tasks': 'Design 10 Screens',
        'assign': 'Single',
        'startDate': '28 Dec 2023',
        'endDate': '28 Dec 2023',
        'totalDays': '100',
      },
      {
        'no': '2',
        'board': 'Card 2',
        'card': 'Card 2',
        'tasks': 'Design 10 Screens',
        'assign': 'Multiple',
        'startDate': '28 Jan 2023',
        'endDate': '28 Jan 2023',
        'totalDays': '120',
      },
      {
        'no': '3',
        'board': 'Card Name',
        'card': 'Card Name',
        'tasks': 'Lorem Ipsum',
        'assign': 'Single',
        'startDate': '28 Feb 2023',
        'endDate': '28 Feb 2023',
        'totalDays': '90',
      },
      {
        'no': '4',
        'board': 'Card Name',
        'card': 'Card Name',
        'tasks': 'Lorem Ipsum',
        'assign': 'Single',
        'startDate': '28 Mar 2023',
        'endDate': '28 Mar 2023',
        'totalDays': '85',
      },
      {
        'no': '5',
        'board': 'Card 3',
        'card': 'Card 3',
        'tasks': 'Lorem Ipsum',
        'assign': 'Single',
        'startDate': '28 Apr 2023',
        'endDate': '28 Apr 2023',
        'totalDays': '110',
      },
      {
        'no': '6',
        'board': 'Card 4',
        'card': 'Card 4',
        'tasks': 'Lorem Ipsum',
        'assign': 'Single',
        'startDate': '28 May 2023',
        'endDate': '28 May 2023',
        'totalDays': '95',
      },
      {
        'no': '7',
        'board': 'Card 5',
        'card': 'Card 5',
        'tasks': 'Lorem Ipsum',
        'assign': 'Single',
        'startDate': '28 Jun 2023',
        'endDate': '28 Jun 2023',
        'totalDays': '88',
      },
      {
        'no': '8',
        'board': 'Card 2',
        'card': 'Card 2',
        'tasks': 'Lorem Ipsum',
        'assign': 'Single',
        'startDate': '28 Jul 2023',
        'endDate': '28 Jul 2023',
        'totalDays': '105',
      },
      {
        'no': '9',
        'board': 'Card Name',
        'card': 'Card Name',
        'tasks': 'Lorem Ipsum',
        'assign': 'Single',
        'startDate': '28 Aug 2023',
        'endDate': '28 Aug 2023',
        'totalDays': '92',
      },
    ];

    if (isMobile) {
      // Mobile: Card-based layout
      return Column(
        children: tasks.map((task) {
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
                      'NO: ${task['no']}',
                      style: AppTextStyles.font12SecondaryBlackCairoMedium.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      '${task['totalDays']} Days',
                      style: AppTextStyles.font12SecondaryBlackCairoMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildMobileTaskRow('Board', task['board'].toString()),
                _buildMobileTaskRow('Card', task['card'].toString()),
                _buildMobileTaskRow('Tasks', task['tasks'].toString()),
                _buildMobileTaskRow('Assign', task['assign'].toString()),
                _buildMobileTaskRow('Start Date', task['startDate'].toString()),
                _buildMobileTaskRow('End Date', task['endDate'].toString()),
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
                _buildTableHeaderCell('Board', isTablet ? 100.w : 120.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Card', isTablet ? 100.w : 120.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Tasks', isTablet ? 130.w : 150.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Assign', isTablet ? 80.w : 100.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Start Date', isTablet ? 100.w : 120.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('End Date', isTablet ? 100.w : 120.w, isTablet),
                SizedBox(width: isTablet ? 30.w : 50.w),
                _buildTableHeaderCell('Total Days', isTablet ? 80.w : 100.w, isTablet),
              ],
            ),
          ),

          // Table Rows
          ...tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;
            return _buildTableRow(task, index, isTablet);
          }),
        ],
      ),
    );
  }

  Widget _buildMobileTaskRow(String label, String value) {
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

  Widget _buildTableRow(Map<String, dynamic> task, int index, bool isTablet) {
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
              task['no'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Board
          SizedBox(
            width: isTablet ? 100.w : 120.w,
            child: Text(
              task['board'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Card
          SizedBox(
            width: isTablet ? 100.w : 120.w,
            child: Text(
              task['card'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Tasks
          SizedBox(
            width: isTablet ? 130.w : 150.w,
            child: Text(
              task['tasks'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Assign
          SizedBox(
            width: isTablet ? 80.w : 100.w,
            child: Text(
              task['assign'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Start Date
          SizedBox(
            width: isTablet ? 100.w : 120.w,
            child: Text(
              task['startDate'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // End Date
          SizedBox(
            width: isTablet ? 100.w : 120.w,
            child: Text(
              task['endDate'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Total Days
          SizedBox(
            width: isTablet ? 80.w : 100.w,
            child: Text(
              task['totalDays'],
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