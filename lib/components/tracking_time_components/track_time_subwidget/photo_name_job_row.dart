// Date Created :14/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :22/November/2023
// Objectives: this is a widget to customize the container that contain the photo and data of the person
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/settings_screen.dart';

// ignore: must_be_immutable
class PhotoNameRow extends StatefulWidget {
  PhotoNameRow({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.jobTitle,
    required this.checkedIn,
    required this.checkedInState,
    this.radius,
  });
  String imageUrl;
  String name;
  String jobTitle;
  bool checkedIn;
  double? radius;
  ValueChanged<bool> checkedInState;

  @override
  State<PhotoNameRow> createState() => _PhotoNameRowState();
}

class _PhotoNameRowState extends State<PhotoNameRow> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
              right: Get.locale.toString().contains('en') ? 0.02.w : 0,
              left: Get.locale.toString().contains('en') ? 0 : 0.02.w),
          child: employee?.photo?.lastOrNull == null
              ? CircleAvatar(
                  radius: isPortrait ? 0.04.h : 0.04.h,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(
                      employee!.gender!.lastOrNull == 'female'
                          ? 'assets/images/female_avatar.png'
                          : 'assets/images/male_avatar.png'),
                )
              : CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: isPortrait ? 0.02.h : 0.04.h,
                  backgroundImage: NetworkImage(
                      employee!.photo!.last!),
                ),
        ),
        Padding(
          padding: EdgeInsets.only(top: widget.radius != null ? 0.01.h : 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: widget.radius != null
                ? CrossAxisAlignment.start
                : isTablet
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.start,
            children: [
              Text(
                widget.name.capitalize as String,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: widget.radius != null
                        ? isPortrait
                            ? FontConstants.fontSize019.h
                            : FontConstants.fontSize017.w
                        : isTablet
                            ? isPortrait
                                ? FontConstants.fontSize023.h
                                : FontConstants.fontSize031.h
                            : FontConstants.fontSize020.h,
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: isTablet
                        ? widget.radius != null
                            ? 0.01.h
                            : 0.022.h
                        : 0.015.h),
                child: Text(
                  widget.jobTitle == 'ceo'
                      ? 'CEO'.tr
                      : widget.jobTitle.capitalize.toString().tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: widget.radius != null
                          ?isPortrait?FontConstants.fontSize017.h :FontConstants.fontSize015.w
                          : isTablet
                              ? isPortrait
                                  ? FontConstants.fontSize020.h
                                  : FontConstants.fontSize026.h
                              : FontConstants.fontSize018.h,
                      color: Theme.of(context).colorScheme.scrim,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
