import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/core/widgets/title_row.dart';

import 'package:demo_app/core/constants/image_paths.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/controllers/employee_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/page_screenstop_level.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/create_event_views/add_info.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/create_event_views/event_information.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/create_event_views/invite_guests.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/event_details.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/events_home_screen.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:page_transition/page_transition.dart';

class EditEventTablet extends StatefulWidget {
  EditEventTablet({
    super.key,
    required this.event,
  });
  EventModel event;
  @override
  State<EditEventTablet> createState() => _EditEventTabletState();
}

class _EditEventTabletState extends State<EditEventTablet> {
  @override
  Widget build(BuildContext context) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    EventController eventController = Get.put(EventController());
    final EventsEmployeeController employeeController = Get.put(EventsEmployeeController());

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PageScreenTopLevel(
        
        children: [
        titleRow(context, orientation, "Edit Event", (){
           Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child:      EditEvent(
                    event: widget.event,
                  ),
                ),
              );
        }),
        SizedBox(
          height:  0.01.h,
        ),
        Expanded(
          child: Container(
              // height: 0.66.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.inversePrimary),
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EventInformation(
                          event: widget.event,
                        ),
                        AddInfoEvent(
                          event: widget.event,
                        ),
                        AddGuests(
                          isEdit: true,
                          event: widget.event,
                        ),
                      ],
                    ),
                  )
                ],
              ) /*SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventInformation(
                    event: widget.event,
                  ),
                  AddInfoEvent(
                    event: widget.event,
                  ),
                  AddGuests(
                    isEdit: true,
                    event: widget.event,
                  ),
                ],
              ),
            ),*/
              ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0.02.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomIconButton(
                buttonText: "Save",
                imagePath: "",
                onPressed: () {
                  eventController.editEvent(widget.event, "saved").then(
                    (_) {
                      eventController.fetchEmployees().then((_) async {
                        await eventController.fetchEventsFromFirebase().then(
                            (value) => eventController.filterEvents(
                                eventController.eventHomeSelectedIndexFilter));
                        eventController.fetchApprovals();
                        employeeController.fetchEmployees().then((value) async {
                          await employeeController
                              .fetchFilledSurveyModel()
                              .then((value) async {
                            await employeeController.fetchEventsFromFirebase();
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
                            subtitle: "You Successfuly Edited This Event".tr,
                            lottieAsset: "assets/images/correct.json",
                          );
                        },
                      );

                      Future.delayed(const Duration(milliseconds: 1500), () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child:  EventsHomeScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
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
                  buttonText: "Publish",
                  imagePath: "",
                  hasIcon: false,
                  onPressed: () {
                    eventController.editEvent(widget.event, "sent").then(
                      (_) {
                        eventController.fetchEmployees().then((_) async {
                          await eventController.fetchEventsFromFirebase().then(
                              (value) => eventController.filterEvents(
                                  eventController
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
                              subtitle: "You Successfuly Edited This Event".tr,
                              lottieAsset: "assets/images/correct.json",
                            );
                          },
                        );

                        Future.delayed(const Duration(milliseconds: 1500), () {
                          Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child:                                 EventsHomeScreen(),

                          ),
                          (Route<dynamic> route) => false,
                        );
                          
                        });
                      },
                    );
                  }),
            ],
          ),
        )
      ]),
    );
  }

  
}
