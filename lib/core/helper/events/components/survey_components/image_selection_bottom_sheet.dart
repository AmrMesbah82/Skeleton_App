import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

class ImageSelectionBottomSheet extends StatelessWidget {
  final List<String> imagePaths;
  final ValueChanged<String> onImageSelected;
  final String? titleText;

  ImageSelectionBottomSheet({
    required this.imagePaths,
    required this.onImageSelected,
    this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
       
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText ?? "Insert Image".tr,
            style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: FontConstants.fontSize022.h,
              color: Theme.of(context).colorScheme.onInverseSurface,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
          SizedBox(height: 0.02.h),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet? (isPortrait? 3 :5 ) : 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    onImageSelected(imagePaths[index]);
                    Navigator.pop(context);  
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      imagePaths[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
