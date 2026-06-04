import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/features/external/task_management_module/borad/view/board_create/create_board_screen.dart';
import 'package:demo_app/features/external/task_management_module/core/components/dialogs/create_board_dialog.dart';
import 'package:demo_app/features/skeleton/home/presentation/ui/widgets/rounded_image_text_container.dart';
import 'package:demo_app/features/skeleton/roles/presentation/ui/pages/role_responsive_page.dart';
import 'package:demo_app/features/skeleton/roles/presentation/ui/pages/role_screen.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/settings_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../nav_bar_package.dart/functions.dart';
import '../../../../../../nav_bar_package.dart/model.dart';
import '../../../../../external/main_core/core/theme/app_colors.dart';
import '../../../../app_drawer/presentation/controller/drawer_controller.dart';
import '../../../../nav_bar/presentation/controller/nav_bar_controller.dart';
import '../../../../roles/domain/enums/modules_enum.dart';
import '../../controller/skeleton_home_controller.dart';

class ActionButtonsRow extends StatelessWidget {
  ActionButtonsRow({super.key});

  SkeletonHomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final HapticController hapticController = Get.find();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Mode.owner != false ? 0 : 25.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Mode.owner)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25.h),
              child: Text(
                "Quick Actions".tr,
                style: isTablet
                    ? orientation
                        ? AppTextStyles.font20BlackCairoMedium
                        : AppTextStyles.font22BlackCairoMedium
                    : AppTextStyles.font18BlackCairoMedium,
              ),
            ),
          Row(
            children: [
              controller.modules.contains(Modules.tasks)
                  ? Expanded(
                      child: InkWell(
                        onTap: () {
                          isTablet
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CreateBoardDialog(
                                      dropDownValueState: (value) {
                                        hapticController.triggerHapticFeedback(
                                          vibration: VibrateType.mediumImpact,
                                          hapticFeedback:
                                              HapticFeedback.mediumImpact,
                                        );
                                      },
                                    );
                                  },
                                )
                              : PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.fade,
                                  withNavBar: false,
                                  screen: const CreateBoardScreenMobile(),
                                );
                        },
                        child: RoundedImageTextContainer(
                          imagePath: "assets/images/file_new2.svg",
                          text: "Create Tasks",
                          imageIcon: AppColors.primary,
                        ),
                      ),
                    )
                  : const SizedBox(),
              controller.modules.contains(Modules.tasks)
                  ? SizedBox(width: 20.w)
                  : const SizedBox.shrink(),
              Expanded(
                child: InkWell(
                  onTap: () {
                    hapticController.triggerHapticFeedback(
                        vibration: VibrateType.lightImpact,
                        hapticFeedback: HapticFeedback.lightImpact);
                    /*               showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CreateEditTodoDialog(searchText: "");
                      },
                    ); */
                  },
                  child: RoundedImageTextContainer(
                    imagePath: "assets/images/todo_final.svg",
                    text: "Create To Do's",
                    imageIcon: AppColors.primary,
                  ),
                ),
              ),
              controller.modules.contains(Modules.messages)
                  ? SizedBox(width: 20.w)
                  : const SizedBox.shrink(),
              controller.modules.contains(Modules.messages)
                  ? Expanded(
                      child: InkWell(
                        onTap: () {
                          hapticController.triggerHapticFeedback(
                              vibration: VibrateType.lightImpact,
                              hapticFeedback: HapticFeedback.lightImpact);
                          if (isTablet) {
                            Get.find<AppDrawerController>().updateSelectedIndex(
                                Get.find<AppDrawerController>()
                                    .allowedDrawerModules
                                    .indexOf(Modules.messages));
                          } else {
                            Mode.controller.jumpToTab(
                                Get.find<NavBarController>()
                                    .navBarModules
                                    .indexOf(Modules.messages));
                          }
                        },
                        child: RoundedImageTextContainer(
                          imagePath: "assets/images/messages_home.svg",
                          text: "Send Messages",
                          imageIcon: AppColors.primary,
                        ),
                      ),
                    )
                  : const SizedBox(),
              if (Mode.owner) SizedBox(width: 20.w),
              if (Mode.owner)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      hapticController.triggerHapticFeedback(
                          vibration: VibrateType.lightImpact,
                          hapticFeedback: HapticFeedback.lightImpact);
                      isTablet
                          ? Get.find<AppDrawerController>().updateSelectedIndex(
                              Get.find<AppDrawerController>()
                                  .allowedDrawerModules
                                  .indexOf(Modules.settings))
                          : Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: SettingsScreen(),
                              ));
                    },
                    child: RoundedImageTextContainer(
                      imagePath: "assets/images/update_info.svg",
                      text: "Update Info's",
                      imageIcon: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          if (Mode.owner)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25.h),
              child: Text(
                "System Managements".tr,
                style: isTablet
                    ? orientation
                        ? AppTextStyles.font20BlackCairoMedium
                        : AppTextStyles.font22BlackCairoMedium
                    : AppTextStyles.font18BlackCairoMedium,
              ),
            ),
          if (Mode.owner != false)
            Row(
              children: [
                if (!isTablet) const Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: isTablet ? 1 : 2,
                  child: InkWell(
                    onTap: () {
                      hapticController.triggerHapticFeedback(
                          vibration: VibrateType.lightImpact,
                          hapticFeedback: HapticFeedback.lightImpact);
                      isTablet
                          ? Get.find<AppDrawerController>().updateSelectedIndex(
                              Get.find<AppDrawerController>()
                                  .allowedDrawerModules
                                  .indexOf(Modules.roles))
                          : Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: RoleResponsivePage(),
                              ),
                            );
                    },
                    child: RoundedImageTextContainer(
                      imagePath: "assets/images/create_role_new1.svg",
                      text: "Create Roles",
                      imageIcon: Color(0xFF4BB609),
                    ),
                  ),
                ),
                controller.modules.contains(Modules.employees)
                    ? SizedBox(width: !isTablet ? 20.w : 20.w)
                    : const SizedBox.shrink(),
                controller.modules.contains(Modules.employees)
                    ? Expanded(
                        flex: isTablet ? 1 : 2,
                        child: InkWell(
                          onTap: () {},
                          child: RoundedImageTextContainer(
                            imagePath: "assets/images/add_employee_new1.svg",
                            text: "Add Employees",
                            imageIcon: AppColors.primary,
                          ),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(width: !isTablet ? 20.w : 20.w),
                Expanded(
                  flex: isTablet ? 1 : 2,
                  child: InkWell(
                    onTap: () {
                      hapticController.triggerHapticFeedback(
                          vibration: VibrateType.lightImpact,
                          hapticFeedback: HapticFeedback.lightImpact);
                      if (isTablet) {
                        Get.find<AppDrawerController>().updateSelectedIndex(
                            Get.find<AppDrawerController>()
                                .allowedDrawerModules
                                .indexOf(Modules.roles),
                            isOnlyDrawer: true);
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: RoleScreen(
                              selectedIndex: 2,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: RoleResponsivePage(
                                //selectedIndex: 2,
                                ),
                          ),
                        );
                      }
                    },
                    child: RoundedImageTextContainer(
                      imagePath: "assets/images/deactivate1.svg",
                      text: "Deactivate Users",
                      imageIcon: Color(0xFFB81512),
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                if (isTablet)
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.lightImpact,
                            hapticFeedback: HapticFeedback.lightImpact);
                        Get.find<AppDrawerController>().updateSelectedIndex(
                            Get.find<AppDrawerController>()
                                .allowedDrawerModules
                                .indexOf(Modules.roles),
                            isOnlyDrawer: true);
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: RoleScreen(selectedIndex: 4),
                          ),
                        );
                      },
                      child: RoundedImageTextContainer(
                        imagePath: "assets/images/export_loggs.svg",
                        text: "Export logs",
                        imageIcon: AppColors.primary,
                      ),
                    ),
                  ),
                if (!isTablet) const Expanded(flex: 1, child: SizedBox())
              ],
            ),
        ],
      ),
    );
  }
}
