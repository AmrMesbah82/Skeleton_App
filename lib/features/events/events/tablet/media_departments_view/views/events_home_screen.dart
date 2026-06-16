import 'package:demo_app/features/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/widgets/form_fields/custom_search.dart';
import 'package:demo_app/core/widgets/custom_upper_filter.dart';


import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/components/filter_event_dialog.dart';
import 'package:demo_app/features/events/components/reusable_icon_container.dart';
import 'package:demo_app/features/events/components/survey_card.dart';
import 'package:demo_app/features/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/approvals_events_container.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/event_container.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/event_container_history.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/page_screenstop_level.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/survey_pop_menu.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/create_event.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/event_details.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/survey/show_survey_screen.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:page_transition/page_transition.dart';

class EventsHomeScreen extends StatefulWidget {
  EventsHomeScreen({
    super.key,
    this.givenIndex,
  });

  int? givenIndex;

  @override
  State<EventsHomeScreen> createState() => _EventsHomeScreenState();
}

class _EventsHomeScreenState extends State<EventsHomeScreen> {
  final EventController eventController = Get.put(EventController());

  final SurveyController surveyController = Get.put(SurveyController());
  @override
  void initState() {
    eventController.filterEvents(eventController.eventHomeSelectedIndexFilter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    eventController.eventHomeSelectedIndexFilter =
        widget.givenIndex ?? eventController.eventHomeSelectedIndexFilter;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GetBuilder<EventController>(
      builder: (eventController) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: GetBuilder<SurveyController>(builder: (surveyController) {
          return PageScreenTopLevel(
            children: [
              Row(
                children: [
                  Text(
                    "Events".tr,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: orientation
                          ? FontConstants.fontSize026.h
                          : FontConstants.fontSize026.w,
                      fontWeight: FontWeight.w600,
                       letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.02.h),
                child: UpperFilters(
                    selectedIndex: eventController.eventHomeSelectedIndexFilter,
                    selectedDepartmentState: (value) {},
                    selectedIndexState: eventController.changeFilterIndex,
                    filterTitles: eventController.filterTitles),
              ),
              Row(
                crossAxisAlignment: orientation
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: orientation ? 0.04.h : 0.052.h,
                      child: CustomSearchFiled2(
                          fillColor: themeController.currentTheme ==
                                  AppColors.lightTheme
                              ? AppColors.colorWhite
                              : Theme.of(context).colorScheme.inversePrimary,
                          hint: "Search".tr,
                          onChanged:
                              eventController.eventHomeSelectedIndexFilter == 5
                                  ? surveyController.onSearchTextChanged
                                  : eventController.onSearchTextChanged,
                          hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: orientation
                                  ? FontConstants.fontSize016.h
                                  : FontConstants.fontSize022.h,
                              fontWeight: FontWeight.w500,
                              // height: (isPortrait? 2.8 : 3.2)  ,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface),
                          keyBoardType: TextInputType.text),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.015.w),
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
                                    ? surveyController.departmentOwnerItems
                                    : eventController.departmentOwnerItems,
                                dateValue: eventController
                                            .eventHomeSelectedIndexFilter ==
                                        5
                                    ? surveyController.dateFilter
                                    : eventController.dateFilter,
                                dateValueState: eventController
                                            .eventHomeSelectedIndexFilter ==
                                        5
                                    ? surveyController.filterDateValueState
                                    : eventController.filterDateValueState,
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
                                    ? surveyController.filterTypeValueState
                                    : eventController.filterTypeValueState,
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

                    /* onPressed: () {
                      eventController.changeSortState();
                      eventController.isSortHomeEnabled
                          ? eventController.sortEventsByDate()
                          : eventController.resetSorting();
                    },*/
                  ),
                  eventController.eventHomeSelectedIndexFilter == 5
                      ? const SizedBox.shrink()
                      : SizedBox(
                          width: 0.015.w,
                        ),
                  eventController.eventHomeSelectedIndexFilter == 5
                      ? const SizedBox.shrink()
                      : CustomIconButton(
                        buttonHeight:  orientation ? 0.04.h : 0.052.h,
                          buttonText: "Create Event",
                          imagePath: "assets/images/events_knwoticed.svg",
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child:                                     const CreateEvent(),

                              ),
                            );
                          },
                        ),
                ],
              ),
              SizedBox(
                height: orientation ? 0.01.h : 0.015.h,
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                    itemCount: eventController.eventHomeSelectedIndexFilter == 5
                        ? surveyController.filteredSurveys.length
                        : eventController.filteredevents.length,
                    itemBuilder: (context, index) {
                      int firstIndex = index * 2;
                      int secondIndex = firstIndex + 1;
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: orientation ? 0.01.h : 0.015.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: eventController
                                      .eventHomeSelectedIndexFilter ==
                                  5
                              ? [
                                  firstIndex <
                                          surveyController
                                              .filteredSurveys.length
                                      ? Expanded(
                                          child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowSurveyScreen(
                                                      survey: firstIndex <
                                                          surveyController
                                                              .filteredSurveys
                                                              .length
                                                          ? surveyController
                                                          .filteredSurveys[
                                                      firstIndex]
                                                          : null,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: firstIndex <
                                                  surveyController
                                                      .filteredSurveys.length
                                              ? SurveyCard(
                                                  status: surveyController
                                                      .filteredSurveys[
                                                          firstIndex]
                                                      .status,
                                                  survey: firstIndex <
                                                          surveyController
                                                              .filteredSurveys
                                                              .length
                                                      ? surveyController
                                                              .filteredSurveys[
                                                          firstIndex]
                                                      : null,
                                                )
                                              : const SizedBox.shrink(),
                                        ))
                                      : Expanded(child: Container()),
                                  SizedBox(
                                    width: orientation ? 0.01.w : 0.02.w,
                                  ),
                                  secondIndex <
                                          surveyController
                                              .filteredSurveys.length
                                      ? Expanded(
                                          child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowSurveyScreen(
                                                      survey: secondIndex <
                                                          surveyController
                                                              .filteredSurveys
                                                              .length
                                                          ? surveyController
                                                          .filteredSurveys[
                                                      secondIndex]
                                                          : null,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: secondIndex <
                                                  surveyController
                                                      .filteredSurveys.length
                                              ? SurveyCard(
                                                  status: surveyController
                                                      .filteredSurveys[
                                                          secondIndex]
                                                      .status,
                                                  survey: surveyController
                                                          .filteredSurveys[
                                                      secondIndex],
                                                )
                                              : const SizedBox.shrink(),
                                        ))
                                      : Expanded(child: Container())
                                ]
                              : eventController.eventHomeSelectedIndexFilter ==
                                      6
                                  ? [
                                      firstIndex <
                                              eventController
                                                  .filteredevents.length
                                          ? Expanded(
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        child:               EditEvent(
                                                          event: eventController
                                                              .filteredevents[
                                                          firstIndex],
                                                          isApproval: true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: ApprovalEventContainer(
                                                    isEmployee: false,
                                                    survey: surveyController
                                                        .getSurvryByEventId(
                                                            eventController
                                                                .filteredevents[
                                                                    firstIndex]
                                                                .id),
                                                    event: eventController
                                                            .filteredevents[
                                                        firstIndex],
                                                  )))
                                          : Expanded(child: Container()),
                                      SizedBox(
                                        width: orientation ? 0.015.w : 0.02.w,
                                      ),
                                      secondIndex <
                                              eventController
                                                  .filteredevents.length
                                          ? Expanded(
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        child:                EditEvent(
                                                          event: eventController
                                                              .filteredevents[
                                                          secondIndex],
                                                          isApproval: true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: ApprovalEventContainer(
                                                    isEmployee: false,
                                                    survey: surveyController
                                                        .getSurvryByEventId(
                                                            eventController
                                                                .filteredevents[
                                                                    secondIndex]
                                                                .id),
                                                    event: eventController
                                                            .filteredevents[
                                                        secondIndex],
                                                  )))
                                          : Expanded(child: Container()),
                                    ]
                                  : eventController
                                              .eventHomeSelectedIndexFilter ==
                                          3
                                      ? [
                                          firstIndex <
                                                  eventController
                                                      .filteredevents.length
                                              ? Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        Navigator
                                                            .push(
                                                          context,
                                                          PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child:                 EditEvent(
                                                              event: eventController
                                                                  .filteredevents[
                                                              firstIndex],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child:
                                                          EventContainerHistory(
                                                        isEmployee: false,
                                                        selectedIndex:
                                                            firstIndex,
                                                        status: 'Accepted',
                                                        survey: surveyController
                                                            .getSurvryByEventId(
                                                                eventController
                                                                    .filteredevents[
                                                                        firstIndex]
                                                                    .id),
                                                        event: eventController
                                                                .filteredevents[
                                                            firstIndex],
                                                      )))
                                              : Expanded(child: Container()),
                                          SizedBox(
                                            width:
                                                orientation ? 0.015.w : 0.02.w,
                                          ),
                                          secondIndex <
                                                  eventController
                                                      .filteredevents.length
                                              ? Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        Navigator
                                                            .push(
                                                          context,
                                                          PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child:            EditEvent(
                                                              event: eventController
                                                                  .filteredevents[
                                                              secondIndex],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child:
                                                          EventContainerHistory(
                                                        isEmployee: false,
                                                        selectedIndex:
                                                            secondIndex,
                                                        status: 'Accepted',
                                                        survey: surveyController
                                                            .getSurvryByEventId(
                                                                eventController
                                                                    .filteredevents[
                                                                        secondIndex]
                                                                    .id),
                                                        event: eventController
                                                                .filteredevents[
                                                            secondIndex],
                                                      )))
                                              : Expanded(child: Container()),
                                        ]
                                      : [
                                          firstIndex <
                                                  eventController
                                                      .filteredevents.length
                                              ? Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        Navigator
                                                            .push(
                                                          context,
                                                          PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child:                EditEvent(
                                                              event: eventController
                                                                  .filteredevents[
                                                              firstIndex],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: EventContainer(
                                                        survey: surveyController
                                                            .getSurvryByEventId(
                                                                eventController
                                                                    .filteredevents[
                                                                        firstIndex]
                                                                    .id),
                                                        event: eventController
                                                                .filteredevents[
                                                            firstIndex],
                                                      )))
                                              : Expanded(child: Container()),
                                          SizedBox(
                                            width:
                                                orientation ? 0.015.w : 0.02.w,
                                          ),
                                          secondIndex <
                                                  eventController
                                                      .filteredevents.length
                                              ? Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        Navigator
                                                            .push(
                                                          context,
                                                          PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child:             EditEvent(
                                                              event: eventController
                                                                  .filteredevents[
                                                              secondIndex],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: EventContainer(
                                                        survey: surveyController
                                                            .getSurvryByEventId(
                                                                eventController
                                                                    .filteredevents[
                                                                        secondIndex]
                                                                    .id),
                                                        event: eventController
                                                                .filteredevents[
                                                            secondIndex],
                                                      )))
                                              : Expanded(child: Container()),
                                        ],
                        ),
                      );
                    }),
              )
            ],
          );
        }),
      ),
    );
  }
}
