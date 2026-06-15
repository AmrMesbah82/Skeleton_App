// ==================== FILE 1: services_actions.dart ====================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_icon_button.dart';
import 'package:demo_app/core/widgets/standard_container.dart';
import 'package:demo_app/features/services_mangment_module/core/new_theme.dart';
import 'package:demo_app/features/home/data/models/home_component_model.dart';

import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../services_mangment_module/Category/presentation/ui/service_department_manager/tablet/s1_create_service/name_and_description/presentation/create_new_services_toggle.dart';
import '../../../../../services_mangment_module/Category/presentation/ui/service_department_manager/tablet/s3_services_requests/my_requests/my_request_toggle.dart';
import '../../../../../services_mangment_module/Category/presentation/ui/service_employee/Widget/W2_Navigator.dart';

class ServicesActions extends StatelessWidget {
  ServicesActions({super.key, required this.model});

  final HomeComponentModel model;

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light ;
    var isMobile = context.isPhone;
    return Container(
      height: isMobile ? 115.h : 130.h,
      child: StandardContainer(
        child: SizedBox(
          width: 140.sp,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 7.sp,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Services'.tr,
                      style: isMobile ? StyleText.fontSize12Weight500.copyWith(
                          color: AppColors.text
                      ) : AppTextStyles.font14BlackCairoMedium
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SvgPicture.asset(
                      'assets/skeleton/home/icons/service.svg',
                      width: isMobile ? 12.w : 20.w ,
                      height: isMobile ? 12.h : 20.h ,
                      fit: BoxFit.scaleDown,
                      color: AppColors.primary,
                    )
                  ],
                ),


                SizedBox(height: 2.sp),
                CustomButton(
                  height: 25.h,
                  textStyle: StyleText.fontSize14Weight400.copyWith(
                      color: AppColors.textButton
                  ),
                  buttonText: 'Create Service'.tr,
                  onTap: () {
                    navigateTo(context, CreateNewServicesLayout());
                  },
                ),

                Column(
                  children: [
                    CustomButton(
                      height: 25.h,
                      textStyle: StyleText.fontSize14Weight400.copyWith(
                          color: AppColors.textButton
                      ),
                      buttonText: 'My Requests'.tr,
                      onTap: () {
                        // Navigate to My Requests page (Admin view)
                        navigateTo(context, MyRequestServicesToggle());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}