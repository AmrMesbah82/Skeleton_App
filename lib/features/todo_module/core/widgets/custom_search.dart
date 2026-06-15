// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_colors.dart';

class CustomSearchFiled2 extends StatefulWidget {
  final String hint;
  final bool isBorded;
  final TextStyle? hintStyle;
  final TextInputType keyBoardType;
  final Function(String)? onChanged;
  final EdgeInsets? padding;

  const CustomSearchFiled2({
    super.key,
    required this.hint,
    this.hintStyle,
    required this.keyBoardType,
    this.padding,
    this.isBorded = false,
    this.onChanged,
  });

  @override
  _CustomSearchFiledState createState() => _CustomSearchFiledState();
}

class _CustomSearchFiledState extends State<CustomSearchFiled2> {
  String search_text = '';
  TextEditingController textEditingController = TextEditingController();

  void onSearchTextChanged(String searchText) {
    setState(() => search_text = searchText);
    widget.onChanged?.call(searchText);
  }

  void clearSearchText() {
    setState(() {
      search_text = '';
      textEditingController.clear(); // Clear the text field
    });
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SizedBox(
      height: 38,
      child: TextFormField(
        cursorColor: AppColors.primary,
        textAlignVertical: TextAlignVertical.center,
        cursorHeight: 16,
        textAlign: TextAlign.start,
        controller: textEditingController,
        onChanged: onSearchTextChanged,
        decoration: InputDecoration(
          filled: true,
          isDense: false,
          fillColor: AppColors.white,
          hintText: widget.hint.tr,
          hintStyle: AppTextStyles.font23MediumBlackCairo.copyWith(
            fontSize: 16,
            height: 1.5,
            color: isDark ? AppColors.mediumGrey : AppColors.spanText,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          prefixIcon: Transform.scale(
              scale: 24 / 38,
              child:
                  SvgPicture.asset('assets/icons/Minimalistic Magnifer.svg')),
          suffixIcon: search_text.isNotEmpty
              ? IconButton(
                  onPressed: clearSearchText,
                  icon: const Icon(Icons.clear, size: 20),
                )
              : null,
          contentPadding: EdgeInsets.zero,
          hoverColor: Colors.transparent,
        ),
        keyboardType: widget.keyBoardType,
        style: AppTextStyles.font23MediumBlackCairo.copyWith(
          fontSize: 16,
          height: 1.5,
          color: AppColors.text,
        ),
      ),
    );
  }
}
