import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../../../main_core/core/networking/get_base_url.dart';
import '../../../../../../main_core/features/employee/domain/entities/employee_entity.dart';
import '../../../../../../main_core/features/employee/presentation/controller/main_core_employee_controller.dart';

import '../../../core/enums/task_priority_enum.dart';
import '../../../core/enums/task_status_enum.dart';
import '../../data/models/items_data.dart';
import '../../data/models/task_model_updates_with_field_history.dart';

class TaskFirebaseService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  var employeeEntity =
      Get.find<MainCoreEmployeeController>().employeeEntity ?? EmployeeEntityPro();

  // Path: Demo > 84763782 > Creating_Task > TaskId
  CollectionReference get _tasksCollection {
    return _fireStore

        .collection(getBaseUrl('Creating_Task'));
  }

  Future<String> createTask(TaskModel task) async {
    try {
      print('🔥 === createTask STARTED ===');

      // Let Firebase generate the ID automatically
      print('📝 Creating document reference...');
      DocumentReference docRef = _tasksCollection.doc();
      String newTaskId = docRef.id;
      print('✅ Firebase generated ID: $newTaskId');

      // Set task ID
      if (task.taskId.current == null || task.taskId.current!.isEmpty) {
        task.taskId.add(newTaskId);
        print('✅ Task ID added to task');
      }

      print('📦 Converting task to Firestore format...');
      Map<String, dynamic> taskData;
      try {
        taskData = task.toFirestore();
        print('✅ Task converted successfully');
      } catch (e, stack) {
        print('❌ Error in toFirestore(): $e');
        print('Stack: $stack');
        throw Exception('Failed to convert task to Firestore format: $e');
      }

      print('💾 Writing to Firebase...');
      print('📍 Document ID: $newTaskId');

      try {
        await docRef.set(taskData);
        print('✅ Task written to Firebase successfully');
      } catch (e, stack) {
        print('❌ Firebase write error: $e');
        print('Stack: $stack');
        throw Exception('Failed to write to Firebase: $e');
      }

      print('📝 Updating Edit_By...');
      try {
        await _updateEditBy();
        print('✅ Edit_By updated');
      } catch (e) {
        print('⚠️ Failed to update Edit_By (non-critical): $e');
      }

      print('✅ === createTask COMPLETED ===');
      return newTaskId;

    } catch (e, stack) {
      print('❌ ========================================');
      print('❌ CRITICAL ERROR IN createTask');
      print('❌ Error: $e');
      print('❌ Stack trace: $stack');
      print('❌ ========================================');
      throw Exception('Error creating task: $e');
    }
  }



  // Future<String> createTask(TaskModel task) async {
  //   try {
  //     DocumentReference docRef = await _tasksCollection.add(task.toFirestore());
  //
  //     await _updateEditBy();
  //
  //     return docRef.id;
  //   } catch (e) {
  //     throw Exception('Error creating task: $e');
  //   }
  // }

  Future<TaskModel?> getTask(String taskId) async {
    try {
      DocumentSnapshot doc = await _tasksCollection.doc(taskId).get();

      if (doc.exists) {
        return TaskModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting task: $e');
    }
  }

  Future<void> updateTask(String taskId, TaskModel task) async {
    try {
      await _tasksCollection.doc(taskId).update(task.toFirestore());

      await _updateEditBy();
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      DocumentSnapshot doc = await _tasksCollection.doc(taskId).get();
      if (!doc.exists) return;

      TaskModel task = TaskModel.fromFirestore(doc);
      task.taskStatus.add(TaskStatus.deleted);

      await _tasksCollection.doc(taskId).update(task.toFirestore());
      await _updateEditBy();
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }

  // 🔹 جلب كل التاسكات
  Stream<List<TaskModel>> getAllTasks() {
    return _tasksCollection.snapshots().map(
          (snapshot) =>
          snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList(),
    );
  }

  Stream<List<TaskModel>> getTasksByStatus(String status) {
    return _tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .where((task) => task.taskStatus.current == status)
          .toList();
    });
  }

  Stream<List<TaskModel>> getToDoTasks() {
    return getAllTasks().map((tasks) {
      final now = DateTime.now();

      return tasks.where((task) {
        final isToDo = task.taskStatus.current == TaskStatus.toDo;
        final notDeleted = task.taskStatus.current != TaskStatus.deleted;

        // Don't filter by overdue here - let getOverdueTasks handle it
        final notOverdue = !isTaskOverdue(task, now);

        return isToDo && notDeleted && notOverdue;
      }).toList();
    });
  }
  Stream<List<TaskModel>> getDoneTasks() {
    return getAllTasks().map((tasks) {
      return tasks
          .where((task) =>
      task.taskStatus.current == TaskStatus.done &&
          task.taskStatus.current != TaskStatus.deleted)
          .toList();
    });
  }
  Stream<List<TaskModel>> getScheduledTasks() {
    return getAllTasks().map((tasks) {
      final now = DateTime.now();

      return tasks.where((task) {
        final isScheduled = task.taskStatus.current == TaskStatus.scheduled;
        final notDeleted = task.taskStatus.current != TaskStatus.deleted;

        // Don't filter by overdue here
        final notOverdue = !isTaskOverdue(task, now);

        return isScheduled && notDeleted && notOverdue;
      }).toList();
    });
  }
  Stream<List<TaskModel>> getDeletedTasks() =>
      getTasksByStatus(TaskStatus.deleted);

  final now = DateTime.now();

  bool isSameDay(DateTime date1, [DateTime? date2]) {
    final d2 = date2 ?? DateTime.now();
    return date1.year == d2.year &&
        date1.month == d2.month &&
        date1.day == d2.day;
  }

  Stream<List<TaskModel>> getOverdueTasks() {
    return getAllTasks().map((tasks) {
      final now = DateTime.now();
      return tasks
          .where((task) =>
      task.taskStatus.current != TaskStatus.deleted &&
          isTaskOverdue(task, now))
          .toList();
    });
  }
  // Helper method
  bool isTaskOverdue(TaskModel task, DateTime now) {
    final scheduled = task.currentScheduled;
    if (scheduled == null) return false;

    final endDate = scheduled.taskEndDate;
    if (endDate == null) return false;

    final endTimeString = scheduled.taskEndTime; // This is a String like "14:30"
    final isNotDone = task.taskStatus.current != TaskStatus.done;

    if (endTimeString != null && endTimeString.isNotEmpty) {
      // Scenario 1: End Date + End Time
      // Parse the time string (format: "HH:mm" or "HH:mm AM/PM")
      try {
        final timeParts = endTimeString.split(':');
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1].split(' ')[0]); // Remove AM/PM if exists

        // Combine end date with end time
        final endDateTime = DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          hour,
          minute,
        );

        return now.isAfter(endDateTime) && isNotDone;
      } catch (e) {
        print('⚠️ Error parsing end time: $e');
        // If parsing fails, treat as date-only
        final deadlineReached = endDate.isBefore(now) || isSameDay(endDate, now);
        return deadlineReached && isNotDone;
      }
    } else {
      // Scenario 2: Only End Date (becomes overdue at start of that day)
      final deadlineReached = endDate.isBefore(now) || isSameDay(endDate, now);
      return deadlineReached && isNotDone;
    }
  }


  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    try {
      DocumentSnapshot doc = await _tasksCollection.doc(taskId).get();
      if (!doc.exists) return;

      TaskModel task = TaskModel.fromFirestore(doc);

      List<ItemData> currentItemsList = task.currentItems ?? [];

      if (newStatus.toLowerCase() == TaskStatus.done) {
        print('✅ Status is Done - marking all items as Done');

        List<ItemData> updatedItems = currentItemsList.map((item) {
          return ItemData(
            itemId: item.itemId,
            itemName: item.itemName,
            itemStatus: TaskStatus.done,
          );
        }).toList();

        String itemsJson = jsonEncode(
          updatedItems.map((e) => e.toMap()).toList(),
        );
        task.items.add(itemsJson);
      } else {
        if (task.items.values.length >= 2) {
          String previousItemsJson =
          task.items.values[task.items.values.length - 2];
          print('📦 Previous items JSON: $previousItemsJson');

          task.items.add(previousItemsJson);
        } else {
          print('⚠️ No previous items history, keeping current items');
          String currentItemsJson = jsonEncode(
            currentItemsList.map((e) => e.toMap()).toList(),
          );
          task.items.add(currentItemsJson);
        }
      }

      task.taskStatus.add(newStatus);
      print('📦 Task status updated to: $newStatus');

      int updateCount = task.taskStatus.values.length;
      DateTime lastTimestamp = DateTime.now();

      final allFields = {
        'taskId': task.taskId,
        'name': task.name,
        'description': task.description,
        'items': task.items,
        'taskStatus': task.taskStatus,
        'priority': task.priority,
        'scheduled': task.scheduled,
        'frequency': task.frequency,
        'creatorEmail': task.creatorEmail,
      };

      allFields.forEach((key, fieldHistory) {
        if (key == 'taskStatus' || key == 'items') return;

        while (fieldHistory.values.length < updateCount) {
          fieldHistory.add(fieldHistory.current ?? '');
        }

        if (fieldHistory.timestamps.isNotEmpty) {
          fieldHistory.timestamps[fieldHistory.timestamps.length - 1] =
              lastTimestamp;
        }
      });

      final dataToSave = task.toFirestore();
      print('💾 Data to save: $dataToSave');

      await _tasksCollection.doc(taskId).update(dataToSave);
      await _updateEditBy();

      print('✅ Task status and items updated successfully');

      DocumentSnapshot verifyDoc = await _tasksCollection.doc(taskId).get();
      print('🔍 Verification - task status: ${verifyDoc.get('taskStatus')}');
      print('🔍 Verification - items: ${verifyDoc.get('items')}');
    } catch (e, stack) {
      print('❌ Error updating task status: $e');
      print('Stack: $stack');
      throw Exception('❌ Error updating task status and syncing fields: $e');
    }
  }

  Future<void> updateItemStatus(String taskId, String newStatus) async {
    try {
      DocumentSnapshot doc = await _tasksCollection.doc(taskId).get();
      if (!doc.exists) return;

      TaskModel task = TaskModel.fromFirestore(doc);
      task.taskStatus.add(newStatus);

      await _tasksCollection.doc(taskId).update(task.toFirestore());
      await _updateEditBy();
    } catch (e) {
      throw Exception('Error updating task status: $e');
    }
  }

  Future<void> _updateEditBy() async {
    try {
      if (employeeEntity.email == null) return;

      final docRef = _fireStore.collection('Demo').doc('84763782');
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) return;

      List<dynamic> editBy = docSnapshot.data()?['Edit_By'] ?? [];

      editBy.add({
        'email': employeeEntity.email,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      });

      await docRef.update({'Edit_By': editBy});
    } catch (e) {
      print('Error updating Edit_By: $e');
    }
  }

  Stream<List<TaskModel>> searchTasks(String query) {
    return _tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).where((
          task,
          ) {
        final name = task.name.current?.toLowerCase() ?? '';
        final desc = task.description.current?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) ||
            desc.contains(query.toLowerCase());
      }).toList();
    });
  }

  Stream<List<TaskModel>> getTasksByPriority(String priority) {
    return _tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .where(
            (task) =>
        task.priority.current == priority &&
            task.taskStatus.current != TaskStatus.deleted,
      )
          .toList();
    });
  }

  List<TaskModel> getTasksFiltersAndSort(
      List<TaskModel> tasks,
      String searchQuery,
      int selectedPriority,
      int selectedSort,
      ) {
    List<TaskModel> filteredTasks = tasks.where((t) {
      final matchesSearch = t.name.current!.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      bool matchesPriority = true;
      switch (selectedPriority) {
        case 1:
          matchesPriority = t.priority.current == TaskPriority.high;
          break;
        case 2:
          matchesPriority = t.priority.current == TaskPriority.medium;
          break;
        case 3:
          matchesPriority = t.priority.current == TaskPriority.low;
          break;
        default:
          matchesPriority = true;
      }

      return matchesSearch && matchesPriority;
    }).toList();

    if (selectedSort != -1) {
      switch (selectedSort) {
        case 0: // Sort by End Date
          filteredTasks.sort((a, b) {
            final dateA = a.currentScheduled?.taskEndDate;
            final dateB = b.currentScheduled?.taskEndDate;
            if (dateA == null && dateB == null) return 0;
            if (dateA == null) return 1;
            if (dateB == null) return -1;
            return dateA.compareTo(dateB);
          });
          break;

        case 1: // Sort by Frequency
          filteredTasks.sort((a, b) {
            final freqA = a.currentFrequency?.frequencyUnit ?? '';
            final freqB = b.currentFrequency?.frequencyUnit ?? '';
            if (freqA.isEmpty && freqB.isEmpty) return 0;
            if (freqA.isEmpty) return 1;
            if (freqB.isEmpty) return -1;
            return freqA.compareTo(freqB);
          });
          break;

        case 2: // Sort by Scheduled status
          filteredTasks.sort((a, b) {
            final isScheduledA = a.taskStatus.current == TaskStatus.scheduled
                ? 0
                : 1;
            final isScheduledB = b.taskStatus.current == TaskStatus.scheduled
                ? 0
                : 1;
            return isScheduledA.compareTo(isScheduledB);
          });
          break;
      }
    }

    return filteredTasks;
  }

  void updateTaskStatusUi(TaskModel task) {
    final String taskId = task.taskId.current ?? '';
    final String currentStatus = task.taskStatus.current ?? '';

    // ✅ FIX: If task is deleted, do nothing - prevent status change
    if (currentStatus == TaskStatus.deleted) {
      print('⚠️ Task is deleted, cannot change status via checkbox');
      return;
    }

    if (currentStatus == TaskStatus.done) {
      final List<String> history = task.taskStatus.values;

      String? previousStatus;
      for (int i = history.length - 2; i >= 0; i--) {
        if (history[i] != TaskStatus.done) {
          previousStatus = history[i];
          break;
        }
      }

      previousStatus ??= TaskStatus.toDo;

      updateTaskStatus(taskId, previousStatus);
    } else {
      updateTaskStatus(taskId, TaskStatus.done);
    }
  }

  updateItemStatusUi(ItemData item) {
    if (item.itemStatus == TaskStatus.done) {
      updateItemStatus(item.itemStatus ?? '', TaskStatus.toDo);
    } else {
      updateTaskStatus(item.itemStatus ?? '', TaskStatus.done);
    }
  }

  Future<void> addItemToTask(String taskId, ItemData newItem) async {
    try {
      DocumentSnapshot doc = await _tasksCollection.doc(taskId).get();
      if (!doc.exists) {
        return;
      }

      TaskModel task = TaskModel.fromFirestore(doc);

      List<ItemData> currentItemsList = task.currentItems ?? [];

      currentItemsList.add(newItem);

      String itemsJson = jsonEncode(
        currentItemsList.map((e) => e.toMap()).toList(),
      );

      task.items.add(itemsJson);

      int updateCount = task.items.values.length;

      DateTime lastTimestamp = DateTime.now();

      final allFields = {
        'taskId': task.taskId,
        'name': task.name,
        'description': task.description,
        'items': task.items,
        'taskStatus': task.taskStatus,
        'priority': task.priority,
        'scheduled': task.scheduled,
        'frequency': task.frequency,
        'creatorEmail': task.creatorEmail,
      };

      allFields.forEach((key, fieldHistory) {
        if (key == 'items') return;

        while (fieldHistory.values.length < updateCount) {
          fieldHistory.add(fieldHistory.current ?? '');
        }

        if (fieldHistory.timestamps.isNotEmpty) {
          fieldHistory.timestamps[fieldHistory.timestamps.length - 1] =
              lastTimestamp;
        }
      });

      final dataToSave = task.toFirestore();

      await _tasksCollection.doc(taskId).update(dataToSave);
      await _updateEditBy();

      DocumentSnapshot verifyDoc = await _tasksCollection.doc(taskId).get();
    } catch (e, stack) {
      print('❌ Error adding item: $e');
      print('Stack: $stack');
      throw Exception('Error adding item: $e');
    }
  }

  Future<void> deleteItemFromTask(String taskId, ItemData itemToRemove) async {
    try {
      print('🔥🔥🔥 === Deleting Item ===');
      print('Task ID: $taskId');
      print('Item to remove: ${itemToRemove.toMap()}');

      DocumentSnapshot doc = await _tasksCollection.doc(taskId).get();
      if (!doc.exists) {
        print('❌ Document does not exist!');
        return;
      }

      print('✅ Document loaded');
      TaskModel task = TaskModel.fromFirestore(doc);

      print('📦 Current items.values: ${task.items.values}');
      print('📦 Current items.current: ${task.items.current}');

      List<ItemData> currentItemsList = task.currentItems ?? [];
      print(
        '📋 Current items list length BEFORE delete: ${currentItemsList.length}',
      );

      // احذف الـ item
      currentItemsList.removeWhere((e) => e.itemId == itemToRemove.itemId);
      print(
        '📋 Current items list length AFTER delete: ${currentItemsList.length}',
      );

      // حول لـ JSON وحفظ
      String itemsJson = jsonEncode(
        currentItemsList.map((e) => e.toMap()).toList(),
      );
      print('📦 JSON to save: $itemsJson');

      task.items.add(itemsJson);
      print('📦 items.values after add: ${task.items.values}');

      // مزامنة باقي الـ fields
      int updateCount = task.items.values.length;
      print('🔢 Update count: $updateCount');

      DateTime lastTimestamp = DateTime.now();

      final allFields = {
        'taskId': task.taskId,
        'name': task.name,
        'description': task.description,
        'items': task.items,
        'taskStatus': task.taskStatus,
        'priority': task.priority,
        'scheduled': task.scheduled,
        'frequency': task.frequency,
        'creatorEmail': task.creatorEmail,
      };

      allFields.forEach((key, fieldHistory) {
        if (key == 'items') return;

        while (fieldHistory.values.length < updateCount) {
          fieldHistory.add(fieldHistory.current ?? '');
        }

        if (fieldHistory.timestamps.isNotEmpty) {
          fieldHistory.timestamps[fieldHistory.timestamps.length - 1] =
              lastTimestamp;
        }
      });

      final dataToSave = task.toFirestore();
      print('💾 Data to save: $dataToSave');
      print('💾 Items in toFirestore: ${dataToSave['items']}');

      await _tasksCollection.doc(taskId).update(dataToSave);
      await _updateEditBy();

      print('✅ Item deleted successfully from Firebase');

      // اقرأ تاني للتأكد
      DocumentSnapshot verifyDoc = await _tasksCollection.doc(taskId).get();
      print('🔍 Verification - items after delete: ${verifyDoc.get('items')}');
    } catch (e, stack) {
      print('❌ Error deleting item: $e');
      print('Stack: $stack');
      throw Exception('Error deleting item: $e');
    }
  }

  Future<void> toggleItemStatus(String taskId, ItemData item) async {
    try {
      DocumentSnapshot doc = await _tasksCollection.doc(taskId).get();
      if (!doc.exists) {
        return;
      }

      TaskModel task = TaskModel.fromFirestore(doc);

      List<ItemData> currentItemsList = task.currentItems ?? [];

      final index = currentItemsList.indexWhere((e) => e.itemId == item.itemId);
      if (index == -1) {
        print('⚠️ Item not found in list');
        print(
          'Available items: ${currentItemsList.map((e) => e.itemId).toList()}',
        );
        return;
      }

      final newStatus = item.itemStatus == TaskStatus.done
          ? TaskStatus.toDo
          : TaskStatus.done;

      final updatedItem = ItemData(
        itemId: item.itemId,
        itemName: item.itemName,
        itemStatus: newStatus,
      );

      currentItemsList[index] = updatedItem;

      String itemsJson = jsonEncode(
        currentItemsList.map((e) => e.toMap()).toList(),
      );

      task.items.add(itemsJson);

      int updateCount = task.items.values.length;

      DateTime lastTimestamp = DateTime.now();

      final allFields = {
        'taskId': task.taskId,
        'name': task.name,
        'description': task.description,
        'items': task.items,
        'taskStatus': task.taskStatus,
        'priority': task.priority,
        'scheduled': task.scheduled,
        'frequency': task.frequency,
        'creatorEmail': task.creatorEmail,
      };

      allFields.forEach((key, fieldHistory) {
        if (key == 'items') return;

        while (fieldHistory.values.length < updateCount) {
          fieldHistory.add(fieldHistory.current ?? '');
        }

        if (fieldHistory.timestamps.isNotEmpty) {
          fieldHistory.timestamps[fieldHistory.timestamps.length - 1] =
              lastTimestamp;
        }
      });

      final dataToSave = task.toFirestore();

      await _tasksCollection.doc(taskId).update(dataToSave);
      await _updateEditBy();
      DocumentSnapshot verifyDoc = await _tasksCollection.doc(taskId).get();
    } catch (e, stack) {
      print('❌ Error toggling item status: $e');
      print('Stack: $stack');
      throw Exception('Error toggling item status: $e');
    }
  }

  Future<void> restoreTask(String taskId) async {
    try {
      print('🔥🔥🔥 === Restoring Task ===');
      print('Task ID: $taskId');

      DocumentSnapshot doc = await _tasksCollection.doc(taskId).get();
      if (!doc.exists) {
        print('❌ Document does not exist!');
        return;
      }

      TaskModel task = TaskModel.fromFirestore(doc);

      print('📦 Current task status: ${task.taskStatus.current}');
      print('📦 Task status history: ${task.taskStatus.values}');

      if (task.taskStatus.current != TaskStatus.deleted) {
        print(
          '⚠️ Task is not deleted, current status: ${task.taskStatus.current}',
        );
        return;
      }

      if (task.taskStatus.values.length >= 2) {
        String previousStatus =
        task.taskStatus.values[task.taskStatus.values.length - 2];
        print('🔄 Previous status: $previousStatus');

        task.taskStatus.add(previousStatus);
        print('✅ Task status restored to: $previousStatus');
      } else {
        print('⚠️ No previous status found, setting to to_do');
        task.taskStatus.add(TaskStatus.toDo);
      }

      if (task.items.values.length >= 2) {
        String previousItems = task.items.values[task.items.values.length - 2];
        print('📦 Restoring items to previous state');
        task.items.add(previousItems);
      } else {
        if (task.items.current != null) {
          task.items.add(task.items.current!);
        }
      }

      int updateCount = task.taskStatus.values.length;
      DateTime lastTimestamp = DateTime.now();

      final allFields = {
        'taskId': task.taskId,
        'name': task.name,
        'description': task.description,
        'items': task.items,
        'taskStatus': task.taskStatus,
        'priority': task.priority,
        'scheduled': task.scheduled,
        'frequency': task.frequency,
        'creatorEmail': task.creatorEmail,
      };

      allFields.forEach((key, fieldHistory) {
        if (key == 'taskStatus' || key == 'items') return;

        while (fieldHistory.values.length < updateCount) {
          fieldHistory.add(fieldHistory.current ?? '');
        }

        if (fieldHistory.timestamps.isNotEmpty) {
          fieldHistory.timestamps[fieldHistory.timestamps.length - 1] =
              lastTimestamp;
        }
      });

      final dataToSave = task.toFirestore();
      print('💾 Data to save: $dataToSave');

      await _tasksCollection.doc(taskId).update(dataToSave);
      await _updateEditBy();

      print('✅ Task restored successfully');

      DocumentSnapshot verifyDoc = await _tasksCollection.doc(taskId).get();
      print('🔍 Verification - task status: ${verifyDoc.get('taskStatus')}');
    } catch (e, stack) {
      print('❌ Error restoring task: $e');
      print('Stack: $stack');
      throw Exception('❌ Error restoring task: $e');
    }
  }
}