import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/services/notifications/firebase_notification_handler.dart';
import 'package:meta/meta.dart';

import '../../../employees/presentation/controller/employee_controller.dart';
import '../../data/repository/notification_repository_main_core.dart';

part 'notification_controller_state_main_core.dart';

class NotificationControllerCubit extends Cubit<NotificationControllerState> {
  NotificationControllerCubit() : super(NotificationControllerInitial());
  NotificationRepository notificationRepository = NotificationRepository();

  sendNotification(
      {required String title,
      required String arabicTitle,
      required String body,
      required String arabicBody,
      required String type,
      required List<String> emails,
      Map<String, dynamic>? payload}) async {
    payload ??= {};
    await FirebaseNotificationHandler.sendNotification(title, body, emails, {
      'Arabic_Title': arabicTitle,
      'Arabic_Body': arabicBody,
      'Type': type,
      'English_Title': title,
      'English_Body': body,
      'Payload': jsonEncode(payload)
    });
    notificationRepository.addNotifications(
        titleEnglish: title,
        titleArabic: arabicTitle,
        bodyEnglish: body,
        bodyArabic: arabicBody,
        type: type,
        emails: emails,
        currentUserEmail:
            Get.find<EmployeeController>().employee!.email!.last!,
        payLoad: payload);
  }
}
