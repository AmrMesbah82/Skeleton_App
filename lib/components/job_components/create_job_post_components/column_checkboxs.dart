import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/components/job_components/create_job_post_components/cutsom_checkbox_text.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class ColumnCheckBox extends StatefulWidget {
  const ColumnCheckBox({
    super.key,
    required this.title,
    this.isOptional = false,
    this.pref = false,
  });
  final String title;
  final bool isOptional;
  final bool pref;

  @override
  State<ColumnCheckBox> createState() => _ColumnCheckBoxState();
}

class _ColumnCheckBoxState extends State<ColumnCheckBox> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                  text: widget.title.tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isTablet
                          ? isPortrait
                              ? FontConstants.fontSize019.h
                              : FontConstants.fontSize022.h
                          : FontConstants.fontSize018.h,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface,
                      height: 1.6),
                  children: widget.isOptional
                      ? [
                          WidgetSpan(
                              child: SizedBox(
                            width: 0.01.w,
                          )),
                          TextSpan(
                              text: "(${'Optional'.tr})",
                              style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isPortrait
                                    ? FontConstants.fontSize019.h
                                    : FontConstants.fontSize022.h,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.scrim,
                              ))
                        ]
                      : []),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.inversePrimary),
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: 0.02.h, horizontal: 0.015.w),
            child: widget.pref
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: isPortrait?MainAxisAlignment.spaceBetween:MainAxisAlignment.start,
                        children: [
                          CustomCheckBoxTextRow(
                            isChecked: false,
                            text: "Education",
                          ),
                          CustomCheckBoxTextRow(
                              isChecked: false, text: "Experience"),
                          CustomCheckBoxTextRow(
                              isChecked: false, text: "Interview Ability"),
                          CustomCheckBoxTextRow(
                              isChecked: false, text: "Languages"),
                        ],
                      ),
                      SizedBox(
                        height: 0.02.h,
                      ),
                      Row(
                        mainAxisAlignment: isPortrait?MainAxisAlignment.spaceBetween:MainAxisAlignment.start,
                        children: [
                          CustomCheckBoxTextRow(
                            isChecked: false,
                            text: "Skills",
                          ),
                          CustomCheckBoxTextRow(
                              isChecked: false, text: "Abillity to Relocate"),
                          CustomCheckBoxTextRow(
                              isChecked: false, text: "Social Media Links"),
                        ],
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCheckBoxTextRow(
                        isChecked: false,
                        text: "Resume",
                      ),
                      CustomCheckBoxTextRow(
                          isChecked: false, text: "License and Certifications"),
                      CustomCheckBoxTextRow(
                          isChecked: false, text: "Cover Letter"),
                    ],
                  ),
          ),
        )
      ],
    );
  }
}
