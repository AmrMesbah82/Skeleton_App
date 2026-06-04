import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/events/controllers/employee_controller.dart';
import 'package:demo_app/feature/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/feature/events/mobile/media_department/create_event_view.dart/add_guests_mobile.dart';
import 'package:demo_app/feature/events/mobile/media_department/create_event_view.dart/add_info_mobile.dart';
import 'package:demo_app/feature/events/mobile/media_department/create_event_view.dart/event_info_mobile.dart';

class CreateEventMobile extends StatefulWidget {
  const CreateEventMobile({super.key});

  @override
  State<CreateEventMobile> createState() => _CreateEventMobileState();
}

class _CreateEventMobileState extends State<CreateEventMobile> {
  final EventController eventController = Get.put(EventController());
  final EventsEmployeeController employeeController = Get.put(EventsEmployeeController());
  @override
  void initState() {
    eventController.createEventpageIndex = 0;
    eventController.clearData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(
      builder: (eventController) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBarMobile(
                  showIcon: true,
                  title: "Create Event",
                  isHome: false,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.04.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.02.h),
                        child: Text(
                          Get.locale.toString().contains('en')
                              ? "${'Step '.tr}${eventController.createEventpageIndex + 1} ${'of'.tr} 3: ${eventController.createEventpageIndex == 0 ? 'Event Information'.tr : eventController.createEventpageIndex == 1 ? 'Additional Information'.tr : 'Invite Guests'.tr}"
                                  .tr
                              : convertNumberToArabic(
                                  "${'Step '.tr}${eventController.createEventpageIndex + 1} ${'of'.tr} 3: ${eventController.createEventpageIndex == 0 ? 'Event Information'.tr : eventController.createEventpageIndex == 1 ? 'Additional Information'.tr : 'Invite Guests'.tr}"),
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: FontConstants.fontSize019.h,
                            fontWeight: FontWeight.w600,
                             letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.65.h,
                        child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary),
                                  child: eventController.createEventpageIndex ==
                                          1
                                      ? const AddInfoEventMobile()
                                      : eventController.createEventpageIndex ==
                                              2
                                          ? AddGuestsMobile()
                                          : EventInformationMobile());
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.02.h),
                        child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             eventController.createEventpageIndex > 0?
                           CustomIconButton(
                                    buttonText: "back",
                                    imagePath: "",
                                    onPressed:
                                        eventController.perviousStepCreateEvent,
                                    hasIcon: false,
                                    buttonColor: MyThemeData.colorWhiteDark,
                                    textColor: MyThemeData.colorBlack,
                                  ) : Expanded(child: Container()),
                            Row(
                              mainAxisAlignment:
                                  eventController.createEventpageIndex != 2
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                 
                                eventController.createEventpageIndex != 2
                                    ? SizedBox.shrink()
                                    : CustomIconButton(
                                        buttonText: eventController
                                                    .createEventpageIndex ==
                                                2
                                            ? "Save for later"
                                            : "back",
                                        imagePath: "",
                                        onPressed: eventController
                                                    .createEventpageIndex <
                                                2
                                            ? eventController
                                                .perviousStepCreateEvent
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
                                                    eventController
                                                        .fetchApprovals();
                                                  });
                                                }
                                                Navigator.pop(context);
                                                eventController
                                                    .createEventpageIndex = 0;
                                              },
                                        hasIcon: false,
                                        buttonColor: MyThemeData.colorWhiteDark,
                                        textColor: MyThemeData.colorBlack,
                                      ),
                                      
                                eventController.createEventpageIndex != 2
                                    ? SizedBox.shrink()
                                    : SizedBox(
                                        width: 0.04.w,
                                      ),
                                CustomIconButton(
                                  buttonText:
                                      eventController.createEventpageIndex == 2
                                          ? "Confirm"
                                          : "Next",
                                  imagePath: "",
                                  onPressed: eventController
                                              .createEventpageIndex <
                                          2
                                      ? eventController.nextStepCreateEvent
                                      : () {
                                          if (eventController
                                                  .createEventpageIndex ==
                                              2) {
                                            eventController
                                                .createEvent("sent")
                                                .then((_) async {
                                              await eventController
                                                  .fetchEmployees();
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
                                                  employeeController
                                                      .fetchApprovals();
                                                  await employeeController
                                                      .fetchSurveys();
                                                });
                                              });
                                            });
                                          }
                                          Navigator.pop(context);
                                          eventController.createEventpageIndex =
                                              0;
                                        },
                                  hasIcon: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
