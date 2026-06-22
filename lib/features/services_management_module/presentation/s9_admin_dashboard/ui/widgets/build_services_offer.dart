/// ******************* FILE INFO *******************
/// File Name: services_offered_widget.dart
/// Description: Reusable widget for displaying services offered chart
/// Created by: Refactored from dashBoard_admin.dart
/// Last Update: [Current Date]

import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/helper/services_management/circle_progress.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

class ServicesOfferedWidgetDashboard extends StatelessWidget {
  final Map<int, double> monthCountss;
  final List<String> serviceNames;
  final List<String> serviceNamesArabic;
  final bool isLoadingServicesName;

  const ServicesOfferedWidgetDashboard({
    Key? key,
    required this.monthCountss,
    required this.serviceNames,
    required this.serviceNamesArabic,
    required this.isLoadingServicesName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Collect all values for min/max calculation
    final values = _allValues().toList();
    final dataMax = (values.isEmpty ? 0.0 : values.reduce(math.max));
    const yMin = 0.0;

    // Calculate dynamic Y range
    final paddedMax = (dataMax <= 0 ? 1.0 : dataMax * 1.2);
    const tickCount = 5;
    final roughStep = (paddedMax - yMin) / (tickCount - 1);
    final yStep = _niceStep(roughStep);

    final neededSteps = ((dataMax - yMin) / yStep).ceil();
    double yMax = yStep * math.max(neededSteps, (tickCount - 1));

    final leftLabels = List<double>.generate(
      tickCount,
          (i) => yMin + i * (yMax / (tickCount - 1)),
    );

    // Calculate chart dimensions
    final barW = 40.w;
    final gap = 60.w;
    final n = monthCountss.length;
    final chartWidth = (barW * n) + (gap * (n - 1)) + 60.sp;

    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: lightMode ? AppColors.white : AppColors.chatBackground,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 26.sp,
                height: 26.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/headphoneDashboard.svg",
                    fit: BoxFit.scaleDown,
                    width: 16.sp,
                    height: 16.sp,
                    color: AppColors.textButton,
                    semanticsLabel: 'Dart Logo',
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                S.of(context).servicesOffered,
                style: AppTextStyles.font14BlackCairoRegular.copyWith(
                  color: lightMode ? AppColors.blackButton : AppColors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.sp),

          // Chart
          SizedBox(
            height: 180.sp,
            child: isLoadingServicesName
                ? Center(child: CircleProgress())
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fixed Y-Axis Labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: leftLabels
                      .map(
                        (v) => SizedBox(
                      height: 30.sp,
                      child: Text(
                        _fmtLabel(v),
                        style: AppTextStyles.font14BlackCairoMedium.copyWith(
                          color: lightMode ? AppColors.secondaryText : AppColors.grey,
                        ),
                      ),
                    ),
                  )
                      .toList()
                      .reversed
                      .toList(),
                ),
                SizedBox(width: 20.sp),

                // Scrollable Bar Chart
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 10),
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: chartWidth,
                      height: 200.h,
                      child: BarChart(
                        BarChartData(
                          groupsSpace: 30.sp,
                          maxY: yMax,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                reservedSize: 30.sp,
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, _) {
                                  final index = value.toInt();

                                  if (index >= 0 && index < serviceNames.length) {
                                    final arabicName = index < serviceNamesArabic.length ? serviceNamesArabic[index] : '';
                                    final englishName = index < serviceNames.length ? serviceNames[index] : '';
                                    final serviceName = isArabic
                                        ? (arabicName.isNotEmpty ? arabicName : englishName)
                                        : englishName;

                                    return Transform.translate(
                                      offset: Offset(0, 5.sp),
                                      child: SizedBox(
                                        width: 100.w,
                                        child: Text(
                                          serviceName,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.font12BlackCairoRegular.copyWith(
                                            color: lightMode ? AppColors.blackButton : AppColors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              tooltipPadding: EdgeInsets.zero,
                              tooltipMargin: 5,
                              getTooltipColor: (group) => Colors.transparent,
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                if (rod.toY <= 0) return null;
                                return BarTooltipItem(
                                  _fmtLabel(rod.toY),
                                  AppTextStyles.font12BlackMediumCairo.copyWith(
                                    color: lightMode ? AppColors.blackButton : AppColors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                          barGroups: monthCountss.entries.map((entry) => _buildBarGroups(entry.key, entry.value)).toList(),
                          gridData: FlGridData(show: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroups(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 30.sp,
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(6.r),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }

  Iterable<double> _allValues() sync* {
    Iterable<double> _yieldAll(dynamic value) sync* {
      if (value is num) {
        yield value.toDouble();
      } else if (value is Iterable) {
        for (final e in value) {
          yield* _yieldAll(e);
        }
      } else if (value is Map) {
        for (final e in value.values) {
          yield* _yieldAll(e);
        }
      }
    }

    for (final v in monthCountss.values) {
      yield* _yieldAll(v);
    }
  }

  double _niceStep(double roughStep) {
    if (roughStep <= 0) return 1;
    final exp = (math.log(roughStep) / math.ln10).floor();
    final f = roughStep / math.pow(10, exp);
    double nf;
    if (f <= 1) {
      nf = 1;
    } else if (f <= 2) {
      nf = 2;
    } else if (f <= 5) {
      nf = 5;
    } else {
      nf = 10;
    }
    return nf * math.pow(10, exp);
  }

  String _fmtLabel(double v) {
    final iv = v.round();
    return (v - iv).abs() < 1e-6 ? iv.toString() : v.toStringAsFixed(1);
  }
}


/*
/// ******************* USAGE EXAMPLE *******************
/// How to use the refactored widgets in dashBoard_admin.dart

// 1. Add these imports at the top of dashBoard_admin.dart:
import 'package:demo_app/features/services_management_module/presentation/s6_admin_dashboard/dashBoard_admin/widget/number_of_services_card.dart';
import 'package:demo_app/features/services_management_module/presentation/s6_admin_dashboard/dashBoard_admin/widget/services_offered_widget.dart';

// 2. In your build method, replace the existing method calls with:

// Replace: buildNumberOfServicesCard()
// With:
NumberOfServicesCard(
  monthCounts: monthCounts,
  monthHours: monthHours,
  isLoading: isLoading,
  showServiceCount: showServiceCount,
  onToggleServiceCount: () {
    if (!showServiceCount) {
      setState(() {
        showServiceCount = true;
        isLoading = true;
      });
      fetchMonthlyServiceCounts();
    }
  },
  onToggleToHours: () {
    if (showServiceCount) {
      setState(() {
        showServiceCount = false;
        isLoading = true;
      });
      fetchMonthlyDurationInHours();
    }
  },
)

// Replace: servicesOfferedWidget()
// With:
ServicesOfferedWidget(
  monthCountss: monthCountss,
  serviceNames: serviceNames,
  serviceNamesArabic: serviceNamesArabic,
  isLoadingServicesName: isLoadingServicesName,
)

// 3. REMOVE these methods from _AdminDashBoardMasterTabletState:
// - buildNumberOfServicesCard()
// - servicesOfferedWidget()
// - _buildBarGroups() (if not used elsewhere)

// 4. The full replacement in your build method:

// ================================
// Old code (line ~1445):
// ================================
selectStatus == "All"
    ? buildNumberOfServicesCard()
    : SizedBox(),

// ================================
// New code:
// ================================
selectStatus == "All"
    ? NumberOfServicesCard(
        monthCounts: monthCounts,
        monthHours: monthHours,
        isLoading: isLoading,
        showServiceCount: showServiceCount,
        onToggleServiceCount: () {
          if (!showServiceCount) {
            setState(() {
              showServiceCount = true;
              isLoading = true;
            });
            fetchMonthlyServiceCounts();
          }
        },
        onToggleToHours: () {
          if (showServiceCount) {
            setState(() {
              showServiceCount = false;
              isLoading = true;
            });
            fetchMonthlyDurationInHours();
          }
        },
      )
    : SizedBox(),

// ================================
// Old code (line ~1383):
// ================================
selectStatus == "All"
    ? Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: lightMode
              ? AppColors.white
              : AppColors.chatBackground,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ... header content
              ],
            ),
            SizedBox(height: 20.sp),
            servicesOfferedWidget(),
          ],
        ),
      )
    : SizedBox(),

// ================================
// New code:
// ================================
selectStatus == "All"
    ? ServicesOfferedWidget(
        monthCountss: monthCountss,
        serviceNames: serviceNames,
        serviceNamesArabic: serviceNamesArabic,
        isLoadingServicesName: isLoadingServicesName,
      )
    : SizedBox(),
 */
