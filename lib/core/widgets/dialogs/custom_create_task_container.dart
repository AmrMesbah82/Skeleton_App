import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_yellow_button copy.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/authentication/welcome_screen/views/mobile_view/nav_bar.dart';


/// Date Created :14/November/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :19/November/2023 By Bassem
/// Objectives: this widget is for showing the meeting or task name, description and start time for each one in addition to images of the participants and the total number of the members enrolled in this event

double height = 0.015.h;

class CustomCreateTaskContainer extends StatefulWidget {
  final bool isProject;
  final String currentBoardName;
  final void Function() onPressed;

  const CustomCreateTaskContainer({
    super.key,
    this.isProject = false,
    required this.onPressed,
    required this.currentBoardName,
  });

  @override
  State<CustomCreateTaskContainer> createState() =>
      _CustomCreateTaskContainerState();
}

final List<String> notify = [
  '10 Minutes Before'.tr,
  '30 Minutes Before'.tr,
  '1 Hour Before'.tr,
];

String? selectedNotify = '10 Minutes Before'.tr;

final List<String> attend = [
  'Yes'.tr,
  'No'.tr,
  'Maybe'.tr,
];

String? selectedAnswer = 'Yes'.tr;

class _CustomCreateTaskContainerState extends State<CustomCreateTaskContainer> {
  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardDescriptionController = TextEditingController();
  //TaskController taskController = Get.find();

  TextStyle customTitleTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: FontConstants.fontSize018.h,
      // ignore: unrelated_type_equality_checks
      color: themeController.currentTheme == MyThemeData.lightTheme
          ? MyThemeData.colorBlack
          : MyThemeData.colorWhiteDark,
      fontWeight: FontWeight.w600,
      height: 1.8);
  TextStyle customSubTitleTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
    fontSize: FontConstants.fontSize016.h,
    // ignore: unrelated_type_equality_checks
    color: themeController.currentTheme == MyThemeData.lightTheme
        ? MyThemeData.colorDarkGrey
        : MyThemeData.colorGreydark,
    fontWeight: FontWeight.w400,
    height: 0.0016.h,
  );
  @override
  Widget build(BuildContext context) {
  //  Get.put(TaskController());
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    double imageHight = 0.03.h;
    double space = 0.015.h;
    return Container();/* GetBuilder<TaskController>(builder: (tController) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: widget.isProject == false ? 0.01.h : 0.01.h,
                horizontal: widget.isProject == false ? 0.0.w : 0),
            decoration: BoxDecoration(
              // ignore: unrelated_type_equality_checks
              color: isTablet
                  ? themeController.currentTheme == MyThemeData.lightTheme
                      ? MyThemeData.colorLightGrey
                      : MyThemeData.darkBackGround
                  : Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SvgPicture.asset("assets/images/imagePickerPhoto.svg"),
                InkWell(
                  onTap: () {
                    tController.uploadImage("card_images");
                  },
                  child: Stack(
                    children: <Widget>[
                      tController.imageUrl == ""
                          ? CircleAvatar(
                              radius: 0.04.h,
                              backgroundColor: MyThemeData.barrierColor,
                              child: Center(
                                child: Transform.scale(
                                    scale: isTablet ? 1.2 : 0.8,
                                    child: SvgPicture.asset(
                                        "assets/images/pic.svg")),
                              ),
                            )
                          : CircleAvatar(
                              radius: 0.08.w,
                              backgroundColor: MyThemeData.barrierColor,
                              child: Center(
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      tController.imageUrl,
                                    ),
                                    radius: 0.06.h,
                                  ),
                                ),
                              ),
                            ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Transform.scale(
                            scale: isTablet ? 1.5 : 1.3,
                            child: CircleAvatar(
                                backgroundColor: MyThemeData.signOut,
                                radius: 0.013.h,
                                child: SvgPicture.asset(
                                  "assets/icons/CameraIcon.svg",
                                  color: MyThemeData().contrastColor(),
                                  height: 0.015.h,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: height,
                ),
                ColumnRequestData(
                  fillColor:
                      themeController.currentTheme == MyThemeData.lightTheme
                          ? MyThemeData.colorLightGrey
                          : MyThemeData.colorBlack,
                  title: widget.isProject == true ? "Card Name" : "Task Name",
                  isRequired: true,
                  isTextField: true,
                  hint: widget.isProject == true
                      ? "Enter Card Name"
                      : "Enter Task Name",
                  isOptional: false,
                  isExpanded: true,
                  hasPrefix: true,
                  textController: cardNameController,
                  // textController: widget.isGroupEdit == true
                  //     ? null
                  //     : desciption,

                  controllerState: (value) {
                    setState(() {
                      print('value description ${value!}');
                    });
                  },
                  maxlength: 120,
                ),
                SizedBox(
                  height: height,
                ),
                ColumnRequestData(
                  title: "Description",
                  isTextField: true,
                  hint: widget.isProject == true
                      ? "Enter Card Description"
                      : "Enter Task Description",
                  isOptional: false,
                  isExpanded: true,
              isDescription: true,
                  fillColor:
                      themeController.currentTheme == MyThemeData.lightTheme
                          ? MyThemeData.colorLightGrey
                          : MyThemeData.colorBlack,
                  textController: cardDescriptionController,
                  // textController: widget.isGroupEdit == true
                  //     ? null
                  //     : desciption,
                  maxlines: 2,
                  controllerfinishState: (value) {},

                  controllerState: (value) {
                    setState(() {
                      print('value description ${value!}');
                    });
                  },
                  maxlength: 600,
                ),
              ],
            ),
          ),
          if (widget.isProject == false)
            Padding(
              padding: EdgeInsets.only(
                  top: 0.03.h, bottom: isTablet == true ? 0 : 0.03.h),
              child: ReusableElevatedButton(
                buttonText: 'Add'.tr,
                onPressed: () {
                  hapticController.triggerHapticFeedback(
                    vibration: VibrateType.mediumImpact,
                    hapticFeedback: HapticFeedback.mediumImpact,
                  );
                  tController.createCard(
                      name: cardNameController.text,
                      description: cardDescriptionController.text,
                      currentBoardName: widget.currentBoardName,
                      context: context);
                  setState(() {});
                },
              ),
            ),
        ],
      );
    });
  */ }
}
