import 'package:demo_app/core/theme/grc_theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/components/calendar_components.dart/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/components/calendar_components.dart/custom_calendar_picker.dart';
import 'package:demo_app/components/job_components/custom_time_container.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_button.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/helper/date_time_in_arabic.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/welcome_screen/views/mobile_view/nav_bar.dart';

class CustomAcceptDialog extends StatefulWidget {
  CustomAcceptDialog({
    super.key,
    this.isEdit = false,
  });
  bool? isEdit;

  @override
  State<CustomAcceptDialog> createState() => _CustomAcceptDialogState();
}

class _CustomAcceptDialogState extends State<CustomAcceptDialog> {
  bool isEnabledDesc = false;

  List<DateTime?> selectedDate = [DateTime.now()];
  String formattedSelectedDate = '';

  TextEditingController description = TextEditingController();
  int selectedIndex = -1;
  List<String> listOfTexts = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
    "07:00 PM",
    "08:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    String formattedSelectedDate =
        DateFormat('EEEE, dd MMMM yyyy').format(selectedDate[0]!);
    String arabicFormattedDate =
        translateDateFormatToArabic(formattedSelectedDate);
    print(arabicFormattedDate);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isPortrait ? 0.1.w : 0.2.w,
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
          child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        height: null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.015.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 0.02.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: MyThemeData.colorWhiteDark,
                ),
                child: SvgPicture.asset(
                  "assets/images/approve.svg",
                  height: 0.1.h,
                ),
              ),
              SizedBox(
                height: 0.02.h,
              ),
              Text(
                "Approving Application".tr,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: isPortrait
                        ? FontConstants.fontSize022.h
                        : FontConstants.fontSize035.h,
                    fontWeight: FontWeight.w600,
                     letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                    color: Theme.of(context).colorScheme.inverseSurface,
                    height: 1.4),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.01.h),
                child: Text(
                  "Approving Application and Send Message?".tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: isPortrait
                        ? FontConstants.fontSize016.h
                        : FontConstants.fontSize029.h,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                ),
              ),
              SizedBox(
                height: isPortrait ? 0 : 0.02.h,
              ),
              if (isEnabledDesc == false)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Approving Application".tr,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: isPortrait
                              ? FontConstants.fontSize017.h
                              : FontConstants.fontSize030.h,
                          fontWeight: FontWeight.w600,
                           letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                          color: Theme.of(context).colorScheme.inverseSurface,
                          height: 1.4),
                    ),
                    SizedBox(
                      height: isPortrait ? 0.005.h : 0.015.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Thank You for your interest in our company , We’d Like to Move forward to the Next Steps with you. Please Pick one date for the Interview."
                                .tr,
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isPortrait
                                    ? FontConstants.fontSize016.h
                                    : FontConstants.fontSize029.h,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.scrim,
                                height: 1.2),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isEnabledDesc = !isEnabledDesc;
                            });
                          },
                          child: Container(
                            width:isPortrait ?0.045.w : 0.025.w,
                            height:  0.04.h,
                          // color: Colors.amber,
                            padding: EdgeInsets.all(isPortrait? 0.005.h : 0.007.h),
                            child: SvgPicture.asset(
                              'assets/icons/isEditIcon.svg',
                              color: MyThemeData.lightPrimary,
                             
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (isEnabledDesc == true)
                ColumnRequestData(
                    title: "Description",
                    isTextField: true,
                    isEdit: true,
                    hint: "Text here",
                    isOptional: false,
                    isExpanded: true,
              isDescription: true,
                    textController: description,
                    enabled: isEnabledDesc,
    
                    maxlines: 2,
                    controllerState: (value) {
                      setState(() {
                        print('Description Value ${value!}');
                      });
                    }),
              SizedBox(
                height: isPortrait ? 0.02.h : 0.04.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: 0.15.w,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: themeController.currentTheme ==
                                MyThemeData.lightTheme
                            ? MyThemeData.colorLightGrey
                            : MyThemeData.darkBackGround,
                      ),

                      /// Calender Widget
                      child: CustomCalendarPicker(
                        isReviewJob: true,
                        calendarType: CalendarDatePicker2Type.single,
                        selectedDate: selectedDate,
                        selectedDateState: (value) {
                          setState(() {
                            selectedDate = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: isPortrait ? 0.03.w : 0.02.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Get.locale.toString().contains('en')
                            ? formattedSelectedDate
                            : arabicFormattedDate,
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: isPortrait
                                ? FontConstants.fontSize015.h
                                : FontConstants.fontSize028.h,
                            fontWeight: FontWeight.w600,
                             letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                            color: Theme.of(context).colorScheme.inverseSurface,
                            height: 1.4),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: isPortrait ? 0.25.h : 0.4.h,
                          width: isPortrait ? 0.3.w : 0.25.w,
                          child: ListView.builder(
padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: listOfTexts.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    print(listOfTexts[index]);
                                  });
                                },
                                child: CustomTimeContainer(
                                  isActive: index == selectedIndex,
                                  text: listOfTexts[index],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: isPortrait ? 0.02.h : 0.04.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MainCustomButton(
                        buttonColor: MyThemeData.colorWhiteDark,
                        buttonText: 'Cancel',
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      width: 0.3.w,
                    ),
                    Expanded(
                      child: MainCustomButton(
                        buttonText: 'Send',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
