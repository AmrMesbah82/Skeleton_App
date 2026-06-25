/// Date Created: 17/2/2025
/// by: Islam Diab
/// objective: Create a search field widget.
library;

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:demo_app/core/helper/task_management_module/core/components/custom_search.dart';
import 'package:demo_app/core/helper/task_management_module/core/components/selection_user.dart';
import 'package:demo_app/core/theme/app_font_size.dart';import 'package:demo_app/core/theme/app_colors.dart';

class SearchFextField extends StatelessWidget {
  final bool orientation;
  final Function(String)? onChanged;
  const SearchFextField({super.key, required this.orientation, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CustomSearchFiled2(
        onBoardDetails: true,
        secondActionIcon: 'assets/icons/g4581.svg',
        secondActionIconColor: AppColors.colorLightGrey,
        fillColor: themeController.currentTheme == AppColors.lightTheme
            ? AppColors.colorWhite
            : Theme.of(context).colorScheme.inversePrimary,
        hint: 'Search'.tr,
        onChanged: onChanged,
        hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
            fontSize: orientation
                ? FontConstants.fontSize018.h
                : FontConstants.fontSize014.w,
            fontWeight: FontWeight.w400,
            height: orientation ? 1.4 : null,
            color: Theme.of(context).colorScheme.scrim),
        keyBoardType: TextInputType.text);
  }
}
