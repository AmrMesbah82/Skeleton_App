import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/main_helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/helper/events/components/survey_components/custom_textfield_container.dart';

class DropDownWidget extends StatefulWidget {
  final List<TextEditingController> controllers;
  String onCorrectAnswerSelected;
  final ValueChanged<String>? onAnswerChanged;

  DropDownWidget({
    super.key,
    required this.controllers,
    required this.onCorrectAnswerSelected,
    this.onAnswerChanged,
  });

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  List<String> options = [];
  List<bool> isSelected = [];
  int? correctAnswerIndex;

  @override
  void initState() {
    if (widget.controllers.isNotEmpty) {
      for (int i = 0; i < widget.controllers.length; i++) {
        options.add(widget.controllers[i].text);
        isSelected.add(false);
        if (widget.controllers[i].text == widget.onCorrectAnswerSelected &&
            widget.onCorrectAnswerSelected != "") {
          correctAnswerIndex = i;
          isSelected[i] = true;
        }
      }
    } else {
      widget.controllers.add(TextEditingController());
      options.add("${"Option".tr} 1");
      isSelected.add(false);
    }
    super.initState();
  }

  void addOption() {
    setState(() {
      options.add("${"Option".tr} ${options.length + 1}");
      widget.controllers.add(TextEditingController());
      isSelected.add(false);
    });
  }

  void removeOption(int index) {
    setState(() {
      options.removeAt(index);
      widget.controllers.removeAt(index);
      isSelected.removeAt(index);
    });
  }

  void handleSelection(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
      correctAnswerIndex = index;
      widget.onCorrectAnswerSelected =
          widget.controllers[correctAnswerIndex!].text;
      widget.onAnswerChanged!(widget.onCorrectAnswerSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    double? textFieldHeight = isTablet ? (isPortrait ? 0.045.h : null) : null;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.02.h),
      child: Column(
        children: [
          ListView.builder(
padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Text(
                        Get.locale.toString().contains('en')
                            ? "${index + 1}."
                            : "${convertNumberToArabic((index + 1).toString())}.",
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                          height: 1.6,
                          fontSize: isTablet
                              ? (isPortrait
                                  ? FontConstants.fontSize016.h
                                  : FontConstants.fontSize020.h)
                              : FontConstants.fontSize020.h,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightPrimary,
                        ),
                      ),
                      SizedBox(
                        width:
                            isTablet ? (isPortrait ? 0.04.w : 0.02.w) : 0.02.w,
                      ),
                      SizedBox(
                        width: isTablet ? 0.52.w : 0.55.w,
                        child: CustomTextFieldContainer(
                          textFieldHeight: textFieldHeight,
                          isPayment: isTablet && isPortrait ? true : null,
                          hint: Get.locale.toString().contains('en')
                              ? "${'Option'.tr} ${index + 1}"
                              : "اختيار ${convertNumberToArabic("${index + 1}")}",
                          textController: widget.controllers[index],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          removeOption(index);
                        },
                        child: SvgPicture.asset(
                          "assets/icons/trashIcon.svg",
                          color: AppColors.colorRed,
                          height: isTablet
                              ? (isPortrait ? 0.035.w : 0.02.w)
                              : 0.025.h,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 0.02.h,
                  ),
                ],
              );
            },
          ),
          InkWell(
            onTap: addOption,
            child: Row(
              children: [
                Transform.scale(
                  scale: 0.7,
                  child: SvgPicture.asset(
                    "assets/icons/circle.svg",
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    height: isTablet ? (isPortrait ? 0.04.w : 0.02.w) : 0.05.w,
                  ),
                ),
                SizedBox(
                  width: isTablet ? (isPortrait ? 0.02.w : 0.01.w) : 0.02.w,
                ),
                Text(
                  "Add New Option".tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                    height: 1.6,
                    fontSize: isTablet
                        ? (isPortrait
                            ? FontConstants.fontSize016.h
                            : FontConstants.fontSize020.h)
                        : FontConstants.fontSize020.h,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
