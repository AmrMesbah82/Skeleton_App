import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';
import 'package:demo_app/features/employees/presentation/controller/employee_controller.dart';
import 'package:demo_app/features/employees/presentation/controller/main_core_department_controller.dart';

import '../../../../../core/enumeration/enum.dart';

class FilterSelector extends StatefulWidget {
  FilterSelector({Key? key, required this.departmentState}) : super(key: key);
  ValueChanged<String?> departmentState;
  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  late String selectedElement;

  @override
  void initState() {
    super.initState();
    getDepartments();
    selectedElement = 'All';
  }

  AddDepartmentController addDepartmentController = Get.find();
  EmployeeController addEmployeeController = Get.find();
  final HapticController hapticController = Get.put(HapticController());
  Future<void> getDepartments() async {
    await addDepartmentController.getDepartments();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      constraints: BoxConstraints(
        maxWidth: isTablet
            ? isPortrait
                ? 450.w
                : 400.w
            : 300.w,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Wrap(
                children: [
                  GestureDetector(
                    onTap: () {
                      hapticController.triggerHapticFeedback(
                          vibration: VibrateType.lightImpact,
                          hapticFeedback: HapticFeedback.lightImpact);
                      setState(() {
                        selectedElement = 'All';
                        widget.departmentState('All');
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 15.w : 20.w,
                        vertical: isTablet ? 4.h : 6.h,
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.h, vertical: 8.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: selectedElement == 'All'
                              ? AppColors.primary
                              : Colors.transparent),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Text(
                            'All'.tr,
                            style: (isTablet
                                    ? isPortrait
                                        ? AppTextStyles.font18BlackCairoRegular
                                        : AppTextStyles.font14BlackRegularCairo
                                    : AppTextStyles.font12BlackCairoRegular)
                                .copyWith(
                                    color: selectedElement == 'All'
                                        ? AppColors.textButton
                                        : AppColors.secondaryBlack,
                                    height: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  for (String element in addDepartmentController.departmentIds)
                    GestureDetector(
                      onTap: () {
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.lightImpact,
                            hapticFeedback: HapticFeedback.lightImpact);
                        setState(() {
                          selectedElement = element;
                          widget.departmentState(element);
                        });
                        print(selectedElement);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 15.w : 20.w,
                          vertical: isTablet ? 4.h : 6.h,
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: 5.h, vertical: 8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: selectedElement == element
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: Text(
                                Get.locale.toString().contains('en')
                                    ? addDepartmentController
                                        .getEnglishDepartmentNameFromDepartmentId(
                                            departmentId: element)!
                                    : addDepartmentController
                                        .getArabicDepartmentNameFromDepartmentId(
                                            departmentId: element)!,
                                style: (isTablet
                                        ? isPortrait
                                            ? AppTextStyles
                                                .font18BlackCairoRegular
                                            : AppTextStyles
                                                .font14BlackRegularCairo
                                        : AppTextStyles.font12BlackCairoRegular)
                                    .copyWith(
                                        color: selectedElement == element
                                            ? AppColors.textButton
                                            : AppColors.secondaryBlack,
                                        height: 1.5),
                              )),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
