/// Date Created: 17/2/2025
/// by: Islam Diab
/// objective: Create status filter with add button widget.
library;

import 'package:flutter/material.dart';
import 'package:demo_app/core/helper/task_management_module/core/components/custom_upper_filter.dart';
import 'package:demo_app/core/helper/task_management_module/core/components/project_screen/task_status_enum.dart';
import 'package:demo_app/core/helper/task_management_module/core/components/project_screen/widget/add_card_button.dart';
import 'package:demo_app/core/helper/task_management_module/core/constant/screen_size.dart';
import 'package:demo_app/core/helper/task_management_module/task/controller/task_controller.dart';
import 'package:demo_app/core/helper/task_management_module/task/controller/task_details_controller.dart';

class StatusFilterWithAddButton extends StatelessWidget {
  final TaskDetailsController controller;
  final bool orientation;
  final Function(int) selectedIndexState;
  final Function(String) selectedDepartmentState;
  final String board;
  const StatusFilterWithAddButton(
      {super.key,
      required this.controller,
      required this.orientation,
      required this.selectedIndexState,
      required this.selectedDepartmentState,
      required this.board});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.02.h),

      ///  Header filter to the page: To Do, Doing, and Done; by default the todo will be selected and if you clicked on for example doing, it show you the cards for this specific card
      child: Row(
        crossAxisAlignment:
            orientation ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: UpperFilters(
              filterTitles: TaskStatusEnum.values.map((e) => e.name).toList(),
              selectedIndex: controller.selectedIndex,
              selectedIndexState: selectedIndexState,
              selectedDepartmentState: selectedDepartmentState,
            ),
          ),
          //  Spacer(),
          /// Add card
          // AddCardButton(
          //   board: board,
          // )
        ],
      ),
    );
  }
}
