import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';



class YellowElevatedButton extends StatelessWidget {
  const YellowElevatedButton(
      {required this.text,
      required this.onPressed,
      this.multiplicationFactor = 1,
      super.key});
  final Text text;
  final VoidCallback onPressed;
  final double multiplicationFactor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bubbleColor, elevation: 0.8),
      onPressed: onPressed,
      child: text,
    );
  }
}
