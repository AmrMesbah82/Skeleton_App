import 'package:flutter/material.dart';
import 'package:demo_app/features/todo_module/core/constants/screen_size.dart';
import 'package:demo_app/core/theme/my_theme.dart';


// date:April/30/2024
// by:MohamedFouad
// lastUpdate:April/30/2024
// This class is used to create a circular progress indicator with a light primary color.
// It is used to indicate that an operation is in progress.
class CircleProgress extends StatelessWidget {
  const CircleProgress({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Center(
      child: SizedBox(
        width: isTablet
            ? orientation
                ? .045.h
                : .06.h
            : .045.h,
        height: isTablet
            ? orientation
                ? .045.h
                : .06.h
            : .045.h,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyThemeData.lightPrimary),
          backgroundColor: Colors.white60,
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
