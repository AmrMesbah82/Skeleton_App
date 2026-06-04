import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_checkbox.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CustomCheckBoxTextRow extends StatefulWidget {
  CustomCheckBoxTextRow({
    super.key,
    required this.isChecked,
    required this.text,
  });
  bool isChecked;
  final String text;

  @override
  State<CustomCheckBoxTextRow> createState() => _CustomCheckBoxTextRowState();
}

class _CustomCheckBoxTextRowState extends State<CustomCheckBoxTextRow> {
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SizedBox(
      width:isPortrait?null: 0.2.w,
      child: Row(
        children: [
          CustomCheckbox(
              isChecked: widget.isChecked,
              onCheckboxState: (value) {
                setState(() {
                  widget.isChecked = value;
                });
              }),
          SizedBox(
            width: 0.01.w,
          ),
          Text(
            widget.text.tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
                color: widget.isChecked
                    ? Theme.of(context).colorScheme.inverseSurface
                    : MyThemeData.colorGrey,
                fontSize: isPortrait
                    ? FontConstants.fontSize014.h
                    : FontConstants.fontSize012.w,
                fontWeight: FontWeight.w400,
                height: 1.8),
          ),
        ],
      ),
    );
  }
}
