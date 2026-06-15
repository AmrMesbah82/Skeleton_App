import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/column_request_data.dart';
import 'package:demo_app/features/todo_module/core/components/other_components/cupertino_time_picker.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';

class PulbishingSectionBodyTablet extends StatelessWidget {
  const PulbishingSectionBodyTablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TodoController controller = Get.find<TodoController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        controller.selectDate(
                          context,
                          controller.startDateKey,
                        );
                      },
                      child: ColumnRequestData(
                        title: "Start Date",
                        isExpanded: true,
                        isTextField: true,
                        isOptional: false,
                        hint: "DD/MM/YYYY",
                        hasSuffix: true,
                        textController: controller.startDateController,
                        enabled: false,
                        suffixUrl: "assets/icons/Calendar copy.svg",
                        sizerSuffix: 0.5,
                        // suffixColor: controller.endDatePublishing.text != ''
                        //     ? Theme.of(context).colorScheme.inverseSurface
                        //     : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoTimePicker(
                              initialDateTime: controller
                                      .startTimePublishing!.text.isNotEmpty
                                  ? DateFormat("HH:mm").parse(
                                      controller.startTimePublishing!.text)
                                  : DateTime.now(),
                              mode: CupertinoDatePickerMode.time,
                              onDateTimeChanged: (DateTime newDateTime) {
                                controller.onDateTimeChangedStart(newDateTime);
                                controller.update();
                              },
                            );
                          },
                        );
                      },
                      child: ColumnRequestData(
                        title: "",
                        isExpanded: true,
                        isTextField: true,
                        enabled: false,
                        isOptional: false,
                        hint: "00:00",
                        hasSuffix: true,
                        textController: controller.startTimePublishing,
                        suffixUrl: "assets/icons/Clock Circle.svg",
                        sizerSuffix: 0.5,
                        // suffixColor: controller.endTimePublishing.text != ''
                        //     ? Theme.of(context).colorScheme.inverseSurface
                        //     : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        controller.selectDate(
                          context,
                          controller.endDateKey,
                        );
                      },
                      child: ColumnRequestData(
                        title: "End Date",
                        isExpanded: true,
                        isTextField: true,
                        isOptional: false,
                        hint: "DD/MM/YYYY",
                        hasSuffix: true,
                        textController: controller.endDateController,
                        enabled: false,
                        suffixUrl: "assets/icons/Calendar copy.svg",
                        sizerSuffix: 0.5,
                        // suffixColor: controller.endDatePublishing.text != ''
                        //     ? Theme.of(context).colorScheme.inverseSurface
                        //     : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoTimePicker(
                              initialDateTime: controller
                                      .endTimePublishing!.text.isNotEmpty
                                  ? DateFormat("HH:mm")
                                      .parse(controller.endTimePublishing!.text)
                                  : DateTime.now(),
                              mode: CupertinoDatePickerMode.time,
                              onDateTimeChanged: (DateTime newDateTime) {
                                controller.onDateTimeChangedEnd(newDateTime);
                                controller.update();
                              },
                            );
                          },
                        );
                      },
                      child: ColumnRequestData(
                        title: "",
                        isExpanded: true,
                        isTextField: true,
                        enabled: false,
                        isOptional: false,
                        hint: "00:00",
                        hasSuffix: true,
                        textController: controller.endTimePublishing,
                        suffixUrl: "assets/icons/Clock Circle.svg",
                        sizerSuffix: 0.5,
                        // suffixColor: controller.endTimePublishing.text != ''
                        //     ? Theme.of(context).colorScheme.inverseSurface
                        //     : null,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: controller.isScheduale ? 18 : 0),
      ],
    );
  }
}
