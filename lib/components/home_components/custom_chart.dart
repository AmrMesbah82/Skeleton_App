// ignore_for_file: unrelated_type_equality_checks, sized_box_for_whitespace, unused_local_variable
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/components/home_components/custom_chart_data.dart';
import 'package:demo_app/components/home_components/custom_chart_values.dart';
import 'package:demo_app/components/home_components/custom_performance_row.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';
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
  final bool isProjectCard;
  final bool? isEmployee;
  final bool? isMeetings;
  final ValueChanged<String> onPeriodChanged;

  const CustomChartContainer({
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
    this.isPerformanceCard = false,
    this.isSmall = false,
    this.detailsProgress = false,
    this.isTransparent = false,
    this.isHorizontal = false,
    this.isProjectCard = false,
    this.isEmployee = false,
    this.isMeetings = false,
    required this.onPeriodChanged,
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
    MyThemeData.signOut,
    MyThemeData.colorGrey,
    MyThemeData.lightPrimary,
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

  @override
  Widget build(BuildContext context) {
    List<Color> modifiedColors = widget.isProjectCard == true
        ? [MyThemeData.warning, MyThemeData.signOut, MyThemeData.unBlock]
        : customColors;
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
          double.parse(widget.values[i])));
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
          Padding(
            padding: EdgeInsets.only(
              bottom: isTablet ? 0.02.h : 0.00.h,
              top: (isPortrait && isTablet
                  ? 0.015.h
                  : isTablet
                      ? 0.01.h
                      : 0.01.h),
              right: isTablet
                  ? (isPortrait && isTablet ? 0.03.w : 0.02.h)
                  : 0.03.w,
              left: isTablet
                  ? (isPortrait && isTablet ? 0.03.w : 0.02.h)
                  : 0.03.w,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 0.02.h,
                      backgroundColor: MyThemeData.signOut,
                      child: widget.isPerformanceCard
                          ? Padding(
                              padding: EdgeInsets.all(0.01.h),
                              child: SvgPicture.asset(
                                'assets/images/diagram_new.svg',
                                height: isTablet
                                    ? (isTablet
                                        ? isPortrait
                                            ? 0.025.h
                                            : 0.035.h
                                        : null)
                                    : 0.04.h,
                                color: MyThemeData().contrastColor(),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.all(0.01.h),
                              child: SvgPicture.asset(
                                'assets/images/employee_icon.svg',
                                height: isTablet
                                    ? (isTablet
                                        ? isPortrait
                                            ? 0.025.h
                                            : 0.035.h
                                        : null)
                                    : 0.04.h,
                                color: MyThemeData().contrastColor(),
                              ),
                            ),
                    ),
                    SizedBox(width: 0.01.h),
                    Text(
                      widget.isPerformanceCard
                          ? "Performance".tr
                          : widget.isProjectCard
                              ? "Project".tr
                              : widget.isMeetings == true
                                  ? "Meetings".tr
                                  : "Attendance".tr,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: isTablet
                              ? FontConstants.fontSize022.h
                              : FontConstants.fontSize019.h,
                          color: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhiteDark,
                          fontWeight: FontWeight.w600,
                          height: isTablet && isPortrait ? 1.8 : 0.002.h),
                    ),
                    if (widget.isProjectCard != true ||
                        widget.isEmployee == false)
                      Spacer(),
                    if (widget.isProjectCard != true &&
                        widget.isEmployee == false)
                      CustomDropdownButton2(
                        buttonPadding: isTablet
                            ? EdgeInsets.symmetric(horizontal: 0.01.h)
                            : EdgeInsets.only(
                                left: Get.locale.toString().contains('en')
                                    ? 0.02.w
                                    : 0,
                                right: Get.locale.toString().contains('ar')
                                    ? 0.02.w
                                    : 0,
                              ),
                        iconHeight: 0.022.h,
                        //borded: true,
                        buttonWidth: isTablet
                            ? (isTablet && isPortrait ? 0.18.w : 0.13.h)
                            : 0.23.w,
                        dropdownWidth: isTablet
                            ? (isTablet && isPortrait ? 0.18.w : 0.13.h)
                            : 0.23.w,
                        buttonHeight: 0.035.h,
                        isBottomSheet: true,

                        hint: 'Monthly'.tr,
                        dropdownItems: period,
                        value: selectedPeriod,
                        onChanged: (String? value) {
                          setState(() {
                            widget.onPeriodChanged(value!);
                            selectedPeriod = value;
                          });
                        },
                      ),
                  ],
                ),
                if (isTablet != true)
                  Padding(
                    padding: EdgeInsets.only(top: 0.01.h),
                    child: Container(
                      height: 0.5,
                      width: double.infinity,
                      color: Colors.grey, // Set the color of the line
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widget.isPerformanceCard && !isTablet
                    ? 0.02.w
                    : (isPortrait && isTablet ? 0.04.w : 0.02.h)),
            child: Row(
              mainAxisAlignment: !widget.isPerformanceCard
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    // color: Colors.amber,
                    height: widget.isPerformanceCard
                        ? isTablet
                            ? (isPortrait ? 0.3.h : 0.29.h)
                            : 0.24.h
                        : isTablet
                            ? (isPortrait ? 0.2.h : 0.22.h)
                            : 0.19.h,
                    width: widget.isPerformanceCard
                        ? isTablet
                            ? (isPortrait ? 0.4.w : 0.4.h)
                            : 0.45.w
                        : isTablet
                            ? (isPortrait ? 0.35.w : 0.18.h)
                            : 0.15.h,
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
                                          fontSize: isTablet
                                              ? FontConstants.fontSize022.h
                                              : FontConstants.fontSize018.h,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 0.01.h),
                                        child: Text(
                                          Get.locale.toString().contains('en')
                                              ? '$totalHours ${'Hours'.tr}' +
                                                  ' $totalMinutes ${'Mins'.tr}'
                                              : convertNumberToArabic(
                                                  '$totalHours ${'Hours'.tr}' +
                                                      ' $totalMinutes ${'Mins'.tr}'),
                                          style: AppFontStyle.cairoRegularStyle
                                              .copyWith(
                                            fontSize: isTablet
                                                ? FontConstants.fontSize021.h
                                                : FontConstants.fontSize016.h,
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
                            : CircularChartAnnotation(widget: SizedBox())
                      ],
                      series: <CircularSeries>[
                        widget.isPerformanceCard
                            ? DoughnutSeries<ChartData, String>(
                                dataSource: data,
                                xValueMapper: (ChartData info, _) => info.text,
                                yValueMapper: (ChartData info, _) =>
                                    info.values,
                                pointColorMapper: (ChartData info, int index) {
                                  if (index >= 0 &&
                                      index < modifiedColors.length) {
                                    return modifiedColors[index];
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
                            : PieSeries<ChartData, String>(
                                dataSource: data,
                                xValueMapper: (ChartData info, _) => info.text,
                                yValueMapper: (ChartData info, _) =>
                                    info.values,
                                pointColorMapper: (ChartData info, int index) {
                                  if (index >= 0 &&
                                      index < modifiedColors.length) {
                                    return modifiedColors[index];
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
                                          bottom: isTablet ? 0.015.h : 0.007.h),
                                      child: Row(
                                        children: [
                                          CustomChartDataRow(
                                              isSmall: widget.isSmall,
                                              dataColor: modifiedColors[i],
                                              textData: widget.texts[i],
                                              isHorizontal:
                                                  widget.isHorizontal),
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
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: isTablet
                                            ? (isPortrait && isTablet
                                                ? 0.01.h
                                                : 0.02.h)
                                            : 0.015.h),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 0.0.h),
                                          child: Icon(Icons.square,
                                              size: 0.018.h,
                                              color: Colors
                                                  .transparent //customColors[i],
                                              ),
                                        ),
                                        SizedBox(width: 0.01.w),
                                        Container(
                                          //  color: Colors.amber,
                                          width: isTablet
                                              ? 0.13.w
                                              : 0.35.w, //widget.textwidth.w,
                                          child: Text(
                                            "Total".tr, // widget.texts[i].tr,
                                            style: AppFontStyle
                                                .cairoRegularStyle
                                                .copyWith(
                                                    fontSize: isTablet
                                                        ? FontConstants
                                                            .fontSize020.h
                                                        : FontConstants
                                                            .fontSize017.h,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiaryContainer,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0.001.h),
                                          ),
                                        ),
                                        isTablet
                                            ? SizedBox.shrink()
                                            : Icon(
                                                Icons.circle,
                                                size: 0.012.h,
                                                color: Colors.transparent,
                                              ),
                                        isTablet
                                            ? SizedBox(
                                                width: (isPortrait
                                                    ? 0.057.w
                                                    : 0.025.h))
                                            : SizedBox(width: 0.01.w),
                                        Text(
                                          Get.locale.toString().contains('en')
                                              ? "${totalSum}"
                                              : convertNumberToArabic(
                                                  "${totalSum}"), //widget.values[i] + ' Projects'.tr,
                                          style: AppFontStyle.cairoRegularStyle
                                              .copyWith(
                                            fontSize: isTablet
                                                ? FontConstants.fontSize020.h
                                                : FontConstants.fontSize017.h,
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
                    : Padding(
                        padding: EdgeInsets.only(top: isTablet ? 0 : 0.02.h),
                        child: Container(
                          //    color: Colors.amber,
                          height: isTablet ? 0.26.h : 0.24.h,

                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (int i = 0; i < widget.values.length; i++)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: i == widget.values.length - 1
                                            ? 0.01.h
                                            : 0.02.h),
                                    child: Row(
                                      children: [
                                        CustomPerformaceDataRow(
                                          valueText: widget.values[i],
                                          dataColor: modifiedColors[i],
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
                        ),
                      )
              ],
            ),
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
