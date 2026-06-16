import 'package:demo_app/features/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';

import 'package:demo_app/core/widgets/custom_upper_filter.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';

import 'package:demo_app/core/constants/image_paths.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/components/survey_components/delete_member_dialog.dart';
import 'package:demo_app/features/events/components/survey_components/dialogue_switchers_row.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/page_screenstop_level.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/edit_survey/edit_survey.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/events_home_screen.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/participants_screen.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/show_analytics_screen.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/show_questions_screen.dart';
import 'package:page_transition/page_transition.dart';

class ShowSurveyScreen extends StatefulWidget {
  const ShowSurveyScreen({
    super.key,
    this.survey,
  });

  final SurveyModel? survey;

  @override
  State<ShowSurveyScreen> createState() => _ShowSurveyScreenState();
}

class _ShowSurveyScreenState extends State<ShowSurveyScreen> {
  final SurveyController surveyController = Get.put(SurveyController());
  int respondedCount = 0;
  @override
  void initState() {
    respondedCount = widget.survey!.partitcipants
        .where((participant) => participant.status == "Responded")
        .toList()
        .length;
    surveyController.showResponseresponseSwitch = widget.survey!.showResponse;
    surveyController.passedSurveyId = widget.survey!.id;
    print(widget.survey!.showResponse);
    print(widget.survey!.surveyTitle);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: GetBuilder<SurveyController>(
        builder: (surveyController) => PageScreenTopLevel(children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child:          EventsHomeScreen(
                        givenIndex: 5,
                      ),
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
                      ? "${widget.survey?.surveyTitle}"
                      : "${widget.survey?.surveyTitleArabic}",
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
              if (surveyController.showSurveyselectedIndex == 0)
                CustomIconButton(
                  buttonText: "Delete",
                  buttonColor: AppColors.delete,
                  textColor: AppColors.colorWhite,
                  imageColor: AppColors.colorWhite,
                  imagePath: "assets/icons/trashIcon.svg",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteMemberDialog(
                          lottieUrl: "assets/images/delete.json",
                          onPressed: () {
                            surveyController
                                .updateSurvey(
                                    status: "deleted", survey: widget.survey!)
                                .then((value) {
                              surveyController.deleteSurvey(widget.survey!);
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: EventsHomeScreen(),
                                ),
                              );
                            });
                          },
                          subtitle:
                              "Are You Sure You Want To Delete This Survey ?",
                          title: "Delete Survey",
                          yesText: "Yes, Delete",
                        );
                      },
                    );
                  },
                ),
              if (surveyController.showSurveyselectedIndex == 0)
                SizedBox(
                  width: 0.02.w,
                ),
              if (surveyController.showSurveyselectedIndex == 0)
                CustomIconButton(
                  buttonText: "Edit",
                  imagePath: "assets/icons/edit.svg",
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child:       EditSurvey(
                          eventID: "",
                          survey: widget.survey,
                          isCreateNew: false,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          SizedBox(
            height: 0.02.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                //    color: Colors.amber,

                child: UpperFilters(
                    selectedIndex: surveyController.showSurveyselectedIndex,
                    selectedDepartmentState: (value) {},
                    selectedIndexState: surveyController.showSurveyState,
                    filterTitles: [
                      'Questions',
                      '${"Analytics".tr} (${Get.locale.toString().contains('en') ? respondedCount : convertNumberToArabic(respondedCount.toString())})',
                      'Participants'
                    ]),
              ),
              SizedBox(
                height: isPortrait ? 0.04.h : null,
                //   color: Colors.amber,
                width: (isPortrait ? 0.24.w : 0.16.w),
                child: DialogueSwitchersRow(
                  title: 'Share Responses',
                  isAnalytics: true,
                  switchValue: surveyController.showResponseresponseSwitch,
                  switchValueState: surveyController.showSResponseState,
                ),
              ),
            ],
          ),
          SizedBox(
            height: isPortrait ? 0 : 0.02.h,
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  //  color: Theme.of(context).colorScheme.inversePrimary
                ),
                child: buildSelectedIndexContainer()),
          ),
        ]),
      ),
    );
  }

  Widget buildSelectedIndexContainer() {
    switch (surveyController.showSurveyselectedIndex) {
      case 0:
        return ShowQuestionsScreen(
          survey: widget.survey,
        );
      case 1:
        return ShowAnalyticsScreen(
          survey: widget.survey,
        );
      case 2:
        return ParticipantsScreen(
          survey: widget.survey,
        );
      default:
        return Container();
    }
  }
}
