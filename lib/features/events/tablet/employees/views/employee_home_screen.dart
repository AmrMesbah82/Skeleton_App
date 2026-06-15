import 'package:demo_app/features/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/form_fields/custom_search.dart';
import 'package:demo_app/core/widgets/custom_upper_filter.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/events/components/filter_event_dialog.dart';
import 'package:demo_app/features/events/components/reusable_icon_container.dart';
import 'package:demo_app/features/events/controllers/employee_controller.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/approvals_events_container.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/event_container_history.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/page_screenstop_level.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/survey_pop_menu.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/event_details.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:page_transition/page_transition.dart';

class EmployeeEventsHomeScreen extends StatefulWidget {
  const EmployeeEventsHomeScreen({super.key});

  @override
  State<EmployeeEventsHomeScreen> createState() =>
      _EmployeeEventsHomeScreenState();
}

class _EmployeeEventsHomeScreenState extends State<EmployeeEventsHomeScreen> {
  String? status = "Accepted";

  final EventsEmployeeController employeeController = Get.put(EventsEmployeeController());
  SurveyController surveyController = Get.put(SurveyController());

  @override
  void initState() {
    employeeController.filterEvents(employeeController.employeeSelectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GetBuilder<EventsEmployeeController>(
        builder: (employeeController) => PageScreenTopLevel(
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
                      selectedIndex: employeeController.employeeSelectedIndex,
                      selectedDepartmentState: (value) {},
                      selectedIndexState:
                          employeeController.employeeFilterState,
                      filterTitles: employeeController.approvalEvents.isEmpty
                          ? employeeController.filtersDataEmployeeNoApprovals
                          : employeeController.filtersDataEmployee),
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
                                    MyThemeData.lightTheme
                                ? MyThemeData.colorWhite
                                : Theme.of(context).colorScheme.inversePrimary,
                            hint: "Search".tr,
                            onChanged: employeeController.onSearchTextChanged,
                            hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: orientation
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.015.w),
                      child: ReusableIconContainer(
                        imagePath: "assets/images/filter_table.svg",
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return FilterEventDialog(
                                  isEmployee: true,
                                  isSurvey: false,
                                  onReset: employeeController.resetFilter,
                                  departmentDropDownItems:
                                      employeeController.departmentOwnerItems,
                                  dateValue: employeeController.dateFilter,
                                  dateValueState:
                                      employeeController.filterDateValueState,
                                  departmentState: employeeController
                                      .filterDepartmentValueState,
                                  departmentValue:
                                      employeeController.departmetFilter,
                                  typeDropDownItems:
                                      employeeController.typesFilter,
                                  typeValue: employeeController.typeFilter,
                                  typetState:
                                      employeeController.filterTypeValueState,
                                  status: employeeController.statusFilter,
                                  statusDropDownItems: employeeController
                                      .statusFilterDropDownItems,
                                  statusState:
                                      employeeController.filterStatusValueState,
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
                SizedBox(
                  height: orientation ? 0.01.h : 0.015.h,
                ),
                Expanded(
                  child: ListView.builder(
padding: EdgeInsets.zero,
                      itemCount: employeeController.filteredevents.length,
                      itemBuilder: (context, index) {
                        int firstIndex = index * 2;
                        int secondIndex = firstIndex + 1;
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: orientation ? 0.01.h : 0.015.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: employeeController
                                        .employeeSelectedIndex ==
                                    1
                                ? [
                                    firstIndex <
                                            employeeController
                                                .filteredevents.length
                                        ? Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child:                 EditEvent(
                                                      event: employeeController
                                                          .filteredevents[
                                                      firstIndex],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: EventContainerHistory(
                                                  isEmployee: true,
                                                  event: employeeController
                                                          .filteredevents[
                                                      firstIndex],
                                                  selectedIndex: firstIndex,
                                                  status: status,
                                                  survey: employeeController
                                                      .getSurvryByEventId(
                                                          employeeController
                                                              .filteredevents[
                                                                  firstIndex]
                                                              .id)),
                                            ),
                                          )
                                        : Expanded(child: Container()),
                                    SizedBox(
                                      width: orientation ? 0.01.w : 0.02.w,
                                    ),
                                    secondIndex <
                                            employeeController
                                                .filteredevents.length
                                        ? Expanded(
                                            child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      type: PageTransitionType
                                                          .fade,
                                                      child:
                                                      EditEvent(
                                                        event: employeeController
                                                            .filteredevents[
                                                        secondIndex],
                                                      )

                                                    ),
                                                  );
                                                },
                                                child: EventContainerHistory(
                                                  isEmployee: true,
                                                  status: status,
                                                  event: employeeController
                                                          .filteredevents[
                                                      secondIndex],
                                                  selectedIndex: secondIndex,
                                                  survey: employeeController
                                                      .getSurvryByEventId(
                                                          employeeController
                                                              .filteredevents[
                                                                  secondIndex]
                                                              .id),
                                                )))
                                        : Expanded(child: Container()),
                                  ]
                                : employeeController.employeeSelectedIndex == 2
                                    ? [
                                        firstIndex <
                                                employeeController
                                                    .filteredevents.length
                                            ? Expanded(
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .fade,
                                                          child:             EditEvent(
                                                            event: employeeController
                                                                .filteredevents[
                                                            firstIndex],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child:
                                                        ApprovalEventContainer(
                                                      isEmployee: true,
                                                      survey: employeeController
                                                          .getSurvryByEventId(
                                                              employeeController
                                                                  .filteredevents[
                                                                      firstIndex]
                                                                  .id),
                                                      event: employeeController
                                                              .filteredevents[
                                                          firstIndex],
                                                    )))
                                            : Expanded(child: Container()),
                                        SizedBox(
                                          width: orientation ? 0.015.w : 0.02.w,
                                        ),
                                        secondIndex <
                                                employeeController
                                                    .filteredevents.length
                                            ? Expanded(
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .fade,
                                                          child:             EditEvent(
                                                            event: employeeController
                                                                .filteredevents[
                                                            secondIndex],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child:
                                                        ApprovalEventContainer(
                                                      isEmployee: true,
                                                      survey: employeeController
                                                          .getSurvryByEventId(
                                                              employeeController
                                                                  .filteredevents[
                                                                      secondIndex]
                                                                  .id),
                                                      event: employeeController
                                                              .filteredevents[
                                                          secondIndex],
                                                    )))
                                            : Expanded(child: Container()),
                                      ]
                                    : [
                                        firstIndex <
                                                employeeController
                                                    .filteredevents.length
                                            ? Expanded(
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .fade,
                                                          child:          EditEvent(
                                                            event: employeeController
                                                                .filteredevents[
                                                            firstIndex],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child:
                                                        ApprovalEventContainer(
                                                      isEmployee: true,
                                                      statusGiven:
                                                          employeeController
                                                                  .filteredevents[
                                                                      firstIndex]
                                                                  .status !=
                                                              "Pending",
                                                      survey: employeeController
                                                          .getSurvryByEventId(
                                                              employeeController
                                                                  .filteredevents[
                                                                      firstIndex]
                                                                  .id),
                                                      event: employeeController
                                                              .filteredevents[
                                                          firstIndex],
                                                    )))
                                            : Expanded(child: Container()),
                                        SizedBox(
                                          width: orientation ? 0.01.w : 0.02.w,
                                        ),
                                        secondIndex <
                                                employeeController
                                                    .filteredevents.length
                                            ? Expanded(
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .fade,
                                                          child:               EditEvent(
                                                            event: employeeController
                                                                .filteredevents[
                                                            secondIndex],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child:
                                                        ApprovalEventContainer(
                                                      isEmployee: true,
                                                      statusGiven:
                                                          employeeController
                                                                  .filteredevents[
                                                                      secondIndex]
                                                                  .status !=
                                                              "Pending",
                                                      survey: employeeController
                                                          .getSurvryByEventId(
                                                              employeeController
                                                                  .filteredevents[
                                                                      secondIndex]
                                                                  .id),
                                                      event: employeeController
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
            ));
  }
}
