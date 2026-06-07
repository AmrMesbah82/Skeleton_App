import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/events/components/row_icon_text.dart';
import 'package:demo_app/features/skeleton/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/components/survey_pop_menu.dart';

class EventContainer extends StatefulWidget {
  EventContainer(
      {super.key,
      this.statusGiven = false,
      this.status,
      this.isHistory = false,
      this.survey,
      required this.event});

  final bool statusGiven;
  String? status;

  final bool isHistory;
  final EventModel event;
  final SurveyModel? survey;

  @override
  State<EventContainer> createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer> {
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
                                  ? 0.22.w
                                  : 0.26.w
                              : 0.53.w,
                          child: RowIconTextEvent(
                              iconUrl: "",
                              text: "Name",
                              isFlexible: true,
                              hideImage: true,
                              value: Get.locale.toString().contains('en')
                                  ? widget.event.eventNameEnglish
                                  : widget.event.eventNameArabic),
                        ),
                        widget.isHistory
                            ? Text(
                                widget.event.status!.tr,
                                style: AppFontStyle.cairoRegularStyle.copyWith(
                                    height: 2,
                                    fontSize: orientation
                                        ? FontConstants.fontSize013.h
                                        : FontConstants.fontSize013.w,
                                    color: widget.event.status == 'Accepted'
                                        ? MyThemeData.unBlock
                                        : MyThemeData.colorRed,
                                    fontWeight: FontWeight.w600),
                              )
                            : InkWell(
                                onTapUp: (details) async {
                                  final iconPosition = details.globalPosition;
                                  SurveyPopMenu sortMenu = SurveyPopMenu();
                                  if (widget.event.hasSurvey) {
                                    await sortMenu.showSortMenu(
                                      context,
                                      iconPosition,
                                      "Show Survey",
                                      widget.survey,
                                      widget.event.id,
                                    );
                                  } else {
                                    await sortMenu.showSortMenu(
                                      context,
                                      iconPosition,
                                      "Create Survey",
                                      widget.survey,
                                      widget.event.id,
                                    );
                                  }
                                },
                                child: SizedBox(
                                  width: isTablet
                                      ? orientation
                                          ? 0.05.w
                                          : 0.04.w
                                      : 0.095.w,
                                  height: isTablet
                                      ? orientation
                                          ? 0.02.h
                                          : 0.03.h
                                      : 0.03.h,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/three_dots.svg",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface,
                                      ),
                                    ),
                                  ),
                                )),
                      ],
                    ),
                    isTablet
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 0.01.h,
                          ),
                    SizedBox(
                      width: isTablet
                          ? orientation
                              ? 0.25.w
                              : 0.24.w
                          : 0.53.w,
                      child: RowIconTextEvent(
                          iconUrl: "",
                          text: "Type",
                          isFlexible: true,
                          hideImage: true,
                          value: widget.event.type.toString()),
                    ),
                    isTablet
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 0.01.h,
                          ),
                    SizedBox(
                      width: isTablet
                          ? orientation
                              ? 0.25.w
                              : 0.24.w
                          : 0.58.w,
                      child: RowIconTextEvent(
                          iconUrl: "",
                          text: "Department Owner",
                          isFlexible: true,
                          hideImage: true,
                          value: widget.event.departmentOwner.toString()),
                    ),
                    isTablet
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 0.01.h,
                          ),
                    SizedBox(
                      width: isTablet
                          ? orientation
                              ? 0.25.w
                              : 0.24.w
                          : 0.53.w,
                      child: RowIconTextEvent(
                          iconUrl: "",
                          text: "Date",
                          hideImage: true,
                          isFlexible: true,
                          value: Get.locale.toString().contains('en')
                              ? widget.event.date
                              : translateDateFormatToArabic(widget.event.date)),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 0.01.h,
            ),
            widget.isHistory
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: isTablet
                            ? orientation
                                ? 0.12.w
                                : 0.13.w
                            : 0.28.w,
                        height: isTablet ? null : 0.035.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: MyThemeData.blueNew),
                        child: Center(
                          child: Text(
                            "${'Invited'.tr} : ${Get.locale.toString().contains('en') ? widget.event.invited : convertNumberToArabic(widget.event.invited)}",
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isTablet
                                    ? FontConstants.fontSize014.w
                                    : FontConstants.fontSize016.h,
                                fontWeight: FontWeight.w500,
                                height: isTablet
                                    ? orientation
                                        ? 2.1
                                        : 1.7
                                    : 1.7,
                                color: MyThemeData.colorWhite),
                          ),
                        ),
                      ),
                      Container(
                        width: isTablet
                            ? orientation
                                ? 0.12.w
                                : 0.13.w
                            : 0.28.w,
                        height: isTablet ? null : 0.035.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: MyThemeData.unBlock),
                        child: Center(
                          child: Text(
                            "${'Accepted'.tr} : ${Get.locale.toString().contains('en') ? widget.event.accepted : convertNumberToArabic(widget.event.accepted)}",
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isTablet
                                    ? FontConstants.fontSize014.w
                                    : FontConstants.fontSize016.h,
                                fontWeight: FontWeight.w500,
                                height: isTablet
                                    ? orientation
                                        ? 2.1
                                        : 1.7
                                    : 1.7,
                                color: MyThemeData.colorWhite),
                          ),
                        ),
                      ),
                      Container(
                        width: isTablet
                            ? orientation
                                ? 0.12.w
                                : 0.13.w
                            : 0.28.w,
                        height: isTablet ? null : 0.035.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: MyThemeData.delete),
                        child: Center(
                          child: Text(
                            "${'Rejected'.tr} : ${Get.locale.toString().contains('en') ? widget.event.rejected : convertNumberToArabic(widget.event.rejected)}",
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isTablet
                                    ? FontConstants.fontSize014.w
                                    : FontConstants.fontSize016.h,
                                fontWeight: FontWeight.w500,
                                height: isTablet
                                    ? orientation
                                        ? 2.1
                                        : 1.7
                                    : 1.7,
                                color: MyThemeData.colorWhite),
                          ),
                        ),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
