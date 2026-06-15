import 'package:demo_app/core/widgets/services_management/curved_poiner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:demo_app/features/services_mangment_module/Category/data/entities/modelEmployee.dart';

import 'package:demo_app/core/helper/services_management/format_helper.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

import '../../theme/app_colors.dart';

class ApprovalCycleWidget extends StatelessWidget {
  final List<EmployeeEntityModell> approvalList;
  final bool isTablet;
  final String? currentState;

  const ApprovalCycleWidget({
    Key? key,
    required this.approvalList,
    required this.isTablet,
    this.currentState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isTablet
        ? buildTabletLayout(context)
        : buildMobileLayout(context);
  }

  /// 📱 MOBILE Layout
  Widget buildMobileLayout(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isCanceled = (currentState?.toLowerCase() ?? '') == 'cancel';
    final displayList = isCanceled ? approvalList : _adjustCycleStates(approvalList);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(displayList.length, (index) {
        final employee = displayList[index];
        final state = employee.state?.toLowerCase() ?? 'pending';

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index > 0)
                  Padding(
                    padding: EdgeInsets.only(left: 20.sp, right: 15.sp),
                    child: CustomPaint(
                      size: const Size(0, 80),
                      painter: CurvedArrowPainter(
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.blackButton
                            : AppColors.whiteShadow,
                        isArabic: isArabic,
                      ),
                    ),
                  )
                else
                  SizedBox(width: 2.sp),
                Padding(
                  padding: EdgeInsets.only(top: 14.sp),
                  child: Container(
                    width: 32.sp,
                    height: 32.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: state == 'cancel' ? AppColors.red : _getBorderColor(state),
                        width: 2.w,
                      ),
                    ),
                    child: ClipOval(
                      child: SvgPicture.asset(
                        employee.gender == 'male' ? 'assets/male.svg' : 'assets/female.svg',
                        fit: BoxFit.scaleDown,
                        width: 28.sp,
                        height: 28.sp,
                      ),
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
                        FormatHelper.capitalize(
                          isArabic
                              ? "${employee.firstNameInArabic ?? ''} ${employee.lastNameInArabic ?? ''}"
                              : "${employee.firstName ?? ''} ${employee.lastName ?? ''}",
                        ),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).brightness == Brightness.light
                              ? AppColors.blackButton
                              : AppColors.white,
                        ),
                      ),
                      Text(
                        FormatHelper.capitalize(
                          isArabic ? employee.titleInArabic ?? '' : employee.title ?? '',
                        ),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).brightness == Brightness.light
                              ? AppColors.secondaryText
                              : AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        );
      }),
    );
  }

  /// 💻 TABLET Layout
  Widget buildTabletLayout(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final displayList = _adjustCycleStates(approvalList);
    final itemsPerRow = 3;

    final rows = <List<int>>[];
    for (var i = 0; i < displayList.length; i += itemsPerRow) {
      rows.add(List.generate((i + itemsPerRow).clamp(0, displayList.length) - i, (j) => i + j));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(rows.length, (rowIndex) {
        final rowItems = rows[rowIndex];
        return Padding(
          padding: EdgeInsets.only(top: rowIndex == 0 ? 0.h : 10.h),
          child: Row(
            children: List.generate(rowItems.length, (i) {
              final index = rowItems[i];
              final employee = displayList[index];
              final state = employee.state?.toLowerCase() ?? 'pending';

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getBorderColor(state),
                        width: 2.w,
                      ),
                    ),
                    child: ClipOval(
                      child: SvgPicture.asset(
                        employee.gender == 'male' ? 'assets/male.svg' : 'assets/female.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.sp),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FormatHelper.capitalize(
                          isArabic
                              ? "${employee.firstNameInArabic ?? ''} ${employee.lastNameInArabic ?? ''}"
                              : "${employee.firstName ?? ''} ${employee.lastName ?? ''}",
                        ),
                        style: AppTextStyles.font10BlackCairoRegular.copyWith(
                          color: Theme.of(context).brightness == Brightness.light
                              ? AppColors.blackButton
                              : AppColors.white,
                        ),
                      ),
                      Text(
                        FormatHelper.capitalize(
                          isArabic ? employee.titleInArabic ?? '' : employee.title ?? '',
                        ),
                        style: AppTextStyles.font10BlackCairoRegular.copyWith(
                          color: Theme.of(context).brightness == Brightness.light
                              ? AppColors.secondaryText
                              : AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  if (index != displayList.length - 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Transform.rotate(
                        angle: isArabic ? 3.1416 : 0,
                        child: SvgPicture.asset(
                          "assets/Arrow.svg",
                          width: 25.w,
                          fit: BoxFit.scaleDown,
                          color: _getBorderColor(state),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        );
      }),
    );
  }

  /// 🧠 Status Color
  Color _getBorderColor(String state) {
    switch (state.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'inprogress':
        return Colors.orange;
      default:
        return Colors.grey[300]!;
    }
  }

  /// 🛠 Adjusts states if not canceled
  List<EmployeeEntityModell> _adjustCycleStates(List<EmployeeEntityModell> list) {
    // Your actual adjustment logic here (if needed)
    return list;
  }
}
