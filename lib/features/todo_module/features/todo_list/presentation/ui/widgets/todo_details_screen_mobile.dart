import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/theme/app_theme.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/column_request_data.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/custom_black_button.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/custom_icon_button.dart';
import 'package:demo_app/features/todo_module/core/constants/app_constanst.dart';
import 'package:demo_app/features/todo_module/core/constants/capitalization_functions.dart';
import 'package:demo_app/features/todo_module/core/constants/date_time_in_arabic.dart';
import 'package:demo_app/features/todo_module/core/constants/enum.dart';
import 'package:demo_app/features/todo_module/core/helper/date_helper.dart';
import 'package:demo_app/features/todo_module/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/frequency_model.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/status_model.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/cancel_add_item_row.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/edit_delete_icons_row.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/todo_comment_title.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/todo_item_chip_container.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/todo_item_name_and_icon.dart';

import '../../../../../core/constants/haptic_controller.dart';
import '../../../data/models/todo_model.dart';
import '../../controllers/todo_controller.dart';

/// ---------------------------------------------------------------------------
/// Module name:       Todo Module
/// Description:       This is a Mobile screen that displays the details of a todo item.
///                    It shows the todo name, description, date, time, and comments.
///                    It also allows the user to edit or delete the todo item.
///                    This screen is used in the TodoItemMobile widget.
///
/// Author:            Ahmed Mahmoud,
/// Date:              March/2024
///
/// Revision history:
///   - Ahmed Mahmoud     | 26/April/2025| ui refinements, refactored code to make it cleaner and more readable
/// ---------------------------------------------------------------------------

class TodoDetailsScreenMobile extends StatefulWidget {
  final TodoModel todoModel;

  const TodoDetailsScreenMobile({super.key, required this.todoModel});

  @override
  State<TodoDetailsScreenMobile> createState() =>
      _TodoDetailsScreenMobileState();
}

class _TodoDetailsScreenMobileState extends State<TodoDetailsScreenMobile> {
  final TodoController controller = Get.find<TodoController>();
  @override

  /// A widget that displays a todo item.
  /// The widget shows the title, description, date and time of the todo item.
  /// There is also an option to mark the item as done or undone.
  /// The widget is used in the TodoScreen widget.

  Widget build(BuildContext context) {
    int? doneItems = (widget.todoModel.comments ?? [])
        .where((comment) =>
            comment!.itemIsDone!.commentIsDone == true &&
            comment.itemIsDeleted!.commentIsDelete == false)
        .length;

    return GetBuilder<TodoController>(builder: (_) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  CustomAppBarMobile(
                      showIcon: true, title: widget.todoModel.name.name.last),

                  // Top buttons
                  if (widget.todoModel.status!.status != TodoStatus.deleted)
                    EditAndDeleteButtonsRowDetailsScreen(
                        controller: controller, model: widget.todoModel),

                  if (widget.todoModel.status!.status != TodoStatus.deleted)
                    SizedBox(height: 15),
                  // Actual Page UI
                  Container(
                    decoration: BoxDecoration(
                      color:
                          // isDark ? AppColors.darkBackGround :
                          AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              children: [
                                // Number of comments
                                if (widget.todoModel.comments?.isNotEmpty ==
                                        true &&
                                    widget.todoModel.status!.status !=
                                        TodoStatus.deleted)
                                  TodoItemChipContainer(
                                    xLarge: true,
                                    title: Get.locale?.languageCode == 'ar'
                                        ? "${convertNumberToArabic(widget.todoModel.comments!.length.toString())}/${convertNumberToArabic(doneItems.toString())}"
                                        : "$doneItems/${widget.todoModel.comments!.length.toString()}",
                                  ),
                                Spacer(),
                                // End Date & Time
                                if (widget.todoModel.endDate?.date?.last !=
                                        AppConstants.empty &&
                                    widget.todoModel.status!.status !=
                                        TodoStatus.deleted)
                                  Row(
                                    children: [
                                      TodoItemChipContainer(
                                        xLarge: true,
                                        title:
                                            Get.locale.toString().contains('en')
                                                ? capitalizeMonth(widget
                                                        .todoModel
                                                        .endDate
                                                        ?.date
                                                        ?.last ??
                                                    '')
                                                : translateDate(capitalizeMonth(
                                                    widget.todoModel.endDate
                                                            ?.date?.last ??
                                                        '')),
                                        color: DateHelper.checkIsEnded(
                                                  date: widget.todoModel.endDate
                                                          ?.date?.last ??
                                                      '',
                                                  time: widget.todoModel.endTime
                                                          ?.time?.last ??
                                                      '',
                                                ) ==
                                                true
                                            ? AppColors.red
                                            : AppColors.background,
                                        textColor: DateHelper.checkIsEnded(
                                                  date: widget.todoModel.endDate
                                                          ?.date?.last ??
                                                      '',
                                                  time: widget.todoModel.endTime
                                                          ?.time?.last ??
                                                      '',
                                                ) ==
                                                true
                                            ? AppColors.white
                                            : AppColors.black,
                                        icon: SvgPicture.asset(
                                            'assets/icons/SmallCalendar.svg',
                                            color: DateHelper.checkIsEnded(
                                                      date: widget
                                                              .todoModel
                                                              .endDate
                                                              ?.date
                                                              ?.last ??
                                                          '',
                                                      time: widget
                                                              .todoModel
                                                              .endTime
                                                              ?.time
                                                              ?.last ??
                                                          '',
                                                    ) ==
                                                    true
                                                ? AppColors.white
                                                : AppTheme.isDark == false
                                                    ? null
                                                    : AppColors.white),
                                      ),
                                      if (widget
                                              .todoModel.endTime!.time!.last !=
                                          AppConstants.empty)
                                        SizedBox(width: 10),
                                      if (widget
                                              .todoModel.endTime!.time!.last !=
                                          AppConstants.empty)
                                        TodoItemChipContainer(
                                          xLarge: true,
                                          title: Get.locale
                                                  .toString()
                                                  .contains('en')
                                              ? capitalizeAmPm(widget.todoModel
                                                      .endTime!.time!.last ??
                                                  "")
                                              : translateTime(capitalizeAmPm(
                                                  widget.todoModel.endTime?.time
                                                          ?.last ??
                                                      '')),
                                          color: AppColors.background,
                                          textColor: AppColors.darkGrey,
                                          icon: SvgPicture.asset(
                                            'assets/icons/ClockCircleSmall.svg',
                                            color: AppTheme.isDark == false
                                                ? null
                                                : AppColors.white,
                                          ),
                                        ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                          if (widget.todoModel.startDate!.date!.last !=
                                      AppConstants.empty &&
                                  widget.todoModel.status!.status !=
                                      TodoStatus.deleted ||
                              widget.todoModel.comments?.isNotEmpty == true &&
                                  widget.todoModel.status!.status !=
                                      TodoStatus.deleted)
                            const SizedBox(height: 10),
                          Row(
                            children: [
                              // Show Scheduled chip
                              if (widget.todoModel.startDate!.date!.last !=
                                      AppConstants.empty &&
                                  widget.todoModel.startTime!.time!.last !=
                                      AppConstants.empty &&
                                  widget.todoModel.status!.status !=
                                      TodoStatus.deleted)
                                TodoItemChipContainer(
                                  xLarge: true,
                                  title:
                                      '${AppConstants.scheduled.tr}: ${Get.locale?.languageCode == 'ar' ? translateDate(widget.todoModel.startDate?.date?.last?.capitalize ?? '') : widget.todoModel.startDate?.date?.last?.capitalize} ${'At'.tr} ${Get.locale?.languageCode == 'ar' ? translateTime(capitalizeAmPm(widget.todoModel.startTime!.time!.last!)) : capitalizeAmPm(widget.todoModel.startTime!.time!.last!)}',
                                ),

                              // Show Scheduled chip
                              if (widget.todoModel.startDate!.date!.last !=
                                      AppConstants.empty &&
                                  widget.todoModel.startTime!.time!.last ==
                                      AppConstants.empty &&
                                  widget.todoModel.status!.status !=
                                      TodoStatus.deleted)
                                TodoItemChipContainer(
                                  xLarge: true,
                                  title:
                                      '${AppConstants.scheduled.tr}: ${Get.locale?.languageCode == 'ar' ? translateDate(widget.todoModel.startDate?.date?.last?.capitalize ?? '') : widget.todoModel.startDate?.date?.last?.capitalize}',
                                ),
                              Spacer(),

                              // Show frequency chip
                              if (widget.todoModel.frequencyText != null &&
                                  widget.todoModel.frequencyText!.frequencyText!
                                          .last !=
                                      null &&
                                  widget.todoModel.status!.status !=
                                      TodoStatus.deleted)
                                TodoItemChipContainer(
                                  xLarge: true,
                                  title: FrequencyText().getFrequencyText(widget
                                      .todoModel
                                      .frequencyText
                                      ?.frequencyText
                                      ?.last),
                                ),
                            ],
                          ),
                          if (widget.todoModel.startDate!.date!.last !=
                                      AppConstants.empty &&
                                  widget.todoModel.status!.status !=
                                      TodoStatus.deleted ||
                              widget.todoModel.frequencyText!.frequencyText!
                                          .last !=
                                      null &&
                                  widget.todoModel.status!.status !=
                                      TodoStatus.deleted)
                            SizedBox(height: 10),
                          // Todo Name
                          ToDoItemNameAndIcon(
                            todoModel: widget.todoModel,
                            controller: controller,
                            // isDark: isDark,
                            detailsScreen: true,
                          ),
                          SizedBox(height: 10),
                          // Todo Description
                          if (widget.todoModel.description?.description?.last !=
                              AppConstants.empty)
                            Padding(
                              padding: Get.locale?.languageCode == 'ar'
                                  ? EdgeInsets.only(left: 20)
                                  : EdgeInsets.only(right: 20),
                              child: Text(
                                widget.todoModel.description?.description?.last
                                        ?.capitalize ??
                                    "",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.font10BlackCairoRegular
                                    .copyWith(
                                        fontSize: 12,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w400,
                                        height: 1.8),
                              ),
                            ),
                          if (widget.todoModel.description?.description?.last !=
                              AppConstants.empty)
                            SizedBox(height: 16),
                          // comment list
                          ListView.separated(
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.todoModel.comments?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return TodoCommentTextAndIcon(
                                onTap: () {
                                  controller.changeCommentStatus(
                                      todoModel: widget.todoModel,
                                      index: index);
                                },
                                onDelete: () {
                                  controller.deleteComment(
                                    context,
                                    todoModel: widget.todoModel,
                                    index: index,
                                  );
                                },
                                detailsScreen: true,
                                todoModel: widget.todoModel,
                                index: index,
                                // isDark: isDark
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          if (widget.todoModel.status!.status !=
                              TodoStatus.deleted)
                            CustomBlackButton(
                              isYellow: controller.isYellow,
                              buttonText: AppConstants.item.tr,
                              onPressed: () {
                                setState(() =>
                                    controller.isYellow = !controller.isYellow);
                              },
                            ),
                          // Adding a new Item field and Buttons
                          if (widget.todoModel.status!.status !=
                              TodoStatus.deleted)
                            if (controller.isYellow == true)
                              Column(
                                children: [
                                  SizedBox(height: 5),
                                  Form(
                                    key: controller.addItemFormKey,
                                    child: ColumnRequestData(
                                      title: AppConstants.title.tr,
                                      isTextField: true,
                                      validator: (val) {
                                        if (widget.todoModel.comments != null &&
                                            widget.todoModel.comments!
                                                .isNotEmpty) {
                                          if (widget.todoModel.comments!.any(
                                              (element) =>
                                                  element?.itemName
                                                      ?.capitalizeFirst ==
                                                  val?.capitalizeFirst)) {
                                            return "Item already exists".tr;
                                          }
                                        }
                                        return null;
                                      },
                                      hint: AppConstants.enterNewItem.tr,
                                      isOptional: false,
                                      isExpanded: true,
                                      textController:
                                          controller.commentController,
                                      hideTitle: true,
                                      controllerState: (value) {
                                        setState(() {});
                                      },
                                      controllerfinishState: (value) =>
                                          FocusScope.of(context).unfocus(),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  CancelAndAddItemsRowOfButtons(
                                      controller: controller,
                                      model: widget.todoModel),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  if (widget.todoModel.status!.status == TodoStatus.deleted)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CustomIconButton(
                        width: 150,
                        buttonText: AppConstants.recover.tr,
                        imagePath: "",
                        hasIcon: false,
                        onPressed: () {
                          Get.find<ToDoHapticController>()
                              .triggerHapticFeedback(
                                  vibration: VibrateType.heavyImpact,
                                  hapticFeedback: HapticFeedback.heavyImpact);
                          controller.recoverTodo(widget.todoModel, context);
                        },
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
