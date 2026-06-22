/// ************************* FILE INFO ************************* ///
/// File Name: role_management_notification_service.dart
/// Purpose: Centralized notification service for Role Management module
///          Covers Section 1.4 (User Account Access) and
///          Section 1.5 (User Management & Permissions)
/// Module: Role Management
/// Bilingual: English & Arabic
/// Pattern: Matches account_status_notification_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/notification/data/models/notification_data_model.dart';

class RoleManagementNotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ═══════════════════════════════════════════════════════════
  // PRIVATE HELPERS
  // ═══════════════════════════════════════════════════════════

  /// Get all Master Admin emails from Firestore
  static Future<List<String>> _getMasterAdminEmails() async {
    try {

      QuerySnapshot employeesSnapshot = await _firestore
          .collection(getBaseUrl('Employees_Info'))
          .get();

      List<String> masterAdminEmails = [];

      for (var doc in employeesSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('Role') && data['Role'] is List) {
          List<dynamic> roleList = data['Role'];
          if (roleList.isNotEmpty) {
            String lastRole = roleList.last.toString().toLowerCase();
            if (lastRole == 'master admin') {
              if (data.containsKey('Email') && data['Email'] is List) {
                List<dynamic> emailList = data['Email'];
                if (emailList.isNotEmpty) {
                  masterAdminEmails.add(emailList.last.toString());
                }
              }
            }
          }
        }
      }

      return masterAdminEmails;
    } catch (e) {
      return [];
    }
  }

  /// Send push notification (FCM)
  static Future<void> _sendPushNotification({
    required String title,
    required String body,
    required String recipientEmail,
  }) async {
    try {
      // TODO: wire up your FCM/NotificationServiceApp here
    } catch (e) {
    }
  }

  /// Save notification to Firestore
  static Future<void> _saveNotificationToFirestore({
    required String title,
    required String body,
    required String senderEmail,
    required String receiverEmail,
    required String page,
  }) async {
    try {
      final notificationModel = NotificationModelSystem(
        title: title,
        body: body,
        nameOfModule: "Roles",
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

    } catch (e) {
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
  // SECTION 1.4 — USER ACCOUNT ACCESS
  // ═══════════════════════════════════════════════════════════

  /// 1.4.1 Account Activated
  /// Trigger: Account Activated — User & Admin
  static Future<void> sendAccountActivatedNotification({
    required String userEmail,
    required String userName,
    String senderEmail = "system@company.com",
  }) async {

    // To USER
    const userTitle = "Account Successfully Activated";
    const userBody =
        "Your account has been activated and you now have full access to the system. "
        "Please log in using your registered credentials.";

    await _sendPushNotification(title: userTitle, body: userBody, recipientEmail: userEmail);
    await _saveNotificationToFirestore(
      title: userTitle,
      body: userBody,
      senderEmail: senderEmail,
      receiverEmail: userEmail,
      page: "RoleManagementPage",
    );

    // To ADMINS
    const adminTitle = "User Account Activation Confirmed";
    final adminBody =
        "The system account for $userName has been successfully activated. "
        "The user may now access the system using their registered credentials.";

    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(title: adminTitle, body: adminBody, recipientEmail: adminEmail);
      await _saveNotificationToFirestore(
        title: adminTitle,
        body: adminBody,
        senderEmail: senderEmail,
        receiverEmail: adminEmail,
        page: "RoleManagementPage",
      );
    }

  }

  /// 1.4.2 Account Deactivated — Admin notification
  /// Trigger: Account Deactivated — Admin
  static Future<void> sendAccountDeactivatedNotification({
    required String userEmail,
    required String userName,
    String senderEmail = "system@company.com",
  }) async {

    // To ADMINS only (doc shows admin trigger)
    const adminTitle = "User Account Deactivation Confirmed";
    final adminBody =
        "The system account for $userName has been successfully deactivated. "
        "The user's access to all system resources has been suspended with immediate effect.";

    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(title: adminTitle, body: adminBody, recipientEmail: adminEmail);
      await _saveNotificationToFirestore(
        title: adminTitle,
        body: adminBody,
        senderEmail: senderEmail,
        receiverEmail: adminEmail,
        page: "RoleManagementPage",
      );
    }

  }

  /// 1.4.3 Activation Scheduled
  /// Trigger: Activation Scheduled — User & Admin
  static Future<void> sendActivationScheduledNotification({
    required String userEmail,
    required String userName,
    required String scheduledDate,
    String senderEmail = "system@company.com",
  }) async {

    final formattedDate = _formatDate(scheduledDate);

    // To USER
    const userTitle = "Account Activation Scheduled";
    final userBody =
        "Your account activation has been scheduled and will take effect on $formattedDate. "
        "You will receive a confirmation notification once access has been granted.";

    await _sendPushNotification(title: userTitle, body: userBody, recipientEmail: userEmail);
    await _saveNotificationToFirestore(
      title: userTitle,
      body: userBody,
      senderEmail: senderEmail,
      receiverEmail: userEmail,
      page: "RoleManagementPage",
    );

    // To ADMINS
    const adminTitle = "Account Activation Successfully Scheduled";
    final adminBody =
        "The account activation for $userName has been scheduled successfully "
        "and will be executed on the designated date.";

    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(title: adminTitle, body: adminBody, recipientEmail: adminEmail);
      await _saveNotificationToFirestore(
        title: adminTitle,
        body: adminBody,
        senderEmail: senderEmail,
        receiverEmail: adminEmail,
        page: "RoleManagementPage",
      );
    }

  }

  /// 1.4.4 Deactivation Scheduled
  /// Trigger: Deactivation Scheduled — User & Admin
  static Future<void> sendDeactivationScheduledNotification({
    required String userEmail,
    required String userName,
    required String scheduledDate,
    String senderEmail = "system@company.com",
  }) async {

    final formattedDate = _formatDate(scheduledDate);

    // To USER
    const userTitle = "Account Deactivation Scheduled";
    final userBody =
        "Your account is scheduled for deactivation on $formattedDate. "
        "Following this date, access to the system will no longer be available. "
        "Please contact your administrator if you have any concerns.";

    await _sendPushNotification(title: userTitle, body: userBody, recipientEmail: userEmail);
    await _saveNotificationToFirestore(
      title: userTitle,
      body: userBody,
      senderEmail: senderEmail,
      receiverEmail: userEmail,
      page: "RoleManagementPage",
    );

    // To ADMINS
    const adminTitle = "Account Deactivation Successfully Scheduled";
    final adminBody =
        "The account deactivation for $userName has been scheduled successfully "
        "and will be executed on the designated date.";

    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(title: adminTitle, body: adminBody, recipientEmail: adminEmail);
      await _saveNotificationToFirestore(
        title: adminTitle,
        body: adminBody,
        senderEmail: senderEmail,
        receiverEmail: adminEmail,
        page: "RoleManagementPage",
      );
    }

  }

  /// 1.4.5 Access Schedule Updated
  /// Trigger: Access Schedule Updated — User
  static Future<void> sendAccessScheduleUpdatedNotification({
    required String userEmail,
    required String scheduledDate,
    String senderEmail = "system@company.com",
  }) async {

    final formattedDate = _formatDate(scheduledDate);

    const userTitle = "Account Access Schedule Updated";
    final userBody =
        "The access schedule associated with your account has been revised. "
        "Your access rights will be adjusted effective $formattedDate. "
        "Please review your updated access permissions.";

    await _sendPushNotification(title: userTitle, body: userBody, recipientEmail: userEmail);
    await _saveNotificationToFirestore(
      title: userTitle,
      body: userBody,
      senderEmail: senderEmail,
      receiverEmail: userEmail,
      page: "RoleManagementPage",
    );

  }

  /// 1.4.6 Scheduled Action Cancelled
  /// Trigger: Scheduled Action Cancelled — User
  static Future<void> sendScheduledActionCancelledNotification({
    required String userEmail,
    String senderEmail = "system@company.com",
  }) async {

    const userTitle = "Scheduled Access Change Cancelled";
    const userBody =
        "The scheduled access change for your account has been cancelled. "
        "Your current access rights remain unchanged unless modified by your system administrator.";

    await _sendPushNotification(title: userTitle, body: userBody, recipientEmail: userEmail);
    await _saveNotificationToFirestore(
      title: userTitle,
      body: userBody,
      senderEmail: senderEmail,
      receiverEmail: userEmail,
      page: "RoleManagementPage",
    );

  }

  /// 1.4.7 Account Unlocked
  /// Trigger: Account Unlocked — User & Admin
  static Future<void> sendAccountUnlockedNotification({
    required String userEmail,
    required String userName,
    String senderEmail = "system@company.com",
  }) async {

    // To USER
    const userTitle = "Account Unlocked — Access Restored";
    const userBody =
        "Your account has been unlocked and full system access has been restored. "
        "You may log in immediately using your registered credentials.";

    await _sendPushNotification(title: userTitle, body: userBody, recipientEmail: userEmail);
    await _saveNotificationToFirestore(
      title: userTitle,
      body: userBody,
      senderEmail: senderEmail,
      receiverEmail: userEmail,
      page: "RoleManagementPage",
    );

    // To ADMINS
    const adminTitle = "User Account Unlocked Successfully";
    final adminBody =
        "The system account for $userName has been successfully unlocked. "
        "The user may now resume normal system access.";

    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(title: adminTitle, body: adminBody, recipientEmail: adminEmail);
      await _saveNotificationToFirestore(
        title: adminTitle,
        body: adminBody,
        senderEmail: senderEmail,
        receiverEmail: adminEmail,
        page: "RoleManagementPage",
      );
    }

  }

  /// 1.4.8 Account Locked — Failed Attempts (Admin only)
  /// Trigger: Account Locked — Failed Attempts
  static Future<void> sendAccountLockedFailedAttemptsNotification({
    required String userEmail,
    required String userName,
  }) async {

    const adminTitle = "User Account Locked — Security Alert";
    final adminBody =
        "The account for $userName has been automatically locked following three consecutive "
        "failed authentication attempts. Please contact your system administrator to initiate "
        "the unlock process.";

    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(title: adminTitle, body: adminBody, recipientEmail: adminEmail);
      await _saveNotificationToFirestore(
        title: adminTitle,
        body: adminBody,
        senderEmail: "system@company.com",
        receiverEmail: adminEmail,
        page: "RoleManagementPage",
      );
    }

  }

  // ═══════════════════════════════════════════════════════════
  // SECTION 1.5 — USER MANAGEMENT & PERMISSIONS
  // ═══════════════════════════════════════════════════════════

  /// 1.5.1 Access Granted
  /// Trigger: Access Granted — User
  static Future<void> sendAccessGrantedNotification({
    required String userEmail,
    String senderEmail = "system@company.com",
  }) async {

    const userTitle = "System Access Granted";
    const userBody =
        "Access rights have been assigned to your account. You may now utilise the designated "
        "system features in accordance with your assigned role and permissions.";

    await _sendPushNotification(title: userTitle, body: userBody, recipientEmail: userEmail);
    await _saveNotificationToFirestore(
      title: userTitle,
      body: userBody,
      senderEmail: senderEmail,
      receiverEmail: userEmail,
      page: "UserManagementPage",
    );

  }

  /// 1.5.2 Access Updated
  /// Trigger: Access Updated — User
  static Future<void> sendAccessUpdatedNotification({
    required String userEmail,
    String senderEmail = "system@company.com",
  }) async {

    const userTitle = "System Access Permissions Updated";
    const userBody =
        "Your system access permissions have been updated. Please log in to review your current "
        "access rights, as available features or restrictions may have changed.";

    await _sendPushNotification(title: userTitle, body: userBody, recipientEmail: userEmail);
    await _saveNotificationToFirestore(
      title: userTitle,
      body: userBody,
      senderEmail: senderEmail,
      receiverEmail: userEmail,
      page: "UserManagementPage",
    );

  }

  /// 1.5.3 Access Revoked
  /// Trigger: Access Revoked — User & Admin
  static Future<void> sendAccessRevokedNotification({
    required String userEmail,
    required String userName,
    String senderEmail = "system@company.com",
  }) async {

    // To USER
    const userTitle = "System Access Revoked";
    const userBody =
        "Your system access rights have been formally revoked. You no longer have authorization "
        "to access the platform. If you believe this is in error, please contact your system administrator.";

    await _sendPushNotification(title: userTitle, body: userBody, recipientEmail: userEmail);
    await _saveNotificationToFirestore(
      title: userTitle,
      body: userBody,
      senderEmail: senderEmail,
      receiverEmail: userEmail,
      page: "UserManagementPage",
    );

    // To ADMINS
    const adminTitle = "User Access Revocation Confirmed";
    final adminBody =
        "System access for $userName has been formally revoked. "
        "The user no longer has authorisation to access any system resources.";

    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(title: adminTitle, body: adminBody, recipientEmail: adminEmail);
      await _saveNotificationToFirestore(
        title: adminTitle,
        body: adminBody,
        senderEmail: senderEmail,
        receiverEmail: adminEmail,
        page: "UserManagementPage",
      );
    }

  }

  /// 1.5.4 Access Change Scheduled
  /// Trigger: Access Change Scheduled — User
  static Future<void> sendAccessChangeScheduledNotification({
    required String userEmail,
    required String scheduledDate,
    String senderEmail = "system@company.com",
  }) async {

    final formattedDate = _formatDate(scheduledDate);

    const userTitle = "System Access Change Scheduled";
    final userBody =
        "A modification to your system access rights has been scheduled and will take effect "
        "on $formattedDate. Please review your permissions following this date.";

    await _sendPushNotification(title: userTitle, body: userBody, recipientEmail: userEmail);
    await _saveNotificationToFirestore(
      title: userTitle,
      body: userBody,
      senderEmail: senderEmail,
      receiverEmail: userEmail,
      page: "UserManagementPage",
    );

  }

  /// 1.5.5 Scheduled Access Applied
  /// Trigger: Scheduled Access Applied — User & Admin
  static Future<void> sendScheduledAccessAppliedNotification({
    required String userEmail,
    required String userName,
    String senderEmail = "system@company.com",
  }) async {

    // To USER
    const userTitle = "Scheduled Access Change Applied";
    const userBody =
        "The pre-scheduled modification to your system access rights has been applied successfully. "
        "Please verify your current permissions to ensure they reflect the intended changes.";

    await _sendPushNotification(title: userTitle, body: userBody, recipientEmail: userEmail);
    await _saveNotificationToFirestore(
      title: userTitle,
      body: userBody,
      senderEmail: senderEmail,
      receiverEmail: userEmail,
      page: "UserManagementPage",
    );

    // To ADMINS
    const adminTitle = "Scheduled Access Change Executed Successfully";
    final adminBody =
        "The scheduled access modification for $userName has been executed successfully. "
        "The user's permissions have been updated as planned.";

    List<String> masterAdmins = await _getMasterAdminEmails();
    for (String adminEmail in masterAdmins) {
      await _sendPushNotification(title: adminTitle, body: adminBody, recipientEmail: adminEmail);
      await _saveNotificationToFirestore(
        title: adminTitle,
        body: adminBody,
        senderEmail: senderEmail,
        receiverEmail: adminEmail,
        page: "UserManagementPage",
      );
    }

  }

  /// 1.5.6 Scheduled Access Cancelled
  /// Trigger: Scheduled Access Cancelled — User
  static Future<void> sendScheduledAccessCancelledNotification({
    required String userEmail,
    String senderEmail = "system@company.com",
  }) async {

    const userTitle = "Scheduled Access Change Cancelled";
    const userBody =
        "The previously scheduled modification to your system access rights has been cancelled. "
        "Your current permissions remain active and unchanged.";

    await _sendPushNotification(title: userTitle, body: userBody, recipientEmail: userEmail);
    await _saveNotificationToFirestore(
      title: userTitle,
      body: userBody,
      senderEmail: senderEmail,
      receiverEmail: userEmail,
      page: "UserManagementPage",
    );

  }
}
