import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../skeleton/roles/presentation/ui/pages/user_management/uoload_file_details.dart';
import '../../main_core/core/theme/app_colors.dart';
import '../../main_core/core/theme/app_text_styles.dart';

class AppMultiSelectDropdown extends StatefulWidget {
    AppMultiSelectDropdown({
    super.key,
    required this.onChanged,
    required this.items,
    required this.textButton,
    required this.selectedItems,
    this.singleSelect = false,
    this.end,
    this.hintText,
    this.value,
    this.customSpacing,
    this.menuWidth,
    this.width,
    this.height,
    this.textColor,
    this.splashColorOn = true,
    this.showDropdownIcon = true,
    this.validator,
    this.fillColor,
    this.svgIconPath,
    this.textStyle,
    this.menuItemHeight,
    this.showErrorBorder = false,
    this.forceDirection,
  });

  final bool singleSelect;
  double? menuItemHeight;
  final Function(dynamic) onChanged;
  final List<String> selectedItems;
  final List<String> items;
  final String? textButton;
  final String? hintText;
  final dynamic value;
  final Widget? customSpacing;
  final bool splashColorOn, showErrorBorder;
  final bool showDropdownIcon;
  final Color? textColor;
  final String? svgIconPath;
  final TextStyle? textStyle;
  final String? Function(dynamic)? validator;
  final double? height, width, menuWidth;
  final double? end;
  final Color? fillColor;
  final TextDirection? forceDirection;

  @override
  State<AppMultiSelectDropdown> createState() => _AppMultiSelectDropdownState();
}

class _AppMultiSelectDropdownState extends State<AppMultiSelectDropdown> {
  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return Directionality(
      textDirection: Localizations.localeOf(context).languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isDense: true,
            items: widget.items.map((item) {
              return DropdownMenuItem(
                value: item,
                enabled: false, // keep false (we handle taps)
                child: StatefulBuilder(
                  builder: (context, menuSetState) {
                    final isSelected = widget.selectedItems.contains(item);
                    return InkWell(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        // Notify parent
                        widget.onChanged(item);

                        // For single select: close menu immediately
                        if (widget.singleSelect) {
                          // Parent will set selectedItems = [item]; we just close.
                          Navigator.pop(context);
                        } else {
                          // Multi-select visual refresh
                          setState(() {});
                          menuSetState(() {});
                        }
                      },
                      child: SizedBox(
                        height: double.infinity,
                        child: Directionality(
                          textDirection: isEnglish
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          child: Row(
                            children: [
                              // Hide checkbox in single-select mode
                              if (!widget.singleSelect)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  child: CustomCheckBox(isSelected: isSelected),
                                ),
                              if (!widget.singleSelect) SizedBox(width: 8.sp),
                              Expanded(
                                child: Text(
                                  item,
                                  style: AppTextStyles
                                      .font12SecondaryBlackCairoRegular,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
            onChanged: (_) {}, // unused; we handle in InkWell
            onMenuStateChange: (isOpen) {
              if (!isOpen) setState(() {});
            },
            customButton: Container(
              decoration: BoxDecoration(
                color: widget.fillColor ?? AppColors.field,
                borderRadius: BorderRadius.circular(4.r),
              ),
              width: widget.width,
              height: 36.h,
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 10.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.svgIconPath != null) _buildIconSection(),
                    // text takes all available space from the START
                    Expanded(child: _buildDropdownText()),
                    if (widget.showDropdownIcon)
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 8.w),
                        child: SvgPicture.asset(
                          "assets/images/arrow_down.svg",
                          height: 7.sp,
                          width: 7.sp,
                          fit: BoxFit.scaleDown,
                          colorFilter: ColorFilter.mode(
                            AppColors.secondaryText,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    if (widget.customSpacing != null) widget.customSpacing!,
                  ],
                ),
              ),
            ),

            menuItemStyleData: MenuItemStyleData(
              height: widget.menuItemHeight ?? 25.h,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              padding: EdgeInsets.symmetric(horizontal: 2.sp),
            ),
            value: widget.value,
            dropdownStyleData: DropdownStyleData(
              width: widget.menuWidth,
              maxHeight: 190.h,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: widget.fillColor ?? AppColors.field,
              ),
            ),
            hint: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.hintText ?? 'Choose Here'.tr,
                  style: AppTextStyles.font12SecondaryBlackCairoRegular,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildDropdownText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          textAlign: TextAlign.start,
          widget.textButton ?? widget.hintText ?? 'Choose here'.tr,
          style: widget.textStyle ?? AppTextStyles.font12BlackCairoRegular,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  SvgPicture _buildIconDropdown() {
    return SvgPicture.asset(
      widget.svgIconPath!,
      colorFilter: ColorFilter.mode(AppColors.text, BlendMode.srcIn),
    );
  }

  _buildIconSection() {
    return Row(
      children: [
        SizedBox(width: 11.sp),
        _buildIconDropdown(),
      ],
    );
  }
}
