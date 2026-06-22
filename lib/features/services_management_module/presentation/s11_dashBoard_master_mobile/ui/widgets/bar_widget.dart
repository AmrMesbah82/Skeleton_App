import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:demo_app/core/theme/app_colors.dart';

BarChartGroupData buildBarGroups(int x, double y) {
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
