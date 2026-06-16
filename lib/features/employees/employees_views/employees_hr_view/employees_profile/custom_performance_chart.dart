// ignore_for_file: unrelated_type_equality_checks, sized_box_for_whitespace, unused_local_variable
import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/shared_components/custom_chart_data.dart';
import 'package:demo_app/core/shared_components/custom_chart_values.dart';


import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//Date Created :5/September/2023
// Developer Name : Mazen shabaan
//App Version : Version Mobile
// Date of Last Edit :23/Novmember/2023 by Bassem
// Objectives: this class created to Customize the chart widget in the home screen

class CustomPerformanceChart extends StatefulWidget {
  final String title;
  final List<String> texts;
  final List<String> values;
  final List<String>? mins;
  final double width;
  final double height;
  final double textSizeTexts;
  final double textSizeValues;
  final double widthDiff;
  final bool show;
  final bool isTransparent;
  final double textwidth;
  final bool detailsProgress;
  final bool isSmall;
  final bool isHorizontal;
  final bool isPerformanceScreen;

  const CustomPerformanceChart({
    required this.title,
    required this.texts,
    required this.values,
    this.mins,
    required this.width,
    this.height = 0.300,
    this.textSizeTexts = 0.023,
    this.textSizeValues = 0.021,
    this.widthDiff = 0.008,
    this.textwidth = 0.16,
    this.show = true,
    this.isPerformanceScreen = false,
    this.isSmall = false,
    this.detailsProgress = false,
    this.isTransparent = false,
    this.isHorizontal = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomPerformanceChart> createState() => _CustomPerformanceChartState();
}

class _CustomPerformanceChartState extends State<CustomPerformanceChart> {
  int calculateSum(List<String>? values) {
    int sum = 0;
    if (values != null) {
      for (int i = 0; i < values.length; i++) {
        sum += int.parse(values[i]);
      }
    }
    return sum;
  }

  List<int> calculateHoursAndMinutes(List<String>? values, List<String>? mins) {
    int totalMinutes = 0;

    if (mins != null) {
      for (int i = 0; i < mins.length; i++) {
        totalMinutes += int.parse(mins[i]);
      }
    }

    int additionalHours = totalMinutes ~/ 60; // Calculate the additional hours
    int remainingMinutes = totalMinutes % 60; // Calculate the remaining minutes

    int totalHours = 0;
    if (values != null) {
      for (int i = 0; i < values.length; i++) {
        totalHours += int.parse(values[i]);
      }
    }

    // Add the additional hours to the existing total hours
    totalHours += additionalHours;

    return [totalHours, remainingMinutes];
  }

  // String simplifyNumber(int value) {
  //   if (value >= 1000000) {
  //     double simplifiedValue = value / 1000000;
  //     return '${simplifiedValue.toStringAsFixed(1)}M';
  //   } else if (value >= 1000) {
  //     double simplifiedValue = value / 1000;
  //     return '${simplifiedValue.toStringAsFixed(1)}k';
  //   } else {
  //     return value.toStringAsFixed(0);
  //   }
  // }

  final List<Color> customColors = [
    AppColors.signOut,
    AppColors.colorGrey,
    AppColors.lightPrimary,
    AppColors.colorGreydark,
    AppColors.colorLightGrey,
    AppColors.colorWhiteDark,
    AppColors.colorGreyDisabled,
    AppColors.colorDarkGrey,
  ];
  //AppColors.colorGreydark,

  @override
  Widget build(BuildContext context) {
    int totalSum = calculateSum(widget.values);
    // String simplifiedSum = simplifyNumber(totalSum);

    List<int> hoursAndMinutes =
        calculateHoursAndMinutes(widget.values, widget.mins);
    int totalHours = hoursAndMinutes[0];
    int totalMinutes = hoursAndMinutes[1];

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final ThemeController themeController = Get.put(ThemeController());
    List<ChartData> data = [];
    for (int i = 0; i < widget.texts.length; i++) {
      data.add(ChartData(widget.texts[i], double.parse(widget.values[i])));
    }
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Container(
      width: widget.width,
      height: widget.height.h,
      decoration: BoxDecoration(
        color: widget.isTransparent && isTablet == false
            ? Colors.transparent
            : Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(9),
        boxShadow: themeController.currentTheme == AppColors.lightTheme
            ? [
                if (widget.isTransparent == false)
                  BoxShadow(
                    color: AppColors.colorGrey.withOpacity(0.2),
                    blurRadius: 18,
                  ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < widget.values.length; i++)
                            Padding(
                              padding: EdgeInsets.only(bottom: 0.02.h),
                              child: Row(
                                children: [
                                  CustomChartDataRow(
                                      isSmall: widget.isSmall,
                                      dataColor: customColors[i],
                                      textData: widget.texts[i],
                                      isHorizontal: widget.isHorizontal,
                                      isPerformanceScreen:
                                          widget.isPerformanceScreen),
                                  CustomChartDataValues(
                                      valueText: widget.values[i],
                                      detailsProgress: widget.detailsProgress,
                                      isHorizontal: widget.isHorizontal,
                                      isSmall: widget.isSmall,
                                      isPerformanceScreen:
                                          widget.isPerformanceScreen)
                                ],
                              ),
                            ),
                          SizedBox(
                            height: 0.015.h,
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(bottom: 0.01.h),
                                child: Icon(Icons.square,
                                    size: 0.022.h,
                                    color: Colors.transparent //customColors[i],
                                    ),
                              ),
                              SizedBox(width: 0.01.w),
                              Container(
                                //  color: Colors.amber,
                                width: 0.18.w, //widget.textwidth.w,
                                child: Text(
                                  "Total".tr, // widget.texts[i].tr,
                                  style: AppFontStyle.cairoRegularStyle
                                      .copyWith(
                                          fontSize: FontConstants.fontSize024.h,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer,
                                          fontWeight: FontWeight.w600,
                                          height: 0.001.h),
                                ),
                              ),
                              SizedBox(width: 0.025.h),
                              Text(
                                "${totalSum}", //widget.values[i] + ' Projects'.tr,
                                style: AppFontStyle.cairoRegularStyle.copyWith(
                                  fontSize: FontConstants.fontSize024.h,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                  fontWeight: FontWeight.w600,
                                  //height: 0.0015.h
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                  //   color: Colors.amber,
                  height: 0.3.h,
                  width: 0.35.h,
                  child: SfCircularChart(
                    annotations: <CircularChartAnnotation>[
                      CircularChartAnnotation(widget: SizedBox())
                    ],
                    series: <CircularSeries>[
                      PieSeries<ChartData, String>(
                        dataSource: data,
                        xValueMapper: (ChartData info, _) => info.text,
                        yValueMapper: (ChartData info, _) => info.values,
                        pointColorMapper: (ChartData info, int index) {
                          if (index >= 0 && index < customColors.length) {
                            return customColors[index];
                          }
                          return Colors.grey;
                        },
                        dataLabelSettings: DataLabelSettings(
                          isVisible: false,
                          labelPosition: ChartDataLabelPosition.inside,
                          textStyle: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: FontConstants.fontSize016.h,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        radius: isTablet ? '94%' : '0%',
                        explodeOffset: isTablet ? '0%' : '3%',
                        explode: false,
                        explodeAll: false,
                      ),
                    ],
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.text, this.values);

  final String text;
  final double values;
}
