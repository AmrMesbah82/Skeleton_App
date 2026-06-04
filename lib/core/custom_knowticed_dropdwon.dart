import 'package:flutter/material.dart';
import 'package:demo_app/core/widgets/custom_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/knowledge_hub_module/core/theming/new_theme.dart';

import '../features/external/main_core/core/theme/app_colors.dart';
import '../features/external/main_core/core/theme/app_theme.dart';
import '../features/external/main_core/core/theme/new_theme.dart';

/// Enum for supported languages
enum AppLanguage {
  english,
  arabic,
}

/// Custom Dropdown Form Field with Bilingual Support (AR/EN) and Hover Effects
class CustomKnowticedDropdown<T> extends StatefulWidget {
  // Basic Properties
  final String labelEn;
  final String labelAr;
  final String hintEn;
  final String hintAr;
  final List<T> items; // List of items to display
  final String Function(T) itemLabelBuilder; // Function to build label from item
  final T? value;
  final Function(T?)? onChanged;

  // Language & Direction
  final AppLanguage language;
  final TextDirection? textDirection;

  // Styling
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? itemStyle;
  final TextStyle? errorStyle;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double borderRadius;
  final double borderWidth;

  // Hover Colors
  final Color? hoverBackgroundColor; // Default: AppColors.primary
  final Color? hoverTextColor; // Default: AppColors.textButton
  final Color? defaultTextColor; // Default: AppColors.text

  // Icons & Suffixes
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final Color? iconColor;

  // Content Padding
  final EdgeInsets contentPadding;

  // Size Control
  final double? width;
  final double? height;

  // Input Formatters & Validation
  final bool isRequired;
  final String? errorMessage;
  final bool enabled;

  // Error Messages (Bilingual)
  final String? errorMessageRequiredEn;
  final String? errorMessageRequiredAr;

  const CustomKnowticedDropdown({
    Key? key,
    required this.labelEn,
    required this.labelAr,
    required this.hintEn,
    required this.hintAr,
    required this.items,
    required this.itemLabelBuilder,
    this.value,
    this.onChanged,
    this.language = AppLanguage.english,
    this.textDirection,
    this.labelStyle,
    this.hintStyle,
    this.itemStyle,
    this.errorStyle,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderRadius = 8,
    this.borderWidth = 1.5,
    this.hoverBackgroundColor,
    this.hoverTextColor,
    this.defaultTextColor,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.suffixWidget,
    this.iconColor,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.width,
    this.height,
    this.isRequired = false,
    this.errorMessage,
    this.enabled = true,
    this.errorMessageRequiredEn,
    this.errorMessageRequiredAr,
  }) : super(key: key);

  @override
  State<CustomKnowticedDropdown<T>> createState() =>
      _CustomKnowticedDropdownState<T>();
}

class _CustomKnowticedDropdownState<T>
    extends State<CustomKnowticedDropdown<T>> {
  late FocusNode _focusNode;
  String? _errorMessage;
  int? _hoveredIndex;
  final GlobalKey _dropdownKey = GlobalKey();
  double _dropdownWidth = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Get dropdown width after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateDropdownWidth();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// Update dropdown width based on trigger button
  void _updateDropdownWidth() {
    final RenderBox? renderBox =
    _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _dropdownWidth = renderBox.size.width;
      });
    }
  }

  /// Get label based on language
  String get _label {
    return widget.language == AppLanguage.english
        ? widget.labelEn
        : widget.labelAr;
  }

  /// Get hint based on language
  String get _hint {
    return widget.language == AppLanguage.english
        ? widget.hintEn
        : widget.hintAr;
  }

  /// Get text direction based on language
  TextDirection get _textDirection {
    if (widget.textDirection != null) return widget.textDirection!;
    return widget.language == AppLanguage.english
        ? TextDirection.ltr
        : TextDirection.rtl;
  }

  /// Get error message based on language
  String _getErrorMessage(
      String defaultMessageEn, String defaultMessageAr, String? custom) {
    if (widget.language == AppLanguage.english) {
      return custom ?? defaultMessageEn;
    } else {
      return custom ?? defaultMessageAr;
    }
  }

  /// Validate dropdown
  String? _validateDropdown() {
    if (widget.isRequired && widget.value == null) {
      return _getErrorMessage(
        '${widget.labelEn} is required',
        'حقل ${widget.labelAr} مطلوب',
        widget.errorMessageRequiredEn,
      );
    }
    return widget.errorMessage;
  }

  /// Build dropdown menu items with hover effects
  List<PopupMenuEntry<T>> _buildDropdownItems() {
    return List.generate(widget.items.length, (index) {
      final item = widget.items[index];
      final itemLabel = widget.itemLabelBuilder(item);

      return PopupMenuItem<T>(
        value: item,
        padding: EdgeInsets.zero, // ← remove default PopupMenuItem padding
        child: StatefulBuilder(
          builder: (context, setMenuState) {
            bool isHovered = _hoveredIndex == index;
            return MouseRegion(
              onEnter: (_) => setMenuState(() => _hoveredIndex = index),
              onExit: (_) => setMenuState(() => _hoveredIndex = null),
              child: Container(
                width: double.infinity, // ← fill the full row
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                color: isHovered
                    ? (widget.hoverBackgroundColor ?? AppColors.primary)
                    : Colors.transparent,
                child: Text(
                  itemLabel,
                  style: widget.itemStyle ??
                      StyleText.fontSize16Weight500.copyWith(
                        color: isHovered
                            ? (widget.hoverTextColor ?? AppColors.textButton)
                            : (widget.defaultTextColor ?? AppColors.text),
                      ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _errorMessage = _validateDropdown();

    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Directionality(
          textDirection: _textDirection,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Label
              if (_label.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: RichText(
                    textDirection: _textDirection,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _label,
                          style: widget.labelStyle ??
                              TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                        ),
                        if (widget.isRequired)
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              // Dropdown Button
              Flexible(
                child: PopupMenuButton<T>(
                  enabled: widget.enabled,
                  tooltip: '', // Remove tooltip
                  onSelected: (T item) {
                    setState(() {
                      widget.onChanged?.call(item);
                    });
                  },
                  itemBuilder: (BuildContext context) => _buildDropdownItems(),
                  constraints: BoxConstraints(
                    minWidth: _dropdownWidth > 0 ? _dropdownWidth : 200,
                    maxWidth: _dropdownWidth > 0 ? _dropdownWidth : 500,
                  ),
                  child: Container(
                    key: _dropdownKey,
                    padding: widget.contentPadding,
                    decoration: BoxDecoration(
                      color: widget.fillColor ?? Colors.grey[50],
                      border: Border.all(
                        color: _errorMessage != null
                            ? widget.errorBorderColor ?? Colors.red[600]!
                            : _focusNode.hasFocus
                            ? widget.focusedBorderColor ?? Colors.blue[600]!
                            : widget.borderColor ?? Colors.grey[300]!,
                        width: widget.borderWidth,
                      ),
                      borderRadius:
                      BorderRadius.circular(widget.borderRadius.r),
                    ),
                    child: Row(
                      textDirection: _textDirection,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Prefix Icon
                        if (widget.prefixWidget != null)
                          Padding(
                            padding: EdgeInsets.only(
                              right: _textDirection == TextDirection.ltr ? 8.w : 0,
                              left: _textDirection == TextDirection.rtl ? 8.w : 0,
                            ),
                            child: widget.prefixWidget,
                          )
                        else if (widget.prefixIcon != null)
                          Padding(
                            padding: EdgeInsets.only(
                              right: _textDirection == TextDirection.ltr ? 8.w : 0,
                              left: _textDirection == TextDirection.rtl ? 8.w : 0,
                            ),
                            child: Icon(
                              widget.prefixIcon,
                              color: widget.iconColor ?? Colors.grey[600],
                              size: 20.r,
                            ),
                          ),
                        // Selected value or hint
                        Expanded(
                          child: Text(
                            widget.value != null
                                ? widget.itemLabelBuilder(widget.value as T)
                                : _hint,
                            style: widget.value != null
                                ? (widget.itemStyle ??
                                StyleText.fontSize16Weight500.copyWith(
                                  color: widget.defaultTextColor ?? AppColors.text,
                                ))
                                : (widget.hintStyle ??
                                StyleText.fontSize16Weight500.copyWith(
                                  color: Colors.red,
                                )),
                            textDirection: _textDirection,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Suffix Icon (Dropdown Arrow)
                        if (widget.suffixWidget != null)
                          Padding(
                            padding: EdgeInsets.only(
                              left: _textDirection == TextDirection.ltr ? 8.w : 0,
                              right: _textDirection == TextDirection.rtl ? 8.w : 0,
                            ),
                            child: widget.suffixWidget,
                          )
                        else
                          Padding(
                              padding: EdgeInsets.only(
                                left: _textDirection == TextDirection.ltr ? 8.w : 0,
                                right: _textDirection == TextDirection.rtl ? 8.w : 0,
                              ),
                              child: CustomSvg(
                                assetPath: "assets/arrowdown.svg",
                                color: AppColors.secondaryText,
                                width: 15.w,
                                height: 15.h,
                                fit:BoxFit.fill,
                              )

                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Error Message
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Text(
                    _errorMessage!,
                    style: widget.errorStyle ??
                        TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.red[600],
                        ),
                  ),
                ),
            ],
          ),
        ));
  }
}