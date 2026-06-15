/// ******************* FILE INFO *******************
/// File Name: custom_filter.dart
/// Description: this is custom filter can reuse
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025


import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

import '../../theme/app_colors.dart';

class CustomValidatedDropdownNoLable extends StatefulWidget {
  final String? label; // optional
  final String hint;
  final String? selectedValue;
  final List<Map<String, String>> items;
  final Function(String?) onChanged;
  final double height;
  final double? width;
  final bool enabled;
  final TextDirection textDirection;
  final bool submitted;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final String? iconPath;
  final double? iconWidth;
  final double? iconHeight;
  final Color? dropdownColor;
  final double? dropdownWidth;

  const CustomValidatedDropdownNoLable({
    super.key,
    this.label,
    required this.hint,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.height = 36,
    this.width,
    this.enabled = true,
    this.textDirection = TextDirection.ltr,
    this.submitted = false,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.iconPath = 'assets/arrowdown.svg',
    this.iconWidth = 16,
    this.iconHeight = 16,
    this.dropdownColor,
    this.dropdownWidth,
  });

  @override
  State<CustomValidatedDropdownNoLable> createState() => _CustomValidatedDropdownNoLableState();
}

class _CustomValidatedDropdownNoLableState extends State<CustomValidatedDropdownNoLable> {
  String? internalSelectedValue;
  final GlobalKey _dropdownKey = GlobalKey();
  double? _popupWidth;

  @override
  void initState() {
    super.initState();
    internalSelectedValue = widget.selectedValue;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _dropdownKey.currentContext;
      if (context != null && mounted) {
        final box = context.findRenderObject() as RenderBox;
        setState(() {
          _popupWidth = box.size.width;
        });
      }
    });
  }

  @override
  void didUpdateWidget(CustomValidatedDropdownNoLable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      internalSelectedValue = widget.selectedValue;
    }
  }

  String _toArabicNum(int number) {
    const arabicNums = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    return number
        .toString()
        .split('')
        .map((e) => arabicNums[int.parse(e)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabicField = widget.textDirection == TextDirection.rtl;
    final bool isEmpty = internalSelectedValue == null || internalSelectedValue!.trim().isEmpty;

    final bool showError = widget.submitted && isEmpty;

    String errorText = '';
    if (isEmpty) {
      errorText = widget.textDirection == TextDirection.rtl
          ? "هذا الحقل مطلوب"
          : "This field is required.";
    }

    final bool lightMode = Theme.of(context).brightness == Brightness.light;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final double fieldHeight = widget.height.sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            textDirection: widget.textDirection,
            style: AppTextStyles.font14BlackCairoRegular.copyWith(
              color: lightMode ? AppColors.blackButton : AppColors.white,
            ),
          ),
        if (widget.label != null) SizedBox(height: 6.h),

        // Dropdown field
        Container(
          key: _dropdownKey,
          width: widget.width,
          height: fieldHeight,
          decoration: BoxDecoration(
            color: widget.fillColor ?? (lightMode ? AppColors.background : AppColors.background),
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: showError
                  ? AppColors.red
                  : Colors.transparent,
              width: showError ? 1 : 0,
            ),
          ),
          child: FormField<String>(
            initialValue: internalSelectedValue,
            builder: (FormFieldState<String> field) {
              return DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    widget.hint,
                    style: widget.hintStyle ??
                        AppTextStyles.font12BlackCairoRegular.copyWith(
                          color: lightMode ? AppColors.secondaryText : AppColors.grey,
                        ),
                  ),
                  value: internalSelectedValue,
                  onChanged: widget.enabled ? (value) {
                    setState(() {
                      internalSelectedValue = value;
                      field.didChange(value);
                    });
                    widget.onChanged(value);
                  } : null,
                  buttonStyleData: ButtonStyleData(
                    height: fieldHeight,
                    width: widget.width,
                    padding: EdgeInsets.symmetric(horizontal: 8.sp),
                    decoration: BoxDecoration(
                      color: widget.dropdownColor ??
                          (lightMode ? AppColors.background : AppColors.background),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: Colors.transparent),
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    width: widget.dropdownWidth ?? _popupWidth ?? 100.sp,
                    maxHeight: 230.sp,
                    offset: const Offset(0, 0),
                    decoration: BoxDecoration(
                      color: lightMode ? AppColors.white : AppColors.background,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    scrollbarTheme: ScrollbarThemeData(
                      thumbVisibility: MaterialStateProperty.all(false),
                      trackVisibility: MaterialStateProperty.all(false),
                      thickness: MaterialStateProperty.all(0),
                      radius: Radius.zero,
                    ),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    height: fieldHeight,
                    padding: EdgeInsets.symmetric(horizontal: 12.sp),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return AppColors.primary;
                        }
                        return Colors.white;
                      },
                    ),
                  ),
                  iconStyleData: IconStyleData(
                    icon: Padding(
                      padding: EdgeInsets.only(
                        right: isArabic ? 0 : 4.sp,
                        left: isArabic ? 4.sp : 0,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          widget.iconPath ?? 'assets/arrowdown.svg',
                          width: (widget.iconWidth ?? 16).sp,
                          height: (widget.iconHeight ?? 16).sp,
                          fit: BoxFit.scaleDown,
                          color: lightMode ? AppColors.secondaryText : AppColors.whiteShadow,
                        ),
                      ),
                    ),
                  ),
                  style: widget.textStyle ??
                      AppTextStyles.font12BlackCairoRegular.copyWith(
                        color: lightMode ? AppColors.blackButton : AppColors.white,
                      ),
                  items: widget.items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item["key"],
                      child: Text(
                        item["value"] ?? '',
                        textDirection: widget.textDirection,
                        style: widget.textStyle ??
                            AppTextStyles.font12BlackCairoRegular.copyWith(
                              color: lightMode ? AppColors.blackButton : AppColors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),

        // Fixed-height lane: error OR nothing (same as text field)
        SizedBox(
          height: 18.h, // keeps rows aligned with text fields
          child: showError
              ? Padding(
            padding: EdgeInsets.only(top: 4.h, left: 4.w),
            child: Text(
              errorText,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                height: 1.1,
                color: AppColors.red,
              ),
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}