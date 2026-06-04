import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../enumeration/enum.dart';

class StringFormatter {
  static String localizedString(
      {required String englishName, required String? arabicName}) {
if( Get.locale.toString().contains('en')|| arabicName == null)
  {
    return capitalize(englishName);
  }
  else
  {
    return arabicName;
  }
}}
