import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_yellow_button copy.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

class ReasonOfRejectionDialog extends StatefulWidget {
  const ReasonOfRejectionDialog({
    super.key,
  });

  @override
  State<ReasonOfRejectionDialog> createState() =>
      _ReasonOfRejectionDialogState();
}

class _ReasonOfRejectionDialogState extends State<ReasonOfRejectionDialog> {
  late TextEditingController rejectionReasonController;

  @override
  void initState() {
    rejectionReasonController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    rejectionReasonController.dispose();
    super.dispose();
  }

  void submitReason(BuildContext context) {
    String rejectionReason = rejectionReasonController.text.trim();
    if (rejectionReason.isNotEmpty) {
      Navigator.of(context).pop(rejectionReason); // Pass back the rejection reason text
    } else {
      // Optionally handle case where rejection reason is empty
      // You can show an error message or prevent closing the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isPortrait ? 0.15.w : 0.3.w,
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.015.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColumnRequestData(
                  title: "Reason Of Rejection",
                  isTextField: true,
                  hint: "Enter Reason Here",
                  isOptional: false,
                  isExpanded: true,
              isDescription: true,
                  maxlines: 2,
                  maxlength: 120,
                  textController: rejectionReasonController,
                  controllerfinishState: (value) {
                    setState(() {});
                  },
                  controllerState: (value) {
                    setState(() {});
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.03.h),
                  child: ReusableElevatedButton(
                    buttonText: 'Submit'.tr,
                    onPressed: () => submitReason(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
