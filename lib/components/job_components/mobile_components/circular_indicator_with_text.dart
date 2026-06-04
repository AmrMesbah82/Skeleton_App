import 'package:flutter/material.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/core/theme/font_manager.dart';

import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CircularIndicatorWithText extends StatelessWidget {
  final double percentage;

  const CircularIndicatorWithText({
    Key? key,
    required this.percentage,
  }) : super(key: key);

  Color _getColor(double percentage) {
    if (percentage <= 20) {
      return MyThemeData.delete;
    } else if (percentage <= 75) {
      return MyThemeData.warning;
    } else if (percentage >= 75) {
      return MyThemeData.unBlock;
    } else {
      return MyThemeData.unBlock;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(width: 0.06.h, height: 0.06.h, child: CircleProgressMaster()
            // (
            //   strokeWidth: 6.0,
            //   value: percentage / 100,
            //   valueColor: AlwaysStoppedAnimation<Color>(_getColor(percentage)),
            //),
            ),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: FontConstants.fontSize018.h,
              color: Theme.of(context).colorScheme.inverseSurface,
              height: 1.6,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
