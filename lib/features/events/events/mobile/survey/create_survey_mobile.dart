import 'package:flutter/material.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/survey_body.dart';

class CreateSurveyMobile extends StatefulWidget {
  const CreateSurveyMobile({super.key, required this.eventID});
  final String eventID;
  @override
  State<CreateSurveyMobile> createState() => _CreateSurveyMobileState();
}

class _CreateSurveyMobileState extends State<CreateSurveyMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBarMobile(
              showIcon: true,
              title: "Create Survey",
              isHome: false,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.04.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.inversePrimary),
                      child: SurveyBody(eventID: widget.eventID)),
                   SizedBox(
                    height: 0.02.h,
                   )   
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
