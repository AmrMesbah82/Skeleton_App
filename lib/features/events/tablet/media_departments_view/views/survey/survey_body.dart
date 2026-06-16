import 'package:demo_app/features/events/events/controllers/survey_controller.dart/survey_controller.dart' show SurveyController;
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/shared_components/custom_black_button.dart';
import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/enumeration/enum.dart';

import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/widgets/loading.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/controllers/employee_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/events_home_screen.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:page_transition/page_transition.dart';

class SurveyBody extends StatefulWidget {
  const SurveyBody({super.key, required this.eventID});

  final String eventID;

  @override
  State<SurveyBody> createState() => _SurveyBodyState();
}

class _SurveyBodyState extends State<SurveyBody> {
  final HapticController hapticController = Get.put(HapticController());

  final SurveyController surveyController = Get.put(SurveyController());

  EventController eventController = Get.put(EventController());

  final EventsEmployeeController employeeController = Get.put(EventsEmployeeController());

  @override
  void initState() {
    surveyController.newSurveyTitle.text = "";
    surveyController.newSurveyTitleArabic.text = "";
    surveyController.newSurveySummary.text = "";
    surveyController.newSurveyArabic.text = "";
    surveyController.surveyCards.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    double height = 0.01.h;
    return GetBuilder<SurveyController>(
      builder: (surveyController) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.02.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isTablet
                ? Row(
                    children: [
                      Expanded(
                        child: ColumnRequestData(
                          fillColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          title: "Title (English)",
                          textDirection: TextDirection.ltr,
                          mainAxisAlignment:
                              Get.locale.toString().contains('en')
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                          isTextField: true,
                          hint: "Text Here ",
                          isOptional: false,
                          isExpanded: true,
                          isRequired: true,
                          hasPrefix: true,
                          textController: surveyController.newSurveyTitle,
                          controllerState: (value) {},
                          maxlength: 60,
                        ),
                      ),
                      SizedBox(
                        width: 0.02.w,
                      ),
                      Expanded(
                        child: ColumnRequestData(
                          fillColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          title: "(العربية) الاسم",
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment:
                              Get.locale.toString().contains('en')
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          isTextField: true,
                          isArabic: true,
                          hint: "Text Here",
                          isOptional: false,
                          isExpanded: true,
                          hasPrefix: true,
                          textController: surveyController.newSurveyTitleArabic,
                          controllerState: (value) {},
                          maxlength: 60,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColumnRequestData(
                        fillColor: Theme.of(context).colorScheme.inversePrimary,
                        title: "Title (English)",
                        textDirection: TextDirection.ltr,
                          mainAxisAlignment:
                              Get.locale.toString().contains('en')
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                        isTextField: true,
                        hint: "Text Here ",
                        isOptional: false,
                        isExpanded: true,
                        hasPrefix: true,
                        textController: surveyController.newSurveyTitle,
                        controllerState: (value) {},
                        maxlength: 60,
                      ),
                      SizedBox(
                        height: 0.015.h,
                      ),
                      ColumnRequestData(
                        fillColor: Theme.of(context).colorScheme.inversePrimary,
                        title: "(العربية) الاسم",
                        textDirection: TextDirection.rtl,
                          mainAxisAlignment:
                              Get.locale.toString().contains('en')
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                        isTextField: true,
                        isArabic: true,
                        hint: "اكتب هنا",
                        isOptional: false,
                        isExpanded: true,
                        hasPrefix: true,
                        textController: surveyController.newSurveyTitleArabic,
                        controllerState: (value) {},
                        maxlength: 60,
                      ),
                    ],
                  ),
            SizedBox(
              height: height,
            ),
            ColumnRequestData(
              title: "Description (English)",
              isTextField: true,
              isRequired: true,
              hint: "Text Here",
              isOptional: false,
              isExpanded: true,
              isDescription: true,
              textDirection: TextDirection.ltr,
              fillColor: themeController.currentTheme == AppColors.lightTheme
                  ? AppColors.colorLightGrey
                  : AppColors.colorBlack,
              mainAxisAlignment: Get.locale.toString().contains('en')
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              textController: surveyController.newSurveySummary,
              // textController: widget.isGroupEdit == true
              //     ? null
              //     : desciption,
              maxlines: 16,
              controllerfinishState: (value) {},

              controllerState: (value) {},
              maxlength: 600,
            ),
            SizedBox(
              height: height,
            ),
            ColumnRequestData(
              title: "(العربية) الوصف",
              isTextField: true,
              hint: "اكتب هنا",
              isArabic: true,
              isOptional: false,
              isExpanded: true,
              isDescription: true,
              textController: surveyController.newSurveyArabic,
              // textController: widget.isGroupEdit == true
              //     ? null
              //     : desciption,
              maxlines: 16,
              controllerfinishState: (value) {},
              textDirection: TextDirection.rtl,
              fillColor: themeController.currentTheme == AppColors.lightTheme
                  ? AppColors.colorLightGrey
                  : AppColors.colorBlack,
              mainAxisAlignment: Get.locale.toString().contains('en')
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              controllerState: (value) {},
              maxlength: 600,
            ),
            SizedBox(
              height: height,
            ),
            ListView.builder(
padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: surveyController.surveyCards.length,
              itemBuilder: (context, index) {
                surveyController.surveyCards[index].index = index;
                return Column(
                  children: [
                    surveyController.surveyCards[index],
                    index == surveyController.surveyCards.length - 1
                        ? const SizedBox.shrink()
                        : const Divider(
                            thickness: 5,
                          )
                  ],
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: isPortrait ? 0 : 0.005.h),
              child: CustomBlackButton(
                buttonText: 'Add Question'.tr,
                onPressed: () {
                  surveyController.addSurveyCard();
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.lightImpact,
                      hapticFeedback: HapticFeedback.lightImpact);
                },
              ),
            ),
            SizedBox(
              height: height,
            ),
            SizedBox(
              height: height,
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: isPortrait ? 0.005.h : 0.02.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainCustomIconButton(
                    onPressed: () async {
                      //   questionsController.onSave();
                      showLoadingIndicator();
                      surveyController
                          .onSent("saved", widget.eventID)
                          .then((_) async {
                        await eventController
                            .fetchEventsFromFirebase()
                            .then((value) async {
                          eventController.fetchApprovals();
                        });

                        hideLoadingIndicator();

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ResponseDialog(
                              title: "Successful".tr,
                              subtitle: "You Successfuly Saved This Survey".tr,
                              lottieAsset: "assets/images/correct.json",
                            );
                          },
                        );
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          Navigator.pop(context);
                          isTablet
                              ? Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child:                                         EventsHomeScreen(),

                                  ),
                                )
                              : Navigator.pop(context);
                        });
                      });
                    },
                    buttonStyle: ElevatedButton.styleFrom(
                      minimumSize: isPortrait
                          ? Size(0.18.w, 0.04.h)
                          : Size(0.1.w, 0.065.h),
                      backgroundColor: AppColors.colorWhite,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.lightPrimary,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                    ),
                    buttonText: "Save".tr,
                  ),
                  MainCustomIconButton(
                    onPressed: () async {
                      // questionsController.onSend();
                      showLoadingIndicator();
                      surveyController
                          .onSent("sent", widget.eventID)
                          .then((_) async {
                        await eventController
                            .fetchEventsFromFirebase()
                            .then((value) async {
                          eventController.fetchApprovals();
                          await employeeController
                              .fetchEmployees()
                              .then((value) async {
                            await employeeController
                                .fetchFilledSurveyModel()
                                .then((value) async {
                              await employeeController
                                  .fetchEventsFromFirebase();
                              employeeController.fetchApprovals();
                              employeeController.fetchSurveys();
                            });
                          });
                        });
                        hideLoadingIndicator();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ResponseDialog(
                              title: "Successful".tr,
                              subtitle: "You Successfuly sent This Survey".tr,
                              lottieAsset: "assets/images/correct.json",
                            );
                          },
                        );
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          Navigator.pop(context);
                          isTablet
                              ? Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child:                                         EventsHomeScreen(),

                                  ),
                                )
                              : Navigator.pop(context);
                        });
                      });
                    },
                    buttonStyle: ElevatedButton.styleFrom(
                      minimumSize: isPortrait
                          ? Size(0.18.w, 0.04.h)
                          : Size(0.1.w, 0.065.h),
                      backgroundColor: AppColors.signOut,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    buttonText: "Send".tr,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
