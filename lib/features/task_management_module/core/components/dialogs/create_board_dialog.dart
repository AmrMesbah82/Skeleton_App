import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CreateBoardDialog extends StatelessWidget {
  final ValueChanged<String?>? dropDownValueState;
  const CreateBoardDialog({super.key, this.dropDownValueState});
  @override
  Widget build(BuildContext context) => AlertDialog(title: Text('Create Board'.tr));
}
