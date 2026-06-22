
import 'package:flutter/material.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApprovalCycleWidget extends StatelessWidget {
  const ApprovalCycleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return approvalCycleView(context);
  }
  Widget approvalCycleView(BuildContext context) {
    final items = List.generate(5, (index) => index);
    final itemsPerRow = 3;

    // Break items into rows
    final rows = <List<int>>[];
    for (var i = 0; i < items.length; i += itemsPerRow) {
      rows.add(items.sublist(i, (i + itemsPerRow).clamp(0, items.length)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(rows.length, (rowIndex) {
        final rowItems = rows[rowIndex];

        return Padding(
          padding: EdgeInsets.only(top: rowIndex == 0.h ? 0.h : 10.h, left: rowIndex == 0.w ? 0.w : 30.w),
          child: Row(
            children: List.generate(rowItems.length, (i) {
              final index = rowItems[i];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(image: AssetImage('assets/images/Ellipse 225.png'),width: 35.w,height: 35.h,fit: BoxFit.fill,),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ahmed Abd el Rahman", style: TextStyle(fontSize: 10.sp)),
                      Text(S.of(context).department_hr, style: TextStyle(fontSize: 10.sp, color: AppColors.red)),
                    ],
                  ),
                  if (index != items.length - 1) // skip arrow after last
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Icon(Icons.arrow_forward, size: 30.sp),
                    ),
                ],
              );
            }),
          ),
        );
      }),
    );
  }
}
