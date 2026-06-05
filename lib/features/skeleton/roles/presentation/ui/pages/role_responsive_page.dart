import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_app/features/skeleton/roles/presentation/ui/pages/role_screen.dart';

import 'package:demo_app/core/widgets/responsive_helper.dart';
import '../../../../account_status/presentation/controller/account_status_cubit.dart';
import '../../controller/role_cubit.dart';
import '../../controller/user_management_cubit.dart';


RoleCubit roleCubit = RoleCubit();
AccountStatusCubit _accountStatusCubit = AccountStatusCubit();
UserManagementAccessCubit _userManagementCubit = UserManagementAccessCubit();

class RoleResponsivePage extends StatelessWidget {
  const RoleResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountStatusCubit>.value(
      value: _accountStatusCubit,
      child: BlocProvider<UserManagementAccessCubit>.value(
        value: _userManagementCubit,
        child: BlocProvider<RoleCubit>.value(
          value: roleCubit,
          child: ResponsiveHelper(
              mobileWidget: RoleScreen(),
              tabletWidget: Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) {
                      return RoleScreen();
                    },
                  );
                },
              )),
        ),
      ),
    );
  }
}
