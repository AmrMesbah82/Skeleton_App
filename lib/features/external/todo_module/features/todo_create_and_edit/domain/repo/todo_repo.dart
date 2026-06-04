import 'package:dartz/dartz.dart';

import '../../../../core/error_handling/failure.dart';
import '../../data/models/todo_item.dart';
import '../../data/models/todo_model.dart';

//date:March/3/2024
//by:Fouad
//lastUpdate:March/3/2024
//description: A class that represents a todo item.
abstract class TodoRepo {
  /// Adds a new TodoModel to the database
  Future<Either<Failure, void>> addTodo(TodoModel todoModel);

  /// Gets a list of TodoModel from the database
  Future<Either<Failure, List<TodoModel>>> getTodo();

  // Adds ItemModel to the database
  Future<Either<Failure, void>> addItem(
      TodoItemModel todoItemModel, String todoId);

  /// Gets a list of ItemModel from the database
  Future<Either<Failure, List<TodoItemModel>>> getItem(String todoId);
}
