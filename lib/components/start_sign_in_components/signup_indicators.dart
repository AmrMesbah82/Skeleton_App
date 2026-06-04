import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/employees/presentation/ui/widgets/add_employee_page_widgets/indicator_column.dart';
import 'package:demo_app/core/theme/screen_size.dart';

// ignore: must_be_immutable
class SignUpIndicators extends StatefulWidget {
  SignUpIndicators({
    super.key,
    required this.companyInformation,
    required this.companyService,
    required this.confirmations,
    required this.contactInformation,
    required this.currentIndex,
  });
  double companyInformation;
  double companyService;
  double contactInformation;
  double confirmations;
  int currentIndex;

  @override
  State<SignUpIndicators> createState() => _SignUpIndicatorsState();
}

class _SignUpIndicatorsState extends State<SignUpIndicators> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.01.w, vertical: 0.03.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IndicatorColumn(
              title: "Company Information",
              value: widget.companyInformation,
              widthStrok: Get.locale.toString().contains('en')
                  ? isPortrait
                      ? 0.24.w
                      : 0.145.w
                  : isPortrait
                      ? 0.185.w
                      : 0.115.w,
              currentIndex: widget.currentIndex == 0,
            ),
            IndicatorColumn(
              title: "Company Services",
              value: widget.companyService,
              widthStrok: Get.locale.toString().contains('en')
                  ? isPortrait
                      ? 0.19.w
                      : 0.128.w
                  : isPortrait
                      ? 0.155.w
                      : 0.1.w,
              currentIndex: widget.currentIndex == 1,
            ),
            IndicatorColumn(
              title: "Contact Information",
              value: widget.contactInformation,
              widthStrok: Get.locale.toString().contains('en')
                  ? isPortrait
                      ? 0.22.w
                      : 0.14.w
                  : isPortrait
                      ? 0.19.w
                      : 0.12.w,
              currentIndex: widget.currentIndex == 2,
            ),
            IndicatorColumn(
              title: "Confirmation",
              value: widget.confirmations,
              widthStrok: Get.locale.toString().contains('en')
                  ? isPortrait
                      ? 0.13.w
                      : 0.09.w
                  : isPortrait
                      ? 0.07.w
                      : 0.05.w,
              currentIndex: widget.currentIndex == 3,
            ),
          ],
        ),
      ),
    );
  }
}
