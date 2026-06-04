import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_button.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class AddCheckListDialog extends StatefulWidget {
  const AddCheckListDialog({
    super.key,
    this.isEdit = false,
  });
  final bool isEdit;

  @override
  State<AddCheckListDialog> createState() => _AddCheckListDialogState();
}

class _AddCheckListDialogState extends State<AddCheckListDialog> {
  TextEditingController listName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 0.3.w,
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        height: 0.3.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.015.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FiltersAppBar(
                  imageUrl: "assets/images/add_checklist.svg",
                  title: "Add Check list"),
              ColumnRequestData(
                fillColor: Colors.transparent,
                title:
                    widget.isEdit ? "Edit Check List Name".tr : "List Name".tr,
                isTextField: true,
                textController: listName,
                hint: "Text Here".tr,
                isOptional: false,
                isExpanded: true,
                readOnly: false,
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.03.h),
                child: MainCustomButton(
                  buttonText: widget.isEdit ? 'Edit'.tr : 'Add'.tr,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
