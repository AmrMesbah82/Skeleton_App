import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class CrossAxisCountHelper {
  static int getCrossAxisCountForDefaultTablet2(BuildContext context) {
    double screenWidth = 1.sw;
    if (screenWidth > 2200) {
      return 5;
    } else if (screenWidth > 1681) {
      return 4;
    } else if (screenWidth <= 1681 && screenWidth > 1033) {
      return 3;
    } else if (screenWidth > 600 && screenWidth < 1033) {
      return 2;
    }
    return 1; // Default for phone
  }
}
