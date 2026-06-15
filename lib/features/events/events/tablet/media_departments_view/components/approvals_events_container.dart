import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/features/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/widgets/loading.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/notification/notification_controller.dart';
import 'package:demo_app/features/events/components/row_icon_text.dart';
import 'package:demo_app/features/events/controllers/employee_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/features/events/tablet/employees/components/customized_drop_down.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/reson_of_rejection_dailog.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';

class ApprovalEventContainer extends StatefulWidget {
  ApprovalEventContainer(
      {super.key,
      this.statusGiven = false,
      this.status,
      this.statusSate,
      this.isHistory = false,
      this.survey,
      required this.event,
      required this.isEmployee});

  bool statusGiven;
  String? status;
  ValueChanged<String?>? statusSate;
  final bool isHistory;
  final EventModel event;
  final SurveyModel? survey;
  final bool isEmployee;

  @override
  State<ApprovalEventContainer> createState() => _ApprovalEventContainerState();
}

class _ApprovalEventContainerState extends State<ApprovalEventContainer> {
  EventController eventController = Get.put(EventController());
  EventsEmployeeController employeeController = Get.put(EventsEmployeeController());
  AppNotificationController notificationController =
      Get.put(AppNotificationController());

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.01.w, vertical: orientation ? 0.01.h : 0.02.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.event.eventPhoto,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: isTablet
                        ? orientation
                            ? 0.12.w
                            : 0.09.w
                        : 0.25.w,
                    height: isTablet
                        ? orientation
                            ? 0.1.h
                            : 0.14.h
                        : 0.12.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 0.01.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: isTablet
                              ? orientation
                                  ? widget.isHistory
                                      ? null
                                      : 0.21.w
                                  : widget.isHistory
                                      ? 0.24.w
                                      : 0.28.w
                              : widget.isHistory
                                  ? 0.5.w
                                  : 0.55.w,
                          child: RowIconTextEvent(
                              iconUrl: "",
                              text: "Name",
                              hideImage: true,
                              isFlexible: true,
                              value: Get.locale.toString().contains('en')
                                  ? widget.event.eventNameEnglish
                                  : widget.event.eventNameArabic),
                        ),
                      ],
                    ),
                    isTablet
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 0.01.h,
                          ),
                    RowIconTextEvent(
                        iconUrl: "",
                        text: "Type",
                        hideImage: true,
                        value: widget.event.type.toString()),
                    isTablet
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 0.01.h,
                          ),
                    RowIconTextEvent(
                        iconUrl: "",
                        text: "Department Owner",
                        hideImage: true,
                        value: widget.event.departmentOwner.toString()),
                    isTablet
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 0.01.h,
                          ),
                    RowIconTextEvent(
                        iconUrl: "",
                        text: "Date",
                        hideImage: true,
                        value: Get.locale.toString().contains('en')
                            ? widget.event.date
                            : translateDateFormatToArabic(widget.event.date)),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 0.01.h,
            ),
            widget.statusGiven
                ? CustomizedDropdownButton2(
                    hint: "",
                    value: widget.event.status!.capitalize!.tr,
                    buttonWidth: double.infinity,
                    buttonHeight: orientation ? 0.04.h : 0.05.h,
                    dropdownWidth: isTablet ? 0.4.w : 0.9.w,
                    dropdownItems: ['Accepted'.tr, 'Rejected'.tr],
                    iconColor: widget.event.status! == "Accepted"
                        ? MyThemeData.unBlock
                        : MyThemeData.colorRed,
                    buttonPadding: EdgeInsets.symmetric(horizontal: 0.01.w),
                    buttonDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            width: 1.5,
                            color: widget.event.status == "Accepted"
                                ? MyThemeData.unBlock
                                : MyThemeData.colorRed)
                        //  color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                    onChanged: (value) {
                      setState(() {
                        showLoadingIndicator();
                        widget.event.status = value;
                        // widget.statusSate!(widget.event.status);
                        if (value == "Rejected".tr) {
                          widget.event.status = "Rejected".tr;
                          widget.statusGiven = true;

                          if (widget.isEmployee) {
                            if (employeeController.employeeSelectedIndex == 2) {
                              employeeController
                                  .updateApprovalStatus(
                                      widget.event.id, "canceled")
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
                                  .updateInvitationStatus(
                                      widget.event.id, "Rejected")
                                  .then((_) async {
                                log("notification reject sent");
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
                                    title: widget.event.eventNameEnglish,
                                    arabicTitle: widget.event.eventNameArabic,
                                    body:
                                        "${employee!.email.last!.split('@')[0]} Rejected your invitation to ${widget.event.eventNameEnglish}",
                                    arabicBody:
                                        "${employee!.email.last!.split('@')[0]} رفض دعوتك ل ${widget.event.eventNameArabic}",
                                    type: "note",
                                    topic: widget.event.eventCreator);
                                await notificationController
                                    .unsubscribeFromTopic(widget.event.id);

                                hideLoadingIndicator();
                              });
                            }
                          } else {
                            eventController
                                .updateApprovalStatus(
                                    widget.event.id, "canceled")
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
                        } else {
                          widget.event.status = "Accepted".tr;
                          widget.statusGiven = true;

                          if (widget.isEmployee) {
                            if (employeeController.employeeSelectedIndex == 2) {
                              employeeController
                                  .updateApprovalStatus(widget.event.id, "sent")
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
                                  .updateInvitationStatus(
                                      widget.event.id, "Accepted")
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
                                await notificationController
                                    .unsubscribeFromTopic(widget.event.id);
                                await notificationController.sendNotification(
                                    title: widget.event.eventNameEnglish,
                                    arabicTitle: widget.event.eventNameArabic,
                                    body:
                                        "${employee!.email.last!.split('@')[0]} Accepted your invitation to ${widget.event.eventNameEnglish}",
                                    arabicBody:
                                        "${employee!.email.last!.split('@')[0]} قبل دعوتك ل ${widget.event.eventNameArabic}",
                                    type: "note",
                                    topic: widget.event.eventCreator);

                                hideLoadingIndicator();
                              });
                            }
                          } else {
                            eventController
                                .updateApprovalStatus(widget.event.id, "sent")
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
                        }
                        eventController.filterEvents(
                            eventController.eventHomeSelectedIndexFilter);

                        eventController.update();
                        employeeController.update();
                      });
                    })
                : Row(
                    children: [
                      Expanded(
                        child: CustomIconButton(
                          textColor: MyThemeData.delete,
                          buttonColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          buttonText: 'Reject',
                          imagePath: 'assets/icons/RejectionIcon.svg',
                          imageColor: MyThemeData.delete,
                          radius: 8,
                          borderColor: MyThemeData.delete,
                          onPressed: () {
                            setState(() {
                              widget.event.status = "Rejected".tr;
                              widget.statusGiven = true;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return RejectionResonDialog(
                                    employeeController: employeeController,
                                    event: widget.event,
                                    eventController: eventController,
                                    isEmployee: widget.isEmployee,
                                  );
                                });
                          },
                        ),
                      ),
                      SizedBox(width: 0.02.w),
                      Expanded(
                        child: CustomIconButton(
                          buttonColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          textColor: MyThemeData.unBlock,
                          borderColor: MyThemeData.unBlock,
                          imageColor: MyThemeData.unBlock,
                          buttonText: 'Approve',
                          radius: 8,
                          imagePath: 'assets/icons/ApproveIcon.svg',
                          onPressed: () {
                            setState(() {
                              showLoadingIndicator();
                              widget.event.status = "Accepted".tr;
                              widget.statusGiven = true;

                              if (widget.isEmployee) {
                                if (employeeController.employeeSelectedIndex ==
                                    2) {
                                  log("employee index: ${employeeController.employeeSelectedIndex}");
                                  employeeController
                                      .updateApprovalStatus(
                                          widget.event.id, "sent")
                                      .then((_) async {
                                    //employee fetch
                                    await employeeController.fetchEmployees();
                                    await employeeController
                                        .fetchEventsFromFirebase();
                                    employeeController.fetchApprovals();
                                    //event fetch
                                    await eventController.fetchEmployees();
                                    await eventController
                                        .fetchEventsFromFirebase();
                                    eventController.fetchApprovals();
                                    hideLoadingIndicator();
                                  });
                                } else {
                                  log("employee index: ${employeeController.employeeSelectedIndex}");
                                  employeeController
                                      .updateInvitationStatus(
                                          widget.event.id, "Accepted")
                                      .then((_) async {
                                    await notificationController
                                        .subscribeToTopic(widget.event.id);
                                    //employee fetch
                                    await employeeController.fetchEmployees();
                                    await employeeController
                                        .fetchEventsFromFirebase();
                                    employeeController.fetchApprovals();
                                    //event fetch
                                    await eventController.fetchEmployees();
                                    await eventController
                                        .fetchEventsFromFirebase();
                                    eventController.fetchApprovals();
                                    await notificationController.sendNotification(
                                        title: widget.event.eventNameEnglish,
                                        arabicTitle:
                                            widget.event.eventNameArabic,
                                        body:
                                            "${employee!.email.last!.split('@')[0]} Accepted your invitation to ${widget.event.eventNameEnglish}",
                                        arabicBody:
                                            "${employee!.email.last!.split('@')[0]} قبل دعوتك ل ${widget.event.eventNameArabic}",
                                        type: "note",
                                        topic: widget.event.eventCreator);
                                    hideLoadingIndicator();
                                  });
                                }
                              } else {
                                log("MEDIAAAAA");
                                eventController
                                    .updateApprovalStatus(
                                        widget.event.id, "sent")
                                    .then((_) async {
                                  //employee fetch
                                  await employeeController.fetchEmployees();
                                  await employeeController
                                      .fetchEventsFromFirebase();
                                  employeeController.fetchApprovals();
                                  //event fetch
                                  await eventController.fetchEmployees();
                                  await eventController
                                      .fetchEventsFromFirebase();
                                  eventController.fetchApprovals();
                                  hideLoadingIndicator();
                                });
                              }
                            });
                            eventController.filterEvents(
                                eventController.eventHomeSelectedIndexFilter);

                            eventController.update();
                            employeeController.update();
                          },
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
