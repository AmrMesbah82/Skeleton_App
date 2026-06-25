import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_font_size.dart';import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/core/theme/app_colors.dart';

// ignore: must_be_immutable
// ignore: must_be_immutable
class CustomTextFieldContainer extends StatefulWidget {
  CustomTextFieldContainer({
    super.key,
    this.maxLength,
    required this.hint,
    this.hasPrefix = false,
    this.prefixIcon,
    this.heightField,
    this.hasSuffix = false,
    this.suffixUrl,
    this.textController,
    this.fillColor,
    this.controllerState,
    this.sizerSuffix,
    this.validator,
    this.suffixHasColor = true,
    this.hassSuffixState,
    this.enabled = true,
    this.readOnly,
    this.initialValue,
    this.maxLines,
    this.controllerfinishState,
    this.showBorder = false,
    this.showLengthCounter = false,
  });

  final String hint;
  TextEditingController? textController;
  ValueChanged<String?>? controllerState;
  ValueChanged? controllerfinishState;
  final bool? hasPrefix;
  final Widget? prefixIcon;
  final int? maxLength;
  bool? hasSuffix;
  String? Function(String?)? validator;
  ValueChanged<bool?>? hassSuffixState;
  final String? suffixUrl;
  final String? initialValue;
  final Color? fillColor;
  final double? sizerSuffix;
  final double? heightField;
  final bool? suffixHasColor;
  final bool? readOnly;
  final int? maxLines;
  bool enabled;
  final bool showBorder;
  final bool showLengthCounter;

  @override
  State<CustomTextFieldContainer> createState() =>
      _CustomTextFieldContainerState();
}

class _CustomTextFieldContainerState extends State<CustomTextFieldContainer> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.controllerfinishState?.call(widget.textController);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final orientation = MediaQuery.of(context).orientation;

    OutlineInputBorder buildBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: widget.showBorder
            ? Theme.of(context).colorScheme.scrim
            : Colors.transparent,
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0.h),
      child: Stack(
        children: [
          TextFormField(
            focusNode: _focusNode,
            initialValue: widget.initialValue,
            maxLines: widget.maxLines ?? 1,
            readOnly: widget.readOnly ?? false,
            controller: widget.textController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              filled: true,
              enabled: widget.enabled,
              hintText: widget.hint.tr,
              fillColor: widget.fillColor,
              counter: widget.showLengthCounter
                  ? Text(
                '${widget.hint.length}/${widget.maxLength}',
                style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: FontConstants.fontSize012.h,
                  color: AppColors.colorGrey,
                ),
              )
                  : const SizedBox.shrink(),
              counterStyle: AppTextStyles.font16BlackRegularCairo.copyWith(
                fontSize: orientation == Orientation.portrait
                    ? FontConstants.fontSize012.h
                    : FontConstants.fontSize018.h,
                color: AppColors.colorGrey,
              ),
              prefixIcon: widget.hasPrefix == true ? widget.prefixIcon : null,
              suffixIcon: widget.hasSuffix!
                  ? GestureDetector(
                onTap: () {
                  setState(() {
                    widget.textController?.clear();
                    widget.hasSuffix = false;
                    widget.hassSuffixState?.call(false);
                  });
                },
                child: Transform.scale(
                  scale: widget.sizerSuffix ?? 0.6,
                  child: SvgPicture.asset(
                    widget.suffixUrl ?? '',
                    color: widget.suffixHasColor == false
                        ? null
                        : Theme.of(context)
                        .colorScheme
                        .scrim
                        .withOpacity(0.6),
                  ),
                ),
              )
                  : null,
              hintStyle: AppTextStyles.font12BlackCairoRegular,
              border: buildBorder(),
              enabledBorder: buildBorder(),
              disabledBorder: buildBorder(),
              errorBorder: buildBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isTablet ? 0.012.w : 0.02.w,
                vertical: 0.01.h,
              ),
            ),
            showCursor: true,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              color: Theme.of(context).colorScheme.onInverseSurface,
              height: isTablet ? null : 1.7,
              fontSize: isTablet
                  ? FontConstants.fontSize021.h
                  : FontConstants.fontSize016.h,
            ),
            onChanged: (value) {
              setState(() {
                widget.hasSuffix = value.isNotEmpty;
                widget.hassSuffixState?.call(widget.hasSuffix);
                widget.controllerState?.call(value);
              });
            },
            onFieldSubmitted: (value) {
              setState(() {
                widget.controllerfinishState?.call(widget.textController);
              });

            },
            cursorColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}


