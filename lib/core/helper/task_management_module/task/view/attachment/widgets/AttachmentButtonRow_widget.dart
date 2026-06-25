import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/task_management_module/core/components/custom_black_button.dart';
import 'package:demo_app/core/helper/task_management_module/core/constant/app_strings.dart';
import 'package:demo_app/core/helper/task_management_module/core/constant/image_paths.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/theme/app_colors.dart';

class AttachmentButtonRow extends StatelessWidget {
  final VoidCallback onAddItem;
  final VoidCallback onDeleteAll;

  const AttachmentButtonRow({
    super.key,
    required this.onAddItem,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomBlackButton(
          buttonText: AppStrings.attachments.tr,
          onPressed: onAddItem,
        ),
        const Spacer(),
        GestureDetector(
          onTap: onDeleteAll,
          child: SvgPicture.asset(
            ImagePaths.getImagePath(context, 'deleteIcon'),
            height: 0.025.h,
            color: AppColors.red,
          ),
        ),
      ],
    );
  }
}
