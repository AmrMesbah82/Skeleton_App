// Date Created :16/April/2024
// Developer Name : Abdullah Ibrahim
//App Version : Version 2
// Objectives: Edit card name and description dialog.
import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/dialogs/custom_create_task_container.dart';
import 'package:demo_app/core/widgets/buttons/main_yellow_button copy.dart';
import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

import 'package:demo_app/core/helper_module/task_management_module/task/data/model/board_model/board_model.dart';
import 'package:demo_app/core/helper_module/task_management_module/task/data/model/card_model/card_model.dart';


class EditCardDetailsDialouge extends StatefulWidget {
  EditCardDetailsDialouge(
      {super.key,
      required this.title,
      this.taskName,
      this.taskDescription,
      required this.onPressed,
      this.textController,
      this.board,
      this.cardModel,
      required this.boardModel});

  final String title;
  final String? taskName;
  final String? taskDescription;

  final String? board;
  final CardModel? cardModel;
  final void Function() onPressed;
  TextEditingController? textController;
  final BoardModel boardModel;

  @override
  State<EditCardDetailsDialouge> createState() =>
      _EditCardDetailsDialougeState();
}

class _EditCardDetailsDialougeState extends State<EditCardDetailsDialouge> {
  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardDescriptionController = TextEditingController();
  String? listValue;

  final HapticController hapticController = Get.put(HapticController());

  TextEditingController titleCont = TextEditingController();

  @override
  initState() {
    if (widget.taskName != null) {
      cardNameController.text = widget.taskName!;
    }
    if (widget.taskDescription != null) {
      cardDescriptionController.text = widget.taskDescription!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(); /* GetBuilder<TaskController>(
      builder: (controller) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? (isVertical ? 0.2.w : 0.33.w) : 0.04.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            /* height:isTablet
                        ? 0.45.h
                        : 0.40.h,*/
            child: Padding(
              padding: EdgeInsets.all(
                  isTablet ? (isVertical ? 0.015.h : 0.015.w) : 0.04.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 0.01.h),
                      child: CustomRowWithIcons(
                       // boardModel: widget.boardModel,
                        iconPath: "assets/icons/editIconReq.svg",
                        title: widget.title.tr,
                        hideDelete: true,
                        onArrowPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    if (widget.taskName != null)
                      ColumnRequestData(
                        fillColor: Colors.transparent,
                        title: "Task Name",
                        isRequired: true,
                        isTextField: true,
                        hint: "Text here",
                        isOptional: false,
                        isExpanded: true,
                        isPriority: false,
                        hasPrefix: true,
                        textController: cardNameController,
                        controllerState: (value) {
                          setState(() {
                            print('value description ${value!}');
                          });
                        },
                        maxlength: 120,
                      ),
                    SizedBox(
                      height: height,
                    ),
                    if (widget.taskDescription != null)
                      ColumnRequestData(
                        title: "Description",
                        isTextField: true,
                        isPriority: false,
                        hint: "Text here",
                        fillColor: themeController.currentTheme ==
                                AppColors.lightTheme
                            ? AppColors.colorLightGrey
                            : AppColors.colorBlack,
                        isOptional: false,
                        isExpanded: true,
              isDescription: true,
                        textController: cardDescriptionController,
                        // textController: widget.isGroupEdit == true
                        //     ? null
                        //     : desciption,
                        maxlines: 2,
                        controllerfinishState: (value) {},

                        controllerState: (value) {
                          setState(() {
                            print('value description ${value!}');
                          });
                        },
                        maxlength: 600,
                      ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.02.h),
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.0.h),
                        child: ReusableElevatedButton(
                          buttonText: 'Save'.tr,
                          onPressed: () async {
                            widget.onPressed();
                            hapticController.triggerHapticFeedback(
                                vibration: VibrateType.heavyImpact,
                                hapticFeedback: HapticFeedback.heavyImpact);

                            if (widget.taskDescription != null &&
                                controller.isFieldValid(
                                    cardDescriptionController.text)) {
                              await controller.updateCard(
                                boardModel: widget.boardModel,
                                cardModel: widget.cardModel!,
                                board: widget.board!,
                                cardDescription: cardDescriptionController.text,
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ResponseDialog(
                                    title: "Successful".tr,
                                    subtitle:
                                        "Card Description Updated Successfully"
                                            .tr,
                                    lottieAsset: "assets/images/correct.json",
                                  );
                                },
                              );
                            } else if (widget.taskName != null &&
                                controller
                                    .isFieldValid(cardNameController.text)) {
                              await controller.updateCard(
                                boardModel: widget.boardModel,
                                cardModel: widget.cardModel!,
                                board: widget.board!,
                                cardName: cardNameController.text,
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ResponseDialog(
                                    title: "Successful".tr,
                                    subtitle:
                                        "Card Name Updated Successfully".tr,
                                    lottieAsset: "assets/images/correct.json",
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const ResponseDialog(
                                    title: "Failure",
                                    subtitle: "Please Fill The Field",
                                    lottieAsset: "assets/images/error.json",
                                  );
                                },
                              );
                            }

                            setState(() {});
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  */ }
}
