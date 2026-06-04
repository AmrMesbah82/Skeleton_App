import 'package:flutter/material.dart';

import '../theme/my_theme.dart';

///  Developer's Name: Bassel Attia
///  Date: 5/8/2023
///  App Version : Knowticed V1
///  Date of Last Edit: 5/8/2023
///
/// It's a radio button that's either selected or not. On property isBlack: true,
/// the color of the switch changes to black.
class MySwitch extends StatelessWidget {
  const MySwitch({
    super.key,
    required this.isSelected,
    this.isBlack = false,
    required this.switchSize ,
  });
  final bool isBlack;
  final bool isSelected;

  final double switchSize;

  @override
  Widget build(BuildContext context) {
    late final Color selectedColor = isBlack
        ? Theme.of(context).colorScheme.onInverseSurface
        : MyThemeData.lightPrimary;
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: isSelected ? selectedColor : MyThemeData.colorGrey,
              width: 2.2),
        ),
        child: Icon(Icons.circle,
            color: isSelected ? selectedColor : Colors.transparent,
            size: switchSize));
  }
}
