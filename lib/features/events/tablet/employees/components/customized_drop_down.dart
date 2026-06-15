// Last edit 13/8/2023 by mazen
// ignore_for_file: deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';

class CustomizedDropdownButton2 extends StatefulWidget {
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
  final Color? iconColor;
  final String? prefixUrl;

  const CustomizedDropdownButton2({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.iconHeight,
    this.iconColor,
    this.selectedItemBuilder,
    this.hintAlignment,
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
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = const Offset(0, 0),
    Key? key,
  }) : super(key: key);

  @override
  State<CustomizedDropdownButton2> createState() =>
      _CustomizedDropdownButton2State();
}

class _CustomizedDropdownButton2State extends State<CustomizedDropdownButton2> {
  final HapticController hapticController = Get.put(HapticController());

  bool filled = false;
  Color _borderColor = MyThemeData.colorGrey;
  final FocusNode _focusNode = FocusNode();
  ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final orientation = MediaQuery.of(context).orientation;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    _borderColor = widget.borded == true || filled == true
        ? Theme.of(context).colorScheme.onInverseSurface
        : MyThemeData.colorGrey;
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        //To avoid long text overflowing.
        isExpanded: true,

        hint: Row(
          children: [
            // widget.prefixUrl != null
            //     ? Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 0.02.w),
            //         child: Transform.scale(
            //             scale: 1.1,
            //             child: SvgPicture.asset(
            //               widget.prefixUrl as String,
            //               height: isTablet ? null : 0.025.h,
            //             )),
            //       )
            //     : const SizedBox.shrink(),
            Focus(
              focusNode: _focusNode,
              onFocusChange: (hasFocus) {
                setState(() {
                  filled == true
                      ? _borderColor =
                          Theme.of(context).colorScheme.onInverseSurface
                      : _borderColor = hasFocus
                          ? MyThemeData.lightPrimary
                          : MyThemeData.colorGrey;
                });
              },
              child: Container(
                //  alignment: widget.hintAlignment,
                // color: Theme.of(context).colorScheme.background,
                color: widget.backColor ??
                    Theme.of(context).colorScheme.background,
                child: Text(
                  widget.hint.tr,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: widget.dropDownTextStyle ??
                      AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: orientation == Orientation.portrait
                            ? isTablet
                                ? FontConstants.fontSize016.h
                                : widget.isSettings == true
                                    ? FontConstants.fontSize017.h
                                    : widget.isSignUpMobile == true
                                        ? FontConstants.fontSize018.h
                                        : FontConstants.fontSize016.h
                            : FontConstants.fontSize022.h,
                        height: orientation == Orientation.portrait
                            ? widget.isSignUpMobile == true && !isTablet
                                ? 1.6
                                : 1.5
                            : 1.3,
                        color: widget.isSignUpMobile == false
                            ? MyThemeData.colorGrey
                            : Theme.of(context).colorScheme.scrim,
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
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isVertical ? 0.015.w : 0.01.w),
                  child: Transform.scale(
                      scale: 1.1,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 0.001.h),
                        child: SvgPicture.asset(
                          item == "Accepted".tr
                              ? 'assets/icons/ApproveIcon.svg'
                              : item == "Rejected".tr
                                  ? 'assets/icons/RejectionIcon.svg'
                                  : "",
                          height: isTablet ?isVertical?0.02.h :0.025.h : 0.02.h,
                        ),
                      )),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    item,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: orientation == Orientation.portrait
                          ? FontConstants.fontSize016.h
                          : FontConstants.fontSize022.h,
                      height: isTablet
                          ? orientation == Orientation.portrait
                              ? widget.isSignUpMobile == true && !isTablet
                                  ? 1.6
                                  : 0.00125.h
                              : 1.7
                          : 1.6, //1.6
                      color: item == 'Accepted'.tr
                          ? MyThemeData.unBlock
                          : MyThemeData.colorRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: widget.onChanged,
        selectedItemBuilder: widget.selectedItemBuilder,
        buttonStyleData: ButtonStyleData(
          height: widget.buttonHeight ?? 0.040.h,
          width: widget.buttonWidth ?? 0.08.w,
          padding: widget.buttonPadding ??
              EdgeInsets.only(
                left: 0.020.w,
              ),
          decoration: widget.buttonDecoration ??
              BoxDecoration(
                  color: widget.buttonColor ??
                      Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(8),
                  border: widget.borded == false
                      ? Border.all(
                          color: widget.value == widget.hint
                              ? Theme.of(context).colorScheme.errorContainer
                              // ignore: unrelated_type_equality_checks
                              : themeController.currentTheme ==
                                      MyThemeData.darkTheme
                                  ? widget.isBottomSheet == true
                                      ? Theme.of(context)
                                          .colorScheme
                                          .errorContainer
                                      : Colors.transparent
                                  : _borderColor,
                        )
                      : Border.all(
                          color: Colors.transparent,
                        )
                  //  color: Theme.of(context).colorScheme.inversePrimary,
                  ),
          elevation: widget.buttonElevation,
        ),
        iconStyleData: IconStyleData(
          icon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.4),
            child: SvgPicture.asset(
              'assets/images/arrowsquaredown.svg',
              height: orientation == Orientation.portrait
                  ? isTablet
                      ? 0.02.h
                      : 0.02.h
                  : widget.iconHeight ?? 0.03.h,
              width: orientation == Orientation.portrait ? 0.07.w : 0.01.h,
              color:widget.iconColor,
            ),
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
                // color:Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors
                      .transparent, //Theme.of(context).colorScheme.onInverseSurface,
                ),
                // color: MyThemeData.colorWhite,
              ),
          elevation: widget.dropdownElevation ?? 8,
          //Null or Offset(0, 0) will open just under the button. You can edit as you want.
          offset: widget.offset,
          //Default is false to show menu below button
          isOverButton: false,
          // scrollbarTheme: ScrollbarThemeData(
          //   radius: widget.scrollbarRadius ?? Radius.circular(0.040.r),
          //   thickness: widget.scrollbarThickness != null
          //       ? MaterialStateProperty.all<double>(widget.scrollbarThickness!)
          //       : null,
          //   thumbVisibility: widget.scrollbarAlwaysShow != null
          //       ? MaterialStateProperty.all<bool>(widget.scrollbarAlwaysShow!)
          //       : null,
          // ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: orientation == Orientation.portrait
              ? isTablet
                  ? 0.055.w
                  : 0.035.h
              : 0.025.w,
          padding: widget.itemPadding ??
              EdgeInsets.only(left: 0.010.w, right: 0.010.w),
        ),
      ),
    );
  }
}
