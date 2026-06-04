import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/features/external/main_core/core/theme/font_manager.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';

class CustomTableBody extends StatefulWidget {
  final String text;
  final Color? textColor;
  final String? profileImage;
  final bool? textField;
  TextEditingController? controller;
  Function(dynamic)? controllerfinishState;
  final bool isIndex;
  final bool isDescribtion;

  CustomTableBody({
    Key? key,
    required this.text,
    this.textColor,
    this.profileImage,
    this.textField,
    this.controller,
    this.controllerfinishState,
    this.isIndex = false,
    this.isDescribtion = false,
  }) : super(key: key);

  @override
  _CustomTableBodyState createState() => _CustomTableBodyState();
}

class _CustomTableBodyState extends State<CustomTableBody> {
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    TextStyle tableDataTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: isPortrait
          ? FontConstants.fontSize015.h
          : FontConstants.fontSize022.h,
      fontWeight: FontWeight.w500,
    );
    List<String> abbreviation = [
      "it",
      "hr",
      'ui ux',
      'log',
      'qa',
      'pr',
      'dev',
      'ceo'
    ];
    Color textColor;

    String lowerCaseText = widget.text.toLowerCase();

    if (lowerCaseText == 'open' ||
        lowerCaseText == 'approved' ||
        lowerCaseText == 'active' ||
        lowerCaseText == 'done') {
      textColor = MyThemeData.unBlock;
    } else if (lowerCaseText == 'closed' ||
        lowerCaseText == 'rejected' ||
        lowerCaseText == 'not assigned' ||
        lowerCaseText == 'canceled' ||
        lowerCaseText == 'expired' ||
        lowerCaseText == 'exceeded deadline') {
      textColor = MyThemeData.delete;
    } else if (lowerCaseText == 'in progress') {
      textColor = MyThemeData.warning;
    } else if (lowerCaseText == 'not started') {
      textColor = MyThemeData.secondaryColor;
    } else if (lowerCaseText == 'pending') {
      textColor = MyThemeData.warning;
    } else if (lowerCaseText.contains('@') && lowerCaseText.contains('.')) {
      textColor = MyThemeData.blue;
      tableDataTextStyle =
          tableDataTextStyle.copyWith(decoration: TextDecoration.underline);
    } else if (lowerCaseText.contains('.pdf') ||
        lowerCaseText.contains('.docx')) {
      textColor = MyThemeData.blue;
      tableDataTextStyle =
          tableDataTextStyle.copyWith(decoration: TextDecoration.underline);
    } else if (lowerCaseText == "deactivated") {
      textColor = MyThemeData.lightPrimary;
    } else if (lowerCaseText == "draft") {
      textColor = MyThemeData.textGrey;
    } else {
      textColor = Theme.of(context).colorScheme.inverseSurface;
    }

    return Container(
      width: isPortrait
          ? widget.isIndex
              ? 0.07.w
              : widget.isDescribtion
                  ? 0.35.w
                  : 0.3.w
          : widget.isIndex
              ? 0.06.w
              : widget.isDescribtion
                  ? 0.25.w
                  : 0.15.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.profileImage != null)
            CircleAvatar(
              radius: isPortrait ? 0.025.w : 0.012.w,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(widget.profileImage!),
            ),
          if (widget.profileImage != null)
            SizedBox(
              width: 0.01.w,
            ),
          Flexible(
            child: widget.textField == true
                ? ColumnRequestData(
                    title: "",
                    hideTitle: true,
                    isTextField: true,
                    hint: "",
                    isOptional: false,
                    textAlign: TextAlign.center,
                    textController: widget.controller,
                    keyboardType: TextInputType.number,
                    controllerfinishState: widget.controllerfinishState,
                    controllerState: (value) {
                      setState(() {});
                    },
                    isExpanded: true)
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isPortrait ? 0.015.w : 0),
                    child: Text(
                      abbreviation.contains(widget.text.toLowerCase())
                          ? widget.text.tr
                          : widget.text.capitalize!.tr,
                      textAlign:
                          widget.profileImage != null ? null : TextAlign.center,
                      style: tableDataTextStyle.copyWith(
                        color: widget.textColor ?? textColor,
                        height: 1.3,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
