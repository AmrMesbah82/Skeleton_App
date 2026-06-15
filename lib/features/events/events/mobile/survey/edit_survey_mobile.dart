import 'package:demo_app/features/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/features/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/edit_survey/edit_survey_body.dart';

class EditSurveyMobile extends StatelessWidget {
  EditSurveyMobile({
    super.key,
    this.survey,
    this.isCreateNew,
    required this.eventID,
  });

  final SurveyModel? survey;
  bool? isCreateNew;
  final String eventID;

  @override
  Widget build(BuildContext context) {
    SurveyController surveyController = Get.put(SurveyController());
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBarMobile(
              showIcon: true,
              title: isCreateNew! ? "Create Survey".tr : "Edit Survey".tr,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.04.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    // height: 0.8.h,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                        child: EditSurveyBody(
                          eventID: eventID,
                          survey: survey,
                          isCreateNew: isCreateNew!,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
