import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/feature/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/events/components/row_icon_text.dart';
import 'package:demo_app/feature/events/controllers/events_controllers/model/event_model.dart';
import 'package:demo_app/feature/events/tablet/media_departments_view/components/survey_pop_menu.dart';

class EventContainerHistory extends StatefulWidget {
  EventContainerHistory({
    super.key,
    this.status,
    this.survey,
    required this.event,
    this.selectedIndex,
    required this.isEmployee,
  });

  String? status;

  final EventModel event;
  final SurveyModel? survey;
  final bool isEmployee;
  int? selectedIndex;

  @override
  State<EventContainerHistory> createState() => _EventContainerHistoryState();
}

class _EventContainerHistoryState extends State<EventContainerHistory> {
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
                                  : 0.24.w
                              : 0.5.w,
                          child: RowIconTextEvent(
                            iconUrl: "",
                            text: "Name",
                            hideImage: true,
                            isFlexible: true,
                            value: Get.locale.toString().contains('en')
                                ? widget.event.eventNameEnglish
                                : widget.event.eventNameArabic,
                          ),
                        ),
                        if (widget.event.hasSurvey &&
                            widget.isEmployee &&
                            widget.event.status!.capitalize == 'Accepted')
                          InkWell(
                            onTapUp: (details) async {
                              final iconPosition = details.globalPosition;
                              SurveyPopMenu sortMenu = SurveyPopMenu();
                              if (widget.event.hasSurvey) {
                                await sortMenu.showSortMenu(
                                    context,
                                    iconPosition,
                                    "Options".tr,
                                    widget.survey,
                                    widget.event.id,
                                    selectedIndex: widget.selectedIndex!);
                              }
                            },
                            child: SizedBox(
                              width: isTablet
                                  ? orientation
                                      ? 0.05.w
                                      : 0.055.w
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
                            ),
                          )
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
                          hideImage: true,
                          isFlexible: true,
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
                          : 0.61.w,
                      child: RowIconTextEvent(
                          iconUrl: "",
                          text: "Department Owner",
                          hideImage: true,
                          isFlexible: true,
                          value: widget.event.departmentOwner.toString()),
                    ),
                    isTablet
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 0.01.h,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: isTablet
                              ? orientation
                                  ? 0.18.w
                                  : 0.23.w
                              : 0.5.w,
                          child: RowIconTextEvent(
                              iconUrl: "",
                              text: "Date",
                              hideImage: true,
                              isFlexible: true,
                              value: Get.locale.toString().contains('en')
                                  ? widget.event.date
                                  : translateDateFormatToArabic(
                                      widget.event.date)),
                        ),
                        Text(
                          widget.event.status!.capitalize == 'Sent' ||
                                  widget.event.status!.capitalize == 'Accepted'
                              ? 'Accepted'.tr
                              : 'Rejected'.tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              height: 2,
                              fontSize: orientation
                                  ? FontConstants.fontSize013.h
                                  : FontConstants.fontSize013.w,
                              color: (widget.event.status!.capitalize ==
                                                  'Sent' ||
                                              widget.event.status!.capitalize ==
                                                  'Accepted'
                                          ? 'Accepted'
                                          : 'Rejected') ==
                                      'Accepted'
                                  ? MyThemeData.unBlock
                                  : MyThemeData.colorRed,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 0.01.h,
            ),
          ],
        ),
      ),
    );
  }
}
