import 'dart:developer';

import 'package:demo_app/feature/events/events/controllers/survey_controller.dart/model/question_model.dart';
import 'package:demo_app/feature/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/feature/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/components/settings_components/custom_black_button.dart';
import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/events/components/survey_components/question_card.dart';
import 'package:demo_app/feature/events/controllers/employee_controller.dart';
import 'package:demo_app/feature/events/controllers/events_controllers/event_controller.dart';

import 'package:demo_app/feature/events/tablet/media_departments_view/views/events_home_screen.dart';
import 'package:demo_app/feature/events/tablet/media_departments_view/views/survey/show_survey_screen.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/settings_screen.dart';
import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:page_transition/page_transition.dart';

class EditSurveyBody extends StatefulWidget {
  const EditSurveyBody({
    super.key,
    this.survey,
    required this.isCreateNew,
    required this.eventID,
  });

  final SurveyModel? survey;
  final String eventID;
  final bool isCreateNew;

  @override
  State<EditSurveyBody> createState() => _EditSurveyBodyState();
}

class _EditSurveyBodyState extends State<EditSurveyBody> {
  final HapticController hapticController = Get.put(HapticController());
  late TextEditingController titleEnglish;
  late TextEditingController titleArabic;
  late TextEditingController summary;
  late TextEditingController summaryArabic;

  final SurveyController surveyController = Get.put(SurveyController());
  final EventController eventController = Get.put(EventController());
  final EventsEmployeeController employeeController = Get.put(EventsEmployeeController());

  @override
  void initState() {
    // TODO: implement initState
    titleEnglish = TextEditingController(text: widget.survey!.surveyTitle);
    titleArabic = TextEditingController(text: widget.survey!.surveyTitleArabic);
    summary = TextEditingController(text: widget.survey!.summary);
    summaryArabic = TextEditingController(text: widget.survey!.summaryInArabic);
    surveyController.initializeEditControllers(widget.survey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    double height = 0.01.h;
    return GetBuilder<SurveyController>(
        builder: (surveyController) => Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.02.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isTablet
                        ? Row(
                            children: [
                              Expanded(
                                child: ColumnRequestData(
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  title: "Title (English)",
                                  textDirection: TextDirection.ltr,
                                  mainAxisAlignment:
                                      Get.locale.toString().contains('en')
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                  isTextField: true,
                                  hint: "Text Here",
                                  isRequired: true,
                                  isOptional: false,
                                  isExpanded: true,
                                  hasPrefix: true,
                                  textController: titleEnglish,
                                  controllerState: (value) {
                                    setState(() {
                                      print('value ${value!}');
                                    });
                                  },
                                  maxlength: 60,
                                ),
                              ),
                              SizedBox(
                                width: 0.02.w,
                              ),
                              Expanded(
                                child: ColumnRequestData(
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  title: "(العربية) الاسم",
                                  textDirection: TextDirection.rtl,
                                  mainAxisAlignment:
                                      Get.locale.toString().contains('en')
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  isTextField: true,
                                  isArabic: true,
                                  hint: "Text Here",
                                  isOptional: false,
                                  isExpanded: true,
                                  hasPrefix: true,
                                  textController: titleArabic,
                                  controllerState: (value) {
                                    setState(() {
                                      print('value ${value!}');
                                    });
                                  },
                                  maxlength: 60,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ColumnRequestData(
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                title: "Title (English)",
                                mainAxisAlignment: MainAxisAlignment.start,
                                isTextField: true,
                                hint: "Text Here",
                                isOptional: false,
                                isExpanded: true,
                                hasPrefix: true,
                                textController: titleEnglish,
                                controllerState: (value) {
                                  setState(() {
                                    print('value ${value!}');
                                  });
                                },
                                maxlength: 60,
                              ),
                              SizedBox(
                                height: 0.015.h,
                              ),
                              ColumnRequestData(
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                title: "(العربية) الاسم",
                                mainAxisAlignment: MainAxisAlignment.end,
                                isTextField: true,
                                isArabic: true,
                                hint: "اكتب هنا",
                                isOptional: false,
                                isExpanded: true,
                                hasPrefix: true,
                                textController: titleArabic,
                                controllerState: (value) {
                                  setState(() {
                                    print('value ${value!}');
                                  });
                                },
                                maxlength: 60,
                              ),
                            ],
                          ),
                    SizedBox(
                      height: height,
                    ),
                    ColumnRequestData(
                      title: "Description (English)",
                      textDirection: TextDirection.ltr,
                      fillColor:
                          themeController.currentTheme == MyThemeData.lightTheme
                              ? MyThemeData.colorLightGrey
                              : MyThemeData.colorBlack,
                      mainAxisAlignment: Get.locale.toString().contains('en')
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      isTextField: true,
                      hint: "Text Here",
                      isOptional: false,
                      isExpanded: true,
              isDescription: true,
                      textController: summary,
                      // textController: widget.isGroupEdit == true
                      //     ? null
                      //     : desciption,
                      maxlines: 16,
                      controllerfinishState: (value) {},

                      controllerState: (value) {
                        setState(() {
                          print('value ${value!}');
                        });
                      },
                      maxlength: 600,
                    ),
                    SizedBox(
                      height: height,
                    ),
                    ColumnRequestData(
                      title: "(العربية) الوصف",
                      isTextField: true,
                      hint: "اكتب هنا",
                      isArabic: true,
                      isOptional: false,
                      isExpanded: true,
              isDescription: true,
                      textController: summaryArabic,
                      // textController: widget.isGroupEdit == true
                      //     ? null
                      //     : desciption,
                      maxlines: 16,
                      controllerfinishState: (value) {},
                      textDirection: TextDirection.rtl,
                      fillColor:
                          themeController.currentTheme == MyThemeData.lightTheme
                              ? MyThemeData.colorLightGrey
                              : MyThemeData.colorBlack,
                      mainAxisAlignment: Get.locale.toString().contains('en')
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      controllerState: (value) {
                        setState(() {
                          print('value ${value!}');
                        });
                      },
                      maxlength: 600,
                    ),
                    SizedBox(
                      height: height,
                    ),
                    SizedBox(
                      // height: isTablet
                      //     ? widget.survey!.questions.length * 0.45.h
                      //     : widget.survey!.questions.length * 0.35.h,
                      child: ListView.builder(
padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.survey!.questions.length,
                          itemBuilder: (context, index) {
                            return widget.survey!.questions[index].status ==
                                    "deleted"
                                ? const SizedBox.shrink()
                                : QuestionCard(
                                    isEdit: true,
                                    index: index,
                                    isRequired: widget
                                        .survey!.questions[index].isRequired,
                                    questionController: surveyController
                                        .questionEditControllers[index],
                                    shortAnswerController: surveyController
                                        .paragraphEditControllers[index],
                                    paragaraphAnswerController: surveyController
                                        .paragraphEditControllers[index],
                                    pointsController: TextEditingController(),
                                    questionType: widget
                                        .survey!.questions[index].questionType,
                                    dropDownControllers: surveyController
                                        .mcqEditControllers[index],
                                    mcqControllers: surveyController
                                        .mcqEditControllers[index],
                                    selectedImagePath: null,
                                    imagePaths: const [],
                                    switchValue: widget.survey!.questions[index]
                                        .isRequired, // Example switch value
                                    onQuestionChanged: (value) {
                                      setState(() {
                                        widget.survey!.questions[index]
                                            .questionType = value!;
                                      });
                                    },
                                    onSwitchChanged: (value) {
                                      setState(() {
                                        widget.survey!.questions[index]
                                            .isRequired = value;
                                      });

                                      // Handle switch value change
                                    },
                                    onDuplicate: () {
                                      log("dublicate question");
                                      surveyController.duplicateSurveyQuestion(
                                          index: index,
                                          questions: widget.survey!.questions);
                                    },
                                    onDelete: () {
                                      setState(() {
                                        widget.survey!.questions[index].status =
                                            "deleted";
                                      });
                                    },
                                    onCorrectAnswerSelected:
                                        widget.survey!.questions[index].answer,
                                    controllerState: (value) {
                                      // Handle controller state changes
                                    },
                                  );
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: isPortrait ? 0 : 0.0.h),
                      child: CustomBlackButton(
                        buttonText: 'Add Question'.tr,
                        onPressed: () {
                          setState(() {
                            surveyController.questionEditControllers
                                .add(TextEditingController());
                            surveyController.paragraphEditControllers
                                .add(TextEditingController());
                            surveyController.mcqEditControllers
                                .add([TextEditingController()]);

                            widget.survey!.questions.insert(
                                widget.survey!.questions.length,
                                QuestionModel(
                                    status: "sent",
                                    question: "",
                                    hintText: "",
                                    isMcq: false,
                                    hasPhoto: false,
                                    answer: "",
                                    choices: '',
                                    questionType: 'Short Answer',
                                    isRequired: true));
                          });
                          surveyController.update();
                        },
                      ),
                    ),
                    SizedBox(
                      height: height,
                    ),
                    SizedBox(
                      height: height,
                    ),
                    !isTablet
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.02.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MainCustomIconButton(
                                  onPressed: () {
                                    widget.survey!.surveyTitle =
                                        titleEnglish.text;
                                    widget.survey!.surveyTitleArabic =
                                        titleArabic.text;
                                    widget.survey!.summary = summary.text;
                                    widget.survey!.summaryInArabic =
                                        summaryArabic.text;

                                    if (widget.isCreateNew) {
                                      surveyController
                                          .createSurveyFromExistingOne("saved",
                                              widget.survey!, widget.eventID)
                                          .then((value) async {
                                        await eventController
                                            .fetchEventsFromFirebase()
                                            .then((value) async {
                                          eventController.fetchApprovals();
                                          await employeeController
                                              .fetchEmployees()
                                              .then((value) async {
                                            await employeeController
                                                .fetchFilledSurveyModel()
                                                .then((value) async {
                                              await employeeController
                                                  .fetchEventsFromFirebase();
                                              employeeController
                                                  .fetchApprovals();
                                              employeeController.fetchSurveys();
                                              surveyController.filteredSurveys
                                                  .assignAll(
                                                      surveyController.surveys);

                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const ResponseDialog(
                                                    title: "Successful",
                                                    subtitle:
                                                        "You Successfuly Saved This Survey",
                                                    lottieAsset:
                                                        "assets/images/correct.json",
                                                  );
                                                },
                                              );
                                              Future.delayed(
                                                  const Duration(seconds: 3),
                                                  () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              });
                                            });
                                          });
                                        });
                                      });
                                    } else {
                                      surveyController
                                          .updateSurvey(
                                              status: "saved",
                                              survey: widget.survey!)
                                          .then((value) async {
                                        await employeeController
                                            .fetchEmployees()
                                            .then((value) async {
                                          await employeeController
                                              .fetchFilledSurveyModel()
                                              .then((value) async {
                                            await employeeController
                                                .fetchEventsFromFirebase();
                                            employeeController.fetchApprovals();
                                            employeeController.fetchSurveys();
                                          });
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const ResponseDialog(
                                              title: "Successful",
                                              subtitle:
                                                  "You Successfuly Saved This Survey",
                                              lottieAsset:
                                                  "assets/images/correct.json",
                                            );
                                          },
                                        );
                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      });
                                    }
                                  },
                                  buttonStyle: ElevatedButton.styleFrom(
                                    minimumSize: Size(0.18.w, 0.045.h),
                                    backgroundColor: MyThemeData.colorWhite,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: MyThemeData.lightPrimary,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                    ),
                                  ),
                                
                                  buttonText: "Save".tr,
                                ),
                                MainCustomIconButton(
                                  onPressed: () {
                                    widget.survey!.surveyTitle =
                                        titleEnglish.text;
                                    widget.survey!.surveyTitleArabic =
                                        titleArabic.text;
                                    widget.survey!.summary = summary.text;
                                    widget.survey!.summaryInArabic =
                                        summaryArabic.text;

                                    if (widget.isCreateNew) {
                                      surveyController
                                          .createSurveyFromExistingOne("sent",
                                              widget.survey!, widget.eventID)
                                          .then((value) async {
                                        await eventController
                                            .fetchEventsFromFirebase()
                                            .then((value) async {
                                          eventController.fetchApprovals();
                                          await employeeController
                                              .fetchEmployees()
                                              .then((value) async {
                                            await employeeController
                                                .fetchFilledSurveyModel()
                                                .then((value) async {
                                              await employeeController
                                                  .fetchEventsFromFirebase();
                                              employeeController
                                                  .fetchApprovals();
                                              employeeController.fetchSurveys();
                                              surveyController.filteredSurveys
                                                  .assignAll(
                                                      surveyController.surveys);
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const ResponseDialog(
                                                    title: "Successful",
                                                    subtitle:
                                                        "You Successfuly Sent This Survey",
                                                    lottieAsset:
                                                        "assets/images/correct.json",
                                                  );
                                                },
                                              );
                                              Future.delayed(
                                                  const Duration(seconds: 3),
                                                  () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              });
                                            });
                                          });
                                        });
                                      });
                                    } else {
                                      surveyController
                                          .updateSurvey(
                                              status: "sent",
                                              survey: widget.survey!)
                                          .then((value) {
                                        employeeController
                                            .fetchEmployees()
                                            .then((value) async {
                                          await employeeController
                                              .fetchFilledSurveyModel()
                                              .then((value) async {
                                            await employeeController
                                                .fetchEventsFromFirebase();
                                            employeeController.fetchApprovals();
                                            employeeController.fetchSurveys();
                                            surveyController.filteredSurveys
                                                .assignAll(
                                                    surveyController.surveys);
                                          });
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const ResponseDialog(
                                              title: "Successful",
                                              subtitle:
                                                  "You Successfully Edited This Survey",
                                              lottieAsset:
                                                  "assets/images/correct.json",
                                            );
                                          },
                                        );
                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      });
                                    }
                                  },
                                  buttonStyle: ElevatedButton.styleFrom(
                                    minimumSize: Size(0.18.w, 0.045.h),
                                    backgroundColor: MyThemeData.lightPrimary,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                              
                                  buttonText: widget.isCreateNew
                                      ? "Send".tr
                                      : "Edit".tr,
                                )
                              ],
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                              bottom: isPortrait ? 0.005.h : 0.02.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MainCustomIconButton(
                                  onPressed: () {
                                    widget.survey!.surveyTitle =
                                        titleEnglish.text;
                                    widget.survey!.surveyTitleArabic =
                                        titleArabic.text;
                                    widget.survey!.summary = summary.text;
                                    widget.survey!.summaryInArabic =
                                        summaryArabic.text;

                                    if (widget.isCreateNew) {
                                      surveyController
                                          .createSurveyFromExistingOne("saved",
                                              widget.survey!, widget.eventID)
                                          .then((value) async {
                                        await eventController
                                            .fetchEventsFromFirebase()
                                            .then((value) async {
                                          eventController.fetchApprovals();
                                          await employeeController
                                              .fetchEmployees()
                                              .then((value) async {
                                            await employeeController
                                                .fetchFilledSurveyModel()
                                                .then((value) async {
                                              await employeeController
                                                  .fetchEventsFromFirebase();
                                              employeeController
                                                  .fetchApprovals();
                                              employeeController.fetchSurveys();
                                              surveyController.filteredSurveys
                                                  .assignAll(
                                                      surveyController.surveys);
                                            });
                                          });
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const ResponseDialog(
                                              title: "Successful",
                                              subtitle:
                                                  "You Successfuly Saved This Survey",
                                              lottieAsset:
                                                  "assets/images/correct.json",
                                            );
                                          },
                                        );
                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child:  EventsHomeScreen(),
                                            ),
                                          );
                                        });
                                      });
                                    } else {
                                      surveyController
                                          .updateSurvey(
                                              status: "saved",
                                              survey: widget.survey!)
                                          .then((value) {
                                        employeeController
                                            .fetchEmployees()
                                            .then((value) async {
                                          await employeeController
                                              .fetchFilledSurveyModel()
                                              .then((value) async {
                                            await employeeController
                                                .fetchEventsFromFirebase();
                                            employeeController.fetchApprovals();
                                            employeeController.fetchSurveys();
                                            surveyController.filteredSurveys
                                                .assignAll(
                                                    surveyController.surveys);
                                          });
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const ResponseDialog(
                                              title: "Successful",
                                              subtitle:
                                                  "You Successfuly Saved This Survey",
                                              lottieAsset:
                                                  "assets/images/correct.json",
                                            );
                                          },
                                        );
                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child:             ShowSurveyScreen(
                                                survey: widget.survey,
                                              ),
                                            ),
                                          );
                                        });
                                      });
                                    }
                                  },
                                  buttonStyle: ElevatedButton.styleFrom(
                                    minimumSize: isPortrait
                                        ? Size(0.18.w, 0.04.h)
                                        : Size(0.1.w, 0.065.h),
                                    backgroundColor: MyThemeData.colorWhite,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: MyThemeData.lightPrimary,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                    ),
                                  ),
     
                                  buttonText: "Save".tr,
                                ),
                                MainCustomIconButton(
                                  onPressed: () {
                                    // late TextEditingController titleEnglish;
                                    // late TextEditingController titleArabic;
                                    // late TextEditingController summary;
                                    // late TextEditingController summaryArabic;

                                    widget.survey!.surveyTitle =
                                        titleEnglish.text;
                                    widget.survey!.surveyTitleArabic =
                                        titleArabic.text;
                                    widget.survey!.summary = summary.text;
                                    widget.survey!.summaryInArabic =
                                        summaryArabic.text;

                                    if (widget.isCreateNew) {
                                      surveyController
                                          .createSurveyFromExistingOne("sent",
                                              widget.survey!, widget.eventID)
                                          .then((value) async {
                                        await eventController
                                            .fetchEventsFromFirebase()
                                            .then((value) async {
                                          eventController.fetchApprovals();
                                          await employeeController
                                              .fetchEmployees()
                                              .then((value) async {
                                            await employeeController
                                                .fetchFilledSurveyModel()
                                                .then((value) async {
                                              await employeeController
                                                  .fetchEventsFromFirebase();
                                              employeeController
                                                  .fetchApprovals();
                                              employeeController.fetchSurveys();
                                              surveyController.filteredSurveys
                                                  .assignAll(
                                                      surveyController.surveys);
                                            });
                                          });
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const ResponseDialog(
                                              title: "Successful",
                                              subtitle:
                                                  "You Successfully Sent This Survey",
                                              lottieAsset:
                                                  "assets/images/correct.json",
                                            );
                                          },
                                        );

                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child:  EventsHomeScreen(),
                                            ),
                                          );
                                        });
                                      });
                                    } else {
                                      surveyController
                                          .updateSurvey(
                                              status: "sent",
                                              survey: widget.survey!)
                                          .then((value) {
                                        employeeController
                                            .fetchEmployees()
                                            .then((value) async {
                                          await employeeController
                                              .fetchFilledSurveyModel()
                                              .then((value) async {
                                            await employeeController
                                                .fetchEventsFromFirebase();
                                            employeeController.fetchApprovals();
                                            employeeController.fetchSurveys();
                                          });
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const ResponseDialog(
                                              title: "Successful",
                                              subtitle:
                                                  "You Successfully Edited This Survey",
                                              lottieAsset:
                                                  "assets/images/correct.json",
                                            );
                                          },
                                        );

                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child:        ShowSurveyScreen(
                                                survey: widget.survey,
                                              ),
                                            ),
                                          );
                                        });
                                      });
                                    }
                                  },
                                  buttonStyle: ElevatedButton.styleFrom(
                                    minimumSize: isPortrait
                                        ? Size(0.18.w, 0.04.h)
                                        : Size(0.1.w, 0.065.h),
                                    backgroundColor: MyThemeData.lightPrimary,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                        
                                  buttonText: widget.isCreateNew
                                      ? "Send".tr
                                      : "Edit".tr,
                                )
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ));
  }
}
