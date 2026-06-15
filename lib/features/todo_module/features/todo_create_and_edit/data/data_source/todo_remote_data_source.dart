import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';

import 'package:demo_app/core/network/get_base_url.dart';
import '../../../../core/constants/app_constanst.dart';
import '../models/todo_item.dart';
import '../models/todo_model.dart';

// date:March/3/2024
// by:Fouad
// lastUpdate:March/3/2024
// description: A class that handles data operations for TodoModel objects.
class TodoRemoteDataSource {
  FirebaseFirestore db = FirebaseFirestore.instance;
  MainCoreEmployeeController addEmployeeController =
      Get.put(MainCoreEmployeeController());

  /// Retrieves all TodoModel objects from the database for the user
  /// Returns a list of TodoModel objects.
  Future<List<TodoModel>> getTodo() async {
    var response = await db
        .collection(getBaseUrl(AppConstants.todoList))
        .doc(addEmployeeController.employeeEntity!.email!)
        .collection(AppConstants.todoListUser)
        .get();
    return response.docs.map((e) => TodoModel.fromMap(e.data(), e.id)).toList();
  }

  /// Adds a TodoModel object to the database for the user with the id
  ///
  /// The TodoModel object is added as a document in the collection
  /// 'todoList'. The document id is the current date and time.
  ///
  /// The document is created with the data from the TodoModel object using
  /// the [toMap] method.
  Future<void> addTodo(TodoModel todoModel) async {
    await db
        .collection(getBaseUrl(AppConstants.todoList))
        .doc(addEmployeeController.employeeEntity!.email!)
        .collection(AppConstants.todoListUser)
        .doc(
            '${addEmployeeController.employeeEntity!.id}${DateTime.now().toString()}')
        .set(todoModel.toMap());
  }

  /// Adds a TodoItemModel object to the database for the user with the id
  /// and with the given [todoId]
  ///
  /// The TodoItemModel object is added as a document in the collection
  /// 'todoItems'. The document id is the [todoId] parameter.
  ///
  /// The document is created with the data from the TodoItemModel object using
  /// the [toMap] method.
  Future<void> addTodoItem(TodoItemModel todoItemModel, String todoId) async {
    await db
        .collection(getBaseUrl(AppConstants.todoItems))
        .doc(addEmployeeController.employeeEntity!.email!)
        .collection(AppConstants.todoListUser)
        .doc(todoId)
        .set(todoItemModel.toMap());
  }

  /// Retrieves a TodoItemModel object from the database for the user with the id
  /// and with the given [todoId]
  /// Returns a list containing the TodoItemModel object.

  Future<List<TodoItemModel>> getItem(String todoId) async {
    var response = await db
        .collection(getBaseUrl(AppConstants.todoItems))
        .doc(addEmployeeController.employeeEntity!.email!)
        .collection(AppConstants.todoItems)
        .doc(todoId)
        .get();

    return [TodoItemModel.fromMap(response.data()!)];
  }
}
