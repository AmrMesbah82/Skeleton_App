/// ******************* FILE INFO *******************
/// File Name: helper_function
/// Description: this page used for function which responsible about get select provider
/// Created by: Amr Mesbah
/// Last Update: 30/8/2025


import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/employee/domain/entities/employee_entity.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';
import 'package:demo_app/core/constants/services_management/constant.dart';





class CSVHelper {
  String createCsv(List<List<dynamic>> rows) {
    return const ListToCsvConverter().convert(rows);
  }

  Future<File> saveCsvToFile(String csvData, String fileName) async {
    Directory? directory;

    if (Platform.isAndroid) {
      // ✅ Save to public Downloads folder
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    } else {
      // ✅ For iOS/macOS fallback
      directory = await getApplicationDocumentsDirectory();
    }

    final path = '${directory.path}/$fileName.csv';
    final file = File(path);

    List<int> csvBytes = utf8.encode(csvData);
    List<int> bom = [0xEF, 0xBB, 0xBF]; // Excel compatibility BOM

    return await file.writeAsBytes(bom + csvBytes);
  }

  Future<File> exportToCSV(List<List<dynamic>> rows, String fileName) async {
    final csv = createCsv(rows);
    return await saveCsvToFile(csv, fileName);
  }
}







double _toMinutes(double v, String? unit) {
  switch ((unit ?? '').toLowerCase()) {
    case 'minutes': return v;
    case 'hours':   return v * 60;
    case 'days':    return v * 60 * 24;
    case 'weeks':   return v * 60 * 24 * 7;
    default:        return v;
  }
}

bool _isActiveStatus(String s) {
  s = s.toLowerCase();
  return s == 'pending' || s == 'approved' || s == 'inprogress' || s == 'done';
}


Future<Map<String, dynamic>?> selectServiceProviderLite({
  required List<Map<String, dynamic>> candidates,

  // ---- NEW optional params to enable persistence ----
  String? serviceId,                                // CreateServices doc id; if provided, we can persist / honor manual
  String createServicesCollection =
      FirestoreCollections.createServices,          // will be prefixed by getBaseUrl(...)
  bool enablePersistence = true,                    // whether to write back after auto-pick
  String assignedProviderField = 'assignedProvider',
  String assignedEmailField = 'assignedProviderEmail',
  String manualFlagField = 'assignedProviderManual',

  // ---- selection knobs ----
  int windowDays = 7,
  int perDayCap = 2, // 0 to disable per-day cap
}) async
{
  // 0) quick exits
  if (candidates.isEmpty) return null;
  if (candidates.length == 1) {
    // Optionally persist single candidate if serviceId provided and no manual override
    final single = candidates.first;
    if (serviceId != null && enablePersistence) {
      final fs = FirebaseFirestore.instance;
      final docRef = fs.collection(getBaseUrl(createServicesCollection)).doc(serviceId);
      final snap = await docRef.get();
      final data = snap.data();

      final hasManual = (data != null && (data[manualFlagField] == true));
      if (!hasManual) {
        await docRef.update({
          assignedProviderField: FieldValue.arrayUnion([single]),
          assignedEmailField: FieldValue.arrayUnion([(single['email'] ?? '').toString().toLowerCase()]),
          manualFlagField: FieldValue.arrayUnion([false]),
          'timestamps': FieldValue.arrayUnion([DateTime.now().millisecondsSinceEpoch]),
        });
      }
    }
    return single;
  }

  final fs = FirebaseFirestore.instance;
  final now = DateTime.now();
  final from = now.subtract(Duration(days: windowDays));
  final startToday = DateTime(now.year, now.month, now.day);
  final endToday = startToday.add(const Duration(days: 1));

  // 1) If serviceId present, check manual override or existing assignment
  if (serviceId != null) {
    final docRef = fs.collection(getBaseUrl(createServicesCollection)).doc(serviceId);
    final snap = await docRef.get();
    final data = snap.data();

    if (data != null) {
      // Handle list format for manualFlag
      bool isManual = false;
      if (data[manualFlagField] is List && (data[manualFlagField] as List).isNotEmpty) {
        isManual = (data[manualFlagField] as List).last == true;
      } else if (data[manualFlagField] is bool) {
        isManual = data[manualFlagField] as bool;
      }

      // Handle list format for assignedProvider
      Map<String, dynamic>? existingProvider;
      if (data[assignedProviderField] is List && (data[assignedProviderField] as List).isNotEmpty) {
        final lastEntry = (data[assignedProviderField] as List).last;
        if (lastEntry is Map) {
          existingProvider = Map<String, dynamic>.from(lastEntry);
        }
      } else if (data[assignedProviderField] is Map) {
        existingProvider = Map<String, dynamic>.from(data[assignedProviderField]);
      }

      // If manually set -> always respect it and return
      if (isManual && existingProvider != null) {
        return existingProvider;
      }
    }
  }

  // 2) Build candidate email set
  final emails = candidates
      .map((c) => (c['email'] ?? '').toString().toLowerCase())
      .where((e) => e.isNotEmpty)
      .toSet();
  if (emails.isEmpty) return candidates.first;

  // 3) ✅ UPDATED: Query RequestServices collection directly (no collectionGroup)
  final requestServicesPath = getBaseUrl(FirestoreCollections.requestServices);

  // Parse the path to get collection reference
  final pathParts = requestServicesPath.split('/');
  CollectionReference<Map<String, dynamic>> requestsCollection;

  if (pathParts.length == 3) {
    // Format: tenant/companyId/RequestServices
    requestsCollection = fs
        .collection(pathParts[0])
        .doc(pathParts[1])
        .collection(pathParts[2]);
  } else if (pathParts.length == 1) {
    // Format: RequestServices (direct collection)
    requestsCollection = fs.collection(pathParts[0]);
  } else {
    // Fallback to candidates.first if path is unexpected
    if (kDebugMode) print('❌ Unexpected path format: $requestServicesPath');
    return candidates.first;
  }

  // Query recent requests
  final recent = await requestsCollection
      .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
      .get();

  final Map<String, double> minutes = { for (final e in emails) e: 0.0 };
  final Map<String, int>    count   = { for (final e in emails) e: 0   };
  final Map<String, int>    today   = { for (final e in emails) e: 0   };

  for (final d in recent.docs) {
    final row = d.data();

    // ✅ UPDATED: Handle assignedProviderEmail field (list format)
    String email = '';

    if (row['Assigned_Provider_Email'] != null) {
      final assignedEmail = row['Assigned_Provider_Email'];
      if (assignedEmail is List && assignedEmail.isNotEmpty) {
        email = assignedEmail.last.toString().toLowerCase();
      } else if (assignedEmail is String) {
        email = assignedEmail.toLowerCase();
      }
    }

    // Fallback to provider field
    if (email.isEmpty) {
      final prov = row['provider'];
      if (prov is Map) {
        email = (prov['email'] ?? '').toString().toLowerCase();
      }
    }

    if (!emails.contains(email)) continue;

    // ✅ UPDATED: Handle list format for state
    String state = '';
    if (row['state'] is List && (row['state'] as List).isNotEmpty) {
      state = (row['state'] as List).last.toString();
    } else if (row['state'] is String) {
      state = row['state'].toString();
    }

    if (!_isActiveStatus(state)) continue;

    final ts = row['createdAt'] ?? row['serviceNameEnglishTimestamp'];
    if (ts is! Timestamp) continue;
    final created = ts.toDate();

    // ✅ UPDATED: Handle list format for selectedDurationUnit
    String? unit;
    if (row['Selected_Duration_Unit'] is List && (row['Selected_Duration_Unit'] as List).isNotEmpty) {
      unit = (row['Selected_Duration_Unit'] as List).last?.toString();
    } else if (row['Selected_Duration_Unit'] is Map) {
      unit = row['Selected_Duration_Unit']['value']?.toString();
    } else {
      unit = row['Selected_Duration_Unit']?.toString();
    }

    // ✅ UPDATED: Handle list format for durationOfServices
    String? valStr;
    if (row['durationOfServices'] is List && (row['durationOfServices'] as List).isNotEmpty) {
      valStr = (row['durationOfServices'] as List).last?.toString();
    } else if (row['durationOfServices'] is Map) {
      valStr = row['durationOfServices']['value']?.toString();
    } else {
      valStr = row['durationOfServices']?.toString();
    }

    final mins = _toMinutes(double.tryParse(valStr ?? '0') ?? 0, unit);

    minutes[email] = (minutes[email] ?? 0) + mins;
    count[email]    = (count[email] ?? 0) + 1;

    if (!created.isBefore(startToday) && created.isBefore(endToday)) {
      today[email] = (today[email] ?? 0) + 1;
    }
  }

  // 4) daily cap filter (optional)
  final filtered = (perDayCap > 0)
      ? candidates.where((c) {
    final e = (c['email'] ?? '').toString().toLowerCase();
    return (today[e] ?? 0) < perDayCap;
  }).toList()
      : candidates.toList();

  final pool = filtered.isNotEmpty ? filtered : candidates;

  // 5) rank by total minutes then by count (fairness)
  pool.sort((a, b) {
    final ea = (a['email'] ?? '').toString().toLowerCase();
    final eb = (b['email'] ?? '').toString().toLowerCase();
    final mA = minutes[ea] ?? 0;
    final mB = minutes[eb] ?? 0;
    if (mA != mB) return mA.compareTo(mB);
    final cA = count[ea] ?? 0;
    final cB = count[eb] ?? 0;
    if (cA != cB) return cA.compareTo(cB);
    return ea.compareTo(eb);
  });

  // 6) random among tied best
  final best = pool.first;
  final be = (best['email'] ?? '').toString().toLowerCase();
  final bm = minutes[be] ?? 0;
  final bc = count[be] ?? 0;

  final tied = pool.where((c) {
    final e = (c['email'] ?? '').toString().toLowerCase();
    return (minutes[e] ?? 0) == bm && (count[e] ?? 0) == bc;
  }).toList();

  final chosen = (tied.length <= 1)
      ? best
      : (tied..shuffle(Random())).first;

  // 7) ✅ UPDATED: persist result using array format
  if (serviceId != null && enablePersistence) {
    final docRef = fs.collection(getBaseUrl(createServicesCollection)).doc(serviceId);
    final snap = await docRef.get();
    final data = snap.data();

    // Check if manually set
    bool isManual = false;
    if (data != null) {
      if (data[manualFlagField] is List && (data[manualFlagField] as List).isNotEmpty) {
        isManual = (data[manualFlagField] as List).last == true;
      } else if (data[manualFlagField] is bool) {
        isManual = data[manualFlagField] as bool;
      }
    }

    if (!isManual) {
      await docRef.update({
        assignedProviderField: FieldValue.arrayUnion([chosen]),
        assignedEmailField: FieldValue.arrayUnion([(chosen['email'] ?? '').toString().toLowerCase()]),
        manualFlagField: FieldValue.arrayUnion([false]),
        'timestamps': FieldValue.arrayUnion([DateTime.now().millisecondsSinceEpoch]),
      });
    }
  }

  return chosen;
}






Future<Map<String, dynamic>?> selectServiceProvider(String currentServiceDocId) async {
  final firestore = FirebaseFirestore.instance;

  try {
    if (kDebugMode) print("🔍 Looking for service: $currentServiceDocId");

    // ✅ UPDATED: Get document directly from CreateServices collection
    final createServicesPath = getBaseUrl(FirestoreCollections.createServices);
    final pathParts = createServicesPath.split('/');

    DocumentReference<Map<String, dynamic>> currentServiceDocRef;

    if (pathParts.length == 3) {
      currentServiceDocRef = firestore
          .collection(pathParts[0])
          .doc(pathParts[1])
          .collection(pathParts[2])
          .doc(currentServiceDocId);
    } else if (pathParts.length == 1) {
      currentServiceDocRef = firestore
          .collection(pathParts[0])
          .doc(currentServiceDocId);
    } else {
      if (kDebugMode) print("❌ Unexpected path format: $createServicesPath");
      return null;
    }

    final currentServiceDoc = await currentServiceDocRef.get();

    if (!currentServiceDoc.exists) {
      if (kDebugMode) print("❌ Service not found: $currentServiceDocId");
      return null;
    }

    final currentData = currentServiceDoc.data();
    final currentProviderServices = currentData?['Provider_Services'];

    if (currentProviderServices == null) {
      if (kDebugMode) print("❌ No providers for service: $currentServiceDocId");
      return null;
    }

    // Parse providers (handle list format)
    List<dynamic> parsedCurrentProviders = _parseProvidersList(currentProviderServices);

    if (parsedCurrentProviders.isEmpty) {
      if (kDebugMode) print("❌ Empty providers list");
      return null;
    }

    // If only 1 provider, return it
    if (parsedCurrentProviders.length == 1) {
      final provider = parsedCurrentProviders[0];
      if (provider is Map<String, dynamic>) {
        if (kDebugMode) print("✅ Single provider: ${provider['email']}");
        return provider;
      }
      return null;
    }

    // ✅ For multiple providers, calculate workload across ALL services
    if (kDebugMode) print("📊 Multiple providers (${parsedCurrentProviders.length}), calculating workload...");

    // ✅ UPDATED: Get all services from CreateServices collection
    CollectionReference<Map<String, dynamic>> createServicesCollection;

    if (pathParts.length == 3) {
      createServicesCollection = firestore
          .collection(pathParts[0])
          .doc(pathParts[1])
          .collection(pathParts[2]);
    } else if (pathParts.length == 1) {
      createServicesCollection = firestore.collection(pathParts[0]);
    } else {
      if (kDebugMode) print("❌ Unexpected path format: $createServicesPath");
      return null;
    }

    final allServicesSnapshot = await createServicesCollection.get();
    if (kDebugMode) print("📊 Total CreateServices docs found: ${allServicesSnapshot.docs.length}");

    final Map<String, double> emailTotalDuration = {};
    final Map<String, int> emailFrequency = {};

    // Process all services to calculate provider workload
    for (var serviceDoc in allServicesSnapshot.docs) {
      final data = serviceDoc.data();
      final providerServices = data['Provider_Services'];

      // ✅ UPDATED: Calculate duration (handle list format)
      final durationData = data['Duration_Of_Services'];
      String? durationValueStr;

      if (durationData is List && durationData.isNotEmpty) {
        final lastEntry = durationData.last;
        if (lastEntry is Map) {
          var durVal = lastEntry['value'] ?? lastEntry['values'];
          if (durVal is List && durVal.isNotEmpty) {
            durationValueStr = durVal[0].toString();
          } else {
            durationValueStr = durVal?.toString();
          }
        } else {
          durationValueStr = lastEntry.toString();
        }
      } else if (durationData is Map) {
        var durVal = durationData['value'] ?? durationData['values'];
        if (durVal is List && durVal.isNotEmpty) {
          durationValueStr = durVal[0].toString();
        } else {
          durationValueStr = durVal?.toString();
        }
      } else {
        durationValueStr = durationData?.toString();
      }

      // ✅ UPDATED: Get duration unit (handle list format)
      final durationUnitData = data['Selected_Duration_Unit'];
      String? durationUnit;

      if (durationUnitData is List && durationUnitData.isNotEmpty) {
        final lastEntry = durationUnitData.last;
        if (lastEntry is Map) {
          var unitVal = lastEntry['value'] ?? lastEntry['values'];
          if (unitVal is List && unitVal.isNotEmpty) {
            durationUnit = unitVal[0].toString().toLowerCase();
          } else {
            durationUnit = unitVal?.toString().toLowerCase();
          }
        } else {
          durationUnit = lastEntry.toString().toLowerCase();
        }
      } else if (durationUnitData is Map) {
        var unitVal = durationUnitData['value'] ?? durationUnitData['values'];
        if (unitVal is List && unitVal.isNotEmpty) {
          durationUnit = unitVal[0].toString().toLowerCase();
        } else {
          durationUnit = unitVal?.toString().toLowerCase();
        }
      } else {
        durationUnit = durationUnitData?.toString().toLowerCase();
      }

      double durationValue = double.tryParse(durationValueStr ?? '0') ?? 0;

      double durationInMin = switch (durationUnit) {
        "minutes" || "minute" || "min" => durationValue,
        "hours" || "hour" || "hr" => durationValue * 60,
        "days" || "day" => durationValue * 1440,
        "weeks" || "week" => durationValue * 10080,
        _ => durationValue
      };

      // Count workload per provider (handle list format)
      if (providerServices != null) {
        dynamic providersList;

        if (providerServices is List && providerServices.isNotEmpty) {
          final lastEntry = providerServices.last;
          if (lastEntry is String) {
            // JSON string format
            providersList = lastEntry;
          } else {
            providersList = providerServices;
          }
        } else if (providerServices is Map) {
          providersList = providerServices['values'] ?? providerServices['value'];
        } else {
          continue;
        }

        List<dynamic> parsedProviders = _parseProvidersList(providersList);

        for (var provider in parsedProviders) {
          if (provider is Map<String, dynamic>) {
            final email = provider['email'];
            if (email != null && email is String) {
              emailTotalDuration[email] = (emailTotalDuration[email] ?? 0) + durationInMin;
              emailFrequency[email] = (emailFrequency[email] ?? 0) + 1;
            }
          }
        }
      }
    }

    if (kDebugMode) print("📊 Workload calculated:");
    emailTotalDuration.forEach((email, duration) {
      if (kDebugMode) print("  $email: ${duration}min (${emailFrequency[email]} services)");
    });

    // Sort providers by workload (least busy first)
    final validProviders = parsedCurrentProviders
        .where((p) => p is Map<String, dynamic> && p['email'] != null)
        .cast<Map<String, dynamic>>()
        .toList();

    if (validProviders.isEmpty) {
      if (kDebugMode) print("❌ No valid providers");
      return null;
    }

    validProviders.sort((a, b) {
      final emailA = a['email'] as String?;
      final emailB = b['email'] as String?;

      if (emailA == null || emailB == null) return 0;

      final durationA = emailTotalDuration[emailA] ?? 0;
      final durationB = emailTotalDuration[emailB] ?? 0;

      if (durationA != durationB) {
        return durationA.compareTo(durationB);
      }

      final freqA = emailFrequency[emailA] ?? 0;
      final freqB = emailFrequency[emailB] ?? 0;
      return freqA.compareTo(freqB);
    });

    final selectedProvider = validProviders.first;
    final selectedEmail = selectedProvider['email'];
    if (kDebugMode) print("✅ Selected provider (least busy): $selectedEmail");
    if (kDebugMode) print("   Total workload: ${emailTotalDuration[selectedEmail] ?? 0}min");
    if (kDebugMode) print("   Service count: ${emailFrequency[selectedEmail] ?? 0}");

    return selectedProvider;

  } catch (e, stackTrace) {
    if (kDebugMode) print("❌ ERROR in selectServiceProvider: $e");
    if (kDebugMode) print("❌ Stack Trace: $stackTrace");
    return null;
  }
}






List<dynamic> _parseProvidersList(dynamic providersList) {
  // print("  🔧 Parsing providers list...");
  // print("  🔧 Input Type: ${providersList?.runtimeType}");

  if (providersList == null) {
    // print("  ❌ Providers list is null");
    return [];
  }

  // If it's already a list
  if (providersList is List) {
    // print("  ✅ Input is a List with ${providersList.length} items");

    // Check if first element is a List (nested array)
    if (providersList.isNotEmpty && providersList[0] is List) {
      // print("  🔄 Unwrapping nested array");
      providersList = providersList[0];
    }

    // Check if first element is a JSON string
    if (providersList.isNotEmpty && providersList[0] is String) {
      // print("  🔄 First element is a String, attempting JSON decode");
      try {
        final decoded = jsonDecode(providersList[0]);
        // print("  ✅ Successfully decoded JSON string");
        if (decoded is List) {
          return decoded;
        } else if (decoded is Map) {
          return [decoded];
        }
      } catch (e) {
        // print("  ❌ Failed to decode JSON: $e");
      }
    }

    // Return the list as-is if elements are Maps
    return providersList;
  }

  // If it's a String (JSON)
  if (providersList is String) {
    // print("  🔄 Input is a String, attempting JSON decode");
    try {
      final decoded = jsonDecode(providersList);
      // print("  ✅ Successfully decoded JSON string");
      if (decoded is List) {
        return decoded;
      } else if (decoded is Map) {
        return [decoded];
      }
    } catch (e) {
      // print("  ❌ Failed to decode JSON string: $e");
    }
  }

  // print("  ❌ Unable to parse providers list");
  return [];
}


Future<Map<String, dynamic>?> selectServiceProviderRequest(
    String currentServiceDocId, {
      int lookbackDays = 7,
      bool rotateWithinSameParent = true,
      int perDayCap = 2,
      bool respectExistingAssignment = true,
      bool allowReassignIfCapExceeded = true,
    })

async {
  final firestore = FirebaseFirestore.instance;
  final userPath = firestore
      .collection(getBaseUrl(FirestoreCollections.requestServices))
      .where("Email_Requester",arrayContains: employeeFunctionHelper.email);


  // ---------- helpers ----------
  String _s(dynamic v) => (v ?? '').toString();

  double _toMinutes(num value, String unit) {
    switch (unit.toLowerCase()) {
      case 'minutes':
      case 'minute':
      case 'min':
      case 'm':
        return value.toDouble();
      case 'hours':
      case 'hour':
      case 'h':
        return value * 60.0;
      case 'days':
      case 'day':
      case 'd':
        return value * 1440.0;
      case 'weeks':
      case 'week':
      case 'w':
        return value * 10080.0;
      default:
        return value.toDouble();
    }
  }

  double _minutesFromModel(ServicesHistoryModel model) {
    final valStr = model.currentDurationOfServices;
    final unitStr = model.currentSelectedDurationUnit;
    final numVal = num.tryParse(valStr) ?? 0;
    return _toMinutes(numVal, unitStr);
  }

  List<Map<String, dynamic>> _providersFromModel(ServicesHistoryModel model) {
    return model.currentProviderServices.map((e) => e.toJson()).toList();
  }

  DateTime? _timestampFromModel(ServicesHistoryModel model) {
    final ts = model.currentDurationOfServicesTimestamp;
    return ts.toDate();
  }

  String _assignedEmailFromModel(ServicesHistoryModel model) {
    final assignedEmail = model.assigned_Provider_Email;

    if (assignedEmail == null || assignedEmail.isEmpty) {
      return '';
    }

    // Filter out empty/null strings and get last valid email
    final validEmails = assignedEmail
        .where((email) =>
    email != null &&
        email.toString().trim().isNotEmpty &&
        email.toString().trim() != '')
        .map((email) => email.toString().trim().toLowerCase())
        .toList();

    return validEmails.isEmpty ? '' : validEmails.last;
  }

  bool _isActiveStatus(String s) {
    s = s.toLowerCase();
    return s == 'pending' || s == 'approved' || s == 'inprogress' || s == 'done';
  }

  int _seedFrom(String s) => s.codeUnits.fold(0, (a, b) => (a * 31 + b) & 0x7fffffff);

  // ✅ UPDATED: Include all Arabic fields that your UI expects
  Map<String, dynamic> _normalizeProvider(Map<String, dynamic> p) {
    return {
      'email'              : _s(p['email']).toLowerCase(),
      'firstName'          : _s(p['firstName']),
      'lastName'           : _s(p['lastName']),
      'firstNameInArabic'  : _s(p['firstNameInArabic']),
      'lastNameInArabic'   : _s(p['lastNameInArabic']),
      'middleName'         : _s(p['middleName']),
      'middleNameInArabic' : _s(p['middleNameInArabic']),
      'title'              : _s(p['title']),
      'titleInArabic'      : _s(p['titleInArabic']),
      'gender'             : _s(p['gender']),
      'photo'              : _s(p['photo']),
      'department'         : _s(p['department']),
      'departmentId'       : p['departmentId'],
      'workLocation'       : _s(p['workLocation']),
      'role'               : _s(p['role']),
      'status'             : _s(p['status']),
      'supervisor'         : _s(p['supervisor']),
      'mobilePhone'        : _s((p['mobilePhone'] is Map) ? p['mobilePhone']['phone'] : p['mobilePhone']),
      'mobileCountryCode'  : _s((p['mobilePhone'] is Map) ? p['mobilePhone']['countryCode'] : ''),
      'id'                 : p['id'],
      'officePhone'        : p['officePhone'],
      'homePhone'          : p['homePhone'],
      'extension'          : p['extension'],
      'nationality'        : _s(p['nationality']),
      'language'           : _s(p['language']),
      'skills'             : p['skills'],
      'bio'                : _s(p['bio']),
      'hobbies'            : p['hobbies'],
      'academicHistory'    : p['academicHistory'],
      'maritalStatus'      : _s(p['maritalStatus']),
      'birthDay'           : p['birthDay'],
      'nationalId'         : _s(p['nationalId']),
      'passport'           : _s(p['passport']),
      'drivingLicenseId'   : _s(p['drivingLicenseId']),
      'imageUrl'           : _s(p['imageUrl']),
      'country'            : _s(p['country']),
      'state'              : _s(p['state']),
      'city'               : _s(p['city']),
      'province'           : _s(p['province']),
      'street'             : _s(p['street']),
      'postalCode'         : _s(p['postalCode']),
      'carPlates'          : p['carPlates'],
      'activationDate'     : p['activationDate'],
      'deactivationDate'   : p['deactivationDate'],
      'firstLogin'         : p['firstLogin'],
      'lastLogin'          : p['lastLogin'],
      'defaultPassword'    : p['defaultPassword'],
      'password'           : p['password'],
      'nationalIdExpirationDate': p['nationalIdExpirationDate'],
      'passportExpirationDate': p['passportExpirationDate'],
    };
  }

  final now = DateTime.now();
  final cutoff = now.subtract(Duration(days: lookbackDays));
  final startToday = DateTime(now.year, now.month, now.day);
  final endToday = startToday.add(const Duration(days: 1));

  // ---------- accumulators ----------
  final Map<String, double> emailTotalDuration = {};
  final Map<String, int>    emailFrequency     = {};
  final Map<String, int>    emailParentFreq    = {};
  final Map<String, int>    emailTodayCount    = {};

  // 1) Load all requests under this requester scope
  final servicesSnapshot = await userPath.get();

  // locate current doc
  DocumentSnapshot<Map<String, dynamic>>? currentDocSnap;
  ServicesHistoryModel? currentModel;

  for (final doc in servicesSnapshot.docs) {
    if (doc.id == currentServiceDocId) {
      currentDocSnap = doc;
      currentModel = ServicesHistoryModel.fromJson(doc.data()!, doc.id);
      break;
    }
  }

  if (currentDocSnap == null || !currentDocSnap.exists || currentModel == null) return null;

  // scan for load stats
  for (final serviceDoc in servicesSnapshot.docs) {
    final data = serviceDoc.data();
    if (data == null) continue;

    final model = ServicesHistoryModel.fromJson(data, serviceDoc.id);

    // only consider active statuses inside lookback
    final ts = _timestampFromModel(model);
    if (ts == null || ts.isBefore(cutoff)) continue;

    final state = model.currentState;
    if (!_isActiveStatus(state)) continue;

    // providers who were candidates for this service
    final durationInMin = _minutesFromModel(model);
    final providers = _providersFromModel(model);

    for (final p in providers) {
      final email = _s(p['email']).toLowerCase();
      if (email.isEmpty) continue;
      emailTotalDuration[email] = (emailTotalDuration[email] ?? 0) + durationInMin;
      emailFrequency[email]     = (emailFrequency[email]     ?? 0) + 1;
    }

    // track daily assignments for perDayCap
    final assignedEmail = _assignedEmailFromModel(model);
    if (assignedEmail.isNotEmpty && !ts.isBefore(startToday) && ts.isBefore(endToday)) {
      emailTodayCount[assignedEmail] = (emailTodayCount[assignedEmail] ?? 0) + 1;
    }
  }

  final currentParentId = currentModel.currentParentServiceId;
  final currentProvidersRaw = _providersFromModel(currentModel);
  if (currentProvidersRaw.isEmpty) return null;

  // 2) Optional: penalize same-parent recent assignees
  if (rotateWithinSameParent && currentParentId.isNotEmpty) {
    for (final serviceDoc in servicesSnapshot.docs) {
      final data = serviceDoc.data();
      if (data == null) continue;

      final model = ServicesHistoryModel.fromJson(data, serviceDoc.id);

      if (model.currentParentServiceId != currentParentId) continue;

      final ts = _timestampFromModel(model);
      if (ts == null || ts.isBefore(cutoff)) continue;

      final assignedEmail = _assignedEmailFromModel(model);
      if (assignedEmail.isEmpty) continue;

      emailParentFreq[assignedEmail] = (emailParentFreq[assignedEmail] ?? 0) + 1;
    }
  }

  // ---------- if already assigned & we respect it, return that provider ----------
  final existingAssigned = _assignedEmailFromModel(currentModel);
  if (respectExistingAssignment && existingAssigned.isNotEmpty) {
    final found = currentProvidersRaw.firstWhere(
          (p) => _s(p['email']).toLowerCase() == existingAssigned,
      orElse: () => const {},
    );
    if (found.isNotEmpty) {
      return _normalizeProvider(found);
    }
  }

  // 3) Apply daily cap filter if enabled
  List<Map<String, dynamic>> pool;
  if (perDayCap > 0) {
    final filtered = currentProvidersRaw.where((p) {
      final e = _s(p['email']).toLowerCase();
      if (e.isEmpty) return false;
      final usedToday = emailTodayCount[e] ?? 0;
      return usedToday < perDayCap;
    }).toList();

    pool = filtered.isNotEmpty
        ? filtered
        : (allowReassignIfCapExceeded ? currentProvidersRaw : const []);
  } else {
    pool = currentProvidersRaw.toList();
  }

  if (pool.isEmpty) {
    return null;
  }

  if (pool.length == 1) {
    final chosen = _normalizeProvider(pool.first);
    final chosenEmail = chosen['email'] as String;
    await firestore.runTransaction((tx) async {
      final fresh = await tx.get(currentDocSnap!.reference);
      if (!fresh.exists) return;

      final freshModel = ServicesHistoryModel.fromJson(fresh.data()!, fresh.id);
      final freshAssigned = _assignedEmailFromModel(freshModel);

      if (respectExistingAssignment && freshAssigned.isNotEmpty) return;

      tx.update(currentDocSnap!.reference, {
        'assignedProviderEmail': [chosenEmail],
        'assignedProvider'     : [chosenEmail],
      });
    });
    return chosen;
  }

  // 4) Sort by load balancing criteria
  final seed = _seedFrom(currentServiceDocId);
  int tieHash(String email) => _seedFrom('$seed|$email');

  pool.sort((a, b) {
    final ea = _s(a['email']).toLowerCase();
    final eb = _s(b['email']).toLowerCase();

    final da = emailTotalDuration[ea] ?? 0.0;
    final db = emailTotalDuration[eb] ?? 0.0;
    if (da != db) return da.compareTo(db);

    final pa = emailParentFreq[ea] ?? 0;
    final pb = emailParentFreq[eb] ?? 0;
    if (pa != pb) return pa.compareTo(pb);

    final fa = emailFrequency[ea] ?? 0;
    final fb = emailFrequency[eb] ?? 0;
    if (fa != fb) return fa.compareTo(fb);

    return tieHash(ea).compareTo(tieHash(eb));
  });

  // 5) Persist chosen email atomically & return
  final chosen = _normalizeProvider(pool.first);
  final chosenEmail = chosen['email'] as String;

  await firestore.runTransaction((tx) async {
    final fresh = await tx.get(currentDocSnap!.reference);
    if (!fresh.exists) return;

    final freshModel = ServicesHistoryModel.fromJson(fresh.data()!, fresh.id);
    final freshAssigned = _assignedEmailFromModel(freshModel);

    if (respectExistingAssignment && freshAssigned.isNotEmpty) return;

    tx.update(currentDocSnap!.reference, {
      'assignedProviderEmail': [chosenEmail],
      'assignedProvider'     : [chosenEmail],
    });
  });

  // print("✅ RETURNING FULL PROVIDER DATA: $chosen");

  return chosen;
}






/// ******************* FILE INFO *******************
/// File Name: selectServiceProviderApproval_FIXED.dart
/// Description: Fixed version that searches in the correct collection
/// Created by: Amr Mesbah
/// Last Update: [Current Date]

Future<Map<String, dynamic>?> selectServiceProviderApproval(
    String currentServiceDocId, {
      int lookbackDays = 7,
      bool rotateWithinSameParent = false,
      bool respectExistingAssignment = true,
    }) async
{
  if (kDebugMode) print('');
  if (kDebugMode) print('🎯 ========== selectServiceProviderApproval CALLED ==========');
  if (kDebugMode) print('🎯 Request ID: $currentServiceDocId');
  if (kDebugMode) print('🎯 Parameters:');
  if (kDebugMode) print('   - lookbackDays: $lookbackDays');
  if (kDebugMode) print('   - rotateWithinSameParent: $rotateWithinSameParent');
  if (kDebugMode) print('   - respectExistingAssignment: $respectExistingAssignment');
  if (kDebugMode) print('🎯 =========================================================');
  if (kDebugMode) print('');

  final firestore = FirebaseFirestore.instance;
  final String tenantRoot = getBaseUrl(FirestoreCollections.requestServices);
  final now = DateTime.now();
  final cutoff = now.subtract(Duration(days: lookbackDays));

  String _s(dynamic v) => v?.toString() ?? '';

  double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  double _minutesFromModel(ServicesHistoryModel model) {
    final value = _toDouble(model.currentDurationOfServices);
    final unit = _s(model.currentSelectedDurationUnit).toLowerCase();
    switch (unit) {
      case 'minutes': case 'minute': case 'min': case 'm': return value;
      case 'hours':   case 'hour':   case 'h':             return value * 60.0;
      case 'days':    case 'day':    case 'd':             return value * 1440.0;
      case 'weeks':   case 'week':   case 'w':             return value * 10080.0;
      default: return value;
    }
  }

  List<Map<String, dynamic>> _providersFromModel(ServicesHistoryModel model) {
    return model.currentProviderServices.map((e) => e.toJson()).toList();
  }

  DateTime? _timestampFromModel(ServicesHistoryModel model) {
    final t = model.currentDurationOfServicesTimestamp;
    return t?.toDate();
  }

  String _assignedEmailFromModel(ServicesHistoryModel model) {
    final assignedEmail = model.assigned_Provider_Email;

    if (assignedEmail == null || assignedEmail.isEmpty) {
      return '';
    }

    final validEmails = assignedEmail
        .where((email) =>
    email != null &&
        email.toString().trim().isNotEmpty)
        .map((email) => email.toString().trim().toLowerCase())
        .toList();

    return validEmails.isEmpty ? '' : validEmails.last;
  }

  String _extractParentServiceId(dynamic rawValue) {
    if (rawValue == null) return '';

    if (rawValue is List && rawValue.isNotEmpty) {
      return rawValue[0]?.toString() ?? '';
    }

    if (rawValue is String) {
      return rawValue;
    }

    return '';
  }

  int _seedFrom(String s) => s.codeUnits.fold(0, (a, b) => (a * 31 + b) & 0x7fffffff);

  try {
    // ✅ FIXED: Search directly in requestServices collection, not collectionGroup
    if (kDebugMode) print('📍 Searching in collection: $tenantRoot');
    if (kDebugMode) print('📍 Looking for document: $currentServiceDocId');

    // Get the current service document directly
    final currentDocRef = firestore.collection(tenantRoot).doc(currentServiceDocId);
    final currentDocSnapshot = await currentDocRef.get();

    if (!currentDocSnapshot.exists) {
      if (kDebugMode) print('❌ Document not found at path: ${currentDocRef.path}');
      return null;
    }

    if (kDebugMode) print('✅ Document found!');

    final currentData = currentDocSnapshot.data();
    if (currentData == null) {
      if (kDebugMode) print('❌ Document data is null');
      return null;
    }

    final currentModel = ServicesHistoryModel.fromJson(currentData, currentServiceDocId);

    // Extract current parent
    final currentParentRaw = currentData['parentServiceId'];
    final currentParent = _extractParentServiceId(currentParentRaw);
    if (kDebugMode) print('📋 Parent Service ID: $currentParent');

    var currentProviders = _providersFromModel(currentModel);
    if (kDebugMode) print('📋 Available providers: ${currentProviders.length}');

    if (currentProviders.isEmpty) {
      if (kDebugMode) print('⚠️  No providers for this service');
      return null;
    }

    // Log provider details
    for (var i = 0; i < currentProviders.length; i++) {
      if (kDebugMode) print('   Provider $i: ${currentProviders[i]['email']} - ${currentProviders[i]['firstName']} ${currentProviders[i]['lastName']}');
    }

    // Check existing assignment if respectExistingAssignment is true
    if (respectExistingAssignment) {
      final existingAssigned = _assignedEmailFromModel(currentModel);
      if (kDebugMode) print('🔍 Checking existing assignment: $existingAssigned');

      if (existingAssigned.isNotEmpty) {
        final existingProvider = currentProviders.firstWhere(
              (p) => _s(p['email']).toLowerCase() == existingAssigned,
          orElse: () => currentProviders.first,
        );
        if (kDebugMode) print('✅ Using existing assigned provider: $existingAssigned');
        if (kDebugMode) print('   Provider details: ${existingProvider['firstName']} ${existingProvider['lastName']}');
        return existingProvider;
      } else {
        if (kDebugMode) print('⚠️  No existing assignment found');
      }
    }

    if (currentProviders.length == 1) {
      final only = currentProviders.first;
      final email = _s(only['email']).toLowerCase();
      await currentDocRef.update({'assignedProviderEmail': [email]});
      if (kDebugMode) print('✅ Only one provider, assigned: $email');
      return only;
    }

    // Count workload across ALL requests
    final thisServiceProviderEmails = currentProviders
        .map((p) => _s(p['email']).toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet();

    if (kDebugMode) print('📊 Calculating workload for providers: $thisServiceProviderEmails');

    final Map<String, double> emailTotalMinutes = {};
    final Map<String, int>    emailFrequency    = {};
    final Map<String, int>    emailParentFreq   = {};

    // Initialize counters
    for (final email in thisServiceProviderEmails) {
      emailTotalMinutes[email] = 0.0;
      emailFrequency[email] = 0;
      emailParentFreq[email] = 0;
    }

    // ✅ FIXED: Get all documents from requestServices collection
    if (kDebugMode) print('📊 Fetching all requests from: $tenantRoot');
    final allRequestsSnapshot = await firestore.collection(tenantRoot).get();
    if (kDebugMode) print('📊 Found ${allRequestsSnapshot.docs.length} total requests');

    for (final doc in allRequestsSnapshot.docs) {
      try {
        final data = doc.data();
        final model = ServicesHistoryModel.fromJson(data, doc.id);

        final ts = _timestampFromModel(model);
        if (ts != null && ts.isBefore(cutoff)) continue;

        final assignedEmail = _assignedEmailFromModel(model);
        final modelParentId = _extractParentServiceId(data['parentServiceId']);

        // Only count if this provider is in our current service's provider list
        if (assignedEmail.isNotEmpty && thisServiceProviderEmails.contains(assignedEmail)) {
          final minutes = _minutesFromModel(model);
          emailTotalMinutes[assignedEmail] = (emailTotalMinutes[assignedEmail] ?? 0) + minutes;
          emailFrequency[assignedEmail] = (emailFrequency[assignedEmail] ?? 0) + 1;

          if (rotateWithinSameParent && modelParentId == currentParent) {
            emailParentFreq[assignedEmail] = (emailParentFreq[assignedEmail] ?? 0) + 1;
          }
        }
      } catch (e) {
        if (kDebugMode) print('⚠️  Error processing document ${doc.id}: $e');
        continue;
      }
    }

    if (kDebugMode) print('📊 Workload distribution:');
    for (final email in thisServiceProviderEmails) {
      if (kDebugMode) print('  $email: ${emailTotalMinutes[email]?.toStringAsFixed(1)}min, ${emailFrequency[email]} requests');
    }

    // Sort by workload (least busy first)
    currentProviders.sort((a, b) {
      final ea = _s(a['email']).toLowerCase();
      final eb = _s(b['email']).toLowerCase();

      final ma = emailTotalMinutes[ea] ?? 0.0;
      final mb = emailTotalMinutes[eb] ?? 0.0;
      if (ma != mb) return ma.compareTo(mb);

      if (rotateWithinSameParent) {
        final pa = emailParentFreq[ea] ?? 0;
        final pb = emailParentFreq[eb] ?? 0;
        if (pa != pb) return pa.compareTo(pb);
      }

      final fa = emailFrequency[ea] ?? 0;
      final fb = emailFrequency[eb] ?? 0;
      if (fa != fb) return fa.compareTo(fb);

      final seed = _seedFrom(currentServiceDocId);
      int tieHash(String email) => _seedFrom('$seed|$email');
      return tieHash(ea).compareTo(tieHash(eb));
    });

    final chosen = currentProviders.first;
    final chosenEmail = _s(chosen['email']).toLowerCase();

    if (kDebugMode) print('✅ Selected provider: $chosenEmail');
    if (kDebugMode) print('   Provider: ${chosen['firstName']} ${chosen['lastName']}');
    if (kDebugMode) print('   Workload: ${emailTotalMinutes[chosenEmail]?.toStringAsFixed(1)}min, ${emailFrequency[chosenEmail]} requests');

    // Update with clean email
    await currentDocRef.update({'assignedProviderEmail': [chosenEmail]});

    if (kDebugMode) print('🎯 ========== selectServiceProviderApproval SUCCESS ==========');
    if (kDebugMode) print('');

    return chosen;

  } catch (e, stackTrace) {
    if (kDebugMode) print('❌ Error: $e');
    if (kDebugMode) print('❌ Stack: $stackTrace');
    if (kDebugMode) print('🎯 ========== selectServiceProviderApproval FAILED ==========');
    if (kDebugMode) print('');
    return null;
  }
}




Future<void> updateGlobalStateIfFullyApproved({
  required String docId,
  required String serviceName,
  required List<EmployeeEntityModell> approvalCycle,
}) async {
  final firestore = FirebaseFirestore.instance;

  final isAllApproved = approvalCycle.every(
        (e) => e.state?.toLowerCase() == 'approved',
  );

  final isRejected = approvalCycle.any(
        (e) => e.state?.toLowerCase() == 'rejected' || e.state?.toLowerCase() == 'cancel',
  );

  if (isRejected) {
    await updateRequestState(docId, 'rejected');
  } else if (isAllApproved) {
    // ✅ Stop at "approved", wait for manual start to become "inprogress"
    await updateRequestState(docId, 'approved');
    // print("✅ All approvers approved — state updated to 'approved'");
  }
}

//////////////////////////////////////////////////////////////////////////////////


EmployeeEntityPro get employeeEntityFunction {
  final controller = Get.find<MainCoreEmployeeController>();
  if (controller.employeeEntity == null) {
    throw Exception('EmployeeEntity is not initialized yet');
  }
  return controller.employeeEntity!;
}


EmployeeEntityPro get employeeFunctionHelper {
  final controller = Get.find<MainCoreEmployeeController>();
  if (controller.employeeEntity == null) {
    throw Exception('EmployeeEntity is not initialized yet');
  }
  return controller.employeeEntity!;
}


Future<void> updateRequestState(String docId, String newState) async {
  final firestore = FirebaseFirestore.instance;

  final querySnapshot = await firestore
      .collection(getBaseUrl(FirestoreCollections.requestServices))
      .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
      .get();

  final doc = querySnapshot.docs.firstWhere(
        (doc) => doc.id == docId,
    orElse: () => throw Exception("Document not found"),
  );

  await doc.reference.update({
    "state": [newState],
  });

  // print("✅ RequestServices state updated to $newState");
}

Future<void> updateApprovalState(String docId, String newState) async {
  final firestore = FirebaseFirestore.instance;

  // Query to find documents where emailRequester matches
  final querySnapshot = await firestore
      .collection(getBaseUrl(FirestoreCollections.requestServices))
      .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
      .get();

  // Find and update the matching document by ID
  for (var doc in querySnapshot.docs) {
    if (doc.id == docId) {
      await doc.reference.update({
        "state": [newState],
      });
      if (kDebugMode) print("✅ RequestServices state updated to $newState");
      return;
    }
  }

  if (kDebugMode) print("❌ No matching document found");
}



/////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////




Future<void> updateServiceState({
  required String docId,
  required String serviceName,
  required String newState, // "inprogress" or "done"
  required Map<String, dynamic> duration, // { "value": 10, "unit": "hours" }
}) async {
  try {
    final firestore = FirebaseFirestore.instance;

    final querySnapshot = await firestore
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
        .get();

    final doc = querySnapshot.docs.firstWhere(
          (doc) => doc.id == docId,
      orElse: () => throw Exception("Document not found"),
    );

    Map<String, dynamic> updateData = {
      "state": [newState],
    };

    if (newState.toLowerCase() == "inprogress") {
      final DateTime startTime = DateTime.now();
      final dynamic rawValue = duration["value"];
      final double value = rawValue is String ? double.tryParse(rawValue) ?? 0 : (rawValue as num).toDouble();
      final String unit = (duration["unit"] ?? "minutes").toString().toLowerCase();

      Duration calculatedDuration = switch (unit) {
        "hours" => Duration(minutes: (value * 60).toInt()),
        "days" => Duration(minutes: (value * 1440).toInt()),
        "weeks" => Duration(minutes: (value * 10080).toInt()),
        _ => Duration(minutes: value.toInt()),
      };

      final DateTime endTime = startTime.add(calculatedDuration);

      updateData.addAll({
        "startTime": [startTime.toIso8601String()],
        "endTime": [endTime.toIso8601String()],
        "duration": [duration],
      });
    }

    await doc.reference.update(updateData);

    // print("✅ Main RequestServices state updated to '$newState'");
  } catch (e) {
    // print("❌ Error updating service state: $e");
  }
}






/////////////////////////////////////////////////////////////////////////////////////////////////////







/////////////////////////// change from Arroved to Inprogress /////////////////////////////

// await changeStateToInProgress(widget.myRequestDetailsModel.id!);
// this is for call this function

Future<void> changeStateToInProgress(String docId) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final querySnapshot = await firestore
        .collection(getBaseUrl(FirestoreCollections.requestServices))
        .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
        .get();

    final docSnapshot = querySnapshot.docs.firstWhere(
          (doc) => doc.id == docId,
      orElse: () => throw Exception("Document not found"),
    );

    final data = docSnapshot.data();

    // Parse using ServicesHistoryModel
    final model = ServicesHistoryModel.fromJson(data, docId);

    final durationValueStr = model.currentDurationOfServices;
    final durationUnit = model.currentSelectedDurationUnit.toLowerCase();

    if (durationValueStr.isEmpty || durationUnit.isEmpty) {
      // print("❌ Duration fields are missing");
      return;
    }

    final durationValue = double.tryParse(durationValueStr);
    if (durationValue == null) {
      // print("❌ Invalid duration value");
      return;
    }

    Duration calculatedDuration;
    switch (durationUnit) {
      case "hours":
      case "hour":
      case "hr":
        calculatedDuration = Duration(minutes: (durationValue * 60).toInt());
        break;
      case "days":
      case "day":
        calculatedDuration = Duration(minutes: (durationValue * 1440).toInt());
        break;
      case "weeks":
      case "week":
        calculatedDuration = Duration(minutes: (durationValue * 10080).toInt());
        break;
      default:
        calculatedDuration = Duration(minutes: durationValue.toInt());
    }

    final now = DateTime.now();
    final endTime = now.add(calculatedDuration);

    await docSnapshot.reference.update({
      "state": ["inprogress"],
      "startTime": [now.toIso8601String()],
      "endTime": [endTime.toIso8601String()],
      "duration": [{
        "value": durationValue,
        "unit": durationUnit,
      }],
    });

    // print("✅ State updated to inprogress");

  } catch (e) {
    // print("❌ Error: $e");
  }
}

////////////////////////// cancel button /////////////////////////////////

////////////////////////// cancel button /////////////////////////////////

Future<void> cancelAllApprovalCycleStates({
  required String docId,
}) async {
  final firestore = FirebaseFirestore.instance;

  final querySnapshot = await firestore
      .collection(getBaseUrl(FirestoreCollections.requestServices))
      .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
      .get();

  final snapshot = querySnapshot.docs.firstWhere(
        (doc) => doc.id == docId,
    orElse: () => throw Exception("Document not found"),
  );

  final data = snapshot.data();

  // Parse using ServicesHistoryModel
  final model = ServicesHistoryModel.fromJson(data, docId);

  // Get current approval cycle and set all states to 'cancel'
  List<EmployeeEntityModell> updatedApprovalCycle = model.currentApprovalCycle.map((e) {
    return EmployeeEntityModell(
      email: e.email,
      firstName: e.firstName,
      lastName: e.lastName,
      firstNameInArabic: e.firstNameInArabic,
      lastNameInArabic: e.lastNameInArabic,
      middleName: e.middleName,
      middleNameInArabic: e.middleNameInArabic,
      title: e.title,
      titleInArabic: e.titleInArabic,
      gender: e.gender,
      photo: e.photo,
      departmentId: e.departmentId,
      workLocation: e.workLocation,
      role: e.role,
      status: e.status,
      supervisor: e.supervisor,
      mobilePhone: e.mobilePhone,
      id: e.id,
      officePhone: e.officePhone,
      homePhone: e.homePhone,
      extension: e.extension,
      nationality: e.nationality,
      language: e.language,
      skills: e.skills,
      bio: e.bio,
      hobbies: e.hobbies,
      academicHistory: e.academicHistory,
      maritalStatus: e.maritalStatus,
      birthDay: e.birthDay,
      nationalId: e.nationalId,
      passport: e.passport,
      drivingLicenseId: e.drivingLicenseId,
      imageUrl: e.imageUrl,
      country: e.country,
      state: 'cancel', // ✅ Set state to cancel
      city: e.city,
      province: e.province,
      street: e.street,
      postalCode: e.postalCode,
      carPlates: e.carPlates,
      activationDate: e.activationDate,
      deactivationDate: e.deactivationDate,
      firstLogin: e.firstLogin,
      lastLogin: e.lastLogin,
      defaultPassword: e.defaultPassword,
      password: e.password,
      nationalIdExpirationDate: e.nationalIdExpirationDate,
      passportExpirationDate: e.passportExpirationDate,
    );
  }).toList();

  // Convert to JSON string for storage
  final updatedApprovalCycleJson = jsonEncode(updatedApprovalCycle.map((e) => e.toJson()).toList());

  await snapshot.reference.update({
    'approvalCycle': [updatedApprovalCycleJson],
    'state': ['cancel'], // Optional: sync state field too
  });

  // print("✅ All approvalCycle states set to 'cancel'");
}

//////////////////////////////////// get number of all services as flow Chart ////////////////////////////////////


Future<Map<String, int>> calculateServiceStates({
  String? filterServiceName,
}) async {
  // print("🔍 calculateServiceStates - Starting...");
  // print("📌 Filter Service Name: '${filterServiceName ?? 'None'}'");

  final firestore = FirebaseFirestore.instance;

  final snapshot = await firestore
      .collection(getBaseUrl(FirestoreCollections.requestServices))
      .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
      .get();

  int done = 0;
  int inProgress = 0;
  int approved = 0;
  int rejected = 0;
  int pending = 0;
  int cancel = 0;
  int branchSla = 0;

  int totalProcessed = 0;
  int matchedCount = 0;

  for (var doc in snapshot.docs) {
    totalProcessed++;

    try {
      final service = ServicesHistoryModel.fromJson(doc.data(), doc.id);

      // ✅ Filter by service name if provided
      if (filterServiceName != null &&
          service.currentServiceNameEnglish != filterServiceName) {
        continue;
      }

      matchedCount++;

      final stateField = service.currentState.toLowerCase();
      String finalState = '';

      // ✅ Check direct states first (except 'active' and 'pending')
      if (['done', 'inprogress', 'cancel', 'branchsla', 'breached sla', 'approved', 'rejected']
          .contains(stateField)) {
        finalState = stateField;
      }

      // ✅ If state is 'active' or 'pending' OR not set, check approval cycle
      if (finalState.isEmpty || stateField == 'active' || stateField == 'pending') {
        final approvers = service.currentApprovalCycle;
        final states = approvers.map((e) => e.state?.toLowerCase() ?? '').toList();

        if (states.isEmpty) {
          // If no approval cycle, treat 'pending' as pending, 'active' as inprogress
          if (stateField == 'pending') {
            finalState = 'pending';
          } else if (stateField == 'active') {
            finalState = 'inprogress';
          }
        } else {
          // Check approval cycle states
          if (states.contains('cancel')) {
            finalState = 'cancel';
          } else if (states.contains('rejected')) {
            finalState = 'rejected';
          } else if (states.every((s) => s == 'approved')) {
            finalState = 'approved';
          } else if (states.contains('pending')) {
            finalState = 'pending';
          }
        }
      }

      // print('📊 Doc ${doc.id}: state = "$finalState"');

      switch (finalState) {
        case 'done':
          done++;
          break;
        case 'inprogress':
          inProgress++;
          break;
        case 'approved':
          approved++;
          break;
        case 'rejected':
          rejected++;
          break;
        case 'pending':
          pending++;
          break;
        case 'cancel':
          cancel++;
          break;
        case 'branchsla':
        case 'breached sla':
          branchSla++;
          break;
      }
    } catch (e) {
      // print("❌ Error calculating states for doc ${doc.id}: $e");
    }
  }

  final result = {
    'done': done,
    'inprogress': inProgress,
    'approved': approved,
    'pending': pending,
    'rejected': rejected,
    'cancel': cancel,
    'branchsla': branchSla,
  };

  // print('✅ calculateServiceStates complete:');
  // print('   - Total docs processed: $totalProcessed');
  // print('   - Matched service name: $matchedCount');
  // print('   - Status counts: $result');

  return result;
}







////////////////////////////// function to calc number of services in every month /////////////////


Future<Map<String, int>> countServicesPerMonth(int year) async {
  final firestore = FirebaseFirestore.instance;

  final querySnapshot = await firestore
      .collection(getBaseUrl(FirestoreCollections.requestServices))
      .where("Email_Requester", arrayContains: employeeFunctionHelper.email)
      .get();

  final Map<String, int> monthCount = {
    'January': 0,
    'February': 0,
    'March': 0,
    'April': 0,
    'May': 0,
    'June': 0,
    'July': 0,
    'August': 0,
    'September': 0,
    'October': 0,
    'November': 0,
    'December': 0,
  };

  for (var doc in querySnapshot.docs) {
    final data = doc.data();

    // Parse using ServicesHistoryModel
    final model = ServicesHistoryModel.fromJson(data, doc.id);
    final timestamp = model.currentDurationOfServicesTimestamp;

    final date = timestamp.toDate();
    if (date.year == year) {
      final monthIndex = date.month; // 1 = January, 12 = December
      final monthName = monthCount.keys.elementAt(monthIndex - 1);
      monthCount[monthName] = (monthCount[monthName] ?? 0) + 1;
    }
  }

  return monthCount;
}
