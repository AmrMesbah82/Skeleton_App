/******************** FILE INFO ********************/
/// File Name: social_permissions.dart
/// Purpose: Enum for Social Permissions in the application
/// Created by: Mohamed Elrashidy
/// Updated: Fixed to use proper AppConstanstForm constants

import 'package:get/get.dart';

import 'package:demo_app/core/helper_module/form_builder_module/core/constants/strings.dart';
import 'package:demo_app/features/roles/role_management/domain/interfaces/module_permissions_sections_permissions.dart';

enum SocialPermissions implements ModulePermissionsSectionsPermission {
  shareSocialInformation,
  shareEmailsAndSocialDataInBio,
  shareCellphonesInSocialDataInBio,
  academicHistory,
  certificates,
  skillsHobbies;

  @override
  bool get isChild {
    return false;
  }

  @override
  String get getDataBaseName {
    switch (this) {
      case shareSocialInformation:
        return 'Share_Social_Information';

      case shareEmailsAndSocialDataInBio:
        return 'Share_Emails_And_Social_Data_In_Bio';

      case shareCellphonesInSocialDataInBio:
        return 'Share_Cellphones_In_Social_Data_In_Bio';

      case academicHistory:
        return 'Academic_History';

      case certificates:
        return 'Certificates';

      case skillsHobbies:
        return 'Skills_Hobbies';
    }
  }

  @override
  String get getUiName {
    switch (this) {
      case shareSocialInformation:
        return AppConstanstForm.shareSocialInformation.tr; // ✅ FIXED: Was using takeScreenShot

      case shareEmailsAndSocialDataInBio:
        return AppConstanstForm.shareEmailsAndSocialDataInBio.tr;

      case shareCellphonesInSocialDataInBio:
        return AppConstanstForm.shareCellphonesInSocialDataInBio.tr;

      case academicHistory:
        return AppConstanstForm.academicHistory.tr;

      case certificates:
        return AppConstanstForm.certificates.tr;

      case skillsHobbies:
        return AppConstanstForm.skillsHobbies.tr;
    }
  }
}