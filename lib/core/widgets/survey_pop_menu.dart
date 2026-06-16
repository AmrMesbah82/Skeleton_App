
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/theme/app_font_size.dart';


class SurveyPopMenu {
  String? selectedOption;
  bool isSortSelected = false;

  Future<String?> showSortMenu(BuildContext context, Offset iconPosition,
      String status, Function() onTap,
      {int? selectedIndex}) async {
    List<String> sortOptions = _getOptionsForStatus(status);

    final isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final double menuOffsetX = iconPosition.dx - (isTablet ? -9.0 : -11);
    final double menuOffsetY = iconPosition.dy - (-7.0);

    final RelativeRect position = RelativeRect.fromLTRB(
      menuOffsetX,
      menuOffsetY,
      overlay.size.width - menuOffsetX,
      overlay.size.height,
    );

    selectedOption = await showMenu(
      context: context,
      position: position,
      color: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      items: sortOptions.map((option) {
        final orientation = MediaQuery.of(context).orientation;
        return PopupMenuItem<String>(
          height: isTablet ? 0.02.h : 0.04.h,
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 0.01.w : 0.01.w),
          value: option,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                option.tr,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isTablet
                      ? (isPortrait
                          ? FontConstants.fontSize014.h
                          : FontConstants.fontSize015.w)
                      : FontConstants.fontSize016.h,
                  height: isPortrait
                      ? isTablet
                          ? 2
                          : 1.6
                      : 1.8,
                  color: option.tr.contains('Delete'.tr)
                      ? AppColors.red
                      : Theme.of(context).colorScheme.scrim,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );

    return selectedOption;
  }

  List<String> _getOptionsForStatus(String status) {
    switch (status) {
      case "dup":
        return ['Duplicate', 'Delete'];
      case "Options":
        return [
          'General',
          'Number',
          'Currency',
          'Date',
          'Time',
          'Percentage',
          'Fraction',
          'Text'
        ];
      case 'column':
        return ['Rename', 'Delete'];
      case 'form':
        return ['Duplicate', 'Edit', 'Convert To PDF', 'Delete Form'];
      case 'dupTable':
        return ['Duplicate', 'Edit', 'Delete'];
      case "database":
        return ['Duplicate', 'Edit', 'Delete'];
      case 'sort':
        return ['Title', 'Date'];
      case 'sortData':
        return ['Name', 'Date', 'No. Of Columns', 'No. Of Rows'];
      default:
        return [];
    }
  }
}
