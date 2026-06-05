import 'package:demo_app/core/theme/grc_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/components/employees_components/employees_hr_components/employee_hr_profile_components/info_with_bullet_list.dart';
import 'package:demo_app/components/job_components/custom_experience_bullet_points.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/widgets/settings_header.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';
import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';

class CustomCandidateDetailsBodyContainerMobile extends StatefulWidget {
  final VoidCallback? onAcceptPressed;
  final VoidCallback? onDeclinePressed;
  final VoidCallback? onCoverLetterDownlaodPressed;
  final VoidCallback? onResumeDownlaodPressed;
  final String bioText;
  final String emailText;
  final String phoneNumber;
  final String country;
  final String city;
  final String address;
  final String resumeFileName;
  final String coverLetterFileName;
  final List<String> workExperienceTitles;
  final List<String> workExperienceFrom;
  final List<String> workExperienceTo;
  final List<String> educationTitles;
  final List<String> educationFrom;
  final List<String> educationTo;
  final List<String> languageSkills;
  final List<String> otherSkills;
  final List<String> interviewAvailability;
  final String relocationAbility;
  final String startDateAvailability;

  const CustomCandidateDetailsBodyContainerMobile({
    Key? key,
    this.onAcceptPressed,
    this.onDeclinePressed,
    this.onCoverLetterDownlaodPressed,
    this.onResumeDownlaodPressed,
    required this.bioText,
    required this.emailText,
    required this.phoneNumber,
    required this.country,
    required this.city,
    required this.address,
    required this.resumeFileName,
    required this.coverLetterFileName,
    required this.workExperienceTitles,
    required this.workExperienceFrom,
    required this.workExperienceTo,
    required this.educationTitles,
    required this.educationFrom,
    required this.educationTo,
    required this.languageSkills,
    required this.otherSkills,
    required this.interviewAvailability,
    required this.relocationAbility,
    required this.startDateAvailability,
  }) : super(key: key);

  @override
  State<CustomCandidateDetailsBodyContainerMobile> createState() =>
      _CustomCandidateDetailsBodyContainerMobileState();
}

class _CustomCandidateDetailsBodyContainerMobileState
    extends State<CustomCandidateDetailsBodyContainerMobile> {
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double heightSpacer = 0.02.h;
    double widthSpacer = 0.02.w;
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(0.02.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsHeader(
                imagePath: 'assets/icons/newPersonalInfoIcon.svg',
                text: 'Bio',
              ),
              customColoredContainer(
                text: widget.bioText,
              ),
              SizedBox(
                height: heightSpacer,
              ),
              /////////////////////////////////////////////////
              SettingsHeader(
                imagePath: 'assets/icons/newContactInfo.svg',
                text: 'Contact Information',
              ),
              customColoredContainer(
                text: widget.emailText,
              ),

              customColoredContainer(
                text: widget.phoneNumber,
              ),
              /////////////////////////////////////////////////
              ///
              SizedBox(
                height: heightSpacer,
              ),
              /////////////////////////////////////////////////
              SettingsHeader(
                imagePath: 'assets/images/map_new.svg',
                text: 'Location Information',
              ),
              customColoredContainer(
                text: widget.country,
              ),

              customColoredContainer(
                text: widget.city,
              ),
              customColoredContainer(
                text: widget.city,
              ),
              SizedBox(
                width: widthSpacer,
              ),
              customColoredContainer(
                text: widget.address,
              ),
              /////////////////////////////////////////////////
              ///
              SizedBox(
                height: heightSpacer,
              ),
              SettingsHeader(
                imagePath: 'assets/icons/resume.svg',
                text: 'Resume',
              ),
              InkWell(
                onTap: widget.onCoverLetterDownlaodPressed,
                child: customColoredContainer(
                  text: widget.resumeFileName,
                ),
              ),
              SizedBox(
                height: heightSpacer,
              ),
              SettingsHeader(
                imagePath: 'assets/icons/resume.svg',
                text: 'Cover Letter',
              ),
              InkWell(
                onTap: widget.onResumeDownlaodPressed,
                child: customColoredContainer(
                  text: widget.coverLetterFileName,
                ),
              ),
              SizedBox(
                height: heightSpacer,
              ),
              SettingsHeader(
                imagePath: 'assets/icons/socialMediaLinks.svg',
                text: 'Social Media Links',
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isPortrait ? 0.01.w : 0.007.w,
                ),
                child: Wrap(
                  direction: Axis.horizontal,  
                  alignment: WrapAlignment.start,
                  spacing: 0.05.w,  

                  children: [
                    customSvgImage(
                      imagePath: "assets/images/addAttach.svg",
                      link: "https://example.com",
                      onTap: () {
                        // Handle onTap action
                      },
                    ),
                    customSvgImage(
                      imagePath: "assets/images/facebookImage.svg",
                      link: "https://example.com",
                      onTap: () {
                        // Handle onTap action
                      },
                    ),
                    customSvgImage(
                      imagePath: "assets/images/xImage.svg",
                      link: "https://example.com",
                      onTap: () {
                        // Handle onTap action
                      },
                    ),
                    customSvgImage(
                      imagePath: "assets/images/instaImage.svg",
                      link: "https://example.com",
                      onTap: () {
                        // Handle onTap action
                      },
                    ),
                    customSvgImage(
                      imagePath: "assets/images/youtubeImage.svg",
                      link: "https://example.com",
                      onTap: () {
                        // Handle onTap action
                      },
                    ),
                    customSvgImage(
                      imagePath: "assets/images/githubImage.svg",
                      link: "https://example.com",
                      onTap: () {
                        // Handle onTap action
                      },
                    ),
                    customSvgImage(
                      imagePath: "assets/images/pinterestImage.svg",
                      link: "https://example.com",
                      onTap: () {
                        // Handle onTap action
                      },
                    ),
                    customSvgImage(
                      imagePath: "assets/images/linkedinImage.svg",
                      link: "https://example.com",
                      onTap: () {
                        // Handle onTap action
                      },
                    ),
                    customSvgImage(
                      imagePath: "assets/images/dribbleImage.svg",
                      link: "https://example.com",
                      onTap: () {
                        // Handle onTap action
                      },
                    ),
                    customSvgImage(
                      imagePath: "assets/images/snapchatImage.svg",
                      link: "https://example.com",
                      onTap: () {
                        // Handle onTap action
                      },
                    ),
                    customSvgImage(
                      imagePath: "assets/images/vimeoImage.svg",
                      link: "https://example.com",
                      onTap: () {
                        // Handle onTap action
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: heightSpacer,
              ),
              SettingsHeader(
                imagePath: 'assets/icons/CaseReview.svg',
                text: 'Work Experience',
              ),
              customColoredContainerWithWidget(
                infoWidget: CustomExperienceBulletPoints(
                  titles: widget.workExperienceTitles,
                  from: widget.workExperienceFrom,
                  to: widget.workExperienceTo,
                ),
              ),
              SizedBox(
                height: heightSpacer,
              ),
              SettingsHeader(
                imagePath: 'assets/icons/educationCap.svg',
                text: 'Education',
              ),
              customColoredContainerWithWidget(
                infoWidget: CustomExperienceBulletPoints(
                  titles: widget.educationTitles,
                  from: widget.educationFrom,
                  to: widget.educationTo,
                ),
              ),
              SizedBox(
                height: heightSpacer,
              ),
              SettingsHeader(
                imagePath: 'assets/icons/newLangIcon.svg',
                text: 'Languages',
              ),
              customColoredContainerWithWidget(
                infoWidget: InfoWithBulletList(
                  skillsTexts: widget.languageSkills,
                ),
              ),
              SizedBox(
                height: heightSpacer,
              ),
              SettingsHeader(
                imagePath: 'assets/icons/newSkillIcon.svg',
                text: 'Skills',
              ),
              customColoredContainerWithWidget(
                infoWidget: InfoWithBulletList(
                  skillsTexts: widget.otherSkills,
                ),
              ),
              SizedBox(
                height: heightSpacer,
              ),
              SettingsHeader(
                imagePath: 'assets/icons/interviewAbility.svg',
                text: 'Interview ability',
              ),
              customColoredContainerWithWidget(
                infoWidget: InfoWithBulletList(
                  skillsTexts: widget.interviewAvailability,
                ),
              ),
              SizedBox(
                height: heightSpacer,
              ),
              SettingsHeader(
                imagePath: 'assets/images/map_new.svg',
                text: 'Ability to Relocate',
              ),
              customColoredContainer(
                text: widget.relocationAbility,
              ),
              SizedBox(
                height: heightSpacer,
              ),
              SettingsHeader(
                imagePath: 'assets/images/map_new.svg',
                text: 'Availability for start date',
              ),
              customColoredContainer(
                text: widget.startDateAvailability,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 0.02.h,
        ),
        Row(
          
          children: [
            Expanded(
              child: CustomIconButton(
                textColor: MyThemeData.colorWhite,
                buttonColor: MyThemeData.delete,
                buttonText: 'Reject',
                imagePath: 'assets/icons/whiteCloseCircle.svg',
                onPressed: widget.onDeclinePressed ?? () {},
              ),
            ),
            SizedBox(width: 0.02.w),
            Expanded(
              child: CustomIconButton(
                buttonColor: MyThemeData.unBlock,
                textColor: MyThemeData.colorWhite,
                buttonText: 'Accept',
                imagePath: 'assets/icons/acceptIcon.svg',
                onPressed: widget.onAcceptPressed ?? () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget customColoredContainerWithWidget({
    required Widget infoWidget,
    bool isPortrait = true,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isPortrait ? 0.01.h : 0.015.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: themeController.currentTheme == MyThemeData.lightTheme
              ? const Color(0xFFF6F6F6)
              : const Color(0xFF545454),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(isPortrait ? 0.01.h : 0.015.h),
        child: infoWidget,
      ),
    );
  }

  Widget customSvgImage({
    required String imagePath,
    String? link,
    VoidCallback? onTap,
  }) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    if (link == null) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isPortrait ? 0.01.h : 0.015.h),
      child: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          imagePath,
          height: isPortrait ? 0.035.h : 0.05.h,
          width: isPortrait ? 0.035.h : 0.05.h,
        ),
      ),
    );
  }

  Widget customColoredContainer({
    required String text,
  }) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final bool containsPdfOrDocx =
        text.contains('.pdf') || text.contains('.docx');

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isPortrait ? 0.01.h : 0.015.h),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: themeController.currentTheme == MyThemeData.lightTheme
                ? const Color(0xFFF6F6F6)
                : const Color(0xFF545454),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(isPortrait ? 0.01.h : 0.015.h),
          child: Row(
            children: [
              text.contains('.pdf') == true
                  ? Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/pdfImage.svg',
                          height: !isPortrait ? 0.035.h : 0.025.h,
                        ),
                        SizedBox(
                          width: 0.02.w,
                        )
                      ],
                    )
                  : text.contains('.docx') == true
                      ? Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/docxImage.svg',
                              height: !isPortrait ? 0.035.h : 0.025.h,
                            ),
                            SizedBox(
                              width: 0.02.w,
                            )
                          ],
                        )
                      : SizedBox.shrink(),
              Expanded(
                child: Text(
                  text,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: FontConstants.fontSize018.h,
                    fontWeight: FontWeight.w400,
                    height: 1.8,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ),
              containsPdfOrDocx
                  ? SvgPicture.asset('assets/icons/downloadIcon.svg', height: !isPortrait ? 0.035.h : 0.025.h,)
                  : SizedBox.shrink(),
            ],
          )),
    );
  }
}
