import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:demo_app/features/skeleton/events/events/controllers/survey_controller.dart/survey_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/app_drawer/presentation/ui/pages/custom_drawer.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/widgets/form_fields/custom_search.dart';
import 'package:demo_app/core/widgets/custom_upper_filter.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/controllers/notification_controller.dart';
import 'package:demo_app/features/skeleton/events/components/survey_components/delete_member_dialog.dart';
import 'package:demo_app/features/skeleton/events/components/survey_components/participants_container.dart';
import 'package:demo_app/features/skeleton/events/mobile/survey/participant_detail_mobile.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/views/survey/no_response_particpant_dialog.dart';
import 'package:demo_app/features/skeleton/events/tablet/media_departments_view/views/survey/participant_detail_screen.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/settings_screen.dart';

class ParticipantsScreen extends StatefulWidget {
  const ParticipantsScreen({super.key, this.survey, this.isEmployee});

  final SurveyModel? survey;
  final bool? isEmployee;

  @override
  State<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  int selectedIndex = 0;
  final SurveyController surveyController = Get.put(SurveyController());
  AppNotificationController notificationController =
      Get.put(AppNotificationController());

  @override
  void initState() {
    surveyController.filterListParticipant
        .assignAll(widget.survey!.partitcipants);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> pendingEmails = widget.survey!.partitcipants
        .where((participant) => participant.status == "Pending")
        .map((participant) => participant.email)
        .toList();
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 0.015.w, vertical: 0.015.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.inversePrimary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isPortrait)
                  SizedBox(
                    height: 0.02.h,
                  ),
                (!Mode.hr && !Mode.owner) || widget.isEmployee == true
                    ? const SizedBox.shrink()
                    : UpperFilters(
                        selectedIndex: selectedIndex,
                        selectedDepartmentState: (value) {},
                        selectedIndexState: (value) {
                          setState(() {
                            selectedIndex = value;
                            surveyController.changeListFilter(
                                selectedIndex, widget.survey!);
                          });
                        },
                        filterTitles: [
                            'All',
                            '${"Responded".tr} (${Get.locale.toString().contains('en') ? widget.survey!.partitcipants.where((participant) => participant.status == "Responded").toList().length : convertNumberToArabic(widget.survey!.partitcipants.where((participant) => participant.status == "Responded").toList().length.toString())})',
                            '${"Started".tr} (${Get.locale.toString().contains('en') ? widget.survey!.partitcipants.where((participant) => participant.status == "Started").toList().length : convertNumberToArabic(widget.survey!.partitcipants.where((participant) => participant.status == "Started").toList().length.toString())})',
                            '${"Pending".tr} (${Get.locale.toString().contains('en') ? widget.survey!.partitcipants.where((participant) => participant.status == "Pending").toList().length : convertNumberToArabic(widget.survey!.partitcipants.where((participant) => participant.status == "Pending").toList().length.toString())})',
                          ]),
                SizedBox(
                  height: isPortrait ? 0.0.h : 0.02.h,
                ),
                Row(
                  crossAxisAlignment:isTablet? isPortrait
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center : CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomSearchFiled2(
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          hint: "Search".tr,
                          onChanged: (value) {
                            setState(() {
                              surveyController.searchParticipants(
                                  value, widget.survey!);
                            });
                          },
                          hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: isPortrait
                                  ? FontConstants.fontSize016.h
                                  : FontConstants.fontSize022.h,
                              fontWeight: FontWeight.w500,
                                height: isTablet? null : 2.4 ,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface),
                          keyBoardType: TextInputType.text),
                    ),
                    (!Mode.hr && !Mode.owner) || widget.isEmployee == true
                        ? const SizedBox.shrink()
                        : SizedBox(width: 0.015.w),
                    (!Mode.hr && !Mode.owner) || widget.isEmployee == true
                        ? const SizedBox.shrink()
                        : CustomIconButton(
                          buttonHeight: 0.05.h,
                            buttonText: "Send Reminders",
                            imagePath: "assets/images/events_knwoticed.svg",
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DeleteMemberDialog(
                                    width: isTablet
                                        ? (isPortrait ? 0.1.w : 0.055.w)
                                        : 0.15.w,
                                    scale: isPortrait ? 0.8 : 1,
                                    lottieUrl: "assets/images/reminder_lo.json",
                                    onPressed: () async {
                                      await notificationController
                                          .sendNotificationToMultiple(
                                              title: widget.survey!.surveyTitle,
                                              arabicTitle: widget
                                                  .survey!.surveyTitleArabic,
                                              body:
                                                  "Please complete the survey for ${widget.survey!.surveyTitle}. Your participation is important to us",
                                              arabicBody:
                                                  "  يرجى إكمال الاستبيان الخاص ب ${widget.survey!.surveyTitleArabic}. مشاركتك مهمة لنا",
                                              type: "note",
                                              topics: pendingEmails);

                                      Navigator.of(context).pop();
                                    },
                                    subtitle:
                                        "Are You Sure You Want To Send It?",
                                    title:
                                        "This Reminder Will Be Sent To All Those Who Have Not Finished The Survey",
                                    yesText: "Yes",
                                  );
                                },
                              );
                            },
                          ),
                  ],
                ),
                SizedBox(
                  height: isPortrait ? 0.01.h : 0.04.h,
                ),
                if (!isPortrait)
                  GetBuilder<SurveyController>(builder: (controller) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          (surveyController.filterListParticipant.length / 3)
                              .ceil(),
                          (int index) {
                            int firstIndex = index * 3;
                            int secondIndex = firstIndex + 1;
                            int thirdIndex = firstIndex + 2;

                            return Padding(
                              padding: EdgeInsets.only(
                                  right: Get.locale.toString().contains('en')
                                      ? 0.01.w
                                      : 0,
                                  left: Get.locale.toString().contains('en')
                                      ? 0
                                      : 0.01.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  firstIndex <
                                          surveyController
                                              .filterListParticipant.length
                                      ? GestureDetector(
                                          onTap: () {
                                            surveyController
                                                        .filterListParticipant[
                                                            firstIndex]
                                                        .status ==
                                                    "Pending"
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        NoResponseParticipantDialog(),
                                                  )
                                                : isTablet
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParticipantDetailScreen(
                                                                survey: widget
                                                                    .survey,
                                                                selctedIndex:
                                                                firstIndex,
                                                              ),
                                                        ),
                                                      )
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParticipantDetailMobile(
                                                                  survey: widget
                                                                      .survey,
                                                                  selctedIndex:
                                                                      firstIndex,
                                                                )));
                                          },
                                          child: ParticipantsContainer(
                                            survey: widget.survey!,
                                            email: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .email,
                                            nameArabic: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .nameArabic,
                                            departmentArabic: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .departmentArabic,
                                            department: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .department,
                                            jobTitle: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .jobTitle,
                                            name: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .name,
                                            profilePhoto: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .profilePhoto,
                                            status: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .status,
                                            withStatus: true,
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: 0.03.h),
                                  secondIndex <
                                          surveyController
                                              .filterListParticipant.length
                                      ? GestureDetector(
                                          onTap: () {
                                            surveyController
                                                        .filterListParticipant[
                                                            secondIndex]
                                                        .status ==
                                                    "Pending"
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        NoResponseParticipantDialog(),
                                                  )
                                                : isTablet
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParticipantDetailScreen(
                                                                survey: widget
                                                                    .survey,
                                                                selctedIndex:
                                                                secondIndex,
                                                              ),
                                                        ),
                                                      )
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParticipantDetailMobile(
                                                                  survey: widget
                                                                      .survey,
                                                                  selctedIndex:
                                                                      secondIndex,
                                                                )));
                                          },
                                          child: ParticipantsContainer(
                                            survey: widget.survey!,
                                            email: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .email,
                                            nameArabic: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .nameArabic,
                                            departmentArabic: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .departmentArabic,
                                            department: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .department,
                                            jobTitle: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .jobTitle,
                                            name: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .name,
                                            profilePhoto: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .profilePhoto,
                                            status: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .status,
                                            withStatus: true,
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: 0.03.h),
                                  thirdIndex <
                                          surveyController
                                              .filterListParticipant.length
                                      ? GestureDetector(
                                          onTap: () {
                                            surveyController
                                                        .filterListParticipant[
                                                            thirdIndex]
                                                        .status ==
                                                    "Pending"
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        NoResponseParticipantDialog(),
                                                  )
                                                : isTablet
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParticipantDetailScreen(
                                                                survey: widget
                                                                    .survey,
                                                                selctedIndex:
                                                                thirdIndex,
                                                              ),
                                                        ),
                                                      )
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParticipantDetailMobile(
                                                                  survey: widget
                                                                      .survey,
                                                                  selctedIndex:
                                                                      thirdIndex,
                                                                )));
                                          },
                                          child: ParticipantsContainer(
                                            survey: widget.survey!,
                                            email: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .email,
                                            department: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .department,
                                            nameArabic: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .nameArabic,
                                            departmentArabic: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .departmentArabic,
                                            jobTitle: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .jobTitle,
                                            name: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .name,
                                            profilePhoto: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .profilePhoto,
                                            status: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .status,
                                            withStatus: true,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                if (isPortrait)
                  GetBuilder<SurveyController>(builder: (secondController) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          (surveyController.filterListParticipant.length / 8)
                              .ceil(),
                          (int index) {
                            int firstIndex = index * 8;
                            int secondIndex = firstIndex + 1;
                            int thirdIndex = firstIndex + 2;
                            int fourthIndex = firstIndex + 3;
                            int fifthIndex = firstIndex + 4;
                            int sixthIndex = firstIndex + 5;
                            int seventhIndex = firstIndex + 6;
                            int eighthIndex = firstIndex + 7;

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.01.w),
                              child: Column(
                                children: [
                                  firstIndex <
                                          surveyController
                                              .filterListParticipant.length
                                      ? GestureDetector(
                                          onTap: () {
                                            debugPrint(
                                                "firstIndex: $firstIndex");
                                            surveyController
                                                        .filterListParticipant[
                                                            firstIndex]
                                                        .status ==
                                                    "Pending"
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        NoResponseParticipantDialog(),
                                                  )
                                                : isTablet
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParticipantDetailScreen(
                                                                survey: widget
                                                                    .survey,
                                                                selctedIndex:
                                                                firstIndex,
                                                              ),
                                                        ),
                                                      )
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParticipantDetailMobile(
                                                                  survey: widget
                                                                      .survey,
                                                                  selctedIndex:
                                                                      firstIndex,
                                                                )));
                                          },
                                          child: ParticipantsContainer(
                                            survey: widget.survey!,
                                            email: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .email,
                                            isEmployee:
                                                (!Mode.hr && !Mode.owner) ||
                                                    widget.isEmployee == true,
                                            department: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .department,
                                            jobTitle: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .jobTitle,
                                            nameArabic: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .nameArabic,
                                            departmentArabic: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .departmentArabic,
                                            name: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .name,
                                            profilePhoto: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .profilePhoto,
                                            status: surveyController
                                                .filterListParticipant[
                                                    firstIndex]
                                                .status,
                                            withStatus: true,
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: 0.015.h),
                                  secondIndex <
                                          surveyController
                                              .filterListParticipant.length
                                      ? GestureDetector(
                                          onTap: () {
                                            surveyController
                                                        .filterListParticipant[
                                                            secondIndex]
                                                        .status ==
                                                    "Pending"
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        NoResponseParticipantDialog(),
                                                  )
                                                : isTablet
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParticipantDetailScreen(
                                                                survey: widget
                                                                    .survey,
                                                                selctedIndex:
                                                                secondIndex,
                                                              ),
                                                        ),
                                                      )
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParticipantDetailMobile(
                                                                  survey: widget
                                                                      .survey,
                                                                  selctedIndex:
                                                                      secondIndex,
                                                                )));
                                          },
                                          child: ParticipantsContainer(
                                            survey: widget.survey!,
                                            email: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .email,
                                            isEmployee:
                                                (!Mode.hr && !Mode.owner) ||
                                                    widget.isEmployee == true,
                                            department: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .department,
                                            nameArabic: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .nameArabic,
                                            departmentArabic: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .departmentArabic,
                                            jobTitle: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .jobTitle,
                                            name: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .name,
                                            profilePhoto: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .profilePhoto,
                                            status: surveyController
                                                .filterListParticipant[
                                                    secondIndex]
                                                .status,
                                            withStatus: true,
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: 0.015.h),
                                  thirdIndex <
                                          surveyController
                                              .filterListParticipant.length
                                      ? GestureDetector(
                                          onTap: () {
                                            surveyController
                                                        .filterListParticipant[
                                                            thirdIndex]
                                                        .status ==
                                                    "Pending"
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        NoResponseParticipantDialog(),
                                                  )
                                                : isTablet
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParticipantDetailScreen(
                                                                survey: widget
                                                                    .survey,
                                                                selctedIndex:
                                                                thirdIndex,
                                                              ),
                                                        ),
                                                      )
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParticipantDetailMobile(
                                                                  survey: widget
                                                                      .survey,
                                                                  selctedIndex:
                                                                      thirdIndex,
                                                                )));
                                          },
                                          child: ParticipantsContainer(
                                            survey: widget.survey!,
                                            email: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .email,
                                            isEmployee:
                                                (!Mode.hr && !Mode.owner) ||
                                                    widget.isEmployee == true,
                                            department: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .department,
                                            jobTitle: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .jobTitle,
                                            name: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .name,
                                            nameArabic: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .nameArabic,
                                            departmentArabic: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .departmentArabic,
                                            profilePhoto: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .profilePhoto,
                                            status: surveyController
                                                .filterListParticipant[
                                                    thirdIndex]
                                                .status,
                                            withStatus: true,
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: 0.015.h),
                                  fourthIndex <
                                          surveyController
                                              .filterListParticipant.length
                                      ? GestureDetector(
                                          onTap: () {
                                            surveyController
                                                        .filterListParticipant[
                                                            fourthIndex]
                                                        .status ==
                                                    "Pending"
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        NoResponseParticipantDialog(),
                                                  )
                                                : isTablet
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParticipantDetailScreen(
                                                                survey: widget
                                                                    .survey,
                                                                selctedIndex:
                                                                fourthIndex,
                                                              ),
                                                        ),
                                                      )
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParticipantDetailMobile(
                                                                  survey: widget
                                                                      .survey,
                                                                  selctedIndex:
                                                                      fourthIndex,
                                                                )));
                                          },
                                          child: ParticipantsContainer(
                                            survey: widget.survey!,
                                            email: surveyController
                                                .filterListParticipant[
                                                    fourthIndex]
                                                .email,
                                            department: surveyController
                                                .filterListParticipant[
                                                    fourthIndex]
                                                .department,
                                            isEmployee:
                                                (!Mode.hr && !Mode.owner) ||
                                                    widget.isEmployee == true,
                                            jobTitle: surveyController
                                                .filterListParticipant[
                                                    fourthIndex]
                                                .jobTitle,
                                            nameArabic: surveyController
                                                .filterListParticipant[
                                                    fourthIndex]
                                                .nameArabic,
                                            departmentArabic: surveyController
                                                .filterListParticipant[
                                                    fourthIndex]
                                                .departmentArabic,
                                            name: surveyController
                                                .filterListParticipant[
                                                    fourthIndex]
                                                .name,
                                            profilePhoto: surveyController
                                                .filterListParticipant[
                                                    fourthIndex]
                                                .profilePhoto,
                                            status: surveyController
                                                .filterListParticipant[
                                                    fourthIndex]
                                                .status,
                                            withStatus: true,
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: 0.015.h),
                                  fifthIndex <
                                          surveyController
                                              .filterListParticipant.length
                                      ? GestureDetector(
                                          onTap: () {
                                            surveyController
                                                        .filterListParticipant[
                                                            fifthIndex]
                                                        .status ==
                                                    "Pending"
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        NoResponseParticipantDialog(),
                                                  )
                                                : isTablet
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParticipantDetailScreen(
                                                                survey: widget
                                                                    .survey,
                                                                selctedIndex:
                                                                fifthIndex,
                                                              ),
                                                        ),
                                                      )
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParticipantDetailMobile(
                                                                  survey: widget
                                                                      .survey,
                                                                  selctedIndex:
                                                                      fifthIndex,
                                                                )));
                                          },
                                          child: ParticipantsContainer(
                                            survey: widget.survey!,
                                            email: surveyController
                                                .filterListParticipant[
                                                    fifthIndex]
                                                .email,
                                            isEmployee:
                                                (!Mode.hr && !Mode.owner) ||
                                                    widget.isEmployee == true,
                                            department: surveyController
                                                .filterListParticipant[
                                                    fifthIndex]
                                                .department,
                                            jobTitle: surveyController
                                                .filterListParticipant[
                                                    fifthIndex]
                                                .jobTitle,
                                            name: surveyController
                                                .filterListParticipant[
                                                    fifthIndex]
                                                .name,
                                            nameArabic: surveyController
                                                .filterListParticipant[
                                                    fifthIndex]
                                                .nameArabic,
                                            departmentArabic: surveyController
                                                .filterListParticipant[
                                                    fifthIndex]
                                                .departmentArabic,
                                            profilePhoto: surveyController
                                                .filterListParticipant[
                                                    fifthIndex]
                                                .profilePhoto,
                                            status: surveyController
                                                .filterListParticipant[
                                                    fifthIndex]
                                                .status,
                                            withStatus: true,
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: 0.015.h),
                                  sixthIndex <
                                          surveyController
                                              .filterListParticipant.length
                                      ? GestureDetector(
                                          onTap: () {
                                            surveyController
                                                        .filterListParticipant[
                                                            sixthIndex]
                                                        .status ==
                                                    "Pending"
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        NoResponseParticipantDialog(),
                                                  )
                                                : isTablet
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParticipantDetailScreen(
                                                                survey: widget
                                                                    .survey,
                                                                selctedIndex:
                                                                sixthIndex,
                                                              ),
                                                        ),
                                                      )
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParticipantDetailMobile(
                                                                  survey: widget
                                                                      .survey,
                                                                  selctedIndex:
                                                                      sixthIndex,
                                                                )));
                                          },
                                          child: ParticipantsContainer(
                                            survey: widget.survey!,
                                            email: surveyController
                                                .filterListParticipant[
                                                    sixthIndex]
                                                .email,
                                            isEmployee:
                                                (!Mode.hr && !Mode.owner) ||
                                                    widget.isEmployee == true,
                                            department: surveyController
                                                .filterListParticipant[
                                                    sixthIndex]
                                                .department,
                                            nameArabic: surveyController
                                                .filterListParticipant[
                                                    sixthIndex]
                                                .nameArabic,
                                            departmentArabic: surveyController
                                                .filterListParticipant[
                                                    sixthIndex]
                                                .departmentArabic,
                                            jobTitle: surveyController
                                                .filterListParticipant[
                                                    sixthIndex]
                                                .jobTitle,
                                            name: surveyController
                                                .filterListParticipant[
                                                    sixthIndex]
                                                .name,
                                            profilePhoto: surveyController
                                                .filterListParticipant[
                                                    sixthIndex]
                                                .profilePhoto,
                                            status: surveyController
                                                .filterListParticipant[
                                                    sixthIndex]
                                                .status,
                                            withStatus: true,
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: 0.015.h),
                                  seventhIndex <
                                          surveyController
                                              .filterListParticipant.length
                                      ? GestureDetector(
                                          onTap: () {
                                            surveyController
                                                        .filterListParticipant[
                                                            seventhIndex]
                                                        .status ==
                                                    "Pending"
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        NoResponseParticipantDialog(),
                                                  )
                                                : isTablet
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParticipantDetailScreen(
                                                                survey: widget
                                                                    .survey,
                                                                selctedIndex:
                                                                seventhIndex,
                                                              ),
                                                        ),
                                                      )
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParticipantDetailMobile(
                                                                  survey: widget
                                                                      .survey,
                                                                  selctedIndex:
                                                                      seventhIndex,
                                                                )));
                                          },
                                          child: ParticipantsContainer(
                                            survey: widget.survey!,
                                            email: surveyController
                                                .filterListParticipant[
                                                    seventhIndex]
                                                .email,
                                            department: surveyController
                                                .filterListParticipant[
                                                    seventhIndex]
                                                .department,
                                            isEmployee:
                                                (!Mode.hr && !Mode.owner) ||
                                                    widget.isEmployee == true,
                                            jobTitle: surveyController
                                                .filterListParticipant[
                                                    seventhIndex]
                                                .jobTitle,
                                            name: surveyController
                                                .filterListParticipant[
                                                    seventhIndex]
                                                .name,
                                            profilePhoto: surveyController
                                                .filterListParticipant[
                                                    seventhIndex]
                                                .profilePhoto,
                                            nameArabic: surveyController
                                                .filterListParticipant[
                                                    seventhIndex]
                                                .nameArabic,
                                            departmentArabic: surveyController
                                                .filterListParticipant[
                                                    seventhIndex]
                                                .departmentArabic,
                                            status: surveyController
                                                .filterListParticipant[
                                                    seventhIndex]
                                                .status,
                                            withStatus: true,
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: 0.015.h),
                                  eighthIndex <
                                          surveyController
                                              .filterListParticipant.length
                                      ? GestureDetector(
                                          onTap: () {
                                            surveyController
                                                        .filterListParticipant[
                                                            eighthIndex]
                                                        .status ==
                                                    "Pending"
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        NoResponseParticipantDialog(),
                                                  )
                                                : isTablet
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParticipantDetailScreen(
                                                                survey: widget
                                                                    .survey,
                                                                selctedIndex:
                                                                eighthIndex,
                                                              ),
                                                        ),
                                                      )
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParticipantDetailMobile(
                                                                  survey: widget
                                                                      .survey,
                                                                  selctedIndex:
                                                                      eighthIndex,
                                                                )));
                                          },
                                          child: ParticipantsContainer(
                                            survey: widget.survey!,
                                            email: surveyController
                                                .filterListParticipant[
                                                    eighthIndex]
                                                .email,
                                            department: surveyController
                                                .filterListParticipant[
                                                    eighthIndex]
                                                .department,
                                            jobTitle: surveyController
                                                .filterListParticipant[
                                                    eighthIndex]
                                                .jobTitle,
                                            name: surveyController
                                                .filterListParticipant[
                                                    eighthIndex]
                                                .name,
                                            nameArabic: surveyController
                                                .filterListParticipant[
                                                    eighthIndex]
                                                .nameArabic,
                                            departmentArabic: surveyController
                                                .filterListParticipant[
                                                    eighthIndex]
                                                .departmentArabic,
                                            isEmployee:
                                                (!Mode.hr && !Mode.owner) ||
                                                    widget.isEmployee == true,
                                            profilePhoto: surveyController
                                                .filterListParticipant[
                                                    eighthIndex]
                                                .profilePhoto,
                                            status: surveyController
                                                .filterListParticipant[
                                                    eighthIndex]
                                                .status,
                                            withStatus: true,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                SizedBox(
                  height: 0.02.h,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
