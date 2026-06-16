import 'package:demo_app/features/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';




import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/mobile/survey/create_survey_mobile.dart';
import 'package:demo_app/features/events/mobile/survey/survey_choose_exisiting_screen.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/create_survey.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/survey_choose_exisiting_screen_tab.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:demo_app/core/nav_bar_package.dart/functions.dart';
import 'package:demo_app/core/nav_bar_package.dart/model.dart';
import 'package:lottie/lottie.dart';

class SurveyCreationChoice extends StatefulWidget {
  const SurveyCreationChoice({super.key, required this.eventID});

  final String eventID;
  @override
  State<SurveyCreationChoice> createState() => _SurveyCreationChoiceState();
}

class _SurveyCreationChoiceState extends State<SurveyCreationChoice> {
  ButtonStyle buttonStyle(Color buttonColor) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return ElevatedButton.styleFrom(
        backgroundColor: buttonColor, //AppColors.bubbleColor,
        minimumSize: isTablet ? Size(0.1.w, 0.053.h) : Size(0.4.w, 0.042.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
  }

  bool isSurveyShown = false;
  bool isSelected = false;
  final SurveyController surveyController = Get.put(SurveyController());

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GetBuilder<SurveyController>(
        builder: (surveyController) => Dialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: isTablet
                      ? (orientation
                          ? 0.2.w
                          : isSurveyShown
                              ? 0.33.w
                              : 0.28.w)
                      : 0.02.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0.02.w, vertical: 0.01.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Lottie.asset("assets/images/create_survey_lottie.json",
                          height: 0.25.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: orientation ? 0.015.h : 0.02.h),
                        child: Text(
                          "Create Survey".tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: isTablet
                                  ? (orientation
                                      ? FontConstants.fontSize025.h
                                      : FontConstants.fontSize035.h)
                                  : FontConstants.fontSize024.h,
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.01.h),
                        child: Row(
                          // direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CustomIconButton(
                              onPressed: () {
                                isTablet
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>            SurveyChooseExisitingTab(
                                            eventID: widget.eventID,
                                          ),
                                        ),
                                      )
                                    : PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.fade,
                                        screen: SurveyChooseExisiting(
                                            eventID: widget.eventID),
                                        withNavBar: true,
                                      );
                              },
                              imagePath: "",
                              hasIcon: false,
                              buttonColor: AppColors.colorGreydark,
                              buttonText: "Choose from Existing".tr,
                              textColor: AppColors.colorBlack,
                            ),
                            Container(width: 0.045.w),
                            CustomIconButton(
                              onPressed: () {
                                isTablet
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>            CreateSurvey(
                                              eventID: widget.eventID),
                                        ),
                                      )
                                      
                                    : PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.fade,
                                        screen: CreateSurveyMobile(
                                            eventID: widget.eventID),
                                        withNavBar: true,
                                      );
                              },
                              buttonText: "Create New Survey".tr,
                              imagePath: "",
                              hasIcon: false,
                              textColor: AppColors.textButton,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
