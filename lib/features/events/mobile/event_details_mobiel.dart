import 'package:demo_app/core/nav_bar_package.dart/model.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/helper/date_time_in_arabic.dart';


import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/components/row_icon_text.dart';
import 'package:demo_app/features/events/controllers/events_controllers/event_controller.dart';
import 'package:demo_app/features/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/features/events/mobile/edit_event_mobile.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/guests_container.dart';
import 'package:demo_app/core/nav_bar_package.dart/functions.dart';


class EventDetailsMobile extends StatefulWidget {
  const EventDetailsMobile({
    super.key,
    required this.isApprovals,
    required this.event,
  });
  final bool isApprovals;
  final EventModel event;
  @override
  State<EventDetailsMobile> createState() => _EventDetailsMobileState();
}

class _EventDetailsMobileState extends State<EventDetailsMobile> {
  EventController eventController = Get.put(EventController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBarMobile(
                showIcon: true,
                title: "Events",
                isHome: false,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.04.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.01.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Event Details".tr,
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: FontConstants.fontSize021.h,
                              fontWeight: FontWeight.w600,
                               letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                              height: 1.4,
                              color: Theme.of(context).colorScheme.inverseSurface,
                            ),
                          ),
                          CustomIconButton(
                              buttonText: "Edit",
                              smallHeight: true,
                              imagePath: "assets/images/pen_edits.svg",
                              onPressed: () {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.fade,
                                  screen: EditEventMobile(
                                    event: widget.event,
                                  ),
                                  withNavBar: false,
                                );
                              })
                        ],
                      ),
                    ),
                    SizedBox(
                  //    height: 0.75.h,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.inversePrimary),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.015.h, horizontal: 0.02.w),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    RowIconTextEvent(
                                        iconUrl: "assets/images/event_small.svg",
                                        text: "Event Name",
                                         isFlexible: true,
                                        value:
                                            Get.locale.toString().contains('en')
                                                ? widget.event.eventNameEnglish
                                                : widget.event.eventNameArabic),
                                    SizedBox(
                                      height: 0.015.h,
                                    ),
                                    RowIconTextEvent(
                                        iconUrl: "assets/images/job_case.svg",
                                        text: "Department Owner",
                                         isFlexible: true,
                                        value: Get.locale
                                                .toString()
                                                .contains('en')
                                            ? widget.event.departmentOwner ?? ""
                                            : eventController
                                                    .departmentArabicList[
                                                eventController.departmentList
                                                    .indexOf(widget.event
                                                            .departmentOwner ??
                                                        "")]),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 0.015.h),
                                  child: RowIconTextEvent(
                                      iconUrl: "assets/images/email_ser.svg",
                                      text: "Summary",
                                    isFlexible: true,
                                      value: Get.locale.toString().contains('en')
                                          ? widget.event.summary
                                          : widget.event.summaryArabic),
                                ),
                                RowIconTextEvent(
                                    iconUrl: "assets/images/email_ser.svg",
                                    text: "Agenda",
                                   isFlexible: true,
                                    value: Get.locale.toString().contains('en')
                                        ? widget.event.agenda
                                        : widget.event.agendaArabic),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 0.015.h),
                                  child: Column(
                                    children: [
                                      RowIconTextEvent(
                                          iconUrl: "assets/icons/newCalenderFixed.svg",
                                          text: "Date",
                                          value:
                                              Get.locale.toString().contains('en')
                                                  ? widget.event.date
                                                  : translateDateFormatToArabic(
                                                      widget.event.date)),
                                      SizedBox(
                                        height: 0.015.h,
                                      ),
                                      RowIconTextEvent(
                                          iconUrl: "assets/images/time_icon.svg",
                                          text: "Time",
                                          value:
                                              Get.locale.toString().contains('en')
                                                  ? widget.event.time
                                                  : convertTimeToArabic(
                                                      widget.event.time)),
                                      SizedBox(
                                        height: 0.015.h,
                                      ),
                                      RowIconTextEvent(
                                          iconUrl:
                                              "assets/images/event_small.svg",
                                          text: "Type",
                                          value: widget.event.type!),
                                      SizedBox(
                                        height: 0.015.h,
                                      ),
                                      SizedBox(
                                        width: 0.89.w,
                                        child: RowIconTextEvent(
                                            iconUrl:
                                                "assets/images/attachsquare_field.svg",
                                            text: "Flyer",
                                            isFlexible: true,
                                            valueColor: AppColors.blue,
                                            value: widget.event.flyer),
                                      ),
                                    ],
                                  ),
                                ),
                                RowIconTextEvent(
                                    iconUrl: "assets/images/max_capacity.svg",
                                    text: "Maximum Capacity",
                                    value: Get.locale.toString().contains('en')
                                        ? widget.event.maximumCapacity
                                        : convertNumberToArabic(
                                            widget.event.maximumCapacity)),
                                             SizedBox(
                                        height: 0.015.h,
                                      ),
                                Row(
                                  children: [
                                    RowIconTextEvent(
                                        iconUrl: "assets/images/map_new.svg",
                                        text: "Event Venue",
                                        value: widget.event.isRemote == true
                                            ? "Remote"
                                            : "On Site"),
                                    SizedBox(
                                      width: 0.015.w,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              color: AppColors.colorLightGrey,
                                              width: 1.4),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.01.h,
                                              horizontal: .01.h),
                                          child: SizedBox(
                                            width: 0.35.w,
                                            child: Text(
                                              widget.event.isRemote
                                                  ? widget.event.remoteUrl
                                                  : (Get.locale
                                                          .toString()
                                                          .contains('en')
                                                      ? widget.event.onSiteAddress
                                                      : convertNumberToArabic(
                                                          widget.event
                                                              .onSiteAddress)),
                                              style: AppFontStyle
                                                  .cairoRegularStyle
                                                  .copyWith(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: FontConstants
                                                          .fontSize014.h,
                                                      fontWeight: FontWeight.w500,
                                                      height: 1.3,
                                                      color: AppColors.blue),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 0.015.h,
                                ),
                                RowIconTextEvent(
                                    iconUrl: "assets/images/contact_icon.svg",
                                    text: "Invited Guests",
                                    isDescribtion: true,
                                    hasAnotherWidget: true,
                                    anotherWidget: Padding(
                                      padding:   EdgeInsets.only(top: 0.01.h),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(
                                              (widget.event.guests.length / 4)
                                                  .ceil(), (index) {
                                            int firstIndex = index * 4;
                                            int secondIndex = firstIndex + 1;
                                            int thirdIndex = firstIndex + 2;
                                            int fourthIndex = firstIndex + 3;
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(right: 0.015.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  firstIndex <
                                                          widget.event.guests.length
                                                      ? widget
                                                                      .event
                                                                      .guests[
                                                                          firstIndex]
                                                                      .invitedEvents[
                                                                  widget
                                                                      .event.id] !=
                                                              "Deleted"
                                                          ? GuestsContainer(
                                                              department: widget
                                                                  .event
                                                                  .guests[
                                                                      firstIndex]
                                                                  .role,
                                                              departmentInArabic: widget
                                                                  .event
                                                                  .guests[
                                                                      firstIndex]
                                                                  .arabicDepartment,
                                                              nameInArabic: widget
                                                                  .event
                                                                  .guests[
                                                                      firstIndex]
                                                                  .arabicName,
                                                              jobTitle: widget
                                                                  .event
                                                                  .guests[
                                                                      firstIndex]
                                                                  .department,
                                                              name: widget
                                                                  .event
                                                                  .guests[
                                                                      firstIndex]
                                                                  .name,
                                                              profilePhoto: widget
                                                                  .event
                                                                  .guests[
                                                                      firstIndex]
                                                                  .imageUrl,
                                                              status: widget
                                                                      .event
                                                                      .guests[
                                                                          firstIndex]
                                                                      .invitedEvents[
                                                                  widget.event.id],
                                                              withStatus: true,
                                                            )
                                                          : const SizedBox.shrink()
                                                      : const SizedBox.shrink(),
                                                  secondIndex <
                                                          widget.event.guests.length
                                                      ? widget
                                                                      .event
                                                                      .guests[
                                                                          firstIndex]
                                                                      .invitedEvents[
                                                                  widget
                                                                      .event.id] !=
                                                              "Deleted"
                                                          ? Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0.015.h),
                                                              child:
                                                                  GuestsContainer(
                                                                department: widget
                                                                    .event
                                                                    .guests[
                                                                        secondIndex]
                                                                    .role,
                                                                departmentInArabic: widget
                                                                    .event
                                                                    .guests[
                                                                        secondIndex]
                                                                    .arabicDepartment,
                                                                nameInArabic: widget
                                                                    .event
                                                                    .guests[
                                                                        secondIndex]
                                                                    .arabicName,
                                                                jobTitle: widget
                                                                    .event
                                                                    .guests[
                                                                        secondIndex]
                                                                    .department,
                                                                name: widget
                                                                    .event
                                                                    .guests[
                                                                        secondIndex]
                                                                    .name,
                                                                profilePhoto: widget
                                                                    .event
                                                                    .guests[
                                                                        secondIndex]
                                                                    .imageUrl,
                                                                status: widget
                                                                        .event
                                                                        .guests[
                                                                            secondIndex]
                                                                        .invitedEvents[
                                                                    widget
                                                                        .event.id],
                                                                withStatus: true,
                                                              ),
                                                            )
                                                          : const SizedBox.shrink()
                                                      : const SizedBox.shrink(),
                                                  thirdIndex <
                                                          widget.event.guests.length
                                                      ? widget
                                                                      .event
                                                                      .guests[
                                                                          firstIndex]
                                                                      .invitedEvents[
                                                                  widget
                                                                      .event.id] !=
                                                              "Deleted"
                                                          ? GuestsContainer(
                                                              department: widget
                                                                  .event
                                                                  .guests[
                                                                      thirdIndex]
                                                                  .role,
                                                              jobTitle: widget
                                                                  .event
                                                                  .guests[
                                                                      thirdIndex]
                                                                  .department,
                                                              departmentInArabic: widget
                                                                  .event
                                                                  .guests[
                                                                      thirdIndex]
                                                                  .arabicDepartment,
                                                              nameInArabic: widget
                                                                  .event
                                                                  .guests[
                                                                      thirdIndex]
                                                                  .arabicName,
                                                              name: widget
                                                                  .event
                                                                  .guests[
                                                                      thirdIndex]
                                                                  .name,
                                                              profilePhoto: widget
                                                                  .event
                                                                  .guests[
                                                                      thirdIndex]
                                                                  .imageUrl,
                                                              status: widget
                                                                      .event
                                                                      .guests[
                                                                          thirdIndex]
                                                                      .invitedEvents[
                                                                  widget.event.id],
                                                              withStatus: true,
                                                            )
                                                          : const SizedBox.shrink()
                                                      : const SizedBox.shrink(),
                                                  fourthIndex <
                                                          widget.event.guests.length
                                                      ? SizedBox(
                                                          height: 0.015.h,
                                                        )
                                                      : const SizedBox.shrink(),
                                                  fourthIndex <
                                                          widget.event.guests.length
                                                      ? widget
                                                                      .event
                                                                      .guests[
                                                                          firstIndex]
                                                                      .invitedEvents[
                                                                  widget
                                                                      .event.id] !=
                                                              "Deleted"
                                                          ? GuestsContainer(
                                                              department: widget
                                                                  .event
                                                                  .guests[
                                                                      fourthIndex]
                                                                  .role,
                                                              jobTitle: widget
                                                                  .event
                                                                  .guests[
                                                                      fourthIndex]
                                                                  .department,
                                                              name: widget
                                                                  .event
                                                                  .guests[
                                                                      fourthIndex]
                                                                  .name,
                                                              departmentInArabic: widget
                                                                  .event
                                                                  .guests[
                                                                      fourthIndex]
                                                                  .arabicDepartment,
                                                              nameInArabic: widget
                                                                  .event
                                                                  .guests[
                                                                      fourthIndex]
                                                                  .arabicName,
                                                              profilePhoto: widget
                                                                  .event
                                                                  .guests[
                                                                      fourthIndex]
                                                                  .imageUrl,
                                                              status: widget
                                                                      .event
                                                                      .guests[
                                                                          fourthIndex]
                                                                      .invitedEvents[
                                                                  widget.event.id],
                                                              withStatus: true,
                                                            )
                                                          : const SizedBox.shrink()
                                                      : const SizedBox.shrink(),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                    value: "Lorem.pdf"),
                                if (widget.event.reminders.isNotEmpty) ...[
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 0.015.h),
                                    child: Column(
                                      children: [
                                        if (widget.event.reminders[0].date !=
                                            "") ...[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "First Notification".tr,
                                                style: AppFontStyle
                                                    .cairoRegularStyle
                                                    .copyWith(
                                                        fontSize: FontConstants
                                                            .fontSize019.h,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .inverseSurface,
                                                        height: 1.6),
                                              ),
                                              SizedBox(
                                                height: 0.015.h,
                                              ),
                                              Column(
                                                children: [
                                                  RowIconTextEvent(
                                                      iconUrl:
                                                          "assets/icons/newCalenderFixed.svg",
                                                      text: "Date",
                                                      value: Get.locale
                                                              .toString()
                                                              .contains("en")
                                                          ? widget.event
                                                              .reminders[0].date
                                                          : translateDateFormatToArabic(
                                                              widget
                                                                  .event
                                                                  .reminders[0]
                                                                  .date)),
                                                  SizedBox(
                                                    height: 0.015.h,
                                                  ),
                                                  RowIconTextEvent(
                                                      iconUrl:
                                                          "assets/images/time_icon.svg",
                                                      text: "Time",
                                                      value: Get.locale
                                                              .toString()
                                                              .contains("en")
                                                          ? widget.event
                                                              .reminders[0].time
                                                          : convertTimeToArabic(
                                                              widget
                                                                  .event
                                                                  .reminders[0]
                                                                  .time)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                        SizedBox(
                                          height: 0.015.h,
                                        ),
                                        if (widget.event.reminders.length > 1 &&
                                            widget.event.reminders[1].date !=
                                                "") ...[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Second Notification".tr,
                                                style: AppFontStyle
                                                    .cairoRegularStyle
                                                    .copyWith(
                                                        fontSize: FontConstants
                                                            .fontSize019.h,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .inverseSurface,
                                                        height: 1.6),
                                              ),
                                              SizedBox(
                                                height: 0.01.h,
                                              ),
                                              Column(
                                                children: [
                                                  RowIconTextEvent(
                                                      iconUrl:
                                                          "assets/icons/newCalenderFixed.svg",
                                                      text: "Date",
                                                      value: Get.locale
                                                              .toString()
                                                              .contains("en")
                                                          ? widget.event
                                                              .reminders[1].date
                                                          : translateDateFormatToArabic(
                                                              widget
                                                                  .event
                                                                  .reminders[1]
                                                                  .date)),
                                                  SizedBox(
                                                    height: 0.015.h,
                                                  ),
                                                  RowIconTextEvent(
                                                      iconUrl:
                                                          "assets/images/time_icon.svg",
                                                      text: "Time",
                                                      value: Get.locale
                                                              .toString()
                                                              .contains("en")
                                                          ? widget.event
                                                              .reminders[1].time
                                                          : convertTimeToArabic(
                                                              widget
                                                                  .event
                                                                  .reminders[1]
                                                                  .time)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                                RowIconTextEvent(
                                  iconUrl: "assets/images/approval_ser.svg",
                                  text: "Approval",
                                  value: widget.event.requiredApproval
                                      ? "Needs Approval From"
                                      : "No Approval Required",
                                  valueColor: AppColors.unBlock,
                                ),
                                SizedBox(
                                  height: 0.015.h,
                                ),
                                if (widget.event.requiredApproval)
                                  GuestsContainer(
                                    department:
                                        widget.event.approvalEmail!.department,
                                    departmentInArabic: widget
                                        .event.approvalEmail!.arabicDepartment,
                                    nameInArabic:
                                        widget.event.approvalEmail!.arabicName,
                                    jobTitle: widget.event.approvalEmail!.role,
                                    name: widget.event.approvalEmail!.name,
                                    profilePhoto:
                                        widget.event.approvalEmail!.imageUrl,
                                    status: widget.event.approvalEmail!
                                                    .approvalEvents[
                                                widget.event.id] ==
                                            "Canceled"
                                        ? "Rejected"
                                        : widget.event.approvalEmail!
                                                        .approvalEvents[
                                                    widget.event.id] ==
                                                "Sent"
                                            ? "Accepted"
                                            : widget.event.approvalEmail!
                                                .approvalEvents[widget.event.id],
                                    withStatus: true,
                                  ),
                                widget.isApprovals
                                    ? SizedBox(height: 0.015.h)
                                    : const SizedBox.shrink(),
                                widget.isApprovals
                                    ? Row(
                                        children: widget.event.status != null
                                            ? [
                                                Text(widget.event.status!,
                                                    style: AppFontStyle
                                                        .cairoRegularStyle
                                                        .copyWith(
                                                            fontSize:
                                                                FontConstants
                                                                    .fontSize016
                                                                    .h,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: widget
                                                                        .event
                                                                        .status!
                                                                        .tr ==
                                                                    "Accepted".tr
                                                                ? AppColors
                                                                    .unBlock
                                                                : AppColors
                                                                    .colorRed))
                                              ]
                                            : [
                                                Expanded(
                                                  child: CustomIconButton(
                                                    textColor: AppColors.delete,
                                                    buttonColor: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary,
                                                    buttonText: 'Reject',
                                                    imagePath:
                                                        'assets/icons/RejectionIcon.svg',
                                                    imageColor:
                                                        AppColors.delete,
                                                    radius: 8,
                                                    borderColor:
                                                        AppColors.delete,
                                                    onPressed: () {},
                                                  ),
                                                ),
                                                SizedBox(width: 0.02.w),
                                                Expanded(
                                                  child: CustomIconButton(
                                                    buttonColor: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary,
                                                    textColor:
                                                        AppColors.unBlock,
                                                    borderColor:
                                                        AppColors.unBlock,
                                                    imageColor:
                                                        AppColors.unBlock,
                                                    buttonText: 'Approve',
                                                    radius: 8,
                                                    imagePath:
                                                        'assets/icons/ApproveIcon.svg',
                                                    onPressed: () {},
                                                  ),
                                                ),
                                              ],
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
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
