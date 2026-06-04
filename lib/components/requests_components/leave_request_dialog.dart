import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/custom_toggle.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/components/tracking_time_components/track_time_subwidget/data_column.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

// ignore: must_be_immutable
class LeaveRequestDialog extends StatefulWidget {
  LeaveRequestDialog(
      {super.key,
      required this.name,
      required this.type,
      required this.dateFrom,
      required this.reason,
      required this.dateTo,
      required this.department,
      required this.status,
      required this.statusState});
  final String name;
  final String department;
  final String reason;
  final String type;
  final String dateFrom;
  final String dateTo;
  String status;
  ValueChanged<String> statusState;

  @override
  State<LeaveRequestDialog> createState() => _LeaveRequestDialogState();
}

class _LeaveRequestDialogState extends State<LeaveRequestDialog> {
  bool isChatShown = false;
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0.1.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        height:isPortrait?0.62.h :0.73.h,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.02.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 0.02.h),
                  child: const FiltersAppBar(
                      imageUrl: "assets/images/department_add.svg",
                      title: "Leave Requested"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: isPortrait ? 0.015.h : 0.03.h),
                  child: isPortrait
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ColumnData(title: "Name", data: widget.name),
                                ColumnData(
                                    title: "Department",
                                    data: widget.department),
                                ColumnData(
                                    title: "Leaves Type", data: widget.type),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.015.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ColumnData(
                                      title: "From", data: widget.dateFrom),
                                  ColumnData(title: "To", data: widget.dateTo),
                                  Container(
                                    width: 0.12.w,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ColumnData(
                              title: "Name",
                              data: widget.name,
                            ),
                            ColumnData(
                                title: "Department", data: widget.department),
                            ColumnData(title: "Leaves Type", data: widget.type),
                            ColumnData(title: "From", data: widget.dateFrom),
                            ColumnData(title: "To", data: widget.dateTo)
                          ],
                        ),
                ),
                Text(
                  "Reason For Leave".tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isPortrait
                          ? FontConstants.fontSize016.h
                          : FontConstants.fontSize014.w,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.01.h, bottom: 0.02.h),
                  child: CustomToggle(
                      enabled: false,
                      horizontalMargin: false,
                      isExpanded: false,
                      borded: true,
                      fillColor: Theme.of(context).colorScheme.inversePrimary,
                      onToggleChanged: () {},
                      onExpand: () {},
                      onCollapse: () {},
                      sizeMultiplicationFactor: 0.7,
                      hint: widget.reason,
                      textController: TextEditingController()),
                ),
                // const ExcalatePhotoDataRow(
                //   photoUrl: "assets/images/escaltephoto.png",
                //   title: "Sick Leave",
                //   space: "50 mb",
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.01.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage:
                                const AssetImage("assets/images/profile3.png"),
                            radius: isPortrait ? 0.025.h : 0.04.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isPortrait ? 0.02.w : 0.01.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Amro Handousa",
                                  style: AppFontStyle.cairoRegularStyle
                                      .copyWith(
                                          fontSize: isPortrait
                                              ? FontConstants.fontSize016.h
                                              : FontConstants.fontSize016.w,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 0.005.h),
                                  child: isChatShown
                                      ? IntrinsicHeight(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: isPortrait
                                                    ? 0.48.w
                                                    : 0.43.w,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 0.39.w,
                                                      child: ColumnRequestData(
                                                        title: "",
                                                        isTextField: true,
                                                        
                                                        hint:
                                                            "Type Your respond..",
                                                        isOptional: false,
                                                        isExpanded: true,
                                                        hideTitle: true,
                                                      ),
                                                    ),
                                                    Transform.rotate(
                                                      angle: Get.locale
                                                              .toString()
                                                              .contains('en')
                                                          ? 0
                                                          : 4.68,
                                                      child: Transform.scale(
                                                        scale: isPortrait
                                                            ? 1.8
                                                            : 1.4,
                                                        child: SvgPicture.asset(
                                                            "assets/images/sendD.svg"),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Text(
                                          "Direct Manger Approved on this leave"
                                              .tr,
                                          style: AppFontStyle.cairoRegularStyle
                                              .copyWith(
                                                  fontSize: isPortrait
                                                      ? FontConstants
                                                          .fontSize016.h
                                                      : FontConstants
                                                          .fontSize014.w,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer),
                                        ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.02.h),
                        child: MainCustomIconButton(
                          onPressed: () {
                            setState(() {
                              isChatShown = !isChatShown;
                            });
                          },
             
                          buttonText:
                              isChatShown ? "Cancel".tr : "Send Message".tr,
                          buttonStyle: ElevatedButton.styleFrom(
                            minimumSize: isChatShown
                                ? Size(0.11, isPortrait ? 0.045.h : 0.05.h)
                                : Size(0.125.w, isPortrait ? 0.045.h : 0.05.h),
                            backgroundColor: isChatShown
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                : MyThemeData.lightPrimary,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.015.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.02.w),
                        child: MainCustomIconButton(
                          onPressed: () {
                            //todo
                            Navigator.pop(context);
                            setState(() {
                              widget.status = "Rejected".tr;
                              widget.statusState(widget.status);
                            });
                          },
                       
                          buttonStyle: ElevatedButton.styleFrom(
                            minimumSize: isPortrait
                                ? Size(0.155.w, 0.045.h)
                                : Size(0.155.w, 0.055.h),
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            )),
                          ),
                        ),
                      ),
                      MainCustomIconButton(
                        onPressed: () {
                          Navigator.pop(context);

                          setState(() {
                            widget.status = "Approved".tr;
                            widget.statusState(widget.status);
                          });
                        },
                    
                        buttonText: "Approve Leave".tr,
                        buttonStyle: ElevatedButton.styleFrom(
                            minimumSize: isPortrait
                                ? Size(0.155.w, 0.045.h)
                                : Size(0.155.w, 0.055.h),
                          backgroundColor: MyThemeData.signOut,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
