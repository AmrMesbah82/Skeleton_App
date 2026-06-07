import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/events/components/row_icon_text.dart';

class SurveyCard extends StatefulWidget {
  SurveyCard({
    super.key,
    required this.status,
    this.isSelcted = false,
    this.survey,
    this.isSelction = false,
  });
  final String status;
  bool isSelcted;
  final SurveyModel? survey;
  bool isSelction;

  @override
  State<SurveyCard> createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: widget.isSelction
              ? widget.isSelcted
                  ? Border.all(color: MyThemeData.bubbleColor, width: 1.3)
                  : null
              : null,
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
                    imageUrl: widget.survey!.surveyPhoto,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: isTablet
                        ? orientation
                            ? 0.11.w
                            : 0.09.w
                        : 0.23.w,
                    height: isTablet
                        ? orientation
                            ? 0.1.h
                            : 0.14.h
                        : 0.18.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 0.01.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: isTablet
                          ? orientation
                              ? 0.25.w
                              : 0.24.w
                          : 0.64.w,
                      child: RowIconTextEvent(
                          iconUrl: "",
                          isFlexible: true,
                          text: "Survey Title",
                          hideImage: true,
                          value: Get.locale.toString().contains('en')
                              ? widget.survey!.surveyTitle
                              : widget.survey!.surveyTitleArabic),
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
                          : 0.64.w,
                      child: RowIconTextEvent(
                          iconUrl: "",
                          text: "Event Name",
                          isFlexible: true,
                          hideImage: true,
                          value: Get.locale.toString().contains('en')
                              ? widget.survey!.eventName
                              : widget.survey!.eventNameArabic),
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
                          : 0.64.w,
                      child: RowIconTextEvent(
                          iconUrl: "",
                          text: "Type",
                          isFlexible: true,
                          hideImage: true,
                          value: widget.survey!.type),
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
                          : 0.64.w,
                      child: RowIconTextEvent(
                          iconUrl: "",
                          text: "Department Owner",
                          hideImage: true,
                          isFlexible: true,
                          value: widget.survey!.departmentOwner),
                    ),
                    isTablet
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 0.01.h,
                          ),
                    Row(
                      children: [
                        SizedBox(
                          width: isTablet
                              ? orientation
                                  ? widget.isSelction
                                      ? 0.17.w
                                      : 0.175.w
                                  : widget.isSelction
                                      ? 0.23.w
                                      : 0.24.w
                              : 0.5.w,
                          child: RowIconTextEvent(
                              iconUrl: "",
                              text: "Date",
                              isFlexible: true,
                              hideImage: true,
                              value: Get.locale.toString().contains('en')
                                  ? widget.survey!.date
                                  : translateDateFormatToArabic(
                                      widget.survey!.date)),
                        ),
                        Text(
                          widget.survey!.status == 'sent'
                              ? "Published".tr
                              : "Saved".tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              height: 2,
                              fontSize: orientation
                                  ? FontConstants.fontSize013.h
                                  : FontConstants.fontSize013.w,
                              color: (widget.survey!.status == 'sent'
                                          ? "Published".tr
                                          : "Saved".tr) ==
                                      'Published'.tr
                                  ? MyThemeData.unBlock
                                  : MyThemeData.warning,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
