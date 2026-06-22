import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/features/services_management_module/presentation/controller/services_manager_cubit.dart';
import 'package:demo_app/features/services_management_module/presentation/s1_home_page_services/ui/pages/home_page_services_toggle.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/dialog.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/helper_method.dart';
import 'package:demo_app/features/services_management_module/presentation/s5_details_service/ui/widgets/success_dialog.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/service_permissions.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/services/services_permissions_sections.dart';
import 'package:demo_app/generated/l10n.dart';

import 'package:demo_app/core/enumeration/enum.dart' as FormatHelper;
import 'package:demo_app/core/widgets/loading.dart';
import 'package:demo_app/core/custom/button.dart';
import 'package:demo_app/core/custom/37-custom_navigate.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/12-custom_delete_icon.dart';
import 'package:demo_app/core/custom/13-custom_edit_icon.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

import 'package:demo_app/core/theme/app_text_styles.dart';

import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/services_management_module/presentation/s4_bulk_upload_services/ui/pages/create_new_services_toggle.dart';

class ServiceHeaderWidget extends StatelessWidget {
  final ServicesHistoryModel createServicesModel;

  const ServiceHeaderWidget({
    required this.createServicesModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isPhone;
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            FormatHelper.capitalize(S.of(context).serviceDetails),
            style: isMobile
                ? AppTextStyles.font16BlackSemiBoldCairo.copyWith(
              color: lightMode ? AppColors.blackButton : AppColors.white,
            )
                : AppTextStyles.font20BlackSemiBoldCairo.copyWith(
              color: lightMode ? AppColors.blackButton : AppColors.white,
            ),
          ),
        ),
        const Spacer(),

        // Edit Button
        if (Get.find<MainCoreEmployeeController>().isHasPermission(
          module: Modules.services,
          permission: ServicePermissions.editService,
          section: ServicePermissionsSections.servicesPermissions,
        ))
          CustomEditIcon(
            color: AppColors.primary,
            borderColor: Colors.transparent,
            svgColor: AppColors.textButton,
            title: isMobile ? "" : FormatHelper.capitalize(S.of(context).Edit),
            textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
              color: AppColors.textButton,
            ),
            onTap: () async {
              showLoadingIndicator();

              try {
                await ServicesManagerCubit.get(context)
                    .debugCreateServicesStructure(createServicesModel.currentId);

                final model = await ServicesManagerCubit.get(context)
                    .getDocToEdit(createServicesModel.currentId);

                hideLoadingIndicator();

                if (model != null) {
                  navigateTo(
                    context,
                    CreateNewServicesLayout(
                      editingModel: model,
                      docId: model.currentId,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).failedToLoadServiceData),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              } catch (e, stackTrace) {
                hideLoadingIndicator();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
          ),

        SizedBox(width: 15.w),

        // Delete Button
        if (Get.find<MainCoreEmployeeController>().isHasPermission(
          module: Modules.services,
          permission: ServicePermissions.deleteService,
          section: ServicePermissionsSections.servicesPermissions,
        ))
          CustomDeleteIcon(
            color: AppColors.red,
            borderColor: Colors.transparent,
            svgColor: AppColors.white,
            title: isMobile ? "" : FormatHelper.capitalize(S.of(context).Delete),
            textStyle: AppTextStyles.font16BlackMediumCairo.copyWith(
              color: AppColors.white,
            ),
            onTap: () {
              showConfirmationDialogServicesDetails(
                lottiePath: "assets/lottie/delete.json",
                title: S.of(context).deleteServices,
                message: S.of(context).AreYouSureDeleteThisService,
                onConfirm: () async {
                  await ServicesManagerCubit.get(context)
                      .deleteService(createServicesModel.currentId)
                      .then((val) async {
                    await ServicesManagerCubit.get(context).getAllServices();
                    navigateTo(context, LayoutScreenServices());
                  });

                  showSuccessDialogServicesDetails(
                    lottiePath: "assets/lottie/approved.json",
                    subtitle: S.of(context).servicesDeleteDone,
                    title: S.of(context).deleteServices,
                    context: context,
                  );
                },
                context: context,
              );
            },
          ),
      ],
    );
  }
}
