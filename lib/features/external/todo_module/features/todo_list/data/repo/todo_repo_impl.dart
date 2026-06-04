import 'package:dartz/dartz.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/comments_model.dart';
import '../../../../core/error_handling/failure.dart';
import '../../domain/repo/todo_repo.dart';
import '../data_source/todo_remote_data_source.dart';
import '../models/todo_model.dart';

/// Developer Name : Mohamed Fouad
/// Objectives:  Add class TodoRepoImpl
/// Date of Last Edit :29/January/2025 By Fouad
class TodoRepoImpl extends TodoRepo {
  final TodoRemoteDataSource todoRemoteDataSource;
  TodoRepoImpl({required this.todoRemoteDataSource});
  @override

  /// Retrieves a list of TodoModel objects from the database
  ///
  /// Returns a Right value containing the list of TodoModel objects if the operation is successful.
  /// Returns a Left value containing a Failure object if the operation fails.
  ///
  Future<Either<Failure, List<TodoModel>>> getTodo(String email) async {
    List<TodoModel> todoList = [];
    try {
      todoList = await todoRemoteDataSource.getTodo(email);
      return Right(todoList);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override

  /// Adds a TodoModel to the remote data source.
  ///
  /// Takes a [todoModel] as input and attempts to add it to the remote data source.
  /// Returns a [Right] value with `null` if the operation is successful.
  /// Returns a [Left] value with a [Failure] object if the operation fails.

  Future<Either<Failure, void>> addTodo(
      TodoModel todoModel, String user) async {
    try {
      await todoRemoteDataSource.addTodo(todoModel, user);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override

  /// Updates a TodoModel in the database.
  ///
  /// Takes a [TodoModel] as input and attempts to update it in the remote data source.
  /// Returns a [Right] value with `null` if the operation is successful.
  /// Returns a [Left] value with a [Failure] object if the operation fails.
  Future<Either<Failure, void>> updateTodo(
      TodoModel todoModel, String user) async {
    try {
      todoRemoteDataSource.updateTodo(todoModel, user);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  /// Updates the Todo comments in the database.
  ///
  /// Takes a [TodoModel] as input and attempts to update it in the remote data source.
  /// Returns a [Right] value with `null` if the operation is successful.
  /// Returns a [Left] value with a [Failure] object if the operation fails.
  @override
  Future<Either<Failure, void>> addComment(
      TodoModel todoModel, String user) async {
    try {
      // Ensure there is at least one comment to update.
      if (todoModel.comments == null || todoModel.comments!.isEmpty) {
        return const Right(null);
      }
      // Assume the new comment is the last one in the list.
      final CommentModel newComment = todoModel.comments!.last!;
      await todoRemoteDataSource.addComment(
        todoId: todoModel.id!,
        newComment: newComment.toMap(),
        user: user,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateComments(
      TodoModel todoModel, String user) async {
    try {
      final updatedComments =
          todoModel.comments?.map((c) => c!.toMap()).toList() ?? [];
      await todoRemoteDataSource.updateCommentsFieldList(
        todoId: todoModel.id!,
        user: user,
        comments: updatedComments,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override

  /// Checks if a notification with the given title and body already exists in the database.
  ///
  /// Takes a [title] and [body] as input and attempts to check if a notification with the same title and body already exists in the remote data source.
  /// Returns a [Right] value with `true` if the notification exists, `false` otherwise.
  /// Returns a [Left] value with a [Failure] object if the operation fails.
  Future<Either<Failure, bool>> checkIfTodoNotificationExists(
      String title, String body, String user) async {
    bool isNotificationExists = false;
    try {
      isNotificationExists = await todoRemoteDataSource
          .checkIfNotificationExists(title, body, user);
      return Right(isNotificationExists);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(String todoId, String user) async {
    try {
      await todoRemoteDataSource.deleteTodo(todoId, user);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
  
@override
Future<Either<Failure, void>> deleteComment({
  required String todoId,
  required String user,
  required int index,
}) async {
  try {
    await todoRemoteDataSource.deleteComment(
      todoId: todoId,
      user: user,
      index: index,
    );
    return const Right(null);
  } catch (e) {
    return Left(Failure(message: e.toString()));
  }
}


}
