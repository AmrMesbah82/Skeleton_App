/// ******************* FILE INFO *******************
/// File Name: sla_notification_model.dart
/// Description: Data model for SLA notification screen
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025

import 'package:flutter/cupertino.dart';

class SlaNotificationModel {
  // Controllers
  final TextEditingController slaOneController = TextEditingController();
  final TextEditingController slaTwoController = TextEditingController();
  List<TextEditingController> extraSlaControllers = [];
  List<TextEditingController> extraSlaTwoControllers = [];

  // Checkbox states
  bool notifyRequesterChecked = true;
  bool notifyProviderChecked = true;
  bool notifyManagerChecked = true;

  // Switch states
  bool notifyRequesterSwitch0 = false;
  bool notifyManagerSwitch1 = false;

  // Validation flags
  bool isInvalidNumber = false;
  bool isInvalidNumberTwo = false;

  // Notification switches map
  Map<String, Map<int, bool>> notificationSwitches = {};

  // Other fields
  String? formatDate;
  static const int maxSlaInputs = 5;

  void dispose() {
    slaOneController.dispose();
    slaTwoController.dispose();
    for (var controller in extraSlaControllers) {
      controller.dispose();
    }
    for (var controller in extraSlaTwoControllers) {
      controller.dispose();
    }
  }
}