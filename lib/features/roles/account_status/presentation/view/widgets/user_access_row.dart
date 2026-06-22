import 'package:flutter/material.dart';
import 'package:demo_app/features/roles/account_status/presentation/view/widgets/custom_user_access_container.dart';
import 'package:demo_app/features/roles/account_status/presentation/view/widgets/custom_user_access_container_vertical.dart';

import '../../../domain/entity/account_status_access_entity.dart';

class UserAccessRow extends StatelessWidget {
  AccountStatusAccessEntity accountStatusAccessEntity;
  final VoidCallback? onPressed;
  final Function(String)? onDateTimeSelected;
  final Function(String)? onDailogPressed;
  UserAccessRow({
    Key? key,
    required this.accountStatusAccessEntity,
    this.onPressed,
    this.onDateTimeSelected,
    this.onDailogPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (isPortrait)
              Expanded(
                child: CustomUserAccessContainerVertical(
                    accountStatusEntity: accountStatusAccessEntity),
              )
            else
              Expanded(
                child: CustomUserAccessContainer(
                  accountStatusEntity: accountStatusAccessEntity,
                ),
              ),
          ],
        );
      },
    );
  }
}
