import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildResponsiveFields({
  required BuildContext context,
  required Widget left,
  required Widget right,
  double? mobileSpacing,
}) {
  final isMobile = MediaQuery.of(context).size.width < 600;
  if (isMobile) {
    return Column(
      children: [
        left,
        SizedBox(height: (mobileSpacing ?? 15).h),
        right,
      ],
    );
  } else {
    return Row(
      children: [
        Expanded(child: left),
        SizedBox(width: 15.sp),
        Expanded(child: right),
      ],
    );
  }
}
