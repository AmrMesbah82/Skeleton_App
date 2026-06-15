// Last edit 13/8/2023 by mazen
// ignore_for_file: deprecated_member_use

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/main_core_theme_controller.dart';
import 'package:demo_app/features/todo_module/core/constants/screen_size.dart';

// ignore: must_be_immutable
class CustomDropdownButton2 extends StatefulWidget {
  final String hint;
  final String? value;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth, iconHeight;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final TextStyle? dropDownTextStyle;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final bool? isSignUpMobile;
  final Offset offset;
  final bool? borded;
  final bool? preferred;
  final Color? backColor;
  final Color? buttonColor;
  final bool? conditionToCheck;
  final bool? isSettings;
  final bool isBottomSheet;
  final bool hasPrefix;
  final String? prefixUrl;
  final bool? isCompany;
  final bool? isArabic;
  final Color? subColor;
  double? suffixPaddingDropDown;
  CustomDropdownButton2({
    this.isCompany,
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.iconHeight,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.subColor,
    this.borded = false,
    this.isSignUpMobile = false,
    this.conditionToCheck = false,
    this.isSettings = false,
    this.preferred,
    this.buttonColor,
    this.prefixUrl,
    this.hasPrefix = false,
    this.backColor,
    this.valueAlignment,
    this.isBottomSheet = false,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.dropDownTextStyle,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.suffixPaddingDropDown,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.isArabic,
    this.offset = const Offset(0, 0),
    super.key,
  });

  @override
  State<CustomDropdownButton2> createState() => _CustomDropdownButton2State();
}

class _CustomDropdownButton2State extends State<CustomDropdownButton2> {
  bool filled = false;
  Color _borderColor = MyThemeData.colorGrey;
  final FocusNode _focusNode = FocusNode();
  MainCoreThemeController themeController = Get.put(MainCoreThemeController());
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        //To avoid long text overflowing.
        isExpanded: true,
        hint: Row(
          children: [
            Focus(
              focusNode: _focusNode,
              onFocusChange: (hasFocus) {
                setState(() {
                  filled == true
                      ? _borderColor = AppColors.text
                      : _borderColor = hasFocus
                          ? MyThemeData.lightPrimary
                          : MyThemeData.colorGrey;
                });
              },
              child: Container(
                color: widget.subColor ??
                    (themeController.currentTheme == MyThemeData.lightTheme
                        ? MyThemeData.colorLightGrey
                        : MyThemeData.colorBlack),
                child: Text(
                  widget.hint.tr,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: widget.dropDownTextStyle ??
                      AppTextStyles.font10BlackCairoRegular.copyWith(
                        fontSize: 14,
                        height: 1.6,
                        color: isDark
                            ? AppColors.mediumGrey
                            : AppColors.inverseBase,
                      ),
                ),
              ),
            ),
          ],
        ),
        value: widget.value,
        items: widget.dropdownItems.map((item) {
          bool isSelected = item == widget.value;
          return DropdownMenuItem<String>(
            value: item,
            child: Row(
              children: [
                Expanded(
                  child: AutoSizeText(
                    widget.isArabic == true
                        ? '$item. ابق إيجابيًا'
                        : widget.isCompany == true
                            ? '$item. Stay positive'
                            : item,
                    maxLines: 1,
                    style: isSelected
                        ? AppTextStyles.font10BlackCairoRegular.copyWith(
                            fontFamily: widget.isCompany == true ? item : null,
                            fontSize: 14,
                            height: 1, //1.6
                            color: AppColors.text,
                            fontWeight: FontWeight.w500,
                          )
                        : AppTextStyles.font10BlackCairoRegular.copyWith(
                            fontFamily: widget.isCompany == true ? item : null,
                            fontSize: 14,
                            height: 1, //1.6
                            color: isDark
                                ? AppColors.mediumGrey
                                : MyThemeData.textdeactivecolor,
                            fontWeight: FontWeight.w500,
                          ),
                  ),
                )
              ],
            ),
          );
        }).toList(),

        onChanged: widget.onChanged,
        selectedItemBuilder: widget.selectedItemBuilder,
        buttonStyleData: ButtonStyleData(
          height: 38,
          width: widget.buttonWidth ?? 0.08.w,
          padding: EdgeInsets.only(left: 15, right: 10),
          decoration: BoxDecoration(
            // ignore: unrelated_type_equality_checks
            color: widget.subColor ??
                (themeController.currentTheme == MyThemeData.lightTheme
                    ? MyThemeData.colorLightGrey
                    : MyThemeData.colorBlack),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: widget.borded == true ? _borderColor : Colors.transparent,
              width: 1.0,
            ),
          ),
          elevation: widget.buttonElevation,
        ),
        iconStyleData: IconStyleData(
          icon: SvgPicture.asset(
            'assets/icons/arrow_down_mobile.svg',
            height: 18,
            width: 18,
            color: AppColors.text,
          ),
          // iconSize: iconSize ?? 22,
          iconEnabledColor: widget.iconEnabledColor,
          iconDisabledColor: widget.iconDisabledColor,
        ),

        dropdownStyleData: DropdownStyleData(
          //Max height for the dropdown menu & becoming scrollable if there are more items. If you pass Null it will take max height possible for the items.
          maxHeight: widget.dropdownHeight ?? 0.250.h, //200,
          width: widget.dropdownWidth ?? 0.2.w,
          padding: widget.dropdownPadding,
          decoration: widget.dropdownDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.transparent,
                ),
                // color: MyThemeData.colorWhite,
              ),
          elevation: widget.dropdownElevation ?? 8,
          //Null or Offset(0, 0) will open just under the button. You can edit as you want.
          offset: widget.offset,
          //Default is false to show menu below button
          // isOverButton: false,
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 30,
          padding: widget.itemPadding ??
              EdgeInsets.only(left: 15, top: 0, right: 15),
        ),
      ),
    );
  }
}
