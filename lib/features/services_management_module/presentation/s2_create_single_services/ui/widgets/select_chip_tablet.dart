import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';



class SelectChipTablet extends StatefulWidget {
  final List<String> departments;
  final List<String> selectedDepartments;
  final double width;
  final Color color;
  final String title;
  final bool apper;
  final Function(String) onAdd;
  final Function(String) onRemove;
  final String iconAsset;
  final double dropdownHeight;
  final double triggerHeight;

  const SelectChipTablet({
    super.key,
    this.title = '',
    required this.departments,
    required this.width,
    required this.color,
    required this.selectedDepartments,
    required this.onAdd,
    required this.onRemove,
    this.apper = true,
    this.iconAsset = "assets/arrowdown.svg",
    this.dropdownHeight = 6 * 31.5,
    this.triggerHeight = 36.0, // default for short dropdown button like screenshot
  });

  @override
  State<SelectChipTablet> createState() => _SelectChipTabletState();
}

class _SelectChipTabletState extends State<SelectChipTablet> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isDropdownOpen = false;

  void _toggleDropdown() {
    if (isDropdownOpen) {
      _closeDropdownSafe();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    if (mounted) {
      setState(() {
        isDropdownOpen = true;
      });
    }
  }

  void _closeDropdownSafe() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) {
        setState(() {
          isDropdownOpen = false;
        });
      }
    } catch (_) {}
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: widget.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, widget.triggerHeight.h ),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.only (bottomLeft: Radius.circular(6.r), bottomRight: Radius.circular(6.r)),
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.white
                : AppColors.background,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: widget.dropdownHeight,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero, // 👈 KEY LINE to remove ListView's top/bottom space
                itemCount: widget.departments.length,
                itemBuilder: (context, index) {
                  String department = widget.departments[index];
                  bool isSelected = widget.selectedDepartments.contains(department);
                   return ListTile(
                    dense: true, // reduces default height
                    visualDensity: const VisualDensity(vertical: -4), // tighter vertically
                    minVerticalPadding: 0, // removes internal top/bottom padding
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 0.sp), // minimal padding
                    horizontalTitleGap: 8.sp, // reduce space between checkbox and text
                    leading: GestureDetector(
                      onTap: () {
                        if (!isSelected) {
                          widget.onAdd(department);
                        } else {
                          widget.onRemove(department);
                        }
                        _overlayEntry?.markNeedsBuild();
                      },
                      child: SvgPicture.asset(
                        isSelected
                            ? "assets/checkbox_fill.svg"
                            : "assets/state/unselectedSvg.svg",
                        width: 16.sp,
                        height: 16.sp,
                      ),
                    ),
                    title: Text(
                      department,
                      style: AppTextStyles.font14BlackCairoRegular.copyWith(
                        fontSize: 12.sp, // optional: reduce text size slightly
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.blackButton
                            : AppColors.white,
                      ),
                    ),
                    onTap: () {
                      if (!isSelected) {
                        widget.onAdd(department);
                      } else {
                        widget.onRemove(department);
                      }
                      _overlayEntry?.markNeedsBuild();
                    },
                  );

                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _closeDropdownSafe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              width: widget.width,
              height: widget.triggerHeight, // ✅ customizable trigger height
              padding: EdgeInsets.only(left: 8.sp, right: 8.sp),
              decoration: BoxDecoration(
                color: widget.color,
                border: Border.all(color: Colors.transparent),
                borderRadius: isDropdownOpen
                    ? BorderRadius.only(
                  topLeft: Radius.circular(6.r),
                  topRight: Radius.circular(6.r),
                )
                    : BorderRadius.all(Radius.circular(6.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.title.isNotEmpty ? widget.title : S.of(context).department,
                    style: AppTextStyles.font12BlackCairoRegular.copyWith(
                      fontSize: 12.sp,
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.secondaryText
                          : AppColors.grey,
                    ),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                    "assets/lottie/selectarrow.svg",
                    width: 18.sp,
                    height: 9.sp,
                    color:  Theme.of(context).brightness == Brightness.light ?
                    AppColors.secondaryText : AppColors.grey,
                    fit: BoxFit.scaleDown,
                  ),
                  SizedBox(width: 3.sp)
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 8.sp),
        widget.apper == true ? Wrap(
          spacing: 8,
          runSpacing: 0,
          alignment: WrapAlignment.start,
          children: widget.selectedDepartments.map((dept) {
            return Chip(
              label: Text(
                dept,
                style: AppTextStyles.font12BlackCairoRegular.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.blackButton
                      : AppColors.white,
                ),
              ),
              onDeleted: () {
                widget.onRemove(dept); // 👈 works with parent setState
                _overlayEntry?.markNeedsBuild();
              },
              deleteIcon: CircleAvatar(
                radius: 7.r,
                backgroundColor: AppColors.red,
                child: Icon(
                  Icons.remove,
                  color: AppColors.white,
                  size: 13.sp,
                ),
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? AppColors.lightGrey
                  : AppColors.background,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(6),
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: 8.sp),
            );
          }).toList(),
        )
            : SizedBox(),
      ],
    );
  }
}
