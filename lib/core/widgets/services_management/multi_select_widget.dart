import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/widgets/custom_check_box.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/widgets/services_management/custom_check_box.dart';

import '../../theme/app_colors.dart';

class AppMultiSelectDropdownMaster extends StatefulWidget {
  AppMultiSelectDropdownMaster({
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
    this.iconOnly = false,
  });

  final bool singleSelect;
  final bool iconOnly; // NEW: Flag for icon-only mode
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

  @override
  State<AppMultiSelectDropdownMaster> createState() => _AppMultiSelectDropdownMasterState();
}

class _AppMultiSelectDropdownMasterState extends State<AppMultiSelectDropdownMaster> {
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
                          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
                          child: Row(
                            children: [
                              // Hide checkbox in single-select mode
                              if (!widget.singleSelect) CustomCheckBox(isSelected: isSelected,),
                              if (!widget.singleSelect) SizedBox(width: 8.sp),
                              Expanded(
                                child: Text(
                                  item,
                                  style: AppTextStyles.font12SecondaryBlackCairoRegular,
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
                borderRadius: BorderRadius.circular(8.r),
              ),
              width: widget.width,
              height:  36.h,
              child: widget.iconOnly
                  ? _buildIconOnlyButton()
                  : Padding(
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
                          "assets/arrowdown.svg",
                          height: 22.sp,
                          width: 22.sp,
                          colorFilter: ColorFilter.mode(
                              AppColors.secondaryBlack, BlendMode.srcIn),
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
              maxHeight: 300,
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
                  style: AppTextStyles.font12SecondaryBlackCairoRegular.copyWith(
                    color: Colors.red,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // NEW: Build icon-only button (centered icon, no text)
  Widget _buildIconOnlyButton() {
    return Center(
      child: SvgPicture.asset(
        widget.svgIconPath!,
        height: 20.sp,
        width: 20.sp,
        colorFilter: ColorFilter.mode(AppColors.text, BlendMode.srcIn),
      ),
    );
  }

  Row _buildDropdownText() {
    // If textButton is provided, use normal color
    // If only hintText (no textButton), it will show as hint with red color
    final displayText = widget.textButton ?? widget.hintText ?? 'Choose here'.tr;
    final isHintMode = widget.textButton == null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          textAlign: TextAlign.start,
          displayText,
          style: (AppTextStyles.font12BlackCairoRegular).copyWith(
            color: isHintMode ? AppColors.text.withOpacity(.5) : AppColors.text.withOpacity(.5),
          ),
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
    return Row(children: [SizedBox(width: 11.sp), _buildIconDropdown()]);
  }
}
