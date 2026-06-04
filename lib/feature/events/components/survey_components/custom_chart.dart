// ignore_for_file: unrelated_type_equality_checks, sized_box_for_whitespace, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/components/home_components/custom_chart_data.dart';
import 'package:demo_app/components/home_components/custom_chart_values.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';
import 'package:demo_app/feature/events/components/survey_components/custom_performance_row.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//Date Created :5/September/2023
// Developer Name : Mazen shabaan
//App Version : Version Mobile
// Date of Last Edit :23/Novmember/2023 by Bassem
// Objectives: this class created to Customize the chart widget in the home screen

class CustomChartContainer extends StatefulWidget {
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
  final bool isPerformanceCard;
  final bool? isAttendanceRate;
  List<ChartData>? chartData;
  final bool isAssignmentScreen;
  final bool isQuestion;
  final bool isExamsScreen;

  CustomChartContainer({
    required this.title,
    required this.texts,
    required this.values,
    this.mins,
    this.isAttendanceRate,
    required this.width,
    this.height = 0.300,
    this.isQuestion = false,
    this.isAssignmentScreen = false,
    this.chartData,
    this.textSizeTexts = 0.023,
    this.textSizeValues = 0.021,
    this.widthDiff = 0.008,
    this.textwidth = 0.16,
    this.show = true,
    this.isPerformanceCard = false,
    this.isSmall = false,
    this.detailsProgress = false,
    this.isTransparent = false,
    this.isHorizontal = false,
    this.isExamsScreen = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomChartContainer> createState() => _CustomChartContainerState();
}

class _CustomChartContainerState extends State<CustomChartContainer> {
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
    MyThemeData.lightPrimary,
    MyThemeData.signOut,
    MyThemeData.colorGreydark,
    MyThemeData.colorLightGrey,
    MyThemeData.colorWhiteDark,
    MyThemeData.colorGreyDisabled,
    MyThemeData.colorDarkGrey,
  ];
  //MyThemeData.colorGreydark,

  final List<String> period = [
    'Weekly'.tr,
    'Monthly'.tr,
    'Yearly'.tr,
  ];

  String? selectedPeriod = 'Monthly'.tr;
  // List<Color> attendanceRateColors = [
  //   selectedColor,
  //   MyThemeData.greenN,
  //   MyThemeData.blueN,
  //   MyThemeData.greenN
  // ];
  List<Color> assignmnetsColors = [
    MyThemeData.signOut,
    MyThemeData.bubbleColor,
    MyThemeData.blue,
    MyThemeData.red
  ];
  // List<Color> assignmentRateColors = [
  //   selectedColor,
  //   MyThemeData.red,
  //   MyThemeData.blueN,
  //   MyThemeData.greenN
  // ];

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
      data.add(ChartData(widget.texts[i].capitalize as String,
          double.parse(widget.values[i]), assignmnetsColors[i]));
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
        boxShadow: themeController.currentTheme == MyThemeData.lightTheme
            ? [
                if (widget.isTransparent == false)
                  BoxShadow(
                    color: MyThemeData.colorGrey.withOpacity(0.2),
                    blurRadius: 18,
                  ),
              ]
            : null,
      ),
      child: Column(
        children: [
          widget.isAttendanceRate == true
              ? const SizedBox.shrink()
              : widget.isQuestion
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.only(
                          bottom: 0.02.h,
                          top: 0.01.h,
                          right: 0.02.h,
                          left: 0.02.h),
                      child: Row(
                        children: [
                          widget.isPerformanceCard
                              ? SvgPicture.asset(
                                  'assets/icons/performance.svg',
                                )
                              : SvgPicture.asset(
                                  'assets/icons/attendance.svg',
                                ),
                          SizedBox(width: 0.01.h),
                          Text(
                            widget.isPerformanceCard
                                ? "Performance".tr
                                : "Attendance".tr,
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: FontConstants.fontSize022.h,
                                color: themeController.currentTheme ==
                                        MyThemeData.lightTheme
                                    ? MyThemeData.colorBlack
                                    : MyThemeData.colorWhiteDark,
                                fontWeight: FontWeight.w600,
                                height: 0.002.h),
                          ),
                          Spacer(),
                          CustomDropdownButton2(
                            buttonPadding:
                                EdgeInsets.symmetric(horizontal: 0.01.h),
                            iconHeight: 0.022.h,
                            //borded: true,
                            buttonWidth: 0.13.h,
                            dropdownWidth: 0.16.h,
                            buttonHeight: 0.035.h,
                            isBottomSheet: true,
                            hint: 'Monthly'.tr,
                            dropdownItems: period,
                            value: selectedPeriod,
                            onChanged: (String? value) {
                              setState(() {
                                selectedPeriod = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  //      color: Colors.amber,
                  height: widget.isPerformanceCard
                      ? 0.29.h
                      : widget.isAttendanceRate == true
                          ? 0.18.h
                          : 0.22.h,
                  width: widget.isPerformanceCard ? 0.4.h : 0.18.h,
                  child: SfCircularChart(
                    annotations: <CircularChartAnnotation>[
                      widget.isPerformanceCard
                          ? CircularChartAnnotation(
                              widget: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Hours Tracked'.tr,
                                      style: AppFontStyle.cairoRegularStyle
                                          .copyWith(
                                        fontSize: FontConstants.fontSize022.h,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 0.01.h),
                                      child: Text(
                                        '$totalHours ${'Hours'.tr}' +
                                            ' $totalMinutes ${'Mins'.tr}',
                                        style: AppFontStyle.cairoRegularStyle
                                            .copyWith(
                                          fontSize: FontConstants.fontSize021.h,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : CircularChartAnnotation(widget: Container())
                    ],
                    series: <CircularSeries>[
                      widget.isPerformanceCard
                          ? DoughnutSeries<ChartData, String>(
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
                                textStyle:
                                    AppFontStyle.cairoRegularStyle.copyWith(
                                  fontSize: FontConstants.fontSize016.h,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              radius: '100%',
                              innerRadius: '80%',
                              explodeOffset: isTablet ? '0%' : '3%',
                              explode: false,
                              explodeAll: false,
                            )
                          : widget.isAttendanceRate == true
                              ? DoughnutSeries<ChartData, String>(
                                  dataSource: widget.chartData,
                                  xValueMapper: (ChartData info, _) =>
                                      info.text,
                                  yValueMapper: (ChartData info, _) =>
                                      info.values,
                                  pointColorMapper:
                                      (ChartData info, int index) {
                                    if (index >= 0 &&
                                        index < customColors.length) {
                                      return customColors[index];
                                    }
                                    return Colors.grey;
                                  },
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: false,
                                    labelPosition:
                                        ChartDataLabelPosition.inside,
                                    textStyle:
                                        AppFontStyle.cairoRegularStyle.copyWith(
                                      fontSize: FontConstants.fontSize016.h,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  radius: '100%',
                                  innerRadius: '70%',
                                  // explodeOffset: isTablet ? null : '3%',
                                  explode: false,
                                  explodeAll: false,
                                )
                              : PieSeries<ChartData, String>(
                                  dataSource: data,
                                  xValueMapper: (ChartData info, _) =>
                                      info.text,
                                  yValueMapper: (ChartData info, _) =>
                                      info.values,
                                  pointColorMapper:
                                      (ChartData info, int index) {
                                    if (index >= 0 &&
                                        index < customColors.length) {
                                      return customColors[index];
                                    }
                                    return Colors.grey;
                                  },
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: false,
                                    labelPosition:
                                        ChartDataLabelPosition.inside,
                                    textStyle:
                                        AppFontStyle.cairoRegularStyle.copyWith(
                                      fontSize: FontConstants.fontSize016.h,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  radius: isTablet ? '94%' : '90%',
                                  explodeOffset: isTablet ? '0%' : '3%',
                                  explode: false,
                                  explodeAll: false,
                                ),
                    ],
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                    ),
                  )),
              !widget.isPerformanceCard
                  ? Column(
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
                                    padding: EdgeInsets.only(
                                        top: 0.02.h,
                                        bottom: 0.0.h,
                                        left: isTablet ? 0.1.w : 0.01.w,
                                        right: 0.01.w),
                                    child: Row(
                                      children: [
                                        CustomChartDataRow(
                                            isSmall: widget.isSmall,
                                            dataColor: customColors[i],
                                            textData: widget.texts[i],
                                            isHorizontal: widget.isHorizontal),
                                        CustomChartDataValues(
                                          valueText: widget.values[i],
                                          detailsProgress:
                                              widget.detailsProgress,
                                          isHorizontal: widget.isHorizontal,
                                          isSmall: widget.isSmall,
                                        )
                                      ],
                                    ),
                                  ),
                                widget.isAttendanceRate == true
                                    ? const SizedBox.shrink()
                                    : Padding(
                                        padding: EdgeInsets.only(
                                          top: 0.02.h,
                                          left: isTablet ? 0.08.w : 0,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 0.0.h),
                                              child: Icon(Icons.square,
                                                  size: 0.018.h,
                                                  color: Colors
                                                      .transparent //customColors[i],
                                                  ),
                                            ),
                                            SizedBox(width: 0.01.w),
                                            Container(
                                              //  color: Colors.amber,
                                              width: Get.locale
                                                      .toString()
                                                      .contains('en')
                                                  ? 0.13.w
                                                  : 0.23
                                                      .w, //widget.textwidth.w,
                                              child: Text(
                                                "Total"
                                                    .tr, // widget.texts[i].tr,
                                                style: AppFontStyle
                                                    .cairoRegularStyle
                                                    .copyWith(
                                                        fontSize: FontConstants
                                                            .fontSize020.h,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .tertiaryContainer,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        height: 0.001.h),
                                              ),
                                            ),
                                            SizedBox(width: 0.025.h),
                                            Text(
                                              "${convertNumberToArabic(totalSum.toString())}", //widget.values[i] + ' Projects'.tr,
                                              style: AppFontStyle
                                                  .cairoRegularStyle
                                                  .copyWith(
                                                fontSize:
                                                    FontConstants.fontSize020.h,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiaryContainer,
                                                fontWeight: FontWeight.w600,
                                                //height: 0.0015.h
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      height: 0.26.h,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < widget.values.length; i++)
                              Padding(
                                padding: EdgeInsets.only(bottom: 0.02.h),
                                child: Row(
                                  children: [
                                    CustomPerformaceDataRow(
                                      valueText: widget.values[i],
                                      dataColor: customColors[i],
                                      textData: widget.texts[i],
                                      totalElements: widget.values.length,
                                      minsValue: widget.mins![i],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.text, this.values, this.color);

  final String text;
  final double values;
  final Color color;
}
