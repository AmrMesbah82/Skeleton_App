import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/main_core/core/networking/get_base_url.dart';
import 'package:demo_app/features/external/main_core/features/employee/presentation/controller/main_core_employee_controller.dart';

import '../../../../core/constants/app_constanst.dart';
import '../models/todo_model.dart';

// developer Name : Mohamed Fouad
// Date of Last Edit :29/January/2025 By Fouad
// Objectives:  Add class TodoRemoteDataSource
class TodoRemoteDataSource {
  FirebaseFirestore db = FirebaseFirestore.instance;
  MainCoreEmployeeController addEmployeeController =
      Get.put(MainCoreEmployeeController());

  /// Retrieves all TodoModel objects from the database for the user
  /// Returns a list of TodoModel objects.
  Future<List<TodoModel>> getTodo(String user) async {
    var response = await db
        .collection(getBaseUrl(AppConstants.todoList))
        .doc(user)
        .collection(AppConstants.todoListUser)
        .get();
    return response.docs
        .map((e) => TodoModel.fromMap(data: e.data(), id: e.id))
        .toList();
  }

  /// Updates the specified request in the attendance requests collection with a reminder.
  ///
  /// This method sends a reminder by updating the corresponding request
  /// with the given [requestModel] under the specified [supervisor] in the
  /// Firestore database. The reminder is merged with existing data using the `SetOptions.merge` flag.
  ///
  /// [requestModel] - The model containing the request details to be updated.
  /// [supervisor] - The ID of the supervisor under whom the request is stored.

  Future<void> deleteTodo(String todoId, String user) async {
    await db
        .collection(getBaseUrl(AppConstants.todoList))
        .doc(user)
        .collection(AppConstants.todoListUser)
        .doc(todoId)
        .delete();
  }

  Future<void> deleteComment({
    required String todoId,
    required String user,
    required int index,
  }) async {
    final todoDocRef = db
        .collection(getBaseUrl(AppConstants.todoList))
        .doc(user)
        .collection(AppConstants.todoListUser)
        .doc(todoId);

    final snapshot = await todoDocRef.get();
    if (!snapshot.exists) return;

    List<dynamic> comments =
        snapshot.data()?[AppConstants.comments.toLowerCase()] ?? [];

    if (index < 0 || index >= comments.length) return;

    comments.removeAt(index);

    await todoDocRef.update({AppConstants.comments: comments});
  }

  /// Adds a TodoModel object to the database for the user with the id
  ///
  /// The TodoModel object is added as a document in the collection
  /// 'todoList'. The document id is the current date and time.
  ///
  /// The document is created with the data from the TodoModel object using
  /// the [toMap] method.
  Future<void> addTodo(TodoModel todoModel, String user) async {
    await db
        .collection(getBaseUrl(AppConstants.todoList))
        .doc(user)
        .collection(AppConstants.todoListUser)
        .doc(DateTime.now().toString())
        .set(todoModel.toMap());
    log(AppConstants.todoList);
    log(AppConstants.todoListUser);
    // log(addEmployeeController.employeeEntity!.email!);
  }

  /// Updates an existing TodoModel object in the database.
  ///
  /// The TodoModel object is identified by its `id`, and the corresponding
  /// document in the 'todoList' collection is updated with the new data
  /// from the TodoModel object using the [toMap] method.

  Future<void> updateTodo(TodoModel todoModel, String user) async {
    await db
        .collection(getBaseUrl(AppConstants.todoList))
        .doc(user)
        .collection(AppConstants.todoListUser)
        .doc(todoModel.id)
        .update(todoModel.toMap());
  }

  // updates the exising comments section only instead of updating the whole database
  Future<void> addComment(
      {required String todoId,
      required Map<String, dynamic> newComment,
      required String user}) async {
    await db
        .collection(getBaseUrl(AppConstants.todoList))
        .doc(user)
        .collection(AppConstants.todoListUser)
        .doc(todoId)
        .update({
      AppConstants.comments: FieldValue.arrayUnion([newComment]),
    });
  }

  // updates the existing comments section when we delete an item
  Future<void> updateCommentsFieldList({
    required String todoId,
    required List<Map<String, dynamic>> comments,
    required String user,
  }) async {
    await db
        .collection(getBaseUrl(AppConstants.todoList))
        .doc(user)
        .collection(AppConstants.todoListUser)
        .doc(todoId)
        .update({
      'Comments': comments,
    });
  }

  /// Checks if a notification with the given title and body already exists in the database.
  /// Takes a [title] and [body] as input and attempts to check if a notification
  /// with the same title and body already exists in the remote data source.
  /// Returns a [bool] value with `true` if the notification exists, `false` otherwise.
  Future<bool> checkIfNotificationExists(
      String title, String body, String user) async {
    var snapshot = await db
        .collection(getBaseUrl(AppConstants.todoList))
        .doc(user)
        .collection(AppConstants.notifications)
        .where(AppConstants.title, isEqualTo: title.toLowerCase())
        .where(AppConstants.body, isEqualTo: body)
        .get();
    return snapshot.docs.isNotEmpty;
  }
}
