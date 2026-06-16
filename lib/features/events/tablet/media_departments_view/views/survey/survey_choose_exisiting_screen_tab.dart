import 'package:demo_app/features/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/form_fields/custom_search.dart';
import 'package:demo_app/core/widgets/title_row.dart';

import 'package:demo_app/core/constants/image_paths.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/components/filter_event_dialog.dart';
import 'package:demo_app/features/events/components/reusable_icon_container.dart';
import 'package:demo_app/features/events/components/survey_card.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/page_screenstop_level.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/edit_survey/edit_survey.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/events_home_screen.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:page_transition/page_transition.dart';

class SurveyChooseExisitingTab extends StatefulWidget {
  const SurveyChooseExisitingTab({super.key, required this.eventID});
  final String eventID;
  @override
  State<SurveyChooseExisitingTab> createState() =>
      _SurveyChooseExisitingTabState();
}

class _SurveyChooseExisitingTabState extends State<SurveyChooseExisitingTab> {
  SurveyController surveyController = Get.put(SurveyController());

  int? selectedIndex;
  ButtonStyle buttonStyle(Color buttonColor) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return ElevatedButton.styleFrom(
        backgroundColor: buttonColor, //AppColors.bubbleColor,
        minimumSize: isTablet ? Size(0.1.w, 0.053.h) : Size(0.4.w, 0.042.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
  }

  @override
  void initState() {
    selectedIndex = null;
    for (int i = 0; i < surveyController.filteredSurveys.length; i++) {
      if (surveyController.filteredSurveys[i].isSelected) {
        surveyController.filteredSurveys[i].isSelected = false;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return PageScreenTopLevel(hasScrollView: true, children: [
      GetBuilder<SurveyController>(
        init: SurveyController(),
        builder: (surveyController) => Column(
          children: [
            titleRow(context, isPortrait, "Choose Survey", () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child:                       EventsHomeScreen(),

                ),
              );
            }),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 0.015.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: isPortrait ? 0.04.h : 0.052.h,
                        child: CustomSearchFiled2(
                            fillColor: themeController.currentTheme ==
                                    AppColors.lightTheme
                                ? AppColors.colorWhite
                                : Theme.of(context).colorScheme.inversePrimary,
                            hint: "Search".tr,
                            onChanged: surveyController.onSearchTextChanged,
                            hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isPortrait
                                    ? FontConstants.fontSize016.h
                                    : FontConstants.fontSize022.h,
                                fontWeight: FontWeight.w500,
                                // height: (isPortrait? 2.8 : 3.2)  ,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface),
                            keyBoardType: TextInputType.text),
                      ),
                    ),
                    SizedBox(
                      width: 0.015.w,
                    ),
                    ReusableIconContainer(
                      imagePath: "assets/images/filter_table.svg",
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return FilterEventDialog(
                                isEmployee: false,
                                isSurvey: true,
                                onReset: surveyController.resetFilterExisting,
                                departmentDropDownItems:
                                    surveyController.departmentOwnerItems,
                                dateValue: surveyController.dateFilterExisting,
                                dateValueState: surveyController
                                    .filterDateValueExisitingState,
                                departmentState: surveyController
                                    .filterDepartmentValueExisitingState,
                                departmentValue:
                                    surveyController.departmetFilterExisting,
                                typeDropDownItems:
                                    surveyController.typesFilterExisting,
                                typeValue: surveyController.typeFilterExisting,
                                typetState: surveyController
                                    .filterTypeValueExistingState,
                              );
                            });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.015.h,
                ),
                SizedBox(
                  height: 0.6.h,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount:
                        (surveyController.filteredSurveys.length / 2).ceil(),
                    itemBuilder: (BuildContext context, int index) {
                      int itemsPerRow = 2;
                      int baseIndex = index * itemsPerRow;

                      return Padding(
                        padding: EdgeInsets.only(top: 0.02.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(itemsPerRow, (i) {
                            int currentIndex = baseIndex + i;

                            if (currentIndex <
                                surveyController.filteredSurveys.length) {
                              /* var service =
                                    controller.needApprovalRequestedServices[
                                        currentIndex];*/
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: Get.locale.toString().contains('en')
                                        ? i < itemsPerRow - 1
                                            ? 0.015.w
                                            : 0
                                        : 0,
                                    left: Get.locale.toString().contains('ar')
                                        ? i < itemsPerRow - 1
                                            ? 0.015.w
                                            : 0
                                        : 0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        /* surveyController
                                                .filteredSurveys[currentIndex]
                                                .isSelected =
                                            !surveyController
                                                .filteredSurveys[currentIndex]
                                                .isSelected;*/
                                        selectedIndex = currentIndex;
                                      });
                                    },
                                    child: SurveyCard(
                                      status: surveyController
                                          .filteredSurveys[currentIndex].status,
                                      isSelction: true,
                                      survey: surveyController
                                          .filteredSurveys[currentIndex],
                                      isSelcted: selectedIndex == currentIndex,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const Expanded(child: SizedBox());
                            }
                          }),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.01.h),
                  child: Row(
                    // direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // CustomElevatedButton(
                      //   buttonStyle: buttonStyle(AppColors.colorGreydark),
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                      //   fontSize: (isPortrait
                      //       ? FontConstants.fontSize022.h
                      //       : FontConstants.fontSize025.h),
                      //   buttonText: "Save for later".tr,
                      //   textColor: AppColors.colorWhite,
                      //   fontweight: FontWeight.w600,
                      // ),
                      MainCustomIconButton(
                        buttonStyle: buttonStyle(AppColors.bubbleColor),
                        onPressed: selectedIndex == null
                            ? () {}
                            : () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child:          EditSurvey(
                                      eventID: widget.eventID,
                                      isCreateNew: true,
                                      survey: surveyController
                                          .filteredSurveys[selectedIndex!],
                                    ),
                                  ),
                                );
                              },
                        buttonText: "Next".tr,
                      
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    ]);
  }
}
