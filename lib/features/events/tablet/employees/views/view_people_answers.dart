import 'package:demo_app/features/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/features/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/constants/image_paths.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/events/tablet/employees/views/employee_home_screen.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/page_screenstop_level.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/participants_screen.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:page_transition/page_transition.dart';

class ViewPeopleSurveyAnswers extends StatefulWidget {
  const ViewPeopleSurveyAnswers({
    super.key,
    this.survey,
  });

  final SurveyModel? survey;

  @override
  State<ViewPeopleSurveyAnswers> createState() => _ShowSurveyScreenState();
}

class _ShowSurveyScreenState extends State<ViewPeopleSurveyAnswers> {
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
                      child: const EmployeeEventsHomeScreen(),
                    ),
                  );
                },
                icon: Transform.translate(
                   offset: Get.locale.toString().contains('en')
                    ? Offset(-0.006.w, -0.0015.h)
                    : Offset(-0.006.w, 0.001.h),
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
                     letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
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
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  //  color: Theme.of(context).colorScheme.inversePrimary
                ),
                child: ParticipantsScreen(
                  survey: widget.survey,
                )),
          ),
        ]),
      ),
    );
  }
}
