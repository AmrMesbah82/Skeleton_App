import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/widgets/form_fields/custom_search.dart';
import 'package:demo_app/core/widgets/custom_upper_filter.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/events/components/filter_event_dialog.dart';
import 'package:demo_app/features/skeleton/events/components/reusable_icon_container.dart';
import 'package:demo_app/features/skeleton/events/components/survey_card.dart';
import 'package:demo_app/features/skeleton/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/skeleton/events/mobile/event_details_mobiel.dart';
import 'package:demo_app/features/skeleton/events/mobile/media_department/create_event_mobile.dart';
import 'package:demo_app/features/skeleton/events/mobile/survey/show_survey_mobile.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/components/approvals_events_container.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/components/event_container.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/components/event_container_history.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/components/survey_pop_menu.dart';
import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:demo_app/nav_bar_package.dart/functions.dart';
import 'package:demo_app/nav_bar_package.dart/model.dart';
import 'package:page_transition/page_transition.dart';

class MediaDepartmentHomeMobile extends StatefulWidget {
  const MediaDepartmentHomeMobile({super.key});

  @override
  State<MediaDepartmentHomeMobile> createState() =>
      _MediaDepartmentHomeMobileState();
}

class _MediaDepartmentHomeMobileState extends State<MediaDepartmentHomeMobile> {
  final EventController eventController = Get.put(EventController());

  final SurveyController surveyController = Get.put(SurveyController());
  @override
  void initState() {
    surveyController.fetchSurveys();
    eventController.filterEvents(eventController.eventHomeSelectedIndexFilter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(
      builder: (eventController) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: GetBuilder<SurveyController>(builder: (surveyController) {
          return Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBarMobile(
                    showIcon: true,
                    title: "Events",
                    isEmployees: true,
                    imagePath: '',
                    onTapUp: (TapUpDetails tap) {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: const CreateEventMobile(),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.04.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.01.h),
                          child: UpperFilters(
                              selectedIndex:
                                  eventController.eventHomeSelectedIndexFilter,
                              selectedDepartmentState: (value) {},
                              selectedIndexState:
                                  eventController.changeFilterIndex,
                              filterTitles: eventController.filterTitles),
                        ),
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
                                  onChanged: eventController
                                              .eventHomeSelectedIndexFilter ==
                                          5
                                      ? surveyController.onSearchTextChanged
                                      : eventController.onSearchTextChanged,
                                  hintStyle: AppFontStyle.cairoRegularStyle
                                      .copyWith(
                                          fontSize: FontConstants.fontSize018.h,
                                          fontWeight: FontWeight.w400,
                                          height: 2.4,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .scrim),
                                  keyBoardType: TextInputType.text),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 0.015.w),
                              child: ReusableIconContainer(
                                imagePath: "assets/images/filter_table.svg",
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return FilterEventDialog(
                                          isEmployee: false,
                                          isSurvey: eventController
                                                      .eventHomeSelectedIndexFilter ==
                                                  5
                                              ? true
                                              : false,
                                          onReset: eventController
                                                      .eventHomeSelectedIndexFilter ==
                                                  5
                                              ? surveyController.resetFilter
                                              : eventController.resetFilter,
                                          departmentDropDownItems: eventController
                                                      .eventHomeSelectedIndexFilter ==
                                                  5
                                              ? surveyController
                                                  .departmentOwnerItems
                                              : eventController
                                                  .departmentOwnerItems,
                                          dateValue: eventController
                                                      .eventHomeSelectedIndexFilter ==
                                                  5
                                              ? surveyController.dateFilter
                                              : eventController.dateFilter,
                                          dateValueState: eventController
                                                      .eventHomeSelectedIndexFilter ==
                                                  5
                                              ? surveyController
                                                  .filterDateValueState
                                              : eventController
                                                  .filterDateValueState,
                                          departmentState: eventController
                                                      .eventHomeSelectedIndexFilter ==
                                                  5
                                              ? surveyController
                                                  .filterDepartmentValueState
                                              : eventController
                                                  .filterDepartmentValueState,
                                          departmentValue: eventController
                                                      .eventHomeSelectedIndexFilter ==
                                                  5
                                              ? surveyController.departmetFilter
                                              : eventController.departmetFilter,
                                          typeDropDownItems: eventController
                                                      .eventHomeSelectedIndexFilter ==
                                                  5
                                              ? surveyController.typesFilter
                                              : eventController.typesFilter,
                                          typeValue: eventController
                                                      .eventHomeSelectedIndexFilter ==
                                                  5
                                              ? surveyController.typeFilter
                                              : eventController.typeFilter,
                                          typetState: eventController
                                                      .eventHomeSelectedIndexFilter ==
                                                  5
                                              ? surveyController
                                                  .filterTypeValueState
                                              : eventController
                                                  .filterTypeValueState,
                                        );
                                      });
                                },
                              ),
                            ),
                            ReusableIconContainer(
                              imagePath: "assets/icons/sort_data.svg",
                              onTapUp: (details) async {
                                final iconPosition = details.globalPosition;
                                SurveyPopMenu sortMenu = SurveyPopMenu();

                                await sortMenu.showSortMenu(
                                    context, iconPosition, "sort".tr, null, '');
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 0.015.h, bottom: 0.015.h),
                          child: SizedBox(
                            child: ListView.builder(
padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: eventController
                                            .eventHomeSelectedIndexFilter ==
                                        5 // for the survey
                                    ? surveyController.filteredSurveys.length
                                    : eventController
                                                .eventHomeSelectedIndexFilter ==
                                            6
                                        ? eventController.filteredevents.length
                                        : eventController.filteredevents.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 0.01.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: GestureDetector(
                                                onTap: () {
                                                  eventController
                                                              .eventHomeSelectedIndexFilter ==
                                                          5
                                                      ? index <
                                                              surveyController
                                                                  .filteredSurveys
                                                                  .length
                                                          ? PersistentNavBarNavigator
                                                              .pushNewScreen(
                                                              context,
                                                              pageTransitionAnimation:
                                                                  PageTransitionAnimation
                                                                      .fade,
                                                              screen: ShowSurveyMobile(
                                                                  survey: index <
                                                                          surveyController
                                                                              .filteredSurveys
                                                                              .length
                                                                      ? surveyController
                                                                              .filteredSurveys[
                                                                          index]
                                                                      : null),
                                                              withNavBar: false,
                                                            )
                                                          : null
                                                      : eventController
                                                                  .eventHomeSelectedIndexFilter ==
                                                              6
                                                          ? PersistentNavBarNavigator
                                                              .pushNewScreen(
                                                              context,
                                                              pageTransitionAnimation:
                                                                  PageTransitionAnimation
                                                                      .fade,
                                                              screen:
                                                                  EventDetailsMobile(
                                                                event: eventController
                                                                        .filteredevents[
                                                                    index],
                                                                isApprovals:
                                                                    true,
                                                              ),
                                                              withNavBar: false,
                                                            )
                                                          : PersistentNavBarNavigator
                                                              .pushNewScreen(
                                                              context,
                                                              pageTransitionAnimation:
                                                                  PageTransitionAnimation
                                                                      .fade,
                                                              screen:
                                                                  EventDetailsMobile(
                                                                event: eventController
                                                                        .filteredevents[
                                                                    index],
                                                                isApprovals:
                                                                    false,
                                                              ),
                                                              withNavBar: false,
                                                            );
                                                },
                                                child: eventController
                                                            .eventHomeSelectedIndexFilter ==
                                                        5
                                                    ? index <
                                                            surveyController
                                                                .filteredSurveys
                                                                .length
                                                        ? SurveyCard(
                                                            survey: surveyController
                                                                    .filteredSurveys[
                                                                index],
                                                            status: surveyController
                                                                .filteredSurveys[
                                                                    index]
                                                                .status,
                                                          )
                                                        : const SizedBox
                                                            .shrink()
                                                    : eventController
                                                                .eventHomeSelectedIndexFilter ==
                                                            6
                                                        ? ApprovalEventContainer(
                                                            isEmployee: false,
                                                            survey: surveyController
                                                                .getSurvryByEventId(
                                                                    eventController
                                                                        .filteredevents[
                                                                            index]
                                                                        .id),
                                                            event: eventController
                                                                    .filteredevents[
                                                                index],
                                                          )
                                                        : eventController
                                                                    .eventHomeSelectedIndexFilter ==
                                                                3
                                                            ? EventContainerHistory(
                                                                isEmployee:
                                                                    false,
                                                                status:
                                                                    "Accepted",
                                                                selectedIndex:
                                                                    index,
                                                                event: eventController
                                                                        .filteredevents[
                                                                    index],
                                                                survey: surveyController.getSurvryByEventId(
                                                                    eventController
                                                                        .filteredevents[
                                                                            index]
                                                                        .id),
                                                              )
                                                            : EventContainer(
                                                                survey: surveyController.getSurvryByEventId(
                                                                    eventController
                                                                        .filteredevents[
                                                                            index]
                                                                        .id),
                                                                event: eventController
                                                                        .filteredevents[
                                                                    index],
                                                              ))),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
          );
        }),
      ),
    );
  }
}
