import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';

import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/constants/image_paths.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/events/components/survey_components/employee_detail_row.dart';
import 'package:demo_app/features/skeleton/events/components/survey_components/test_question_container.dart';

import 'package:demo_app/features/skeleton/events/models/more_models/employee_submission_model.dart';
import 'package:demo_app/features/skeleton/events/tablet/employees/views/employee_home_screen.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/components/page_screenstop_level.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/views/survey/show_survey_screen.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/settings_screen.dart';
import 'package:page_transition/page_transition.dart';

class ParticipantDetailScreen extends StatelessWidget {
  ParticipantDetailScreen(
      {super.key, required this.survey, required this.selctedIndex});
  final SurveyModel? survey;
  int selctedIndex;

  SurveyController surveyController = Get.put(SurveyController());

  @override
  Widget build(BuildContext context) {
    EmployeeSubmissionModel? employeeSubmissionModel =
        surveyController.getEmployeeSubmission(
            survey!.id, survey!.partitcipants[selctedIndex].email);

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PageScreenTopLevel(hasScrollView: true, children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                (!Mode.hr && !Mode.owner)
                    ? Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: EmployeeEventsHomeScreen(),
                        ),
                      )
                    : Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: ShowSurveyScreen(survey: survey),
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
                (!Mode.hr && !Mode.owner)
                    ? "Response".tr
                    : Get.locale.toString().contains('en')
                        ? survey!.surveyTitle
                        : survey!
                            .surveyTitleArabic, //widget.survey!.surveyTitle,
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
          height: 0.02.h,
        ),
        (!Mode.hr && !Mode.owner)
            ? const SizedBox.shrink()
            : participant_details_info_header(
                isPortrait: isPortrait,
                survey: survey,
                selctedIndex: selctedIndex),
        SizedBox(
          height: 0.02.h,
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: employeeSubmissionModel!.questionModel.length,
          physics: const NeverScrollableScrollPhysics(),
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
              qusestionType: survey!.questions[index].questionType,
              question: survey!.questions[index].question,
              hintText: survey!.questions[index].hintText,
              imagepath: null,
              choices: survey!.questions[index].choices,
              isRequired: survey!.questions[index].isRequired,
            );
          },
        ),
      ]),
    );
  }
}

class participant_details_info_header extends StatelessWidget {
  const participant_details_info_header({
    super.key,
    required this.isPortrait,
    required this.survey,
    required this.selctedIndex,
  });

  final bool isPortrait;
  final SurveyModel? survey;
  final int selctedIndex;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.015.h, horizontal: 0.015.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isPortrait
                ? isTablet
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomIconButton(
                              buttonText: "Send Message",
                              imagePath:
                                  "assets/icons/message_without_notif.svg",
                              isOwnerHome: true,
                              onPressed: () {})
                        ],
                      )
                    : const SizedBox.shrink()
                : const SizedBox.shrink(),
            Row(
              children: [
                CircleAvatar(
                  radius: isPortrait ? 0.03.h : 0.04.h,
                  backgroundImage: AssetImage(
                    survey!.partitcipants[selctedIndex].profilePhoto,
                  ),
                ),
                SizedBox(
                  width: 0.02.w,
                ),
                Text(
                  survey!.partitcipants[selctedIndex].name,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isPortrait
                          ? FontConstants.fontSize016.h
                          : FontConstants.fontSize016.w,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
                isTablet
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.03.w),
                        child: EmployeeContent(
                          title: "Department",
                          value: survey!.partitcipants[selctedIndex].department,
                          isAssets: true,
                        ),
                      )
                    : const Spacer(),
                isTablet
                    ? EmployeeContent(
                        title: "Job Title",
                        value: survey!.partitcipants[selctedIndex].jobTitle,
                        isAssets: true,
                      )
                    : CustomIconButton(
                        buttonText: "Send Message",
                        imagePath: "assets/icons/message_without_notif.svg",
                        isOwnerHome: true,
                        onPressed: () {}),
                isTablet ? const Spacer() : const SizedBox.shrink(),
                isPortrait
                    ? const SizedBox.shrink()
                    : CustomIconButton(
                        buttonText: "Send Message",
                        imagePath: "assets/icons/message_without_notif.svg",
                        isOwnerHome: true,
                        onPressed: () {})
              ],
            ),
            SizedBox(
              height: 0.015.h,
            ),
            isTablet
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      EmployeeContent(
                        title: "Department",
                        value: survey!.partitcipants[selctedIndex].department,
                        isAssets: true,
                      ),
                      SizedBox(
                        height: 0.015.h,
                      ),
                      EmployeeContent(
                        title: "Job Title",
                        value: survey!.partitcipants[selctedIndex].jobTitle,
                        isAssets: true,
                      ),
                    ],
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                EmployeeContent(
                  title: "Date",
                  value: Get.locale.toString().contains('en')
                      ? survey!.partitcipants[selctedIndex].dateSentResponse!
                      : translateDateFormatToArabic(survey!
                          .partitcipants[selctedIndex].dateSentResponse!),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
