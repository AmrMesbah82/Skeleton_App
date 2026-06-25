import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:get/get.dart'; // ✅ Import Get for context.isPhone

import 'package:demo_app/core/enums/enum.dart' as FormatHelper;
import 'package:demo_app/core/theme/app_text_styles.dart';
import '../../../core/custom_widgets/custom_check_box.dart';
import '../../../core/custom_widgets/svg_custom.dart';
import '../../../core/enums/task_status_enum.dart';
import '../../../core/utilties/images.dart';
import '../../data/models/items_data.dart';
import '../../data/models/task_model_updates_with_field_history.dart';
import '../../domain/services/task_services.dart';
import 'custom_task_card.dart';

class CustomBuildItem extends StatefulWidget {
  CustomBuildItem({
    super.key,
    required this.item,
    required this.task,
    required this.isNotHome,
    required this.updateItemStatus,
  });

  ItemData item;
  TaskModel task;
  bool isNotHome;
  VoidCallback updateItemStatus;

  @override
  State<CustomBuildItem> createState() => _CustomBuildItemState();
}

class _CustomBuildItemState extends State<CustomBuildItem> {
  final TaskFirebaseService _firebaseService = TaskFirebaseService();
  List<ItemData> _items = [];

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    var isMobile = context.isPhone; // ✅ Add mobile detection

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.updateItemStatus,
                child: CustomCheckBox(
                  size: 18.sp,
                  isSelected: widget.item.itemStatus == TaskStatus.done,
                ),
              ),
              SizedBox(width: 5.w),
              Flexible(
                child: Text(
                  FormatHelper.capitalize(widget.item.itemName),
                  style: AppTextStyles.font12BlackMediumCairo.copyWith(
                    color: AppColors.text,
                    decoration: widget.item.itemStatus == TaskStatus.done
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        if (widget.isNotHome) ...[
          SizedBox(width: 10.w),

          InkWell(
            onTap: () async {
              await _firebaseService.deleteItemFromTask(
                  widget.task.taskId.current ?? '', widget.item);
              setState(() {
                _items.remove(widget.item);
              });
            },
            child: CustomSvg(
              assetPath: Images.trashIcon,
              width: 16.w,
              height: 16.h,
            ),
          ),

          // ✅ Only show spacing on tablet/desktop
          if (!isMobile)
            SizedBox(
              width: 70.sp,
            ),
        ],
      ],
    );
  }
}