import 'dart:async';

import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/events/components/survey_components/test_question_container.dart';
import 'package:demo_app/features/skeleton/events/controllers/employee_controller.dart';
import 'package:demo_app/features/skeleton/events/controllers/events_controllers/event_controller.dart';

import 'package:demo_app/features/skeleton/events/models/more_models/employee_submission_model.dart';

class TakeSurveyScreenMobile extends StatefulWidget {
  const TakeSurveyScreenMobile({
    super.key,
    this.survey,
  });
  final SurveyModel? survey;

  @override
  State<TakeSurveyScreenMobile> createState() => _TakeSurveyScreenMobileState();
}

class _TakeSurveyScreenMobileState extends State<TakeSurveyScreenMobile> {
  final EventsEmployeeController employeeController = Get.put(EventsEmployeeController());
  final SurveyController surveyController = Get.put(SurveyController());
  final EventController eventController = Get.put(EventController());

  int takenTime = 0;
  late Timer _timer;
  late Duration surveyDuration;
  bool isSavedBefore = false;
  EmployeeSubmissionModel? subModel;
  @override
  void initState() {
    employeeController
        .initalizeEmployeeSubmissionAnswer(widget.survey!.questions.length);
    EmployeeSubmissionModel? submissionModel =
        employeeController.findEmployeeSubmission(surveyId: widget.survey!.id);

    if (submissionModel != null) {
      isSavedBefore = true;

      for (int i = 0; i < submissionModel.questionModel.length; i++) {
        employeeController.employeeSubmissionAnswer[i].text =
            submissionModel.questionModel[i].answer!.last!;
      }

      List<String> parts =
          submissionModel.timeTaken.remainingTime!.last!.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int seconds = int.parse(parts[2]);
      surveyDuration =
          Duration(hours: hours, minutes: minutes, seconds: seconds);
    } else {
      surveyDuration = const Duration(hours: 0, minutes: 0, seconds: 0);
    }
    takenTime = surveyDuration.inSeconds;
    getSubModel();
    startTimer();
    super.initState();
  }

  void getSubModel() {
    subModel =
        employeeController.findEmployeeSubmission(surveyId: widget.survey!.id);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        takenTime++;
      });
    });
  }

  String formatTime(int time) {
    int hours = time ~/ 3600;
    int minutes = (time % 3600) ~/ 60;
    int seconds = time % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBarMobile(
                  showIcon: true,
                  title: Get.locale.toString().contains('en')
                      ? widget.survey!.surveyTitle
                      : widget.survey!.surveyTitleArabic,
                  isHome: false,
                ),
                GetBuilder<SurveyController>(
                    init: SurveyController(),
                    builder: (controller) {
                      double height = 0.01.h;
                      if (widget.survey == null) {
                        return Center(
                          child: Text(
                            "No survey available".tr,
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: FontConstants.fontSize016.h,
                              fontWeight: FontWeight.w600,
                              height: 1.8,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                          ),
                        );
                      }
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.04.w),
                          child: CustomScrollView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            slivers: [
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.015.w,
                                            vertical: 0.015.h),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                        child: Text(
                                          "Thank you for participating in our event. We hope you had as much fun attending as we did organizing it. We want to hear your feedback so we can keep improving our logistics and content. Please fill this quick survey and let us know your thoughts (your answers will be anonymous)."
                                              .tr,
                                          style: AppFontStyle.cairoRegularStyle
                                              .copyWith(
                                            fontSize:
                                                FontConstants.fontSize016.h,
                                            fontWeight: FontWeight.w600,
                                            height: 1.8,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inverseSurface,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      if (!isSavedBefore)
                                        ...widget.survey!.questions
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          var question = entry.value;
                                          return TestQuestionContainer(
                                            mcqAnswerState: (value) {},
                                            textAnswer: employeeController
                                                    .employeeSubmissionAnswer[
                                                index],
                                            mcqAnswer: employeeController
                                                    .employeeSubmissionAnswer[
                                                index],
                                            hasPhoto: true,
                                            qusestionType:
                                                question.questionType,
                                            question: question.question,
                                            hintText: question.hintText,
                                            imagepath: null,
                                            choices: question.choices,
                                            isRequired: question.isRequired,
                                          );
                                        }).toList(),
                                      if (isSavedBefore && subModel != null)
                                        ...subModel!.questionModel
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          if (employeeController
                                                      .employeeSubmissionAnswer[
                                                          index]
                                                      .text ==
                                                  'True' ||
                                              employeeController
                                                      .employeeSubmissionAnswer[
                                                          index]
                                                      .text ==
                                                  "False") {
                                            employeeController
                                                    .employeeSubmissionAnswer[index]
                                                    .text =
                                                employeeController
                                                    .employeeSubmissionAnswer[
                                                        index]
                                                    .text
                                                    .tr;
                                          }
                                          var question = entry.value;
                                          return TestQuestionContainer(
                                            mcqAnswerState: (value) {},
                                            textAnswer: employeeController
                                                    .employeeSubmissionAnswer[
                                                index],
                                            mcqAnswer: employeeController
                                                    .employeeSubmissionAnswer[
                                                index],
                                            hasPhoto: true,
                                            qusestionType:
                                                question.questionType!.last!,
                                            question:
                                                question.questionTitle!.last!,
                                            hintText: "",
                                            imagepath: null,
                                            choices: question.choices!.last!,
                                            isRequired:
                                                question.isRequired!.last,
                                          );
                                        }).toList(),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomIconButton(
                                            buttonText: "Save for later",
                                            imagePath: "",
                                            hasIcon: false,
                                            onPressed: () {
                                              employeeController
                                                  .uploadEmployeeSubmission(
                                                      status: "saved",
                                                      surveyModel:
                                                          widget.survey!,
                                                      takenTime:
                                                          formatTime(takenTime))
                                                  .then((value) async {
                                                await employeeController
                                                    .fetchFilledSurveyModel()
                                                    .then((value) async {
                                                  await eventController
                                                      .fetchEventsFromFirebase()
                                                      .then(
                                                    (value) async {
                                                      await surveyController
                                                          .fetchFilledSurveyModel()
                                                          .then((value) async {
                                                        await surveyController
                                                            .fetchSurveys();
                                                      });
                                                    },
                                                  );
                                                  await employeeController
                                                      .fetchEventsFromFirebase();
                                                  employeeController
                                                      .fetchApprovals();
                                                  employeeController
                                                      .fetchSurveys()
                                                      .then((va) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return ResponseDialog(
                                                          title:
                                                              "Successful".tr,
                                                          subtitle:
                                                              "You Successfuly Saved The Survey"
                                                                  .tr,
                                                          lottieAsset:
                                                              "assets/images/correct.json",
                                                        );
                                                      },
                                                    );
                                                    Navigator.pop(context);
                                                  });
                                                });
                                              });
                                            },
                                            buttonColor: MyThemeData.GreyBack,
                                          ),
                                          CustomIconButton(
                                            buttonText: "Submit",
                                            imagePath: "",
                                            hasIcon: false,
                                            onPressed: () {
                                              employeeController
                                                  .uploadEmployeeSubmission(
                                                      status: "sent",
                                                      surveyModel:
                                                          widget.survey!,
                                                      takenTime:
                                                          formatTime(takenTime))
                                                  .then(
                                                (value) async {
                                                  employeeController
                                                      .sendNotificationWhenFilledSurvey(
                                                          widget.survey!);
                                                  await employeeController
                                                      .fetchFilledSurveyModel()
                                                      .then((value) async {
                                                    await eventController
                                                        .fetchEventsFromFirebase()
                                                        .then(
                                                      (value) async {
                                                        await surveyController
                                                            .fetchFilledSurveyModel()
                                                            .then(
                                                                (value) async {
                                                          await surveyController
                                                              .fetchSurveys();
                                                        });
                                                      },
                                                    );
                                                    await employeeController
                                                        .fetchEventsFromFirebase();
                                                    employeeController
                                                        .fetchApprovals();
                                                    employeeController
                                                        .fetchSurveys()
                                                        .then((va) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return ResponseDialog(
                                                            title:
                                                                "Successful".tr,
                                                            subtitle:
                                                                "You Successfuly Saved The Survey"
                                                                    .tr,
                                                            lottieAsset:
                                                                "assets/images/correct.json",
                                                          );
                                                        },
                                                      );
                                                      Navigator.pop(context);
                                                    });
                                                  });

                                                 
                                                },
                                              );
                                            },
                                            buttonColor: MyThemeData.signOut,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ));
                    }),
              ],
            ),
          )),
        ));
  }
}
