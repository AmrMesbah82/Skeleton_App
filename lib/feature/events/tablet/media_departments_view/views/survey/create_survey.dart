import 'package:demo_app/feature/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/title_row.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/events/tablet/media_departments_view/components/page_screenstop_level.dart';
import 'package:demo_app/feature/events/tablet/media_departments_view/views/events_home_screen.dart';
import 'package:demo_app/feature/events/tablet/media_departments_view/views/survey/survey_body.dart';
import 'package:page_transition/page_transition.dart';

class CreateSurvey extends StatelessWidget {
  CreateSurvey({super.key, required this.eventID});

  final String eventID;
  final SurveyController surveyController = Get.put(SurveyController());
  @override
  Widget build(BuildContext context) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PageScreenTopLevel(hasScrollView: true, children: [
        titleRow(context, orientation, "Create Survey", () {
          surveyController.surveyCards.clear();
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child:  EventsHomeScreen(),
            ),
          );
        }),
        SizedBox(
          height: 0.02.h,
        ),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.inversePrimary),
            child: SurveyBody(eventID: eventID)),
        SizedBox(
          height: 0.02.h,
        ),
      ]),
    );
  }
}
