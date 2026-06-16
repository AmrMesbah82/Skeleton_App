import 'package:demo_app/features/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';

import 'package:demo_app/core/constants/image_paths.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/page_screenstop_level.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/edit_survey/edit_survey_body.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/events_home_screen.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/show_survey_screen.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:page_transition/page_transition.dart';

class EditSurvey extends StatefulWidget {
  EditSurvey({
    super.key,
    this.survey,
    this.isCreateNew,
    required this.eventID,
  });

  final SurveyModel? survey;
  final String eventID;
  bool? isCreateNew;

  @override
  State<EditSurvey> createState() => _EditSurveyState();
}

class _EditSurveyState extends State<EditSurvey> {
  @override
  Widget build(BuildContext context) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PageScreenTopLevel(children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child:            widget.isCreateNew == true
                        ? EventsHomeScreen()
                        : ShowSurveyScreen(
                      survey: widget.survey,
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
                    scale: orientation ? 0.0014.h : 0.0023.h,
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
            Text(
              widget.isCreateNew! ? "Create Survey".tr : "Edit Survey".tr,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: orientation
                    ? FontConstants.fontSize026.h
                    : FontConstants.fontSize026.w,
                fontWeight: FontWeight.w600,
                 letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                height: 1.4,
                color: Theme.of(context).colorScheme.inverseSurface,
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
                  color: Theme.of(context).colorScheme.inversePrimary),
              child: EditSurveyBody(
                eventID: widget.eventID,
                survey: widget.survey,
                isCreateNew: widget.isCreateNew!,
              )),
        ),
      ]),
    );
  }
}
