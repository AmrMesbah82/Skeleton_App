// Date Created :19/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :19/November/2023
// Objectives: this is a widget to customize the contact data and role in the group in messages screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/buttons/custom_icon_button.dart';


import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

// ignore: must_be_immutable
class ContactRow extends StatefulWidget {
  ContactRow({
    super.key,
    required this.imageUrl,
    required this.mail,
    required this.name,
    required this.role,
    required this.valuedState,
    required this.addState,
    this.isMember = false,
    this.isNew = false,
  });

  ValueChanged<String?> valuedState;
  ValueChanged<String?> addState;
  final String imageUrl;
  final String name;
  String role;
  final String mail;
  bool isNew;
  bool isMember;

  @override
  State<ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<ContactRow> {
  String? valued = 'Member';
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: EdgeInsets.only(
          top: isTablet ? (isPortrait ? 0.017.h : 0.03.h) : 0.01.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment:isTablet? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                widget.imageUrl.contains('assets')
                    ? CircleAvatar(
                        backgroundImage: AssetImage(widget.imageUrl),
                        radius:
                            isTablet ? (isPortrait ? 0.02.h : 0.02.w) : 0.04.w,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(widget.imageUrl),
                        radius:
                            isTablet ? (isPortrait ? 0.02.h : 0.02.w) : 0.04.w,
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.015.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                       //  color: Colors.amber,
                        width: isTablet ? (isPortrait ? 0.35.w : 0.3.w) : 0.45.w,
                        child: Text(
                          widget.name,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: isTablet
                                  ? (isPortrait
                                      ? FontConstants.fontSize016.h
                                      : FontConstants.fontSize016.w)
                                  : FontConstants.fontSize018.h,
                              fontWeight: FontWeight.w500,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface),
                        ),
                      ),
                      SizedBox(
                        height: 0.005.h,
                      ),
                      Container(
                      //     color: Colors.amber,
                        width: isTablet ? (isPortrait ? 0.35.w : 0.3.w) : 0.45.w,
                        child: Text(
                          "${widget.mail} (${valued == 'Make Admin' ? "Admin" : widget.role.capitalize})",
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: isTablet
                                  ? (isPortrait
                                      ? FontConstants.fontSize013.h
                                      : FontConstants.fontSize014.w)
                                  : FontConstants.fontSize015.h,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.scrim),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          widget.isMember
              ? const SizedBox()
              : widget.isNew
                  ? 
                  // CustomIconButton(
                  //     buttonText: 'Add'.tr,
                      
                  //     imagePath: "assets/icons/profileadd.svg",
                  //     onPressed: () {
                  //       setState(() {
                  //         widget.isNew = false;
                  //         widget.role = "member";
                  //         widget.addState('member');
                  //       });
                  //     },
                  //   )
                  MainCustomIconButton(
                      onPressed: () {
                        setState(() {
                          widget.isNew = false;
                          widget.role = "member";
                          widget.addState('member');
                        });
                      },
                      buttonText: "Add".tr,
                  
                     // iconHeight: 0.029.h,
                      buttonStyle: ElevatedButton.styleFrom(
                        minimumSize:isTablet ? (isPortrait ? Size(0.086.w, 0.035.h) :   Size(0.086.w, 0.05.h) ) : Size(0.086.w, 0.04.h),
                        backgroundColor: MyThemeData.signOut,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        )),
                      ),
                      widgetIcon: "assets/icons/profileadd.svg",
                    )
                  : CustomDropdownButton2(
                    borded: true,
                      hint: widget.isNew ? valued! : capitalize(widget.role),
                      buttonWidth: isTablet ? (isPortrait? 0.2.w :0.13.w) : 0.27.w,
                      buttonHeight: isTablet ? (isPortrait? 0.03.h:  0.045.h) : 0.034.h,
                      dropdownWidth: isTablet ? (isPortrait? 0.2.w :0.13.w) : 0.27.w,
                   
                      buttonPadding: EdgeInsets.symmetric(horizontal: 0.01.w),
                      value: widget.isNew ? valued! : capitalize(widget.role),
                      dropdownItems: const [
                        'Removed',
                        'Admin',
                        'Only View',
                        'Member'
                      ],
                      onChanged: (value) {
                        setState(() {
                          valued = value;
                          widget.valuedState(valued);
                        });
                      }),
          SizedBox(
            width: 0.01.w,
          ),
        ],
      ),
    );
  }
}
