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

class AssetsTabContent extends StatefulWidget {
  const AssetsTabContent({super.key});

  @override
  State<AssetsTabContent> createState() => _AssetsTabContentState();
}

class _AssetsTabContentState extends State<AssetsTabContent> {
  final TextEditingController _searchController = TextEditingController();
  bool _isAssetsSelected = true; // true = Assets, false = Consumables

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Performance Section
        _buildOverallPerformance(isMobile, isTablet),
        SizedBox(height: 24.h),

        // Assets Bar Chart with Inventory Type Filter
        CustomVerticalBarChartWidget(
          title: _isAssetsSelected ? 'Assets' : 'Consumables',
          iconAsset: 'assets/hrAsset/hrBoards.svg',
          labels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          values: const [410, 305, 265, 192, 63, 78],
          height: isMobile ? 300 : 400,
          lightMode: false,
          showValuesOnBars: true,
          headerWidget: _buildChartHeaderDropdowns(isMobile, isTablet),
        ),
        SizedBox(height: 24.h),

        // Assets/Consumables Toggle
        Row(
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
                  // Assets Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAssetsSelected = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 12.w : 16.w,
                          vertical: isMobile ? 6.h : 8.h
                      ),
                      decoration: BoxDecoration(
                        color: _isAssetsSelected
                            ? AppColors.secondaryPrimary
                            : AppColors.card,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'Assets',
                        style: (isMobile
                            ? AppTextStyles.font12BlackCairoRegular
                            : AppTextStyles.font14BlackCairoRegular)
                            .copyWith(
                          color: _isAssetsSelected
                              ? AppColors.textButton
                              : AppColors.text,
                        ),
                      ),
                    ),
                  ),
                  // Consumables Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAssetsSelected = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 12.w : 16.w,
                          vertical: isMobile ? 6.h : 8.h
                      ),
                      decoration: BoxDecoration(
                        color: !_isAssetsSelected
                            ? AppColors.secondaryPrimary
                            : AppColors.card,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'Consumables',
                        style: (isMobile
                            ? AppTextStyles.font12BlackCairoRegular
                            : AppTextStyles.font14BlackCairoRegular)
                            .copyWith(
                          color: !_isAssetsSelected
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
        ),
        SizedBox(height: 20.h),

        // Assets Details Header
        Text(
          'Assets Details',
          style: (isMobile
              ? AppTextStyles.font16BlackMediumCairo
              : AppTextStyles.font18BlackMediumCairo)
              .copyWith(
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 8.h),

        // Search, Filter, and Export Row
        _buildSearchFilterExportRow(isMobile, isTablet),
        SizedBox(height: 15.h),

        // Assets Table
        _buildAssetsTable(isMobile, isTablet),
      ],
    );
  }

  // OVERALL PERFORMANCE - ALWAYS HORIZONTAL
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
            'Overall',
            style: (isMobile
                ? AppTextStyles.font14BlackCairoMedium
                : AppTextStyles.font16BlackMediumCairo)
                .copyWith(
              color: AppColors.text,
            ),
          ),
          SizedBox(height: isMobile ? 12.h : 16.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCardContent(
                  icon: 'assets/hrAsset/hrAst.svg',
                  label: 'Assets',
                  value: '11',
                  labelColor: AppColors.secondaryPrimary,
                  isMobile: isMobile,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCardContent(
                  icon: 'assets/hrAsset/hrConsumable.svg',
                  label: 'Consumables',
                  value: '11',
                  labelColor: AppColors.secondaryPrimary,
                  isMobile: isMobile,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCardContent(
                  icon: 'assets/hrAsset/hrReq.svg',
                  label: 'Requests',
                  value: '11',
                  labelColor: AppColors.secondaryPrimary,
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
        SizedBox(width: isMobile ? 8.w : 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: (isMobile
                    ? AppTextStyles.font13SecondaryBlackCairo
                    : AppTextStyles.font15BlackCairoRegular)
                    .copyWith(
                  color: labelColor ?? AppColors.secondaryPrimary,
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

  // CHART HEADER DROPDOWNS - RESPONSIVE
  Widget _buildChartHeaderDropdowns(bool isMobile, bool isTablet) {
    return Row(
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
                'Inventory Type',
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
        SizedBox(width: isMobile ? 8.w : 12.w),
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

  Widget _buildAssetsTable(bool isMobile, bool isTablet) {
    final assets = [
      {
        'id': '001',
        'name': 'Laptop',
        'category': 'Electronics',
        'subcategory': 'Computer',
        'model': 'G2 16',
        'brand': 'Dell',
        'dateReceived': '01 Feb 2024',
        'dateReturn': '02 Feb 2024',
      },
      {
        'id': '002',
        'name': 'Projector',
        'category': 'Electronics',
        'subcategory': 'Daily / Visual',
        'model': 'HP 127',
        'brand': 'Sony',
        'dateReceived': '02 Feb 2024',
        'dateReturn': '',
      },
      {
        'id': '003',
        'name': 'Software',
        'category': 'Software',
        'subcategory': 'Software Licenses',
        'model': 'Operating System',
        'brand': '',
        'dateReceived': '03 Feb 2024',
        'dateReturn': '02 Feb 2024',
      },
    ];

    if (isMobile) {
      // Mobile: Card-based layout
      return Column(
        children: assets.map((asset) {
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
                      'ID: ${asset['id']}',
                      style: AppTextStyles.font12SecondaryBlackCairoMedium.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      asset['category'].toString(),
                      style: AppTextStyles.font12SecondaryBlackCairoMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildMobileAssetRow('Name', asset['name'].toString()),
                _buildMobileAssetRow('Subcategory', asset['subcategory'].toString()),
                _buildMobileAssetRow('Model', asset['model'].toString()),
                _buildMobileAssetRow('Brand', asset['brand'].toString().isEmpty ? '-' : asset['brand'].toString()),
                _buildMobileAssetRow('Date Received', asset['dateReceived'].toString()),
                _buildMobileAssetRow('Date Return', asset['dateReturn'].toString().isEmpty ? '-' : asset['dateReturn'].toString()),
              ],
            ),
          );
        }).toList(),
      );
    }

    // Tablet & Desktop: Table layout
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: SingleChildScrollView(
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
                  _buildTableHeaderCell('Asset ID', isTablet ? 80.w : 100.w, isTablet),
                  SizedBox(width: isTablet ? 30.w : 50.w),
                  _buildTableHeaderCell('Asset Name', isTablet ? 130.w : 150.w, isTablet),
                  SizedBox(width: isTablet ? 30.w : 50.w),
                  _buildTableHeaderCell('Category', isTablet ? 130.w : 150.w, isTablet),
                  SizedBox(width: isTablet ? 30.w : 50.w),
                  _buildTableHeaderCell('Subcategory', isTablet ? 130.w : 150.w, isTablet),
                  SizedBox(width: isTablet ? 30.w : 50.w),
                  _buildTableHeaderCell('Model', isTablet ? 130.w : 150.w, isTablet),
                  SizedBox(width: isTablet ? 30.w : 50.w),
                  _buildTableHeaderCell('Brand', isTablet ? 100.w : 120.w, isTablet),
                  SizedBox(width: isTablet ? 30.w : 50.w),
                  _buildTableHeaderCell('Date Received', isTablet ? 130.w : 150.w, isTablet),
                  SizedBox(width: isTablet ? 30.w : 50.w),
                  _buildTableHeaderCell('Date Return', isTablet ? 130.w : 150.w, isTablet),
                ],
              ),
            ),
            // Table Rows
            ...assets.asMap().entries.map((entry) {
              final index = entry.key;
              final asset = entry.value;
              return _buildTableRow(asset, index, isTablet);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileAssetRow(String label, String value) {
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

  Widget _buildTableRow(Map<String, dynamic> asset, int index, bool isTablet) {
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
          // Asset ID
          SizedBox(
            width: isTablet ? 80.w : 100.w,
            child: Text(
              asset['id'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Asset Name
          SizedBox(
            width: isTablet ? 130.w : 150.w,
            child: Text(
              asset['name'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Category
          SizedBox(
            width: isTablet ? 130.w : 150.w,
            child: Text(
              asset['category'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Subcategory
          SizedBox(
            width: isTablet ? 130.w : 150.w,
            child: Text(
              asset['subcategory'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Model
          SizedBox(
            width: isTablet ? 130.w : 150.w,
            child: Text(
              asset['model'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Brand
          SizedBox(
            width: isTablet ? 100.w : 120.w,
            child: Text(
              asset['brand'].isEmpty ? '-' : asset['brand'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Date Received
          SizedBox(
            width: isTablet ? 130.w : 150.w,
            child: Text(
              asset['dateReceived'],
              style: (isTablet
                  ? AppTextStyles.font12BlackCairoRegular
                  : AppTextStyles.font13SecondaryBlackCairo)
                  .copyWith(
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 30.w : 50.w),

          // Date Return
          SizedBox(
            width: isTablet ? 130.w : 150.w,
            child: Text(
              asset['dateReturn'].isEmpty ? '-' : asset['dateReturn'],
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