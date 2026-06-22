import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/network/get_base_url.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/services_management_module/data/models/services_history_model.dart';

import 'package:demo_app/core/constants/services_management/constant.dart';

/// ******************* FILE INFO *******************
/// File Name: firebase_draft_repository.dart
/// Description: Repository for saving/loading drafts from Firebase
/// Drafts are saved in the MAIN CreateServices collection with status="draft"
/// *************************************************

class FirebaseDraftRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Page identifiers
  static const int pageCreateService = 1;      // CreateNewServicesLayout
  static const int pageSelectProvider = 2;     // ServicesProviderLayout
  static const int pageDetailsApproval = 3;    // DetailsToggleScreen
  static const int pageSlaNotification = 4;    // ToggleSlaScreen

  /// Get current user email
  String get _currentUserEmail {
    try {
      final controller = Get.find<MainCoreEmployeeController>();
      return controller.employeeEntity?.email ?? '';
    } catch (e) {
      return '';
    }
  }

  /// 🔥 Get the main CreateServices collection path
  String get _createServicesPath {
    return getBaseUrl(FirestoreCollections.createServices);
  }

  /// Save draft to MAIN CreateServices collection with draft status
  Future<String> saveDraft({
    required ServicesHistoryModel model,
    required int currentPage,
    String? existingDraftId,
  }) async {
    try {
      final userEmail = _currentUserEmail;
      if (userEmail.isEmpty) {
        throw Exception('User not authenticated');
      }

      // ✅ CRITICAL FIX: Check if we should update existing or create new
      String draftId;
      bool isUpdate = false;

      if (existingDraftId != null && existingDraftId.isNotEmpty) {
        // Check if document actually exists
        final existingDoc = await _firestore
            .collection(_createServicesPath)
            .doc(existingDraftId)
            .get();

        if (existingDoc.exists) {
          draftId = existingDraftId;
          isUpdate = true;
        } else {
          // Document doesn't exist, create new
          draftId = 'draft_${DateTime.now().millisecondsSinceEpoch}_$userEmail';
          isUpdate = false;
        }
      } else {
        // No existing ID, create new
        draftId = 'draft_${DateTime.now().millisecondsSinceEpoch}_$userEmail';
        isUpdate = false;
      }

      // Build draft data
      final modelJson = model.toJsonForCreate();
      final cleanedJson = _cleanEmptyValues(modelJson);

      final draftData = {
        ...cleanedJson,

        // Draft metadata
        'draftMetadata': {
          'draftId': draftId,
          'createdAt': isUpdate
              ? (await _firestore.collection(_createServicesPath).doc(draftId).get()).data()?['draftMetadata']?['createdAt']
              ?? FieldValue.serverTimestamp()
              : FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': userEmail,
          'currentPage': currentPage,
          'isDraft': true,
          'draftState': 'in_progress',
        },

        // Override status and state to be draft
        'status': ['draft'],
        'state': ['draft'],

        // ✅ Ensure ID is set in the data too
        'id': [draftId],
      };

      if (isUpdate) {
        // ✅ UPDATE existing document
        await _firestore
            .collection(_createServicesPath)
            .doc(draftId)
            .update(draftData);
      } else {
        // ✅ CREATE new document
        await _firestore
            .collection(_createServicesPath)
            .doc(draftId)
            .set(draftData, SetOptions(merge: true));
      }

      return draftId;

    } catch (e, stackTrace) {
      rethrow;
    }
  }

  /// 🔥 NEW: Helper to clean empty/placeholder values from JSON
  Map<String, dynamic> _cleanEmptyValues(Map<String, dynamic> json) {
    final cleaned = <String, dynamic>{};

    json.forEach((key, value) {
      if (value == null) return; // Skip nulls

      if (value is List) {
        // Skip empty lists
        if (value.isEmpty) return;

        // Skip lists containing only empty strings
        if (value.every((item) => item == null || item == '' || item == '[]' || item == '""')) {
          return;
        }

        // For lists with actual values, keep them
        cleaned[key] = value;
      } else if (value is String) {
        // Skip empty strings
        if (value.isEmpty || value == '[]' || value == '""') return;
        cleaned[key] = value;
      } else if (value is Map) {
        // Recursively clean nested maps
        final cleanedMap = _cleanEmptyValues(Map<String, dynamic>.from(value));
        if (cleanedMap.isNotEmpty) {
          cleaned[key] = cleanedMap;
        }
      } else {
        // Keep other types (numbers, booleans, timestamps)
        cleaned[key] = value;
      }
    });

    return cleaned;
  }

  /// Update existing draft with new page progress
  Future<void> updateDraftPage({
    required String draftId,
    required int currentPage,
    required ServicesHistoryModel updatedModel,
  }) async {
    try {
      final userEmail = _currentUserEmail;

      final updateData = {
        ...updatedModel.toJson(),
        'draftMetadata.updatedAt': FieldValue.serverTimestamp(),
        'draftMetadata.currentPage': currentPage,
        // Ensure it stays as draft
        'status': ['draft'],
        'state': ['draft'],
      };

      final path = _createServicesPath;

      await _firestore
          .collection(path)
          .doc(draftId)
          .update(updateData);

    } catch (e) {
      rethrow;
    }
  }

  /// Get all drafts for current user from CreateServices collection
  /// Get all drafts for current user from CreateServices collection
  Future<List<ServicesHistoryModel>> getUserDrafts() async {
    try {
      final userEmail = _currentUserEmail;
      if (userEmail.isEmpty) {
        return [];
      }

      final path = _createServicesPath;

      QuerySnapshot<Map<String, dynamic>> snapshot;

      try {
        // Query for documents where status is draft AND created by this user
        // AND draftState is still in_progress
        snapshot = await _firestore
            .collection(path)
            .where('status', arrayContains: 'draft')
            .where('draftMetadata.createdBy', isEqualTo: userEmail)
            .where('draftMetadata.draftState', isEqualTo: 'in_progress')
            .orderBy('draftMetadata.updatedAt', descending: true)
            .get();
      } catch (e) {
        // Fallback without orderBy
        snapshot = await _firestore
            .collection(path)
            .where('status', arrayContains: 'draft')
            .where('draftMetadata.createdBy', isEqualTo: userEmail)
            .where('draftMetadata.draftState', isEqualTo: 'in_progress')
            .get();
      }

      // ✅ ADDITIONAL FILTER: Double-check in memory to ensure no published drafts slip through
      final drafts = snapshot.docs
          .where((doc) {
        final data = doc.data();
        final draftState = data['draftMetadata']?['draftState'];
        final status = data['status'];

        // Extra safety: ensure it's still a draft
        bool isDraftStatus = false;
        if (status is List && status.isNotEmpty) {
          isDraftStatus = status.last == 'draft';
        } else if (status is String) {
          isDraftStatus = status == 'draft';
        }

        return draftState == 'in_progress' && isDraftStatus;
      })
          .map((doc) {
        final data = doc.data();
        final model = ServicesHistoryModel.fromJson(data, doc.id);
        return model;
      })
          .toList();

      return drafts;

    } catch (e, stackTrace) {
      return [];
    }
  }

  /// Get specific draft with page info
  Future<DraftWithPage?> getDraftWithPage(String draftId) async {
    try {
      final path = _createServicesPath;

      final doc = await _firestore
          .collection(path)
          .doc(draftId)
          .get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data()!;

      // Verify it's actually a draft
      final status = data['status'];
      bool isDraft = false;
      if (status is List && status.isNotEmpty) {
        isDraft = status.last == 'draft';
      } else if (status is String) {
        isDraft = status == 'draft';
      }

      if (!isDraft) {
        return null;
      }

      // ✅ CRITICAL: Ensure the ID is set in the data before parsing
      data['id'] = [draftId]; // Set the ID to the draft ID

      final model = ServicesHistoryModel.fromJson(data, doc.id);

      // Extract page from metadata
      final metadata = data['draftMetadata'] as Map<String, dynamic>?;
      final currentPage = metadata?['currentPage'] as int? ?? pageCreateService;

      return DraftWithPage(
        model: model,
        currentPage: currentPage,
        draftId: draftId,
      );

    } catch (e) {
      return null;
    }
  }

  /// Mark draft as completed (when user finishes or cancels)
  Future<void> deleteDraft(String draftId) async {
    try {
      final path = _createServicesPath;

      // Instead of deleting, mark as completed
      // This keeps the history but removes from active drafts
      await _firestore
          .collection(path)
          .doc(draftId)
          .update({
        'draftMetadata.draftState': 'completed',
        'draftMetadata.completedAt': FieldValue.serverTimestamp(),
        // Optionally change status to inactive or keep as draft for history
        // 'status': ['inactive'],
      });

    } catch (e) {
    }
  }

  /// Permanently delete draft (rarely used)
  Future<void> permanentlyDeleteDraft(String draftId) async {
    try {
      final path = _createServicesPath;

      await _firestore
          .collection(path)
          .doc(draftId)
          .delete();

    } catch (e) {
    }
  }

  /// Publish draft - convert to active service
  /// Publish draft - convert to active service
  Future<String> publishDraft(
      String draftId,
      ServicesHistoryModel completeModel
      ) async {
    try {
      final path = _createServicesPath;

      // Generate new service ID if needed (optional - you can keep same ID)
      final now = DateTime.now();
      final formattedDate = "${_monthAbbreviation(now.month)}${now.day}_${now.year}";
      final randomId = now.millisecondsSinceEpoch % 100000;
      final newServiceId = "SRV$randomId$formattedDate";

      // Option 1: Update existing document to active status (keeps same ID)
      await _firestore
          .collection(path)
          .doc(draftId)
          .update({
        ...completeModel.toJsonForCreate(),
        'status': ['active'],
        'state': ['active'],
        'draftMetadata.draftState': 'published',
        'draftMetadata.publishedAt': FieldValue.serverTimestamp(),
        'draftMetadata.publishedServiceId': newServiceId, // Optional: track new ID
        'id': [newServiceId], // Update to new service ID
      });

      // Note: The cubit will handle clearing its draft tracking
      return draftId;

    } catch (e) {
      rethrow;
    }
  }

  /// Alternative: Publish by creating new document and deleting draft
  Future<String> publishDraftAsNew(
      String draftId,
      ServicesHistoryModel completeModel
      ) async {
    try {
      // Generate new service ID
      final now = DateTime.now();
      final formattedDate = "${_monthAbbreviation(now.month)}${now.day}_${now.year}";
      final randomId = now.millisecondsSinceEpoch % 100000;
      final serviceId = "User$randomId$formattedDate";

      final path = _createServicesPath;

      // Create new active service
      await _firestore
          .collection(path)
          .doc(serviceId)
          .set({
        ...completeModel.toJson(),
        'status': ['active'],
        'state': ['active'],
        'publishedAt': FieldValue.serverTimestamp(),
        'draftId': draftId,  // Reference to original draft
      });

      // Mark original draft as published
      await _firestore
          .collection(path)
          .doc(draftId)
          .update({
        'draftMetadata.draftState': 'published',
        'draftMetadata.publishedAt': FieldValue.serverTimestamp(),
        'draftMetadata.publishedServiceId': serviceId,
      });

      return serviceId;

    } catch (e) {
      rethrow;
    }
  }

  String _monthAbbreviation(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

/// Helper class to return draft with page info
class DraftWithPage {
  final ServicesHistoryModel model;
  final int currentPage;
  final String draftId;

  DraftWithPage({
    required this.model,
    required this.currentPage,
    required this.draftId,
  });
}
