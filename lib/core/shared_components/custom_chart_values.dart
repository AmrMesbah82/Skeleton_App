//Date Created :16/October/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :16/October/2023 by mazen
// Objectives: this class  created to Customize the chart data values in the dashboard widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';

import 'package:demo_app/core/theme/app_font_size.dart';

// ignore: must_be_immutable
class CustomChartDataValues extends StatefulWidget {
  CustomChartDataValues(
      {super.key,
      this.detailsProgress,
      this.isHorizontal,
      required this.valueText,
      this.isPerformanceScreen,
      this.isSmall});
  bool? detailsProgress;
  bool? isHorizontal;
  String valueText;
  bool? isPerformanceScreen;
  bool? isSmall;

  @override
  State<CustomChartDataValues> createState() => _CustomChartDataValuesState();
}

class _CustomChartDataValuesState extends State<CustomChartDataValues> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Row(
      children: [
        isTablet
            ? SizedBox(width: 0.025.h)
            : Icon(
                Icons.circle,
                size: 0.012.h,
                color: Colors.transparent,
              ),
        isTablet ? const SizedBox.shrink() : SizedBox(width: 0.01.w),
        Text(
          Get.locale.toString().contains('en')
              ? widget.valueText.tr
              : convertNumberToArabic(
                  widget.valueText.tr), //widget.values[i] + ' Projects'.tr,
          style: AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: widget.isPerformanceScreen == true
                ? FontConstants.fontSize024.h
                : isTablet
                    ?isPortrait?FontConstants.fontSize016.h :FontConstants.fontSize020.h
                    : FontConstants.fontSize017.h,
            color: Theme.of(context).colorScheme.tertiaryContainer,
            fontWeight: FontWeight.w600,
            //height: 0.0015.h
          ),
        ),
      ],
    );
  }
}
