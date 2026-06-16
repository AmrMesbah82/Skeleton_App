import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/controllers/employee_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/features/events/mobile/media_department/create_event_view.dart/add_guests_mobile.dart';
import 'package:demo_app/features/events/mobile/media_department/create_event_view.dart/add_info_mobile.dart';
import 'package:demo_app/features/events/mobile/media_department/create_event_view.dart/event_info_mobile.dart';

class EditEventMobile extends StatefulWidget {
  const EditEventMobile({super.key, required this.event});
  final EventModel event;

  @override
  State<EditEventMobile> createState() => _EditEventMobileState();
}

class _EditEventMobileState extends State<EditEventMobile> {
  EventController eventController = Get.put(EventController());
  final EventsEmployeeController employeeController = Get.put(EventsEmployeeController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                title: "Edit Event",
                isHome: false,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.04.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.inversePrimary),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EventInformationMobile(
                            isEdit: true,
                            event: widget.event,
                          ),
                          AddInfoEventMobile(
                            event: widget.event,
                          ),
                          AddGuestsMobile(
                            isEdit: true,
                            event: widget.event,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.02.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomIconButton(
                            buttonText: "Save",
                            imagePath: "",
                            onPressed: () {
                              eventController
                                  .editEvent(widget.event, 'saved')
                                  .then(
                                (_) {
                                  eventController
                                      .fetchEmployees()
                                      .then((_) async {
                                    await eventController
                                        .fetchEventsFromFirebase()
                                        .then((value) => eventController
                                            .filterEvents(eventController
                                                .eventHomeSelectedIndexFilter));
                                    eventController.fetchApprovals();
                                    employeeController
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

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ResponseDialog(
                                        title: "Successful".tr,
                                        subtitle:
                                            "You Successfuly Edited This Event"
                                                .tr,
                                        lottieAsset:
                                            "assets/images/correct.json",
                                      );
                                    },
                                  );

                                  Future.delayed(
                                      const Duration(milliseconds: 1500), () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                },
                              );
                            },
                            hasIcon: false,
                          ),
                          SizedBox(
                            width: 0.02.w,
                          ),
                          CustomIconButton(
                              buttonText: "Publish".tr,
                              imagePath: "",
                              hasIcon: false,
                              onPressed: () {
                                eventController
                                    .editEvent(widget.event, 'sent')
                                    .then(
                                  (_) {
                                    eventController
                                        .fetchEmployees()
                                        .then((_) async {
                                      await eventController
                                          .fetchEventsFromFirebase()
                                          .then((value) => eventController
                                              .filterEvents(eventController
                                                  .eventHomeSelectedIndexFilter));
                                      eventController.fetchApprovals();
                                      employeeController
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

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ResponseDialog(
                                          title: "Successful".tr,
                                          subtitle:
                                              "You Successfuly Edited This Event"
                                                  .tr,
                                          lottieAsset:
                                              "assets/images/correct.json",
                                        );
                                      },
                                    );

                                    Future.delayed(
                                        const Duration(milliseconds: 1500), () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  },
                                );
                              }),
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
    );
  }
}
