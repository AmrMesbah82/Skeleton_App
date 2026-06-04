    import 'dart:io';

import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/screen_size.dart';

double getSwitchHeightSize(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = Platform.isLinux || Platform.isMacOS || Platform.isWindows;

    if (isDesktop && screenHeight >= 611 && screenHeight < 810) {
      return 0.035.h;
    } else if (isDesktop && screenHeight >= 810 && screenHeight < 900) {
      return 0.03.h;
    } else if (isDesktop && screenHeight >= 900 && screenHeight < 950) {
      return 0.03.h;
    } else if (isDesktop && screenHeight >= 950 && screenHeight < 1000) {
      return 0.028.h;
    }
     else if (isDesktop && screenHeight >= 1000) {
      return  0.025.h;
    }

    return 0.04.h;
  }
   double getSwitchWidthSize(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = Platform.isLinux || Platform.isMacOS || Platform.isWindows;

    if (isDesktop && screenHeight >= 611 && screenHeight < 810) {
      return 0.04.w;
    } else if (isDesktop && screenHeight >= 810 && screenHeight < 900) {
      return 0.035.w;
    } else if (isDesktop && screenHeight >= 900 && screenHeight < 950) {
      return 0.035.w;
    } else if (isDesktop && screenHeight >= 950 && screenHeight < 1000) {
      return 0.035.w;
    }
     else if (isDesktop && screenHeight >= 1000) {
      return  0.035.w;
    }

    return 0.035.w;
  }