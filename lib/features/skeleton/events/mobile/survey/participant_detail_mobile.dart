import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/events/components/survey_components/test_question_container.dart';
import 'package:demo_app/features/skeleton/events/models/more_models/employee_submission_model.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/views/survey/participant_detail_screen.dart';

class ParticipantDetailMobile extends StatelessWidget {
  ParticipantDetailMobile({
    super.key,
    required this.survey,
    required this.selctedIndex,
    this.isEmployee = false,
  });
  final SurveyModel? survey;
  int selctedIndex;
  bool? isEmployee;

  SurveyController surveyController = Get.put(SurveyController());

  @override
  Widget build(BuildContext context) {
    EmployeeSubmissionModel? employeeSubmissionModel =
        surveyController.getEmployeeSubmission(
            survey!.id, survey!.partitcipants[selctedIndex].email);

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
                  title:
                      isEmployee == true ? "My Responses" : survey!.surveyTitle,
                  isHome: false,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.04.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isEmployee == true
                          ? const SizedBox.shrink()
                          : participant_details_info_header(
                              isPortrait: true,
                              survey: survey,
                              selctedIndex: selctedIndex),
                      SizedBox(
                        height: 0.02.h,
                      ),
                      ListView.builder(
padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount:
                            employeeSubmissionModel!.questionModel.length,
                        physics:const NeverScrollableScrollPhysics(),    
                        itemBuilder: (context, index) {
                          return TestQuestionContainer(
                            mcqAnswerState: (value) {},
                            isDisabled: true,
                            textAnswer: TextEditingController(
                                text: employeeSubmissionModel
                                    .questionModel[index].answer!.last),
                            mcqAnswer: TextEditingController(
                                text: employeeSubmissionModel
                                    .questionModel[index].answer!.last),
                            hasPhoto: true,
                            qusestionType:
                                survey!.questions[index].questionType,
                            question: survey!.questions[index].question,
                            hintText: survey!.questions[index].hintText,
                            imagepath: null,
                            choices: survey!.questions[index].choices,
                            isRequired: survey!.questions[index].isRequired ,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
