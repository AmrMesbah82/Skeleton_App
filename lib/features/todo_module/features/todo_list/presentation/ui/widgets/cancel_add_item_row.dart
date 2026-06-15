import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/custom_icon_button.dart';
import 'package:demo_app/features/todo_module/core/constants/app_constanst.dart';
import 'package:demo_app/features/todo_module/core/constants/enum.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/todo_model.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';

import '../../../../../core/constants/haptic_controller.dart';

class CancelAndAddItemsRowOfButtons extends StatelessWidget {
  const CancelAndAddItemsRowOfButtons({
    super.key,
    required this.controller,
    required this.model,
  });

  final TodoController controller;
  final TodoModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomIconButton(
            buttonText: AppConstants.cancel.tr,
            height: 42,
            imagePath: "",
            buttonColor: AppColors.moreLightGrey,
            hasIcon: false,
            onPressed: () {
              Get.find<ToDoHapticController>().triggerHapticFeedback(
                  vibration: VibrateType.heavyImpact,
                  hapticFeedback: HapticFeedback.heavyImpact);
              controller.cancelComment();
            },
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: CustomIconButton(
            width: 150,
            height: 42,
            buttonText: AppConstants.add.tr,
            imagePath: "",
            buttonColor: controller.commentController.text.isNotEmpty
                ? AppColors.primary
                : Colors.grey,
            hasIcon: false,
            onPressed: () {
              Get.find<ToDoHapticController>().triggerHapticFeedback(
                  vibration: VibrateType.heavyImpact,
                  hapticFeedback: HapticFeedback.heavyImpact);
              controller.addComment(controller.commentController.text, model);
            },
          ),
        ),
      ],
    );
  }
}
