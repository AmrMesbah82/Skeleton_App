// upper_filters.dart
// Custom reusable horizontal tab filter — same UI as original, fully portable

import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpperFilters extends StatefulWidget {
  const UpperFilters({
    super.key,
    required this.filterTitles,
    required this.onChanged,
    this.initialIndex = 0,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.fontSize = 16,
    this.itemSpacing,
    this.height,
  });

  final List<String> filterTitles;

  /// Called when a tab is tapped — returns (index, label)
  final void Function(int index, String label) onChanged;

  final int initialIndex;

  // ── Optional style overrides (fall back to original colors if null) ──
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final double fontSize;
  final double? itemSpacing;
  final double? height;

  @override
  State<UpperFilters> createState() => _UpperFiltersState();
}

class _UpperFiltersState extends State<UpperFilters> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTap(int index, String title) {
    HapticFeedback.lightImpact();
    setState(() => _selectedIndex = index);
    widget.onChanged(index, title);
  }

  Widget _filterItem(String title, int index) {
    final bool isSelected = _selectedIndex == index;

    final Color selected =
        widget.selectedColor ?? const Color(0xFF1976D2); // replace with AppColors.secondaryPrimary
    final Color unselected = widget.unselectedColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFF616161)); // replace with AppColors.darkGrey / inverseBase

    final TextStyle baseStyle = TextStyle(
      fontSize: widget.fontSize.sp,
      fontWeight: FontWeight.w400,
      height: 1.2,
    );

    return GestureDetector(
      onTap: () => _onTap(index, title),
      behavior: HitTestBehavior.opaque,
      child: IntrinsicWidth(
        child: Column(
          spacing: 5.sp,
          children: [
            Text(
              title.tr,
              style: baseStyle.copyWith(
                color: isSelected ? selected : unselected,
              ),
            ),
            Container(
              height: 2,
              color: isSelected
                  ? (widget.indicatorColor ?? selected)
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _spacer() {
    final bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final double width = widget.itemSpacing ??
        (isTablet ? (isPortrait ? 0.04.w : 0.06.h) : 0.06.w);

    return SizedBox(width: width);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 0.05.h,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.filterTitles.length,
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _filterItem(widget.filterTitles[index], index),
              _spacer(),
            ],
          );
        },
      ),
    );
  }
}


//   UpperFilters(
//               height: 100.h,
//               itemSpacing: 20.w,
//               filterTitles: ['All', 'Done', 'InProgress', 'Draft', 'Reject', 'Cancel', 'Pending', 'Approved'],
//               onChanged: (index, label) {
//
//               },
//               selectedColor: AppColors.secondaryPrimary,
//               unselectedColor: AppColors.darkGrey,
//             ),