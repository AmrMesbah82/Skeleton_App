import 'package:demo_app/feature/events/events/controllers/survey_controller.dart/model/question_model.dart';
import 'package:demo_app/feature/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/feature/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/events/components/survey_components/employee_detail_row.dart';
import 'package:demo_app/feature/events/components/survey_components/question_card_analytic.dart';

import 'package:demo_app/feature/events/models/more_models/employee_submission_model.dart';

class ShowAnalyticsScreen extends StatefulWidget {
  const ShowAnalyticsScreen({
    super.key,
    this.survey,
  });

  final SurveyModel? survey;

  @override
  State<ShowAnalyticsScreen> createState() => _ShowAnalyticsScreenState();
}

class _ShowAnalyticsScreenState extends State<ShowAnalyticsScreen> {
  final HapticController hapticController = Get.put(HapticController());
  final SurveyController surveyController = Get.put(SurveyController());

  int viewIndex = 0;
  int respondedCount = 0;

  List<EmployeeSubmissionModel> employeeSubmissionList = [];

  @override
  void initState() {
    respondedCount = widget.survey!.partitcipants
        .where((participant) => participant.status == "Responded")
        .toList()
        .length;
    employeeSubmissionList =
        surveyController.getFilledSurvey(widget.survey!.id);
    super.initState();
  }

  List<List<String>> getOptionsDetails(QuestionModel question) {
    List<String> options = question.choices
        .split(',')
        .map((word) => word.trim())
        .where((word) => word.isNotEmpty)
        .toList();

    List<int> optionsCount = [];

    for (int i = 0; i < options.length; i++) {
      optionsCount.add(0);
    }

    if (employeeSubmissionList.isNotEmpty) {
      for (var studnetAnswer in employeeSubmissionList) {
        for (var questionFirebaseModel in studnetAnswer.questionModel) {
          if (questionFirebaseModel.questionTitle!.last! == question.question) {
            for (int i = 0; i < options.length; i++) {
              if (options[i] == questionFirebaseModel.answer!.last) {
                optionsCount[i]++;
              }
            }
            break;
          }
        }
      }
    }

    List<String> temp = [];
    for (int i = 0; i < optionsCount.length; i++) {
      temp.add(optionsCount[i].toString());
    }

    return [options, temp];
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    double height = 0.01.h;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0.w, vertical: 0.0.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !isPortrait
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 0.69.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.015.w, vertical: 0.015.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${"Response Time".tr} :",
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isPortrait
                                    ? FontConstants.fontSize016.h
                                    : FontConstants.fontSize022.h,
                                fontWeight: FontWeight.w600,
                                height: 1.8,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                              ),
                            ),
                            SizedBox(
                              height: height,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: EmployeeContent(
                                      isAssets: true,
                                      title: "Maximum".tr,
                                      value: Get.locale
                                              .toString()
                                              .contains('en')
                                          ? "${widget.survey?.maxResponseTime}"
                                          : convertNumberToArabic(
                                              widget.survey!.maxResponseTime)),
                                ),
                                Expanded(
                                  child: EmployeeContent(
                                      isAssets: true,
                                      title: "Average".tr,
                                      value:
                                          Get.locale.toString().contains('en')
                                              ? "${widget.survey?.averageTime}"
                                              : convertNumberToArabic(
                                                  widget.survey!.averageTime)),
                                ),
                                Expanded(
                                  child: EmployeeContent(
                                      isAssets: true,
                                      title: "Minimum".tr,
                                      value: Get.locale
                                              .toString()
                                              .contains('en')
                                          ? "${widget.survey?.minResponseTime}"
                                          : convertNumberToArabic(
                                              widget.survey!.minResponseTime)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 0.02.w,
                      ),
                      const Spacer(),
                      Container(
                        width: 0.15.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.015.w, vertical: 0.015.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${'Total Participants'.tr} :",
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isPortrait
                                    ? FontConstants.fontSize016.h
                                    : FontConstants.fontSize022.h,
                                fontWeight: FontWeight.w600,
                                height: 1.8,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                              ),
                            ),
                            SizedBox(
                              height: height,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    Get.locale.toString().contains('en')
                                        ? "$respondedCount"
                                        : convertNumberToArabic(
                                            convertNumberToArabic(
                                                respondedCount.toString())),
                                    softWrap: true,
                                    maxLines: 1,
                                    style:
                                        AppFontStyle.cairoRegularStyle.copyWith(
                                      fontSize: isPortrait
                                          ? FontConstants.fontSize017.h
                                          : FontConstants.fontSize014.w,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.02.h),
                        child: Container(
                          // width: 0.69.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 0.015.w : 0.04.w,
                              vertical: 0.015.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${"Response Time".tr} :",
                                style: AppFontStyle.cairoRegularStyle.copyWith(
                                  fontSize: isPortrait
                                      ? FontConstants.fontSize016.h
                                      : FontConstants.fontSize022.h,
                                  fontWeight: FontWeight.w600,
                                  height: 1.8,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                ),
                              ),
                              SizedBox(
                                height: height,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  EmployeeContent(
                                      isAssets: true,
                                      title: "Maximum".tr,
                                      value: Get.locale
                                              .toString()
                                              .contains('en')
                                          ? "${widget.survey?.maxResponseTime}"
                                          : convertNumberToArabic(
                                              widget.survey!.maxResponseTime)),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 0.015.h),
                                    child: EmployeeContent(
                                        isAssets: true,
                                        title: "Average".tr,
                                        value: Get.locale
                                                .toString()
                                                .contains('en')
                                            ? "${widget.survey?.averageTime}"
                                            : convertNumberToArabic(
                                                widget.survey!.averageTime)),
                                  ),
                                  EmployeeContent(
                                      isAssets: true,
                                      title: "Minimum".tr,
                                      value: Get.locale
                                              .toString()
                                              .contains('en')
                                          ? "${widget.survey?.minResponseTime}"
                                          : convertNumberToArabic(
                                              widget.survey!.minResponseTime)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        // width: 0.15.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 0.015.w : 0.04.w,
                            vertical: 0.015.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${'Total Participants'.tr} :",
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isPortrait
                                    ? FontConstants.fontSize016.h
                                    : FontConstants.fontSize022.h,
                                fontWeight: FontWeight.w500,
                                height: 1.8,
                                color: MyThemeData.GreyBack,
                              ),
                            ),
                            SizedBox(
                              width: 0.04.w,
                            ),
                            Flexible(
                              child: Text(
                                Get.locale.toString().contains('en')
                                    ? "$respondedCount"
                                    : convertNumberToArabic(
                                        respondedCount.toString()),
                                softWrap: true,
                                maxLines: 1,
                                style: AppFontStyle.cairoRegularStyle.copyWith(
                                  height: 1.7,
                                  fontSize: isPortrait
                                      ? FontConstants.fontSize017.h
                                      : FontConstants.fontSize014.w,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 0.02.h,
                      ),
                    ],
                  ),
            if (!isPortrait) SizedBox(height: height),
            if (!isPortrait) SizedBox(height: height),
            ListView.builder(
padding: EdgeInsets.zero,
              itemCount: widget.survey?.questions.length ?? 0,
              physics:const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var question = widget.survey?.questions[index];
                if (question!.status != 'deleted' &&
                    (question.questionType == "Multiple Choice" ||
                        question.questionType == "Drop Menu" ||
                        question.questionType == "True Or False")) {
                  viewIndex++;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 0.015.h),
                    child: QuestionCardAnalytic(
                      count: viewIndex + 1,
                      question: question.question,
                      options: getOptionsDetails(question)[0],
                      textAnswer: question.answer,
                      optionsCount: getOptionsDetails(question)[1],
                      questionType:
                          question.questionType == "Multiple Choice" ||
                                  question.questionType == "Drop Menu" ||
                                  question.questionType == "True Or False"
                              ? 2
                              : 1,
                    ),
                  );
                } else {
                  if (question.status != 'deleted') {
                    viewIndex++;
                  }
                  return const SizedBox.shrink();
                }
              },
            ),
            SizedBox(height: height),
          ],
        ),
      ),
    );
  }
}
