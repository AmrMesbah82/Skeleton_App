/// ******************* FILE INFO *******************
/// File Name: number_of_services_card.dart
/// Description: Reusable widget for displaying number of services chart
/// Created by: Refactored from dashBoard_admin.dart
/// ✅ UPDATED: Now uses CustomVerticalBarChartWidget

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/extension/context_extensions.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/DashBoard_widget.dart';
import 'package:demo_app/core/helper/services_management/circle_progress.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

class NumberOfServicesCardDashBoard extends StatelessWidget {
  final Map<int, double> monthCounts;
  final Map<int, num> monthHours;
  final bool isLoading;
  final bool showServiceCount;
  final VoidCallback onToggleServiceCount;
  final VoidCallback onToggleToHours;

  const NumberOfServicesCardDashBoard({
    Key? key,
    required this.monthCounts,
    required this.monthHours,
    required this.isLoading,
    required this.showServiceCount,
    required this.onToggleServiceCount,
    required this.onToggleToHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final isMobile = context.isPhone;
    final locale = Localizations.localeOf(context).languageCode;

    // Pick active dataset
    final Map<int, num> activeData =
    showServiceCount ? monthCounts : monthHours;

    // Build labels + values for all 12 months
    final List<String> labels = List.generate(12, (i) {
      return DateFormat.MMM(locale).format(DateTime(2025, i + 1));
    });
    final List<double> values = List.generate(12, (i) {
      return (activeData[i] ?? 0).toDouble();
    });

    if (isLoading) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: lightMode
              ? AppColors.white
              : AppColors.chatBackground,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SizedBox(
          height: 300.h,
          child: Center(child: CircleProgress()),
        ),
      );
    }

    return CustomVerticalBarChartWidget(
      title: S.of(context).numberOfServices,
      iconAsset: "assets/headphoneDashboard.svg",
      labels: labels,
      values: values,
      lightMode: lightMode,
      height: isMobile ? 350 : 400,
      showAllMonths: false,
      barAlignment: BarChartAlignment.spaceAround,
      headerWidget: _buildAnimatedToggle(context, lightMode, isMobile),
    );
  }

  /// ✅ ANIMATED TOGGLE BUTTON
  Widget _buildAnimatedToggle(
      BuildContext context, bool lightMode, bool isMobile) {
    return GestureDetector(
      onTap: () {
        if (showServiceCount) {
          onToggleToHours();
        } else {
          onToggleServiceCount();
        }
      },
      child: Container(
        width: isMobile ? 200.sp : 240.sp,
        height: 30.sp,
        decoration: BoxDecoration(
          color: lightMode ? const Color(0xFFF5F5FF) : AppColors.background,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Stack(
          children: [
            // ✅ Sliding background indicator
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: showServiceCount
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: isMobile ? 96.sp : 116.sp,
                height: 30.sp,
                margin: EdgeInsets.all(4.sp),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),

            // ✅ Text labels
            Row(
              children: [
                // No. of Service Text
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: showServiceCount
                            ? AppColors.textButton
                            : (lightMode ? AppColors.black : AppColors.white),
                      ),
                      child: Text(S.of(context).NoOfService),
                    ),
                  ),
                ),

                // Total Hours Text
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: !showServiceCount
                            ? AppColors.textButton
                            : (lightMode ? AppColors.black : AppColors.white),
                      ),
                      child: Text(S.of(context).TotalHours),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
