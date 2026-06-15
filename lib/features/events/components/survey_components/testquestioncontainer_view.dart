import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/theme/font_manager.dart';

import 'package:demo_app/core/theme/my_theme.dart';

import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/events/components/survey_components/radio_button_item.dart';

class TestQuestionContainerView extends StatefulWidget {
  TestQuestionContainerView(
      {super.key,
      required this.mcqAnswer,
      required this.hintText,
      required this.question,
      required this.hasPhoto,
      required this.qusestionType,
      required this.imagepath,
      required this.isRequired,
      required this.textAnswer,
      required this.mcqAnswerState,
      this.isDisabled = false,
      this.choices});
  final String hintText;
  final String question;
  final String qusestionType;
  final bool hasPhoto;
  final String? imagepath;
  final String? choices;
  String? mcqAnswer;
  bool? isRequired;

  TextEditingController textAnswer;
  bool isDisabled;
  ValueChanged<String?> mcqAnswerState;

  @override
  State<TestQuestionContainerView> createState() =>
      _TestQuestionContainerViewState();
}

class _TestQuestionContainerViewState extends State<TestQuestionContainerView> {
  List<String> words = [];
  // String? selectedMcqAnswer;
  late TextEditingController localTextController;
  String? selectedMcqAnswer;

  @override
  void initState() {
    super.initState();
    localTextController = TextEditingController(text: widget.textAnswer.text);
    selectedMcqAnswer = widget.mcqAnswer;
  }

  @override
  // void dispose() {
  //   localTextController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    List<String> temp = widget.choices!
        .split(',')
        .map((word) => word.trim())
        .where((word) => word.isNotEmpty)
        .toList();
    words.assignAll(temp);

    if (widget.qusestionType == "True Or False") {
      words.assignAll(["True", "False"]);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 0.015.h),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.02.h, horizontal: 0.015.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 0.9.w,
                child: Text(
                  widget.question,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isTablet
                          ? isPortrait
                              ? FontConstants.fontSize018.h
                              : FontConstants.fontSize014.w
                          : FontConstants.fontSize018.h,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
              ),
              SizedBox(
                height: isTablet ? 0.02.h : 0.01.h,
              ),
              SizedBox(
                width: isTablet
                    ? widget.hasPhoto
                        ? 0.85.w
                        : 0.3.w
                    : double.infinity,
                child: widget.qusestionType == "Multiple Choice" ||
                        widget.qusestionType == "Drop Menu" ||
                        widget.qusestionType == "True Or False"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: words.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 0.005.w,
                                  right: Get.locale.toString().contains('en')
                                      ? 0
                                      : 0.005.w,
                                ),
                                child: RadioButtonitem(
                                  isDisabled: widget.isDisabled,
                                  label: words[index].tr,
                                  connectionType: words[index].tr,
                                  type: selectedMcqAnswer,
                                  typeStateChanged: (value) {
                                    setState(() {
                                      selectedMcqAnswer = value;
                                      widget.mcqAnswer = value;
                                      widget.mcqAnswerState(widget.mcqAnswer);
                                      print(
                                          "${widget.mcqAnswer}-----------------------------------");
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          widget.imagepath != null
                              ? Image.network(
                                  widget.imagepath!,
                                  width: isTablet ? 0.25.w : 0.4.w,
                                )
                              : const SizedBox.shrink()
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.textAnswer.text,
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isTablet
                                    ? (isPortrait
                                        ? FontConstants.fontSize013.h
                                        : FontConstants.fontSize018.h)
                                    : FontConstants.fontSize016.h,
                                fontWeight: FontWeight.w600,
                                height:
                                    isTablet ? (isPortrait ? 1.6 : 1.6) : 1.2,
                                color: Color(0xFF969696),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 0.06.w,
                          ),
                          widget.imagepath != null
                              ? SizedBox(
                                  child: Image.network(
                                    widget.imagepath!,
                                    width: isTablet ? 0.4.w : 0.4.w,
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
