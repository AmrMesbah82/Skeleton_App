import 'dart:async';

import 'package:demo_app/features/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/features/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/constants/image_paths.dart';
import 'package:demo_app/core/widgets/loading.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/events/components/survey_components/test_question_container.dart';
import 'package:demo_app/features/events/controllers/employee_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/events/models/more_models/employee_submission_model.dart';
import 'package:demo_app/features/events/tablet/employees/views/employee_home_screen.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/page_screenstop_level.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:page_transition/page_transition.dart';

class TakeSurveyScreen extends StatefulWidget {
  const TakeSurveyScreen({
    super.key,
    this.survey,
  });

  final SurveyModel? survey;

  @override
  State<TakeSurveyScreen> createState() => _TakeSurveyScreenState();
}

class _TakeSurveyScreenState extends State<TakeSurveyScreen> {
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
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return PageScreenTopLevel(
      hasScrollView: true,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child:                         EmployeeEventsHomeScreen(),

                  ),
                );
              },
              icon: Transform.translate(
                offset: Get.locale.toString().contains('en')
                    ? Offset(-0.01.w, -0.0015.h)
                    : Offset(0.01.w, 0.001.h),
                child: Transform.rotate(
                  angle: Get.locale.toString().contains('ar') ? 3.13 : 0,
                  child: Transform.scale(
                    scale: isPortrait ? 0.0014.h : 0.0023.h,
                    child: SvgPicture.asset(
                      // ignore: deprecated_member_use
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      ImagePaths.getImagePath(
                        context,
                        'back_icon',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                Get.locale.toString().contains('en')
                    ? widget.survey!.surveyTitle
                    : widget.survey!.surveyTitleArabic,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isPortrait
                      ? FontConstants.fontSize026.h
                      : FontConstants.fontSize026.w,
                  fontWeight: FontWeight.w600,
                  letterSpacing:
                      Get.locale.toString().contains('en') ? 1.1 : null,
                  height: 1.6,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 0.01.h,
        ),
        GetBuilder<SurveyController>(
          init: SurveyController(),
          builder: (controller) {
            bool isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;

            double height = 0.01.h;

            if (widget.survey == null) {
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
              child: CustomScrollView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0.015.w, vertical: 0.015.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                            child: Text(
                              "Thank you for participating in our event. We hope you had as much fun attending as we did organizing it. We want to hear your feedback so we can keep improving our logistics and content. Please fill this quick survey and let us know your thoughts (your answers will be anonymous)."
                                  .tr,
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
                                    .employeeSubmissionAnswer[index],
                                mcqAnswer: employeeController
                                    .employeeSubmissionAnswer[index],
                                hasPhoto: true,
                                qusestionType: question.questionType,
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
                                          .employeeSubmissionAnswer[index]
                                          .text ==
                                      'True' ||
                                  employeeController
                                          .employeeSubmissionAnswer[index]
                                          .text ==
                                      "False") {
                                employeeController
                                        .employeeSubmissionAnswer[index].text =
                                    employeeController
                                        .employeeSubmissionAnswer[index]
                                        .text
                                        .tr;
                              }
                              var question = entry.value;
                              return TestQuestionContainer(
                                mcqAnswerState: (value) {},
                                textAnswer: employeeController
                                    .employeeSubmissionAnswer[index],
                                mcqAnswer: employeeController
                                    .employeeSubmissionAnswer[index],
                                hasPhoto: true,
                                qusestionType: question.questionType!.last!,
                                question: question.questionTitle!.last!,
                                hintText: "",
                                imagepath: null,
                                choices: question.choices!.last!,
                                isRequired: question.isRequired!.last,
                              );
                            }).toList(),
                          SizedBox(
                            height: height,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomIconButton(
                                buttonText: "Save for later".tr,
                                imagePath: "",
                                hasIcon: false,
                                onPressed: () {
                                  employeeController
                                      .uploadEmployeeSubmission(
                                          status: "saved",
                                          surveyModel: widget.survey!,
                                          takenTime: formatTime(takenTime))
                                      .then(
                                    (value) async {
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
                                        employeeController.fetchApprovals();
                                        employeeController.fetchSurveys();
                                      });
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ResponseDialog(
                                            title: "Successful".tr,
                                            subtitle:
                                                "You Successfuly Saved The Survey"
                                                    .tr,
                                            lottieAsset:
                                                "assets/images/correct.json",
                                          );
                                        },
                                      );
                                      Future.delayed(
                                          const Duration(milliseconds: 1500),
                                          () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                    },
                                  );
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
                                          surveyModel: widget.survey!,
                                          takenTime: formatTime(takenTime))
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
                                                .then((value) async {
                                              await surveyController
                                                  .fetchSurveys();
                                            });
                                          },
                                        );
                                        await employeeController
                                            .fetchEventsFromFirebase();
                                        employeeController.fetchApprovals();
                                        employeeController.fetchSurveys();
                                      });
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ResponseDialog(
                                            title: "Successful".tr,
                                            subtitle:
                                                "You Successfuly Sunmitted The Survey"
                                                    .tr,
                                            lottieAsset:
                                                "assets/images/correct.json",
                                          );
                                        },
                                      );
                                      Future.delayed(
                                          const Duration(milliseconds: 1500),
                                          () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
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
              ),
            );
          },
        ),
      ],
    );
  }
}
