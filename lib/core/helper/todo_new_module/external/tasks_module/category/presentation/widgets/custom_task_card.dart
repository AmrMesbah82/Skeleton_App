import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/enums/enum.dart' as FormatHelper;
import 'package:demo_app/core/theme/app_font_weights.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import '../../../core/custom_widgets/custom_button_widget.dart';
import '../../../core/custom_widgets/custom_check_box.dart';
import '../../../core/custom_widgets/custom_pop_up_dialog_widget.dart';
import '../../../core/enums/task_status_enum.dart';
import '../../../core/utilties/images.dart';
import '../../data/models/task_model_updates_with_field_history.dart';
import '../../domain/services/task_services.dart';
import 'build_item.dart';

final _now = DateTime.now();

bool isTimeBeforeNow(String? timeString, DateTime? date) {
  if (timeString == null || timeString.isEmpty || date == null) return false;

  try {
    final parts = timeString.split(' ');
    if (parts.length < 2) return false;

    final hm = parts[0].split(':');
    if (hm.length < 2) return false;

    int hour = int.tryParse(hm[0]) ?? 0;
    int minute = int.tryParse(hm[1]) ?? 0;

    final isPM = parts[1].toLowerCase() == 'pm';
    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    final time = DateTime(date.year, date.month, date.day, hour, minute);
    return time.isBefore(_now);
  } catch (e) {
    debugPrint('⚠️ Error in isTimeBeforeNow: $e');
    return false;
  }
}

class TaskCard extends StatefulWidget {
  TaskCard({
    super.key,
    required this.task,
    required this.updateTaskStatus,
    required this.isSameDay,
  });

  TaskModel task;
  VoidCallback updateTaskStatus;
  bool? isSameDay;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final TaskFirebaseService _firebaseService = TaskFirebaseService();
  bool _isLoading = false;

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

  bool isTodayOrPast(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    return targetDate.isBefore(today) || targetDate.isAtSameMomentAs(today);
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

  // Add this helper method to format numbers based on locale
  String _formatNumberForLocale(int number, String locale) {
    final numberFormat = NumberFormat.decimalPattern(locale);
    return numberFormat.format(number);
  }

  // Restore dialog
  void _showRestoreDialog(BuildContext context) {
    var isMobile = context.isPhone;
    var lightMode = Theme.of(context).brightness == Brightness.light;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => CustomPopupDialogWithLottie(
        lottiePath: Images.retriveLottie,
        title: S.of(context).restoringToDo,
        message: S.of(context).areYouSureYouWantToRestoreThisListToDo,
        actions: [
          customButton(
            title: S.of(context).no,
            width: 135.w,
            color: lightMode ? Colors.grey[400] : Colors.grey[700],
            height: 38.sp,
            textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
              color: lightMode ? Colors.black : Colors.white,
            ),
            radius: 8.r,
            function: () => Navigator.of(dialogContext).pop(),
          ),
          SizedBox(width: isMobile ? 10.w : 28.w),
          customButton(
            title: S.of(context).yes,
            width: 135.w,
            color: AppColors.primary,
            height: 38.sp,
            textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
              color: AppColors.textButton,
            ),
            radius: 8.r,
            function: () => _restoreTask(dialogContext),
          ),
        ],
      ),
    );
  }

  // Restore task
  void _restoreTask(BuildContext dialogContext) async {
    // Close the confirmation dialog first
    Navigator.of(dialogContext).pop();

    setState(() => _isLoading = true);

    try {
      await _firebaseService.restoreTask(widget.task.taskId.current ?? '');

      // Then show success dialog
      if (mounted) {
        _showSuccessRestoreDialog(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Success restore dialog
  void _showSuccessRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          // Trigger the updateTaskStatus callback to refresh the list
          widget.updateTaskStatus();
        });

        return CustomPopupDialogWithLottie(
          lottiePath: Images.approvedLottie,
          title: S.of(context).restoringToDo,
          message: S.of(context).youSuccessfullyRestoredThisToDo,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    var lightMode = Theme.of(context).brightness == Brightness.light;

    // Use locale-aware date formatter
    final formatter = DateFormat('dd MMM yyyy', locale);
    final endDateFormatter = DateFormat('dd MMM yyyy', locale);

    final isNotDone = (widget.task.taskStatus.current ?? '') != TaskStatus.done;
    final isNotDeleted =
        (widget.task.taskStatus.current ?? '') != TaskStatus.deleted;
    final isDeleted = (widget.task.taskStatus.current ?? '') == TaskStatus.deleted;
    final isScheduled = widget.task.currentScheduled != null;
    final isFrequency = widget.task.currentFrequency != null;

    final scheduleWord =
    (isScheduled &&
        isFrequency &&
        !isTodayOrPast(widget.task.currentScheduled!.taskStartDate))
        ? S.of(context).schedAbbreviation
        : S.of(context).scheduled;
    final frequencyWord =
    (isScheduled &&
        isFrequency &&
        !isTodayOrPast(widget.task.currentScheduled!.taskStartDate))
        ? S.of(context).freqAbbreviation
        : S.of(context).frequency;

    bool _overdueBorder(String? timeString) {
      if (widget.task.currentScheduled == null ||
          widget.task.currentScheduled?.taskEndDate == null ||
          timeString == null ||
          timeString.isEmpty) {
        return false;
      }

      try {
        final isBefore = isTimeBeforeNow(
          timeString,
          widget.task.currentScheduled?.taskEndDate,
        );

        // A task is overdue ONLY if:
        // 1. The end time has passed (isBefore is true)
        // 2. The task is currently NOT done (isNotDone is true)
        //
        // This means:
        // - If task is done → Never overdue (no red border)
        // - If task is deleted but was done before deletion → Not overdue (no red border)
        // - If task is deleted and was NOT done → Can be overdue (red border if time passed)
        // - If task is todo and time passed → Overdue (red border)

        return isBefore && isNotDone;
      } catch (e) {
        debugPrint('⚠️ Error in _overdueBorder: $e');
        return false;
      }
    }

    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color:
          (isScheduled &&
              _overdueBorder(widget.task.currentScheduled?.taskEndTime))
              ? AppColors.red
              : Colors.transparent,
          width: 1.5.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if ((widget.task.currentItems ?? []).isNotEmpty &&
                      isNotDeleted) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 20.h,
                          padding: EdgeInsets.symmetric(horizontal: 7.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Center(
                            child: Text(
                              '${_formatNumberForLocale(widget.task.currentItems?.where((element) => element.itemStatus == TaskStatus.done).length ?? 0, locale)}/${_formatNumberForLocale(widget.task.currentItems?.length ?? 0, locale)}',
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: AppFontWeights.regular,
                                color: AppColors.textButton,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 5.w),
                  ],
                  if (isFrequency && isNotDeleted) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 20.h,
                          padding: EdgeInsets.symmetric(horizontal: 7.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Center(
                            child: Text(
                              '$frequencyWord: ${_getLocalizedFrequency(widget.task.currentFrequency?.frequencyUnit ?? '')}',
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: AppFontWeights.regular,
                                color: AppColors.textButton,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isScheduled &&
                        isNotDeleted &&
                        !isTodayOrPast(
                          widget.task.currentScheduled!.taskStartDate,
                        ))   SizedBox(width: 5.w),
                  ],
                  if (isScheduled &&
                      isNotDeleted &&
                      !isTodayOrPast(
                        widget.task.currentScheduled!.taskStartDate,
                      )) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 20.h,
                          padding: EdgeInsets.symmetric(horizontal: 7.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Center(
                            child: Text(
                              '$scheduleWord: ${formatter.format(widget.task.currentScheduled!.taskStartDate)} ${S.of(context).at} ${_formatTimeForLocale(widget.task.currentScheduled?.taskStartTime, locale)}',
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: AppFontWeights.regular,
                                color: AppColors.textButton,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (isDeleted) ...[
                    GestureDetector(
                      onTap: () => _showRestoreDialog(context),
                      child: Container(
                        height: 20.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).restore,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: AppFontWeights.regular,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ FIXED: Disable checkbox when deleted
                  GestureDetector(
                    onTap: isDeleted
                        ? null  // Disable tap when deleted
                        : () => _firebaseService.updateTaskStatusUi(widget.task),
                    child: Opacity(
                      opacity: isDeleted ? 0.5 : 1.0,  // Make it look disabled
                      child: AbsorbPointer(
                        absorbing: isDeleted,  // Block all interactions when deleted
                        child: CustomCheckBox(
                          isSelected:
                          (widget.task.taskStatus.current ?? '') ==
                              TaskStatus.done,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 3.sp),
                        Text(
                          FormatHelper.capitalize(
                            widget.task.name.current ?? '',
                          ),
                          style: AppTextStyles.font14BlackCairoRegular.copyWith(
                            color: AppColors.text,
                            decoration:
                            (widget.task.taskStatus.current ?? '') ==
                                TaskStatus.done
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),

                        SizedBox(height: 10.sp),
                        if ((widget.task.description.current ?? '')
                            .isNotEmpty &&
                            (widget.task.currentItems == null ||
                                widget.task.currentItems!.isEmpty)) ...[
                          Text(
                            FormatHelper.capitalize(
                              widget.task.description.current ?? '',
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.font10SecondaryBlackCairoRegular.copyWith(
                              height: 1.7,
                              color: AppColors.secondaryBlack,
                              decoration:
                              (widget.task.taskStatus.current ?? '') ==
                                  TaskStatus.done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ],
                        if ((widget.task.currentItems ?? []).isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          SizedBox(
                            height: (2 * 20.5.h) + 10.h,
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: widget.task.currentItems!.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 10.h),
                              itemBuilder: (context, i) {
                                return CustomBuildItem(
                                  item: widget.task.currentItems![i],
                                  task: widget.task,
                                  isNotHome: false,
                                  updateItemStatus: () async {
                                    // ✅ Also prevent item status update when task is deleted
                                    if (isDeleted) return;

                                    await _firebaseService.toggleItemStatus(
                                      widget.task.taskId.current ?? '',
                                      widget.task.currentItems![i],
                                    );
                                    setState(() {
                                      widget.task.currentItems![i].itemStatus =
                                          widget
                                              .task
                                              .currentItems![i]
                                              .itemStatus =
                                      widget
                                          .task
                                          .currentItems![i]
                                          .itemStatus ==
                                          TaskStatus.done
                                          ? TaskStatus.toDo
                                          : TaskStatus.done;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (widget.task.currentScheduled != null &&
              widget.task.currentScheduled?.taskEndDate != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customButtonWithImage(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    title: widget.task.currentScheduled?.taskEndDate != null
                        ? endDateFormatter.format(widget.task.currentScheduled!.taskEndDate!)
                        : '',
                    function: () {},
                    textStyle: AppTextStyles.font10BlackCairoRegular.copyWith(
                        color:
                        (((widget.isSameDay ?? false) || (!isNotDone)) &&
                            (!_overdueBorder(
                              widget.task.currentScheduled?.taskEndTime,
                            )))
                            ? Colors.white
                            : AppColors.secondaryText
                    ),
                    height: 30.h,
                    space: 4.r,
                    radius: 8.r,
                    color:
                    ((widget.isSameDay ?? false) &&
                        !_overdueBorder(
                          widget.task.currentScheduled?.taskEndTime,
                        ))
                        ? AppColors.red
                        : (!isNotDone)
                        ? AppColors.green
                        : AppColors.background,
                    image: Images.calendarIcon,
                    svgColor:
                    (((widget.isSameDay ?? false) || (!isNotDone)) &&
                        (!_overdueBorder(
                          widget.task.currentScheduled?.taskEndTime,
                        )))
                        ? Colors.white
                        : AppColors.secondaryText,
                    widthImage: 16.h,
                    heightImage: 16.h,
                    colorBorder:
                    Colors.transparent
                ),
                //clock button
                customButtonWithImage(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  title: _formatTimeForLocale(widget.task.currentScheduled?.taskEndTime, locale),
                  function: () {},
                  textStyle: AppTextStyles.font10BlackCairoRegular.copyWith(
                      color: AppColors.secondaryText
                  ),
                  height: 30.h,
                  space: 4.r,
                  radius: 8.r,
                  color: AppColors.background,
                  image: Images.clockIcon,
                  widthImage: 16.h,
                  heightImage: 16.h,
                  colorBorder: Colors.transparent,
                ),
              ],
            ),
        ],
      ),
    );
  }
}