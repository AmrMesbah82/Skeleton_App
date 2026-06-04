import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

//Date Created :14/November/2023
// Developer Name : Bassem Mohamed
//App Version :  V2
// Date of Last Edit :14/November/2023 by Bassem
// Objectives: this class  created to Customize the chart data labels in the Perormance widget

// ignore: must_be_immutable
class CustomPerformaceDataRow extends StatefulWidget {
  CustomPerformaceDataRow({
    super.key,
    required this.dataColor,
    required this.textData,
    this.totalElements,
    this.minsValue,
    required this.valueText,
  });

  Color dataColor;
  String textData;
  String valueText;
  String? minsValue;
  int? totalElements;

  @override
  State<CustomPerformaceDataRow> createState() =>
      _CustomPerformaceDataRowState();
}

class _CustomPerformaceDataRowState extends State<CustomPerformaceDataRow> {
  List<int> calculateHoursAndMinutes(
      List<String>? hoursList, List<String>? minsList) {
    int totalMinutes = 0;

    if (minsList != null) {
      for (int i = 0; i < minsList.length; i++) {
        totalMinutes += int.parse(minsList[i]);
      }
    }

    int additionalHours = totalMinutes ~/ 60;
    int remainingMinutes = totalMinutes % 60;

    int totalHours = 0;
    if (hoursList != null) {
      for (int i = 0; i < hoursList.length; i++) {
        totalHours += int.parse(hoursList[i]);
      }
    }

    totalHours += additionalHours;

    return [totalHours, remainingMinutes];
  }

  Color textColorBasedOnBackground(Color backgroundColor) {
    // Calculate luminance of the background color
    double luminance = backgroundColor.computeLuminance();

    // Determine whether the background color is dark or light
    bool isDark = luminance > 0.5;

    // Return white if the background is dark, otherwise return black
    return isDark ? MyThemeData.colorBlack : MyThemeData.colorWhite;
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    List<String>? sampleHours = widget.valueText
        .split(','); // Assuming valueText contains hours separated by comma
    List<String>? sampleMinutes = widget.minsValue
        ?.split(','); // Assuming minsValue contains minutes separated by comma

    List<int> hoursAndMinutes =
        calculateHoursAndMinutes(sampleHours, sampleMinutes);
    int totalHours = hoursAndMinutes[0];
    int totalMinutes = hoursAndMinutes[1];

    // Check if there are remaining minutes
    String hoursAndMinutesString =
        '$totalHours ${"Hours".tr} $totalMinutes ${"Mins".tr}';

    // Extract the value of total elements from the widget
    int? total =
        widget.totalElements ?? 1; // Default to 1 to avoid division by zero

    // Calculate the percentage for each element based on the total number of elements
    double percentage = (100 / total);

    // Convert the percentage to a string with exactly two decimal places
    String percentageString = percentage.toStringAsFixed(0);
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return isTablet && !isPortrait
        ? Row(
            children: <Widget>[
              Text(
                Get.locale.toString().contains('en')
                    ? "$percentageString%"
                    : convertNumberToArabic("$percentageString%"),
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: FontConstants.fontSize020.h,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 0.01.w),
              Container(
                //    color: Colors.amber,
                width: 0.15.w, //widget.textwidth.w,
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  widget.textData.capitalize as String, // widget.texts[i].tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: FontConstants.fontSize020.h,
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    fontWeight: FontWeight.w600,
                    // height: 0.001.h
                  ),
                ),
              ),
              SizedBox(width: 0.01.w),
              Container(
                decoration: BoxDecoration(
                  color: widget.dataColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                width: Get.locale.toString().contains('en') ? 0.18.h : 0.127.w,
                child: Padding(
                  padding: EdgeInsets.all(0.01.h),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      Get.locale.toString().contains('en')
                          ? hoursAndMinutesString.tr
                          : convertNumberToArabic(hoursAndMinutesString.tr),
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: FontConstants.fontSize020.h,
                          // go back
                          color: textColorBasedOnBackground(widget.dataColor),
                          fontWeight: FontWeight.w600,
                          height: 1.1),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          )
        : isTablet && isPortrait
            ? Column(
                children: <Widget>[
                  Text(
                    "$percentageString%",
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize017.h,
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        fontWeight: FontWeight.w600,
                        height: 1.4),
                  ),
                  SizedBox(width: 0.01.w),
                  Container(
                    //      color: Colors.amber,
                    // width: 0.25.w,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      widget.textData.capitalize
                          as String, // widget.texts[i].tr,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: FontConstants.fontSize017.h,
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          fontWeight: FontWeight.w600,
                          // height: 0.001.h
                          height: 1.5),
                    ),
                  ),
                  SizedBox(width: 0.01.w),
                  Container(
                    decoration: BoxDecoration(
                      color: widget.dataColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width:
                        Get.locale.toString().contains('en') ? 0.25.w : 0.25.w,
                    child: Padding(
                      padding: EdgeInsets.all(0.01.h),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          hoursAndMinutesString.tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: FontConstants.fontSize014.h,
                              color: MyThemeData.colorBlack,
                              fontWeight: FontWeight.w600,
                              height: 1.1),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: <Widget>[
                  Text(
                    "$percentageString%",
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize017.h,
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        fontWeight: FontWeight.w600,
                        height: 1.4),
                  ),
                  SizedBox(width: 0.01.w),
                  Container(
                    //      color: Colors.amber,
                    // width: 0.25.w,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      widget.textData.capitalize
                          as String, // widget.texts[i].tr,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: FontConstants.fontSize017.h,
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          fontWeight: FontWeight.w600,
                          // height: 0.001.h
                          height: 1.5),
                    ),
                  ),
                  SizedBox(width: 0.01.w),
                  Container(
                    decoration: BoxDecoration(
                      color: widget.dataColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: Get.locale.toString().contains('en') ? 0.3.w : 0.3.w,
                    child: Padding(
                      padding: EdgeInsets.all(0.01.h),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          hoursAndMinutesString.tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: FontConstants.fontSize014.h,
                              color: MyThemeData.colorBlack,
                              fontWeight: FontWeight.w600,
                              height: 1.1),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }
}
