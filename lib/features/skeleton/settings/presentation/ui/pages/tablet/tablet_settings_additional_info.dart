///*************************** FILE INFO **********************************///
/// Purpose: A Tablet Screen that displays the additional info documents and images.
/// Author: Mohamed Elrashidy
/// Refactored At: 13/11/2024
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/widgets/additional_info_content.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/widgets/settings_header.dart';
import 'package:demo_app/components/tracking_time_components/track_time_subwidget/request_escalate_dialog.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/features/skeleton/controllers/request_controller.dart';
import '../../../controller/settings_controller.dart';


class TabletSettingsAdditionalInfo extends StatefulWidget {
  const TabletSettingsAdditionalInfo({super.key});

  @override
  _TabletSettingsAdditionalInfoState createState() => _TabletSettingsAdditionalInfoState();
}

class _TabletSettingsAdditionalInfoState extends State<TabletSettingsAdditionalInfo> {
  int selectedContainerIndex = 0;
  bool isEnglish = Get.locale.toString().contains('en');
  SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GetBuilder<RequestController>(
        init: Get.find<RequestController>(),
        builder: (requestController) {
          return Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: isPortrait
                        ? Mode.owner
                            ? 0.678.h
                            : 0.62.h
                        : 0.54.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.02.w, vertical: 0.01.w),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: 0.02.h, top: 0.01.h),
                              child: SettingsHeader(
                                imagePath: 'assets/icons/newAddInfo.svg',
                                text: 'Additional Information'.tr,
                              ),
                            ),
                            AdditionalInfoContent()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: Get.locale.toString().contains('ar')
                        ? (isPortrait
                            ? EdgeInsets.only(
                                top: 0.015.w,
                                bottom: 0.0
                                    .h, // Use Arabic vertical value for bottom
                              )
                            : EdgeInsets.only(
                                top: 0.025
                                    .h, // Use Arabic horizontal value for top
                                bottom: 0.0.w,
                              ))
                        : EdgeInsets.only(
                            top: isPortrait ? 0.02.w : 0.025.h,
                            bottom: isPortrait ? 0.0 : 0.0.h,
                          ),
                    child: Container(
                      width: isPortrait ? double.infinity : null,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyThemeData.signOut,
                          padding: EdgeInsets.symmetric(
                            vertical: isPortrait ? 0.01.h : 0.015.h,
                            horizontal: isPortrait ? 0 : 0.155.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RequestExcalateDialog(
                                  isSetting: true,
                                  title: "Request to Change",
                                  imageUrl: "assets/icons/reqToChange.svg",
                                  isExclate: false,
                                  onPressed: () {}
                                  /*: () async {
                                  print('asdaaaff');
                                  print(
                                      'educationCertificate2: $educationCertificate2');
                                  void share() {
                                    requestController
                                            .requestsModel.value.department =
                                        settingsController.employee!.department!
                                            .department!.last!
                                            .trim();
                                    requestController.requestsModel.value
                                        .dateRequest = Timestamp.now();
                                    requestController
                                            .requestsModel.value.firstName =
                                        settingsController.employee!.firstName!
                                            .firstNames!.last!;
                                    requestController
                                            .requestsModel.value.lastName =
                                        settingsController.employee!.lastName!
                                            .lastNames!.last!;
                                    requestController
                                            .requestsModel.value.image =
                                        settingsController
                                            .employee!
                                            .employeePhoto
                                            ?.employeePhotos
                                            ?.lastOrNull;
                                    requestController.requestsModel.value
                                        .section = 'additional info';
                                    requestController
                                            .requestsModel.value.email =
                                        settingsController
                                            .employee!.email!.emails!.last;
                                    requestController
                                        .requestsModel.value.status = 'pending';
                                    requestController.requestsModel.value.role =
                                        settingsController
                                            .employee!.role!.role!.last!;
                                    requestController
                                            .requestsModel.value.requestId =
                                        '${settingsController.employee!.firstName!.firstNames!.last!}_${settingsController.employee!.lastName!.lastNames!.last!}_${DateTime.now()}';
                                  }

                                  if (educationCertificate2 != null) {
                                    requestController.requestsModel.value
                                        .whatChanged = 'education certificate';
                                    share();
                                    requestController.requestsModel.value
                                        .newData = educationCertificate2;
                                    requestController
                                            .requestsModel.value.currentData =
                                        settingsController
                                            .employee!
                                            .educationCertificate
                                            ?.educationCertificate
                                            ?.lastOrNull;
                                    await requestController.createRequest(
                                        requestController.requestsModel.value,
                                        requestController
                                            .requestsModel.value.requestId!);
                                  }
                                  if (idPhoto2 != null) {
                                    requestController.requestsModel.value
                                        .whatChanged = 'id photo';
                                    share();
                                    requestController
                                        .requestsModel.value.newData = idPhoto2;
                                    requestController
                                            .requestsModel.value.currentData =
                                        settingsController.employee!.idPhoto
                                            ?.idPhoto?.lastOrNull;
                                    await requestController.createRequest(
                                        requestController.requestsModel.value,
                                        requestController
                                            .requestsModel.value.requestId!);
                                  }
                                  if (drivingLicense2 != null) {
                                    requestController.requestsModel.value
                                        .whatChanged = 'driving license';
                                    share();
                                    requestController.requestsModel.value
                                        .newData = drivingLicense2;
                                    requestController
                                            .requestsModel.value.currentData =
                                        settingsController
                                            .employee!
                                            .drivingLicense
                                            ?.drivingLicense
                                            ?.lastOrNull;
                                    await requestController.createRequest(
                                        requestController.requestsModel.value,
                                        requestController
                                            .requestsModel.value.requestId!);
                                  }
                                  if (insuranceCard2 != null) {
                                    requestController.requestsModel.value
                                        .whatChanged = 'insurance card';
                                    share();
                                    requestController.requestsModel.value
                                        .newData = insuranceCard2;
                                    requestController
                                            .requestsModel.value.currentData =
                                        settingsController
                                            .employee!
                                            .insuranceCard
                                            ?.insuranceCard
                                            ?.lastOrNull;
                                    await requestController.createRequest(
                                        requestController.requestsModel.value,
                                        requestController
                                            .requestsModel.value.requestId!);
                                  }
                                  if (armyCertificate2 != null) {
                                    requestController.requestsModel.value
                                        .whatChanged = 'army certificate';
                                    share();
                                    requestController.requestsModel.value
                                        .newData = armyCertificate2;
                                    requestController
                                            .requestsModel.value.currentData =
                                        settingsController
                                            .employee!
                                            .armyCertificate
                                            ?.armyCertificate
                                            ?.lastOrNull;
                                    await requestController.createRequest(
                                        requestController.requestsModel.value,
                                        requestController
                                            .requestsModel.value.requestId!);
                                  }
                                  if (maritalCertificate2 != null) {
                                    requestController.requestsModel.value
                                        .whatChanged = 'marital certificate';
                                    share();
                                    requestController.requestsModel.value
                                        .newData = maritalCertificate2;
                                    requestController
                                            .requestsModel.value.currentData =
                                        settingsController
                                            .employee!
                                            .maritalCertificate
                                            ?.maritalCertificate
                                            ?.lastOrNull;
                                    await requestController.createRequest(
                                        requestController.requestsModel.value,
                                        requestController
                                            .requestsModel.value.requestId!);
                                  }

                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const SuccessDialog(
                                        title: "Successful",
                                        subtitle:
                                            "You Successfully Sent This Request",
                                        lottieAsset:
                                            "assets/images/correct.json",
                                      );
                                    },
                                  );

                                  //setState(() {});
                                }*/

                                  );
                            },
                          );
                        },
                        child: Text(
                          'Request to Change'.tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: isPortrait
                                ? FontConstants.fontSize020.h
                                : FontConstants.fontSize025.h,
                            fontWeight: FontWeight.w500,
                            color: MyThemeData().contrastColor(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
