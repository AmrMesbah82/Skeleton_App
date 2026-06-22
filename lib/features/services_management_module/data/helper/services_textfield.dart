import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_app/core/custom/2-custom_textfield.dart';

/// Module-local wrapper that keeps the full `CustomValidatedTextFieldInv`
/// call-site API used across the services module, while rendering the core
/// [CustomTextField] (lib/core/custom/2-custom_textfield.dart) underneath.
/// Bundled so the module is self-contained and the same fix applies in every app.
class CustomValidatedTextFieldInv extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final double height;
  final double? width;
  final int maxLines;
  final bool enabled;
  final bool showCharCount;
  final ValueChanged<String>? onChanged;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final bool onlyDigits;
  final bool submitted;
  final TextStyle? textStyle;
  final double? fontSize;
  final Color? fillColor;
  final String? errorText;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;

  // SVG prefix icon parameters
  final String? prefixSvgAsset;
  final double? prefixIconWidth;
  final double? prefixIconHeight;
  final EdgeInsetsGeometry? prefixPadding;
  final VoidCallback? onPrefixTap;
  final BoxConstraints? prefixConstraints;

  final int? maxLength;
  final List<TextInputFormatter>? additionalInputFormatters;
  final bool autoCapitalize;
  final ValueChanged<String>? onFieldSubmitted;

  const CustomValidatedTextFieldInv({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.height = 36,
    this.width,
    this.maxLines = 1,
    this.enabled = true,
    this.showCharCount = false,
    this.onChanged,
    this.textDirection = TextDirection.ltr,
    this.textAlign = TextAlign.start,
    this.onlyDigits = false,
    this.submitted = false,
    this.textStyle,
    this.fontSize,
    this.fillColor,
    this.errorText,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
    this.prefixSvgAsset,
    this.prefixIconWidth,
    this.prefixIconHeight,
    this.prefixPadding,
    this.onPrefixTap,
    this.prefixConstraints,
    this.maxLength = 500,
    this.additionalInputFormatters,
    this.autoCapitalize = true,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = (controller?.text ?? '').trim().isEmpty;
    final String? error =
        errorText ?? ((submitted && isEmpty) ? 'This field is required' : null);

    TextStyle? valueStyle = textStyle;
    if (fontSize != null) {
      valueStyle = (valueStyle ?? const TextStyle()).copyWith(fontSize: fontSize);
    }

    final List<TextInputFormatter> formatters = <TextInputFormatter>[
      if (onlyDigits) FilteringTextInputFormatter.digitsOnly,
      ...?additionalInputFormatters,
    ];

    Widget? prefixIcon;
    if (prefixSvgAsset != null) {
      Widget svg = SvgPicture.asset(
        prefixSvgAsset!,
        width: prefixIconWidth,
        height: prefixIconHeight,
      );
      if (prefixPadding != null) svg = Padding(padding: prefixPadding!, child: svg);
      if (onPrefixTap != null) {
        svg = GestureDetector(onTap: onPrefixTap, child: svg);
      }
      prefixIcon = svg;
    }

    Widget field = CustomTextField(
      controller: controller,
      label: label,
      hint: hint,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: showCharCount ? maxLength : null,
      errorText: error,
      textAlign: textAlign,
      textDirection: textDirection,
      onChanged: onChanged,
      onSubmitted: onFieldSubmitted,
      onTap: onTap,
      fillColor: fillColor,
      valueStyle: valueStyle,
      prefixIcon: prefixIcon,
      textCapitalization:
          autoCapitalize ? TextCapitalization.words : TextCapitalization.none,
      keyboardType: onlyDigits ? TextInputType.number : keyboardType,
      inputFormatters: formatters.isEmpty ? null : formatters,
    );

    if (width != null) {
      field = SizedBox(width: width, child: field);
    }
    return field;
  }
}
