import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIcon extends StatelessWidget {
  final Function()? onTap;
  final String svgPath;
  final Color color;
  const CustomIcon(
      {super.key, this.onTap, required this.svgPath, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(
            svgPath,
            // width: 20,
            // height: 24,
          ),
        ),
      ),
    );
  }
}
