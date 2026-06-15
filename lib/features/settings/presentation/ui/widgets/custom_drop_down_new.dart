import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/core/theme/app_colors.dart';

import '../../../../services_mangment_module/core/new_theme.dart';


class CustomDropdownFormFieldCalendar extends StatefulWidget {
  final String? selectedValue;
  final double? widthIcon;
  final Color? dropdownColor;
  final double? heightIcon;
  final Function(String?) onChanged;
  final String Function(String?)? validator;
  final double? width;
  final double? height;
  final double? spaceHeight;
  final Widget? hint;
  final String? label;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDropdownFormFieldCalendar({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
    this.widthIcon,
    this.heightIcon,
    this.validator,
    this.width,
    this.height,
    this.spaceHeight,
    this.hint,
    this.dropdownColor,
    this.label,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  State<CustomDropdownFormFieldCalendar> createState() =>
      _CustomDropdownFormFieldCalendarState();
}

class _CustomDropdownFormFieldCalendarState
    extends State<CustomDropdownFormFieldCalendar> {
  String? internalSelectedValue;
  final GlobalKey _dropdownKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    internalSelectedValue = widget.selectedValue;
  }

  Future<void> _openDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        final bool lightMode = Theme.of(context).brightness == Brightness.light;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: lightMode
                ? ColorScheme.light(primary: AppColors.primary)
                : ColorScheme.dark(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = "${picked.day}/${picked.month}/${picked.year}";

      setState(() {
        internalSelectedValue = formattedDate;
      });

      widget.onChanged(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool lightMode = Theme.of(context).brightness == Brightness.light;
    final double fieldHeight = widget.height ?? 36;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Match text field label spacing
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: StyleText.fontSize14Weight400.copyWith(
              color: AppColors.text
            ),
          ),
          SizedBox(height: 6.h), // Match CustomDropdownFormField spacing
        ],

        GestureDetector(
          onTap: _openDatePicker,
          child: Container(
            key: _dropdownKey,
            width: widget.width,
            height: widget.height?.h,
            padding: EdgeInsets.symmetric(horizontal: 8.sp),
            decoration: BoxDecoration(
              color: widget.dropdownColor ??
                AppColors.background,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: Colors.transparent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    internalSelectedValue ??
                        (widget.hint is Text
                            ? (widget.hint as Text).data ?? 'Select Date'
                            : 'Select Date'),
                    style: StyleText.fontSize12Weight400.copyWith(
                      color: internalSelectedValue != null
                          ? (AppColors.text
                      )
                          : (Colors.grey),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: isArabic ? 0 : 4.sp,
                    left: isArabic ? 4.sp : 0,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/Calendar.svg',
                      width: 16.sp,
                      height: 16.sp,
                      fit: BoxFit.fill,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Add fixed-height spacing to match text field's error/counter area
        SizedBox(height: 18.h),
      ],
    );
  }
}

