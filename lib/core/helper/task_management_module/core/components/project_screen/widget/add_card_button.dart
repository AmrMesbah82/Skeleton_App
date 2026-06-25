/// Date Created: 17/2/2025
/// by: Islam Diab
/// objective: Create add card button widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/task_management_module/core/components/custom_black_button.dart';
import 'package:demo_app/core/helper/task_management_module/core/components/dialogs/add_card_dialog.dart';
import 'package:demo_app/core/helper/task_management_module/core/components/tasks_components/custom_project_screen_header.dart';
import 'package:demo_app/core/helper/task_management_module/core/constant/enum.dart';
import 'package:demo_app/core/helper/task_management_module/core/constant/screen_size.dart';

class AddCardButton extends StatelessWidget {
  final String board;
  const AddCardButton({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0.w),
      child: CustomBlackButton(
        buttonText: 'Add Card'.tr,
        onPressed: () {
          hapticController.triggerHapticFeedback(
              vibration: VibrateType.lightImpact,
              hapticFeedback: HapticFeedback.lightImpact);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddCardDialog(
                board: board,
              );
            },
          );
        },
      ),
    );
  }
}
