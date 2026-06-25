import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final storage = GetStorage();

class BiometricController extends GetxController {
  RxBool isBiometricEnabled = storage.read('Biometric') == null
      ? true.obs
      : storage.read('Biometric') == true
          ? true.obs
          : false.obs;

  void toggleBiometricFeedback(bool value) {
    isBiometricEnabled.value = value;
    storage.write('Biometric', value);
    update();
  }
}
