import 'package:demo_app/features/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/widgets/custom_upper_filter.dart';
import 'package:demo_app/core/widgets/dialogs/delete_dialog.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/components/survey_components/dialogue_switchers_row.dart';
import 'package:demo_app/features/events/mobile/media_department/media_department_home.dart';
import 'package:demo_app/features/events/mobile/survey/edit_survey_mobile.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/participants_screen.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/show_analytics_screen.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/show_questions_screen.dart';
import 'package:demo_app/core/nav_bar_package.dart/functions.dart';
import 'package:demo_app/core/nav_bar_package.dart/model.dart';

class ShowSurveyMobile extends StatefulWidget {
  const ShowSurveyMobile({super.key, required this.survey});
  final SurveyModel? survey;

  @override
  State<ShowSurveyMobile> createState() => _ShowSurveyMobileState();
}

class _ShowSurveyMobileState extends State<ShowSurveyMobile> {
  final SurveyController surveyController = Get.put(SurveyController());

  bool responseSwitch = false;
  int respondedCount = 0;
  @override
  void initState() {
    respondedCount = widget.survey!.partitcipants
        .where((participant) => participant.status == "Responded")
        .toList()
        .length;
    surveyController.showResponseresponseSwitch = widget.survey!.showResponse;
    surveyController.passedSurveyId = widget.survey!.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBarMobile(
              showIcon: true,
              title: Get.locale.toString().contains('en')
                  ? widget.survey?.surveyTitle ?? "Survey Title"
                  : widget.survey?.surveyTitleArabic ?? "عنوان الاستبيان",
              isHome: false,
            ),
            GetBuilder<SurveyController>(
              builder: (surveyController) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.04.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomIconButton(
                  buttonText: "Delete",
                  smallHeight: true,
                  buttonColor: AppColors.delete,
                  textColor: AppColors.colorWhite,
                  imageColor: AppColors.colorWhite,
                  imagePath: "assets/icons/trashIcon.svg",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteDialog(
                          deleteText:
                              "Are You Sure You Want To Delete This Survey ?",
                          deleteTitleText: "Delete Survey",
                          isDeleteDialog: true,
                          yesOnPressed: () {
                            surveyController
                                .updateSurvey(
                                    status: "deleted", survey: widget.survey!)
                                .then((value) {
                              surveyController.deleteSurvey(widget.survey!);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MediaDepartmentHomeMobile(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            });
                          },
                          /*  subtitle:
                              "Are You Sure You Want To Delete This Survey ?",
                          title: "Delete Survey",
                          yesText: "Yes, Delete",*/
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  width: 0.02.w,
                ),
                CustomIconButton(
                  buttonText: "Edit",
                  smallHeight: true,
                  imagePath: "assets/icons/edit.svg",
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                      screen: EditSurveyMobile(
                        eventID: "",
                        survey: widget.survey,
                        isCreateNew: false,
                      ),
                      withNavBar: false,
                    );
                  },
                ),
                      ],
                    ),
                    SizedBox(height: 0.005.h,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          //    color: Colors.amber,
                          width: 0.9.w,
                          child: UpperFilters(
                              selectedIndex:
                                  surveyController.showSurveyselectedIndex,
                              selectedDepartmentState: (value) {},
                              selectedIndexState:
                                  surveyController.showSurveyState,
                              filterTitles: [
                                'Questions',
                                '${"Analytics".tr} (${Get.locale.toString().contains('en') ? respondedCount : convertNumberToArabic(respondedCount.toString())})',
                                'Participants'
                              ]),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 0.04.h,
                          //   color: Colors.amber,
                          width: (0.45.w),
                          child: DialogueSwitchersRow(
                            title: 'Share Responses',
                            isAnalytics: true,
                            switchValue:
                                surveyController.showResponseresponseSwitch,
                            switchValueState:
                                surveyController.showSResponseState,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.01.h,),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          //  color: Theme.of(context).colorScheme.inversePrimary
                        ),
                        child: buildSelectedIndexContainer()),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
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
