import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CustomCandidateStatisticsContainer extends StatefulWidget {
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

  const CustomCandidateStatisticsContainer({
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
  State<CustomCandidateStatisticsContainer> createState() =>
      _CustomCandidateStatisticsContainerState();
}

class _CustomCandidateStatisticsContainerState
    extends State<CustomCandidateStatisticsContainer> {
  bool isExpand = true;
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
                    fontSize: isPortrait
                        ? FontConstants.fontSize026.h
                        : FontConstants.fontSize033.h,
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
          if (isExpand == true) SizedBox(height: 0.04.h),
          if (isExpand == true)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailWidget(
                            'Gender',
                          ),
                          Row(
                            children: [
                              _buildContainerWidget(
                                subTitle: "Males",
                                value: widget.genderMales,
                              ),
                              _buildContainerWidget(
                                subTitle: "Females",
                                value: widget.genderFemales,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 0.02.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailWidget(
                            'Age',
                          ),
                          Row(
                            children: [
                              _buildContainerWidget(
                                subTitle: "Minim",
                                value: widget.ageMin,
                              ),
                              _buildContainerWidget(
                                subTitle: "Avg",
                                value: widget.ageAvg,
                              ),
                              _buildContainerWidget(
                                subTitle: "Max",
                                value: widget.ageMax,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 0.02.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailWidget(
                            'Years of Experience',
                          ),
                          Row(
                            children: [
                              _buildContainerWidget(
                                subTitle: "Min",
                                value: widget.experienceMin,
                              ),
                              _buildContainerWidget(
                                subTitle: "Avg",
                                value: widget.experienceAvg,
                              ),
                              _buildContainerWidget(
                                subTitle: "Max",
                                value: widget.experienceMax,
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (!isPortrait)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildDetailWidget(
                              'Submitted Cover Letters',
                            ),
                            _buildContainerWidget(
                              subTitle: "Total",
                              value: widget.coverLettersTotal,
                            ),
                          ],
                        ),
                      if (!isPortrait)
                        SizedBox(
                          width: 0.02.w,
                        ),
                      if (!isPortrait)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildDetailWidget(
                              'Shared Portfolios',
                            ),
                            _buildContainerWidget(
                              subTitle: "Total",
                              value: widget.sharedPortfoliosTotal,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                if (isPortrait)
                  SizedBox(
                    height: 0.02.h,
                  ),
                if (isPortrait)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildDetailWidget(
                              'Submitted Cover Letters',
                            ),
                            _buildContainerWidget(
                              subTitle: "Total",
                              value: widget.coverLettersTotal,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 0.04.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildDetailWidget(
                              'Shared Portfolios',
                            ),
                            _buildContainerWidget(
                              subTitle: "Total",
                              value: widget.sharedPortfoliosTotal,
                            ),
                          ],
                        ),
                      ],
                    ),
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
      ],
    );
  }

  Widget _buildContainerWidget({
    String? subTitle,
    required String value,
  }) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(isPortrait ? 0.01.h : 0.015.h),
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Column(
            children: [
              if (subTitle != null) ...[
                Text(
                  subTitle.tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: isPortrait
                        ? FontConstants.fontSize016.h
                        : FontConstants.fontSize026.h,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                SizedBox(
                  height: 0.02.h,
                ),
              ],
              Text(
                Get.locale.toString().contains('en')
                    ? value
                    : convertNumberToArabic(value),
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isPortrait
                      ? FontConstants.fontSize016.h
                      : FontConstants.fontSize026.h,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
