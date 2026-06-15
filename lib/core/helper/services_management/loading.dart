/// ******************* FILE INFO *******************
/// File Name: loading
/// Description: this page used for loading ui
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';


Future<void> showLoadingIndicator() {
  return Get.dialog(
    Center(
      child: Container(
        width: 70,
        height: 70,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const CircularProgressIndicator(color: Colors.white),
      ),
    ),
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.4),
  );
}

hideLoadingIndicator() {
  Get.back();
}
