import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InverseVerticalSpacer extends StatelessWidget {
  InverseVerticalSpacer(this.height);
   double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height.w);
  }
}
