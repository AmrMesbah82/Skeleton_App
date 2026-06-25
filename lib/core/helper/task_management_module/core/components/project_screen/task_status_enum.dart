/// Date Created :17/2/2025
/// By: Islam Daib
/// Objective: Create an enum class to represent the different task statuses.
library;

enum TaskStatusEnum {
  toDo('To Do'),
  doing('Doing'),
  done('Done'),
  archived('Archived'),
  deleted('Deleted');

  final String taskStatus;
  const TaskStatusEnum(this.taskStatus);
}
