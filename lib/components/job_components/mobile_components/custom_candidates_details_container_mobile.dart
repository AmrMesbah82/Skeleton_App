import 'package:flutter/material.dart';
import 'package:demo_app/components/employees_components/employees_components_subwidgets.dart/employee_content.dart';
import 'package:demo_app/components/job_components/mobile_components/circular_indicator_with_text.dart';
import 'package:demo_app/core/theme/font_manager.dart';

import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/job_posts/review_applications/review_applications_mobile/candidate_details_screen_mobile.dart';
import 'package:demo_app/features/skeleton/job_posts/review_applications/review_applications_mobile/candidates_applications_screen_mobile.dart';
import 'package:demo_app/nav_bar_package.dart/functions.dart';

class CustomCandidatesDetailsContainerMobile extends StatelessWidget {
  final String candidateImage;
  final String candidateName;
  final String applyingDateValue;
  final String yearsOfExperienceValue;
  final String contactMailValue;
  final String resumeValue;
  final double matchingValue;

  const CustomCandidatesDetailsContainerMobile({
    Key? key,
    this.candidateImage = "assets/images/profile1.png",
    required this.candidateName,
    required this.applyingDateValue,
    required this.yearsOfExperienceValue,
    required this.contactMailValue,
    required this.resumeValue,
    required this.matchingValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double contentWidth = 0.41.w;
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: CandidatesDetailsScreenMobile(),
          withNavBar: true,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.015.h, horizontal: 0.025.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(candidateImage),
                    radius: 0.02.h,
                  ),
                  SizedBox(
                    width: 0.02.w,
                  ),
                  Text(
                    candidateName,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize020.h,
                        color: Theme.of(context).colorScheme.inverseSurface,
                        height: 2,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  CircularIndicatorWithText(
                    percentage: matchingValue,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 0.015.h,
                ),
                child: EmployeeContent(
                  title: "Applying Date",
                  value: applyingDateValue,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 0.015.h,
                ),
                child: EmployeeContent(
                  title: "Years of Experience",
                  value: yearsOfExperienceValue,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 0.015.h,
                ),
                child: EmployeeContent(
                  title: "Contact Mail",
                  value: contactMailValue,
                ),
              ),
              EmployeeContent(
                title: "Resume",
                value: resumeValue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
