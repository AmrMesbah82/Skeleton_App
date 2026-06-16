import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/home/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/widgets/title_row.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';

import 'package:demo_app/core/constants/image_paths.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/events/components/row_icon_text.dart';
import 'package:demo_app/features/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/features/events/tablet/employees/views/employee_home_screen.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/guests_container.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/components/page_screenstop_level.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/edit_event_view.dart';
import 'package:demo_app/features/events/tablet/media_departments_view/views/events_home_screen.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:page_transition/page_transition.dart';

class EditEvent extends StatelessWidget {
  const EditEvent({
    super.key,
    this.event,
    this.isApproval = false,
  });
  final EventModel? event;
  final bool? isApproval;

  String getOrdinal(int number) {
    if (number % 10 == 1 && number % 100 != 11) {
      return '${number}st';
    } else if (number % 10 == 2 && number % 100 != 12) {
      return '${number}nd';
    } else if (number % 10 == 3 && number % 100 != 13) {
      return '${number}rd';
    } else {
      return '${number}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return PageScreenTopLevel(children: [
      titleRow(
          context,
          orientation,
          Get.locale.toString().contains('en')
              ? event!.eventNameEnglish
              : event!.eventNameArabic, () {
        (!Mode.hr && !Mode.owner)
            ? Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child:                       EmployeeEventsHomeScreen(),

                ),
              )
            : Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child:  EventsHomeScreen(),
                ),
              );
      }),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0.02.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Event Details".tr,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: orientation
                    ? FontConstants.fontSize021.h
                    : FontConstants.fontSize021.w,
                fontWeight: FontWeight.w600,
                 letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                height: 1.4,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
            isApproval == true || (!Mode.hr && !Mode.owner)
                ? const SizedBox.shrink()
                : CustomIconButton(
                    buttonText: "Edit",
                    imagePath: "assets/images/pen_edits.svg",
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child:          EditEventTablet(
                            event: event!,
                          ),
                        ),
                      );
                    })
          ],
        ),
      ),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.inversePrimary),
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: 0.015.h, horizontal: 0.015.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 0.32.w,
                        child: RowIconTextEvent(
                            iconUrl: "assets/images/event_small.svg",
                            text: "Event Name",
                            value: Get.locale.toString().contains('en')
                                ? event!.eventNameEnglish
                                : event!.eventNameArabic),
                      ),
                      RowIconTextEvent(
                          iconUrl: "assets/images/job_case.svg",
                          text: "Department Owner",
                          value: Get.locale.toString().contains('en')
                              ? "${event!.departmentOwner!.tr} ${'Department'.tr}"
                              : " ${'Department'.tr} ${event!.departmentOwner!.tr}"),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.015.h),
                    child: RowIconTextEvent(
                        iconUrl: "assets/images/email_ser.svg",
                        text: "Summary",
                        value: Get.locale.toString().contains('en')
                            ? event!.summary
                            : event!.summaryArabic),
                  ),
                  RowIconTextEvent(
                      iconUrl: "assets/images/email_ser.svg",
                      text: "Agenda",
                      value: Get.locale.toString().contains('en')
                          ? event!.agenda
                          : " ${event!.agendaArabic}"),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.015.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 0.18.w,
                          child: RowIconTextEvent(
                              iconUrl: "assets/icons/newCalenderFixed.svg",
                              text: "Date",
                              isFlexible: true,
                              value: Get.locale.toString().contains('en')
                                  ? event!.date
                                  : translateDateFormatToArabic(event!.date)),
                        ),
                        SizedBox(
                          width: 0.18.w,
                          child: RowIconTextEvent(
                              iconUrl: "assets/images/time_icon.svg",
                              text: "Time",
                              isFlexible: true,
                              value: Get.locale.toString().contains('en')
                                  ? event!.time
                                  : convertTimeToArabic(event!.time)),
                        ),
                        SizedBox(
                          width: 0.2.w,
                          child: RowIconTextEvent(
                              iconUrl: "assets/images/event_small.svg",
                              text: "Type",
                              isFlexible: true,
                              value: event!.type!),
                        ),
                        SizedBox(
                          width: 0.2.w,
                          child: RowIconTextEvent(
                              iconUrl: "assets/images/attachsquare_field.svg",
                              text: "Flyer",
                              isFlexible: true,
                              valueColor: AppColors.blue,
                              value: event!.flyer),
                        ),
                      ],
                    ),
                  ),
                  RowIconTextEvent(
                      iconUrl: "assets/images/max_capacity.svg",
                      text: "Maximum Capacity".tr,
                      value: Get.locale.toString().contains('en')
                          ? event!.maximumCapacity
                          : convertNumberToArabic(event!.maximumCapacity)),
                  SizedBox(
                    height: 0.015.h,
                  ),
                  Row(
                    children: [
                      RowIconTextEvent(
                          iconUrl: "assets/images/map_new.svg",
                          text: "Event Venue",
                          value: event!.isRemote == true
                              ? "Remote".tr
                              : "On Site".tr),
                      SizedBox(
                        width: 0.015.w,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.dividerColor),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.01.h,
                                horizontal: orientation ? 0.01.h : .015.h),
                            child: SizedBox(
                              width: orientation ? 0.3.w : 0.25.w,
                              child: Text(
                                event!.isRemote
                                    ? event!.remoteUrl
                                    : Get.locale.toString().contains('en')
                                        ? event!.onSiteAddress
                                        : convertNumberToArabic(
                                            event!.onSiteAddress),
                                style: AppFontStyle.cairoRegularStyle.copyWith(
                                    fontSize: orientation
                                        ? FontConstants.fontSize012.h
                                        : FontConstants.fontSize012.w,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                    color: AppColors.blue),
                              ),
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 0.005.h,
                  ),
                  RowIconTextEvent(
                      iconUrl: "assets/images/contact_icon.svg",
                      text: "Invited Guests",
                      isDescribtion: true,
                      hasAnotherWidget: true,
                      anotherWidget: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              (event!.guests.length / 4).ceil(), (index) {
                            int firstIndex = index * 4;
                            int secondIndex = firstIndex + 1;
                            int thirdIndex = firstIndex + 2;
                            int fourthIndex = firstIndex + 3;
                            return Padding(
                              padding: EdgeInsets.only(right: 0.015.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  firstIndex < event!.guests.length
                                      ? event!.guests[firstIndex]
                                                  .invitedEvents[event!.id] !=
                                              "Deleted"
                                          ? GuestsContainer(
                                              department: event!
                                                  .guests[firstIndex]
                                                  .department,
                                              departmentInArabic: event!
                                                  .guests[firstIndex]
                                                  .arabicDepartment,
                                              nameInArabic: event!
                                                  .guests[firstIndex]
                                                  .arabicName,
                                              jobTitle: event!
                                                  .guests[firstIndex].role,
                                              name: event!
                                                  .guests[firstIndex].name,
                                              profilePhoto: event!
                                                  .guests[firstIndex].imageUrl,
                                              status: event!.guests[firstIndex]
                                                  .invitedEvents[event!.id],
                                              withStatus: true,
                                            )
                                          : const SizedBox.shrink()
                                      : const SizedBox.shrink(),
                                  secondIndex < event!.guests.length
                                      ? event!.guests[secondIndex]
                                                  .invitedEvents[event!.id] !=
                                              "Deleted"
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0.015.h),
                                              child: GuestsContainer(
                                                department: event!
                                                    .guests[secondIndex]
                                                    .department,
                                                jobTitle: event!
                                                    .guests[secondIndex].role,
                                                departmentInArabic: event!
                                                    .guests[secondIndex]
                                                    .arabicDepartment,
                                                nameInArabic: event!
                                                    .guests[secondIndex]
                                                    .arabicName,
                                                name: event!
                                                    .guests[secondIndex].name,
                                                profilePhoto: event!
                                                    .guests[secondIndex]
                                                    .imageUrl,
                                                status: event!
                                                    .guests[secondIndex]
                                                    .invitedEvents[event!.id],
                                                withStatus: true,
                                              ),
                                            )
                                          : const SizedBox.shrink()
                                      : const SizedBox.shrink(),
                                  thirdIndex < event!.guests.length
                                      ? event!.guests[thirdIndex]
                                                  .invitedEvents[event!.id] !=
                                              "Deleted"
                                          ? GuestsContainer(
                                              department: event!
                                                  .guests[thirdIndex]
                                                  .department,
                                              jobTitle: event!
                                                  .guests[thirdIndex].role,
                                              departmentInArabic: event!
                                                  .guests[thirdIndex]
                                                  .arabicDepartment,
                                              nameInArabic: event!
                                                  .guests[thirdIndex]
                                                  .arabicName,
                                              name: event!
                                                  .guests[thirdIndex].name,
                                              profilePhoto: event!
                                                  .guests[thirdIndex].imageUrl,
                                              status: event!.guests[thirdIndex]
                                                  .invitedEvents[event!.id],
                                              withStatus: true,
                                            )
                                          : const SizedBox.shrink()
                                      : const SizedBox.shrink(),
                                  fourthIndex < event!.guests.length
                                      ? SizedBox(
                                          height: 0.015.h,
                                        )
                                      : const SizedBox.shrink(),
                                  fourthIndex < event!.guests.length
                                      ? event!.guests[fourthIndex]
                                                  .invitedEvents[event!.id] !=
                                              "Deleted"
                                          ? GuestsContainer(
                                              department: event!
                                                  .guests[fourthIndex]
                                                  .department,
                                              jobTitle: event!
                                                  .guests[fourthIndex].role,
                                              departmentInArabic: event!
                                                  .guests[fourthIndex]
                                                  .arabicDepartment,
                                              nameInArabic: event!
                                                  .guests[fourthIndex]
                                                  .arabicName,
                                              name: event!
                                                  .guests[fourthIndex].name,
                                              profilePhoto: event!
                                                  .guests[fourthIndex].imageUrl,
                                              withStatus: true,
                                              status: event!.guests[fourthIndex]
                                                  .invitedEvents[event!.id],
                                            )
                                          : const SizedBox.shrink()
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      value: "Lorem.pdf"),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.015.h),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: event!.reminders.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        int firstIndex = index * 2;
                        int secondIndex = firstIndex + 1;
                        return Row(
                          children: [
                            firstIndex < event!.reminders.length
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${getOrdinal(firstIndex + 1)} Notification"
                                            .tr,
                                        style: AppFontStyle.cairoRegularStyle
                                            .copyWith(
                                                fontSize: orientation
                                                    ? FontConstants
                                                        .fontSize016.h
                                                    : FontConstants
                                                        .fontSize022.h,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inverseSurface,
                                                height: 1.6),
                                      ),
                                      SizedBox(
                                        height: 0.01.h,
                                      ),
                                      Row(
                                        children: [
                                          RowIconTextEvent(
                                              iconUrl:
                                                  "assets/icons/newCalenderFixed.svg",
                                              text: "Date",
                                              value: Get.locale
                                                      .toString()
                                                      .contains("en")
                                                  ? event!.reminders[firstIndex]
                                                      .date
                                                  : translateDateFormatToArabic(
                                                      event!
                                                          .reminders[firstIndex]
                                                          .date)),
                                          SizedBox(
                                            width:
                                                orientation ? 0.08.w : 0.08.w,
                                          ),
                                          RowIconTextEvent(
                                              iconUrl:
                                                  "assets/images/time_icon.svg",
                                              text: "Time",
                                              value: Get.locale
                                                      .toString()
                                                      .contains("en")
                                                  ? event!.reminders[firstIndex]
                                                      .time
                                                  : convertTimeToArabic(event!
                                                      .reminders[firstIndex]
                                                      .time)),
                                        ],
                                      )
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            secondIndex < event!.reminders.length
                                ? SizedBox(
                                    width: orientation ? 0.045.w : 0.15.w,
                                  )
                                : const SizedBox.shrink(),
                            secondIndex < event!.reminders.length
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${getOrdinal(secondIndex + 1)} Notification"
                                            .tr,
                                        style: AppFontStyle.cairoRegularStyle
                                            .copyWith(
                                                fontSize: orientation
                                                    ? FontConstants
                                                        .fontSize016.h
                                                    : FontConstants
                                                        .fontSize022.h,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inverseSurface,
                                                height: 1.6),
                                      ),
                                      SizedBox(
                                        height: 0.01.h,
                                      ),
                                      Row(
                                        children: [
                                          RowIconTextEvent(
                                              iconUrl:
                                                  "assets/icons/newCalenderFixed.svg",
                                              text: "Date",
                                              value: Get.locale
                                                      .toString()
                                                      .contains("en")
                                                  ? event!
                                                      .reminders[secondIndex]
                                                      .date
                                                  : translateDateFormatToArabic(
                                                      event!
                                                          .reminders[
                                                              secondIndex]
                                                          .date)),
                                          SizedBox(
                                            width:
                                                orientation ? 0.04.w : 0.08.w,
                                          ),
                                          RowIconTextEvent(
                                              iconUrl:
                                                  "assets/images/time_icon.svg",
                                              text: "Time",
                                              value: Get.locale
                                                      .toString()
                                                      .contains("en")
                                                  ? event!
                                                      .reminders[secondIndex]
                                                      .time
                                                  : convertTimeToArabic(event!
                                                      .reminders[secondIndex]
                                                      .time)),
                                        ],
                                      )
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ],
                        );
                      },
                    ),
                  ),
                  RowIconTextEvent(
                    iconUrl: "assets/images/approval_ser.svg",
                    text: "Approval",
                    value: event!.requiredApproval
                        ? "Needs Approval From".tr
                        : "No Approval Required".tr,
                    valueColor: AppColors.unBlock,
                  ),
                  SizedBox(
                    height: 0.015.h,
                  ),
                  if (event!.requiredApproval)
                    GuestsContainer(
                      department: event!.approvalEmail!.department,
                      jobTitle: event!.approvalEmail!.role,
                      departmentInArabic:
                          event!.approvalEmail!.arabicDepartment,
                      nameInArabic: event!.approvalEmail!.arabicName,
                      name: event!.approvalEmail!.name,
                      profilePhoto: event!.approvalEmail!.imageUrl,
                      status: event!.approvalEmail!.approvalEvents[event!.id] ==
                              "Canceled"
                          ? "Rejected"
                          : event!.approvalEmail!.approvalEvents[event!.id]!,
                      withStatus: true,
                    ),
                  (isApproval == true || (!Mode.hr && !Mode.owner))
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: event!.status != null
                              ? [
                                  Text(event!.status!.tr,
                                      style: AppFontStyle.cairoRegularStyle
                                          .copyWith(
                                              fontSize:
                                                  FontConstants.fontSize016.w,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  event!.status! == "Accepted"
                                                      ? AppColors.unBlock
                                                      : AppColors.colorRed))
                                ]
                              : [
                                  Row(
                                    children: [
                                      CustomIconButton(
                                        textColor: AppColors.delete,
                                        buttonColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        buttonText: 'Reject',
                                        imagePath:
                                            'assets/icons/RejectionIcon.svg',
                                        imageColor: AppColors.delete,
                                        radius: 8,
                                        borderColor: AppColors.delete,
                                        onPressed: () {},
                                      ),
                                      SizedBox(width: 0.02.w),
                                      CustomIconButton(
                                        buttonColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        textColor: AppColors.unBlock,
                                        borderColor: AppColors.unBlock,
                                        imageColor: AppColors.unBlock,
                                        buttonText: 'Approve',
                                        radius: 8,
                                        imagePath:
                                            'assets/icons/ApproveIcon.svg',
                                        onPressed: () {},
                                      ),
                                    ],
                                  )
                                ],
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
