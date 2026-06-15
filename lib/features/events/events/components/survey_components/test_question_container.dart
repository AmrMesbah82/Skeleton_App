import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/events/components/survey_components/multiple_choice_item.dart';
import 'package:demo_app/features/events/components/survey_components/radio_button_item.dart';

class TestQuestionContainer extends StatefulWidget {
  TestQuestionContainer(
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
  TextEditingController mcqAnswer;
  bool? isRequired;

  TextEditingController textAnswer;
  bool isDisabled;
  ValueChanged<String?> mcqAnswerState;

  @override
  State<TestQuestionContainer> createState() => _TestQuestionContainerState();
}

class _TestQuestionContainerState extends State<TestQuestionContainer> {
  List<String> words = [];
  // String? selectedMcqAnswer;
  late TextEditingController localTextController;
  String? selectedMcqAnswer;
  String? selectedMcqAnswerDropDown;

  @override
  void initState() {
    super.initState();
    localTextController = TextEditingController(text: widget.textAnswer.text);
    selectedMcqAnswer = widget.mcqAnswer.text;
    print(widget.qusestionType);
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

    List<String> temp = widget.qusestionType == "True Or False".toLowerCase()
        ? ['True'.tr, 'False'.tr]
        : widget.choices!
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
            border: Border.all(color: Colors.transparent)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 0.02.h, horizontal: isTablet ? 0.015.w : 0.04.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 0.9.w,
                child: RichText(
                    text: TextSpan(
                        text: widget.question.tr,
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: isPortrait
                                ? FontConstants.fontSize019.h
                                : FontConstants.fontSize022.h,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.inverseSurface,
                            height: 1.6),
                        children: [
                      WidgetSpan(
                          child: SizedBox(
                        width: 0.01.w,
                      )),
                      widget.isRequired == true
                          ? TextSpan(
                              text: "*".tr,
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isPortrait
                                    ? FontConstants.fontSize018.h
                                    : FontConstants.fontSize014.w,
                                fontWeight: FontWeight.w600,
                                color: MyThemeData.delete,
                              ))
                          : const WidgetSpan(child: SizedBox.shrink()),
                    ])),
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
                child: widget.qusestionType.toLowerCase() ==
                            "Multiple Choice".toLowerCase() ||
                        widget.qusestionType.toLowerCase() ==
                            "Drop Menu".toLowerCase() ||
                        widget.qusestionType.toLowerCase() ==
                            "True Or False".toLowerCase()
                    ? widget.qusestionType.toLowerCase() ==
                            "Drop Menu".toLowerCase()
                        ? CustomDropdownButton2(
                            hint: "Answer",
                            value: selectedMcqAnswerDropDown,
                            buttonHeight: 0.05.h,
                            dropdownWidth: 0.83.w,
                            dropdownItems: words,
                            itemPadding:
                                EdgeInsets.symmetric(horizontal: 0.02.w),
                            buttonPadding:
                                EdgeInsets.symmetric(horizontal: 0.02.w),
                            onChanged: widget.isDisabled
                                ? (value) {}
                                : (value) {
                                    setState(() {
                                      selectedMcqAnswerDropDown = value;
                                    });
                                  })
                        : Column(
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
                                      right:
                                          Get.locale.toString().contains('en')
                                              ? 0
                                              : 0.005.w,
                                    ),
                                    child: widget.qusestionType.toLowerCase() ==
                                            "Multiple Choice".toLowerCase()
                                        ? Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 0.02.h),
                                            child: MultipleChoiceItem(
                                              isSelected: widget.mcqAnswer.text
                                                  .contains(words[index]),
                                              label: words[index],
                                              onTap: widget.isDisabled
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        if (widget
                                                            .mcqAnswer.text
                                                            .contains(
                                                                words[index])) {
                                                          List<String> temp =
                                                              widget.mcqAnswer
                                                                  .text
                                                                  .split(',');
                                                          temp.remove(
                                                              words[index]);
                                                          widget.mcqAnswer
                                                                  .text =
                                                              temp.join(',');
                                                          widget.mcqAnswerState(
                                                              widget.mcqAnswer
                                                                  .text);
                                                        } else {
                                                          // selectedMcqAnswer =
                                                          //     words[index];
                                                          widget.mcqAnswer
                                                                  .text +=
                                                              words[index];
                                                          widget.mcqAnswer
                                                              .text += ",";
                                                          widget.mcqAnswerState(
                                                              widget.mcqAnswer
                                                                  .text);
                                                        }
                                                      });
                                                    },
                                            ),
                                          )
                                        : RadioButtonitem(
                                            isDisabled: widget.isDisabled,
                                            label: words[index].tr,
                                            connectionType: words[index].tr,
                                            type: selectedMcqAnswer != null
                                                ? selectedMcqAnswer!.tr
                                                : selectedMcqAnswer,
                                            typeStateChanged: (value) {
                                              setState(() {
                                                selectedMcqAnswer = value;
                                                widget.mcqAnswer.text = value!;
                                                widget.mcqAnswerState(
                                                    widget.mcqAnswer.text);
                                                print(
                                                    "${widget.mcqAnswer.text}-----------------------------------");
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
                            child: TextFormField(
                              controller: localTextController,
                              enabled: !widget.isDisabled,
                              onChanged: (value) {
                                setState(() {
                                  localTextController.text = value;
                                  widget.textAnswer.text = value;
                                });
                              },
                              maxLength: 50,
                              cursorColor: MyThemeData.signOut,
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                  fontSize: isTablet
                                      ? isPortrait
                                          ? FontConstants.fontSize018.h
                                          : FontConstants.fontSize014.w
                                      : FontConstants.fontSize018.h,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface),
                              decoration: InputDecoration(
                                hintText: widget.hintText.tr,
                                counter: const SizedBox.shrink(),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: MyThemeData.signOut)),
                                hintStyle: AppFontStyle.cairoRegularStyle
                                    .copyWith(
                                        fontSize: isTablet
                                            ? isPortrait
                                                ? FontConstants.fontSize018.h
                                                : FontConstants.fontSize014.w
                                            : FontConstants.fontSize016.h,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .scrim),
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
