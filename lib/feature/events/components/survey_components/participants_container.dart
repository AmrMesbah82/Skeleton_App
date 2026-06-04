import 'package:demo_app/feature/events/events/controllers/survey_controller.dart/model/survey_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/components/requests_components/requests_filter_appbar.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/controller/notification_controller.dart';
import 'package:demo_app/feature/events/components/survey_components/delete_member_dialog.dart';

class ParticipantsContainer extends StatefulWidget {
  const ParticipantsContainer({
    super.key,
    required this.department,
    required this.jobTitle,
    required this.name,
    required this.nameArabic,
    required this.departmentArabic,
    required this.profilePhoto,
    this.status,
    this.withStatus = false,
    required this.email,
    required this.survey,
    this.isEmployee,
  });
  final String profilePhoto;
  final String name;
  final String nameArabic;
  final String jobTitle;
  final String department;
  final String departmentArabic;
  final bool withStatus;
  final String? status;
  final String email;
  final SurveyModel survey;
  final bool? isEmployee;
  @override
  State<ParticipantsContainer> createState() => _ParticipantsContainerState();
}

class _ParticipantsContainerState extends State<ParticipantsContainer> {
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'responded':
        return MyThemeData.unBlock;
      case 'pending':
        return MyThemeData.warning;
      case 'started':
        return MyThemeData.lightPrimary;
      default:
        return MyThemeData.unBlock;
    }
  }

  AppNotificationController notificationController =
      Get.put(AppNotificationController());

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      width: isTablet
          ? isPortrait
              ? 0.43.w
              : 0.37.w
          : 0.87.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.015.w, vertical: isPortrait ? 0.01.h : 0.015.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: isTablet
                  ? isPortrait
                      ? 0.035.w
                      : 0.025.w
                  : 0.09.w,
              backgroundImage: AssetImage(widget.profilePhoto),
            ),
            SizedBox(
              width: isTablet ? 0.01.w : 0.03.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      //   color: Colors.amber,
                      width: isTablet
                          ? isPortrait
                              ? 0.22.w
                              : widget.status == "Responded".tr
                                  ? 0.19.w
                                  : 0.2.w
                          : 0.45.w,
                      child: Text(
                        Get.locale.toString().contains('ar')
                            ? widget.nameArabic
                            : widget.name.capitalize!,
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: isTablet
                                ? isPortrait
                                    ? FontConstants.fontSize022.w
                                    : FontConstants.fontSize014.w
                                : FontConstants.fontSize018.h,
                            color: Theme.of(context).colorScheme.inverseSurface,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: 0.01.w,
                    ),
                    Text(
                      widget.status!.tr,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: isTablet
                              ? isPortrait
                                  ? FontConstants.fontSize012.h
                                  : FontConstants.fontSize012.w
                              : FontConstants.fontSize015.h,
                          color: getStatusColor(widget.status!),
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.015.h),
                  child: SizedBox(
                    //  color: Colors.amber,
                    width: isTablet ? 0.25.w : 0.4.w,
                    child: Text(
                      Get.locale.toString().contains('ar')
                          ? widget.departmentArabic
                          : widget.department.capitalize!,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: isTablet
                              ? isPortrait
                                  ? FontConstants.fontSize012.h
                                  : FontConstants.fontSize012.w
                              : FontConstants.fontSize015.h,
                          color: MyThemeData.textGrey,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                widget.status == "Pending".tr
                    ? (!Mode.hr && !Mode.owner)
                        ? SizedBox(
                            height: 0.01.h,
                          )
                        : const SizedBox.shrink()
                    : SizedBox(
                        height: 0.01.h,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          //   color: Colors.amber,
                          width: isTablet
                              ? isPortrait
                                  ? 0.14.w
                                  : 0.15.w
                              : 0.3.w,
                          child: Text(
                            Get.locale.toString().contains('ar')
                                ? widget.jobTitle.capitalize!.tr
                                : addDepartmentController
                                    .containAbbreviation(widget.jobTitle),
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isTablet
                                    ? isPortrait
                                        ? FontConstants.fontSize010.h
                                        : FontConstants.fontSize012.w
                                    : FontConstants.fontSize015.h,
                                color: MyThemeData.textGrey,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        widget.status == "Pending".tr
                            ? (!Mode.hr && !Mode.owner) ||
                                    widget.isEmployee == true
                                ? const SizedBox.shrink()
                                : MainCustomIconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DeleteMemberDialog(
                                            lottieUrl:
                                                "assets/images/reminder_lo.json",
                                            width: isTablet
                                                ? (isPortrait ? 0.1.w : 0.055.w)
                                                : 0.15.w,
                                            scale: isPortrait ? 0.8 : 1,
                                            onPressed: () async {
                                              await notificationController
                                                  .sendNotification(
                                                      title: widget
                                                          .survey.surveyTitle,
                                                      arabicTitle:
                                                          widget.survey
                                                              .surveyTitleArabic,
                                                      body:
                                                          "Please complete the survey for ${widget.survey.surveyTitle}. Your participation is important to us",
                                                      arabicBody:
                                                          "  يرجى إكمال الاستبيان الخاص ب ${widget.survey.surveyTitleArabic}. مشاركتك مهمة لنا",
                                                      type: "note",
                                                      topic: widget.email);
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
                                    buttonText: "Send Reminder",
                                    buttonStyle: ElevatedButton.styleFrom(
                                      minimumSize: isTablet
                                          ? Size(isPortrait ? 0.16.w : 0.12.w,
                                              isPortrait ? 0.025.h : 0.035.h)
                                          : Size(
                                              0.3.w, isPortrait ? 0.035.h : 0),
                                      maximumSize: isTablet
                                          ? Size(isPortrait ? 0.16.w : 0.12.w,
                                              isPortrait ? 0.025.h : 0.035.h)
                                          : Size(
                                              0.35.w, isPortrait ? 0.045.h : 0),
                                      backgroundColor: MyThemeData.signOut,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      )),
                                    ),
                                  )
                            : const SizedBox.shrink()
                        // CustomIconButton(
                        //   buttonText: "Send Reminder",

                        //   hasIcon: false,
                        //   imagePath: "assets/icons/trashIcon.svg",
                        //   onPressed: () {
                        //     // showDialog(
                        //     //   context: context,
                        //     //   builder: (context) {
                        //     //     return DeleteMemberDialog(
                        //     //       lottieUrl: "assets/images/delete.json",
                        //     //       onPressed: () {
                        //     //         Navigator.of(context).pop();
                        //     //       },
                        //     //       subtitle:
                        //     //           "Are You Sure You Want To Delete This Survey ?",
                        //     //       title: "Delete Survey",
                        //     //       yesText: "Yes, Delete",
                        //     //     );
                        //     //   },
                        //     // );
                        //   },
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
