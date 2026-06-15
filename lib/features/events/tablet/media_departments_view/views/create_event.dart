import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/widgets/title_row.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/constants/image_paths.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/events/controllers/employee_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/page_screenstop_level.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/create_event_views/add_info.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/create_event_views/event_information.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/create_event_views/invite_guests.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/events_home_screen.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:page_transition/page_transition.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final EventController eventController = Get.put(EventController());

  final EventsEmployeeController employeeController = Get.put(EventsEmployeeController());

  @override
  void initState() {
    eventController.createEventpageIndex = 0;
    eventController.clearData();
    eventController.fetchEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: GetBuilder<EventController>(
        builder: (eventController) => PageScreenTopLevel(children: [
          titleRow(context, orientation, "Create New Event", () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child:                     EventsHomeScreen(),

              ),
            );

            eventController.createEventpageIndex = 0;
          }),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.02.h),
            child: Text(
              Get.locale.toString().contains('en')
                  ? "${'Step '.tr}${eventController.createEventpageIndex + 1} ${'of'.tr} 3: ${eventController.createEventpageIndex == 0 ? 'Event Information'.tr : eventController.createEventpageIndex == 1 ? 'Additional Information'.tr : 'Invite Guests'.tr}"
                      .tr
                  : convertNumberToArabic(
                      "${'Step '.tr}${eventController.createEventpageIndex + 1} ${'of'.tr} 3: ${eventController.createEventpageIndex == 0 ? 'Event Information'.tr : eventController.createEventpageIndex == 1 ? 'Additional Information'.tr : 'Invite Guests'.tr}"),
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: orientation
                    ? FontConstants.fontSize019.h
                    : FontConstants.fontSize019.w,
                fontWeight: FontWeight.w600,
                 letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.inversePrimary),
                      child: eventController.createEventpageIndex == 1
                          ? const SingleChildScrollView(child: AddInfoEvent())
                          : eventController.createEventpageIndex == 2
                              ? const SingleChildScrollView(child: AddGuests())
                              : const SingleChildScrollView(
                                  child: EventInformation()));
                }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 0.02.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: eventController.createEventpageIndex == 2
                  ? [
                      CustomIconButton(
                        buttonText: "back",
                        imagePath: "",
                        onPressed: () {
                          eventController.perviousStepCreateEvent();
                        },
                        hasIcon: false,
                        buttonColor: MyThemeData.colorWhiteDark,
                        textColor: MyThemeData.colorBlack,
                      ),
                      Row(
                        children: [
                          eventController.createEventpageIndex == 0
                              ? Container()
                              : CustomIconButton(
                                  buttonText:
                                      eventController.createEventpageIndex == 2
                                          ? "Save for later"
                                          : "back",
                                  imagePath: "",
                                  onPressed: eventController
                                                  .createEventpageIndex >
                                              0 &&
                                          eventController
                                                  .createEventpageIndex !=
                                              2
                                      ? eventController.perviousStepCreateEvent
                                      : () {
                                          if (eventController
                                                  .createEventpageIndex ==
                                              2) {
                                            eventController
                                                .createEvent("saved")
                                                .then((_) async {
                                              await eventController
                                                  .fetchEmployees();
                                              await eventController
                                                  .fetchEventsFromFirebase();
                                              eventController.fetchApprovals();
                                              await Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child:                                                       EventsHomeScreen(),

                                                ),
                                              );

                                              eventController
                                                  .createEventpageIndex = 0;
                                            });
                                          }
                                        },
                                  hasIcon: false,
                                  buttonColor: MyThemeData.colorWhiteDark,
                                  textColor: MyThemeData.colorBlack,
                                ),
                          SizedBox(width: 0.02.w),
                          CustomIconButton(
                            buttonText:
                                eventController.createEventpageIndex == 2
                                    ? "Confirm"
                                    : "Next",
                            imagePath: "",
                            onPressed: eventController.createEventpageIndex < 2
                                ? eventController.nextStepCreateEvent
                                : () {
                                    if (eventController.createEventpageIndex ==
                                        2) {
                                      eventController
                                          .createEvent("sent")
                                          .then((_) async {
                                        await eventController.fetchEmployees();
                                        await eventController
                                            .fetchEventsFromFirebase();
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

                                            await employeeController
                                                .fetchSurveys();
                                          });
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child:                                                   EventsHomeScreen(),

                                            ),
                                          );
                                          eventController.createEventpageIndex =
                                              0;
                                        });
                                      });
                                    }
                                  },
                            hasIcon: false,
                          ),
                        ],
                      )
                    ]
                  : [
                      eventController.createEventpageIndex == 0
                          ? Container()
                          : CustomIconButton(
                              buttonText:
                                  eventController.createEventpageIndex == 2
                                      ? "Save for later"
                                      : "back",
                              imagePath: "",
                              onPressed: eventController.createEventpageIndex >
                                          0 &&
                                      eventController.createEventpageIndex != 2
                                  ? eventController.perviousStepCreateEvent
                                  : () {
                                      if (eventController
                                              .createEventpageIndex ==
                                          2) {
                                        eventController
                                            .createEvent("saved")
                                            .then((_) async {
                                          await eventController
                                              .fetchEventsFromFirebase();
                                          await Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child: EventsHomeScreen(),
                                            ),
                                          );

                                          eventController.createEventpageIndex =
                                              0;
                                        });
                                      }
                                    },
                              hasIcon: false,
                              buttonColor: MyThemeData.colorWhiteDark,
                              textColor: MyThemeData.colorBlack,
                            ),
                      CustomIconButton(
                        buttonText: eventController.createEventpageIndex == 2
                            ? "Confirm"
                            : "Next",
                        imagePath: "",
                        onPressed: eventController.createEventpageIndex < 2
                            ? eventController.nextStepCreateEvent
                            : () {
                                if (eventController.createEventpageIndex == 2) {
                                  eventController
                                      .createEvent("sent")
                                      .then((_) async {
                                    await eventController
                                        .fetchEventsFromFirebase();
                                  });
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child:  EventsHomeScreen(),
                                    ),
                                  );

                                  eventController.createEventpageIndex = 0;
                                }
                              },
                        hasIcon: false,
                      ),
                    ],
            ),
          )
        ]),
      ),
    );
  }
}
