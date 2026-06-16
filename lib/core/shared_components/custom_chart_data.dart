//Date Created :16/October/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :16/October/2023 by mazen
// Objectives: this class  created to Customize the chart data labels in the dashboard widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/theme/app_font_size.dart';

// ignore: must_be_immutable
class CustomChartDataRow extends StatefulWidget {
  CustomChartDataRow(
      {super.key,
      required this.isSmall,
      required this.dataColor,
      required this.textData,
      required this.isHorizontal,
      this.isPerformanceScreen,
      this.isSmallContainer,
      this.width});
  bool isSmall;
  Color dataColor;
  String textData;
  bool isHorizontal;
  bool? isPerformanceScreen;
  bool? isSmallContainer;
  double? width;

  @override
  State<CustomChartDataRow> createState() => _CustomChartDataRowState();
}

class _CustomChartDataRowState extends State<CustomChartDataRow> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              bottom: widget.isPerformanceScreen == true ? 0.003.h : 0.00.h),
          child: Icon(Icons.square,
              size: widget.isPerformanceScreen == true ? 0.022.h :isPortrait?0.013.h :0.018.h,
              color: widget.dataColor //customColors[i],
              ),
        ),
        SizedBox(width: widget.isSmallContainer == true ? 0.005.h : 0.01.w),
        Container(
        //     color: Colors.red,
          width: widget.isPerformanceScreen == true
              ? 0.14.w
              : widget.isSmallContainer == true
                  ? null
                  : isTablet
                      ? (isPortrait ? 0.12.w : 0.1.w)
                      : 0.25.w, //widget.textwidth.w,
          child: Text(
            widget.textData.tr.capitalize as String, // widget.texts[i].tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: widget.isPerformanceScreen == true
                  ? FontConstants.fontSize024.h
                  : isTablet
                      ?isPortrait?FontConstants.fontSize016.h :FontConstants.fontSize020.h
                      : FontConstants.fontSize017.h,
              color: Theme.of(context).colorScheme.tertiaryContainer,
              fontWeight: FontWeight.w600,
              height: widget.isPerformanceScreen == true
                  ? 0.002.h
                  : isTablet
                      ? 1.6
                      : 1.5,
            ),
          ),
        ),
        SizedBox(width: widget.isSmallContainer == true ? 0.015.h : 0),
      ],
    );
  }
}
