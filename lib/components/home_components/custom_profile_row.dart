import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
// REMOVED_MODULE: import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';

class OrganizationRow extends StatefulWidget {
  final String firstImage;
  final String orgName;

  const OrganizationRow({
    Key? key,
    required this.firstImage,
    required this.orgName,

  }) : super(key: key);

  @override
  State<OrganizationRow> createState() => _OrganizationRowState();
}

class _OrganizationRowState extends State<OrganizationRow> {
  @override
  Widget build(BuildContext context) {
    TextStyle customSubTitleTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: FontConstants.fontSize016.h,
      // ignore: unrelated_type_equality_checks
      color: themeController.currentTheme == MyThemeData.lightTheme
          ? MyThemeData.colorDarkGrey
          : MyThemeData.colorGreydark,
      fontWeight: FontWeight.w400,
      height: 0.0016.h,
    );
        String generateEmail(String orgName) {
      List<String> names = orgName.split(" ");
      if (names.length == 1) {
        return "${orgName.toLowerCase()}@gmail.com";
      } else {
        String firstName = names[0][0].toLowerCase();
        String lastName = names[1].toLowerCase();
        return "$firstName.$lastName@gmail.com";
      }
    }
    return Padding(
      padding:   EdgeInsets.only(top: 0.01.h),
      child: Row(
        children: [
          Container(
            width: 0.04.h,
            height: 0.04.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyThemeData.lightPrimary,
            ),
            child: Center(
              child: CircleAvatar(
                radius: 0.03.h,
                backgroundImage: AssetImage(widget.firstImage),
              ),
            ),
          ),
          SizedBox(
            width: 0.02.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.orgName, style: customSubTitleTextStyle),
              Text(generateEmail(widget.orgName), style: customSubTitleTextStyle),
            ],
          ),
        ],
      ),
    );
  }
}
