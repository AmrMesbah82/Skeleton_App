import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/widgets/loading.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/controllers/notification_controller.dart';
import 'package:demo_app/features/skeleton/events/controllers/employee_controller.dart';
import 'package:demo_app/features/skeleton/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/skeleton/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/settings_screen.dart';

class RejectionResonDialog extends StatelessWidget {
  RejectionResonDialog({
    super.key,
    required this.employeeController,
    required this.isEmployee,
    required this.eventController,
    required this.event,
  });
  bool isEmployee;
  EventsEmployeeController employeeController;
  EventController eventController;
  EventModel event;

  AppNotificationController notificationController =
      Get.put(AppNotificationController());

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? 0.2.w : 0.15.w),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.inversePrimary),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const FiltersAppBar(
                imageUrl: "assets/images/filter_table.svg",
                title: "Filter",
                hideIcon: true,
              ),
              ColumnRequestData(
                controllerState: (value) {
                  print('value description ${value!}');
                },
                title: "",
                hideTitle: true,
                isTextField: true,
                hint: "Text Here",
                isOptional: false,
                isExpanded: true,
                maxlines: 6,
                textController: isEmployee
                    ? employeeController.rejectionReason
                    : eventController.rejectionReason,
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.02.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomIconButton(
                        buttonText: "Submit",
                        imagePath: "",
                        hasIcon: false,
                        onPressed: () {
                          Navigator.pop(context);
                          showLoadingIndicator();
                          if (isEmployee) {
                            if (employeeController.employeeSelectedIndex == 2) {
                              employeeController
                                  .updateApprovalStatus(event.id, "canceled")
                                  .then((_) async {
                                //employee fetch
                                await employeeController.fetchEmployees();
                                await employeeController
                                    .fetchEventsFromFirebase();
                                employeeController.fetchApprovals();
                                //event fetch
                                await eventController.fetchEmployees();
                                await eventController.fetchEventsFromFirebase();
                                eventController.fetchApprovals();
                                hideLoadingIndicator();
                              });
                            } else {
                              employeeController
                                  .updateInvitationStatus(event.id, "Rejected")
                                  .then((_) async {
                                //employee fetch
                                await employeeController.fetchEmployees();
                                await employeeController
                                    .fetchEventsFromFirebase();
                                employeeController.fetchApprovals();
                                //event fetch
                                await eventController.fetchEmployees();
                                await eventController.fetchEventsFromFirebase();
                                eventController.fetchApprovals();
                                await notificationController.sendNotification(
                                    title: event.eventNameEnglish,
                                    arabicTitle: event.eventNameArabic,
                                    body:
                                        "${employee!.email.last!.split('@')[0]} Rejected your invitation to ${event.eventNameEnglish}",
                                    arabicBody:
                                        "${employee!.email.last!.split('@')[0]} رفض دعوتك ل ${event.eventNameArabic}",
                                    type: "note",
                                    topic: event.eventCreator
                                        .replaceAll("@", "_"));
                                await notificationController
                                    .unsubscribeFromTopic(event.id);

                                hideLoadingIndicator();
                              });
                            }
                          } else {
                            eventController
                                .updateApprovalStatus(event.id, "canceled")
                                .then((_) async {
                              //employee fetch
                              await employeeController.fetchEmployees();
                              await employeeController
                                  .fetchEventsFromFirebase();
                              employeeController.fetchApprovals();
                              //event fetch
                              await eventController.fetchEmployees();
                              await eventController.fetchEventsFromFirebase();
                              eventController.fetchApprovals();

                              hideLoadingIndicator();
                            });
                          }
                          eventController.filterEvents(
                              eventController.eventHomeSelectedIndexFilter);

                          eventController.update();
                          employeeController.update();
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
