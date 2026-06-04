import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_text_styles.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';

/// Modified CustomTextFieldContainer with reduced height
// ignore: must_be_immutable
class CustomTextFieldContainer extends StatefulWidget {
  CustomTextFieldContainer({
    super.key,
    this.maxLength,
    required this.hint,
    this.hasPrefix = false,
    this.prefixIcon,
    this.hasSuffix = false,
    this.suffixUrl,
    this.controller,
    this.fillColor,
    this.controllerState,
    this.sizerSuffix,
    this.validator,
    this.suffixHasColor = true,
    this.hassSuffixState,
    this.enabled = true,
    this.readOnly,
    this.suffixColor,
    this.initialValue,
    this.initialValueColor,
    this.maxLines,
    this.minLines,
    this.keyboardType,
    this.buttonHeight,
    this.textDirection,
    this.textAlign,
    this.contentPadding,
    this.isAddNewEmp = false,
    this.errorNotifier,
    this.controllerfinishState,
    this.hasBeenTouched = false,
  });
  bool hasBeenTouched;
  final String hint;
  TextEditingController? controller;
  ValueChanged<String?>? controllerState;
  ValueChanged? controllerfinishState;
  TextInputType? keyboardType;
  final bool? hasPrefix;
  final Widget? prefixIcon;
  final int? maxLength;
  bool? hasSuffix;
  double? buttonHeight;
  String? Function(String?)? validator;
  ValueChanged<bool?>? hassSuffixState;
  final String? suffixUrl;
  final String? initialValue;
  final Color? fillColor;
  final double? sizerSuffix;
  final bool? suffixHasColor;
  final bool? readOnly;
  final int? maxLines;
  final int? minLines;
  final Color? initialValueColor;
  bool enabled;
  bool isAddNewEmp;
  final TextDirection? textDirection;
  final Color? suffixColor;
  ValueNotifier<String>? errorNotifier;
  TextAlign? textAlign;
  EdgeInsets? contentPadding;
  @override
  State<CustomTextFieldContainer> createState() =>
      _CustomTextFieldContainerState();
}

class _CustomTextFieldContainerState extends State<CustomTextFieldContainer> {
  late bool _hasBeenTouched; // State-managed variable

  @override
  void initState() {
    super.initState();
    _hasBeenTouched = widget.hasBeenTouched; // Initialize from widget
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          validator: widget.validator,
          controller: widget.controller,
          textDirection: widget.textDirection,
          textAlign: widget.textAlign ?? TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          initialValue: widget.initialValue,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines ?? 1,
          readOnly: widget.readOnly ?? false,
          onChanged: (value) => setState(() {
            widget.hasBeenTouched = true;
            _hasBeenTouched = true; // Modify STATE variable
          }),
          buildCounter: (
            context, {
            required currentLength,
            required isFocused,
            maxLength,
          }) {
            return Row(
              textDirection: widget.textDirection,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Builder(
                    builder: (context) {
                      if (_hasBeenTouched || widget.hasBeenTouched) {
                        final errorText =
                            widget.validator!(widget.controller!.text);
                        return errorText != null
                            ? Text(
                                errorText,
                                style: AppTextStyles.font10BlackCairoRegular
                                    .copyWith(
                                  fontSize: 13,
                                  color: MyThemeData.colorRed,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : const SizedBox.shrink();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            );
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: widget.keyboardType,
          scrollPadding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).viewInsets.bottom),
          decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            hoverColor: Colors.transparent,
            filled: true,
            fillColor:
                isDark ? MyThemeData.colorBlack : MyThemeData.colorLightGrey,
            enabled: widget.enabled,
            hintText: widget.hint.tr,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            prefixIcon: widget.hasPrefix == true ? widget.prefixIcon : null,
            suffixIcon: widget.hasSuffix == true
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.controller != null) {
                          widget.controller!.text = '';
                        }
                        widget.hasSuffix = false;
                        if (widget.hassSuffixState != null) {
                          widget.hassSuffixState!(widget.hasSuffix);
                        }
                      });
                    },
                    child: widget.suffixUrl == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.all(13),
                            child: SvgPicture.asset(
                              height: 14,
                              width: 14,
                              widget.suffixUrl ?? '',
                              color: widget.suffixColor ??
                                  (widget.controller?.text.isNotEmpty == true
                                      ?
                                      // isDark
                                      //     ? Theme.of(context)
                                      //         .colorScheme
                                      //         .onInverseSurface:
                                      MyThemeData.colorWhite
                                      :
                                      // isDark? Theme.of(context)
                                      //         .colorScheme
                                      //         .scrim
                                      //         .withOpacity(0.6):
                                      MyThemeData.colorGrey),
                            ),
                          ),
                  )
                : null,
            hintTextDirection: widget.textDirection ?? TextDirection.ltr,
            hintStyle: AppTextStyles.font10BlackCairoRegular.copyWith(
                color: isDark ? AppColors.mediumGrey : AppColors.inverseBase,
                height: 1,
                fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: MyThemeData.lightPrimary),
            ),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent)),
            isDense: true,
          ),
          showCursor: true,
          style: AppTextStyles.font10BlackCairoRegular.copyWith(
            fontSize: 14,
            height: 1.5,
            color: AppColors.text,
          ),
          cursorWidth: 2,
        ),
      ],
    );
  }
}
