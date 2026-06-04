import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';

import 'package:demo_app/core/theme/screen_size.dart';

class CustomCandidateStatisticsContainerMobile extends StatefulWidget {
  final String genderMales;
  final String genderFemales;
  final String ageMin;
  final String ageAvg;
  final String ageMax;
  final String experienceMin;
  final String experienceAvg;
  final String experienceMax;
  final String coverLettersTotal;
  final String sharedPortfoliosTotal;

  const CustomCandidateStatisticsContainerMobile({
    Key? key,
    required this.genderMales,
    required this.genderFemales,
    required this.ageMin,
    required this.ageAvg,
    required this.ageMax,
    required this.experienceMin,
    required this.experienceAvg,
    required this.experienceMax,
    required this.coverLettersTotal,
    required this.sharedPortfoliosTotal,
  }) : super(key: key);

  @override
  State<CustomCandidateStatisticsContainerMobile> createState() =>
      _CustomCandidateStatisticsContainerMobileState();
}

class _CustomCandidateStatisticsContainerMobileState
    extends State<CustomCandidateStatisticsContainerMobile> {
  bool isExpand = false;
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double heightSpacer = 0.02.h;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(0.015.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpand = !isExpand;
              });
            },
            child: Row(
              children: [
                Text(
                  "Candidates Statistics".tr,
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
          if (isExpand == true) SizedBox(height: 0.02.h),
          if (isExpand == true)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailWidget(
                      'Gender',
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildContainerWidget(
                            subTitle: "Males",
                            value: widget.genderMales,
                          ),
                        ),
                        Expanded(
                          child: _buildContainerWidget(
                            subTitle: "Females",
                            value: widget.genderFemales,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: heightSpacer,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailWidget(
                      'Age',
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildContainerWidget(
                            subTitle: "Mini",
                            value: widget.ageMin,
                          ),
                        ),
                        Expanded(
                          child: _buildContainerWidget(
                            subTitle: "Avg",
                            value: widget.ageAvg,
                          ),
                        ),
                        Expanded(
                          child: _buildContainerWidget(
                            subTitle: "Max",
                            value: widget.ageMax,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: heightSpacer,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailWidget(
                      'Years of Experience',
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildContainerWidget(
                            subTitle: "Min",
                            value: widget.experienceMin,
                          ),
                        ),
                        Expanded(
                          child: _buildContainerWidget(
                            subTitle: "Avg",
                            value: widget.experienceAvg,
                          ),
                        ),
                        Expanded(
                          child: _buildContainerWidget(
                            subTitle: "Max",
                            value: widget.experienceMax,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: heightSpacer,
                ),
                _buildDetailWidget(
                  'Submitted Cover Letters',
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildContainerWidget(
                        subTitle: "Total",
                        value: widget.coverLettersTotal,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: heightSpacer,
                ),
                _buildDetailWidget(
                  'Shared Portfolios',
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildContainerWidget(
                        subTitle: "Total",
                        value: widget.sharedPortfoliosTotal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDetailWidget(String title) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

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
      ],
    );
  }

  Widget _buildContainerWidget({
    required String subTitle,
    required String value,
  }) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Container(
      padding: EdgeInsets.all(isPortrait ? 0.01.h : 0.015.h),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Row(
        children: [
          Text(
            subTitle.tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: FontConstants.fontSize020.h,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
          SizedBox(
            width: 0.03.w,
          ),
          Text(
            Get.locale.toString().contains('en')
                ? value
                : convertNumberToArabic(value),
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: FontConstants.fontSize020.h,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ],
      ),
    );
  }
}
