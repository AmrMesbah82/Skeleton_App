import 'package:dartz/dartz.dart';

import '../../../../core/error_handling/failure.dart';
import '../../data/models/todo_model.dart';

/// Developer Name : Mohamed Fouad
/// Objectives:  Add abstract class TodoRepo
/// Date of Last Edit :29/January/2025 By Fouad
abstract class TodoRepo {
  /// Gets a list of TodoModel from the database
  Future<Either<Failure, List<TodoModel>>> getTodo(String email);

  /// Adds a new TodoModel to the database
  Future<Either<Failure, void>> addTodo(TodoModel todoModel, String user);

  /// Updates a TodoModel in the database
  Future<Either<Failure, void>> updateTodo(TodoModel todoModel, String user);

  /// Updates a TodoModel in the database when we add comment
  Future<Either<Failure, void>> addComment(TodoModel todoModel, String user);

  /// Updates a TodoModel in the database when we delete comment
  Future<Either<Failure, void>> updateComments(
      TodoModel todoModel, String user);

  Future<Either<Failure, void>> deleteTodo(String todoId, String user);

   Future<Either<Failure, void>> deleteComment({
    required String todoId,
    required String user,
    required int index,
  });
  /// Checks if a todo notification exists in the database
  Future<Either<Failure, bool>> checkIfTodoNotificationExists(
      String title, String body, String user);
}
