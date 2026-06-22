part of 'approval_request_details.dart';

// Auto-extracted to keep files under 600 lines.
extension _ApprovalLogicB on _ApprovalDetailsScreenState {
  String getLocalizedDepartment(BuildContext context, String? departmentId) {
    if (departmentId == null || departmentId.isEmpty) {
      return '-';
    }

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    String? result;

    if (isArabic) {
      result = departmentController.getArabicDepartmentNameFromDepartmentId(
          departmentId: departmentId);
    } else {
      result = departmentController.getEnglishDepartmentNameFromDepartmentId(
          departmentId: departmentId);
    }

    if (result == null || result.isEmpty) {
      return departmentId;
    }

    return result;
  }

  String getLocalizedDurationUnit(String? unit, bool isArabic, {num? quantity}) {
    if (unit == null || unit.isEmpty) return '';

    final lowerUnit = unit.toLowerCase().trim();
    final isSingular = (quantity == null) ? false : (quantity == 1);

    if (!isArabic) {
      final map = {
        'days': isSingular ? 'day' : 'days',
        'day': 'day',
        'weeks': isSingular ? 'week' : 'weeks',
        'week': 'week',
        'hours': isSingular ? 'hour' : 'hours',
        'hour': 'hour',
        'minutes': isSingular ? 'minute' : 'minutes',
        'minute': 'minute',
        'months': isSingular ? 'month' : 'months',
        'month': 'month',
        'years': isSingular ? 'year' : 'years',
        'year': 'year',
      };
      return map[lowerUnit] ?? unit;
    } else {
      final map = {
        'days': isSingular ? 'يوم' : 'أيام',
        'day': 'يوم',
        'weeks': isSingular ? 'أسبوع' : 'أسابيع',
        'week': 'أسبوع',
        'hours': isSingular ? 'ساعة' : 'ساعات',
        'hour': 'ساعة',
        'minutes': isSingular ? 'دقيقة' : 'دقائق',
        'minute': 'دقيقة',
        'months': isSingular ? 'شهر' : 'أشهر',
        'month': 'شهر',
        'years': isSingular ? 'سنة' : 'سنوات',
        'year': 'سنة',
      };
      return map[lowerUnit] ?? unit;
    }
  }

  bool isTabletLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return size.width >= 600 && isLandscape;
  }

  String getLocalizedStatus(String status) {
    final result = switch (status.toLowerCase()) {
      'done' => S.of(context).Done,
      'approved' => S.of(context).Approved,
      'pending' => S.of(context).Pending,
      'rejected' => S.of(context).Rejected,
      'cancel' => S.of(context).Canceled,
      'inprogress' => S.of(context).Inprogress,
      'branchsla' || 'breached sla' => S.of(context).BreachedSLA,
      _ => S.of(context).Pending,
    };
    return result;
  }

  String getFinalStateFromModel(ServicesHistoryModel service) {
    final stateField = (service.currentState ?? '').toString().toLowerCase();

    if (stateField == 'done') {
      return 'done';
    }

    if (stateField == 'cancel') {
      return 'cancel';
    }

    if (['inprogress', 'branchsla', 'breached sla'].contains(stateField)) {
      return stateField;
    }

    final approvalList = service.currentApprovalCycle;

    final states =
    approvalList.map((item) => item.state?.toLowerCase() ?? '').toList();

    final filtered =
    states.where((s) => s.isNotEmpty && s != 'normal').toList();
    if (filtered.contains('cancel')) return 'cancel';
    if (filtered.contains('rejected')) return 'rejected';
    if (filtered.isNotEmpty && filtered.every((s) => s == 'approved'))
      return 'approved';
    if (filtered.contains('pending')) return 'pending';

    if (stateField.isNotEmpty) {
      return stateField;
    }

    return 'N/A';
  }

  Future<bool> _getRequesterLanguagePreference(String requesterEmail) async {
    try {

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(requesterEmail.toLowerCase())
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        final languageCode = data?['languageCode'] ?? 'en';
        final isArabic = languageCode == 'ar';
        return isArabic;
      }
    } catch (e) {
    }

    return false;
  }

  Future<Map<String, String>> _getApproverName(String approverEmail) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(approverEmail.toLowerCase())
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        final firstNameEn = data?['firstName'] ?? '';
        final lastNameEn = data?['lastName'] ?? '';
        final firstNameAr = data?['firstNameInArabic'] ?? firstNameEn;
        final lastNameAr = data?['lastNameInArabic'] ?? lastNameEn;

        return {
          'en': '$firstNameEn $lastNameEn',
          'ar': '$firstNameAr $lastNameAr',
        };
      }
    } catch (e) {
    }

    return {'en': 'System', 'ar': 'النظام'};
  }

  Future<void> _sendNotificationToRequester({
    required String action,
    required String requesterEmail,
    required String serviceName,
  }) async {
    if (requesterEmail.isEmpty) {
      return;
    }

    try {
      final isArabic = await _getRequesterLanguagePreference(requesterEmail);
      final approverNames = await _getApproverName(employeeEntity.email ?? '');
      final approverName = isArabic ? approverNames['ar']! : approverNames['en']!;

      String notificationTitle;
      String notificationBody;

      if (action == 'approved') {
        final template = await _templateService.getTemplate(
          module: 'services',
          eventType: 'request_approved',
        );

        if (template == null || !template.isEnabled || !template.hasPush) {
          return;
        }

        notificationTitle = isArabic ? template.subjectArabic : template.subjectEnglish;
        notificationBody = isArabic ? template.bodyArabic : template.bodyEnglish;

        final variables = {
          'serviceName': serviceName,
          'approverName': approverName,
        };
        notificationTitle = _templateService.processTemplate(notificationTitle, variables);
        notificationBody = _templateService.processTemplate(notificationBody, variables);
      } else {
        final template = await _templateService.getTemplate(
          module: 'services',
          eventType: 'request_rejected',
        );

        if (template == null || !template.isEnabled || !template.hasPush) {
          return;
        }

        notificationTitle = isArabic ? template.subjectArabic : template.subjectEnglish;
        notificationBody = isArabic ? template.bodyArabic : template.bodyEnglish;

        final variables = {
          'serviceName': serviceName,
          'approverName': approverName,
          'rejectionReason': rejectController.text,
        };
        notificationTitle = _templateService.processTemplate(notificationTitle, variables);
        notificationBody = _templateService.processTemplate(notificationBody, variables);
      }

      final notificationModel = NotificationModelSystem(
        title: notificationTitle,
        body: notificationBody,
        nameOfModule: 'services',
        senderEmail: employeeEntity.email ?? '',
        receiverEmail: requesterEmail,
        nameOfPage: 'RequestServicesToggle',
        isPinned: false,
        isRead: false,
        isClean: false,
      );

      final notificationService = FirestoreNotificationService();
      await notificationService.uploadNotification(notificationModel);

      await NotificationServiceApp.sendNotification(
        notificationTitle,
        notificationBody,
        requesterEmail,
      );

    } catch (notificationError) {
    }
  }

  Future<String> checkRejectComment() async {
    try {
      final docId = widget.approvalModel.currentId;

      if (docId == null || docId.isEmpty) {
        return '';
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .doc(docId)
          .get();

      if (!docSnapshot.exists) {
        return '';
      }

      final data = docSnapshot.data();
      final comment = data?['rejectComment'];

      if (comment != null && comment.toString().isNotEmpty) {
        return comment.toString();
      }

      return '';
    } catch (e) {
      return '';
    }
  }

  Future<String> checkApproveComment() async {
    try {
      final docId = widget.approvalModel.currentId;

      if (docId == null || docId.isEmpty) {
        return '';
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .doc(docId)
          .get();

      if (!docSnapshot.exists) {
        return '';
      }

      final data = docSnapshot.data();
      final comment = data?['approveComment'];

      if (comment != null && comment.toString().isNotEmpty) {
        return comment.toString();
      }

      return '';
    } catch (e) {
      return '';
    }
  }
}
