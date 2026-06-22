// ignore_for_file: unrelated_type_equality_checks, unnecessary_string_interpolations, body_might_complete_normally_nullable

import 'package:demo_app/core/shared_components/custom_icon_container.dart';
import 'package:demo_app/core/shared_components/request_escalate_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:demo_app/features/requests/requests_components/rejected_request_dialog.dart';
import 'package:demo_app/core/widgets/form_fields/profile_textfield.dart';
import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/employees/presentation/controller/employee_controller.dart';
import 'package:demo_app/features/requests/request_controller.dart';
import 'package:demo_app/features/requests/data/models/request_model.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:demo_app/core/custom/33-custom_haptic.dart';

/// Date Created :7/Dec/2023
/// Developer Name : Bassem Mohamed
/// App Version : Version 2
/// Date of Last Edit :14/Dec/2023
/// Objectives: this screen widget is responsible for showing the change requested container,
///  this container behaves dynamically according to the case requested to change.
///
class CustomRequestContainer extends StatefulWidget {
  final List<RequestsModel> requestsModal;
  final bool isReview;

  const CustomRequestContainer({
    Key? key,
    required this.requestsModal,
    required this.isReview,
  }) : super(key: key);

  @override
  State<CustomRequestContainer> createState() => _CustomRequestContainerState();
}

EmployeeController addEmployeeController = Get.put(EmployeeController());

class _CustomRequestContainerState extends State<CustomRequestContainer> {
  List<String> imageExtentions = [
    ".PSD",
    ".XCF",
    ".AI",
    ".CDR",
    ".tif",
    ".tiff",
    ".bmp",
    ".jpg",
    ".jpeg",
    ".gif",
    ".png",
    ".eps",
    ".raw",
    ".cr2",
    ".nef",
    ".orf",
    ".sr2"
  ];
  bool isImage(String filePath) {
    bool flag = false;
    for (String imageExtention in imageExtentions) {
      if (filePath.contains(imageExtention)) {
        return true;
      }
    }
    return flag;
  }

  TextStyle textStyle(Color textColor, BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: isPortrait
          ? FontConstants.fontSize013.h
          : FontConstants.fontSize018.w,
      fontWeight: Get.locale.toString().contains('en')
          ? FontWeight.w900
          : FontWeight.w500,
      height: 0.0018.h,
      color: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final TextStyle blackTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: isPortrait
          ? FontConstants.fontSize016.h
          : FontConstants.fontSize021.h,
      color: themeController.currentTheme == AppColors.lightTheme
          ? AppColors.colorBlack
          : AppColors.colorWhiteDark,
      fontWeight: Get.locale.toString().contains('en')
          ? FontWeight.w600
          : FontWeight.w500,
    );

    final TextStyle greyTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: isPortrait
          ? FontConstants.fontSize016.h
          : FontConstants.fontSize021.h,
      color: themeController.currentTheme == AppColors.lightTheme
          ? AppColors.colorDarkGrey
          : AppColors.colorGreydark,
      fontWeight: Get.locale.toString().contains('en')
          ? FontWeight.w600
          : FontWeight.w500,
    );

    return GetBuilder<RequestController>(builder: (controller) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
          // color: themeController.currentTheme == AppColors.lightTheme
          //     ? AppColors.colorLightGrey
          //     : AppColors.darkBackGround,
          borderRadius: BorderRadius.circular(7),
        ),
        padding: EdgeInsets.symmetric(vertical: 0.02.h, horizontal: 0.02.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Column 1: Rounded Image
                widget.requestsModal[0].image != null
                    ? Container(
                        width: isPortrait ? 0.1.h : 0.15.h,
                        height: isPortrait ? 0.1.h : 0.15.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(widget.requestsModal[0].image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        width: isPortrait ? 0.1.h : 0.15.h,
                        height: isPortrait ? 0.1.h : 0.15.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/male_avatar.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                SizedBox(width: 0.02.h),

                // Column 2: Employee Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            addEmployeeController
                                .getEmployeeName(widget.requestsModal[0].email!)
                                .capitalize!,
                            //    '${widget.requestsModal[0].firstName!.capitalize} ${widget.requestsModal[0].lastName!.capitalize}',
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: FontConstants.fontSize023.h,
                              color: themeController.currentTheme ==
                                      AppColors.lightTheme
                                  ? AppColors.colorBlack
                                  : AppColors.colorWhiteDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                              DateFormat('dd-MM-yyyy hh:mm a',
                                      Get.locale.toString())
                                  .format(widget.requestsModal[0].dateRequest!
                                      .toDate()),
                              style: blackTextStyle),
                        ],
                      ),
                      SizedBox(height: 0.02.h),
                      Row(
                        children: [
                          Text(
                            '${'Department'.tr}: ',
                            style: greyTextStyle,
                          ),
                          Text(
                            widget.requestsModal[0].department!.capitalize!.tr,
                            style: blackTextStyle,
                          ),
                          SizedBox(width: isPortrait ? 0.015.w : 0.04.h),
                          !isPortrait
                              ? Text(
                                  '${'Role'.tr}: ',
                                  style: greyTextStyle,
                                )
                              : const SizedBox(),
                          !isPortrait
                              ? Text(
                                  widget.requestsModal[0].role!.capitalize!.tr,
                                  style: blackTextStyle,
                                )
                              : const SizedBox(),
                          SizedBox(width: isPortrait ? 0.015.w : 0.04.h),
                          !isPortrait
                              ? Text(
                                  '${'Section'.tr}: ',
                                  style: greyTextStyle,
                                )
                              : SizedBox.shrink(),
                          !isPortrait
                              ? Text(
                                  widget
                                      .requestsModal[0].section!.capitalize!.tr,
                                  style: blackTextStyle,
                                )
                              : SizedBox.shrink(),
                          const Spacer(),
                          !isPortrait &&
                                  !widget.isReview &&
                                  widget.requestsModal.length > 1
                              ? ElevatedButton(
                                  onPressed: () {
                                    controller.acceptAll(widget.requestsModal);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.unBlock,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    fixedSize: Size(double.infinity,
                                        isPortrait ? 0.045.h : 0.06.h),
                                  ),
                                  child: Text(
                                    'Accept All'.tr,
                                    style:
                                        AppFontStyle.cairoRegularStyle.copyWith(
                                      fontSize: isPortrait
                                          ? FontConstants.fontSize016.h
                                          : FontConstants.fontSize022.h,
                                      color: themeController.currentTheme ==
                                              AppColors.lightTheme
                                          ? AppColors.colorWhite
                                          : AppColors.colorWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      isPortrait ? SizedBox(height: 0.02.h) : const SizedBox(),
                      isPortrait
                          ? Row(
                              children: [
                                Text(
                                  '${'Section'.tr}: ',
                                  style: greyTextStyle,
                                ),
                                Text(
                                  widget
                                      .requestsModal[0].section!.capitalize!.tr,
                                  style: blackTextStyle,
                                ),
                              ],
                            )
                          : const SizedBox(),
                      isPortrait ? SizedBox(height: 0.02.h) : const SizedBox(),
                      isPortrait
                          ? Row(
                              children: [
                                Text(
                                  '${'Role'.tr}: ',
                                  style: greyTextStyle,
                                ),
                                Text(
                                  widget.requestsModal[0].role!.capitalize!.tr,
                                  style: blackTextStyle,
                                ),
                                const Spacer(),
                                !widget.isReview &&
                                        widget.requestsModal.length > 1
                                    ? ElevatedButton(
                                        onPressed: () {
                                          controller
                                              .acceptAll(widget.requestsModal);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.unBlock,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          fixedSize: Size(double.infinity,
                                              isPortrait ? 0.045.h : 0.06.h),
                                        ),
                                        child: Text(
                                          'Accept All'.tr,
                                          style: AppFontStyle.cairoRegularStyle
                                              .copyWith(
                                            fontSize: isPortrait
                                                ? FontConstants.fontSize016.h
                                                : FontConstants.fontSize022.h,
                                            color:
                                                themeController.currentTheme ==
                                                        AppColors.lightTheme
                                                    ? AppColors.colorWhite
                                                    : AppColors.colorWhite,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: .15.w),
              child: Divider(
                  height: 0.03.h,
                  thickness: 0.002.h,
                  color: AppColors.secondaryPrimary),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0.01.h, bottom: 0.01.h),
              child: Column(
                children: List.generate(
                  widget.requestsModal.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 0.02.h),
                    child: Column(
                      children: [
                        index == 0
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: isPortrait ? 0.002.h : .01.h),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: widget
                                              .requestsModal[index].newData!
                                              .contains('http')
                                          ? 0
                                          : isPortrait
                                              ? 0.18.w
                                              : .12.w,
                                    ),
                                    Text('Current'.tr, style: blackTextStyle),
                                    SizedBox(
                                      width: isPortrait
                                          ? widget.requestsModal[index].newData!
                                                  .contains('http')
                                              ? .28.w
                                              : 0.17.w
                                          : widget.requestsModal[index].newData!
                                                  .contains('http')
                                              ? .32.w
                                              : .24.w,
                                    ),
                                    Text('New'.tr, style: blackTextStyle),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.requestsModal[index].newData!
                                        .contains('http')
                                    ? const SizedBox()
                                    : SizedBox(
                                        width: isPortrait ? 0.16.w : 0.1.w,
                                        child: Text(
                                          widget.requestsModal[index]
                                              .whatChanged!.capitalize!.tr,
                                          style: AppFontStyle.cairoRegularStyle
                                              .copyWith(
                                            fontSize: isTablet
                                                ? isPortrait
                                                    ? FontConstants
                                                        .fontSize014.h
                                                    : FontConstants
                                                        .fontSize022.h
                                                : FontConstants.fontSize018.h,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inverseSurface,
                                          ),
                                        ),
                                      ),
                                widget.requestsModal[index].newData!
                                        .contains('http')
                                    ? const SizedBox()
                                    : SizedBox(
                                        width: 0.02.w,
                                      ),
                                widget.requestsModal[index].newData!
                                        .contains('http')
                                    ? CustomIconContainer(
                                        isSmallerFont: MediaQuery.of(context)
                                                    .size
                                                    .shortestSide >
                                                600
                                            ? false
                                            : true,
                                        text: widget.requestsModal[index]
                                            .whatChanged!.capitalize!,
                                        image: widget
                                            .requestsModal[index].currentData,
                                        isEdit: true,
                                        onPressed: () async {
                                          if (widget.requestsModal[index]
                                                  .currentData !=
                                              null) {
                                            var link = Uri.parse(widget
                                                .requestsModal[index]
                                                .currentData!);
                                            isImage(widget.requestsModal[index]
                                                    .currentData!)
                                                ? showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return RequestExcalateDialog(
                                                        isSetting: true,
                                                        title: "",
                                                        imageUrl: widget
                                                            .requestsModal[
                                                                index]
                                                            .currentData!,
                                                        isExclate: false,
                                                        isToShowImage: true,
                                                      );
                                                    },
                                                  )
                                                : await launchUrl(
                                                    link,
                                                    mode: LaunchMode
                                                        .externalApplication,
                                                  );
                                          }
                                        },
                                      )
                                    : SizedBox(
                                        width: isPortrait ? 0.22.w : 0.25.w,
                                        child: textfieled(
                                          
                                            context,
                                            (value) {},
                                            (value) {},
                                            ' ',
                                            widget.requestsModal[index]
                                                    .currentData?.capitalize ??
                                                '',
                                            null,
                                            controller: null,
                                            isReadOnly: true,
                                            ),
                                      ),
                                SizedBox(
                                  width: 0.02.w,
                                ),
                                widget.requestsModal[index].newData!
                                        .contains('http')
                                    ? CustomIconContainer(
                                        isSmallerFont: MediaQuery.of(context)
                                                    .size
                                                    .shortestSide >
                                                600
                                            ? false
                                            : true,
                                        text: widget.requestsModal[index]
                                            .whatChanged!.capitalize!,
                                        image:
                                            widget.requestsModal[index].newData,
                                        isEdit: true,
                                        onPressed: () async {
                                          if (widget.requestsModal[index]
                                                  .newData !=
                                              null) {
                                            var link = Uri.parse(widget
                                                .requestsModal[index].newData!);
                                            isImage(widget.requestsModal[index]
                                                    .newData!)
                                                ? showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return RequestExcalateDialog(
                                                        isSetting: true,
                                                        title: "",
                                                        imageUrl: widget
                                                            .requestsModal[
                                                                index]
                                                            .newData!,
                                                        isExclate: false,
                                                        isToShowImage: true,
                                                      );
                                                    },
                                                  )
                                                : await launchUrl(
                                                    link,
                                                    mode: LaunchMode
                                                        .externalApplication,
                                                  );
                                          }
                                        },
                                      )
                                    : SizedBox(
                                        width: isPortrait ? 0.22.w : 0.25.w,
                                        child: textfieled(
                                            context,
                                            (value) {},
                                            (value) {},
                                            ' ',
                                            widget.requestsModal[index].newData!
                                                .capitalize!,
                                            null,
                                            controller: null,
                                            isReadOnly: true,
                                             ),
                                      ),
                              ],
                            ),
                            // Spacer(),
                            !widget.isReview
                                ? widget.requestsModal[index].newData!
                                            .contains('http') &&
                                        isPortrait
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 0.008.h),
                                            child: SizedBox(
                                              height:
                                                  isPortrait ? 0.06.w : 0.045.w,
                                              width:
                                                  isPortrait ? 0.06.w : 0.045.w,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  controller.updateRequest(
                                                      'approved',
                                                      widget.requestsModal[
                                                          index]);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.unBlock,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                                child: SvgPicture.asset(
                                                    'assets/icons/acceptReq.svg'),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: isPortrait
                                                  ? 0.015.w
                                                  : 0.02.h),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 0.008.h),
                                            child: SizedBox(
                                              height:
                                                  isPortrait ? 0.06.w : 0.045.w,
                                              width:
                                                  isPortrait ? 0.06.w : 0.045.w,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  controller.updateRequest(
                                                      'rejected',
                                                      widget.requestsModal[
                                                          index]);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.block,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                                child: SvgPicture.asset(
                                                    'assets/icons/declineReq.svg'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 0.008.h),
                                            child: SizedBox(
                                              height:
                                                  isPortrait ? 0.06.w : 0.035.w,
                                              width:
                                                  isPortrait ? 0.06.w : 0.045.w,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  controller.updateRequest(
                                                      'rejected',
                                                      widget.requestsModal[
                                                          index]);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.block,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                                child: SvgPicture.asset(
                                                    'assets/icons/declineReq.svg'),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: isPortrait
                                                  ? 0.015.w
                                                  : 0.02.h),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 0.008.h),
                                            child: SizedBox(
                                              height:
                                                  isPortrait ? 0.06.w : 0.035.w,
                                              width:
                                                  isPortrait ? 0.06.w : 0.045.w,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  controller.updateRequest(
                                                      'approved',
                                                      widget.requestsModal[
                                                          index]);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.unBlock,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/icons/acceptReq.svg',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            isPortrait ? 0.0.w : 0.02.w),
                                    child: Text(
                                      widget.requestsModal[index].status
                                          .toString()
                                          .capitalize!
                                          .tr,
                                      style: textStyle(
                                          capitalize(widget.requestsModal[index]
                                                      .status!) ==
                                                  "Approved".tr
                                              ? AppColors.unBlock
                                              : capitalize(widget
                                                          .requestsModal[index]
                                                          .status!) ==
                                                      "Rejected".tr
                                                  ? AppColors.colorRed
                                                  : AppColors.warning,
                                          context),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
