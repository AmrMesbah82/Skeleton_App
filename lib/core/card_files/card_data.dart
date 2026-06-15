//Date Created :1/September/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :3/October/2023 by mazen
// Objectives: this class  created to view the data in the orange card front of it for each user
import 'package:flutter/material.dart';
import 'package:demo_app/core/card_files/card_row_data.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

class CardData extends StatelessWidget {
  const CardData({super.key, this.isHorizontal = false, this.isCard = false});
  final bool isHorizontal;
  final bool isCard;

  final String jobTitle = "ui/UX Designer";
  // ignore: non_constant_identifier_names
  final String CompanyName = "Bayanatz";
  final String phoneNumber = "0103435646";
  // ignore: non_constant_identifier_names
  final String Email = 'a.bayantz@gmail.com';
  @override
  Widget build(BuildContext context) {
    double cardHeight = .28.h;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    String preferredCommunication = 'Calls';

    Widget spacing() {
      return SizedBox(
        height: isHorizontal == true
            ? cardHeight * .00
            : isCard == true
                ? isTablet
                    ? cardHeight * .01
                    : cardHeight * .02
                : cardHeight * .015,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        spacing(),
        CardRowData(
          cardHeight: cardHeight,
          icon: 'assets/icons/job_icon.svg',
          data: jobTitle,
          isCard: isCard,
          isHorizontal: isHorizontal,
        ),
        spacing(),
        CardRowData(
            isHorizontal: isHorizontal,
            isCard: isCard,
            cardHeight: cardHeight,
            icon: 'assets/icons/company_icon.svg',
            data: CompanyName),
        spacing(),
        // third card here
        CardRowData(
          isHorizontal: isHorizontal,
          isCard: isCard,
          cardHeight: cardHeight,
          icon: 'assets/icons/phone_icon.svg',
          data: phoneNumber,
          preferredCommunication: preferredCommunication,
        ),
        spacing(),
        CardRowData(
            isHorizontal: isHorizontal,
            isCard: isCard,
            cardHeight: cardHeight,
            icon: 'assets/icons/email_icon.svg',
            data: Email)
      ],
    );
  }
}
