import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo_app/core/theme/app_colors.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';




class CustomVerticalBarChartWidget extends StatelessWidget {
  final String title;
  final String? iconAsset;
  final List<String> labels;
  final List<double> values;
  final Widget? headerWidget;
  final double? maxY;
  final double? height;
  final double? width;
  final double? barWidth;
  final Color? barColor;
  final Color? backgroundColor;
  final BarChartAlignment barAlignment;
  final double groupsSpace;
  final bool showGrid;
  final bool lightMode;
  final bool showValuesOnBars;

  const CustomVerticalBarChartWidget({
    super.key,
    required this.title,
    required this.labels,
    required this.values,
    this.iconAsset,
    this.headerWidget,
    this.maxY,
    this.height,
    this.width,
    this.barWidth,
    this.barColor,
    this.backgroundColor,
    this.barAlignment = BarChartAlignment.spaceAround,
    this.groupsSpace = 30,
    this.showGrid = true,
    required this.lightMode,
    this.showValuesOnBars = true,
  });

  Map<String, double> _calculateYAxisParams() {
    if (values.isEmpty) {
      return {'maxY': 100, 'interval': 25};
    }

    final dataMax = values.reduce((a, b) => a > b ? a : b);
    final calculatedMaxY = maxY ?? (dataMax * 1.15); // Add 15% padding for values above bars

    double roundedMaxY;
    double interval;

    if (calculatedMaxY <= 100) {
      roundedMaxY = (calculatedMaxY / 20).ceil() * 20.0;
      interval = 20;
    } else if (calculatedMaxY <= 500) {
      roundedMaxY = (calculatedMaxY / 100).ceil() * 100.0;
      interval = 100;
    } else if (calculatedMaxY <= 1000) {
      roundedMaxY = (calculatedMaxY / 200).ceil() * 200.0;
      interval = 200;
    } else if (calculatedMaxY <= 5000) {
      roundedMaxY = (calculatedMaxY / 500).ceil() * 500.0;
      interval = 500;
    } else {
      roundedMaxY = (calculatedMaxY / 1000).ceil() * 1000.0;
      interval = 1000;
    }

    return {'maxY': roundedMaxY, 'interval': interval};
  }

  @override
  Widget build(BuildContext context) {
    final defaultBarColor = barColor ?? AppColors.primary;
    final defaultBgColor =
        backgroundColor ?? AppColors.card;

    final yAxisParams = _calculateYAxisParams();
    final calculatedMaxY = yAxisParams['maxY']!;
    final interval = yAxisParams['interval']!;
    final calculatedBarWidth = barWidth ?? 30;

    return Container(
      width: width?.w,
      height: height?.h,
      margin: EdgeInsets.only(top: 10.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: defaultBgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (iconAsset != null)
                    Container(
                      width: 26.sp,
                      height: 26.sp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: defaultBarColor,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          iconAsset!,
                          width: 16.sp,
                          height: 16.sp,
                          color: AppColors.textButton,
                        ),
                      ),
                    ),
                  if (iconAsset != null) SizedBox(width: 8.sp),
                  Text(
                    title,
                    style: AppTextStyles.font14BlackCairoRegular.copyWith(
                      color: AppColors.text
                    ),
                  ),
                ],
              ),
              if (headerWidget != null) Expanded(child: headerWidget!),
            ],
          ),

          SizedBox(height: 20.sp),

          // Chart
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: calculatedMaxY,
                minY: 0,
                alignment: barAlignment,
                groupsSpace: groupsSpace.sp,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: showGrid,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.secondaryText,
                      strokeWidth: 1,
                    );
                  },
                ),
                barTouchData: BarTouchData(
                  enabled: !showValuesOnBars,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: EdgeInsets.all(4.sp),
                    tooltipMargin: 2.sp,
                    getTooltipColor: (_) => Colors.transparent,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toInt().toString(),
                        TextStyle(
                          color: AppColors.text,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      reservedSize: 45.sp,
                      getTitlesWidget: (value, _) {
                        // Show 0 and every interval value
                        if (value % interval == 0) {
                          return SizedBox(
                            width: 40.sp, // Fixed width for alignment
                            child: Text(
                              value.toInt().toString(),
                              textAlign: TextAlign.right, // Right align all numbers
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50.sp,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();
                        if (index < labels.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 12.sp),
                            child: SizedBox(
                              width: 100.sp,
                              child: Text(
                                labels[index],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(values.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: values[index],
                        width: calculatedBarWidth.sp,
                        borderRadius: BorderRadius.circular(6.r),
                        color: defaultBarColor,
                      ),
                    ],
                    showingTooltipIndicators: showValuesOnBars ? [0] : [],
                  );
                }),
                // Use BarTouchTooltipData to show values always
              ),
              swapAnimationDuration: const Duration(milliseconds: 150),
              swapAnimationCurve: Curves.linear,
            ),
          ),



        ],
      ),
    );
  }
}

// Custom painter to draw values directly above bars
class _BarValuesPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final double maxY;
  final double barWidth;
  final double groupsSpace;
  final BarChartAlignment barAlignment;
  final double leftReservedSize;
  final double bottomReservedSize;
  final bool lightMode;

  _BarValuesPainter({
    required this.values,
    required this.labels,
    required this.maxY,
    required this.barWidth,
    required this.groupsSpace,
    required this.barAlignment,
    required this.leftReservedSize,
    required this.bottomReservedSize,
    required this.lightMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final chartWidth = size.width - leftReservedSize;
    final chartHeight = size.height - bottomReservedSize;

    for (int i = 0; i < values.length; i++) {
      final value = values[i];
      final barHeightRatio = value / maxY;
      final barPixelHeight = chartHeight * barHeightRatio;

      // Calculate X position for this bar
      double barX;
      if (barAlignment == BarChartAlignment.spaceAround) {
        final totalBarsWidth = values.length * barWidth;
        final spacing = (chartWidth - totalBarsWidth) / (values.length + 1);
        barX = leftReservedSize + spacing + (i * (barWidth + spacing));
      } else if (barAlignment == BarChartAlignment.center) {
        final totalBarsWidth = values.length * barWidth;
        final totalSpacesWidth = (values.length - 1) * groupsSpace;
        final totalWidth = totalBarsWidth + totalSpacesWidth;
        final startX = leftReservedSize + (chartWidth - totalWidth) / 2;
        barX = startX + (i * (barWidth + groupsSpace));
      } else {
        // start or end
        barX = leftReservedSize + (i * (barWidth + groupsSpace));
      }

      // Calculate Y position - directly above bar with small gap
      final barTopY = chartHeight - barPixelHeight;

      // Draw value text
      final textSpan = TextSpan(
        text: value.toInt().toString(),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: lightMode ? Colors.black : Colors.white,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // Center text above bar with minimal gap (3-5 pixels)
      final textX = barX + (barWidth - textPainter.width) / 2;
      final textY = barTopY - textPainter.height - 3; // 3px gap

      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 3. PIE CHART WITH LABELS WIDGET
// ============================================
class CustomPieChartWithLabelsWidget extends StatelessWidget {
  final String title;
  final String? iconAsset;
  final String totalValue;
  final String totalLabel;
  final List<ChartDataItem> data;
  final List<String> valueLabels;
  final bool lightMode;
  final double? height;

  const CustomPieChartWithLabelsWidget({
    super.key,
    required this.title,
    required this.totalValue,
    required this.totalLabel,
    required this.data,
    required this.valueLabels,
    this.iconAsset,
    required this.lightMode,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final defaultBgColor =  AppColors.card;  // Changed from const Color(0xFF2C2C2C)

    final int itemCount = data.length;
    final double labelRowHeight = 26.sp;
    final double itemRowHeight = 19.sp;
    final double itemSpacing = 5.sp;
    final double topPadding = 10.sp;
    final double pieChartHeight = 120.sp;
    final double bottomPadding = 10.sp;

    final double minHeight =
        labelRowHeight + topPadding + 30.sp + bottomPadding + pieChartHeight;

    final double calculatedHeight =
        labelRowHeight +
            topPadding +
            bottomPadding +
            (itemCount * (itemRowHeight + itemSpacing));

    return Container(
      height:
      height ??
          (isMobile ? min(max(calculatedHeight, minHeight), 220.sp) : 260.sp),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: defaultBgColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                if (iconAsset != null)
                  Container(
                    width: 26.sp,
                    height: 26.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        iconAsset!,
                        width: 16.sp,
                        height: 16.sp,
                        color: AppColors.textButton,
                      ),
                    ),
                  ),
                SizedBox(width: 7.sp),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 15.sp),

            // Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Labels
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data
                          .map(
                            (item) => Padding(
                          padding: EdgeInsets.only(bottom: 5.sp),
                          child: Row(
                            children: [
                              Container(
                                width: 14.sp,
                                height: 14.sp,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: item.color,
                                ),
                              ),
                              SizedBox(width: 6.sp),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color:AppColors.secondaryText,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),

                  SizedBox(width: 10.sp),

                  // Values
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: valueLabels
                          .map(
                            (value) => Padding(
                          padding: EdgeInsets.only(bottom: 5.sp),
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),

                  SizedBox(width: 10.sp),

                  // Pie Chart
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: pieChartHeight,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 35.r,
                              sections: data
                                  .map(
                                    (item) => PieChartSectionData(
                                  value: item.value,
                                  color: item.color,
                                  radius: 24.r,
                                  title: "",
                                ),
                              )
                                  .toList(),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                totalValue,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.text,
                                ),
                              ),
                              Text(
                                totalLabel,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class for Pie Chart Data
class ChartDataItem {
  final String label;
  final Color color;
  final double value;

  ChartDataItem({
    required this.label,
    required this.color,
    required this.value,
  });
}
