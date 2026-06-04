import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_button.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CustomCandidateDetailsContainer extends StatefulWidget {
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

  const CustomCandidateDetailsContainer({
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
  State<CustomCandidateDetailsContainer> createState() =>
      _CustomCandidateDetailsContainerState();
}

class _CustomCandidateDetailsContainerState
    extends State<CustomCandidateDetailsContainer> {
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(0.02.h),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.positionTitle,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isPortrait
                          ? FontConstants.fontSize026.h
                          : FontConstants.fontSize033.h,
                      fontWeight: FontWeight.w600,
                       letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                  SizedBox(height: 0.02.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailWidget('Open From', widget.openFromDate),
                      SizedBox(width: Get.locale.toString().contains('en') ? 0 : 0.02.w,),
                      _buildDetailWidget('To', widget.toDate),
                       SizedBox(width: Get.locale.toString().contains('en') ? 0 : 0.02.w,),
                      _buildDetailWidget(
                          'No. of Applicants', widget.numberOfApplicants),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: isPortrait ? 0.18.w : 0.15.w,
                    child: MainCustomButton(
                      buttonText: 'Edit',
                      onPressed: widget.onEditPressed ?? () {},
                    ),
                  ),
                  SizedBox(height: 0.015.h),
                  Container(
                    width: isPortrait ? 0.18.w : 0.15.w,
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.02.h),
            child: Divider(
              thickness: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailWidget('Location', widget.location),
              _buildDetailWidget('Job Type', widget.jobType),
              _buildDetailWidget('Workplace Type', widget.workplaceType),
              _buildDetailWidget('Salary', widget.salary),
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
            fontSize: isPortrait
                ? FontConstants.fontSize018.h
                : FontConstants.fontSize028.h,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.scrim,
          ),
        ),
        SizedBox(
          height: 0.02.h,
        ),
        Container(
          // color: Colors.amber,
          width: isPortrait ? 0.17.w : 0.2.w,
          child: Text(
             Get.locale.toString().contains('en')
              ? value
              : isDateValue  
                  ? convertToArabicDateSpaceVersion(value)
                  : convertNumberToArabic(value.tr), 
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: isPortrait
                  ? FontConstants.fontSize018.h
                  : FontConstants.fontSize028.h,
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