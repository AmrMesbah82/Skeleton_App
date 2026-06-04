import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:demo_app/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/buttons//custom_icon_button.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/widgets/dialogs//response_dialog.dart';

import 'package:path_provider/path_provider.dart';


class ExportTableDialog extends StatefulWidget {
  const ExportTableDialog({
    super.key,
    required this.dataRows,
  });
  final List<List<String>> dataRows;
  @override
  State<ExportTableDialog> createState() => _ExportTableDialogState();
}

List<String> headers = [
  'Department',
  'Date',
  'Time',
  'Employee Name',
  'Action',
];
List<String> headersArabic = [
  'القسم',
  'التاريخ',
  'الوقت',
  'اسم الموظف',
  'العملية',
];

class _ExportTableDialogState extends State<ExportTableDialog> {
  TextEditingController temp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet
            ? isPortrait
                ? 0.22.w
                : 0.35.w
            : 0.1.w,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.inversePrimary),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.02.h, horizontal: 0.015.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FiltersAppBar(
                  imageUrl: "assets/images/upload_signature.svg",
                  title: "Export Table".tr),
              ColumnRequestData(
                  title: "File Name".tr,
                  isTextField: true,
                  hint: "Text Here",
                  isOptional: false,
                  textController: temp,
                  controllerState: (value) {
                    temp.text = value!;
                  },
                  isExpanded: true),
              SizedBox(height: 0.01.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomIconButton(
                      buttonText: "Export",
                      imagePath: "",
                      hasIcon: false,
                      onPressed: () async {
                        showLoadingIndicator();
                        Directory? downloadsDirectory =
                            (Platform.isMacOS || Platform.isIOS)
                                ? await getApplicationDocumentsDirectory()
                                : await getDownloadsDirectory();
                        await getDownloadsDirectory();
                        if (downloadsDirectory == null) {
                          print('Could not access the Downloads directory.');
                          return;
                        }
                        String downloadsPath = downloadsDirectory.path;
                        // Create a file in the Downloads directory
                        File file = File('$downloadsPath/${temp.text}.csv');
                        List data = widget.dataRows;

                        data.insert(
                            0,
                            Get.locale.toString().contains('en')
                                ? headers
                                : headersArabic);

                        // Convert list to CSV format
                        String csv = const ListToCsvConverter()
                            .convert(data.cast<List?>());
                        print('csv: $csv');

                        // Write CSV data to the file with UTF-8 BOM
                        List<int> csvBytes = utf8.encode(csv);
                        List<int> bom = [0xEF, 0xBB, 0xBF];
                        await file.writeAsBytes(bom + csvBytes);

                        print('CSV file created: ${file.path}');

                        hideLoadingIndicator();

                        Navigator.pop(context);

                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ResponseDialog(
                              title: "Successful",
                              subtitle:
                                  "Your Data Has Been Saved To Download Folder",
                              lottieAsset: "assets/images/correct.json",
                            );
                          },
                        );
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
