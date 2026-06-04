import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';


class RowIconText extends StatefulWidget {
  RowIconText(
      {super.key,
      required this.iconUrl,
      required this.text,
      this.isSmall = false,
      this.isDescribtion = false,
      this.isDropDown = false,
      this.hideImage = false,
      this.status,
      this.statusState,
      this.isProvider = false,
      this.providerNAme,
      this.valueColor,
      this.hasAnotherWidget = false,
      this.anotherWidget,
      required this.value});
  final String iconUrl;
  final String text;
  final String value;
  bool? isSmall;
  final bool isDescribtion;
  final bool isDropDown;
  final bool hideImage;
  String? status;
  ValueChanged<String?>? statusState;
  final bool isProvider;
  TextEditingController? providerNAme;
  final Color? valueColor;
  final Widget? anotherWidget;
  final bool hasAnotherWidget;

  @override
  State<RowIconText> createState() => _RowIconTextState();
}

class _RowIconTextState extends State<RowIconText> {
  void updateProviderName(String newProviderName) {
    setState(() {
      widget.providerNAme?.text = newProviderName;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double dropdownWidthVert = 0.28.w;
    double dropdownWidthHori = 0.2.w;
    TextStyle textStyle = AppFontStyle.cairoRegularStyle.copyWith(
        fontSize: widget.isSmall == true
            ? widget.isSmall == true
                ? isPortrait
                    ? FontConstants.fontSize015.h
                    : FontConstants.fontSize012.w
                : FontConstants.fontSize014.w
            : isTablet
                ? isPortrait
                    ? FontConstants.fontSize016.h
                    : FontConstants.fontSize013.w
                : FontConstants.fontSize018.h,
        color: themeController.currentTheme == MyThemeData.lightTheme
            ? MyThemeData.colorDarkGrey
            : MyThemeData.colorGreydark,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
        height: isTablet ? 1.8 : 1.5);
    TextStyle valueStyle = AppFontStyle.cairoRegularStyle.copyWith(
        fontSize: widget.isSmall == true
            ? widget.isSmall == true
                ? isPortrait
                    ? FontConstants.fontSize015.h
                    : FontConstants.fontSize012.w
                : FontConstants.fontSize014.w
            : isTablet
                ? isPortrait
                    ? FontConstants.fontSize016.h
                    : FontConstants.fontSize013.w
                : FontConstants.fontSize018.h,
        color: widget.valueColor ??
            (themeController.currentTheme == MyThemeData.lightTheme
                ? MyThemeData.colorBlack
                : MyThemeData.colorWhiteDark),
        fontWeight: FontWeight.w500,
        height: isTablet ? 1.8 : 1.5);
    return widget.isDescribtion
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    widget.iconUrl,
                    color: MyThemeData.signOut,
                    height: isPortrait
                        ? 0.025.h
                        : widget.isSmall == true
                            ? 0.025.h
                            : 0.035.h,
                  ), //'assets/icons/Org.svg'
                  SizedBox(width: 0.01.w),
                  Text(
                    "${widget.text.tr}: ", //widget.isGrade == true ? 'Teacher:' : 'Organizer:'
                    style: textStyle,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.0.h),
                child: widget.hasAnotherWidget
                    ? widget.anotherWidget
                    : Text(
                        widget.value
                            .tr, //' ${widget.organizerName}'.capitalize as String
                        style: valueStyle,
                        // overflow: TextOverflow.ellipsis,
                      ),
              ),
            ],
          )
        : Row(
            crossAxisAlignment: widget.isDropDown || widget.isProvider
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              widget.hideImage == true
                  ? SizedBox.shrink()
                  : SvgPicture.asset(
                      widget.iconUrl,
                      color: MyThemeData.signOut,
                      height: isPortrait
                          ? isTablet
                              ? 0.02.h
                              : 0.025.h
                          : widget.isSmall == true
                              ? 0.025.h
                              : 0.035.h,
                    ), //'assets/icons/Org.svg'
              widget.hideImage == true
                  ? SizedBox.shrink()
                  : SizedBox(width: 0.01.w),
              Text(
                "${widget.text.tr}: ", //widget.isGrade == true ? 'Teacher:' : 'Organizer:'
                style: textStyle,
              ),
              isTablet
                  ? Flexible(
                      child: Text(
                        widget.value
                            .tr, //' ${widget.organizerName}'.capitalize as String
                        style: valueStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Text(
                      widget.value
                          .tr, //' ${widget.organizerName}'.capitalize as String
                      style: valueStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
            ],
          );
  }
}
