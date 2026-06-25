import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/helper/task_management_module/core/constant/screen_size.dart';

import '../main_yellow_button.dart';
import '../tracking_time_components/track_time_subwidget/column_request_data.dart';
import '../tracking_time_components/track_time_subwidget/filters_appbar.dart';

class AttachmentsDialog extends StatefulWidget {
  const AttachmentsDialog({super.key});

  @override
  State<AttachmentsDialog> createState() => _AttachmentsDialogState();
}

class _AttachmentsDialogState extends State<AttachmentsDialog> {
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
                  title: "Attachment"),
              ColumnRequestData(
                fillColor: Colors.transparent,
                title: "List Name".tr,
                isTextField: true,
                textController: listName,
                hint: "Choose Attachment".tr,
                hasSuffix: true,
                suffixUrl: 'assets/images/attachsquare_field.svg',
                isOptional: false,
                isExpanded: true,
                readOnly: false,
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.03.h),
                child: ReusableElevatedButton(
                  buttonText: 'Update'.tr,
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
