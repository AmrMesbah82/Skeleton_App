import 'package:flutter/material.dart';
import 'package:demo_app/components/employees_components/employees_components_subwidgets.dart/employee_content.dart';
import 'package:demo_app/core/theme/font_manager.dart';

import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/job_posts/review_applications/review_applications_mobile/candidates_applications_screen_mobile.dart';
import 'package:demo_app/nav_bar_package.dart/functions.dart';

class CustomJobPostContainer extends StatelessWidget {
  final String jobTitle;
  final String jobStatus;
  final String openFromDate;
  final String openToDate;
  final String postedBy;
  final String numOfApplicants;

  const CustomJobPostContainer({
    Key? key,
    required this.jobTitle,
    required this.jobStatus,
    required this.openFromDate,
    required this.openToDate,
    required this.postedBy,
    required this.numOfApplicants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double contentWidth = 0.41.w;
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: CandidatesApplicationsScreenMobile(),
          withNavBar: true,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.02.h, horizontal: 0.025.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    jobTitle,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize020.h,
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 0.02.w),
                  Text(
                    jobStatus,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize018.h,
                      color: jobStatus == "Open"
                          ? MyThemeData.unBlock
                          : jobStatus == "Closed"
                              ? MyThemeData.delete
                              : Theme.of(context).colorScheme.inverseSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0.015.h,
                ),
                child: Row(
                  children: [
                    Container(
                      width: contentWidth,
                      child: EmployeeContent(
                        title: "Open From",
                        value: openFromDate,
                      ),
                    ),
                    SizedBox(width: 0.02.w),
                    Container(
                      width: contentWidth,
                      child: EmployeeContent(
                        title: "To",
                        value: openToDate,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 0.015.h,
                ),
                child: EmployeeContent(
                  title: "No. Of Applicants",
                  value: numOfApplicants,
                ),
              ),
              EmployeeContent(
                title: "Posted By",
                value: postedBy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
