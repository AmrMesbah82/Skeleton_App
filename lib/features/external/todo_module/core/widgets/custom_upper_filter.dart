// Date Created :20/November/2023
// Developer Name : Bassem Mohamed
//App Version : Version 2
// Date of Last Edit :4/March/2024
// Objectives: this is a widget to customize the fikter if the messages

// Last Edit: Ahmed Mahmoud on 9/March/2025
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_text_styles.dart';
import 'package:demo_app/features/external/todo_module/core/constants/enum.dart';
import 'package:demo_app/features/external/todo_module/core/constants/haptic_controller.dart';

// ignore: must_be_immutable
class UpperFilters extends StatefulWidget {
  UpperFilters({
    super.key,
    required this.selectedIndex,
    required this.selectedDepartmentState,
    required this.selectedIndexState,
    required this.filterTitles,
    required this.numberOfFilter,
  });
  List<int> numberOfFilter;
  int selectedIndex;
  ValueChanged<String> selectedDepartmentState;
  ValueChanged<int> selectedIndexState;
  List<String> filterTitles;

  @override
  State<UpperFilters> createState() => _UpperFiltersState();
}

class _UpperFiltersState extends State<UpperFilters> {
  final TextStyle unselectedStyle = AppTextStyles.font12BlackCairo.copyWith(
      fontSize: 16, color: AppColors.inverseBase, fontWeight: FontWeight.w600);

  final TextStyle selectedStyle = AppTextStyles.font12BlackCairo.copyWith(
    color: AppColors.black,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );
  final TextStyle unselectedStyleTablet = AppTextStyles.font12BlackCairo
      .copyWith(
          fontSize: 16,
          color: AppColors.inverseBase,
          fontWeight: FontWeight.w600);

  final TextStyle selectedStyleTablet = AppTextStyles.font12BlackCairo.copyWith(
    color: AppColors.text,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );
  final ToDoHapticController hapticController =
      Get.find<ToDoHapticController>();
  Widget filterItems(String title, int index) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return GestureDetector(
      onTap: () {
        hapticController.triggerHapticFeedback(
            vibration: VibrateType.lightImpact,
            hapticFeedback: HapticFeedback.lightImpact);
        setState(() {
          widget.selectedIndex = index;
          widget.selectedDepartmentState(title);
          widget.selectedIndexState(index);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: isTablet ? 45 : 35,
            width: isTablet ? 45 : 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: widget.selectedIndex == index
                    ? AppColors.primary
                    : Colors.white),
            child: Text(
              widget.numberOfFilter[index].toString(),
              textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false),
              style: widget.selectedIndex == index
                  ? isTablet
                      ? selectedStyleTablet
                      : selectedStyle
                  : isTablet
                      ? unselectedStyleTablet
                      : unselectedStyle,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            title.tr,
            textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false),
            style:
                widget.selectedIndex == index ? selectedStyle : unselectedStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return SizedBox(
      height: isTablet ? 45 : 35,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.filterTitles.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              filterItems(widget.filterTitles[index], index),
              const SizedBox(width: 30),
            ],
          );
        },
      ),
    );
  }
}
