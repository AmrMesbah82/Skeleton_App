import 'package:flutter/material.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employees_hr_subwidgets/permission_switch_row.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class PermissionContainer extends StatefulWidget {
  const PermissionContainer({super.key});

  @override
  State<PermissionContainer> createState() => _PermissionContainerState();
}

class _PermissionContainerState extends State<PermissionContainer> {
  bool isOpen1 = false;
  bool isOpen2 = false;
  bool isOpen3 = false;
  bool isOpen4 = false;
  bool isOpen5 = false;
  bool isOpen6 = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius:const  BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8)
              ),
            ),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 0.02.h, horizontal: 0.015.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Permission",
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize016.w,
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Action",
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize016.w,
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PermissionSwitchRow(
            containerColor: Theme.of(context).colorScheme.surfaceVariant,
            title: "Employees Attendance",
            isOpen: isOpen1,
            isOpenState: (value) {
              setState(() {
                isOpen1 = value;
              });
            },
          ),
          PermissionSwitchRow(
            containerColor: Theme.of(context).colorScheme.inversePrimary,
            title: "Pending Projects",
            isOpen: isOpen2,
            isOpenState: (value) {
              setState(() {
                isOpen2 = value;
              });
            },
          ),
          PermissionSwitchRow(
            containerColor: Theme.of(context).colorScheme.surfaceVariant,
            title: "In Progress Projects",
            isOpen: isOpen3,
            isOpenState: (value) {
              setState(() {
                isOpen3 = value;
              });
            },
          ),
          PermissionSwitchRow(
            containerColor: Theme.of(context).colorScheme.inversePrimary,
            title: "Done Projects",
            isOpen: isOpen4,
            isOpenState: (value) {
              setState(() {
                isOpen4 = value;
              });
            },
          ),
          PermissionSwitchRow(
            containerColor: Theme.of(context).colorScheme.surfaceVariant,
            title: "Project Performance",
            isOpen: isOpen5,
            isOpenState: (value) {
              setState(() {
                isOpen5 = value;
              });
            },
          ),
          PermissionSwitchRow(
            containerColor: Theme.of(context).colorScheme.inversePrimary,
            title: "Create Task from Home Page",
            isOpen: isOpen6,
            isOpenState: (value) {
              setState(() {
                isOpen6 = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
