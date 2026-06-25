import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/core/new_theme.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/generated/l10n.dart';

class ExpandedContent extends StatefulWidget {
  ExpandedContent({required this.content, required this.title});
  String title;
  Widget content;
  @override
  State<ExpandedContent> createState() => _ExpandedContentState();
}

class _ExpandedContentState extends State<ExpandedContent> {
  bool isHide = false;
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Column(
      spacing: 8.sp,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: AppTextStyles.font16BlackSemiBoldCairo.copyWith(
                color:AppColors.text
              ),
            ),
            Spacer(),
            InkWell(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                isHide = !isHide;
                setState(() {});
              },
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isHide ? S.of(context).show : S.of(context).hide,
                      style: AppTextStyles.font10BlackCairoRegular.copyWith(
                        color: AppColors.blue,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      height: 1,
                      color: AppColors.blue,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        if (!isHide) widget.content,
      ],
    );
  }
}
