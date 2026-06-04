//Date Created :2/September/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :3/October/2023 by mazen
// Objectives: this class  created to view the Card widget in the Home page
// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/components/card_files/bullet_points_fields_alert.dart';
import 'package:demo_app/components/card_files/card_back_data.dart';
import 'package:demo_app/components/card_files/card_data.dart';
import 'package:demo_app/components/card_files/edit_icon.dart';

import 'package:demo_app/components/card_files/face_background.dart';
import 'package:demo_app/components/card_files/user_name_and_icon.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';

import 'package:demo_app/core/theme/screen_size.dart';

class CardProfileWidget extends StatefulWidget {
  CardProfileWidget(
      {super.key,
      this.cardHeight,
      this.isCard = false,
      this.isHorizontalCard = false});
  final double? cardHeight;
  final bool isCard;
  final bool isHorizontalCard;

  @override
  State<CardProfileWidget> createState() => _CardProfileWidgetState();
}

class _CardProfileWidgetState extends State<CardProfileWidget> {
  bool isFacingUp = true;
  final HapticController hapticController = Get.put(HapticController());
  void flipCard() {
    hapticController.triggerHapticFeedback(
        vibration: VibrateType.lightImpact,
        hapticFeedback: HapticFeedback.lightImpact);
    setState(() {
      isFacingUp = !isFacingUp;
    });
  }

  TextEditingController bullet1 = TextEditingController();
  TextEditingController bullet2 = TextEditingController();
  TextEditingController bullet3 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    double cardHeight =
        widget.isHorizontalCard == true ? .25.h : widget.cardHeight ?? .3.h;
    double cardWidth = widget.isCard ? .22.w : .51.w;
    String userName = 'Ogeny Rashad';
    // ignore: non_constant_identifier_names
    String ProfilePhoto = 'assets/images/female_avatar.png';
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return GestureDetector(
      onTap: flipCard,
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 501),
        width: double.infinity,
        curve: Curves.fastOutSlowIn,
        child: isFacingUp
            ? Stack(
                alignment: Alignment.center,
                children: [
                  FaceBackGround(
                      ImageAddress: 'assets/images/card2.svg',
                      cardHeight: cardHeight,
                      isHorizontalCard: widget.isHorizontalCard),
                  Padding(
                    padding: widget.cardHeight != null ||
                            widget.isHorizontalCard == true
                        ? EdgeInsets.only(
                            top: cardHeight * .02,
                            left: Get.locale.toString().contains('en')
                                ? widget.cardHeight != null
                                    ? 0.025.w
                                    : 0.04.w
                                : 0,
                            right: Get.locale.toString().contains('en')
                                ? 0
                                : widget.cardHeight != null
                                    ? 0.025.w
                                    : 0.04.w,
                          )
                        : EdgeInsets.only(
                            left: cardWidth * .01,
                            right: Get.locale.toString().contains('en')
                                ? cardWidth * .01
                                : cardWidth * .05,
                            top: cardHeight * .005,
                          ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: widget.isCard == true
                              ? EdgeInsets.symmetric(
                                  horizontal: isTablet ? 0.012.w : 0.032.w,
                                  vertical: widget.isHorizontalCard == true
                                      ? 0.065.h
                                      : isTablet
                                          ? 0.05.h
                                          : 0.05.h)
                              : EdgeInsets.only(
                                  left: Get.locale.toString().contains('en')
                                      ? widget.cardHeight == null
                                          ? cardWidth * .03
                                          : 0
                                      : cardHeight != .355.h
                                          ? 0
                                          : 0.01.w, //edit
                                  right: Get.locale.toString().contains('en')
                                      ? cardWidth * .05
                                      : cardHeight != .355.h
                                          ? cardWidth * .02
                                          : cardWidth * .0,
                                  top: cardHeight * .16,
                                ),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(ProfilePhoto),
                            radius: widget.isCard == true
                                ? widget.isHorizontalCard == true
                                    ? 0.048.w
                                    : isTablet
                                        ? 0.065.w
                                        : 0.13.w
                                : isTablet
                                    ? 65
                                    : 50, //30
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: Get.locale.toString().contains('en')
                                  ? 0.0015.w
                                  : 0,
                              top: isTablet ? 0 : 0.008.h,
                              right: Get.locale.toString().contains('ar') &&
                                      isPortrait
                                  ? widget.isCard == true
                                      ? 0
                                      : 0.025.w
                                  : 0.01.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: widget.cardHeight == null
                                      ? widget.isCard == true
                                          ? widget.isHorizontalCard == true
                                              ? cardWidth * 1.2
                                              : isTablet
                                                  ? cardWidth * 1.25
                                                  : cardWidth * 2.55
                                          : isTablet
                                              ? cardWidth * .6
                                              : cardWidth * .8
                                      : cardWidth * .4,
                                  child: UserNameAndIcon(
                                      isCard: widget.isCard,
                                      isHorizontalCard: widget.isHorizontalCard,
                                      username: userName,
                                      cardHeight2: cardHeight,
                                      cardHeight: 0 //look here
                                      )),
                              SizedBox(
                                height: isTablet ? 0.002.h : 0.006.h,
                              ),
                              CardData(
                                isHorizontal: widget.cardHeight == null
                                    ? widget.isHorizontalCard == true
                                        ? true
                                        : false
                                    : true,
                                isCard: widget.isCard,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Stack(
                alignment: Alignment.topCenter,
                children: [
                  FaceBackGround(
                    ImageAddress: 'assets/images/card_back2.svg',
                    cardHeight: cardHeight,
                    isHorizontalCard: widget.isHorizontalCard,
                  ),
                  Column(
                    children: [
                      widget.isCard == true
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isPortrait == true
                                      ? isTablet
                                          ? 0.03.w
                                          : 0.05.w
                                      : 0.05.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  EditIcon(
                                    cardHeight: cardHeight,
                                    isHorizontalCard: widget.isHorizontalCard,
                                    onTap: () {
                                      hapticController.triggerHapticFeedback(
                                          vibration: VibrateType.mediumImpact,
                                          hapticFeedback:
                                              HapticFeedback.mediumImpact);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        useSafeArea: true,
                                        barrierColor: MyThemeData.barrierColor,
                                        builder: (BuildContext context) {
                                          return Form(
                                            child: Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              insetPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal:
                                                          isPortrait == true
                                                              ? isTablet
                                                                  ? 0.1.h
                                                                  : 0.03.w
                                                              : 0.35.h),
                                              //  EdgeInsets.fromLTRB(0.1.h, 0.2.h, 0.1.h, 0.2.h),
                                              child: BulletPointsFieldsAlert(
                                                bullet1: bullet1,
                                                bullet2: bullet2,
                                                bullet3: bullet3,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                      Padding(
                        padding: EdgeInsets.only(
                          left: widget.isHorizontalCard == true
                              ? cardWidth * .15
                              : isTablet
                                  ? cardWidth * .04
                                  : cardWidth * .08,
                          right: isTablet
                              ? cardWidth * .0003
                              : Get.locale.toString().contains('en')
                                  ? cardWidth * .0003
                                  : cardWidth * .2,
                          top: widget.isCard == true ? 0 : cardHeight * .10,
                        ),
                        child: CardBackData(
                          pointWidth: widget.cardHeight != null
                              ? 0.3.w
                              : widget.isCard == true
                                  ? isPortrait == false
                                      ? .15.w
                                      : isTablet
                                          ? .2.w
                                          : .4.w
                                  : null,
                          isCard: widget.isCard,
                          isHorizontalCard: widget.isHorizontalCard,
                          bullet1: bullet1.text,
                          bullet2: bullet2.text,
                          bullet3: bullet3.text,
                        ),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
