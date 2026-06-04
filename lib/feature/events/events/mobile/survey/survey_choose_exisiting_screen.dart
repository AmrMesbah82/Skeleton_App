import 'package:demo_app/feature/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/form_fields/custom_search.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/events/components/filter_event_dialog.dart';
import 'package:demo_app/feature/events/components/reusable_icon_container.dart';
import 'package:demo_app/feature/events/components/survey_card.dart';
import 'package:demo_app/feature/events/mobile/survey/edit_survey_mobile.dart';
import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:demo_app/nav_bar_package.dart/functions.dart';
import 'package:demo_app/nav_bar_package.dart/model.dart';

class SurveyChooseExisiting extends StatefulWidget {
  const SurveyChooseExisiting({super.key, required this.eventID});
  final String eventID;
  @override
  State<SurveyChooseExisiting> createState() => _SurveyChooseExisitingState();
}

class _SurveyChooseExisitingState extends State<SurveyChooseExisiting> {
  int? selectedIndex;
  ButtonStyle buttonStyle(Color buttonColor) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return ElevatedButton.styleFrom(
        backgroundColor: buttonColor, //MyThemeData.bubbleColor,
        minimumSize: isTablet ? Size(0.1.w, 0.053.h) : Size(0.4.w, 0.042.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
  }

  SurveyController surveyController = Get.put(SurveyController());
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
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      body: SafeArea(
          child: GetBuilder<SurveyController>(
        init: SurveyController(),
        builder: (surveyController) => SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBarMobile(
                showIcon: true,
                title: "Choose Survey".tr,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.04.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomSearchFiled2(
                              fillColor: themeController.currentTheme ==
                                      MyThemeData.lightTheme
                                  ? MyThemeData.colorWhite
                                  : Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                              hint: "Search".tr,
                              onChanged: surveyController.onSearchTextChanged,
                              hintStyle: AppFontStyle.cairoRegularStyle
                                  .copyWith(
                                      fontSize: FontConstants.fontSize018.h,
                                      fontWeight: FontWeight.w400,
                                      height: 2.4,
                                      color:
                                          Theme.of(context).colorScheme.scrim),
                              keyBoardType: TextInputType.text),
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
                                    onReset:
                                        surveyController.resetFilterExisting,
                                    departmentDropDownItems:
                                        surveyController.departmentOwnerItems,
                                    dateValue:
                                        surveyController.dateFilterExisting,
                                    dateValueState: surveyController
                                        .filterDateValueExisitingState,
                                    departmentState: surveyController
                                        .filterDepartmentValueExisitingState,
                                    departmentValue: surveyController
                                        .departmetFilterExisting,
                                    typeDropDownItems:
                                        surveyController.typesFilterExisting,
                                    typeValue:
                                        surveyController.typeFilterExisting,
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
                    ListView.builder(
padding: EdgeInsets.zero,
                        itemCount: surveyController.filteredSurveys.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 0.015.h),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  /* surveyController
                                          .filteredSurveys[index].isSelected =
                                      !surveyController
                                          .filteredSurveys[index].isSelected;*/
                                  selectedIndex = index;
                                });
                              },
                              child: SurveyCard(
                                status: surveyController
                                    .filteredSurveys[index].status,
                                isSelction: true,
                                survey: surveyController.filteredSurveys[index],
                                isSelcted: selectedIndex == index,
                              ),
                            ),
                          );
                        }),
                    Padding(
                      padding: EdgeInsets.only(top: 0.01.h),
                      child: Row(
                        // direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          // Expanded(
                          //   child: Container(),
                          //   // child: CustomElevatedButton(
                          //   //   buttonStyle: buttonStyle(MyThemeData.colorGreydark),
                          //   //   onPressed: () {
                          //   //     Navigator.pop(context);
                          //   //   },
                          //   //   fontSize: isTablet
                          //   //       ? (orientation
                          //   //           ? FontConstants.fontSize022.h
                          //   //           : FontConstants.fontSize025.h)
                          //   //       : FontConstants.fontSize014.h,
                          //   //   buttonText: "Save for later".tr,
                          //   //   textColor: MyThemeData.colorWhite,
                          //   //   fontweight: FontWeight.w600,
                          //   // ),
                          // ),

                          MainCustomIconButton(
                            buttonStyle: buttonStyle(MyThemeData.bubbleColor),
                            onPressed: selectedIndex == null
                                ? () {}
                                : () {
                                    for (int i = 0;
                                        i <
                                            surveyController
                                                .filteredSurveys.length;
                                        i++) {
                                      if (surveyController
                                          .filteredSurveys[i].isSelected) {
                                        surveyController.filteredSurveys[i]
                                            .isSelected = false;
                                      }
                                    }
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.fade,
                                      screen: EditSurveyMobile(
                                        eventID: widget.eventID,
                                        isCreateNew: true,
                                        survey: surveyController
                                            .filteredSurveys[selectedIndex!],
                                      ),
                                      withNavBar: false,
                                    );
                                  },
                            buttonText: "Next".tr,
       
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
