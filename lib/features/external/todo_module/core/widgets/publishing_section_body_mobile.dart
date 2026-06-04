import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/external/todo_module/core/components/other_components/column_request_data.dart';
import 'package:demo_app/features/external/todo_module/core/components/other_components/cupertino_time_picker.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/presentation/controllers/todo_controller.dart';

class PublishingSectionBodyMobile extends StatelessWidget {
  const PublishingSectionBodyMobile({
    super.key,

  });


  @override
  Widget build(BuildContext context) {

    TodoController controller = Get.find<TodoController>();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
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
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoTimePicker(
                          mode: CupertinoDatePickerMode.time,
                          onDateTimeChanged: (DateTime newDateTime) {
                            controller.onDateTimeChangedStart(newDateTime);
                            controller.update();
                          },
                          initialDateTime: controller
                                  .startTimePublishing!.text.isNotEmpty
                              ? DateFormat("HH:mm").parse(
                                  controller.startTimePublishing!.text)
                              : DateTime.now(),
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
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                flex: 5,
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
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 3,
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
                  ),
                ),
              ),
            ],
          ),
        ],
      );
  }
}
