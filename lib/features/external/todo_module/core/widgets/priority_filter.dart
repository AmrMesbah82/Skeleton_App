import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_text_styles.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/proiority_model.dart';

/// PriorityFilter Widget
///
/// This widget displays a row of filter options (All, High, Medium, Low) and allows the user to select a priority filter.
/// The selected priority is highlighted, and the value is sent to the parent widget via the `onFilterSelected` callback.
/// The filter options are translated based on the current language using GetX's `.tr` method, displaying in Arabic if the language is set to Arabic.
///
/// Created by Mohammed Yasser, Developer
/// Date: 14 March 2025
class PriorityFilter extends StatefulWidget {
  final Function(TodoPriority?) onFilterSelected;
  const PriorityFilter({super.key, required this.onFilterSelected});

  @override
  _PriorityFilterState createState() => _PriorityFilterState();
}

class _PriorityFilterState extends State<PriorityFilter> {
  TodoPriority? _selectedPriority;

  final List<TodoPriority?> _priorityOptions = [null, TodoPriority.high, TodoPriority.medium, TodoPriority.low];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _priorityOptions.map((priority) {
        bool isSelected = _selectedPriority == priority;
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPriority = priority;
                });
                widget.onFilterSelected(priority);
              },
              child: Container(
                height: 28,
                constraints: const BoxConstraints(minWidth: 50),
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Baseline(
                    baseline: 14,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      _getPriorityText(priority),
                      style: AppTextStyles.font16BlackRegularCairo.copyWith(
                        fontSize: 14,
                        color: isSelected ? Colors.black : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
          ],
        );
      }).toList(),
    );
  }

  String _getPriorityText(TodoPriority? priority) {
    if (priority == null) return "All".tr;
    return priority.toString().split('.').last.tr;
  }


}
