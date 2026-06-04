// Date Created :14/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :14/November/2023
// Objectives: this is a widget to customize column of the requests
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_text_styles.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';
import 'package:demo_app/features/external/todo_module/core/components/other_components/custom_description_textfield.dart';
import 'package:demo_app/features/external/todo_module/core/components/other_components/custom_drop_down_menu.dart';
import 'package:demo_app/features/external/todo_module/core/components/other_components/custom_textfield_new.dart';
import 'package:demo_app/features/external/todo_module/core/constants/screen_size.dart';

// ignore: must_be_immutable
class ColumnRequestData extends StatefulWidget {
  ColumnRequestData({
    super.key,
    this.onTap,
    this.dropdownValue,
    this.dropDownValueState,
    required this.title,
    required this.isTextField,
    required this.hint,
    required this.isOptional,
    this.isSetting = false,
    this.maxlength,
    this.hideTitle = false,
    this.hasPrefix = false,
    this.hasSuffix = false,
    this.isRequestDialogMobile = false,
    this.prefixIcon,
    this.suffixUrl,
    this.dropDownItems,
    this.hasPadding,
    this.fillColor,
    this.buttonWidth,
    this.controllerState,
    this.validator,
    this.controllerfinishState,
    this.textController,
    this.suffixHasColor,
    this.readOnly,
    this.sizerSuffix,
    this.initialValue,
    this.maxlines,
    this.minlines,
    this.dropWidth,
    this.enabled = true,
    this.removeSpace = false,
    this.isEdit = false,
    this.isRequired = false,
    this.hassSuffixState,
    this.enabledState,
    this.editField,
    this.initialValueColor,
    this.prefixUrl,
    this.isPriority,
    this.buttonHeight,
    required this.isExpanded,
    this.isAddNew = false,
    this.suffixColor,
    this.isArabic = false,
    this.textDirection,
    this.keyboardType,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.textAlign,
    this.errorNotifier,
    this.padding,
    this.isCheckboxDropDown = false,
    this.hasBeenTouched = false,
  });
  EdgeInsets? padding;
  final MainAxisAlignment? mainAxisAlignment;
  String? dropdownValue;
  ValueChanged<String?>? dropDownValueState;
  final String title;
  bool isTextField;
  final bool hasBeenTouched;
  bool? removeSpace;
  bool? isRequired;
  String hint;
  bool? isCheckboxDropDown;
  bool isExpanded;
  bool isOptional;
  int? maxlength;
  bool isAddNew;
  List<String>? dropDownItems;
  String? Function(String?)? validator;
  final bool? isSetting;
  final bool hideTitle;
  final bool? hasPrefix;
  bool? hasSuffix;
  final String? suffixUrl;
  final int? maxlines;
  final int? minlines;
  final String? initialValue;
  final Widget? prefixIcon;
  final bool? hasPadding;
  final bool? readOnly;
  final bool? isRequestDialogMobile;
  final Color? fillColor;
  final double? buttonWidth;
  final double? dropWidth;
  final double? sizerSuffix;
  final bool? suffixHasColor;
  final bool? isEdit;
  final Function()? onTap;
  TextInputType? keyboardType;
  ValueChanged<bool?>? hassSuffixState;
  TextEditingController? textController;
  ValueChanged<String?>? controllerState;
  ValueChanged? controllerfinishState;
  bool enabled;
  ValueChanged<bool>? enabledState;
  void Function()? editField;
  final Color? initialValueColor;
  final String? prefixUrl;
  final bool? isPriority;
  final double? buttonHeight;
  bool isArabic;
  final Color? suffixColor;
  final TextDirection? textDirection;
  // added new
  TextAlign? textAlign;
  ValueNotifier<String>? errorNotifier;
  @override
  State<ColumnRequestData> createState() => _ColumnRequestDataState();
}

class _ColumnRequestDataState extends State<ColumnRequestData> {
  bool isEditMode = false;
  TextEditingController settingReason = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    TextEditingController settingReason = TextEditingController();
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isDesktop = MediaQuery.of(context).size.width > 1400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.hideTitle
            ? const SizedBox.shrink()
            : Row(
                mainAxisAlignment: widget.mainAxisAlignment!,
                children: [
                  widget.isArabic
                      ? RichText(
                          text: TextSpan(
                              text: "*".tr,
                              style: AppTextStyles.font10BlackCairoRegular
                                  .copyWith(
                                fontSize: isDesktop ? 16 : 14,
                                fontWeight: FontWeight.w400,
                                color: MyThemeData.delete,
                              ),
                              children: [
                                WidgetSpan(child: SizedBox(width: 0.01.w)),
                                TextSpan(
                                    text: widget.title.tr,
                                    style: AppTextStyles.font10BlackCairoRegular
                                        .copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.text,
                                            height: 1.6))
                              ]),
                        )
                      : RichText(
                          text: TextSpan(
                              text: widget.title.tr,
                              style: AppTextStyles.font10BlackCairoRegular
                                  .copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: isDark
                                          ? AppColors.whiteDark
                                          : Colors.black,
                                      height: 1.6),
                              children: widget.isOptional
                                  ? [
                                      WidgetSpan(
                                          child: SizedBox(width: 0.01.w)),
                                      TextSpan(
                                          text: "(${'Optional'.tr})",
                                          style: AppTextStyles
                                              .font10BlackCairoRegular
                                              .copyWith(
                                                  fontSize: isDesktop ? 16 : 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.darkGrey))
                                    ]
                                  : widget.isRequired == true
                                      ? [
                                          WidgetSpan(
                                              child: SizedBox(width: 0.01.w)),
                                          TextSpan(
                                              text: "*",
                                              style: AppTextStyles
                                                  .font10BlackCairoRegular
                                                  .copyWith(
                                                fontSize: isDesktop ? 16 : 14,
                                                fontWeight: FontWeight.w400,
                                                color: MyThemeData.delete,
                                              ))
                                        ]
                                      : []),
                        ),
                  if (widget.isEdit == true && !isEditMode) const Spacer(),
                  if (widget.isEdit == true && !isEditMode)
                    InkWell(
                      onTap: widget.editField,
                      child: SvgPicture.asset(
                        'assets/icons/isEditIcon.svg',
                        height: isPortrait ? 0.02.h : 0.03.h,
                        color: MyThemeData.lightPrimary,
                      ),
                    ),
                ],
              ),
        widget.isTextField
            ? widget.isExpanded
                ? widget.isSetting == true
                    ? CustomDescriptionTextField(
                        controller: widget.textController ?? settingReason,
                        maxLength: widget.maxlength,
                        enabled: widget.enabled,
                        fillColor: widget.fillColor,
                        validator: widget.validator,
                        maxLines: widget.maxlines,
                        textDirection: widget.textDirection,
                        hint: widget.hint,
                        hasBeenTouched: widget.hasBeenTouched,
                      )
                    : CustomTextFieldContainer(
                        hasBeenTouched: widget.hasBeenTouched,
                        minLines: widget.minlines ?? 1,
                        buttonHeight: widget.buttonHeight,
                        textDirection: widget.textDirection,
                        initialValue: widget.initialValue,
                        textAlign: widget.textAlign,
                        readOnly: widget.readOnly ?? false,
                        keyboardType: widget.keyboardType,
                        hint: widget.hint,
                        suffixColor: widget.suffixColor,
                        initialValueColor: widget.initialValueColor,
                        hasPrefix: widget.hasPrefix,
                        enabled: widget.enabled,
                        maxLength: widget.maxlength,
                        validator: widget.validator,
                        prefixIcon: widget.prefixIcon,
                        hasSuffix: widget.hasSuffix,
                        suffixUrl: widget.suffixUrl,
                        maxLines: widget.maxlines,
                        isAddNewEmp: widget.isAddNew,
                        fillColor: widget.fillColor,
                        sizerSuffix: widget.sizerSuffix,
                        errorNotifier: widget.errorNotifier,
                        hassSuffixState: (value) {
                          setState(() {});
                        },
                        suffixHasColor: widget.suffixHasColor,
                        controller: widget.textController,
                        controllerfinishState: (value) {
                          setState(() {
                            widget
                                .controllerfinishState!(widget.textController);
                          });
                        },
                        controllerState: (value) {
                          setState(() {
                            widget.controllerState!(value);
                          });
                        },
                      )
                : Container(
                    height: 0.06.h,
                    width: 0.2.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.darkGrey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: Get.locale.toString().contains('en')
                                  ? 0.01.w
                                  : 0,
                              right: Get.locale.toString().contains('en')
                                  ? 0
                                  : 0.01.w),
                          child: Text(
                            widget.hint.tr,
                            style: AppTextStyles.font10BlackCairoRegular
                                .copyWith(
                                    fontSize: isDesktop ? 16 : 14,
                                    fontWeight: FontWeight.w500,
                                    height: 0.002.h,
                                    color: AppColors.darkGrey),
                          ),
                        ),
                        // ignore: deprecated_member_use
                        widget.hasSuffix == true
                            ? Padding(
                                padding: EdgeInsets.only(
                                    right: Get.locale.toString().contains('en')
                                        ? 0.01.w
                                        : 0,
                                    left: Get.locale.toString().contains('en')
                                        ? 0
                                        : 0.01.w),
                                child: SvgPicture.asset(
                                  widget.suffixUrl as String,
                                  // ignore: deprecated_member_use
                                  color: AppColors.darkGrey,
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  )
            : SizedBox(
                height: isDesktop ? 33 : 40,
                child: CustomDropdownButton2(
                  hint: widget.hint.tr,
                  prefixUrl: widget.prefixUrl,
                  subColor: widget.isAddNew
                      ? !isDark
                          ? MyThemeData.colorWhite
                          : MyThemeData.dark
                      : null,
                  borded: false,
                  suffixPaddingDropDown: isPortrait
                      ? isTablet
                          ? 0.01.w
                          : null
                      : null,
                  buttonWidth: widget.buttonWidth ??
                      (isTablet ? 0.2.w : double.infinity),
                  dropdownWidth: widget.dropWidth ??
                      (isTablet
                          ? 0.2.w
                          : widget.isRequestDialogMobile == true
                              ? 0.86.w
                              : 0.75.w),
                  buttonColor: widget.isAddNew
                      ? !isDark
                          ? MyThemeData.colorLightGrey
                          : MyThemeData.dark
                      : widget.fillColor,
                  backColor: widget.isAddNew
                      ? !isDark
                          ? MyThemeData.colorLightGrey
                          : MyThemeData.dark
                      : widget.fillColor ?? Colors.transparent,

                  value: widget.dropdownValue, //requestType,
                  dropdownItems: widget.isSetting == true
                      ? [
                          "Personal Information".tr,
                          "Health Insurance".tr,
                          "Additional Information".tr
                        ]
                      : widget.dropDownItems ??
                          ["Sick Leave".tr, "Permission".tr, "Vacation".tr],
                  onChanged: (value) {
                    setState(() {
                      if (widget.isPriority != null) {
                        if (widget.isPriority == true) {
                          widget.dropdownValue = value;
                        }
                        widget.dropDownValueState!(widget.dropdownValue);
                      } else {
                        widget.dropdownValue = value;
                        widget.dropDownValueState!(widget.dropdownValue);
                      }

                      //requestType = value;
                    });
                  },
                ),
              )
      ],
    );
  }
}
