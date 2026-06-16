import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/shared_components/calender_package/calendar_date_picker2.dart';
import 'package:demo_app/core/shared_components/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/core/shared_components/date_picker_class.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/enumeration/enum.dart';

import 'package:demo_app/core/helper/haptic_controller.dart';

import 'package:demo_app/core/theme/app_font_size.dart';

// ignore: must_be_immutable
class JobPostFilterDialog extends StatefulWidget {
  JobPostFilterDialog(
      {super.key,
      required this.statusValue,
      this.postedValue,
      this.submittedValue,
      this.postedState,
      required this.statusState,
      required this.submittedState,
      required this.dateValue,
      required this.dateValueState,
       
      required this.postedDropDownItems,
      required this.submittedDropDownItems});
  String? statusValue;
  String? postedValue;
  List<String> postedDropDownItems;
  ValueChanged<String?>? statusState;
  ValueChanged<String?>? postedState;
  String? submittedValue;
  List<String> submittedDropDownItems;
  ValueChanged<String?>? submittedState;
  String dateValue;
  ValueChanged<String>? dateValueState;
 
  @override
  State<JobPostFilterDialog> createState() => _JobPostFilterDialogState();
}

class _JobPostFilterDialogState extends State<JobPostFilterDialog> {
  // date picker function
  //String dateValue = "Date";

  TextEditingController date = TextEditingController();
  DateTime? selectedDate;
  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [];
  Future<void> _selectDate(BuildContext context) async {
    final List<DateTime?>? picked = await DatePicker().showDatePicker(
        context,
        _rangeDatePickerValueWithDefaultValue,
        DateTime.now(),
        CalendarDatePicker2Type.range);
    // change the selected the  with the picked date
    // ignore: unrelated_type_equality_checks
    if (picked != null && picked != selectedDate) {
      setState(() {
        _rangeDatePickerValueWithDefaultValue = picked;
        selectedDate = picked[
            0]; // get the first element in the array which is the selected date
        // final DateFormat formatter = DateFormat('dd/MM/yyyy');
        // String formattedDate = formatter.format(picked[0] as DateTime);
        // String formattedDate2 = formatter.format(picked.last as DateTime);
        widget.dateValue =
            "${'From'.tr} ${picked[0]!.day} ${DateFormat.MMM().format(picked[0]!).tr} ${picked[0]!.year} ${'To'.tr} ${picked.last!.day} ${DateFormat.MMM().format(picked.last!).tr} ${picked.last!.year}";
        widget.dateValueState!(widget.dateValue);

        date.text = widget.dateValue.substring(
            widget.dateValue.indexOf('To'.tr) + 2, widget.dateValue.length  );
      });
    }
  }

  final HapticController hapticController = Get.put(HapticController());

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? (isPortrait? 0.1.w: 0.2.w) : 0.1.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        height: null,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:  isPortrait ? 0.025.w:0.015.w, vertical: isPortrait ? 0.015.h : 0.015.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FiltersAppBar(
                imageUrl: "assets/icons/headerFilterIcon.svg",
                title: "Filter",
                iconColor: AppColors.colorWhite,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomDropdownButton2(
                          hint: "Status",
                          borded: false,
                          buttonHeight:isPortrait? 0.05.h: 0.065.h,
                          dropdownWidth: isTablet ? 0.22.w : 0.35.w,
                        
                          buttonPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 0.01.w : 0.02.w),
                          value: widget.statusValue!,
                          dropdownItems: [
                            'Open'.tr,
                            'Closed'.tr,
                          ], 
                          onChanged: (value) {
                            setState(() {
                              widget.statusValue = value;
                              widget.statusState!(value);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 0.02.w,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _selectDate(
                              context,
                            );
                          },
                          child: ColumnRequestData(
                            fillColor: Colors.transparent,
                            title: "Date",
                            textController: date,
                            hideTitle: true,
                            isTextField: true,
                            hint: "Date",
                            isOptional: false,
                            isExpanded: true,
                            enabled: false,
                            hasPrefix: true,
                            hasSuffix: true,
                            
                            suffixUrl: "assets/icons/newCalenderFixed.svg",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.02.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomDropdownButton2(
                          hint: "Posted By",
                          borded: false,
                          buttonHeight:isPortrait? 0.05.h: 0.065.h,
                          dropdownWidth: isTablet ? 0.22.w : 0.35.w,
                       
                          buttonPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 0.01.w : 0.02.w),
                          value: widget.postedValue!,
                          dropdownItems:  widget.postedDropDownItems,
                          onChanged: (value) {
                            setState(() {
                              widget.postedValue = value;
                              widget.postedState!(value);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 0.02.w,
                      ),
                      Expanded(
                        child: CustomDropdownButton2(
                      hint: "Submitted",
                      borded: false,
                      buttonHeight:isPortrait? 0.05.h: 0.065.h,
                          dropdownWidth: isTablet ? 0.22.w : 0.35.w,
                     
                      
           
                      buttonPadding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 0.01.w : 0.02.w),
                      value: widget.submittedValue!,
                      dropdownItems: widget.submittedDropDownItems,
                      onChanged: (value) {
                        setState(() {
                          widget.submittedValue = value;
                          widget.submittedState!(widget.submittedValue);
                        });
                      },
                    ),
                      ),
                    ],
                  ),
                
                ],
              ),
              SizedBox(
                height: 0.02.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical:   0.015.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MainCustomIconButton(
                      onPressed: () {
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.mediumImpact,
                            hapticFeedback: HapticFeedback.mediumImpact);
                        
                      },
                      buttonText: "Reset".tr,
                     
                      buttonStyle: ElevatedButton.styleFrom(
                        minimumSize: isTablet
                            ? isPortrait
                                ? Size(0.15.w, 0.045.h)
                                : Size(0.07.w, 0.05.h)
                            : Size(0.36.w, 0.05.h),
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.shadow),
                        ),
                      ),
                    ),
                    MainCustomIconButton(
                      onPressed: () {
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.heavyImpact,
                            hapticFeedback: HapticFeedback.heavyImpact);

                        Navigator.pop(context);
                      },
                      buttonText: "Apply".tr,
                     
                      buttonStyle: widget.dateValue == "Date" &&
                              widget.statusValue == null
                          ? ElevatedButton.styleFrom(
                              minimumSize: isTablet
                                  ? isPortrait
                                      ? Size(0.15.w, 0.045.h)
                                      : Size(0.07.w, 0.05.h)
                                  : Size(0.36.w, 0.05.h),
                              backgroundColor: AppColors.GreyBack,
                              shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.shadow),
                              ),
                            )
                          : ElevatedButton.styleFrom(
                              minimumSize: isTablet
                                  ? isPortrait
                                      ? Size(0.15.w, 0.045.h)
                                      : Size(0.07.w, 0.05.h)
                                  : Size(0.36.w, 0.05.h),
                              backgroundColor: AppColors.signOut,
                              shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.shadow),
                              ),
                            ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
