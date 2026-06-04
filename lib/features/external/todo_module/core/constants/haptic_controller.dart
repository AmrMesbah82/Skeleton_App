import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vibration/vibration.dart';

import 'enum.dart';

final storage = GetStorage();

class ToDoHapticController extends GetxController {
  // Define a variable to hold the haptic feedback status
  RxBool isHapticEnabled =
      storage.read('haptic') == true ? true.obs : false.obs;

  // Method to toggle the haptic feedback status
  void toggleHapticFeedback(bool value) {
    isHapticEnabled.value = value;
    storage.write('haptic', value);
    update();
  }

  Future<void> triggerHapticFeedback({
    VibrateType vibration = VibrateType.lightImpact,
    Function() hapticFeedback = HapticFeedback.mediumImpact,
  }) async {
    if (isHapticEnabled.value) {
      if (Platform.isAndroid) {
        Vibration.vibrate(
          duration: vibration == VibrateType.lightImpact
              ? 50
              : vibration == VibrateType.mediumImpact
                  ? 70
                  : 90,
        );
      } else {
        hapticFeedback();
      }
    }
  }
}
