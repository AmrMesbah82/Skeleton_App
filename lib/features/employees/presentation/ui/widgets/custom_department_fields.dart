import 'package:flutter/material.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/theme/app_font_size.dart';

class CustomDepartmentFields extends StatefulWidget {
  TextEditingController depNameController;
  ValueChanged<TextEditingController> depNameState;
  TextEditingController depNameInArabicController;
  ValueChanged<TextEditingController> depNameInArabicState;

  CustomDepartmentFields({
    super.key,
    required this.depNameController,
    required this.depNameState,
    required this.depNameInArabicController,
    required this.depNameInArabicState,
  });

  @override
  State<CustomDepartmentFields> createState() => _CustomDepartmentFieldsState();
}

class _CustomDepartmentFieldsState extends State<CustomDepartmentFields> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return isTablet
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  child: ColumnRequestData(
                    title: "Department Name",
                    fillColor: Theme.of(context).colorScheme.inversePrimary,
                    isTextField: true,
                    hint: "Enter Department Name",
                    //maxlength: 20,
                    textController: widget.depNameController,
                    controllerfinishState: (value) {
                      setState(() {
                        widget.depNameController;
                        widget.depNameState(widget.depNameController);
                      });
                    },
                    controllerState: (_) {},
                    isOptional: false,
                    isExpanded: true,
                  ),
                ),
              ),
              SizedBox(
                width: 0.02.w,
              ),
              Expanded(
                child: SizedBox(
                  child: ColumnRequestData(
                    title: "Department Name In Arabic",
                    fillColor: Theme.of(context).colorScheme.inversePrimary,
                    isTextField: true,
                    //   maxlength: 20,
                    hint: "Enter Department Name",
                    textController: widget.depNameInArabicController,
                    controllerfinishState: (value) {
                      setState(() {
                        widget.depNameInArabicController;
                        widget.depNameInArabicState(
                            widget.depNameInArabicController);
                      });
                    },
                    controllerState: (_) {},
                    isOptional: false,
                    isExpanded: true,
                  ),
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: isTablet
                    ? (isPortrait ? double.infinity : 0.23.w)
                    : double.infinity,
                child: ColumnRequestData(
                  title: "Department Name",
                  fillColor: Theme.of(context).colorScheme.inversePrimary,
                  isTextField: true,
                  hint: "Enter Department Name",
                  maxlength: 20,
                  textController: widget.depNameController,
                  controllerfinishState: (value) {
                    setState(() {
                      widget.depNameController;
                      widget.depNameState(widget.depNameController);
                    });
                  },
                  controllerState: (_) {},
                  isOptional: false,
                  isExpanded: true,
                ),
              ),
              SizedBox(
                width:
                    isTablet ? (isPortrait ? double.infinity : 0.23.w) : null,
                child: ColumnRequestData(
                  title: "Department Name In Arabic",
                  fillColor: Theme.of(context).colorScheme.inversePrimary,
                  isTextField: true,
                  maxlength: 20,
                  hint: "Enter Department Name",
                  textController: widget.depNameInArabicController,
                  controllerfinishState: (value) {
                    setState(() {
                      widget.depNameInArabicController;
                      widget.depNameInArabicState(
                          widget.depNameInArabicController);
                    });
                  },
                  controllerState: (_) {},
                  isOptional: false,
                  isExpanded: true,
                ),
              ),
            ],
          );
  }
}
