import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/custom/8-custom_filter_app.dart';
import 'package:demo_app/generated/l10n.dart';
import 'dart:ui' as ui;

import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/custom/11_custom_confirm_diaolog.dart';

import '../widgets/grc/custom_botton.dart';

class ViewCustomWidget extends StatefulWidget {
  const ViewCustomWidget({super.key});

  @override
  State<ViewCustomWidget> createState() => _ViewCustomWidgetState();
}

class _ViewCustomWidgetState extends State<ViewCustomWidget> {
  String? selectedStateFilter;

  Map<String, int> stateCounts = {
    "In Use": 0,
    "Returned": 0,
    "Maintenance": 0,
    "Under Repair": 0,
    "Damaged": 0,
    "Missing": 0,
    "Stolen": 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StatusChipFilter(
            selectedKey: selectedStateFilter ?? '',
            onSelected: (key) => setState(() {
              selectedStateFilter = key;
            }),
            items: [
              StatusChipItem(key: "In Use",       label: S.of(context).inUse,       count: stateCounts["In Use"] ?? 0,       labelColor: const Color(0xFF4BB609)),
              StatusChipItem(key: "Returned",     label: S.of(context).returned,     count: stateCounts["Returned"] ?? 0,     labelColor: const Color(0xFFDF1C1C)),
              StatusChipItem(key: "Maintenance",  label: S.of(context).maintenance,  count: stateCounts["Maintenance"] ?? 0,  labelColor: const Color(0xFFE5B800)),
              StatusChipItem(key: "Under Repair", label: S.of(context).underRepair,  count: stateCounts["Under Repair"] ?? 0, labelColor: const Color(0xFFFFDE59)),
              StatusChipItem(key: "Damaged",      label: S.of(context).damaged,      count: stateCounts["Damaged"] ?? 0,      labelColor: const Color(0xFFBA1B1B)),
              StatusChipItem(key: "Missing",      label: S.of(context).missing,      count: stateCounts["Missing"] ?? 0,      labelColor: const Color(0xFF797979)),
              StatusChipItem(key: "Stolen",       label: S.of(context).stolen,       count: stateCounts["Stolen"] ?? 0,       labelColor: const Color(0xFF797979)),
            ],
          ),
          SizedBox(height: 12.h),
          StatusChipFilter(
            selectedKey: selectedStateFilter ?? '',
            onSelected: (key) => setState(() {
              selectedStateFilter = key;
            }),
            items: [
              StatusChipItem(key: "Approved",    label: S.of(context).inUse,       count: stateCounts["In Use"] ?? 0),
              StatusChipItem(key: "Reject",      label: S.of(context).returned,     count: stateCounts["Returned"] ?? 0),
              StatusChipItem(key: "Done",        label: S.of(context).maintenance,  count: stateCounts["Maintenance"] ?? 0),
              StatusChipItem(key: "Pending",     label: S.of(context).underRepair,  count: stateCounts["Under Repair"] ?? 0),
              StatusChipItem(key: "In Progress", label: S.of(context).damaged,      count: stateCounts["Damaged"] ?? 0),
              StatusChipItem(key: "Canceled",    label: S.of(context).missing,      count: stateCounts["Missing"] ?? 0),
            ],
          ),
          SizedBox(height: 20.h),

          // ── Normal Dialog Button ──
          customButton(
            title: 'Normal Dialog',
            width: 200.w,
            height: 42.h,
            function: () {
              showConfirmDialog(
                context: context,
                title: 'Request To Cancellation',
                subtitle: 'Are You Sure You Want to Cancel This Request?',
                iconAsset: 'assets/icons/cancel.svg',
                onConfirm: () {
                  showCommentDialog(
                    context: context,
                    title: 'Reason Of Cancellation',
                    fieldLabel: 'Justifications',
                    onSubmit: (comment) {
                      showSuccessDialog(
                        context: context,
                        title: 'Request Cancelation',
                        subtitle: 'You Successfully Requested Cancelation For This Request',
                      );
                    },
                  );
                },
              );
            },
          ),
          SizedBox(height: 12.h),

          // ── Upload Dialog Button ──
          customButton(
            title: 'Upload Dialog',
            width: 200.w,
            height: 42.h,
            function: () {
              showUploadDialog(
                context: context,
                dialogTitle: 'Upload Document',
                titleFieldLabel: 'Document Name',
                titleFieldHint: 'Enter a name...',
                submitLabel: 'Upload',
                discardLabel: 'Cancel',
                allowedExtensions: ['pdf', 'docx', 'png', 'jpg'],
                headerIconAsset: 'assets/icons/upload.svg',
                textDirection: ui.TextDirection.ltr,
                onSubmit: (PlatformFile file, String title) {
                  // uploadToServer(file, title);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}