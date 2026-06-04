import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_button.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';

import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CustomCandidateDetailsContainerMobile extends StatefulWidget {
  final String positionTitle;
  final String openFromDate;
  final String toDate;
  final String numberOfApplicants;
  final String location;
  final String jobType;
  final String workplaceType;
  final String salary;
  final VoidCallback? onEditPressed;
  final VoidCallback? onEndJobPressed;

  const CustomCandidateDetailsContainerMobile({
    Key? key,
    required this.positionTitle,
    required this.openFromDate,
    required this.toDate,
    required this.numberOfApplicants,
    required this.location,
    required this.jobType,
    required this.workplaceType,
    required this.salary,
    this.onEditPressed,
    this.onEndJobPressed,
  }) : super(key: key);

  @override
  State<CustomCandidateDetailsContainerMobile> createState() =>
      _CustomCandidateDetailsContainerMobileState();
}

class _CustomCandidateDetailsContainerMobileState
    extends State<CustomCandidateDetailsContainerMobile> {
  bool isExpand = false;
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double heightSpacer = 0.025.h;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(0.02.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpand = !isExpand;
              });
            },
            child: Row(
              children: [
                Text(
                  widget.positionTitle,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: FontConstants.fontSize026.h,
                    fontWeight: FontWeight.w600,
                     letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                Spacer(),
                SvgPicture.asset(
                    isExpand == true
                        ? 'assets/icons/taskOpened.svg'
                        : 'assets/icons/taskClosed.svg',
                    height: isPortrait ? 0.012.h : 0.015.h,
                    color: Theme.of(context).colorScheme.scrim),
              ],
            ),
          ),
          SizedBox(height: 0.02.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '(${widget.numberOfApplicants} ${"Applicants".tr})',
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: FontConstants.fontSize020.h,
                  fontWeight: FontWeight.w600,
                   letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                  color: MyThemeData.blue,
                ),
              ),
            ],
          ),
          if (isExpand == true)
            Column(
              children: [
                SizedBox(height: 0.02.h),
                Row(
                  children: [
                    Expanded(
                        child: _buildDetailWidget(
                            'Open From', widget.openFromDate)),
                    Expanded(child: _buildDetailWidget('To', widget.toDate)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.01.h),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: _buildDetailWidget('Location', widget.location)),
                    Expanded(
                        child: _buildDetailWidget('Job Type', widget.jobType)),
                  ],
                ),
                SizedBox(
                  height: heightSpacer,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: _buildDetailWidget(
                            'Workplace Type', widget.workplaceType)),
                    Expanded(
                        child: _buildDetailWidget('Salary', widget.salary)),
                  ],
                ),
              ],
            ),
          SizedBox(
            height: heightSpacer,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MainCustomButton(
                  buttonText: 'Edit',
                  onPressed: widget.onEditPressed ?? () {},
                ),
              ),
              SizedBox(width: 0.02.w),
              Expanded(
                child: MainCustomButton(
                  buttonColor: MyThemeData.delete,
                  buttonText: 'End This Job',
                  onPressed: widget.onEndJobPressed ?? () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailWidget(String title, String value) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isDateValue = _isDateValue(value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.tr,
          style: AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: FontConstants.fontSize022.h,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.scrim,
          ),
        ),
        SizedBox(
          height: 0.01.h,
        ),
        Container(
          // color: Colors.amber,

          child: Text(
            Get.locale.toString().contains('en')
                ? value
                : isDateValue
                    ? convertToArabicDateSpaceVersion(value)
                    : convertNumberToArabic(value.tr),
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: FontConstants.fontSize020.h,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ),
      ],
    );
  }
}

// Function to check if the entered value is in the date format
bool _isDateValue(String value) {
  try {
    // Attempt to parse the value as a date
    DateFormat('dd MMM yyyy').parse(value);
    return true; // If successful, return true
  } catch (e) {
    return false; // If unsuccessful, return false
  }
}
