import 'package:get/get.dart';
import '../../features/todo_list/data/data_source/todo_remote_data_source.dart';
import '../../features/todo_list/data/repo/todo_repo_impl.dart';
import '../../features/todo_list/presentation/controllers/todo_controller.dart';

/// This function is used to configure the dependencies of the GetX framework
/// The function is called once when the application is started

configurationDependencies() {
  Get.put(TodoController(
      todoRepo: TodoRepoImpl(todoRemoteDataSource: TodoRemoteDataSource())));
}
