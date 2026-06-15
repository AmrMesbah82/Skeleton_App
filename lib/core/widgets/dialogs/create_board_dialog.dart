import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:demo_app/core/shared_components/requests_filter_appbar.dart';
import 'package:demo_app/core/widgets/dialogs/dialogue_switchers_row.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_button.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/widgets/circle_progress.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/employees/presentation/controller/main_core_department_controller.dart';


class CreateBoardDialog extends StatefulWidget {
  CreateBoardDialog({
    super.key,
    this.dropDownValue,
    this.dropDownValueState,
  });
  String? dropDownValue;
  ValueChanged<String?>? dropDownValueState;

  @override
  State<CreateBoardDialog> createState() => _CreateBoardDialogState();
}

class _CreateBoardDialogState extends State<CreateBoardDialog> {
  //TaskController tController = Get.find();
  final ImagePicker picker = ImagePicker();
  bool switchValue3 = false;
  late TextEditingController desciption;
  late TextEditingController name;

  @override
  void initState() {
    getGroups();
    desciption = TextEditingController();
    name = TextEditingController();
  //  tController.imageUrl = "";
    super.initState();
  }

  String searchText = '';

  Future<void> getGroups() async {
    //setState(() {});
  }

  String? selectedDepartment;
  bool isAllChecked = false;
  @override
  Widget build(BuildContext context) {
    bool isLargeTablet = MediaQuery.of(context).size.shortestSide >= 1024;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;

    bool isNotEmpty(TextEditingController controller) {
      return controller.text.isNotEmpty;
    }

    bool isNotEmptyString(String? value) {
      return value != null && value.isNotEmpty;
    }

    if (isNotEmpty(desciption) &&
        isNotEmpty(name) &&
        isNotEmptyString(selectedDepartment)) {
      isAllChecked = true;
    } else {
      isAllChecked = false;
    }

    bool isButtonEnabled = isAllChecked;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? (isVertical ? 0.1.w : 0.2.w) : 0.2.w,
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child:
      Container()
      /*  GetBuilder<TaskController>(builder: (controller) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.015.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FiltersAppBar(
                    imageUrl: 'assets/images/task_manage.svg',
                    title: "Create Board",
                  ),
                  InkWell(
                    onTap: () {
                      controller.uploadImage("board_images");
                      //_uploadImage();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: <Widget>[
                            controller.imageUrl == ""
                                ? CircleAvatar(
                                    radius: isVertical ? 0.06.w : 0.036.w,
                                    backgroundColor: MyThemeData.barrierColor,
                                    child: Center(
                                      child: Transform.scale(
                                          scale: 1.3,
                                          child: SvgPicture.asset(
                                              "assets/images/pic.svg")),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: isVertical ? 0.06.w : 0.036.w,
                                    backgroundColor: MyThemeData.barrierColor,
                                    child: Center(
                                      child: Transform.scale(
                                        scale: 1,
                                        child: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(controller.imageUrl),
                                          radius: 0.06.h,
                                        ),
                                      ),
                                    ),
                                  ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Transform.scale(
                                  scale: isTablet ? 1.5 : 0.9,
                                  child: CircleAvatar(
                                      backgroundColor: MyThemeData.signOut,
                                      radius: isVertical ? 0.01.h : 0.013.h,
                                      child: SvgPicture.asset(
                                        "assets/icons/CameraIcon.svg",
                                        color: MyThemeData().contrastColor(),
                                        height: 0.015.h,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.015.h),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: 0.34.w,
                            child: ColumnRequestData(
                                title: "Board Name",
                                maxlength: 80,
                                isTextField: true,
                                //  buttonHeight : isVertical ?0.063.h : 0.087.h,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                textController: name,
                                controllerState: (value) {
                                  setState(() {});
                                },
                                controllerfinishState: (value) {
                                  setState(() {});
                                },
                                hint: "Enter Board Name",
                                isOptional: false,
                                isExpanded: true),
                          ),
                          ColumnRequestData(
                            title: "Department",
                            isTextField: false,
                            hint: "Select Department",
                            maxlength: 80,
                            buttonHeight: isVertical
                                ? (isLargeTablet ? 0.049.h : 0.049.h)
                                : (isLargeTablet ? 0.055.h : 0.053.h),
                            isOptional: false,
                            buttonWidth: isVertical ? 0.4.w : null,
                            isExpanded: false,
                            dropDownItems: Get.locale.toString().contains('en')
                                ? Get.find<AddDepartmentController>().departmentsEnglishName
                                : Get.find<AddDepartmentController>().departmentsArabicName,
                            dropdownValue: selectedDepartment,
                            dropDownValueState: (value) {
                              print('value $value');
                              setState(() {
                                widget.dropDownValue =
                                addDepartmentController.getDepartmentIdFromDepartmentName(departmentName: value!);

                                selectedDepartment = value;
                                print(
                                    'widget.dropDownValue ${widget.dropDownValue}');
                                //  widget.dropDownValue = value;
                                //widget.dropDownValueState!(widget.dropDownValue);
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  ColumnRequestData(
                    initialValue: null,
                    title: "Description",
                    isTextField: true,
              isDescription: true,
                    hint: "Enter Board Description",
                    isOptional: false,
                    fillColor: Theme.of(context).colorScheme.inversePrimary,
                    isExpanded: true,
                    textController: desciption,
                    readOnly: false,
                    controllerfinishState: (value) {
                      setState(() {});
                    },
                    controllerState: (value) {
                      setState(() {
                        desciption = value as TextEditingController;
                        print('value description ${value!}');
                      });
                    },
                    maxlength: 600,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.015.h),
                    child: DialogueSwitcher(
                        title: "Creating Messaging Channels",
                        isDialog: true,
                        subtitle:
                            "You Can Chat With Team Through Project Board",
                        switchValue: switchValue3,
                        switchValueState: (value) {
                          setState(() {
                            switchValue3 = value;
                          });
                        }),
                  ),
                  controller.loading
                      ? const Center(child: CircleProgress())
                      : Padding(
                          padding: EdgeInsets.only(top: 0.02.h, bottom: 0.01.h),
                          child: MainCustomButton(
                            buttonColor:
                                !isButtonEnabled ? MyThemeData.GreyBack : null,
                            buttonText: 'Create'.tr,
                            onPressed: isButtonEnabled
                                ? () async {
                                    await controller
                                        .createBoard(
                                      context: context,
                                      department: widget.dropDownValue,
                                      description: desciption.text,
                                      name: name.text,
                                      messaginChannel:
                                          switchValue3 ? "true" : "false",
                                    )
                                        .then((value) {
                                      setState(() {
                                        controller.boards = [];
                                        controller.boards.addAll(
                                            controller.filterBoards("All"));
                                        controller.selectedIndex = 0;
                                      });
                                    });
                                    // if (switchValue3) {
                                    //   if (addGroupController.allGroups!
                                    //       .where((element) =>
                                    //           element.groupName!.groupName!.last ==
                                    //           name.text)
                                    //       .toList()
                                    //       .isNotEmpty) {
                                    //     showDialog(
                                    //         context: context,
                                    //         builder: (context) {
                                    //           return const SuccessDialog(
                                    //             title: "Unsuccessful",
                                    //             subtitle:
                                    //                 "This Group Name Already Exist",
                                    //             lottieAsset:
                                    //                 "assets/images/error.json",
                                    //           );
                                    //         });
                                    //   } else {
                                    //     addGroupController.groupModel.value
                                    //         .description = Description(
                                    //       description: [
                                    //         desciption.text.toLowerCase(),
                                    //       ],
                                    //       timestamps: [Timestamp.now()],
                                    //     );
                                    //     addGroupController
                                    //         .groupModel.value.groupName = GroupName(
                                    //       groupName: [
                                    //         name.text.toLowerCase(),
                                    //       ],
                                    //       timestamps: [Timestamp.now()],
                                    //     );
                                    //     addGroupController.groupModel.value
                                    //         .dateCreated = DateTime.now().toString();
                                    //     addGroupController
                                    //             .groupModel.value.createdBy =
                                    //         "${employee!.firstName!.firstNames!.last!} ${employee!.lastName!.lastNames!.last!}";
                                    //     addGroupController
                                    //         .groupModel.value.adminOnly = AdminOnly(
                                    //       adminOnly: [
                                    //         false,
                                    //       ],
                                    //       timestamps: [Timestamp.now()],
                                    //     );
                                    //     controller.imageUrl != ""
                                    //         ? addGroupController.groupModel.value
                                    //             .groupPhoto = GroupPhoto(
                                    //             groupPhoto: [
                                    //               controller.imageUrl,
                                    //             ],
                                    //             timestamps: [Timestamp.now()],
                                    //           )
                                    //         : addGroupController.groupModel.value
                                    //             .groupPhoto = GroupPhoto(
                                    //             groupPhoto: [],
                                    //             timestamps: [],
                                    //           );
                                    //     addGroupController.groupModel.value.members =
                                    //         Members(
                                    //       members: [employee!.email!.emails!.last!],
                                    //       addedBy: [employee!.email!.emails!.last!],
                                    //       status: ['admin'],
                                    //       timestamps: [Timestamp.now()],
                                    //     );
                                    //     addGroupController.groupModel.value.groupId =
                                    //         '${name.text.toLowerCase()}_${DateTime.now()}';
                                    //     await addGroupController.addGroup(
                                    //         addGroupController.groupModel.value,
                                    //         addGroupController
                                    //             .groupModel.value.groupId!);
                                    //   }
                                    // }
                                  }
                                : () {},
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      }),
   */  );
  }

  @override
  void dispose() {
    name.dispose();
    desciption.dispose();
    super.dispose();
  }
}
