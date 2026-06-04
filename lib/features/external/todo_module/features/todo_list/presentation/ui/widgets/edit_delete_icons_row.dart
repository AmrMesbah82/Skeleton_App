import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/todo_module/core/components/other_components/custom_icon_button.dart';
import 'package:demo_app/features/external/todo_module/core/constants/app_constanst.dart';
import 'package:demo_app/features/external/todo_module/core/widgets/reusable_icon_container.dart';
import 'package:demo_app/features/external/todo_module/features/todo_create_and_edit/presentation/UI/screens/mobile/edit_todo_mobile.dart';
import 'package:demo_app/features/external/todo_module/features/todo_create_and_edit/presentation/UI/screens/tablet/edit_todo_tablet.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/todo_model.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';

import '../../../../../../../../../nav_bar_package.dart/functions.dart';
import '../../../../../../../../../nav_bar_package.dart/model.dart';

class EditAndDeleteButtonsRowDetailsScreen extends StatelessWidget {
  const EditAndDeleteButtonsRowDetailsScreen({
    super.key,
    required this.controller,
    required this.model,
  });

  final TodoController controller;
  final TodoModel model;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return isTablet
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomIconButton(
                buttonText: AppConstants.edit.tr,
                onPressed: () {
                  controller.selecetedTodoModel = model;
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                    screen: EditTodoTablet(todoModel: model),
                    withNavBar: false,
                  );
                },
                imagePath: "assets/icons/Pen New Square.svg",
              ),
              SizedBox(width: 15),
              CustomIconButton(
                buttonColor: AppColors.red,
                textColor: AppColors.white,
                imageColor: AppColors.white,
                imagePath: 'assets/icons/deleteIcon.svg',
                buttonText: AppConstants.delete.tr,
                onPressed: () {
                  controller.deleteToDoStatus(model, context);
                },
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ReusableIconContainer(
                filterColor: true,
                imagePath: "assets/icons/Pen New Square.svg",
                onPressed: () {
                  controller.selecetedTodoModel = model;
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                    screen: EditTodoMobile(todoModel: model),
                  );
                },
              ),
              SizedBox(width: 15),
              ReusableIconContainer(
                iconHeight: 20,
                backgroundRed: true,
                foregroundWhite: true,
                imagePath: 'assets/icons/deleteIcon.svg',
                onPressed: () {
                  controller.deleteToDoStatus(model, context);
                },
              ),
            ],
          );
  }
}
