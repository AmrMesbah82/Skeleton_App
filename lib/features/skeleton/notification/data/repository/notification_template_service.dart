import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_modle.dart';

class NotificationTemplateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'notification_templates';

  // ✅ Get template by module and event type (NO notificationType parameter needed now)
  Future<NotificationTemplateModel?> getTemplate({
    required String module,
    required String eventType,
  }) async {
    try {
      final templateId = '${module}_$eventType';
      print('📥 Fetching template: $templateId');

      final doc = await _firestore
          .collection(_collectionPath)
          .doc(templateId)
          .get();

      if (doc.exists) {
        final template = NotificationTemplateModel.fromFirestore(doc);
        print('✅ Template found: ${template.subjectEnglish}');
        print('✅ Selected types: ${template.selectedNotificationTypes}');
        return template;
      } else {
        print('⚠️ Template not found: $templateId');
        // Return default template if not found
        return _getDefaultTemplate(module: module, eventType: eventType);
      }
    } catch (e) {
      print('❌ Error fetching template: $e');
      return null;
    }
  }

  // Get all templates for a module
  Future<List<NotificationTemplateModel>> getTemplatesByModule(String module) async {
    try {
      print('📥 Fetching templates for module: $module');

      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('module', isEqualTo: module)
          .get();

      final templates = querySnapshot.docs
          .map((doc) => NotificationTemplateModel.fromFirestore(doc))
          .toList();

      print('✅ Found ${templates.length} templates for $module');
      return templates;
    } catch (e) {
      print('❌ Error fetching templates: $e');
      return [];
    }
  }

  // ✅ Save or update template with selected notification types
  Future<bool> saveTemplate(NotificationTemplateModel template) async {
    try {
      print('💾 Saving template: ${template.id}');
      print('💾 Selected types: ${template.selectedNotificationTypes}');

      final updatedTemplate = template.copyWith(
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(_collectionPath)
          .doc(template.id)
          .set(updatedTemplate.toFirestore(), SetOptions(merge: true));

      print('✅ Template saved successfully');
      return true;
    } catch (e) {
      print('❌ Error saving template: $e');
      return false;
    }
  }

  // ✅ Update only selected notification types
  Future<bool> updateSelectedNotificationTypes({
    required String module,
    required String eventType,
    required List<String> selectedTypes,
  }) async {
    try {
      final templateId = '${module}_$eventType';
      print('🔄 Updating notification types for: $templateId');
      print('🔄 New types: $selectedTypes');

      await _firestore
          .collection(_collectionPath)
          .doc(templateId)
          .set({
        'selectedNotificationTypes': selectedTypes,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      }, SetOptions(merge: true));

      print('✅ Notification types updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating notification types: $e');
      return false;
    }
  }

  // Delete template
  Future<bool> deleteTemplate(String templateId) async {
    try {
      print('🗑️ Deleting template: $templateId');

      await _firestore
          .collection(_collectionPath)
          .doc(templateId)
          .delete();

      print('✅ Template deleted successfully');
      return true;
    } catch (e) {
      print('❌ Error deleting template: $e');
      return false;
    }
  }

  // ✅ Reset to default template
  Future<bool> resetToDefault({
    required String module,
    required String eventType,
  }) async {
    try {
      final defaultTemplate = _getDefaultTemplate(
        module: module,
        eventType: eventType,
      );

      if (defaultTemplate != null) {
        return await saveTemplate(defaultTemplate);
      }
      return false;
    } catch (e) {
      print('❌ Error resetting template: $e');
      return false;
    }
  }

  // ✅ Get default template based on module and event
  NotificationTemplateModel? _getDefaultTemplate({
    required String module,
    required String eventType,
  }) {
    // Default: Email and Push enabled for most notifications
    final defaultTypes = ['email', 'push'];

    // Services module defaults
    if (module == 'services') {
      switch (eventType) {
        case 'request_submitted':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Service Request Submitted',
            subjectArabic: 'تم إرسال طلب الخدمة',
            bodyEnglish: "Your service request '{{serviceName}}' has been submitted successfully and is now under review. You will be notified of updates.",
            bodyArabic: "تم إرسال طلب الخدمة '{{serviceName}}' بنجاح، وهو قيد المراجعة حالياً. سيتم إشعارك بالتحديثات.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'request_approved':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Service Request Approved',
            subjectArabic: 'تمت الموافقة على طلب الخدمة',
            bodyEnglish: "Your service request '{{serviceName}}' has been approved by {{approverName}}. The service provider will contact you soon.",
            bodyArabic: "تمت الموافقة على طلب الخدمة '{{serviceName}}' من قبل {{approverName}}. سيتصل بك مزود الخدمة قريباً.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'request_rejected':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: false,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Service Request Rejected',
            subjectArabic: 'تم رفض طلب الخدمة',
            bodyEnglish: "Your service request '{{serviceName}}' has been rejected by {{approverName}}. Reason: {{rejectionReason}}",
            bodyArabic: "تم رفض طلب الخدمة '{{serviceName}}' من قبل {{approverName}}. السبب: {{rejectionReason}}",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'request_cancelled':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: false,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Service Request Cancelled',
            subjectArabic: 'تم إلغاء طلب الخدمة',
            bodyEnglish: "Service request '{{serviceName}}' has been cancelled by {{cancelledBy}}.",
            bodyArabic: "تم إلغاء طلب الخدمة '{{serviceName}}' من قبل {{cancelledBy}}.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'request_in_progress':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Service Request In Progress',
            subjectArabic: 'طلب الخدمة قيد التنفيذ',
            bodyEnglish: "Your service request '{{serviceName}}' is now in progress. The service provider is working on it.",
            bodyArabic: "طلب الخدمة '{{serviceName}}' الخاص بك قيد التنفيذ حالياً. مزود الخدمة يعمل عليه.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'request_done':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Service Request Completed',
            subjectArabic: 'تم إنجاز طلب الخدمة',
            bodyEnglish: "Your service request '{{serviceName}}' has been completed successfully. Please review and provide feedback.",
            bodyArabic: "تم إنجاز طلب الخدمة '{{serviceName}}' بنجاح. يرجى المراجعة وتقديم الملاحظات.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'request_sla_exceed':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: false,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Service Request SLA Exceeded',
            subjectArabic: 'تجاوز طلب الخدمة الوقت المحدد',
            bodyEnglish: "Service request '{{serviceName}}' has exceeded the SLA time limit. Please follow up urgently.",
            bodyArabic: "طلب الخدمة '{{serviceName}}' تجاوز الوقت المحدد للإنجاز. يرجى المتابعة بشكل عاجل.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'needs_approval':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'New Service Request Requires Your Approval',
            subjectArabic: 'طلب خدمة جديد يحتاج إلى موافقتك',
            bodyEnglish: "A new service request '{{serviceName}}' from {{requesterName}} requires your approval. Please review and take action.",
            bodyArabic: "طلب خدمة جديد '{{serviceName}}' من {{requesterName}} يحتاج إلى موافقتك. يرجى مراجعة الطلب واتخاذ الإجراء المناسب.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        default:
          return null;
      }
    }

    // Qiyas module defaults
    // Qiyas module defaults
    if (module == 'qiyas') {
      switch (eventType) {
        case 'perspectives_axes_created':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Perspectives and Axes Successfully Created',
            subjectArabic: 'تم إنشاء المناظير والمحاور بنجاح',
            bodyEnglish: "The perspectives and axes for {FrameworkName} have been successfully created by {EmployeeName} and are now available for evidence assignment and champion configuration. Please review the new structure before proceeding.",
            bodyArabic: "تم إنشاء المناظير والمحاور لـ {FrameworkName} بنجاح بواسطة {EmployeeName} وأصبحت متاحة لتعيين الأدلة وتهيئة السفراء. يرجى مراجعة الهيكل الجديد قبل المتابعة.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'champion_assigned_to_evidence':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Digital Transformation Champion Assigned',
            subjectArabic: 'تم تعيين سفير التحول الرقمي',
            bodyEnglish: "A Digital Transformation Champion has been assigned to {DocumentName}. The champion is now responsible for coordinating evidence submission and fulfilling all required actions associated with this document within the designated timeframe.",
            bodyArabic: "تم تعيين سفير التحول الرقمي للمستند {DocumentName}. يتولى السفير الآن مسؤولية تنسيق تقديم الأدلة وإنجاز جميع الإجراءات المطلوبة المرتبطة بهذا المستند في غضون الإطار الزمني المحدد.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'evidence_submitted_for_review':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Evidence Submitted for Supervisor Review',
            subjectArabic: 'تم إرسال الدليل للمراجعة',
            bodyEnglish: "{DocumentName} has been successfully submitted by the assigned Digital Transformation Champion and is currently pending formal review by the designated supervisor. An automated reminder will be issued if no action is taken within the required timeframe.",
            bodyArabic: "تم تقديم المستند {DocumentName} بنجاح من قبل سفير التحول الرقمي المعيّن وهو حالياً قيد المراجعة الرسمية من قبل المشرف المختص. سيتم إرسال تذكير تلقائي في حال عدم اتخاذ أي إجراء خلال المدة المحددة.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'evidence_status_approved':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Evidence Status Updated to Approved',
            subjectArabic: 'تحديث حالة الدليل إلى معتمد',
            bodyEnglish: "The approval status of {DocumentName} has been formally updated to Approved. No further action is required.",
            bodyArabic: "تم تحديث حالة الموافقة على المستند {DocumentName} رسمياً إلى معتمد. يستوفي الدليل الآن جميع المعايير المطلوبة ويُعد صالحاً للفترة الزمنية للقياس المرتبطة. لا يستلزم اتخاذ أي إجراء إضافي.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'evidence_status_rejected':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Evidence Status Updated to Rejected',
            subjectArabic: 'تحديث حالة الدليل إلى مرفوض',
            bodyEnglish: "The approval status of {DocumentName} has been formally updated to Rejected. Please review the feedback provided by the supervisor, address all identified issues, and resubmit a revised version for reconsideration at your earliest convenience.",
            bodyArabic: "تم تحديث حالة الموافقة على المستند {DocumentName} رسمياً إلى مرفوض. يرجى مراجعة الملاحظات المقدمة من المشرف ومعالجة جميع المشكلات المحددة وإعادة تقديم نسخة معدلة لإعادة النظر فيها في أقرب وقت ممكن.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'evidence_overdue':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Evidence Submission Overdue — Immediate Action Required',
            subjectArabic: 'تجاوز موعد تقديم الدليل — مطلوب إجراء فوري!',
            bodyEnglish: "{DocumentName} has exceeded its designated submission deadline and is now recorded as overdue in the system. Please take immediate action to avoid further escalation and any potential impact on your organisation's measurement score.",
            bodyArabic: "تجاوز المستند {DocumentName} الموعد النهائي للتقديم المحدد وتم تسجيله في النظام كمتأخر. يرجى اتخاذ إجراء فوري لتجنب مزيد من التصعيد وأي تأثير محتمل على درجة القياس لمنظمتكم.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'champion_reassigned':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Digital Transformation Champion Reassigned',
            subjectArabic: 'تمت إعادة تعيين سفير التحول الرقمي',
            bodyEnglish: "The Digital Transformation Champion for {DocumentName} has been formally reassigned. The newly assigned champion will assume full responsibility for evidence coordination effective immediately. Previous assignment records have been updated accordingly.",
            bodyArabic: "تمت إعادة تعيين سفير التحول الرقمي للمستند {DocumentName} رسمياً. سيتولى السفير المعيّن حديثاً المسؤولية الكاملة عن تنسيق الأدلة بشكل فوري. تم تحديث سجلات التعيين السابقة وفقاً لذلك.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        default:
          return null;
      }
    }

    // Inventory module defaults
    if (module == 'inventory') {
      switch (eventType) {
        case 'low_stock_alert':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Low Stock Alert',
            subjectArabic: 'تنبيه نقص المخزون',
            bodyEnglish: "Item '{{itemName}}' is running low in stock. Current quantity: {{quantity}}",
            bodyArabic: "العنصر '{{itemName}}' على وشك النفاد من المخزون. الكمية الحالية: {{quantity}}",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'item_added':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: false,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'New Item Added',
            subjectArabic: 'تم إضافة عنصر جديد',
            bodyEnglish: "New item '{{itemName}}' has been added to inventory.",
            bodyArabic: "تم إضافة عنصر جديد '{{itemName}}' إلى المخزون.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        default:
          return null;
      }
    }

    // Knowledge Hub module defaults
    if (module == 'knowledge_hub') {
      switch (eventType) {
        case 'new_article':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'New Article Published',
            subjectArabic: 'تم نشر مقال جديد',
            bodyEnglish: "A new article '{{articleTitle}}' has been published by {{authorName}}.",
            bodyArabic: "تم نشر مقال جديد '{{articleTitle}}' من قبل {{authorName}}.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'article_updated':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Article Updated',
            subjectArabic: 'تم تحديث المقال',
            bodyEnglish: "Article '{{articleTitle}}' has been updated.",
            bodyArabic: "تم تحديث المقال '{{articleTitle}}'.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        default:
          return null;
      }
    }

    // Todo module defaults
    if (module == 'todo') {
      switch (eventType) {
        case 'task_assigned':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'New Task Assigned',
            subjectArabic: 'تم تعيين مهمة جديدة',
            bodyEnglish: "A new task '{{taskName}}' has been assigned to you by {{assignerName}}.",
            bodyArabic: "تم تعيين مهمة جديدة '{{taskName}}' لك من قبل {{assignerName}}.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'task_completed':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Task Completed',
            subjectArabic: 'تم إنجاز المهمة',
            bodyEnglish: "Task '{{taskName}}' has been completed by {{completedBy}}.",
            bodyArabic: "تم إنجاز المهمة '{{taskName}}' من قبل {{completedBy}}.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        default:
          return null;
      }
    }

    // Role Management module defaults
    if (module == 'role_management') {
      switch (eventType) {

        // ── Section 1.4: User Account Access ──────────────────────────

        case 'account_activated':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Account Successfully Activated',
            subjectArabic: 'تم تفعيل حسابك بنجاح',
            bodyEnglish: "Your account has been activated and you now have full access to the system. Please log in using your registered credentials.",
            bodyArabic: "تم تفعيل حسابك وأصبح بإمكانك الوصول الكامل إلى النظام. يرجى تسجيل الدخول باستخدام بيانات الاعتماد المسجلة لديك.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'account_activated_admin':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'User Account Activation Confirmed',
            subjectArabic: 'تأكيد تفعيل حساب المستخدم',
            bodyEnglish: "The system account for {UserName} has been successfully activated. The user may now access the system using their registered credentials.",
            bodyArabic: "تم تفعيل حساب المستخدم {UserName} بنجاح في النظام. يمكن للمستخدم الآن تسجيل الدخول باستخدام بيانات اعتماده المسجلة.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'account_deactivated_admin':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'User Account Deactivation Confirmed',
            subjectArabic: 'تأكيد تعطيل حساب المستخدم',
            bodyEnglish: "The system account for {UserName} has been successfully deactivated. The user's access to all system resources has been suspended with immediate effect.",
            bodyArabic: "تم تعطيل حساب المستخدم {UserName} بنجاح في النظام. تم تعليق وصول المستخدم إلى جميع موارد النظام بشكل فوري.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'activation_scheduled':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Account Activation Scheduled',
            subjectArabic: 'تمت جدولة تفعيل الحساب',
            bodyEnglish: "Your account activation has been scheduled and will take effect on {ScheduledDate}. You will receive a confirmation notification once access has been granted.",
            bodyArabic: "تمت جدولة تفعيل حسابك وسيكون سارياً اعتباراً من {ScheduledDate}. ستتلقى إشعار تأكيد فور منح صلاحية الوصول.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'activation_scheduled_admin':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Account Activation Successfully Scheduled',
            subjectArabic: 'تمت جدولة تفعيل حساب المستخدم بنجاح',
            bodyEnglish: "The account activation for {UserName} has been scheduled successfully and will be executed on the designated date.",
            bodyArabic: "تمت جدولة تفعيل حساب المستخدم {UserName} بنجاح وسيتم تنفيذها في التاريخ المحدد.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'deactivation_scheduled':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Account Deactivation Scheduled',
            subjectArabic: 'تمت جدولة تعطيل الحساب',
            bodyEnglish: "Your account is scheduled for deactivation on {ScheduledDate}. Following this date, access to the system will no longer be available. Please contact your administrator if you have any concerns.",
            bodyArabic: "تمت جدولة تعطيل حسابك اعتباراً من {ScheduledDate}. بعد هذا التاريخ لن يكون بإمكانك الوصول إلى النظام. يرجى التواصل مع مسؤول النظام في حال وجود أي استفسار.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'deactivation_scheduled_admin':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Account Deactivation Successfully Scheduled',
            subjectArabic: 'تمت جدولة تعطيل حساب المستخدم بنجاح',
            bodyEnglish: "The account deactivation for {UserName} has been scheduled successfully and will be executed on the designated date.",
            bodyArabic: "تمت جدولة تعطيل حساب المستخدم {UserName} بنجاح وسيتم تنفيذها في التاريخ المحدد.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'access_schedule_updated':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Account Access Schedule Updated',
            subjectArabic: 'تم تحديث جدول صلاحيات الوصول',
            bodyEnglish: "The access schedule associated with your account has been revised. Your access rights will be adjusted effective {ScheduledDate}. Please review your updated access permissions.",
            bodyArabic: "تم تعديل جدول الوصول المرتبط بحسابك. ستُعدَّل صلاحيات وصولك اعتباراً من {ScheduledDate}. يرجى مراجعة صلاحياتك المحدّثة.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'scheduled_action_cancelled':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Scheduled Access Change Cancelled',
            subjectArabic: 'تم إلغاء تغيير الوصول المجدول',
            bodyEnglish: "The scheduled access change for your account has been cancelled. Your current access rights remain unchanged unless modified by your system administrator.",
            bodyArabic: "تم إلغاء التغيير المجدول على صلاحيات الوصول لحسابك. تظل صلاحيات وصولك الحالية دون تغيير ما لم يُعدّلها مسؤول النظام.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'account_unlocked':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Account Unlocked — Access Restored',
            subjectArabic: 'تم فتح الحساب — تم استعادة الوصول',
            bodyEnglish: "Your account has been unlocked and full system access has been restored. You may log in immediately using your registered credentials.",
            bodyArabic: "تم فتح حسابك واستعادة وصولك الكامل إلى النظام. يمكنك تسجيل الدخول فوراً باستخدام بيانات اعتمادك المسجلة.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'account_unlocked_admin':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'User Account Unlocked Successfully',
            subjectArabic: 'تم فتح حساب المستخدم بنجاح',
            bodyEnglish: "The system account for {UserName} has been successfully unlocked. The user may now resume normal system access.",
            bodyArabic: "تم فتح حساب المستخدم {UserName} بنجاح. يمكن للمستخدم الآن استئناف وصوله الاعتيادي إلى النظام.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'account_locked_failed_attempts':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'User Account Locked — Security Alert',
            subjectArabic: 'تنبيه أمني — تم قفل حساب المستخدم',
            bodyEnglish: "The account for {UserName} has been automatically locked following three consecutive failed authentication attempts. Please contact your system administrator to initiate the unlock process.",
            bodyArabic: "تم قفل حساب المستخدم {UserName} تلقائياً إثر ثلاث محاولات مصادقة فاشلة متتالية. يرجى التواصل مع مسؤول النظام لاستئناف عملية فتح الحساب.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        // ── Section 1.5: User Management & Permissions ────────────────

        case 'access_granted':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'System Access Granted',
            subjectArabic: 'تم منح صلاحيات الوصول إلى النظام',
            bodyEnglish: "Access rights have been assigned to your account. You may now utilise the designated system features in accordance with your assigned role and permissions.",
            bodyArabic: "تم تعيين حقوق الوصول لحسابك. يمكنك الآن استخدام ميزات النظام المحددة وفقاً للدور والصلاحيات المخصصة لك.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'access_updated':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'System Access Permissions Updated',
            subjectArabic: 'تم تحديث صلاحيات الوصول إلى النظام',
            bodyEnglish: "Your system access permissions have been updated. Please log in to review your current access rights, as available features or restrictions may have changed.",
            bodyArabic: "تم تحديث صلاحيات وصولك إلى النظام. يرجى تسجيل الدخول لمراجعة حقوق الوصول الحالية، إذ قد تكون الميزات المتاحة أو القيود المفروضة قد تغيرت.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'access_revoked':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'System Access Revoked',
            subjectArabic: 'تم سحب صلاحيات الوصول إلى النظام',
            bodyEnglish: "Your system access rights have been formally revoked. You no longer have authorization to access the platform. If you believe this is in error, please contact your system administrator.",
            bodyArabic: "تم سحب حقوق وصولك إلى النظام رسمياً. لم يعد لديك تفويض للوصول إلى المنصة. إذا اعتقدت أن ذلك خطأ فيرجى التواصل مع مسؤول النظام.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'access_revoked_admin':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'User Access Revocation Confirmed',
            subjectArabic: 'تأكيد سحب صلاحيات الوصول للمستخدم',
            bodyEnglish: "System access for {UserName} has been formally revoked. The user no longer has authorisation to access any system resources.",
            bodyArabic: "تم سحب صلاحيات وصول المستخدم {UserName} إلى النظام رسمياً. لم يعد للمستخدم تفويض بالوصول إلى أي موارد النظام.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'access_change_scheduled':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'System Access Change Scheduled',
            subjectArabic: 'تمت جدولة تغيير صلاحيات النظام',
            bodyEnglish: "A modification to your system access rights has been scheduled and will take effect on {ScheduledDate}. Please review your permissions following this date.",
            bodyArabic: "تمت جدولة تعديل على صلاحيات وصولك إلى النظام وستسري اعتباراً من {ScheduledDate}. يرجى مراجعة صلاحياتك بعد هذا التاريخ.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'scheduled_access_applied':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Scheduled Access Change Applied',
            subjectArabic: 'تم تطبيق تغيير الوصول المجدول',
            bodyEnglish: "The pre-scheduled modification to your system access rights has been applied successfully. Please verify your current permissions to ensure they reflect the intended changes.",
            bodyArabic: "تم تطبيق التعديل المجدول مسبقاً على صلاحيات وصولك إلى النظام بنجاح. يرجى التحقق من صلاحياتك الحالية للتأكد من أنها تعكس التغييرات المقصودة.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'scheduled_access_applied_admin':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Scheduled Access Change Executed Successfully',
            subjectArabic: 'تم تنفيذ تغيير الوصول المجدول للمستخدم بنجاح',
            bodyEnglish: "The scheduled access modification for {UserName} has been executed successfully. The user's permissions have been updated as planned.",
            bodyArabic: "تم تنفيذ التعديل المجدول على صلاحيات المستخدم {UserName} بنجاح. تم تحديث أذونات المستخدم وفقاً للخطة المحددة.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        case 'scheduled_access_cancelled':
          return NotificationTemplateModel(
            id: '${module}_$eventType',
            module: module,
            eventType: eventType,
            isEnabled: true,
            selectedNotificationTypes: defaultTypes,
            subjectEnglish: 'Scheduled Access Change Cancelled',
            subjectArabic: 'تم إلغاء تغيير الوصول المجدول',
            bodyEnglish: "The previously scheduled modification to your system access rights has been cancelled. Your current permissions remain active and unchanged.",
            bodyArabic: "تم إلغاء التعديل المجدول مسبقاً على صلاحيات وصولك إلى النظام. تظل صلاحياتك الحالية نشطة ودون تغيير.",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

        default:
          return null;
      }
    }

    return null;
  }

  // Process template variables (replace placeholders)
  String processTemplate(String template, Map<String, String> variables) {
    String result = template;
    variables.forEach((key, value) {
      result = result.replaceAll('{{$key}}', value);
    });
    return result;
  }
}