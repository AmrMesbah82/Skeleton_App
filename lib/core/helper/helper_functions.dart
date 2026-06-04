import 'package:get/get.dart';

abstract class HelperFunctions {
  static bool get isEnglish => Get.locale?.languageCode == 'en';
  static String getUserImage({required String? imagePath, required String? gender})
  {
    String userImagePath;
    if (imagePath != null) {
      userImagePath =imagePath;
    } else {
      if (gender == 'female')
        userImagePath = 'assets/images/female_avatar.png';
      else {
        userImagePath = 'assets/images/male_avatar.png';
      }
    }
    return userImagePath;
  }
}
