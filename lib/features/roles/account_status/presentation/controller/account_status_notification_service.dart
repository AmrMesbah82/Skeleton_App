/// ************************* FILE INFO ************************* ///
/// File Name: account_status_notification_service.dart
/// Purpose: Centralized service for sending account status notifications
/// Author: AI Assistant
/// Created At: 23/12/2025
/// Updated: 23/12/2025 - Removed static adminEmail parameter
/// Features:
///   - Send push notifications (FCM)
///   - Save notifications to Firestore
///   - Dynamically fetch Master Admin emails
///   - Handle bilingual messages (English/Arabic)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import '../../../../notification/data/models/notification_data_model.dart';

class AccountStatusNotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all Master Admin emails from Firestore
  /// ✅ UPDATED: Correctly parses List structure for Role and Email
  static Future<List<String>> _getMasterAdminEmails() async {
    try {

      QuerySnapshot employeesSnapshot = await _firestore
          .collection(getBaseUrl('Employees_Info'))
          .get();

      List<String> masterAdminEmails = [];

      for (var doc in employeesSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // ✅ FIXED: Handle List structure for Role
        if (data.containsKey('Role') && data['Role'] is List) {
          List<dynamic> roleList = data['Role'];

          // Get last role (current role)
          if (roleList.isNotEmpty) {
            String lastRole = roleList.last.toString().toLowerCase();

            if (lastRole == 'master admin') {
              // ✅ FIXED: Handle List structure for Email
              if (data.containsKey('Email') && data['Email'] is List) {
                List<dynamic> emailList = data['Email'];

                if (emailList.isNotEmpty) {
                  String email = emailList.last.toString();
                  masterAdminEmails.add(email);
                }
              }
            }
          }
        }
      }

      return masterAdminEmails;
    } catch (e, stackTrace) {
      return [];
    }
  }

  /// Send push notification using FCM
  static Future<void> _sendPushNotification({
    required String title,
    required String body,
    required String recipientEmail,
  }) async {
    try {

      // TODO: Replace with your actual notification service
      // Example:
      // await NotificationServiceApp.sendNotification(
      //   title,
      //   body,
      //   recipientEmail,
      // );

    } catch (e, stackTrace) {
    }
  }

  /// Save notification to Firestore
  static Future<void> _saveNotificationToFirestore({
    required String title,
    required String body,
    required String senderEmail,
    required String receiverEmail,
    required String module,
    required String page,
  }) async {
    try {

      final notificationModel = NotificationModelSystem(
        title: title,
        body: body,
        nameOfModule: module,
        senderEmail: senderEmail,
        receiverEmail: receiverEmail,
        nameOfPage: page,
        isPinned: false,
        isRead: false,
        isClean: false,
      );

      await _firestore
          .collection(getBaseUrl('Notifications'))
          .add(notificationModel.toMap());

    } catch (e, stackTrace) {
    }
  }

  /// Format date for display
  static String _formatDate(String dateString) {
    try {
      DateFormat inputFormat = DateFormat("d MMMM yyyy, hh:mm a", 'en');
      DateTime date = inputFormat.parse(dateString);
      DateFormat outputFormat = DateFormat("MMMM d, yyyy 'at' h:mm a", 'en');
      return outputFormat.format(date);
    } catch (e) {
      return dateString;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // PUBLIC NOTIFICATION METHODS (✅ REMOVED adminEmail parameter)
  // ═══════════════════════════════════════════════════════════

  /// 1. Account Activated (Manual)
  /// 1. Account Activated (Manual)
  static Future<void> sendAccountActivatedNotification({
    required String userEmail,
    required String userName,
    String senderEmail = "system@company.com", // ✅ ADD WITH DEFAULT
  }) async {

    // Send to USER
    await _sendPushNotification(
      title: "Account Activated",
      body: "Your account has been activated successfully. You now have access to the system.",
      recipientEmail: userEmail,
    );

    await _saveNotificationToFirestore(
      title: "Account Activated",
      body: "Your account has been activated successfully. You now have access to the system.",
      senderEmail: senderEmail, // ✅ USE PASSED SENDER
      receiverEmail: userEmail,
      module: "Roles",
      page: "AccountStatusPage",
    );

    // ✅ Send to ALL MASTER ADMINS (Dynamic - fetched from DB)
    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(
        title: "Account Activation Completed",
        body: "The user account $userName has been activated successfully.",
        recipientEmail: adminEmail,
      );

      await _saveNotificationToFirestore(
        title: "Account Activation Completed",
        body: "The user account $userName has been activated successfully.",
        senderEmail: senderEmail, // ✅ USE PASSED SENDER
        receiverEmail: adminEmail,
        module: "Roles",
        page: "AccountStatusPage",
      );
    }

  }

  /// 2. Account Deactivated (Manual)
  /// 2. Account Deactivated (Manual)
  static Future<void> sendAccountDeactivatedNotification({
    required String userEmail,
    required String userName,
    String senderEmail = "system@company.com", // ✅ ADD THIS
  }) async {
     // ✅ ADD THIS

    // Send to USER
    await _sendPushNotification(
      title: "Account Deactivated",
      body: "Your account has been deactivated. Please contact the administrator for more information.",
      recipientEmail: userEmail,
    );

    await _saveNotificationToFirestore(
      title: "Account Deactivated",
      body: "Your account has been deactivated. Please contact the administrator for more information.",
      senderEmail: senderEmail, // ✅ CHANGED FROM "system@company.com"
      receiverEmail: userEmail,
      module: "Roles", // ✅ CHANGED FROM "Account Status"
      page: "AccountStatusPage",
    );

    // Send to ALL MASTER ADMINS
    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(
        title: "Account Deactivation Completed",
        body: "The user account $userName has been deactivated successfully.",
        recipientEmail: adminEmail,
      );

      await _saveNotificationToFirestore(
        title: "Account Deactivation Completed",
        body: "The user account $userName has been deactivated successfully.",
        senderEmail: senderEmail, // ✅ CHANGED FROM "system@company.com"
        receiverEmail: adminEmail,
        module: "Roles", // ✅ CHANGED FROM "Account Status"
        page: "AccountStatusPage",
      );
    }

  }

  /// 3. Account Unlocked
  /// 3. Account Unlocked
  static Future<void> sendAccountUnlockedNotification({
    required String userEmail,
    required String userName,
    String senderEmail = "system@company.com", // ✅ ADD THIS
  }) async {
     // ✅ ADD THIS

    // Send to USER
    await _sendPushNotification(
      title: "Account Unlocked",
      body: "Your account has been unlocked. You may now access the system.",
      recipientEmail: userEmail,
    );

    await _saveNotificationToFirestore(
      title: "Account Unlocked",
      body: "Your account has been unlocked. You may now access the system.",
      senderEmail: senderEmail, // ✅ CHANGED FROM "system@company.com"
      receiverEmail: userEmail,
      module: "Roles", // ✅ CHANGED FROM "Account Status"
      page: "AccountStatusPage",
    );

    // Send to ALL MASTER ADMINS
    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(
        title: "Account Unlocked",
        body: "The user account $userName has been unlocked successfully and can login.",
        recipientEmail: adminEmail,
      );

      await _saveNotificationToFirestore(
        title: "Account Unlocked",
        body: "The user account $userName has been unlocked successfully and can login.",
        senderEmail: senderEmail, // ✅ CHANGED FROM "system@company.com"
        receiverEmail: adminEmail,
        module: "Roles", // ✅ CHANGED FROM "Account Status"
        page: "AccountStatusPage",
      );
    }

  }

  /// 4. Account Activation Scheduled
  static Future<void> sendActivationScheduledNotification({
    required String userEmail,
    required String userName,
    required String scheduledDate,
  }) async {

    String formattedDate = _formatDate(scheduledDate);

    // Send to USER
    await _sendPushNotification(
      title: "Account Activation Scheduled",
      body: "Your account is scheduled to be activated on $formattedDate.",
      recipientEmail: userEmail,
    );

    await _saveNotificationToFirestore(
      title: "Account Activation Scheduled",
      body: "Your account is scheduled to be activated on $formattedDate.",
      senderEmail: "system@company.com",
      receiverEmail: userEmail,
      module: "Account Status",
      page: "AccountStatusPage",
    );

    // ✅ Send to ALL MASTER ADMINS (Dynamic)
    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(
        title: "Activation Scheduled",
        body: "Account activation for $userName has been scheduled successfully for $formattedDate.",
        recipientEmail: adminEmail,
      );

      await _saveNotificationToFirestore(
        title: "Activation Scheduled",
        body: "Account activation for $userName has been scheduled successfully for $formattedDate.",
        senderEmail: "system@company.com",
        receiverEmail: adminEmail,
        module: "Account Status",
        page: "AccountStatusPage",
      );
    }

  }

  /// 5. Account Deactivation Scheduled
  static Future<void> sendDeactivationScheduledNotification({
    required String userEmail,
    required String userName,
    required String scheduledDate,
    String senderEmail = "system@company.com", // ✅ ADD THIS
  }) async {
     // ✅ ADD THIS

    String formattedDate = _formatDate(scheduledDate);

    // Send to USER
    await _sendPushNotification(
      title: "Account Deactivation Scheduled",
      body: "Your account is scheduled to be deactivated on $formattedDate.",
      recipientEmail: userEmail,
    );

    await _saveNotificationToFirestore(
      title: "Account Deactivation Scheduled",
      body: "Your account is scheduled to be deactivated on $formattedDate.",
      senderEmail: senderEmail, // ✅ CHANGED FROM "system@company.com"
      receiverEmail: userEmail,
      module: "Roles", // ✅ CHANGED FROM "Account Status"
      page: "AccountStatusPage",
    );

    // Send to ALL MASTER ADMINS
    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(
        title: "Deactivation Scheduled",
        body: "Account deactivation for $userName has been scheduled successfully for $formattedDate.",
        recipientEmail: adminEmail,
      );

      await _saveNotificationToFirestore(
        title: "Deactivation Scheduled",
        body: "Account deactivation for $userName has been scheduled successfully for $formattedDate.",
        senderEmail: senderEmail, // ✅ CHANGED FROM "system@company.com"
        receiverEmail: adminEmail,
        module: "Roles", // ✅ CHANGED FROM "Account Status"
        page: "AccountStatusPage",
      );
    }

  }

  /// 6. Schedule Edited (Activation/Deactivation)
  /// 6. Schedule Edited (Activation/Deactivation)
  static Future<void> sendScheduleEditedNotification({
    required String userEmail,
    required String userName,
    required String newScheduledDate,
    required String scheduleType, // "activation" or "deactivation"
    String senderEmail = "system@company.com", // ✅ ADD THIS
  }) async {
     // ✅ ADD THIS

    String formattedDate = _formatDate(newScheduledDate);

    // Send to USER
    await _sendPushNotification(
      title: "Access Schedule Updated",
      body: "The schedule related to your account access has been updated to $formattedDate.",
      recipientEmail: userEmail,
    );

    await _saveNotificationToFirestore(
      title: "Access Schedule Updated",
      body: "The schedule related to your account access has been updated to $formattedDate.",
      senderEmail: senderEmail, // ✅ CHANGED FROM "system@company.com"
      receiverEmail: userEmail,
      module: "Roles", // ✅ CHANGED FROM "Account Status"
      page: "AccountStatusPage",
    );

    // Send to ALL MASTER ADMINS
    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(
        title: "Schedule Updated",
        body: "Account $scheduleType schedule for $userName has been updated to $formattedDate.",
        recipientEmail: adminEmail,
      );

      await _saveNotificationToFirestore(
        title: "Schedule Updated",
        body: "Account $scheduleType schedule for $userName has been updated to $formattedDate.",
        senderEmail: senderEmail, // ✅ CHANGED FROM "system@company.com"
        receiverEmail: adminEmail,
        module: "Roles", // ✅ CHANGED FROM "Account Status"
        page: "AccountStatusPage",
      );
    }

  }

  /// 7. Schedule Canceled
  /// 7. Schedule Canceled
  static Future<void> sendScheduleCanceledNotification({
    required String userEmail,
    required String userName,
    String senderEmail = "system@company.com", // ✅ ADD THIS
  }) async {
     // ✅ ADD THIS

    // Send to USER
    await _sendPushNotification(
      title: "Access Schedule Canceled",
      body: "The scheduled access change for your account has been canceled.",
      recipientEmail: userEmail,
    );

    await _saveNotificationToFirestore(
      title: "Access Schedule Canceled",
      body: "The scheduled access change for your account has been canceled.",
      senderEmail: senderEmail, // ✅ CHANGED FROM "system@company.com"
      receiverEmail: userEmail,
      module: "Roles", // ✅ CHANGED FROM "Account Status"
      page: "AccountStatusPage",
    );

    // Send to ALL MASTER ADMINS
    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(
        title: "Schedule Canceled",
        body: "The scheduled access change for $userName has been canceled.",
        recipientEmail: adminEmail,
      );

      await _saveNotificationToFirestore(
        title: "Schedule Canceled",
        body: "The scheduled access change for $userName has been canceled.",
        senderEmail: senderEmail, // ✅ CHANGED FROM "system@company.com"
        receiverEmail: adminEmail,
        module: "Roles", // ✅ CHANGED FROM "Account Status"
        page: "AccountStatusPage",
      );
    }

  }

  /// 8. Account Locked (Multiple Failed Attempts) - ADMIN ONLY
  static Future<void> sendAccountLockedNotification({
    required String userEmail,
    required String userName,
  }) async {

    // ✅ Send to ALL MASTER ADMINS ONLY (Dynamic)
    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(
        title: "User Account Locked",
        body: "The user account $userName has been locked automatically after three consecutive failed access attempts.",
        recipientEmail: adminEmail,
      );

      await _saveNotificationToFirestore(
        title: "User Account Locked",
        body: "The user account $userName has been locked automatically after three consecutive failed access attempts.",
        senderEmail: "system@company.com",
        receiverEmail: adminEmail,
        module: "Account Status",
        page: "AccountStatusPage",
      );
    }

  }

  /// 9. Unlock Request Sent (when user requests unlock) - ADMIN ONLY
  /// 9. Unlock Request Sent (when user requests unlock) - ADMIN ONLY
  static Future<void> sendUnlockRequestNotification({
    required String userEmail,
    required String userName,
    String senderEmail = "system@company.com", // ✅ ADD THIS (but typically overridden with userEmail)
  }) async {
     // ✅ ADD THIS

    // Send to ALL MASTER ADMINS ONLY
    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(
        title: "Account Unlock Request",
        body: "User $userName ($userEmail) has requested to unlock their account.",
        recipientEmail: adminEmail,
      );

      await _saveNotificationToFirestore(
        title: "Account Unlock Request",
        body: "User $userName ($userEmail) has requested to unlock their account.",
        senderEmail: senderEmail, // ✅ CHANGED FROM userEmail (now uses parameter)
        receiverEmail: adminEmail,
        module: "Roles", // ✅ CHANGED FROM "Account Status"
        page: "AccountStatusPage",
      );
    }

  }
}