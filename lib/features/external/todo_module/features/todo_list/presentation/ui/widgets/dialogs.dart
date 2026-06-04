import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/todo_module/core/components/other_components/success_dialog.dart';
import 'package:demo_app/features/external/todo_module/core/constants/app_constanst.dart';
import 'package:demo_app/features/external/todo_module/core/widgets/dialogs/two_buttoned_dialog.dart';

Future<dynamic> deleteTodoSuccessDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return const SuccessDialog(
        title: AppConstants.success,
        subtitle: AppConstants.deleteListSuccess,
        lottieAsset: "assets/images/correct.json",
      );
    },
  );
}

Future<dynamic> deleteTodoDialog(
    BuildContext context, void Function() onPrimaryPressed) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return TwoButtonedDialog(
        title: AppConstants.deleteList,
        subtitle: AppConstants.sureDeleteList.tr,
        onPrimaryPressed: () {},
        onSecondaryPressed: () => Get.back(),
        lottieAsset: "assets/images/deletion.json",
      );
    },
  );
}

Future<dynamic> recoverTodoSuccessDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return const SuccessDialog(
        title: AppConstants.success,
        subtitle: "Todo Successfully Recovered",
        lottieAsset: "assets/images/correct.json",
      );
    },
  );
}

Future<dynamic> recoverTodoDialog(
    BuildContext context, Function() onPrimaryPressed) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return TwoButtonedDialog(
        lottieAsset: "assets/images/delete_member.json",
        title: "Recover ToDo",
        subtitle: "Are You Sure You Want To Recover This To Do List",
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: () => Get.back(),
      );
    },
  );
}

Future<dynamic> deleteCommentSuccessDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return const SuccessDialog(
        title: AppConstants.success,
        subtitle: AppConstants.deleteSuccess,
        lottieAsset: "assets/images/correct.json",
      );
    },
  );
}

Future<dynamic> deleteCommentDialog(
    BuildContext context, Function() onPrimaryPressed) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return TwoButtonedDialog(
        lottieAsset: "assets/images/deletion.json",
        title: AppConstants.delete,
        subtitle: AppConstants.sureDelete.tr,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: () => Get.back(),
      );
    },
  );
}
