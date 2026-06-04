import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CustomTableBody extends StatefulWidget {
  final String text;
  final Color? textColor;
  final String? profileImage;

  CustomTableBody({
    Key? key,
    required this.text,
    this.textColor,
    this.profileImage,
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

    Color textColor;

    String lowerCaseText = widget.text.toLowerCase();

    if (lowerCaseText == 'open' ||
        lowerCaseText == 'approved' ||
        lowerCaseText == 'done') {
      textColor = MyThemeData.unBlock;
    } else if (lowerCaseText == 'closed' ||
        lowerCaseText == 'rejected' ||
        lowerCaseText == 'canceled' ||
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
    } else {
      textColor = Theme.of(context).colorScheme.inverseSurface;
    }

    return Container(
      width: isPortrait ? 0.2.w : 0.15.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.profileImage != null)
            CircleAvatar(
              radius: isPortrait ? 0.02.w : 0.012.w,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(widget.profileImage!),
            ),
          if (widget.profileImage != null)
            SizedBox(
              width: 0.01.w,
            ),
          Flexible(
            child: Text(
              widget.text.capitalize!.tr,
              textAlign: TextAlign.center,
              style: tableDataTextStyle.copyWith(
                color: widget.textColor ?? textColor,
                height: 1.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
