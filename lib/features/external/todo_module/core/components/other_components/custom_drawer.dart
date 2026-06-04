import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/external/main_core/core/theme/font_manager.dart';
import 'package:demo_app/features/external/main_core/core/theme/my_theme.dart';
import 'package:demo_app/features/external/todo_module/core/constants/enum.dart';
import 'package:demo_app/features/external/todo_module/core/constants/haptic_controller.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/presentation/ui/pages/tablet/todo_home_screen_tablet.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../data_grc_module/feature/settings_screen/views/settings_screen.dart';


/// Date Created :12/November/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :23/November/2023 By Bassem
/// Objectives:  this is the custom drawer that we are using in the whole application, it helps in the naviagtion between the pages.

class CustomDrawer extends StatefulWidget {
  final int selectedIndex;

  CustomDrawer({
    this.selectedIndex = 0,
  });
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    Color background = Theme.of(context).colorScheme.inversePrimary;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double height = 0.02.h;
    return Container(
      width: 0,
      //  height: 0.971.h,
      decoration: BoxDecoration(
        color: background,
      ),
      child: Container(),
    );
  }

  Widget _buildContainer(
    int index,
    String icon,
    String title,
    String iconSelected,
  ) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final ToDoHapticController hapticController =
        Get.find<ToDoHapticController>();
    final isSelected = _selectedIndex == index;
    final iconColor = isSelected && index != 11
        ? index == 9
            ? null
            : MyThemeData.colorWhite
        : mainCoreThemeController.currentTheme == MyThemeData.lightTheme
            ? index == 9
                ? null
                : MyThemeData.colorDarkGrey
            : MyThemeData.colorGreydark;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        hapticController.triggerHapticFeedback(
            vibration: VibrateType.lightImpact,
            hapticFeedback: HapticFeedback.lightImpact);
        _navigateToPage(index);
      },
      child: Container(
        width: orientation == true ? 0.08.w : 0.12.h,
        decoration: BoxDecoration(
          color: isSelected ? MyThemeData.lightPrimary : null,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 0.01.h, vertical: orientation == true ? 0 : 0.005.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0.01.h),
              child: SvgPicture.asset(
                isSelected ? iconSelected : icon,
                width: orientation == true ? 0.02.w : 0.02.h,
                height: orientation == true ? 0.035.w : 0.035.h,
                color: iconColor,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                  top: 0.01.h,
                  bottom: orientation == true ? 0.002.h : 0.005.h,
                ),
                child: orientation == false
                    ? Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: FontConstants.fontSize020.h,
                            color: isSelected
                                ? MyThemeData.colorWhite
                                : mainCoreThemeController.currentTheme ==
                                        MyThemeData.lightTheme
                                    ? MyThemeData.colorDarkGrey
                                    : MyThemeData.colorGreydark,
                            fontWeight: FontWeight.w500,
                            height: 1.2),
                      )
                    : SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 12:
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: TodoHomeScreenTablet(),
          ),
        );
        break;
      case 6:
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: Settings(),
          ),
        );
        break;

      default:
        break;
    }
  }
}

void onSignOutConfirmed() async {}
