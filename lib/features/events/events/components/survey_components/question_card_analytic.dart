import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/events/components/survey_components/custom_chart.dart';

class QuestionCardAnalytic extends StatefulWidget {
  const QuestionCardAnalytic({
    super.key,
    required this.count,
    required this.question,
    required this.questionType,
    this.options,
    this.optionsCount,
    this.textAnswer,
  });
  final int count;
  final String question;
  final String? textAnswer;
  final List<String>? options;
  final List<String>? optionsCount;
  final int questionType; // 1 for essay 2 for mcq 3 for true and false

  @override
  State<QuestionCardAnalytic> createState() => _QuestionCardAnalyticState();
}

class _QuestionCardAnalyticState extends State<QuestionCardAnalytic> {
  List<ChartData> getChartData() {
    List<ChartData>? temp = [];
    List<Color> assignmnetsColors = [
      MyThemeData.signOut,
      MyThemeData.bubbleColor,
      MyThemeData.blue,
      MyThemeData.red
    ];
    for (int i = 0; i < widget.optionsCount!.length; i++) {
      temp.add(ChartData(widget.options![i],
          double.parse(widget.optionsCount![i]), assignmnetsColors[i]));
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.02.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // Get.locale.toString().contains('en')
              //     ?
              //"Q ${widget.count})
              widget.question,
              //    : "س ${convertNumberToArabic(widget.count.toString())})  ${widget.question}",
              style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isTablet
                      ? isPortrait
                          ? FontConstants.fontSize019.h
                          : FontConstants.fontSize015.w
                      : FontConstants.fontSize019.h,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.inverseSurface),
            ),
            SizedBox(
              height: 0.02.h,
            ),
            widget.questionType == 1
                ? Text(
                    widget.textAnswer!,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: isTablet
                            ? isPortrait
                                ? FontConstants.fontSize017.h
                                : FontConstants.fontSize013.w
                            : FontConstants.fontSize017.h,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.scrim),
                  )
                : widget.questionType == 2
                    ? SizedBox(
                        height: 0.23.h,
                        child: CustomChartContainer(
                          isTransparent: true,
                          isAttendanceRate: true,
                          isAssignmentScreen: true,
                          width: double.infinity,
                          height: double.infinity,
                          textSizeTexts: 0.023,
                          textSizeValues: 0.021,
                          isExamsScreen: true,
                          title: '',
                          chartData: getChartData(),
                          texts: widget.options!,
                          values: widget.optionsCount!,
                        ),
                      )
                    : SizedBox(
                        height: 0.22.h,
                        child: CustomChartContainer(
                          isTransparent: true,
                          isAttendanceRate: false,
                          isAssignmentScreen: true,
                          isQuestion: true,
                          width: double.infinity,
                          height: double.infinity,
                          textSizeTexts: 0.023,
                          textSizeValues: 0.021,
                          title: '',
                          chartData: getChartData(),
                          texts: widget.options!,
                          values: widget.optionsCount!,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
