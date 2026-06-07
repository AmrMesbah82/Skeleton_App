import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_yellow_button%20copy.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';


class AddCardDialog extends StatefulWidget {
  const AddCardDialog({
    super.key,
    required this.board,
  });
  final String board;
  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  late TextEditingController cardDesciption;
  late TextEditingController cardName;

  @override
  void initState() {
    //taskController.imageUrl = "";
    cardDesciption = TextEditingController();
    cardName = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
     
     bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
   // Get.put(TaskController());
    return /* GetBuilder<TaskController>(
      builder: (controller) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal:  isPortrait ? 0.2.w : 0.3.w,
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
              padding:
                  EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.015.h),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FiltersAppBar(
                        imageUrl: "assets/icons/ClipboardListIcon.svg",
                        title: "Add Card"),
                        SizedBox(height: isPortrait? 0.01.h : 0,),
                    // SvgPicture.asset("assets/images/imagePickerPhoto.svg"),
                    InkWell(
                      onTap: () {
                        controller.uploadImage("card_images");
                      },
                      child: Stack(
                            children: <Widget>[
                              controller.imageUrl == ""
                                  ? CircleAvatar(
                                      radius: isPortrait? 0.06.w: 0.036.w,
                                      backgroundColor: MyThemeData.barrierColor,
                                      child: Center(
                                        child: Transform.scale(
                                            scale: 1.3,
                                            child: SvgPicture.asset(
                                                "assets/images/pic.svg")),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: isPortrait? 0.06.w: 0.036.w,
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
                                        radius: isPortrait ? 0.01.h : 0.013.h,
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
                    ),
                    SizedBox(
                      height: 0.015.h,
                    ),
                    ColumnRequestData(
                      fillColor: Colors.transparent,
                      title: "Card Name",
                      isRequired: true,
                      isTextField: true,
                      hint: "Enter Card Name",
                      isOptional: false,
                      isExpanded: true,
                      hasPrefix: true,
                      textController: cardName,
                      controllerfinishState: (value) {
                        setState(() {});
                      },
                      controllerState: (value) {
                        setState(() {
                          print('value description ${value!}');
                        });
                      },
                      maxlength: 120,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.015.h),
                      child: ColumnRequestData(
                        title: "Description",
                        isTextField: true,
                        hint: "Enter Card Description",
                        isOptional: false,
                        isExpanded: true,
                           fillColor: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorLightGrey
                              : MyThemeData.colorBlack,
              isDescription: true,
                        maxlines: 2,
                        maxlength: 120,
                        textController: cardDesciption,
                        controllerfinishState: (value) {
                          setState(() {});
                        },
                        controllerState: (value) {
                          setState(() {
                            print('value description ${value!}');
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.03.h),
                      child: ReusableElevatedButton(
                        buttonText: 'Add'.tr,
                        onPressed: () {
                          controller.createCard(
                              name: cardName.text,
                              description: cardDesciption.text,
                              currentBoardName: widget.board.capitalize!,
                              context: context);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ); */Container();
  }

  @override
  void dispose() {
    cardDesciption.dispose();
    cardName.dispose();
    super.dispose();
  }
}
