//Date Created :2/September/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :3/October/2023 by mazen
// Objectives: this class  created to Customize the row of the front data of the card in card screen
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';

// ignore: must_be_immutable
class CardRowData extends StatelessWidget {
  CardRowData(
      {super.key,
      required this.isHorizontal,
      required this.isCard,
      required this.cardHeight,
      required this.icon,
      required this.data,
      this.preferredCommunication = "Calls"});
  bool isHorizontal;
  bool isCard;
  double cardHeight;
  final String data;
  final String icon;
  final String preferredCommunication;
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    String capitalize(String input) {
      if (input.isEmpty) {
        return "";
      }

      List<String> words = input.split(" ");
      words = words.map((word) {
        if (word.isNotEmpty) {
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        } else {
          return "";
        }
      }).toList();

      return words.join(" ");
    }

    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Row(
      children: [
        SizedBox(
          width: isHorizontal == true
              ? cardHeight * .13
              : isCard == true
                  ? cardHeight * .08
                  : isTablet
                      ? cardHeight * .11
                      : cardHeight * .1,
          height: isHorizontal == true ? cardHeight * .14 : cardHeight * .11,
          child: SvgPicture.asset(
            icon, //,
          ),
        ),
        SizedBox(width: isTablet ? 0.006.w : 0.02.w),
        //
        Padding(
          padding: EdgeInsets.only(top: 0.004.h),
          child: SizedBox(
            width: isCard == true
                ? icon == 'assets/icons/email_icon.svg'
                    ? isTablet
                        ? .22.w
                        : .45.w
                    : isTablet
                        ? .19.w
                        : .4.w
                : isPortrait == true
                    ? isTablet
                        ? .37.w
                        : 0.46.w
                    : Get.locale.toString().contains('en') &&
                            icon == 'assets/icons/phone_icon.svg'
                        ? .225.w
                        : icon == 'assets/icons/phone_icon.svg'
                            ? .25.w
                            : .225.w,
            child: Row(
              mainAxisAlignment:
                  isCard == false && icon == 'assets/icons/phone_icon.svg'
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
              children: [
                FittedBox(
                  alignment: Get.locale.toString().contains('ar')
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    icon == 'assets/icons/email_icon.svg'
                        ? data
                        : capitalize(data),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        height: isHorizontal == true
                            ? 0.00215.h
                            : isTablet
                                ? null
                                : 0.0018.h,
                        fontSize: isHorizontal == true
                            ? FontConstants.fontSize028.h
                            : isCard == false
                                ? isTablet
                                    ? FontConstants.fontSize021.h
                                    : FontConstants.fontSize019.h
                                : icon == 'assets/icons/email_icon.svg'
                                    ? isTablet
                                        ? FontConstants.fontSize015.h
                                        : FontConstants.fontSize017.h
                                    : isTablet
                                        ? FontConstants.fontSize017.h
                                        : FontConstants.fontSize019.h),
                  ),
                ),
                isCard == false && icon == 'assets/icons/phone_icon.svg'
                    ? FittedBox(
                        alignment: Get.locale.toString().contains('en')
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${"Prefer".tr}  ${preferredCommunication.tr}",
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: isHorizontal == true
                                  ? FontConstants.fontSize020.h
                                  : FontConstants.fontSize014.h,
                              fontWeight: Get.locale.toString().contains('en')
                                  ? FontWeight.w600
                                  : FontWeight.w500),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
