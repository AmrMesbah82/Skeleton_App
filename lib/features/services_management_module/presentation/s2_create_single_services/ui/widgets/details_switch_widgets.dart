/// ******************* FILE INFO *******************
/// File Name: details_switch_widgets.dart
/// Description: All widgets for Details Switch Screen
/// Created by: Amr Mesbah
/// Last Update: 01/12/2025

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:demo_app/core/extension/context_extensions.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_app/core/custom/35-custom_search_widget_custom.dart';
import 'package:demo_app/features/services_management_module/data/helper/services_ui_helpers.dart';
import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';

import 'package:demo_app/core/enumeration/enum.dart' as FormatHelper;
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/core/widgets/services_management/custom_botton.dart';
import 'package:demo_app/core/widgets/services_management/custom_grid_view.dart';
import 'package:demo_app/core/widgets/services_management/custom_select_chip.dart';
import 'package:demo_app/features/services_management_module/presentation/s2_create_single_services/ui/widgets/employee_card_item.dart';


class ValidationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String lottiePath;

  const ValidationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.lottiePath,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: SizedBox(
          width: 411.sp,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                lottiePath,
                width: 70.sp,
                height: 70.sp,
                fit: BoxFit.scaleDown,
                repeat: true,
                animate: true,
              ),
              SizedBox(height: 20.sp),
              Text(
                title,
                style: AppTextStyles.font20BlackCairoMedium.copyWith(
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 18.sp),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String lottiePath;
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final String noText;
  final String yesText;

  const ConfirmationDialog({
    super.key,
    required this.lottiePath,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.noText,
    required this.yesText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: SizedBox(
          width: 411.sp,
          height: 210.sp,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                lottiePath,
                width: 70.sp,
                height: 70.sp,
                fit: BoxFit.scaleDown,
                repeat: true,
                animate: true,
              ),
              SizedBox(height: 20.sp),
              Text(
                title,
                style: AppTextStyles.font20BlackCairoMedium.copyWith(
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 18.sp),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              SizedBox(height: 15.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customButtonAnimation(
                      title: noText,
                      function: () {
                        Navigator.pop(context);
                      },
                      textStyle: AppTextStyles.font15BlackCairoRegular.copyWith(
                        color: AppColors.black,
                      ),
                      width: 120.sp,
                      height: 38.sp,
                      radius: 4.r,
                      color: AppColors.secondaryButton,
                    ),
                    SizedBox(width: 15.sp),
                    customButtonAnimation(
                      title: yesText,
                      function: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      textStyle: AppTextStyles.font15BlackCairoRegular.copyWith(
                        color: AppColors.textButton,
                      ),
                      width: 120.sp,
                      height: 38.sp,
                      radius: 4.r,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ApprovalPerson extends StatelessWidget {
  final EmployeeEntityPro employee;
  final bool isEnglish;

  const ApprovalPerson({
    super.key,
    required this.employee,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: SvgPicture.asset(
                employee.gender == "male" ? 'assets/male.svg' : 'assets/female.svg',
                semanticsLabel: 'Gender Icon',
                fit: BoxFit.cover,
                width: 35.sp,
                height: 35.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              FormatHelper.capitalize(
                '${isEnglish ? employee.firstName ?? '' : employee.firstNameInArabic ?? ''} ${isEnglish ? employee.lastName ?? '' : employee.lastNameInArabic ?? ''}',
              ),
              style: AppTextStyles.font14BlackCairoMedium.copyWith(
                color: AppColors.text,
              ),
            ),
            Text(
              FormatHelper.capitalize(
                isEnglish ? employee.title ?? '' : employee.titleInArabic ?? '',
              ),
              style: AppTextStyles.font12BlackCairoRegular.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LimitAvailabilitySection extends StatelessWidget {
  final bool limitAvailability;
  final bool isArabic;
  final ValueChanged<bool> onToggle;
  final List<String> selectedDepartments;
  final List<String> departments;
  final double width;
  final Function(String) onAdd;
  final Function(String) onRemove;

  const LimitAvailabilitySection({
    super.key,
    required this.limitAvailability,
    required this.isArabic,
    required this.onToggle,
    required this.selectedDepartments,
    required this.departments,
    required this.width,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: isMobile ? null : 200.sp,
                    child: Text(
                      FormatHelper.capitalize(
                        S.of(context).limitServiceAvailability,
                      ),
                      style: AppTextStyles.font14BlackCairoRegular.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  Spacer(),
                  Transform(
                    alignment: Alignment.center,
                    transform: isArabic
                        ? Matrix4.rotationY(3.14159)
                        : Matrix4.identity(),
                    child: FlutterSwitch(
                      activeColor: AppColors.secondaryPrimary,
                      height: 22.sp,
                      width: 38.sp,
                      padding: 3.sp,
                      borderRadius: 20.sp,
                      toggleSize: 22.sp,
                      value: limitAvailability,
                      onToggle: onToggle,
                    ),
                  ),
                ],
              ),
              if (limitAvailability) ...[
                SizedBox(height: 15.sp),
                SelectChip(
                  departments: departments,
                  selectedDepartments: selectedDepartments,
                  width: isMobile
                      ? MediaQuery.sizeOf(context).width
                      : MediaQuery.sizeOf(context).width * .3,
                  triggerHeight: 36.sp,
                  color: AppColors.background,
                  onAdd: onAdd,
                  onRemove: onRemove,
                ),
              ],
            ],
          ),
        ),
        isMobile ? SizedBox() : Expanded(flex: 2, child: Column()),
      ],
    );
  }
}

class RequireApprovalSection extends StatelessWidget {
  final bool requireApproval;
  final bool isArabic;
  final ValueChanged<bool> onToggle;

  const RequireApprovalSection({
    super.key,
    required this.requireApproval,
    required this.isArabic,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    return Row(
      children: [
        SizedBox(
          width: isMobile ? null : 200.sp,
          child: Text(
            FormatHelper.capitalize(
              S.of(context).requiresApprovals,
            ),
            style: AppTextStyles.font14BlackCairoRegular.copyWith(
              color: AppColors.text,
            ),
          ),
        ),
        Spacer(),
        Transform(
          alignment: Alignment.center,
          transform: Directionality.of(context) == TextDirection.rtl
              ? Matrix4.rotationY(3.14159)
              : Matrix4.identity(),
          child: FlutterSwitch(
            activeColor: AppColors.secondaryPrimary,
            height: 22.sp,
            width: 38.sp,
            padding: 3.sp,
            borderRadius: 20.sp,
            toggleSize: 22.sp,
            value: requireApproval,
            onToggle: onToggle,
          ),
        ),
      ],
    );
  }
}

class ApprovalSelectionSection extends StatelessWidget {
  final TextEditingController searchController;
  final List<EmployeeEntityPro> filteredEmployees;
  final List<EmployeeEntityPro> selectedEmployees;
  final bool Function(EmployeeEntityPro) isRegularEmployee;
  final bool Function(EmployeeEntityPro) isSelected;
  final Function(EmployeeEntityPro) onToggleSelection;
  final String Function(EmployeeEntityPro, bool) displayName;
  final bool isEnglish;
  final bool isMobile;
  final ScrollController scrollController;
  final Function(int) onRemoveEmployee;
  final VoidCallback onRemoveEmployeeFromSelection;
  // ✅ FIX: Added onSearchChanged callback instead of accessing _cubit directly
  final ValueChanged<String> onSearchChanged;

  const ApprovalSelectionSection({
    super.key,
    required this.searchController,
    required this.filteredEmployees,
    required this.selectedEmployees,
    required this.isRegularEmployee,
    required this.isSelected,
    required this.onToggleSelection,
    required this.displayName,
    required this.isEnglish,
    required this.isMobile,
    required this.scrollController,
    required this.onRemoveEmployee,
    required this.onRemoveEmployeeFromSelection,
    required this.onSearchChanged, // ✅ NEW required param
  });

  @override
  Widget build(BuildContext context) {
    // filteredEmployees already contains only eligible employees from the cubit,
    // so no need to filter again here — just use it directly.
    final eligibleEmployees = filteredEmployees;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 26.sp),
        Text(
          FormatHelper.capitalize(
            S.of(context).addApprovals,
          ),
          style: AppTextStyles.font14BlackCairoRegular.copyWith(
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 8.sp),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 38.h,
                child: Row(
                  children: [
                    Expanded(
                      child: AppSearchTextField(
                        fillColor: AppColors.background,
                        controller: searchController,
                        // ✅ FIX: use the passed callback, not _cubit
                        onChanged: onSearchChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isMobile
                ? SizedBox()
                : Expanded(flex: 2, child: Column()),
          ],
        ),
        SizedBox(height: 10.sp),
        SizedBox(
          height: 300.sp,
          child: GridView.builder(
            controller: scrollController,
            padding: EdgeInsets.all(0.sp),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: CrossAxisCountHelperResponsive
                  .getCrossAxisCountForDefaultTabletResponsive(context),
              crossAxisSpacing: 10.sp,
              mainAxisSpacing: 10.sp,
              mainAxisExtent: 77.sp,
            ),
            itemCount: eligibleEmployees.length,
            itemBuilder: (context, index) {
              final employee = eligibleEmployees[index];
              return SizedBox(
                child: EmployeeCard(
                  employee: employee,
                  onTap: () => onToggleSelection(employee),
                  isSelected: isSelected(employee),
                  isLightMode: Theme.of(context).brightness == Brightness.light,
                  name: displayName(employee, isEnglish),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.sp),
        Text(
          FormatHelper.capitalize(
            "${S.of(context).approvalCycle}: ",
          ),
          style: AppTextStyles.font14BlackCairoRegular.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        SizedBox(height: 10.sp),
        _buildSelectedEmployees(context),
      ],
    );
  }

  Widget _buildSelectedEmployees(BuildContext context) {
    if (isMobile) {
      return Column(
        children: List.generate(selectedEmployees.length, (index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index != 0)
                Padding(
                  padding: EdgeInsets.only(
                    left: isEnglish ? 30.sp : 10.sp,
                    right: isEnglish ? 10.sp : 30.sp,
                    bottom: 0.sp,
                  ),
                  child: CustomPaint(
                    size: Size(0, 80),
                    painter: CurvedArrowPainter(
                      color: AppColors.text,
                      isArabic: !isEnglish,
                    ),
                  ),
                )
              else
                SizedBox(width: 1.w),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ApprovalPerson(
                      employee: selectedEmployees[index],
                      isEnglish: isEnglish,
                    ),
                    Positioned(
                      right: isEnglish
                          ? index == 0
                          ? 273.sp
                          : 235.sp
                          : index == 0
                          ? 23.sp
                          : 27.sp,
                      bottom: 6,
                      child: GestureDetector(
                        onTap: () => onRemoveEmployee(index),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.red,
                          ),
                          child: Icon(
                            Icons.remove,
                            color: AppColors.white,
                            size: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      );
    }

    return Wrap(
      spacing: 0.sp,
      children: List.generate(
        selectedEmployees.length,
            (index) {
          final employee = selectedEmployees[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index >= 3 ? 0.sp : 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.sp,
                        vertical: 4.sp,
                      ),
                      child: CircleAvatar(
                        radius: 25.r,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: SvgPicture.asset(
                            employee.gender == "male"
                                ? 'assets/male.svg'
                                : 'assets/female.svg',
                            semanticsLabel: 'Gender Icon',
                            fit: BoxFit.cover,
                            width: 40.sp,
                            height: 40.sp,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6.sp,
                      right: isEnglish ? 6.sp : 35.sp,
                      child: Container(
                        width: 16.sp,
                        height: 16.sp,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.remove,
                            size: 12.sp,
                            color: AppColors.white,
                          ),
                          onPressed: onRemoveEmployeeFromSelection,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 6.sp),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FormatHelper.capitalize(
                        isEnglish
                            ? "${employee.firstName ?? ''} ${employee.lastName ?? ''}"
                            : "${employee.firstNameInArabic ?? ''} ${employee.lastNameInArabic ?? ''}",
                      ),
                      style: AppTextStyles.font13SecondaryBlackCairo.copyWith(
                        color: AppColors.text,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.sp),
                    Text(
                      _getDisplayJobTitle(employee, isEnglish),
                      style: AppTextStyles.font10SecondaryBlackCairoRegular.copyWith(
                        color: AppColors.secondaryText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(width: 4.sp),
                if (index < selectedEmployees.length - 1)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.sp,
                    ),
                    child: Transform.rotate(
                      angle: isEnglish ? 0 : 3.1416,
                      child: SvgPicture.asset(
                        "assets/Arrow.svg",
                        color: AppColors.text,
                        fit: BoxFit.scaleDown,
                        semanticsLabel: 'Arrow',
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getDisplayJobTitle(EmployeeEntityPro employee, bool isEnglish) {
    final titleEn = (employee.title ?? '').trim();
    final titleAr = (employee.titleInArabic ?? '').trim();

    String title = isEnglish
        ? (titleEn.isNotEmpty ? FormatHelper.capitalize(titleEn) : titleAr)
        : (titleAr.isNotEmpty ? titleAr : titleEn);

    final abbreviationRegex = RegExp(r'\(([^)]+)\)\s*$');
    final match = abbreviationRegex.firstMatch(title);

    if (match != null) {
      return match.group(1) ?? title;
    }

    return title;
  }
}

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onDismiss;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), onDismiss);

    return WillPopScope(
      onWillPop: () async {
        onDismiss();
        return false;
      },
      child: AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        content: SizedBox(
          width: 411.sp,
          height: 170.sp,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/approved.json',
                width: 70.sp,
                height: 70.sp,
              ),
              SizedBox(height: 25.sp),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.font20BlackCairoMedium.copyWith(
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 18.sp),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.font15BlackCairoRegular.copyWith(
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
