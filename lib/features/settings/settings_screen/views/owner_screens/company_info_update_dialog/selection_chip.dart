import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

/// [SelectionChip] is a selected option chip builder.
/// It is used to build the selected option chip.
class SelectionChip<T> extends StatelessWidget {
  final ChipConfig chipConfig;
  final Function(ValueItem<T>) onItemDelete;
  final ValueItem<T> item;

  const SelectionChip({
    Key? key,
    required this.chipConfig,
    required this.item,
    required this.onItemDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.005.w),
      child: Chip(
        padding: chipConfig.padding,
        label: Text(
          item.label,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(chipConfig.radius),
            side: BorderSide(color: Colors.transparent)),
        deleteIcon: Padding(
          padding: EdgeInsets.only(
              bottom:isTablet? (isPortrait? 0.002.h : 0.003.h) : 0.002.h,
              left: Get.locale.toString().contains('en') ? (isTablet? (0.007.w) : 0.02.w ): 0,
              right: Get.locale.toString().contains('ar') ? 0.08.w : 0,
              ),
          child: chipConfig.deleteIcon,
        ),
        deleteIconColor: AppColors.textButton,
        labelPadding: chipConfig.labelPadding,
        backgroundColor: chipConfig.backgroundColor ?? AppColors.lightPrimary,
        labelStyle: chipConfig.labelStyle ??
            TextStyle(
                color: AppColors.textButton,
                fontSize: isTablet
                    ? (isPortrait
                        ? FontConstants.fontSize016.h
                        : FontConstants.fontSize022.h)
                    : FontConstants.fontSize016.h),
        onDeleted: () => onItemDelete(item),
      ),
    );
  }
}
