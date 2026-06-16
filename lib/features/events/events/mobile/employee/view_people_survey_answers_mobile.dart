import 'package:demo_app/features/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/features/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/participants_screen.dart';

class ViewPeopleSurveyAnswersMobile extends StatefulWidget {
  const ViewPeopleSurveyAnswersMobile({
    super.key,
    this.survey,
  });
  final SurveyModel? survey;

  @override
  State<ViewPeopleSurveyAnswersMobile> createState() =>
      _ViewPeopleSurveyAnswersMobileState();
}

class _ViewPeopleSurveyAnswersMobileState
    extends State<ViewPeopleSurveyAnswersMobile> {
  final SurveyController surveyController = Get.put(SurveyController());
  int respondedCount = 0;
  @override
  void initState() {
    respondedCount = widget.survey!.partitcipants
        .where((participant) => participant.status == "Responded")
        .toList()
        .length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SurveyController>(
      init: SurveyController(),
      builder: (controller) => Scaffold(
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBarMobile(
              showIcon: true,
              title: Get.locale.toString().contains('en')
                  ? "${widget.survey?.surveyTitle}"
                  : "${widget.survey?.surveyTitleArabic}",
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 0.04.w),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    //  color: Theme.of(context).colorScheme.inversePrimary
                  ),
                  child: ParticipantsScreen(
                    survey: widget.survey,
                    isEmployee: true,
                  )),
            ),
          ],
        )),
      ),
    );
  }
}
