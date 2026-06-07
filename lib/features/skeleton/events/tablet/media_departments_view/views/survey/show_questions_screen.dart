import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/events/components/survey_components/test_question_container.dart';

class ShowQuestionsScreen extends StatelessWidget {
  const ShowQuestionsScreen({
    super.key,
    this.survey,
  });

  final SurveyModel? survey;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SurveyController>(
      init: SurveyController(),
      builder: (controller) {
        bool isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;

        double height = 0.01.h;

        if (survey == null) {
          return Center(
            child: Text(
              "No survey available".tr,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: isPortrait
                    ? FontConstants.fontSize016.h
                    : FontConstants.fontSize022.h,
                fontWeight: FontWeight.w600,
                height: 1.8,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0.w, vertical: 0.0.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0.015.w, vertical: 0.015.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  child: Text(
                    "Thank you for participating in our event. We hope you had as much fun attending as we did organizing it. We want to hear your feedback so we can keep improving our logistics and content. Please fill this quick survey and let us know your thoughts (your answers will be anonymous)."
                        .tr
                        .tr,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isPortrait
                          ? FontConstants.fontSize016.h
                          : FontConstants.fontSize022.h,
                      fontWeight: FontWeight.w600,
                      height: 1.8,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ),
                SizedBox(
                  height: height,
                ),
                SizedBox(
                  height: height,
                ),
                ...survey!.questions.map((question) {
                  return question.status == "deleted"
                      ? const SizedBox.shrink()
                      : TestQuestionContainer(
                          mcqAnswerState: (value) {},
                          isDisabled: true,
                          textAnswer: TextEditingController(),
                          mcqAnswer: TextEditingController(),
                          hasPhoto: true,
                          qusestionType: question.questionType,
                          question: question.question,
                          hintText: "answer",
                          imagepath: null,
                          choices: question.choices,
                          isRequired: question.isRequired,
                        );
                }).toList(),
                SizedBox(
                  height: height,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
