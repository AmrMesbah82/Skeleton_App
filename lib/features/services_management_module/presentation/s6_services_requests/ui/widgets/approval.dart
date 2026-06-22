import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_ui_helpers.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';

import 'package:demo_app/features/services_management_module/presentation/s6_services_requests/ui/widgets/approvals.dart';



Widget buildApprovalCycle(BuildContext context, List<EmployeeEntityModell> innerApprovalList  ,String ? imagePerson) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final approvalList = innerApprovalList ?? [];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(approvalList.length, (index) {
      final item = approvalList[index];
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index != 0)
                Padding(
                  padding: EdgeInsets.only(left: 25.sp, right: 20.sp,bottom: 0.sp),
                  child: CustomPaint(
                    size: Size(0, 60),
                    painter: CurvedArrowPainter(
                      color: AppColors.text,
                      isArabic: isArabic,
                    ),
                  ),
                )
              else
                SizedBox(width: 2.sp), // Reserve equal width to align with arrow size
              Padding(
                padding: EdgeInsets.only(top: 14.sp),
                child:
                ClipOval(
                  child: SvgPicture.asset(
                    imagePerson!,
                    semanticsLabel: 'Dart Logo',
                    fit: BoxFit.scaleDown,
                    width:25.sp ,
                    height: 25.sp,
                  ),
                ),

              ),

              SizedBox(width: 8.sp),
              Padding(
                padding: EdgeInsets.only(top: 12.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FormatHelper.capitalize(isArabic
                          ? "${item.firstNameInArabic ?? ''} ${item.lastNameInArabic ?? ''}"
                          : "${item.firstName ?? ''} ${item.lastName ?? ''}"),
                      style: AppTextStyles.font12BlackMediumCairo.copyWith(
                        color: Theme.of(context).brightness == Brightness.light ? AppColors.blackButton : AppColors.white
                      ),
                    ),
                    Text(
                      FormatHelper.capitalize(isArabic ? item.titleInArabic ?? '' : item.title ?? ''),
                      style: AppTextStyles.font10BlackCairoRegular.copyWith(
                          color: Theme.of(context).brightness == Brightness.light ? AppColors.secondaryText : AppColors.grey
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }),
  );
}

Widget approvalCycleViewTablet(List<EmployeeEntityModell> innerApprovalList, BuildContext context) {
  final approvalList = innerApprovalList;
  var themeMode = Theme.of(context).brightness == Brightness.light;
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';

  final screenWidth = MediaQuery.of(context).size.width;

  // Each item needs: avatar(38) + spacing(6) + text(~150) + arrow(~45) = ~240 min width
  const double minItemWidth = 220.0;
  final int itemsPerRow = (screenWidth / minItemWidth).floor().clamp(1, approvalList.length);

  final rows = <List<EmployeeEntityModell>>[];
  for (var i = 0; i < approvalList.length; i += itemsPerRow) {
    rows.add(approvalList.sublist(i, (i + itemsPerRow).clamp(0, approvalList.length)));
  }

  return SizedBox(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(rows.length, (rowIndex) {
        final rowItems = rows[rowIndex];

        return Padding(
          padding: EdgeInsets.only(top: rowIndex == 0 ? 0.h : 16.h),
          child: Row(
            mainAxisSize: MainAxisSize.min, // ✅ only take needed width
            children: List.generate(rowItems.length, (i) {
              final approver = rowItems[i];
              final indexInOriginalList = (rowIndex * itemsPerRow) + i;

              final fullName = isArabic
                  ? "${approver.firstNameInArabic ?? ''} ${approver.lastNameInArabic ?? ''}"
                  : "${approver.firstName ?? ''} ${approver.lastName ?? ''}";

              final title = isArabic
                  ? (approver.titleInArabic ?? '')
                  : (approver.title ?? '');

              return Row(
                mainAxisSize: MainAxisSize.min, // ✅ only take needed width
                children: [
                  ClipOval(
                    child: SvgPicture.asset(
                      approver.gender == "male" ? "assets/male.svg" : "assets/female.svg",
                      fit: BoxFit.scaleDown,
                      semanticsLabel: 'User Icon',
                      width: 38.sp,
                      height: 38.sp,
                    ),
                  ),
                  SizedBox(width: 6.sp),
                  // ✅ ConstrainedBox instead of Flexible/Expanded
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 150.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          FormatHelper.capitalize(fullName),
                          style: AppTextStyles.font13SecondaryBlackCairo.copyWith(
                            color: themeMode ? AppColors.blackButton : AppColors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5.sp),
                        Text(
                          FormatHelper.capitalize(title),
                          style: AppTextStyles.font10SecondaryBlackCairoRegular.copyWith(
                            color: themeMode ? AppColors.secondaryText : AppColors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Arrow between items only
                  if (i != rowItems.length - 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: Transform.rotate(
                        angle: isArabic ? pi : 0,
                        child: SvgPicture.asset(
                          "assets/Arrow.svg",
                          width: 25.sp,
                          fit: BoxFit.scaleDown,
                          color: themeMode
                              ? AppColors.blackButton
                              : AppColors.whiteShadow,
                          semanticsLabel: 'Arrow Icon',
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        );
      }),
    ),
  );
}
