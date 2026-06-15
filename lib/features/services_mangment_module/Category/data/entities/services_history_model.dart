import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'modelEmployee.dart';



class ServicesHistoryModel {
  // ✅ SHARED timestamps for ALL fields
  final List<int> timestamps;

  // Core fields - Direct lists!
  final List<String> id;
  final List<String> state;
  final List<String> status;
  final List<String> parent_Service_Id;

  // Requester information
  final List<String> first_Name_Requester;
  final List<String> last_Name_Requester;
  final List<String> department_Requester;
  final List<String> job_Title_Requester;
  final List<String> email_Requester;
  final List<String> phone_Requester;
  final List<String> gender_Requester;
  final List<String> assigned_Provider_Email;

  // Arabic fields
  final List<String> first_Name_Requester_Arabic;
  final List<String> last_Name_Requester_Arabic;
  final List<String> job_Title_Requester_Arabic;
  final List<String> department_Requester_Arabic;

  // Service details
  final List<String> service_Name_English;
  final List<String> service_Name_Arabic;
  final List<String> service_Description_English;
  final List<String> service_Description_Arabic;
  final List<String> duration_Of_Services;
  final List<String> selected_Duration_Unit;
  final List<Timestamp> duration_Of_Services_Timestamp;
  final List<String> image_Url;

  // Provider services (stored as JSON string)
  final List<String> provider_Services;

  // Boolean fields
  final List<bool> limit_Availability;
  final List<bool> require_Approval;

  // Department selection (stored as JSON string)
  final List<String> select_Department;

  // Approval cycle (stored as JSON string)
  final List<String> approval_Cycle;

  // SLA fields
  final List<String> sla_One_Controller_English;
  final List<String> sla_Two_Controller_English;

  // Notification fields
  final List<bool> notify_Requester_Checked;
  final List<bool> notify_Provider_Checked;
  final List<bool> notify_Manager_Checked;
  final List<bool> notify_Requester_Switch0;
  final List<bool> notify_Manager_Switch1;

  ServicesHistoryModel({
    required this.timestamps,
    required this.id,
    required this.state,
    required this.status,
    required this.parent_Service_Id,
    required this.first_Name_Requester,
    required this.last_Name_Requester,
    required this.department_Requester,
    required this.job_Title_Requester,
    required this.email_Requester,
    required this.phone_Requester,
    required this.gender_Requester,
    required this.assigned_Provider_Email,
    required this.first_Name_Requester_Arabic,
    required this.last_Name_Requester_Arabic,
    required this.job_Title_Requester_Arabic,
    required this.department_Requester_Arabic,
    required this.service_Name_English,
    required this.service_Name_Arabic,
    required this.service_Description_English,
    required this.service_Description_Arabic,
    required this.duration_Of_Services,
    required this.selected_Duration_Unit,
    required this.duration_Of_Services_Timestamp,
    required this.image_Url,
    required this.provider_Services,
    required this.limit_Availability,
    required this.require_Approval,
    required this.select_Department,
    required this.approval_Cycle,
    required this.sla_One_Controller_English,
    required this.sla_Two_Controller_English,
    required this.notify_Requester_Checked,
    required this.notify_Provider_Checked,
    required this.notify_Manager_Checked,
    required this.notify_Requester_Switch0,
    required this.notify_Manager_Switch1,
  });

  // ✅ Helper getters for current (latest) values
  String get currentId => id.isNotEmpty ? id.last : '';
  String get currentState => state.isNotEmpty ? state.last : '';
  String get currentStatus => status.isNotEmpty ? status.last : '';
  String get currentParentServiceId => parent_Service_Id.isNotEmpty ? parent_Service_Id.last : '';
  String get currentFirstNameRequester => first_Name_Requester.isNotEmpty ? first_Name_Requester.last : '';
  String get currentLastNameRequester => last_Name_Requester.isNotEmpty ? last_Name_Requester.last : '';
  String get currentDepartmentRequester => department_Requester.isNotEmpty ? department_Requester.last : '';
  String get currentJobTitleRequester => job_Title_Requester.isNotEmpty ? job_Title_Requester.last : '';
  String get currentEmailRequester => email_Requester.isNotEmpty ? email_Requester.last : '';
  String get currentPhoneRequester => phone_Requester.isNotEmpty ? phone_Requester.last : '';
  String get currentGenderRequester => gender_Requester.isNotEmpty ? gender_Requester.last : '';
  String get currentAssignedProviderEmail => assigned_Provider_Email.isNotEmpty ? assigned_Provider_Email.last : '';
  String get currentFirstNameRequesterArabic => first_Name_Requester_Arabic.isNotEmpty ? first_Name_Requester_Arabic.last : '';
  String get currentLastNameRequesterArabic => last_Name_Requester_Arabic.isNotEmpty ? last_Name_Requester_Arabic.last : '';
  String get currentJobTitleRequesterArabic => job_Title_Requester_Arabic.isNotEmpty ? job_Title_Requester_Arabic.last : '';
  String get currentDepartmentRequesterArabic => department_Requester_Arabic.isNotEmpty ? department_Requester_Arabic.last : '';
  String get currentServiceNameEnglish => service_Name_English.isNotEmpty ? service_Name_English.last : '';
  String get currentServiceNameArabic => service_Name_Arabic.isNotEmpty ? service_Name_Arabic.last : '';
  String get currentServiceDescriptionEnglish => service_Description_English.isNotEmpty ? service_Description_English.last : '';
  String get currentServiceDescriptionArabic => service_Description_Arabic.isNotEmpty ? service_Description_Arabic.last : '';
  String get currentDurationOfServices => duration_Of_Services.isNotEmpty ? duration_Of_Services.last : '';
  String get currentSelectedDurationUnit => selected_Duration_Unit.isNotEmpty ? selected_Duration_Unit.last : '';
  Timestamp get currentDurationOfServicesTimestamp => duration_Of_Services_Timestamp.isNotEmpty ? duration_Of_Services_Timestamp.last : Timestamp.now();
  String get currentImageUrl => image_Url.isNotEmpty ? image_Url.last : '';
  bool get currentLimitAvailability => limit_Availability.isNotEmpty ? limit_Availability.last : false;
  bool get currentRequireApproval => require_Approval.isNotEmpty ? require_Approval.last : false;
  String get currentSlaOneControllerEnglish => sla_One_Controller_English.isNotEmpty ? sla_One_Controller_English.last : '';
  String get currentSlaTwoControllerEnglish => sla_Two_Controller_English.isNotEmpty ? sla_Two_Controller_English.last : '';
  bool get currentNotifyRequesterChecked => notify_Requester_Checked.isNotEmpty ? notify_Requester_Checked.last : false;
  bool get currentNotifyProviderChecked => notify_Provider_Checked.isNotEmpty ? notify_Provider_Checked.last : false;
  bool get currentNotifyManagerChecked => notify_Manager_Checked.isNotEmpty ? notify_Manager_Checked.last : false;
  bool get currentNotifyRequesterSwitch0 => notify_Requester_Switch0.isNotEmpty ? notify_Requester_Switch0.last : false;
  bool get currentNotifyManagerSwitch1 => notify_Manager_Switch1.isNotEmpty ? notify_Manager_Switch1.last : false;

  // ✅ Get timestamp at specific index
  int? getTimestampAt(int index) => index < timestamps.length ? timestamps[index] : null;

  // ✅ Get current (latest) timestamp
  int? get currentTimestamp => timestamps.isNotEmpty ? timestamps.last : null;

  // Factory: Create from JSON
  factory ServicesHistoryModel.fromJson(Map<String, dynamic> json, [String? docId]) {
    try {
      // ✅ Parse shared timestamps first
      final List<int> sharedTimestamps = (json['timestamps'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [DateTime.now().millisecondsSinceEpoch];

      return ServicesHistoryModel(
        timestamps: sharedTimestamps,
        id: _parseList<String>(docId ?? json['id'], (v) => v as String? ?? ''),
        state: _parseList<String>(json['state'], (v) => v as String? ?? ''),
        status: _parseList<String>(json['status'], (v) => v as String? ?? ''),
        parent_Service_Id: _parseList<String>(json['Parent_Service_Id'], (v) => v as String? ?? ''),
        first_Name_Requester: _parseList<String>(json['First_Name_Requester'], (v) => v as String? ?? ''),
        last_Name_Requester: _parseList<String>(json['Last_Name_Requester'], (v) => v as String? ?? ''),
        department_Requester: _parseList<String>(json['Department_Requester'], (v) => v as String? ?? ''),
        job_Title_Requester: _parseList<String>(json['Job_Title_Requester'], (v) => v as String? ?? ''),
        email_Requester: _parseList<String>(json['Email_Requester'], (v) => v as String? ?? ''),
        phone_Requester: _parseList<String>(json['Phone_Requester'], (v) => v as String? ?? ''),
        gender_Requester: _parseList<String>(json['Gender_Requester'], (v) => v as String? ?? ''),
        assigned_Provider_Email: _parseList<String>(json['Assigned_Provider_Email'], (v) => v as String? ?? ''),
        first_Name_Requester_Arabic: _parseList<String>(json['First_Name_Requester_Arabic'], (v) => v as String? ?? ''),
        last_Name_Requester_Arabic: _parseList<String>(json['Last_Name_Requester_Arabic'], (v) => v as String? ?? ''),
        job_Title_Requester_Arabic: _parseList<String>(json['Job_Title_Requester_Arabic'], (v) => v as String? ?? ''),
        department_Requester_Arabic: _parseList<String>(json['Department_Requester_Arabic'], (v) => v as String? ?? ''),
        service_Name_English: _parseList<String>(json['Service_Name_English'], (v) => v as String? ?? ''),
        service_Name_Arabic: _parseList<String>(json['Service_Name_Arabic'], (v) => v as String? ?? ''),
        service_Description_English: _parseList<String>(json['Service_Description_English'], (v) => v as String? ?? ''),
        service_Description_Arabic: _parseList<String>(json['Service_Description_Arabic'], (v) => v as String? ?? ''),
        duration_Of_Services: _parseList<String>(json['Duration_Of_Services'], (v) => v as String? ?? ''),
        selected_Duration_Unit: _parseList<String>(json['Selected_Duration_Unit'], (v) => v as String? ?? ''),
        duration_Of_Services_Timestamp: _parseList<Timestamp>(
          json['Duration_Of_Services_Timestamp'],
              (v) {
            if (v is Timestamp) return v;
            if (v is int) return Timestamp.fromMillisecondsSinceEpoch(v);
            return Timestamp.now();
          },
        ),
        image_Url: _parseList<String>(json['Image_Url'], (v) => v as String? ?? ''),
        provider_Services: _parseList<String>(json['Provider_Services'], (v) => _parseEmployeeListToJson(v)),
        select_Department: _parseList<String>(json['Select_Department'], (v) => _parseJsonArray(v)),
        approval_Cycle: _parseList<String>(json['Approval_Cycle'], (v) => _parseEmployeeListToJson(v)),
        limit_Availability: _parseList<bool>(json['Limit_Availability'], (v) => v as bool? ?? false),
        require_Approval: _parseList<bool>(json['Require_Approval'], (v) => v as bool? ?? false),
        sla_One_Controller_English: _parseList<String>(json['Sla_One_Controller_English'], (v) => v as String? ?? ''),
        sla_Two_Controller_English: _parseList<String>(json['Sla_Two_Controller_English'], (v) => v as String? ?? ''),
        notify_Requester_Checked: _parseList<bool>(json['Notify_Requester_Checked'], (v) => v as bool? ?? false),
        notify_Provider_Checked: _parseList<bool>(json['Notify_Provider_Checked'], (v) => v as bool? ?? false),
        notify_Manager_Checked: _parseList<bool>(json['Notify_Manager_Checked'], (v) => v as bool? ?? false),
        notify_Requester_Switch0: _parseList<bool>(json['Notify_Requester_Switch0'], (v) => v as bool? ?? false),
        notify_Manager_Switch1: _parseList<bool>(json['Notify_Manager_Switch1'], (v) => v as bool? ?? false),
      );
    } catch (e, stack) {
      // print("❌ Error parsing ServicesHistoryModel from doc '${docId ?? 'unknown'}': $e");
      // print("📄 JSON: $json");
      // print("🧱 Stacktrace:\n$stack");
      rethrow;
    }
  }

  // Helper: Parse list (handles multiple legacy formats)
  static List<T> _parseList<T>(dynamic value, T Function(dynamic) deserializer) {
    // If it's already a list
    if (value is List) {
      return value.map((e) => deserializer(e)).toList();
    }

    // Legacy format with FieldHistory: {timestamps: [...], values: [...]}
    if (value is Map<String, dynamic> && value.containsKey('values')) {
      final values = value['values'];
      if (values is List) {
        return values.map((e) => deserializer(e)).toList();
      }
    }

    // Legacy format: {value: ..., timestamp: ...}
    if (value is Map<String, dynamic> && value.containsKey('value')) {
      return [deserializer(value['value'])];
    }

    // Simple value
    return [deserializer(value)];
  }

  // Helper: Convert arrays to JSON string
  static String _parseJsonArray(dynamic value) {
    if (value == null) return '[]';
    if (value is String) return value;
    if (value is List) return jsonEncode(value);
    return '[]';
  }

  // Helper: Convert employee list to JSON string
  static String _parseEmployeeListToJson(dynamic value) {
    if (value == null) return '[]';
    if (value is String) return value;
    if (value is List) {
      final employees = value.map((e) {
        if (e is Map<String, dynamic>) {
          return e;
        } else if (e is Map) {
          return Map<String, dynamic>.from(e);
        }
        return null;
      }).whereType<Map<String, dynamic>>().toList();
      return jsonEncode(employees);
    }
    return '[]';
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'timestamps': timestamps,
      'id': id,
      'state': state,
      'status': status,
      'Parent_Service_Id': parent_Service_Id,
      'First_Name_Requester': first_Name_Requester,
      'Last_Name_Requester': last_Name_Requester,
      'Department_Requester': department_Requester,
      'Job_Title_Requester': job_Title_Requester,
      'Email_Requester': email_Requester,
      'Phone_Requester': phone_Requester,
      'Gender_Requester': gender_Requester,
      'Assigned_Provider_Email': assigned_Provider_Email,
      'First_Name_Requester_Arabic': first_Name_Requester_Arabic,
      'Last_Name_Requester_Arabic': last_Name_Requester_Arabic,
      'Job_Title_Requester_Arabic': job_Title_Requester_Arabic,
      'Department_Requester_Arabic': department_Requester_Arabic,
      'Service_Name_English': service_Name_English,
      'Service_Name_Arabic': service_Name_Arabic,
      'Service_Description_English': service_Description_English,
      'Service_Description_Arabic': service_Description_Arabic,
      'Duration_Of_Services': duration_Of_Services,
      'Selected_Duration_Unit': selected_Duration_Unit,
      'Duration_Of_Services_Timestamp': duration_Of_Services_Timestamp.map((v) => v.millisecondsSinceEpoch).toList(),
      'Image_Url': image_Url,
      'Provider_Services': provider_Services,
      'Limit_Availability': limit_Availability,
      'Require_Approval': require_Approval,
      'Select_Department': select_Department,
      'Approval_Cycle': approval_Cycle,
      'Sla_One_Controller_English': sla_One_Controller_English,
      'Sla_Two_Controller_English': sla_Two_Controller_English,
      'Notify_Requester_Checked': notify_Requester_Checked,
      'Notify_Provider_Checked': notify_Provider_Checked,
      'Notify_Manager_Checked': notify_Manager_Checked,
      'Notify_Requester_Switch0': notify_Requester_Switch0,
      'Notify_Manager_Switch1': notify_Manager_Switch1,
    };
  }

  // ✅ NEW: Convert to JSON, ONLY including fields that have values
  // ✅ UPDATED: Convert to JSON, ONLY including fields that have values
  Map<String, dynamic> toJsonMinimal() {
    final Map<String, dynamic> json = {};

    // ✅ Always include timestamps
    json['timestamps'] = timestamps;

    // ✅ Only add fields if they are NOT EMPTY AND have non-empty values
    if (parent_Service_Id.isNotEmpty && parent_Service_Id.last.isNotEmpty) {
      json['Parent_Service_Id'] = parent_Service_Id;
    }
    if (id.isNotEmpty && id.last.isNotEmpty) {
      json['id'] = id;
    }
    if (provider_Services.isNotEmpty && provider_Services.last.isNotEmpty) {
      json['Provider_Services'] = provider_Services;
    }
    if (approval_Cycle.isNotEmpty && approval_Cycle.last.isNotEmpty) {
      json['Approval_Cycle'] = approval_Cycle;
    }
    if (state.isNotEmpty && state.last.isNotEmpty) {
      json['state'] = state;
    }
    if (status.isNotEmpty && status.last.isNotEmpty) {
      json['status'] = status;
    }
    if (email_Requester.isNotEmpty && email_Requester.last.isNotEmpty) {  // ✅ ADDED CHECK
      json['Email_Requester'] = email_Requester;
    }
    if (assigned_Provider_Email.isNotEmpty && assigned_Provider_Email.last.isNotEmpty) {
      json['Assigned_Provider_Email'] = assigned_Provider_Email;
    }

    // ✅ Don't include select_Department or any other empty fields
    return json;
  }

  // copyWith method - adds new timestamp and new values
  ServicesHistoryModel copyWith({
    String? id,
    String? state,
    String? status,
    String? parentServiceId,
    String? firstNameRequester,
    String? lastNameRequester,
    String? departmentRequester,
    String? jobTitleRequester,
    String? emailRequester,
    String? phoneRequester,
    String? genderRequester,
    String? assignedProviderEmail,
    String? firstNameRequesterArabic,
    String? lastNameRequesterArabic,
    String? jobTitleRequesterArabic,
    String? departmentRequesterArabic,
    String? serviceNameEnglish,
    String? serviceNameArabic,
    String? serviceDescriptionEnglish,
    String? serviceDescriptionArabic,
    String? durationOfServices,
    String? selectedDurationUnit,
    Timestamp? durationOfServicesTimestamp,
    String? imageUrl,
    List<EmployeeEntityModell>? providerServices,
    bool? limitAvailability,
    bool? requireApproval,
    List<dynamic>? selectDepartment,
    List<EmployeeEntityModell>? approvalCycle,
    String? slaOneControllerEnglish,
    String? slaTwoControllerEnglish,
    bool? notifyRequesterChecked,
    bool? notifyProviderChecked,
    bool? notifyManagerChecked,
    bool? notifyRequesterSwitch0,
    bool? notifyManagerSwitch1,
  }) {
    // ✅ Add new timestamp
    final newTimestamps = List<int>.from(timestamps)..add(DateTime.now().millisecondsSinceEpoch);

    return ServicesHistoryModel(
      timestamps: newTimestamps,
      id: id != null ? (List<String>.from(this.id)..add(id)) : this.id,
      state: state != null ? (List<String>.from(this.state)..add(state)) : this.state,
      status: status != null ? (List<String>.from(this.status)..add(status)) : this.status,
      parent_Service_Id: parentServiceId != null ? (List<String>.from(this.parent_Service_Id)..add(parentServiceId)) : this.parent_Service_Id,
      first_Name_Requester: firstNameRequester != null ? (List<String>.from(this.first_Name_Requester)..add(firstNameRequester)) : this.first_Name_Requester,
      last_Name_Requester: lastNameRequester != null ? (List<String>.from(this.last_Name_Requester)..add(lastNameRequester)) : this.last_Name_Requester,
      department_Requester: departmentRequester != null ? (List<String>.from(this.department_Requester)..add(departmentRequester)) : this.department_Requester,
      job_Title_Requester: jobTitleRequester != null ? (List<String>.from(this.job_Title_Requester)..add(jobTitleRequester)) : this.job_Title_Requester,
      email_Requester: emailRequester != null ? (List<String>.from(this.email_Requester)..add(emailRequester)) : this.email_Requester,
      phone_Requester: phoneRequester != null ? (List<String>.from(this.phone_Requester)..add(phoneRequester)) : this.phone_Requester,
      gender_Requester: genderRequester != null ? (List<String>.from(this.gender_Requester)..add(genderRequester)) : this.gender_Requester,
      assigned_Provider_Email: assignedProviderEmail != null ? (List<String>.from(this.assigned_Provider_Email)..add(assignedProviderEmail)) : this.assigned_Provider_Email,
      first_Name_Requester_Arabic: firstNameRequesterArabic != null ? (List<String>.from(this.first_Name_Requester_Arabic)..add(firstNameRequesterArabic)) : this.first_Name_Requester_Arabic,
      last_Name_Requester_Arabic: lastNameRequesterArabic != null ? (List<String>.from(this.last_Name_Requester_Arabic)..add(lastNameRequesterArabic)) : this.last_Name_Requester_Arabic,
      job_Title_Requester_Arabic: jobTitleRequesterArabic != null ? (List<String>.from(this.job_Title_Requester_Arabic)..add(jobTitleRequesterArabic)) : this.job_Title_Requester_Arabic,
      department_Requester_Arabic: departmentRequesterArabic != null ? (List<String>.from(this.department_Requester_Arabic)..add(departmentRequesterArabic)) : this.department_Requester_Arabic,
      service_Name_English: serviceNameEnglish != null ? (List<String>.from(this.service_Name_English)..add(serviceNameEnglish)) : this.service_Name_English,
      service_Name_Arabic: serviceNameArabic != null ? (List<String>.from(this.service_Name_Arabic)..add(serviceNameArabic)) : this.service_Name_Arabic,
      service_Description_English: serviceDescriptionEnglish != null ? (List<String>.from(this.service_Description_English)..add(serviceDescriptionEnglish)) : this.service_Description_English,
      service_Description_Arabic: serviceDescriptionArabic != null ? (List<String>.from(this.service_Description_Arabic)..add(serviceDescriptionArabic)) : this.service_Description_Arabic,
      duration_Of_Services: durationOfServices != null ? (List<String>.from(this.duration_Of_Services)..add(durationOfServices)) : this.duration_Of_Services,
      selected_Duration_Unit: selectedDurationUnit != null ? (List<String>.from(this.selected_Duration_Unit)..add(selectedDurationUnit)) : this.selected_Duration_Unit,
      duration_Of_Services_Timestamp: durationOfServicesTimestamp != null ? (List<Timestamp>.from(this.duration_Of_Services_Timestamp)..add(durationOfServicesTimestamp)) : this.duration_Of_Services_Timestamp,
      image_Url: imageUrl != null ? (List<String>.from(this.image_Url)..add(imageUrl)) : this.image_Url,
      provider_Services: providerServices != null ? (List<String>.from(this.provider_Services)..add(jsonEncode(providerServices.map((e) => e.toJson()).toList()))) : this.provider_Services,
      limit_Availability: limitAvailability != null ? (List<bool>.from(this.limit_Availability)..add(limitAvailability)) : this.limit_Availability,
      require_Approval: requireApproval != null ? (List<bool>.from(this.require_Approval)..add(requireApproval)) : this.require_Approval,
      select_Department: selectDepartment != null ? (List<String>.from(this.select_Department)..add(jsonEncode(selectDepartment))) : this.select_Department,
      approval_Cycle: approvalCycle != null ? (List<String>.from(this.approval_Cycle)..add(jsonEncode(approvalCycle.map((e) => e.toJson()).toList()))) : this.approval_Cycle,
      sla_One_Controller_English: slaOneControllerEnglish != null ? (List<String>.from(this.sla_One_Controller_English)..add(slaOneControllerEnglish)) : this.sla_One_Controller_English,
      sla_Two_Controller_English: slaTwoControllerEnglish != null ? (List<String>.from(this.sla_Two_Controller_English)..add(slaTwoControllerEnglish)) : this.sla_Two_Controller_English,
      notify_Requester_Checked: notifyRequesterChecked != null ? (List<bool>.from(this.notify_Requester_Checked)..add(notifyRequesterChecked)) : this.notify_Requester_Checked,
      notify_Provider_Checked: notifyProviderChecked != null ? (List<bool>.from(this.notify_Provider_Checked)..add(notifyProviderChecked)) : this.notify_Provider_Checked,
      notify_Manager_Checked: notifyManagerChecked != null ? (List<bool>.from(this.notify_Manager_Checked)..add(notifyManagerChecked)) : this.notify_Manager_Checked,
      notify_Requester_Switch0: notifyRequesterSwitch0 != null ? (List<bool>.from(this.notify_Requester_Switch0)..add(notifyRequesterSwitch0)) : this.notify_Requester_Switch0,
      notify_Manager_Switch1: notifyManagerSwitch1 != null ? (List<bool>.from(this.notify_Manager_Switch1)..add(notifyManagerSwitch1)) : this.notify_Manager_Switch1,
    );
  }

  // Factory: Create new service
  factory ServicesHistoryModel.createNew({
    String id = '',
    String state = '',
    String status = 'draft',
    String parentServiceId = '',
    String firstNameRequester = '',
    String lastNameRequester = '',
    String departmentRequester = '',
    String jobTitleRequester = '',
    String emailRequester = '',
    String phoneRequester = '',
    String genderRequester = '',
    String assignedProviderEmail = '',
    String firstNameRequesterArabic = '',
    String lastNameRequesterArabic = '',
    String jobTitleRequesterArabic = '',
    String departmentRequesterArabic = '',
    String serviceNameEnglish = '',
    String serviceNameArabic = '',
    String serviceDescriptionEnglish = '',
    String serviceDescriptionArabic = '',
    String durationOfServices = '',
    String selectedDurationUnit = '',
    Timestamp? durationOfServicesTimestamp,
    String imageUrl = '',
    List<EmployeeEntityModell> providerServices = const [],
    bool limitAvailability = false,
    bool requireApproval = false,
    List<dynamic> selectDepartment = const [],
    List<EmployeeEntityModell> approvalCycle = const [],
    String slaOneControllerEnglish = '',
    String slaTwoControllerEnglish = '',
    bool notifyRequesterChecked = false,
    bool notifyProviderChecked = false,
    bool notifyManagerChecked = false,
    bool notifyRequesterSwitch0 = false,
    bool notifyManagerSwitch1 = false,
  }) {
    return ServicesHistoryModel(
      timestamps: [DateTime.now().millisecondsSinceEpoch],
      id: [id],
      state: [state],
      status: [status],
      parent_Service_Id: [parentServiceId],
      first_Name_Requester: [firstNameRequester],
      last_Name_Requester: [lastNameRequester],
      department_Requester: [departmentRequester],
      job_Title_Requester: [jobTitleRequester],
      email_Requester: [emailRequester],
      phone_Requester: [phoneRequester],
      gender_Requester: [genderRequester],
      assigned_Provider_Email: [assignedProviderEmail],
      first_Name_Requester_Arabic: [firstNameRequesterArabic],
      last_Name_Requester_Arabic: [lastNameRequesterArabic],
      job_Title_Requester_Arabic: [jobTitleRequesterArabic],
      department_Requester_Arabic: [departmentRequesterArabic],
      service_Name_English: [serviceNameEnglish],
      service_Name_Arabic: [serviceNameArabic],
      service_Description_English: [serviceDescriptionEnglish],
      service_Description_Arabic: [serviceDescriptionArabic],
      duration_Of_Services: [durationOfServices],
      selected_Duration_Unit: [selectedDurationUnit],
      duration_Of_Services_Timestamp: [durationOfServicesTimestamp ?? Timestamp.now()],
      image_Url: [imageUrl],
      provider_Services: [jsonEncode(providerServices.map((e) => e.toJson()).toList())],
      limit_Availability: [limitAvailability],
      require_Approval: [requireApproval],
      select_Department: [jsonEncode(selectDepartment)],
      approval_Cycle: [jsonEncode(approvalCycle.map((e) => e.toJson()).toList())],
      sla_One_Controller_English: [slaOneControllerEnglish],
      sla_Two_Controller_English: [slaTwoControllerEnglish],
      notify_Requester_Checked: [notifyRequesterChecked],
      notify_Provider_Checked: [notifyProviderChecked],
      notify_Manager_Checked: [notifyManagerChecked],
      notify_Requester_Switch0: [notifyRequesterSwitch0],
      notify_Manager_Switch1: [notifyManagerSwitch1],
    );
  }



  // ✅ NEW: For CREATING/UPDATING services - includes ALL service data, NO personal requester info
  Map<String, dynamic> toJsonForCreate() {
    final Map<String, dynamic> json = {};

    // ✅ Always include timestamps
    json['timestamps'] = timestamps;

    // ✅ Core identifiers
    if (id.isNotEmpty) json['id'] = id;
    if (state.isNotEmpty) json['state'] = state;
    if (status.isNotEmpty) json['status'] = status;
    if (parent_Service_Id.isNotEmpty) json['Parent_Service_Id'] = parent_Service_Id;

    // ✅ Email Requester (ADDED)
    if (email_Requester.isNotEmpty && email_Requester.last.isNotEmpty) {
      json['Email_Requester'] = email_Requester;
    }

    // ✅ Service details (INCLUDE ALL)
    if (service_Name_English.isNotEmpty) json['Service_Name_English'] = service_Name_English;
    if (service_Name_Arabic.isNotEmpty) json['Service_Name_Arabic'] = service_Name_Arabic;
    if (service_Description_English.isNotEmpty) json['Service_Description_English'] = service_Description_English;
    if (service_Description_Arabic.isNotEmpty) json['Service_Description_Arabic'] = service_Description_Arabic;
    if (duration_Of_Services.isNotEmpty) json['Duration_Of_Services'] = duration_Of_Services;
    if (selected_Duration_Unit.isNotEmpty) json['Selected_Duration_Unit'] = selected_Duration_Unit;
    if (duration_Of_Services_Timestamp.isNotEmpty) {
      json['Duration_Of_Services_Timestamp'] = duration_Of_Services_Timestamp.map((v) => v.millisecondsSinceEpoch).toList();
    }

    // ✅ Image URL (only if not empty)
    if (image_Url.isNotEmpty && image_Url.last.isNotEmpty) {
      json['Image_Url'] = image_Url;
    }

    // ✅ Provider and approval data
    if (provider_Services.isNotEmpty && provider_Services.last.isNotEmpty && provider_Services.last != '[]') {
      json['Provider_Services'] = provider_Services;
    }
    if (approval_Cycle.isNotEmpty && approval_Cycle.last.isNotEmpty && approval_Cycle.last != '[]') {
      json['Approval_Cycle'] = approval_Cycle;
    }
    if (select_Department.isNotEmpty && select_Department.last.isNotEmpty && select_Department.last != '[]') {
      json['Select_Department'] = select_Department;
    }

    // ✅ Boolean flags
    if (limit_Availability.isNotEmpty) json['Limit_Availability'] = limit_Availability;
    if (require_Approval.isNotEmpty) json['Require_Approval'] = require_Approval;

    // ✅ SLA fields
    if (sla_One_Controller_English.isNotEmpty && sla_One_Controller_English.last.isNotEmpty) {
      json['Sla_One_Controller_English'] = sla_One_Controller_English;
    }
    if (sla_Two_Controller_English.isNotEmpty && sla_Two_Controller_English.last.isNotEmpty) {
      json['Sla_Two_Controller_English'] = sla_Two_Controller_English;
    }

    // ✅ Notification settings
    if (notify_Requester_Checked.isNotEmpty) json['Notify_Requester_Checked'] = notify_Requester_Checked;
    if (notify_Provider_Checked.isNotEmpty) json['Notify_Provider_Checked'] = notify_Provider_Checked;
    if (notify_Manager_Checked.isNotEmpty) json['Notify_Manager_Checked'] = notify_Manager_Checked;
    if (notify_Requester_Switch0.isNotEmpty) json['Notify_Requester_Switch0'] = notify_Requester_Switch0;
    if (notify_Manager_Switch1.isNotEmpty) json['Notify_Manager_Switch1'] = notify_Manager_Switch1;

    // ✅ Assigned provider email (for requests)
    if (assigned_Provider_Email.isNotEmpty && assigned_Provider_Email.last.isNotEmpty) {
      json['Assigned_Provider_Email'] = assigned_Provider_Email;
    }

    // ❌ EXCLUDE OTHER requester personal fields:
    // - First_Name_Requester
    // - Last_Name_Requester
    // - Department_Requester
    // - Job_Title_Requester
    // - Phone_Requester
    // - Gender_Requester
    // - First_Name_Requester_Arabic
    // - Last_Name_Requester_Arabic
    // - Job_Title_Requester_Arabic
    // - Department_Requester_Arabic

    return json;
  }

  // ✅ NEW: Creates a MINIMAL request with ONLY the required fields
  /// All other fields will remain as EMPTY LISTS (not included in toJsonMinimal)
  factory ServicesHistoryModel.createMinimalRequest({
    required String parentServiceId,
    required String id,
    required List<EmployeeEntityModell> providerServices,
    required List<EmployeeEntityModell> approvalCycle,
    required String state,
    required String status,
    required String emailRequester,  // ✅ ADDED
  }) {
    return ServicesHistoryModel(
      // ✅ Required fields ONLY
      timestamps: [DateTime.now().millisecondsSinceEpoch],
      parent_Service_Id: [parentServiceId],
      id: [id],
      provider_Services: [jsonEncode(providerServices.map((e) => e.toJson()).toList())],
      select_Department: [],  // ✅ Empty - will not be uploaded
      email_Requester: [emailRequester],  // ✅ ADDED - will be uploaded
      approval_Cycle: [jsonEncode(approvalCycle.map((e) => e.toJson()).toList())],
      state: [state],
      status: [status],

      // ✅ ALL other fields are EMPTY LISTS (won't be uploaded when using toJsonMinimal)
      first_Name_Requester: [],
      last_Name_Requester: [],
      department_Requester: [],
      job_Title_Requester: [],
      phone_Requester: [],
      gender_Requester: [],
      assigned_Provider_Email: [],
      first_Name_Requester_Arabic: [],
      last_Name_Requester_Arabic: [],
      job_Title_Requester_Arabic: [],
      department_Requester_Arabic: [],
      service_Name_English: [],
      service_Name_Arabic: [],
      service_Description_English: [],
      service_Description_Arabic: [],
      duration_Of_Services: [],
      selected_Duration_Unit: [],
      duration_Of_Services_Timestamp: [],
      image_Url: [],
      limit_Availability: [],
      require_Approval: [],
      sla_One_Controller_English: [],
      sla_Two_Controller_English: [],
      notify_Requester_Checked: [],
      notify_Provider_Checked: [],
      notify_Manager_Checked: [],
      notify_Requester_Switch0: [],
      notify_Manager_Switch1: [],
    );
  }

  // Update methods - add new values to lists
  void updateServiceName(String englishName, String arabicName) {
    timestamps.add(DateTime.now().millisecondsSinceEpoch);
    service_Name_English.add(englishName);
    service_Name_Arabic.add(arabicName);
  }

  void updateServiceDescription(String englishDesc, String arabicDesc) {
    timestamps.add(DateTime.now().millisecondsSinceEpoch);
    service_Description_English.add(englishDesc);
    service_Description_Arabic.add(arabicDesc);
  }

  void updateStatus(String newStatus) {
    timestamps.add(DateTime.now().millisecondsSinceEpoch);
    status.add(newStatus);
  }

  void updateProviderServices(List<EmployeeEntityModell> providers) {
    timestamps.add(DateTime.now().millisecondsSinceEpoch);
    provider_Services.add(jsonEncode(providers.map((e) => e.toJson()).toList()));
  }

  void updateApprovalCycle(List<EmployeeEntityModell> approvers) {
    timestamps.add(DateTime.now().millisecondsSinceEpoch);
    approval_Cycle.add(jsonEncode(approvers.map((e) => e.toJson()).toList()));
  }

  void updateSelectDepartment(List<String> departments) {
    timestamps.add(DateTime.now().millisecondsSinceEpoch);
    select_Department.add(jsonEncode(departments));
  }

  void updateDurationTimestamp(Timestamp timestamp) {
    timestamps.add(DateTime.now().millisecondsSinceEpoch);
    duration_Of_Services_Timestamp.add(timestamp);
  }

  // Helper methods to get decoded values
  List<EmployeeEntityModell> get currentProviderServices {
    try {
      print('🔍 [currentProviderServices] START');
      print('   provider_Services.length: ${provider_Services.length}');

      if (provider_Services.isEmpty) {
        print('   ❌ provider_Services array is EMPTY');
        return [];
      }

      final jsonStr = provider_Services.last;
      print('   jsonStr: $jsonStr');
      print('   jsonStr.length: ${jsonStr.length}');
      print('   jsonStr type: ${jsonStr.runtimeType}');

      if (jsonStr.isEmpty || jsonStr == '[]' || jsonStr == '""') {
        print('   ❌ jsonStr is empty or contains empty array');
        return [];
      }

      print('   Attempting to decode JSON...');
      final List<dynamic> list = jsonDecode(jsonStr);
      print('   ✅ JSON decoded successfully');
      print('   Decoded list length: ${list.length}');
      print('   Decoded list: $list');

      if (list.isEmpty) {
        print('   ❌ Decoded list is EMPTY');
        return [];
      }

      print('   Mapping to EmployeeEntityModel...');
      final result = list.map((e) {
        print('      Parsing employee: ${e['firstName']} ${e['lastName']}');
        return EmployeeEntityModell.fromJson(e);
      }).toList();

      print('   ✅ Mapped result length: ${result.length}');
      print('   First employee: ${result.first.firstName} ${result.first.lastName}');
      return result;
    } catch (e, stackTrace) {
      print('❌ ERROR in currentProviderServices getter: $e');
      print('❌ Stack trace: $stackTrace');
      print('❌ provider_Services raw: $provider_Services');
      return [];
    }
  }

  List<EmployeeEntityModell> get currentApprovalCycle {
    try {
      final jsonStr = approval_Cycle.isNotEmpty ? approval_Cycle.last : '[]';
      final List<dynamic> list = jsonDecode(jsonStr);
      final result = list.map((e) => EmployeeEntityModell.fromJson(e)).toList();
      return result;
    } catch (e, stackTrace) {
      return [];
    }
  }

  List<String> get currentSelectDepartment {
    try {
      final jsonStr = select_Department.isNotEmpty ? select_Department.last : '[]';
      final List<dynamic> list = jsonDecode(jsonStr);
      final result = list.map((e) => e.toString()).toList();
      return result;
    } catch (e, stackTrace) {
      return [];
    }
  }
}