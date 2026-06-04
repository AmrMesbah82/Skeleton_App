import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/employees/presentation/ui/widgets/add_employee_page_widgets/indicator_column.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CreateJobIndicators extends StatefulWidget {
  CreateJobIndicators(
      {super.key,
      required this.companyInformation,
      required this.selectedIndex,
      required this.jobDetails,
      required this.pay,
      required this.preference,
      required this.preview});
  double companyInformation;
  int selectedIndex;
  double jobDetails;
  double pay;
  double preference;
  double preview;

  @override
  State<CreateJobIndicators> createState() => _CreateJobIndicatorsState();
}

class _CreateJobIndicatorsState extends State<CreateJobIndicators> {
  @override
  int index = 0;
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
              widthStrok: isPortrait
                  ? Get.locale.toString().contains("en")
                      ? 0.2.w
                      : 0.165.w
                  : Get.locale.toString().contains("en")
                      ? 0.15.w
                      : 0.115.w,
              currentIndex: widget.selectedIndex == 0,
              isCreateJob: true,
            ),
            IndicatorColumn(
              title: "Job Details",
              value: widget.jobDetails,
              widthStrok: isPortrait
                  ?Get.locale.toString().contains("en")? 0.105.w:0.15.w
                  : Get.locale.toString().contains("en")
                      ? 0.07.w
                      : 0.11.w,
              currentIndex: widget.selectedIndex == 1,
              isCreateJob: true,
            ),
            IndicatorColumn(
              title: "Pay and Benefits",
              value: widget.pay,
              widthStrok: isPortrait
                  ?Get.locale.toString().contains("en")? 0.16.w:0.12.w
                  : Get.locale.toString().contains("en")
                      ? 0.12.w
                      : 0.09.w,
              currentIndex: widget.selectedIndex == 2,
              isCreateJob: true,
            ),
            IndicatorColumn(
              title: "Set Preferences",
              value: widget.preference,
              widthStrok: isPortrait
                  ? 0.155.w
                  : Get.locale.toString().contains("en")
                      ? 0.11.w
                      : 0.1.w,
              currentIndex: widget.selectedIndex == 3,
              isCreateJob: true,
            ),
            IndicatorColumn(
              title: "Preview",
              value: widget.preview,
              widthStrok: isPortrait
                  ?Get.locale.toString().contains("en")? 0.08.w:0.1.w
                  : Get.locale.toString().contains("en")
                      ? 0.06.w
                      : 0.07.w,
              currentIndex: widget.selectedIndex == 4,
              isCreateJob: true,
            ),
          ],
        ),
      ),
    );
  }
}
