import 'package:flutter/cupertino.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

class UserImage extends StatelessWidget {
  final String imageUrl;
  const UserImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Container(
      width: isTablet ? (isPortrait ? 0.045.h : 0.07.h) : 0.1.w,
      height: isTablet ? (isPortrait ? 0.045.h : 0.07.h) : 0.1.w,
      decoration: BoxDecoration(
        borderRadius: isPortrait ? BorderRadius.circular(8) : null,
        shape: isPortrait ? BoxShape.rectangle : BoxShape.circle,
        image: imageUrl.contains('assets')
            ? DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.cover)
            : DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
    );
  }
}
