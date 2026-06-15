import 'package:dartz/dartz.dart';
import 'package:demo_app/features/todo_module/features/todo_create_and_edit/data/models/todo_item.dart';
import '../../../../core/error_handling/failure.dart';
import '../../domain/repo/todo_repo.dart';
import '../data_source/todo_remote_data_source.dart';
import '../models/todo_model.dart';

//date:March/3/2024
//by:Fouad
//lastUpdate:March/3/2024
//description: A class that implements the TodoRepo interface.
class TodoRepoImpl extends TodoRepo {
  final TodoRemoteDataSource todoRemoteDataSource;
  TodoRepoImpl({required this.todoRemoteDataSource});
  @override

  /// Retrieves a list of TodoModel objects from the database
  ///
  /// Returns a Right value containing the list of TodoModel objects if the operation is successful.
  /// Returns a Left value containing a Failure object if the operation fails.
  ///
  Future<Either<Failure, List<TodoModel>>> getTodo() async {
    List<TodoModel> todoList = [];
    try {
      todoList = await todoRemoteDataSource.getTodo();
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

  Future<Either<Failure, void>> addTodo(TodoModel todoModel) async {
    try {
      todoRemoteDataSource.addTodo(todoModel);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override

  /// Adds a TodoItemModel to the remote data source.
  ///
  /// Takes a [todoItemModel] and a [todoId] as input and attempts to add the
  /// TodoItemModel to the remote data source. The TodoItemModel is added as a
  /// document in the collection 'todoItems'. The document id is the current
  /// date and time.
  ///
  /// The document is created with the data from the TodoItemModel object using
  /// the [toMap] method.
  ///
  /// Returns a [Right] value with `null` if the operation is successful.
  /// Returns a [Left] value with a [Failure] object if the operation fails.
  Future<Either<Failure, void>> addItem(
      TodoItemModel todoItemModel, String todoId) async {
    try {
      todoRemoteDataSource.addTodoItem(todoItemModel, todoId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  /// Retrieves a list of TodoItemModel objects from the database for a given todoId
  ///
  /// Takes a [todoId] as input and attempts to retrieve the list of TodoItemModel objects
  /// associated with it from the remote data source.
  /// Returns a [Right] value containing the list of TodoItemModel objects if the operation is successful.
  /// Returns a [Left] value containing a [Failure] object if the operation fails.
  ///
  @override
  Future<Either<Failure, List<TodoItemModel>>> getItem(String todoId) async {
    List<TodoItemModel> todoList = [];
    try {
      todoList = await todoRemoteDataSource.getItem(todoId);
      return Right(todoList);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
