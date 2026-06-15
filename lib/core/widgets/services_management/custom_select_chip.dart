
/// ******************* FILE INFO *******************
/// File Name: custom_select_chip.dart
/// Description: can use this if you need when select item from dropdown see your select under dropdown
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/widgets/services_management/multi_select_widget.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

import '../../theme/app_colors.dart';

class SelectChip extends StatelessWidget {
  final List<String> departments;
  final List<String> selectedDepartments;
  final double width;
  final Color color;
  final String title;
  final bool apper;
  final Function(String) onAdd;
  final Function(String) onRemove;
  final bool singleSelect;
  final String iconAsset;
  final double triggerHeight;
  final double? menuWidth;
  final double? menuItemHeight;

  const SelectChip({
    super.key,
    this.title = '',
    required this.departments,
    required this.width,
    required this.color,
    required this.selectedDepartments,
    required this.onAdd,
    required this.onRemove,
    this.apper = true,
    this.singleSelect = false,
    this.iconAsset = "assets/arrowdown.svg",
    this.triggerHeight = 36.0,
    this.menuWidth,
    this.menuItemHeight,
  });

  @override
  Widget build(BuildContext context) {
    final label = title.isNotEmpty ? title : S.of(context).department;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppMultiSelectDropdownMaster(
          items: departments,
          selectedItems: selectedDepartments,
          singleSelect: singleSelect,
          width: width,
          menuWidth: menuWidth ?? width,
          height: triggerHeight,
          fillColor: color,
          textButton: label,
          hintText: label,
          textStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
            color: AppColors.text.withOpacity(.5)
          ),
          menuItemHeight: menuItemHeight,
          onChanged: (value) {
            final v = value as String;

            if (selectedDepartments.contains(v)) {
              onRemove(v);
            } else {
              if (singleSelect) {
                for (final s in List<String>.from(selectedDepartments)) {
                  onRemove(s);
                }
              }
              onAdd(v);
            }
          },
          validator: (_) => null,
        ),

        SizedBox(height: 8.sp),

        // Fixed chips to prevent Arabic delete text
        apper
            ? Wrap(
          spacing: 8.sp,
          runSpacing: 8.sp,
          alignment: WrapAlignment.start,
          children: selectedDepartments.map((dept) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade200
                    : AppColors.background,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dept,
                    style: AppTextStyles.font12BlackCairoRegular.copyWith(
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.blackButton
                          : AppColors.white,
                    ),
                  ),
                  SizedBox(width: 6.sp),
                  GestureDetector(
                    onTap: () => onRemove(dept),
                    child: CircleAvatar(
                      radius: 7.r,
                      backgroundColor: AppColors.red,
                      child: Icon(
                        Icons.remove,
                        color: AppColors.white,
                        size: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        )
            : const SizedBox.shrink(),
      ],
    );
  }
}
