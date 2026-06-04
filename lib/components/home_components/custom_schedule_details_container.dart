import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/components/home_components/custom_profile_row.dart';
import 'package:demo_app/components/home_components/custom_rounded_text_container.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';

/// Date Created :14/November/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :19/November/2023 By Bassem
/// Objectives: this widget is for showing the meeting or task name, description and start time for each one in addition to images of the participants and the total number of the members enrolled in this event

class CustomScheduleDetailesContainer extends StatefulWidget {
  final String text;
  final String description;
  final String startTime;
  final String? endTime;
  final String? orgName;
  final String? totalImagesNum;
  final String firstImage;
  final String? secondImage;

  const CustomScheduleDetailesContainer({
    super.key,
    required this.text,
    required this.description,
    required this.startTime,
    this.totalImagesNum,
    this.endTime = "",
    this.orgName = "",
    required this.firstImage,
    this.secondImage,
  });

  @override
  State<CustomScheduleDetailesContainer> createState() =>
      _CustomScheduleDetailesContainerState();
}
final List<String> notify = [
  '10 Minutes Before'.tr,
  '30 Minutes Before'.tr,
  '1 Hour Before'.tr,
];

String? selectedNotify = '10 Minutes Before'.tr;

final List<String> attend = [
  'Yes'.tr,
  'No'.tr,
  'Maybe'.tr,
];

String? selectedAnswer = 'Yes'.tr;

 

class _CustomScheduleDetailesContainerState
    extends State<CustomScheduleDetailesContainer> {
  TextStyle customTitleTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: FontConstants.fontSize018.h,
      // ignore: unrelated_type_equality_checks
      color: themeController.currentTheme == MyThemeData.lightTheme
          ? MyThemeData.colorBlack
          : MyThemeData.colorWhiteDark,
      fontWeight: FontWeight.w600,
      height: 1.8);
  TextStyle customSubTitleTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
    fontSize: FontConstants.fontSize016.h,
    // ignore: unrelated_type_equality_checks
    color: themeController.currentTheme == MyThemeData.lightTheme
        ? MyThemeData.colorDarkGrey
        : MyThemeData.colorGreydark,
    fontWeight: FontWeight.w400,
    height: 0.0016.h,
  );
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    double imageHight = 0.03.h;
    double space = 0.015.h;
    return Container(
      // width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 0.02.h, horizontal: 0.025.w),
      decoration: BoxDecoration(
        // ignore: unrelated_type_equality_checks
        color: isTablet
            ? themeController.currentTheme == MyThemeData.lightTheme
                ? MyThemeData.colorLightGrey
                : MyThemeData.darkBackGround
            : Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Description".tr, style: customTitleTextStyle),
              //     SvgPicture.asset("assets/icons/more_menu.svg")
            ],
          ),
          SizedBox(height: 0.01.h),
          RoundedTextContainer(text: widget.description),
          SizedBox(height: space),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date".tr, style: customTitleTextStyle),
                    RoundedTextContainer(text: "14/02/2024"),
                  ],
                ),
              ),
              SizedBox(
                width: 0.05.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Repeat".tr, style: customTitleTextStyle),
                    RoundedTextContainer(text: "Weekly".tr),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: space),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Start Time".tr, style: customTitleTextStyle),
                    RoundedTextContainer(text: widget.startTime),
                  ],
                ),
              ),
              SizedBox(
                width: 0.05.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("End Time".tr, style: customTitleTextStyle),
                    RoundedTextContainer(text: widget.endTime!),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: space),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Attending?".tr, style: customTitleTextStyle),
              CustomDropdownButton2(
                buttonPadding: EdgeInsets.symmetric(horizontal: 0.01.h),
                iconHeight: 0.022.h,
                //borded: true,
                buttonWidth: isTablet ? 0.13.h : 0.11.h,
                dropdownWidth: isTablet ? 0.13.h : 0.11.h,
                buttonHeight: 0.045.h,
                isBottomSheet: true,

                hint: 'Yes'.tr,
                dropdownItems: attend,
                value: selectedAnswer,
                onChanged: (String? value) {
                  setState(() {
                    selectedAnswer = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: space),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Notify Me".tr, style: customTitleTextStyle),
              CustomDropdownButton2(
                buttonPadding: EdgeInsets.symmetric(horizontal: 0.01.h),
                iconHeight: 0.022.h,
                //borded: true,
                buttonWidth:double.infinity,
                dropdownWidth:   0.865.w,
                buttonHeight: 0.045.h,
                isBottomSheet: true,
                hint: 'Select'.tr,
                dropdownItems: notify,
                value: selectedNotify,
                onChanged: (String? value) {
                  setState(() {
                    selectedNotify = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: space),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Host".tr, style: customTitleTextStyle),
              OrganizationRow(
                firstImage: widget.firstImage,
                orgName: widget.orgName!,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Invitees".tr, style: customTitleTextStyle),
              OrganizationRow(
                firstImage: widget.firstImage,
                orgName: "Bassem Mohamed",
              ),
              OrganizationRow(
                firstImage: widget.firstImage,
                orgName: "Mazen Shabaan",
              ),
              OrganizationRow(
                firstImage: widget.firstImage,
                orgName: "Mohamed Fouad",
              ),
              OrganizationRow(
                firstImage: widget.firstImage,
                orgName: "Amro Handousa",
              ),
            ],
          ),
          SizedBox(height: space),
        ],
      ),
    );
  }
}
