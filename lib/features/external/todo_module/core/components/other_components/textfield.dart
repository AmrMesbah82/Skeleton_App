// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/external/todo_module/core/constants/screen_size.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/main_core_theme_controller.dart';

Widget textfieled(
    BuildContext context,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    String hits,
    String? initialValue,
    Widget? prefixIcon,
    {Widget? suffixIcon,
    TextEditingController? controller,
    Function(String)? onFinish,
    bool isReadOnly = false,
    bool isCSV = false,
    bool isRequestDialog = false,
    bool? hasError,
    int? maxLength}) {
  bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
  final MainCoreThemeController themeController = Get.find<MainCoreThemeController>();
  final orientation = MediaQuery.of(context).orientation;
  return Padding(
    padding: EdgeInsets.symmetric(
        vertical: orientation == Orientation.portrait ? 0.001.h : 0.003.h),
    child: SizedBox(
      height: MediaQuery.of(context).size.shortestSide > 600
          ? (orientation == Orientation.portrait ? null : null)
          : 0.06.h,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.007.h),
        child: TextFormField(
          key: Key(initialValue.toString()),
          controller: controller,
          initialValue: initialValue,
          onChanged: (value) {
            onChanged!(value);
          },
          onFieldSubmitted: (value) {
            // onFinish(value);
          },
          validator: validator,
          maxLength: maxLength,
          autovalidateMode: isCSV
              ? AutovalidateMode.always
              : AutovalidateMode.onUserInteraction,
          readOnly: isReadOnly,
          style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: orientation == Orientation.portrait
                  ? isTablet
                      ? FontConstants.fontSize016.h
                      : isRequestDialog == true && isTablet == false
                          ? FontConstants.fontSize016.h
                          : FontConstants.fontSize017.h
                  : FontConstants.fontSize023.h,
              height: isCSV ? 2 : null,
              color: hasError == true
                  ? MyThemeData.delete
                  : themeController.currentTheme == MyThemeData.lightTheme
                      ? MyThemeData.colorBlack
                      : MyThemeData.colorWhite,
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            filled: true,
            suffixIcon: suffixIcon,
            errorStyle: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: FontConstants.fontSize018.h,
                color: MyThemeData.delete,
                fontWeight: FontWeight.w500),
            contentPadding: const EdgeInsets.only(top: 0, left: 0),
            focusColor: MyThemeData.textfieldColor,
            hoverColor: MyThemeData.textfieldColor,
            hintText: hits,
            counterText: '',
            prefix: SizedBox(
              height: .023.h,
            ),
            prefixIcon: Padding(
                padding: MediaQuery.of(context).size.shortestSide > 600
                    ? const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      )
                    : EdgeInsets.only(
                        left: 0.008.w,
                        right: 10.0,
                      ),
                child: prefixIcon),
            prefixIconConstraints: BoxConstraints(
              maxHeight: .035.h,
              maxWidth: .06.h,
            ),
            hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: orientation == Orientation.portrait
                    ? isTablet
                        ? FontConstants.fontSize014.h
                        : isRequestDialog == true && isTablet == false
                            ? FontConstants.fontSize017.h
                            : FontConstants.fontSize017.h
                    : FontConstants.fontSize020.h,
                color: MyThemeData.colorGrey,
                fontWeight: FontWeight.w400,
                height: MediaQuery.of(context).size.shortestSide > 600
                    ? (orientation == Orientation.portrait ? 0.0014.h : 0.002.h)
                    : 0.0022.h),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: isCSV
                  ? BorderSide(color: MyThemeData.lightPrimary)
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: isCSV
                  ? BorderSide(
                      color:
                          themeController.currentTheme == MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhite)
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyThemeData.delete, width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
            //
            fillColor: isCSV
                ? Colors.transparent
                : (themeController.currentTheme == MyThemeData.lightTheme
                    ? const Color(0xFFF6F6F6)
                    : const Color(0xFF545454)),
          ),
        ),
      ),
    ),
  );
}
