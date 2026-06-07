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
import 'package:demo_app/features/skeleton/events/controllers/employee_controller.dart';
import 'package:demo_app/features/skeleton/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/components/approvals_events_container.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/components/event_container.dart';
import 'package:demo_app/features/skeleton/events/mobile/event_details_mobiel.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/components/event_container_history.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/components/survey_pop_menu.dart';
import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';
import 'package:demo_app/nav_bar_package.dart/functions.dart';
import 'package:demo_app/nav_bar_package.dart/model.dart';

class EmployeeHomeMobile extends StatefulWidget {
  const EmployeeHomeMobile({super.key});

  @override
  State<EmployeeHomeMobile> createState() => _EmployeeHomeMobileState();
}

class _EmployeeHomeMobileState extends State<EmployeeHomeMobile> {
  String? status = "Rejected".tr;

  final EventsEmployeeController employeeController = Get.put(EventsEmployeeController());

  @override
  void initState() {
    employeeController.filterEvents(employeeController.employeeSelectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventsEmployeeController>(
        builder: (employeeController) => Scaffold(
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBarMobile(
                      showIcon: true,
                      title: "Events",
                      isEmployees: true,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.04.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.02.h),
                            child: UpperFilters(
                                selectedIndex:
                                    employeeController.employeeSelectedIndex,
                                selectedDepartmentState: (value) {},
                                selectedIndexState:
                                    employeeController.employeeFilterState,
                                filterTitles:
                                    employeeController.approvalEvents.isEmpty
                                        ? employeeController
                                            .filtersDataEmployeeNoApprovals
                                        : employeeController
                                            .filtersDataEmployee),
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
                                    onChanged:
                                        employeeController.onSearchTextChanged,
                                    hintStyle: AppFontStyle.cairoRegularStyle
                                        .copyWith(
                                            fontSize:
                                                FontConstants.fontSize018.h,
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
                                            isEmployee: true,
                                            isSurvey: false,
                                            onReset:
                                                employeeController.resetFilter,
                                            departmentDropDownItems:
                                                employeeController
                                                    .departmentOwnerItems,
                                            dateValue:
                                                employeeController.dateFilter,
                                            dateValueState: employeeController
                                                .filterDateValueState,
                                            departmentState: employeeController
                                                .filterDepartmentValueState,
                                            departmentValue: employeeController
                                                .departmetFilter,
                                            typeDropDownItems:
                                                employeeController.typesFilter,
                                            typeValue:
                                                employeeController.typeFilter,
                                            typetState: employeeController
                                                .filterTypeValueState,
                                            status:
                                                employeeController.statusFilter,
                                            statusDropDownItems:
                                                employeeController
                                                    .statusFilterDropDownItems,
                                            statusState: employeeController
                                                .filterStatusValueState,
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

                                  await sortMenu.showSortMenu(context,
                                      iconPosition, "sort".tr, null, '');
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0.015.h),
                            child: SizedBox(
                              height: 0.63.h,
                              child: ListView.builder(
padding: EdgeInsets.zero,
                                  itemCount: employeeController
                                              .employeeSelectedIndex ==
                                          2
                                      ? employeeController.filteredevents.length
                                      : employeeController
                                                  .employeeSelectedIndex ==
                                              1
                                          ? employeeController
                                              .filteredevents.length
                                          : employeeController
                                              .filteredevents.length,
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
                                                    PersistentNavBarNavigator
                                                        .pushNewScreen(
                                                      context,
                                                      pageTransitionAnimation:
                                                          PageTransitionAnimation
                                                              .fade,
                                                      screen:
                                                          EventDetailsMobile(
                                                        isApprovals: true,
                                                        event: employeeController
                                                                .filteredevents[
                                                            index],
                                                      ),
                                                      withNavBar: false,
                                                    );
                                                  },
                                                  child: employeeController
                                                              .employeeSelectedIndex ==
                                                          2
                                                      ? ApprovalEventContainer(
                                                          isEmployee: true,
                                                          statusGiven:
                                                              employeeController
                                                                      .filteredevents[
                                                                          index]
                                                                      .status !=
                                                                  "Pending",
                                                          survey: employeeController
                                                              .getSurvey(
                                                                  eventId: employeeController
                                                                      .filteredevents[
                                                                          index]
                                                                      .id),
                                                          event: employeeController
                                                                  .filteredevents[
                                                              index],
                                                        )
                                                      : employeeController
                                                                  .employeeSelectedIndex ==
                                                              1
                                                          ? EventContainerHistory(
                                                              isEmployee: true,
                                                              status:
                                                                  "Accepted",
                                                              selectedIndex:
                                                                  index,
                                                              event: employeeController
                                                                      .filteredevents[
                                                                  index],
                                                              survey: employeeController.getSurvey(
                                                                  eventId: employeeController
                                                                      .filteredevents[
                                                                          index]
                                                                      .id),
                                                            )
                                                          : ApprovalEventContainer(
                                                              isEmployee: true,
                                                              statusGiven: employeeController
                                                                      .filteredevents[
                                                                          index]
                                                                      .status !=
                                                                  "Pending",
                                                              survey: employeeController.getSurvey(
                                                                  eventId: employeeController
                                                                      .filteredevents[
                                                                          index]
                                                                      .id),
                                                              event: employeeController
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
            ));
  }
}
