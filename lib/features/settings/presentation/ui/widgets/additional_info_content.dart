///******************* FILE INFO **********************************///
/// Purpose: A widget that displays the additional info documents and images.
/// Author: Mohamed Elrashidy
/// Refactored At: 13/11/2024

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/shared_components/request_escalate_dialog.dart';
import 'package:demo_app/core/helper/file_path_functions.dart';
import 'package:demo_app/features/settings/presentation/controller/settings_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'document_section.dart';

class AdditionalInfoContent extends StatelessWidget {
  AdditionalInfoContent({super.key});
  SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return /*DocumentSection(
      educationCertificateImage: settingsController
          .employee!.educationCertificate?.educationCertificate?.lastOrNull,
      educationCertificateOnPressed: () async {
        onTapDocument(
            settingsController.employee!.educationCertificate!
                .educationCertificate!.lastOrNull,
            context);
      },
      idPhotoImage: settingsController.employee!.idPhoto!.idPhoto?.lastOrNull,
      idPhotoOnPressed: () async {
        onTapDocument(
            settingsController.employee!.idPhoto!.idPhoto?.lastOrNull, context);
      },
      drivingLicenseImage: settingsController
          .employee!.drivingLicense!.drivingLicense?.lastOrNull,
      drivingLicenseOnPressed: () async {
        onTapDocument(
            settingsController
                .employee!.drivingLicense!.drivingLicense?.lastOrNull,
            context);
      },
      maritalCertificateImage: settingsController
          .employee!.maritalCertificate!.maritalCertificate?.lastOrNull,
      maritalCertificateOnPressed: () async {
        onTapDocument(
            settingsController
                .employee!.maritalCertificate!.maritalCertificate?.lastOrNull,
            context);
      },
      lifeInsuranceCardImage:
          settingsController.employee!.insuranceCard!.insuranceCard?.lastOrNull,
      lifeInsuranceCardOnPressed: () async {
        onTapDocument(
            settingsController
                .employee!.insuranceCard!.insuranceCard?.lastOrNull,
            context);
      },
      maritalServiceProofImage: settingsController
          .employee!.armyCertificate!.armyCertificate?.lastOrNull,
      maritalServiceProofOnPressed: () async {
        await onTapDocument(
            settingsController
                .employee!.armyCertificate!.armyCertificate!.lastOrNull,
            context);
      },
    );*/Container();
  }

  onTapDocument(String? documentPath, BuildContext context) async {
    if (documentPath != null) {
      var link = Uri.parse(documentPath);
      print(FilePathFunctions.isImage(documentPath));
      FilePathFunctions.isImage(documentPath)
          ? showDialog(
              context: context,
              builder: (BuildContext context) {
                return RequestExcalateDialog(
                    isSetting: true,
                    title: "",
                    imageUrl: documentPath,
                    isExclate: false,
                    isToShowImage: true);
              },
            )
          : await launchUrl(link, mode: LaunchMode.externalApplication);
    }
  }
}
