import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../core/helper/cross_axis_count_helper.dart';
import '../../../../../../../core/widgets/confirm_dialog.dart';
import '../../../../../../../core/widgets/loading.dart';
import '../../../../../../../core/widgets/pagination_app_bar.dart';
import '../../../../domain/entity/user_permission_entity.dart';
import '../../../controller/user_management_cubit.dart';
import '../../../../utils/role_log_service.dart';
import '../../widgets/user_management/access_info.dart';
import '../../widgets/user_management/access_search_and_filter.dart';
import '../../widgets/user_management/person_state_view.dart';

class EditRoleUserAccess extends StatelessWidget {
  EditRoleUserAccess({super.key});

  late UserManagementAccessCubit controller;
  @override
  Widget build(BuildContext context) {
    controller = context.read<UserManagementAccessCubit>();
    bool isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.only(
              start: isTablet ? 30.sp : 15.sp, end: 15.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaginationAppBar(screensTitles: [
                'Platform Controls and Management'.tr,
                'User Access Details'.tr,
                'Editing'.tr
              ]),
              AccessInfo(),
              SizedBox(height: 20.sp),
              AccessSearchAndFilter(),
              SizedBox(height: 10.sp),
              BlocBuilder<UserManagementAccessCubit, UserManagementAccessState>(
                builder: (context, state) {
                  List<UserPermissionEntity> userPermissions = [];
                  for (UserPermissionEntity permission
                      in controller.filteredEmployeeToGiveAccess) {
                    if (!controller.selectedUsersIdToChangeAccess
                        .contains(permission.employeeId)) {
                      userPermissions.add(permission);
                    }
                  }

                  return Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: CrossAxisCountHelper
                              .getCrossAxisCountForDefaultTablet2(context),
                          mainAxisExtent: 100.sp,
                          mainAxisSpacing: 10.sp,
                          crossAxisSpacing: 10.sp,
                        ),
                        itemCount: userPermissions.length,
                        itemBuilder: (context, index) {
                          return PersonStateView(
                              onTap: () {

                                ConfirmDialog().show(context,
                                    title: 'Remove Access'.tr,
                                    subtitle:
                                    'Are you sure you want to remove this access?'.tr,
                                    icon: 'assets/lottie/delete.json',
                                    onCancel: () {}, onConfirm: () async {
                                      RoleLogService.log(RoleLogService.actionRevokeAccess);
                                      showLoadingIndicator();
                                      controller.selectUserToChangeAccess(
                                          userPermissions[index].employeeId);
                                      await controller.removeUserAccess(userPermissions[index]);
                                      hideLoadingIndicator();

                                    });
                              },
                              showAccessDates: true,
                              isEdit: true,
                              isSelected: controller
                                  .selectedUsersIdToChangeAccess
                                  .contains(userPermissions[index].employeeId),
                              person: userPermissions[index]);
                        }),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
