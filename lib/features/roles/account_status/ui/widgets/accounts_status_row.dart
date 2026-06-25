///************************ FILE INFO ****************************///
/// File Name: accounts_status_row.dart
/// Purpose : Contains the ui for account status row in account status screen.
/// Author: Mohamed Elrashidy
/// Created at : 28/1/2025
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/enums/enum.dart';
import 'package:demo_app/features/roles/account_status/controller/account_status_cubit.dart';

import 'package:demo_app/features/roles/widgets/filter_bar_item.dart';
import 'package:demo_app/features/roles/account_status/utils/account_status_constants.dart';
import 'package:demo_app/features/roles/account_status/controller/account_status_state.dart';

class AccountsStatusRow extends StatelessWidget {
  const AccountsStatusRow({super.key});

  @override
  Widget build(BuildContext context) {
    // Use BlocBuilder to listen to state changes
    return BlocBuilder<AccountStatusCubit, AccountStatusState>(
      builder: (context, state) {
        AccountStatusCubit controller = context.read<AccountStatusCubit>();

        return SingleChildScrollView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 30.sp,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              for (int statusIndex = 0;
              statusIndex < AccountStatusConstants.employeeStatus.length;
              statusIndex++)
                FilterBarItem(
                    color: AccountStatusConstants.employeeStatus[statusIndex].color,
                    isSelected: controller.selectedStatus ==
                        AccountStatusConstants.employeeStatus[statusIndex],
                    title: capitalize(
                        AccountStatusConstants.employeeStatus[statusIndex].localizedName(context)
                    ),
                    onTap: () {
                      controller.selectStatus(
                          AccountStatusConstants.employeeStatus[statusIndex]);
                    },
                    numberOfItems: controller
                        .accountStatusEntities[
                    AccountStatusConstants.employeeStatus[statusIndex]]
                        ?.length ??
                        0),
            ],
          ),
        );
      },
    );
  }
}