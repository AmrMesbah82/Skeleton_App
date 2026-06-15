import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/success_dialog.dart';
import 'package:demo_app/features/todo_module/core/widgets/dialogs/two_buttoned_dialog.dart';

Future<dynamic> createTodoSuccessDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return const SuccessDialog(
        title: "Successful",
        subtitle: "You Successfully Created The To Do",
        lottieAsset: "assets/images/correct.json",
      );
    },
  );
}

Future<dynamic> createTodoDialog(
    BuildContext context, void Function() onPrimaryPressed) {
  return showDialog(
    context: context,
    builder: (context) => TwoButtonedDialog(
      title: "Creating To Do".tr,
      subtitle: 'Are You Sure You Want To Create This To Do?'.tr,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: () {
        Navigator.of(context).pop();
      },
      lottieAsset: 'assets/icons/Animation - 1739542756531.json',
    ),
  );
}

Future<dynamic> editTodoSuccessDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return SuccessDialog(
          title: "Successful".tr,
          subtitle: "You Successfully Edited The To Do".tr,
          lottieAsset: "assets/images/correct.json",
        );
      });
}

Future<dynamic> editTodoDialog(
    BuildContext context, Function() onPrimaryPressed) {
  return showDialog(
    context: context,
    builder: (context) => TwoButtonedDialog(
      title: "Editing To Do".tr,
      subtitle: 'Are You Sure You Want To Edit This To Do?'.tr,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: () {
        Navigator.of(context).pop();
      },
      lottieAsset: 'assets/images/Animation - 1739543711942.json',
    ),
  );
}
