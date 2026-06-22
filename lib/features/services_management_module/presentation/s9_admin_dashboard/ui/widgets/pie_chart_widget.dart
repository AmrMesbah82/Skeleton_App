import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/info_text.dart';

class PieChartWithLabels extends StatelessWidget {
  final String title;
  final String total;
  final String headerImage;
  final List<(String, Color, double)> data;
  final List<String> numberList;

  const PieChartWithLabels({
    required this.title,
    required this.total,
    required this.headerImage,
    required this.data,
    required this.numberList,
  });

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    return Container(
      width:
      isMobile
          ? 345.sp
          : isTabletLandscape(context)
          ? MediaQuery.sizeOf(context).width * .438
          : 320.sp,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.r),
        color:
        Theme.of(context).brightness == Brightness.light
            ? AppColors.white
            : AppColors.chatBackground,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 15.sp),
        child: Column(
          children: [
            // Header section (fixed)
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 26.sp,
                          height: 26.sp,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              headerImage,
                              width: 13.sp,
                              color: AppColors.textButton,
                              height: 13.sp,
                              fit: BoxFit.fill,
                              semanticsLabel: 'Dart Logo',
                            ),
                          ),
                        ),
                        SizedBox(width: 7.w),
                        Text(
                          title,
                          style: AppTextStyles.font14BlackCairoRegular.copyWith(
                            color:
                            Theme.of(context).brightness == Brightness.light
                                ? AppColors.blackButton
                                : AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.sp),
                    // Content section with fixed height
                    SizedBox(
                      height: 180.sp, // Fixed height for the entire content area
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left side - Scrollable department list
                          SizedBox(
                            height: 200.sp, // Match parent height
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(data.length, (index) {
                                  final (label, color, _) = data[index];
                                  final number = numberList[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 14.sp,
                                          height: 14.sp,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color,
                                          ),
                                        ),
                                        SizedBox(width: 6.sp),
                                        SizedBox(
                                          width: 120.sp,
                                          child: Text(
                                            label,
                                            style: AppTextStyles.font10SecondaryBlackCairoRegular.copyWith(
                                              color:
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                                  ? AppColors.blackButton
                                                  : AppColors.white,
                                            ),
                                          ),
                                        ),

                                        Text(
                                          number,
                                          style: AppTextStyles.font12BlackMediumCairo.copyWith(
                                            color:
                                            Theme.of(context).brightness ==
                                                Brightness.light
                                                ? AppColors.header
                                                : AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 30.sp),

                // Right side - Fixed pie chart
                Expanded(
                  flex: 2,
                  child: Center(
                    child: SizedBox(
                      width: 145.sp,
                      height: 120.sp,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 55.r,
                              sections:
                              data.map((e) {
                                return PieChartSectionData(
                                  value: e.$3,
                                  color: e.$2,
                                  radius: 24.r,
                                  title: "",
                                );
                              }).toList(),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                total,
                                style: AppTextStyles.font16BlackSemiBoldCairo.copyWith(
                                  color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                      ? AppColors.blackButton
                                      : AppColors.white,
                                ),
                              ),
                              Text(
                                S.of(context).total,
                                style: AppTextStyles.font12BlackCairoRegular.copyWith(
                                  color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                      ? AppColors.blackButton
                                      : AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // // Add some bottom padding
            // SizedBox(height: 15.sp),
          ],
        ),
      ),
    );
  }
}
