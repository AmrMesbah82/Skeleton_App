import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/todo_module/core/constants/app_constanst.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';

/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       This widget is a dropdown menu for sorting options in the home screen.
///
/// Author:            Ahmed Mahmoud,
/// Date:              10/March/2025
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------

class HomeSortingDropDown extends StatelessWidget {
  const HomeSortingDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final controller = Get.find<TodoController>();
    final textStyle = AppTextStyles.font10BlackCairoMediam
        .copyWith(color: AppColors.text, fontSize: 12);

    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      child: Container(
        width: isPortrait ? 38 : 100,
        height: 38,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: PopupMenuButton<String>(
          key: const ValueKey('sorting_dropdown'),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: 120,
            maxWidth: 120,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          offset: const Offset(0, 38),
          color: Colors.white,
          icon: isPortrait
              ? Center(
                  child: SvgPicture.asset(
                  "assets/icons/sort.svg",
                  height: 24,
                  width: 24,
                  color: AppColors.black,
                  fit: BoxFit.contain,
                ))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/sort.svg",
                      height: 24,
                      width: 24,
                      color: AppColors.black,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 8),
                    Baseline(
                      baseline: 16,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(AppConstants.sort,
                          style: AppTextStyles.font10BlackCairoMediam
                              .copyWith(color: AppColors.text, fontSize: 16)),
                    ),
                  ],
                ),
          onSelected: (value) {
            controller.sortHomePage(value);
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              padding: const EdgeInsets.only(left: 20),
              height: 35,
              value: "endDate",
              child: Text(AppConstants.endDate, style: textStyle),
            ),
            PopupMenuItem<String>(
              padding: const EdgeInsets.only(left: 20),
              height: 35,
              value: "frequency",
              child: Text(AppConstants.frequency, style: textStyle),
            ),
            PopupMenuItem<String>(
              padding: const EdgeInsets.only(left: 20),
              height: 35,
              value: "scheduled",
              child: Text(AppConstants.scheduled, style: textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
