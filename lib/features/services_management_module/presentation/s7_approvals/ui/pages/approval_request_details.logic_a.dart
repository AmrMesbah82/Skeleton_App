part of 'approval_request_details.dart';

// Auto-extracted to keep files under 600 lines.
extension _ApprovalLogicA on _ApprovalDetailsScreenState {
  String getStatusIcon(String stateLabel) {
    if (stateLabel.toLowerCase().contains('approved') ||
        stateLabel.contains('موافقة')) {
      return 'assets/state/approved.svg';
    } else if (stateLabel.toLowerCase().contains('rejected') ||
        stateLabel.contains('مرفوض')) {
      return 'assets/state/rejected.svg';
    } else {
      return '';
    }
  }

  String _getLabel(String state) {
    switch (state.toLowerCase()) {
      case 'done':
        return 'Done';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'cancel':
        return 'Canceled';
      case 'pending':
        return 'Pending';
      case 'inprogress':
        return 'Inprogress';
      case 'breached sla':
        return 'Breached SLA';
      default:
        return FormatHelper.capitalize(state);
    }
  }

  Color _getBorderColor(String state) {
    switch (state.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF814A);
      case 'done':
        return Color(0xFF4BB609);
      case 'approved':
        return const Color(0xFF4BB609);
      case 'rejected':
        return AppColors.darkRed!;
      case 'cancel':
        return const Color(0xFFDF0C0C);
      case 'inprogress':
        return const Color(0xFFFFCC00);
      case 'breached sla':
        return const Color(0xFFB00020);
      default:
        return AppColors.lightGrey!;
    }
  }

  String _getIconAsset(String state) {
    switch (state.toLowerCase()) {
      case 'approved':
        return 'assets/state/approved.svg';
      case 'done':
        return 'assets/state/approved.svg';
      case 'rejected':
        return 'assets/state/reject.svg';
      case 'cancel':
        return 'assets/state/cansel.svg';
      case 'pending':
        return 'assets/state/pending.svg';
      case 'inprogress':
        return 'assets/state/inprogress_icon.svg';
      case 'breached sla':
        return 'assets/state/breached SLA.svg';
      default:
        return 'assets/state/pending.svg';
    }
  }

  String getOverallStatus() {
    final approvalCycle = widget.approvalModel.currentApprovalCycle;
    final docState = currentState?.toLowerCase();

    if (docState == 'cancel') {
      return 'cancel';
    }

    if (docState == 'inprogress' ||
        docState == 'breached sla' ||
        docState == 'done') {
      return docState!;
    }

    for (final approver in approvalCycle) {
      final state = approver.state?.toLowerCase();
      if (state == 'rejected' || state == 'cancel') return state!;
    }

    for (final approver in approvalCycle) {
      if (approver.state?.toLowerCase() == 'pending') return 'pending';
    }

    if (approvalCycle.isNotEmpty &&
        approvalCycle.every((e) => e.state?.toLowerCase() == 'approved')) {
      return 'approved';
    }

    return 'pending';
  }

  Future<void> fetchAndPrintStates() async {
    try {
      final docId = widget.approvalModel.currentId;
      final serviceName = widget.approvalModel.currentServiceNameEnglish;

      if (docId == null || docId.isEmpty) {
        return;
      }

      final requestDoc = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .doc(docId)
          .get();

      if (!requestDoc.exists) {
        return;
      }

      var querySnapshot = await requestDoc.reference
          .collection("RequestedServices")
          .where('serviceName', isEqualTo: serviceName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        saveIdUser = querySnapshot.docs.first.data()['id'];
      }
    } catch (e) {
    }
  }

  List<EmployeeEntityModell> _adjustCycleStates(List<EmployeeEntityModell> list) {
    final adjusted = List<EmployeeEntityModell>.from(list);
    bool foundPending = false;

    for (int i = 0; i < adjusted.length; i++) {
      final originalState = adjusted[i].state?.toLowerCase();

      if (originalState == 'approved' ||
          originalState == 'rejected' ||
          originalState == 'cancel') {
        continue;
      }

      if (!foundPending) {
        adjusted[i] = adjusted[i].copyWith(state: 'pending');
        foundPending = true;
      } else {
        adjusted[i] = adjusted[i].copyWith(state: 'normal');
      }
    }

    return adjusted;
  }

  Color getArrowColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF814A);
      case 'approved':
        return const Color(0xFF4BB609);
      case 'rejected':
        return const Color(0xFFDF0C0C);
      case 'inprogress':
        return const Color(0xFFFFCC00);
      default:
        return AppColors.text;
    }
  }

  Future<void> _initFunctions() async {
    await this.fetchAndPrintStates();
  }

  Future<void> cancelCommentFunction() async {
    try {
      final docId = widget.approvalModel.currentId;

      if (docId == null || docId.isEmpty) {
        return;
      }

      final cancelSnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .doc(docId)
          .get();

      if (!cancelSnapshot.exists) {
        return;
      }

      final data = cancelSnapshot.data();
      if (data != null) {
        cancelReason = data["canselComment"] ?? '';
        setState(() {});
      }
    } catch (e) {
      cancelReason = '';
    }
  }

  Future<void> _refreshModelFromFirestore() async {
    try {
      final docId = _currentModel.currentId;
      if (docId == null || docId.isEmpty) return;

      final snapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .doc(docId)
          .get();

      if (snapshot.exists && mounted) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _currentModel = ServicesHistoryModel.fromJson(data, docId);
        });
      }
    } catch (e) {
    }
  }

  Future<void> _loadServiceDataFromCreateServices() async {
    try {

      final parentServiceId = widget.approvalModel.currentParentServiceId.isNotEmpty
          ? widget.approvalModel.currentParentServiceId
          : widget.approvalModel.currentId;

      final requesterEmail = widget.approvalModel.currentEmailRequester ?? '';

      final serviceData = await CreateServicesHelper.getServiceDetailsFromCreateServices(
        parentServiceId: parentServiceId,
        emailRequester: requesterEmail,
      );

      setState(() {
        // ✅ FIXED: Use camelCase keys instead of underscore keys
        serviceNameEnglish = serviceData['serviceNameEnglish'];
        serviceNameArabic = serviceData['serviceNameArabic'];
        serviceDescriptionEnglish = serviceData['serviceDescriptionEnglish'];
        serviceDescriptionArabic = serviceData['serviceDescriptionArabic'];
        serviceDuration = serviceData['duration'];
        serviceDurationUnit = serviceData['unit'];
        owningDepartment = serviceData['owningDepartment'];
      });

    } catch (e) {
    }
  }

  Future<void> fetchLatestStateFromFirestore() async {
    try {
      final docId = widget.approvalModel.currentId;

      if (docId == null || docId.isEmpty) {
        return;
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .doc(docId)
          .get();

      if (!docSnapshot.exists) {
        return;
      }

      final data = docSnapshot.data();
      if (data != null) {
        currentState = data['state']?.toString().toLowerCase();
      }
    } catch (e) {
    }
  }

  Future<void> loadRequesterData() async {
    final prefs = await SharedPreferences.getInstance();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    setState(() {
      globalEmailRequester = prefs.getString("emailRequester") ?? '';
      globalGenderRequester = prefs.getString("genderRequester") ?? '';
      globalPhoneRequester = prefs.getString("phoneRequester") ?? '';
      globalDepartmentRequester = prefs.getString("departmentRequester") ?? '';

      globalFirstNameRequester = isArabic
          ? prefs.getString("firstNameRequesterArabic") ?? ''
          : prefs.getString("firstNameRequester") ?? '';

      globalLastNameRequester = isArabic
          ? prefs.getString("lastNameRequesterArabic") ?? ''
          : prefs.getString("lastNameRequester") ?? '';

      globalJobTitleRequester = isArabic
          ? prefs.getString("jobTitleRequesterArabic") ?? ''
          : prefs.getString("jobTitleRequester") ?? '';
    });
  }

  Future<void> fetchRequesterInfoFromFirestore() async {
    try {
      final docId = widget.approvalModel.currentId;

      if (docId == null || docId.isEmpty) {
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .doc(docId)
          .get();

      if (!snapshot.exists) {
        return;
      }

      final data = snapshot.data();
      if (data == null) return;

      String _extractString(dynamic value) {
        if (value == null) return '';
        if (value is String) return value;
        if (value is List && value.isNotEmpty) {
          return value[0]?.toString() ?? '';
        }
        return value.toString();
      }

      setState(() {
        requesterFirstNameEn = _extractString(data['firstNameRequester']);
        requesterLastNameEn = _extractString(data['lastNameRequester']);
        requesterJobTitleEn = _extractString(data['jobTitleRequester']);
        requesterDepartment = _extractString(data['departmentRequester']);

        requesterFirstNameAr = _extractString(data['firstNameRequesterArabic']);
        requesterLastNameAr = _extractString(data['lastNameRequesterArabic']);
        requesterJobTitleAr = _extractString(data['jobTitleRequesterArabic']);
      });
    } catch (e) {
    }
  }

  Future<void> _initialize() async {
    try {
      rejectCommentText = await this.checkRejectComment();
      approveCommentText = await this.checkApproveComment();

      await this.cancelCommentFunction();

      final docId = widget.approvalModel.currentId;

      if (docId == null || docId.isEmpty) {
        setState(() {
          isLoadingCommentReson = false;
        });
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection(getBaseUrl(FirestoreCollections.requestServices))
          .doc(docId)
          .get();

      if (!snapshot.exists) {
        setState(() {
          isLoadingCommentReson = false;
        });
        return;
      }

      final data = snapshot.data();
      if (data != null) {
        var stateValue = data["state"];

        if (stateValue is List && stateValue.isNotEmpty) {
          currentState = stateValue[0]?.toString().toLowerCase();
        } else if (stateValue is String) {
          currentState = stateValue.toLowerCase();
        } else {
          currentState = stateValue?.toString().toLowerCase();
        }

      }

      await _initFunctions();

      setState(() {
        isLoadingCommentReson = false;
      });
    } catch (e, st) {
      setState(() {
        isLoadingCommentReson = false;
      });
    }
  }
}
