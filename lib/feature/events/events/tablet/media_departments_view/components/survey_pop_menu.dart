import 'dart:developer';

import 'package:demo_app/feature/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/feature/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/events/controllers/employee_controller.dart';
import 'package:demo_app/feature/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/feature/events/mobile/employee/take_survey_screen_mobile.dart';
import 'package:demo_app/feature/events/mobile/employee/view_people_survey_answers_mobile.dart';
import 'package:demo_app/feature/events/mobile/survey/participant_detail_mobile.dart';
import 'package:demo_app/feature/events/mobile/survey/show_survey_mobile.dart';
import 'package:demo_app/feature/events/mobile/survey/survey_creation_choice.dart';
import 'package:demo_app/feature/events/models/more_models/employee_submission_model.dart';
import 'package:demo_app/feature/events/tablet/employees/views/view_people_answers.dart';
import 'package:demo_app/feature/events/tablet/media_departments_view/views/survey/no_response_particpant_dialog.dart';
import 'package:demo_app/feature/events/tablet/media_departments_view/views/survey/participant_detail_screen.dart';
import 'package:demo_app/feature/events/tablet/media_departments_view/views/survey/show_survey_screen.dart';
import 'package:demo_app/feature/events/tablet/media_departments_view/views/survey/take_survey_screen.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/settings_screen.dart';
import 'package:demo_app/nav_bar_package.dart/functions.dart';
import 'package:demo_app/nav_bar_package.dart/model.dart';
import 'package:page_transition/page_transition.dart';

class SurveyPopMenu {
  String? selectedOption;
  bool isSortSelected = false;

  Future<void> showSortMenu(BuildContext context, Offset iconPosition,
      String status, SurveyModel? survey, final String eventID,
      {int? selectedIndex}) async {
    List<String> sortOptions = _getOptionsForStatus(status);

    final isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final double menuOffsetX = iconPosition.dx - (isTablet ? -9.0 : -11);
    final double menuOffsetY = iconPosition.dy - (-7.0);

    final RelativeRect position = RelativeRect.fromLTRB(
      menuOffsetX,
      menuOffsetY,
      overlay.size.width - menuOffsetX,
      overlay.size.height,
    );

    EventsEmployeeController employeeController = Get.put(EventsEmployeeController());
    EventController eventController = Get.put(EventController());
    SurveyController surveyController = Get.put(SurveyController());

    selectedOption = await showMenu(
      context: context,
      position: position,
      color: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      items: sortOptions.map((option) {
        final orientation = MediaQuery.of(context).orientation;
        return PopupMenuItem<String>(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 0.01.w : 0.01.w),
          value: option,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                option.tr,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isTablet
                      ? (isPortrait
                          ? FontConstants.fontSize014.h
                          : FontConstants.fontSize015.w)
                      : FontConstants.fontSize016.h,
                  height: isPortrait ? 2 : 1.6,
                  color: Theme.of(context).colorScheme.scrim,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );

    if (selectedOption != null) {
      if (selectedOption == "Title".tr) {
        employeeController.employeeSelectedIndex == 2
            ? employeeController.sortApprovalEvents()
            : employeeController.sortEvents();

        eventController.eventHomeSelectedIndexFilter == 5
            ? surveyController.sortSurveysByTitle()
            : eventController.sortEvents();
      } else if (selectedOption == "Date".tr) {
        employeeController.employeeSelectedIndex == 2
            ? employeeController.sortApprovalEventsByDate()
            : employeeController.sortEventsByDate();

        eventController.eventHomeSelectedIndexFilter == 5
            ? surveyController.sortSurveysByDate()
            : eventController.sortEventsByDate();
      }
      if (selectedOption == "Create Survey".tr) {
        showDialog(
          context: context,
          builder: (context) {
            return SurveyCreationChoice(eventID: eventID);
          },
        );
      } else if (selectedOption == "Show Survey".tr) {
        if (isTablet) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>      ShowSurveyScreen(
                survey: survey,
              ),
            ),
          );
        } else {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            pageTransitionAnimation: PageTransitionAnimation.fade,
            screen: ShowSurveyMobile(
              survey: survey,
            ),
          );
        }
      } else if (selectedOption == "Answer The Survey".tr) {
        EmployeeSubmissionModel? submissionModel =
            employeeController.findEmployeeSubmission(surveyId: survey!.id);
        if (isTablet) {
          if (submissionModel == null ||
              submissionModel.status.status!.last == "saved") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>            TakeSurveyScreen(
                  survey: survey,
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ResponseDialog(
                  title: "Submitted".tr,
                  subtitle: "You Successfully submitted that Survey before".tr,
                  lottieAsset: "assets/images/correct.json",
                );
              },
            );
          }
        } else {
          if (submissionModel == null ||
              submissionModel.status.status!.last == "saved") {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: TakeSurveyScreenMobile(
                  survey: survey,
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ResponseDialog(
                  title: "Submitted".tr,
                  subtitle: "You Successfully submitted that Survey before".tr,
                  lottieAsset: "assets/images/correct.json",
                );
              },
            );
          }
        }
      } else if (selectedOption == "View Survey Results".tr) {
        if (isTablet) {
          if (survey!.showResponse == false) {
            showDialog(
              context: context,
              builder: (BuildContext context) => NoResponseParticipantDialog(
                showresponse: true,
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ViewPeopleSurveyAnswers(
                      survey: survey,
                    ),
              ),
            );
          }
        } else {
          if (survey!.showResponse == false) {
            showDialog(
              context: context,
              builder: (BuildContext context) => NoResponseParticipantDialog(
                isEmployee: true,
                showresponse: true,
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewPeopleSurveyAnswersMobile(
                  survey: survey,
                ),
              ),
            );
          }
        }
      } else if (selectedOption == 'View My Submission'.tr) {
        EmployeeSubmissionModel? submissionModel =
            employeeController.findEmployeeSubmission(surveyId: survey!.id);
        int index = 0;
        if (submissionModel != null) {
          for (int i = 0; i < survey.partitcipants.length; i++) {
            if (survey.partitcipants[i].email ==
                employee!.email.last!) {
              index = i;
              log("index $index i $i");
            }
          }
        }
        log("index $index");
        if (isTablet) {
          if (submissionModel != null &&
              submissionModel.status.status!.last == "sent") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>               ParticipantDetailScreen(
                  selctedIndex: index,
                  survey: survey,
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => NoResponseParticipantDialog(
                isEmployee: true,
              ),
            );
          }
        } else {
          if (submissionModel != null &&
              submissionModel.status.status!.last == "sent") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ParticipantDetailMobile(
                  survey: survey,
                  selctedIndex: index,
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => NoResponseParticipantDialog(
                isEmployee: true,
              ),
            );
          }
        }
      }
    }
  }

  List<String> _getOptionsForStatus(String status) {
    switch (status) {
      case "Create Survey":
        return ["Create Survey".tr];
      case "Show Survey":
        return ["Show Survey".tr];
      case "Options":
        return [
          'Answer The Survey'.tr,
          'View Survey Results'.tr,
          'View My Submission'.tr,
        ];
      case 'sort':
        return ['Title'.tr, 'Date'.tr];

      default:
        return [];
    }
  }
}
