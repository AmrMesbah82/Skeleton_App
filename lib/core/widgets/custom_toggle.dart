// last edit 8/8/2023 by mazen
// ignore_for_file: must_be_immutable, unused_field, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


import 'package:demo_app/core/theme/app_font_size.dart';

class CustomToggle extends StatefulWidget {
  final String? toggleName;
  final bool isExpanded;
  final VoidCallback onToggleChanged;
  final VoidCallback onExpand;
  final Color? fillColor;
  final VoidCallback onCollapse;
  final bool horizontalMargin;
  final bool? isEdit;
  final bool? borded;
  final TextStyle? hintStyle;
  final bool? enabled;
  final int? length;
  final Color? counterStyle;
  final double sizeMultiplicationFactor;
  TextEditingController? textController;
  final bool showHint;
  Function()? onChanged;
  final String? hint;
  final bool isCreateService;
  // ignore: non_constant_identifier_names
  final double? ContainerWidth;
  CustomToggle({
    Key? key,
    this.isEdit,
    this.toggleName,
    this.enabled,
    required this.isExpanded,
    required this.onToggleChanged,
    this.horizontalMargin = true,
    required this.onExpand,
    this.counterStyle,
    this.hintStyle,
    // ignore: non_constant_identifier_names
    this.ContainerWidth,
    this.borded,
    this.length,
    this.hint,
    this.sizeMultiplicationFactor = 1,
    this.showHint = true,
    required this.onCollapse,
    this.isCreateService = false,
    this.fillColor,
    this.onChanged,
    required this.textController,
  }) : super(key: key);

  @override
  CustomToggleState createState() => CustomToggleState();
}

class CustomToggleState extends State<CustomToggle> {
  double radius = 8;
  final FocusNode _focusNode = FocusNode();
  bool filled = false;
  Color _borderColor = AppColors.colorGrey;
  void toggle() {
    setState(() {
      widget.onToggleChanged();
    });
  }

  void expand() {
    setState(() {
      widget.onExpand();
    });
  }

  void collapse() {
    setState(() {
      widget.onCollapse();
    });
  }

  @override
  Widget build(BuildContext context) {
    _borderColor = widget.isEdit == true
        ? Theme.of(context).colorScheme.onInverseSurface
        : AppColors.colorGrey;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.toggleName != null)
          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.toggleName!,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: FontConstants.fontSize028.h,
                  color: Theme.of(context).colorScheme.inverseSurface,
                  height: 1.3,
                  // change the text color based on toggle state
                  fontWeight: FontWeight.w500,
                ),
              ),
              SvgPicture.asset(
                'assets/icons/question.svg',
                color: Theme.of(context).colorScheme.onInverseSurface,
              )
            ],
          ),
        Padding(
          padding: EdgeInsets.only(
              top: isTablet == false && widget.isCreateService == true ? 0 : 0),
          child: Column(
            children: [
              // const SizedBox(height: 12),
              Focus(
                focusNode: _focusNode,
                onFocusChange: (hasFocus) {
                  setState(() {
                    // filled==true?_borderColor= AppColors.colorBlack :
                    _borderColor = _focusNode.hasFocus
                        ? AppColors.lightPrimary
                        : AppColors.colorGrey;
                  });
                },
                child: Padding(
                  padding: widget.horizontalMargin
                      ? EdgeInsets.symmetric(horizontal: 0.009.w)
                      : const EdgeInsets.all(0),
                  child: Container(
                    height: 0.23.h * widget.sizeMultiplicationFactor,
                    width: widget.ContainerWidth ?? 0.95.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: widget.fillColor ??
                            Theme.of(context).colorScheme.background,
                        border: widget.borded == true
                            ? Border.all(
                                color: Theme.of(context).colorScheme.scrim,
                                width: 1)
                            : Border.all(
                                color: Colors
                                    .transparent, //AppColors.colorGrey /*AppColors.colorBlack*/,
                                width: 1),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0.0.h, 0.01.h),
                            color: AppColors.colorGrey.withOpacity(0.05),
                            blurRadius: 18,
                          )
                        ]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.002.w, vertical: 0.008.h),
                      child: TextField(
                        enabled: widget.enabled,
                        maxLength: widget.length ?? 200,
                        onEditingComplete: widget.onChanged ?? () {},
                        onChanged: (value) {
                          setState(() {
                            value != '' ? filled = true : filled = false;
                          });

                          print(value);
                        },
                        controller: widget.textController,
                        decoration: InputDecoration(
                          hintText: widget.isExpanded
                              ? 'Describe Your Service..'.tr
                              : widget.hint,
                          fillColor: widget.fillColor ??
                              Theme.of(context).colorScheme.background,
                          counterStyle: widget.hintStyle ??
                              AppFontStyle.cairoRegularStyle.copyWith(
                                  fontSize: FontConstants.fontSize015.h,
                                  fontWeight: FontWeight.w500,
                                  color: widget.counterStyle ??
                                      AppColors.colorGreydark),
                          hintStyle: widget.hintStyle ??
                              AppFontStyle.cairoRegularStyle.copyWith(
                                  fontSize: isPortrait == true
                                      ? FontConstants.fontSize018.h
                                      : FontConstants.fontSize020.h,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer),
                          border: InputBorder.none,

                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0.01.h,
                            horizontal: 0.015.w,
                          ), // vertical padding added for cursor position
                          filled: true,
                        ),
                        maxLines: 10,
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                            color:
                                Theme.of(context).colorScheme.onInverseSurface,
                            fontSize: FontConstants.fontSize020.h,
                            fontWeight: FontWeight.w500),
                        textAlignVertical: TextAlignVertical.center,
                        cursorHeight: 0.020.h,
                        cursorWidth: 0.002.w,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomToggle2 extends StatefulWidget {
  final String toggleName;
  final bool isExpanded;
  final VoidCallback onToggleChanged;
  final VoidCallback onExpand;
  final VoidCallback onCollapse;

  CustomToggle2({
    Key? key,
    required this.toggleName,
    required this.isExpanded,
    required this.onToggleChanged,
    required this.onExpand,
    required this.onCollapse,
  })  : textController = TextEditingController(),
        super(key: key);

  final TextEditingController textController;

  @override
  CustomToggleState2 createState() => CustomToggleState2();
}

class CustomToggleState2 extends State<CustomToggle2> {
  bool _isToggled = false;

  void toggle() {
    setState(() {
      _isToggled = !_isToggled;
      widget.onToggleChanged();
    });
  }

  void expand() {
    setState(() {
      widget.onExpand();
    });
  }

  void collapse() {
    setState(() {
      widget.onCollapse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: toggle,
              child: Image.asset(
                _isToggled
                    ? 'assets/icons/CheckListOn.png'
                    : 'assets/icons/CheckListOff.png',
                width: 0.070.w,
                height: 0.040.h,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.toggleName,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: FontConstants.fontSize020.h,
                  color: AppColors.colorBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        if (_isToggled)
          Column(
            children: [
              const SizedBox(height: 12),
              TextField(
                maxLength: 300,
                controller: widget.textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 66, horizontal: 12),
                ),
                maxLines: null,
                style:   AppFontStyle.cairoRegularStyle.copyWith(fontSize: 16),
              ),
              //SizedBox(height: 12),
              /*ElevatedButton(
                onPressed: () {
                  // Save button on press function
                },
                child: Text('Save'),
              ),*/
            ],
          ),
      ],
    );
  }
}
