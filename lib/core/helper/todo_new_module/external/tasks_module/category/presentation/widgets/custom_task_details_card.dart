import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/helper/inventory_module/core/text_field.dart';

import 'package:demo_app/core/enums/enum.dart' as FormatHelper;
import 'package:demo_app/core/theme/app_font_weights.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import '../../../core/custom_widgets/custom_button_widget.dart';
import '../../../core/custom_widgets/custom_check_box.dart';
import '../../../core/custom_widgets/svg_custom.dart';
import '../../../core/custom_widgets/text_field.dart';
import '../../../core/enums/task_status_enum.dart';
import '../../../core/utilties/images.dart';
import '../../data/models/items_data.dart';
import '../../data/models/task_model_updates_with_field_history.dart';
import '../../domain/services/task_services.dart';
import 'build_item.dart';
import 'custom_task_card.dart';

class CustomTaskDetailsCard extends StatefulWidget {
  CustomTaskDetailsCard({
    super.key,
    required this.task,
    required this.isSameDay,
  });

  TaskModel task;
  bool isSameDay;

  @override
  State<CustomTaskDetailsCard> createState() => _CustomTaskDetailsCardState();
}

class _CustomTaskDetailsCardState extends State<CustomTaskDetailsCard> {
  final TaskFirebaseService _firebaseService = TaskFirebaseService();

  String _getLocalizedFrequency(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return S.of(context).daily;
      case 'weekly':
        return S.of(context).weekly;
      case 'monthly':
        return S.of(context).monthly;
      default:
        return FormatHelper.capitalize(frequency);
    }
  }

  // Add this helper method to format time based on locale
  String _formatTimeForLocale(String? timeString, String locale) {
    if (timeString == null || timeString.isEmpty) return '';

    try {
      // Parse the time string (assuming format like "2:30 PM" or "14:30")
      final parts = timeString.trim().split(' ');
      if (parts.isEmpty) return timeString;

      final timePart = parts[0];
      final hm = timePart.split(':');
      if (hm.length < 2) return timeString;

      int hour = int.tryParse(hm[0]) ?? 0;
      int minute = int.tryParse(hm[1]) ?? 0;

      // Check if there's AM/PM
      if (parts.length > 1) {
        final isPM = parts[1].toLowerCase().contains('pm');
        if (isPM && hour != 12) hour += 12;
        if (!isPM && hour == 12) hour = 0;
      }

      // Create a DateTime object for today with the parsed time
      final now = DateTime.now();
      final dateTime = DateTime(now.year, now.month, now.day, hour, minute);

      // Format based on locale
      final timeFormatter = DateFormat.jm(locale); // This gives localized time format
      return timeFormatter.format(dateTime);
    } catch (e) {
      debugPrint('⚠️ Error formatting time for locale: $e');
      return timeString; // Return original if parsing fails
    }
  }

  bool _overdueBorder(String? timeString) {
    if (widget.task.currentScheduled == null ||
        widget.task.currentScheduled?.taskStartDate == null ||
        timeString == null ||
        timeString.isEmpty) {
      return false;
    }

    final isNotDone = (widget.task.taskStatus.current ?? '') != TaskStatus.done;

    try {
      final isBefore = isTimeBeforeNow(
        timeString,
        widget.task.currentScheduled?.taskStartDate,
      );
      return isNotDone && isBefore;
    } catch (e) {
      debugPrint('⚠️ Error in _overdueBorder: $e');
      return false;
    }
  }

  bool isTodayOrPast(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    return targetDate.isBefore(today) || targetDate.isAtSameMomentAs(today);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    var isMobile = context.isPhone; // ✅ Add mobile detection
    var lightMode = Theme.of(context).brightness == Brightness.light;
    final formatter = DateFormat('dd MMM yyyy', locale);
    final endDateFormatter = DateFormat('dd MMM yyyy', locale);

    final isNotDone = (widget.task.taskStatus.current ?? '') != TaskStatus.done;
    final isNotDeleted =
        (widget.task.taskStatus.current ?? '') != TaskStatus.deleted;
    final isScheduled = widget.task.currentScheduled != null;
    final isFrequency = widget.task.currentFrequency != null;

    return Container(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: (isScheduled &&
              _overdueBorder(widget.task.currentScheduled?.taskEndTime))
              ? AppColors.red
              : Colors.transparent,
          width: 1.5.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          //  Mobile: Fixed layout with reserved positions
          if (isMobile) ...[
            // First row: End date + End time (always on right side)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Items count (or empty space if no items)
                if ((widget.task.currentItems ?? []).isNotEmpty)
                  Container(
                    height: 30.h,
                    padding: EdgeInsets.symmetric(horizontal: 7.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.task.currentItems?.where((element) => element.itemStatus == TaskStatus.done).length ?? 0}/${widget.task.currentItems?.length ?? 0}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textButton,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox.shrink(), // ✅ Empty placeholder to maintain spacing

                // Right side: End date + End time
                if (isScheduled && widget.task.currentScheduled?.taskEndDate != null)
                  Row(
                    children: [
                      customButtonWithImage(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        title: widget.task.currentScheduled?.taskEndDate != null
                            ? endDateFormatter.format(
                            widget.task.currentScheduled!.taskEndDate!)
                            : '',
                        function: () {},
                        textStyle: AppTextStyles.font10BlackCairoRegular.copyWith(
                          color: (((widget.isSameDay ?? false) || (!isNotDone)) &&
                              (!_overdueBorder(
                                widget.task.currentScheduled?.taskEndTime,
                              )))
                              ? Colors.white
                              : AppColors.secondaryText,
                        ),
                        height: 30.h,
                        space: 4.r,
                        radius: 4.r,
                        color: ((widget.isSameDay ?? false) &&
                            !_overdueBorder(
                              widget.task.currentScheduled?.taskEndTime,
                            ))
                            ? AppColors.red
                            : (!isNotDone)
                            ? AppColors.green
                            : AppColors.background,
                        image: Images.calendarIcon,
                        svgColor: (((widget.isSameDay ?? false) || (!isNotDone)) &&
                            (!_overdueBorder(
                              widget.task.currentScheduled?.taskEndTime,
                            )))
                            ? Colors.white
                            : AppColors.secondaryText,
                        widthImage: 16.h,
                        heightImage: 16.h,
                        colorBorder: ((widget.isSameDay ?? false) &&
                            !_overdueBorder(
                              widget.task.currentScheduled?.taskEndTime,
                            ))
                            ? AppColors.red
                            : (!isNotDone)
                            ? AppColors.green
                            : AppColors.card,
                      ),
                      SizedBox(width: 10.w),
                      customButtonWithImage(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        title: _formatTimeForLocale(
                            widget.task.currentScheduled?.taskEndTime, locale),
                        function: () {},
                        textStyle: AppTextStyles.font10BlackCairoRegular
                            .copyWith(color: AppColors.secondaryText),
                        height: 30.h,
                        space: 4.r,
                        radius: 4.r,
                        color: AppColors.background,
                        image: Images.clockIcon,
                        widthImage: 16.h,
                        heightImage: 16.h,
                        colorBorder: AppColors.background,
                      ),
                    ],
                  )
                else
                  SizedBox.shrink(), // ✅ Empty placeholder to maintain spacing
              ],
            ),

            // ✅ Always show second row spacing (even if empty)
            SizedBox(height: 10.h),

            // Second row: Frequency + Scheduled (always on right side)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Frequency (or empty space)
                if (isFrequency)
                  Container(
                    height: 30.h,
                    padding: EdgeInsets.symmetric(horizontal: 7.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Center(
                      child: Text(
                        '${S.of(context).frequency}: ${_getLocalizedFrequency(widget.task.currentFrequency?.frequencyUnit ?? '')}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textButton,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox.shrink(), // ✅ Empty placeholder to maintain spacing

                // Right side: Scheduled start date/time
                if (isScheduled &&
                    widget.task.currentScheduled?.taskStartDate != null &&
                    !isTodayOrPast(widget.task.currentScheduled!.taskStartDate))
                  Container(
                    height: 30.h,
                    padding: EdgeInsets.symmetric(horizontal: 7.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Center(
                      child: Text(
                        '${S.of(context).scheduled}: ${formatter.format(widget.task.currentScheduled!.taskStartDate)} ${S.of(context).at} ${_formatTimeForLocale(widget.task.currentScheduled?.taskStartTime, locale)}',
                        style: AppTextStyles.font10BlackCairoRegular
                            .copyWith(color: AppColors.textButton),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  )
                else
                  SizedBox.shrink(), // ✅ Empty placeholder to maintain spacing
              ],
            ),
          ]
          // Tablet/Desktop: Keep original single row layout
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if ((widget.task.currentItems ?? []).isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 30.h,
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.task.currentItems?.where((element) => element.itemStatus == TaskStatus.done).length ?? 0}/${widget.task.currentItems?.length ?? 0}',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textButton,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),
                ],
                if (isFrequency) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 30.h,
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Center(
                          child: Text(
                            '${S.of(context).frequency}: ${_getLocalizedFrequency(widget.task.currentFrequency?.frequencyUnit ?? '')}',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textButton,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),
                ],
                if (isScheduled &&
                    !isTodayOrPast(
                      widget.task.currentScheduled!.taskStartDate,
                    )) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 30.h,
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Center(
                          child: Text(
                            '${S.of(context).scheduled}: ${formatter.format(widget.task.currentScheduled!.taskStartDate)} ${S.of(context).at} ${_formatTimeForLocale(widget.task.currentScheduled?.taskStartTime, locale)}',
                            style: AppTextStyles.font10BlackCairoRegular
                                .copyWith(color: AppColors.textButton),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),
                ],
                if (isScheduled &&
                    widget.task.currentScheduled?.taskEndDate != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customButtonWithImage(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        title: widget.task.currentScheduled?.taskEndDate != null
                            ? endDateFormatter.format(
                            widget.task.currentScheduled!.taskEndDate!)
                            : '',
                        function: () {},
                        textStyle: AppTextStyles.font10BlackCairoRegular.copyWith(
                          color: (((widget.isSameDay ?? false) ||
                              (!isNotDone)) &&
                              (!_overdueBorder(
                                widget.task.currentScheduled?.taskEndTime,
                              )))
                              ? Colors.white
                              : AppColors.secondaryText,
                        ),
                        height: 30.h,
                        space: 4.r,
                        radius: 4.r,
                        color: ((widget.isSameDay ?? false) &&
                            !_overdueBorder(
                              widget.task.currentScheduled?.taskEndTime,
                            ))
                            ? AppColors.red
                            : (!isNotDone)
                            ? AppColors.green
                            : AppColors.background,
                        image: Images.calendarIcon,
                        svgColor: (((widget.isSameDay ?? false) ||
                            (!isNotDone)) &&
                            (!_overdueBorder(
                              widget.task.currentScheduled?.taskEndTime,
                            )))
                            ? Colors.white
                            : AppColors.secondaryText,
                        widthImage: 16.h,
                        heightImage: 16.h,
                        colorBorder: ((widget.isSameDay ?? false) &&
                            !_overdueBorder(
                              widget.task.currentScheduled?.taskEndTime,
                            ))
                            ? AppColors.red
                            : (!isNotDone)
                            ? AppColors.green
                            : AppColors.card,
                      ),
                      SizedBox(width: 10.w),
                      customButtonWithImage(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        title: _formatTimeForLocale(
                            widget.task.currentScheduled?.taskEndTime, locale),
                        function: () {},
                        textStyle: AppTextStyles.font10BlackCairoRegular
                            .copyWith(color: AppColors.secondaryText),
                        height: 30.h,
                        space: 4.r,
                        radius: 4.r,
                        color: AppColors.background,
                        image: Images.clockIcon,
                        widthImage: 16.h,
                        heightImage: 16.h,
                        colorBorder: AppColors.background,
                      ),
                    ],
                  ),
              ],
            ),
          SizedBox(height: 15.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _firebaseService.updateTaskStatusUi(widget.task),
                child: CustomCheckBox(
                  isSelected:
                  (widget.task.taskStatus.current ?? '') == TaskStatus.done,
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${FormatHelper.capitalize(widget.task.name.current ?? '')}',
                      style: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color: AppColors.text,
                        decoration:
                        (widget.task.taskStatus.current ?? '') ==
                            TaskStatus.done
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if ((widget.task.description.current ?? '').isNotEmpty) ...[
                      SizedBox(height: 5.h),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Text(
                          '${FormatHelper.capitalize(widget.task.description.current ?? '')} ',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.font14BlackCairoRegular.copyWith(
                            height: 1.7,
                            color: AppColors.secondaryText,
                            decoration:
                            (widget.task.taskStatus.current ?? '') ==
                                TaskStatus.done
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if ((widget.task.currentItems ?? []).isNotEmpty) ...[
                SizedBox(height: 5.h),
                Column(
                  children: [
                    for (int i = 0; i < widget.task.currentItems!.length; i++)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: CustomBuildItem(
                          item: widget.task.currentItems![i],
                          task: widget.task,
                          isNotHome: true,
                          updateItemStatus: () async {
                            await _firebaseService.toggleItemStatus(
                              widget.task.taskId.current ?? '',
                              widget.task.currentItems![i],
                            );
                            setState(() {
                              widget.task.currentItems![i].itemStatus =
                              widget.task.currentItems![i].itemStatus ==
                                  TaskStatus.done
                                  ? TaskStatus.toDo
                                  : TaskStatus.done;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ],
              SizedBox(height: 15.h),
              customButtonWithImage(
                title: S.of(context).item,
                function: _showAddNewItemDialog,
                textStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
                    color: AppColors.white
                ),
                width: 100.w,
                height: 28.h,
                space: 4.w,
                radius: 4.r,
                color: AppColors.black,
                image: Images.plusIcon,
                widthImage: 16,
                heightImage: 16,
                colorBorder: Colors.transparent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddNewItemDialog() {
    final TextEditingController dialogController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var isMobile = context.isPhone;
        var isTablet = context.isTablet;
        var isLandscape = context.isLandscape;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final lightMode = Theme.of(context).brightness == Brightness.light;
            return AlertDialog(
              backgroundColor: AppColors.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              content: SizedBox(
                width: 411.w,
                height: 140.h,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: Center(
                            child: CustomSvg(
                              assetPath: Images.plusIcon,
                              width: 20.w,
                              height: 20.h,
                              color: AppColors.textButton,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          S.of(context).addNewItem,
                          style: AppTextStyles.font16BlackSemiBoldCairo.copyWith(
                              color: lightMode ? AppColors.blackButton : AppColors.white
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    CustomValidatedTextFieldInv(
                      height: 36,
                      label: "",
                      hint: S.of(context).textHere,
                      controller: dialogController,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customButton(
                          title: S.of(context).cancel,
                          function: () => Navigator.pop(context),
                          width: 100.w,
                          radius: 4.r,
                          height: 30.h,
                          color: lightMode ?Colors.grey[400] :  Colors.grey[700],
                          textStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
                            color: lightMode ? Colors.black : Colors.white,
                          ),
                        ),
                        customButton(
                          title: S.of(context).submit,
                          function: () async {
                            if (dialogController.text.trim().isEmpty) return;

                            final newItem = ItemData(
                              itemId: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              itemName: dialogController.text.trim(),
                              itemStatus:
                              widget.task.taskStatus.current ==
                                  TaskStatus.done
                                  ? TaskStatus.done
                                  : TaskStatus.toDo,
                            );

                            await _firebaseService.addItemToTask(
                              widget.task.taskId.current ?? '',
                              newItem,
                            );

                            setState(() {
                              widget.task.currentItems?.add(newItem);
                            });

                            Navigator.pop(context);
                          },
                          width: 100.w,
                          radius: 4.r,
                          height: 30.h,
                          color: AppColors.primary,
                          textStyle: AppTextStyles.font14BlackCairoMedium.copyWith(
                            color: AppColors.textButton,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}