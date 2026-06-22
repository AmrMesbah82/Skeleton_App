import 'package:flutter/material.dart';
import 'package:demo_app/core/custom/1-custom_dropdwon.dart';

/// Module-local wrappers that preserve the call-site APIs of the old
/// `CustomDropdownFormFieldInvMaster` / `CustomDropdownFormFieldFinal`
/// widgets, while rendering the core [CustomDropdown] from
/// lib/core/custom/1-custom_dropdwon.dart. Bundled so the services module is
/// self-contained and the same fix applies in every app.

List<DropdownItem<String>> _toDropdownItems(List<Map<String, String>> items) {
  return items.map((m) {
    final value = m['key'] ?? m['value'] ?? m['id'] ?? (m.values.isNotEmpty ? m.values.first : '');
    final label = m['value'] ?? m['name'] ?? m['label'] ?? value ?? '';
    return DropdownItem<String>(value: value ?? '', label: label);
  }).toList();
}

String? _hintText(Widget? hint) => hint is Text ? hint.data : null;

class CustomDropdownFormFieldInvMaster extends StatelessWidget {
  final String? selectedValue;
  final List<Map<String, String>> items;
  final void Function(String?)? onChanged;
  final double? widthIcon;
  final double? heightIcon;
  final String? Function(String?)? validator;
  final double? width;
  final double? height;
  final double? spaceHeight;
  final double? dropdownWidth;
  final Widget? hint;
  final Color? dropdownColor;
  final String? label;
  final String? iconPath;
  final bool isEditable;
  final String? firestoreCategory;
  final Map<String, Color>? itemColors;
  final bool showColorDots;
  final double borderRadius;

  const CustomDropdownFormFieldInvMaster({
    super.key,
    this.selectedValue,
    this.items = const [],
    this.onChanged,
    this.widthIcon,
    this.heightIcon,
    this.validator,
    this.width,
    this.height,
    this.spaceHeight,
    this.dropdownWidth,
    this.hint,
    this.dropdownColor,
    this.label,
    this.iconPath,
    this.isEditable = false,
    this.firestoreCategory,
    this.itemColors,
    this.showColorDots = false,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget dd = CustomDropdown<String>(
      value: (selectedValue != null && selectedValue!.isNotEmpty) ? selectedValue : null,
      items: _toDropdownItems(items),
      hint: _hintText(hint) ?? (label?.isNotEmpty == true ? label : null),
      label: (label?.isNotEmpty == true) ? label : null,
      fillColor: dropdownColor,
      borderRadius: BorderRadius.circular(borderRadius),
      onChanged: (v) => onChanged?.call(v),
    );
    if (width != null) dd = SizedBox(width: width, child: dd);
    return dd;
  }
}

class CustomDropdownFormFieldFinal extends StatelessWidget {
  final String? selectedValue;
  final List<Map<String, String>> items;
  final void Function(String?)? onChanged;
  final double? widthIcon;
  final double? heightIcon;
  final double? paddingLeft;
  final double? paddingRight;
  final double? width;
  final double? height;
  final double? spaceHeight;
  final Widget? hint;
  final String? label;
  final Color? color;
  final Color? dropdownColor;
  final TextStyle? style;

  const CustomDropdownFormFieldFinal({
    super.key,
    this.selectedValue,
    this.items = const [],
    this.onChanged,
    this.widthIcon,
    this.heightIcon,
    this.paddingLeft,
    this.paddingRight,
    this.width,
    this.height,
    this.spaceHeight,
    this.hint,
    this.label,
    this.color,
    this.dropdownColor,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    Widget dd = CustomDropdown<String>(
      value: (selectedValue != null && selectedValue!.isNotEmpty) ? selectedValue : null,
      items: _toDropdownItems(items),
      hint: _hintText(hint) ?? (label?.isNotEmpty == true ? label : null),
      label: (label?.isNotEmpty == true) ? label : null,
      fillColor: color ?? dropdownColor,
      valueStyle: style,
      onChanged: (v) => onChanged?.call(v),
    );
    if (width != null) dd = SizedBox(width: width, child: dd);
    return dd;
  }
}
