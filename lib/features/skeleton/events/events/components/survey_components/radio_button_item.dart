// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

// ignore: must_be_immutable
class RadioButtonitem extends StatefulWidget {
  RadioButtonitem({
    super.key,
    required this.connectionType,
    required this.label,
    required this.type,
    required this.typeStateChanged,
    this.isDisabled = false,
    this.correctAnswer,
  });
  String? connectionType;
  String label;
  String? type;
  ValueChanged<String?> typeStateChanged;
  bool isDisabled;
  String? correctAnswer;

  @override
  State<RadioButtonitem> createState() => _RadioButtonitemState();
}

class _RadioButtonitemState extends State<RadioButtonitem> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Row(
      children: [
        Radio<String>(
          fillColor: MaterialStateColor.resolveWith(
            (states) => (widget.correctAnswer != null &&
                    widget.type != widget.correctAnswer)
                ? widget.type == widget.connectionType //Connectiontype.text
                    ? widget.type == widget.correctAnswer
                        ? MyThemeData.signOut
                        : MyThemeData.colorRed
                    : Theme.of(context).colorScheme.tertiaryContainer
                : widget.type == widget.connectionType //Connectiontype.text
                    ? MyThemeData.signOut
                    : Theme.of(context).colorScheme.tertiaryContainer,
          ),
          value: widget.connectionType!, //Connectiontype.text,
          groupValue: widget.type,
          onChanged: widget.isDisabled
              ? null
              : (String? value) {
                  setState(() {
                    widget.type = value as String;
                    widget.typeStateChanged(widget.type);
                  });
                },
        ),
        Padding(
          padding: EdgeInsets.only(top: isTablet ? 0.004.h : 0.006.h),
          child: Text(
            widget.label, //'Text Messages'.tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: FontConstants.fontSize018.h,
                color: widget.type == widget.connectionType
                    ? Theme.of(context).colorScheme.onInverseSurface
                    : Theme.of(context).colorScheme.tertiaryContainer,
                fontWeight: Get.locale.toString().contains('en')
                    ? FontWeight.w600
                    : FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
