import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/features/employee/presentation/controller/main_core_employee_controller.dart';
import 'package:demo_app/features/todo_module/core/components/calendar_components.dart/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/features/todo_module/core/components/calendar_components.dart/date_picker_class.dart';
import 'package:demo_app/features/todo_module/features/todo_create_and_edit/presentation/UI/widgets/dialogs.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/comment_is_delete.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/comment_is_done.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/frequency_model.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/proiority_model.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/reminder_numbers.dart';
import 'package:demo_app/features/todo_module/features/todo_list/data/models/reminder_texts.dart';
import 'package:demo_app/features/todo_module/features/todo_list/presentation/ui/widgets/dialogs.dart';

import '../../../../core/constants/app_constanst.dart';
import '../../data/models/comments_model.dart';
import '../../data/models/date_model.dart';
import '../../data/models/description_model.dart';
import '../../data/models/name_model.dart';
import '../../data/models/status_model.dart';
import '../../data/models/time_model.dart';
import '../../data/models/todo_model.dart';
import '../../domain/repo/todo_repo.dart';

/// Developer Name : Mohamed Hussien
/// Objectives:  Add methods ( getTodoList ,addNewTodo,getTime,checkState, checkIsEnded , capitalize,
/// formatDateString, updateTodo, commentsList, searchList, isNotEmptyList)
/// Date of Last Edit :30/January/2025 By Fouad
/// Date of Last Edit :12/April/2025 By Ahmed Mahmoud
class TodoController extends GetxController {
  final TodoRepo todoRepo;
  TodoController({required this.todoRepo});

  // Global Keys
  final GlobalKey<FormState> createTodoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addItemFormKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController? descriptionController = TextEditingController();
  final TextEditingController? priorityController = TextEditingController();
  final TextEditingController? startDateController = TextEditingController();
  final TextEditingController? endDateController = TextEditingController();
  final TextEditingController? startTimePublishing = TextEditingController();
  final TextEditingController? endTimePublishing = TextEditingController();
  final TextEditingController? firstReminderNumber = TextEditingController();
  final TextEditingController? secondReminderNumber = TextEditingController();
  final TextEditingController? thirdReminderNumber = TextEditingController();
  final TextEditingController? firstReminderText = TextEditingController();
  final TextEditingController? secondReminderText = TextEditingController();
  final TextEditingController? thirdReminderText = TextEditingController();
  final TextEditingController? frequencyText = TextEditingController();
  final TextEditingController? frequencyNumber = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  //
  final employeeController = Get.find<MainCoreEmployeeController>();

  //
  TodoModel? selecetedTodoModel;

  //
  int selectedFilterIndex = 0;
  int reminderNumber = 0;
  int filterIndex = 0;

  //
  var selectedPriority = "".obs;
  var firstSelectedReminderNumber = "".obs;
  var secondSelectedReminderNumber = "".obs;
  var thirdSelectedReminderNumber = "".obs;
  var firstSelectedReminderText = "".obs;
  var secondSelectedReminderText = "".obs;
  var thirdSelectedReminderText = "".obs;
  var selectedFrequencyText = "".obs;
  var selectedFrequencyNumber = "".obs;

  //
  bool isScheduale = false;
  bool isFrequency = false;
  bool isSortedByFrequency = false;
  bool isSortedByStartDate = false;
  bool isYellow = false;
  bool isSortedByEndDate = false;

  //
  String startDateKey = "start";
  String searchName = "";
  String endDateKey = "end";

  //
  List<TodoModel> todoList = [];
  List<TodoModel> filteredTodoList = [];
  List<TodoModel> searchTodoList = [];
  List<TodoModel> allTodoList = [];

  // getting the number of filters shown in home screen
  List<int> get numberOfFilter {
    return [
      searchTodoList.length,
      searchTodoList
          .where((todo) => todo.status?.status == TodoStatus.todo)
          .length,
      searchTodoList
          .where((todo) => todo.status?.status == TodoStatus.done)
          .length,
      searchTodoList
          .where((todo) => todo.status?.status == TodoStatus.deleted)
          .length,
      searchTodoList
          .where((todo) => todo.status?.status == TodoStatus.scheduled)
          .length,
    ];
  }

  //
  /// Adds a new Todo item to the database
  Future<void> addNewTodo(BuildContext context) async {
    Timestamp now = Timestamp.now();
    TodoModel todoModel = TodoModel(
      name: NameModel(
        name: [nameController.text.isNotEmpty ? nameController.text : "empty"],
        timestamps: [now],
      ),
      description: DescriptionModel(
        description: [
          descriptionController?.text.isNotEmpty == true
              ? descriptionController!.text
              : "empty"
        ],
        timestamps: [now],
      ),
      priority: PriorityModel(
        priority: [
          priorityController?.text.isNotEmpty == true
              ? PriorityModel.priorityFromString(priorityController!.text)
              : null,
        ],
        timestamps: [now],
      ),
      startDate: DateModel(date: [
        startDateController?.text.isNotEmpty == true
            ? startDateController!.text
            : "empty"
      ], timestamps: [
        now
      ]),
      endDate: DateModel(date: [
        endDateController?.text.isNotEmpty == true
            ? endDateController!.text
            : "empty"
      ], timestamps: [
        now
      ]),
      startTime: TimeModel(time: [
        startTimePublishing?.text.isNotEmpty == true
            ? startTimePublishing!.text
            : "empty"
      ], timestamps: [
        now
      ]),
      endTime: TimeModel(time: [
        endTimePublishing?.text.isNotEmpty == true
            ? endTimePublishing!.text
            : "empty"
      ], timestamps: [
        now
      ]),
      firstReminderNumber: FirstReminderNumber(firstReminderNumber: [
        firstReminderNumber?.text.isNotEmpty == true
            ? firstReminderNumber!.text
            : "empty"
      ], timestamps: [
        now
      ]),
      secondReminderNumber: SecondReminderNumber(secondReminderNumber: [
        secondReminderNumber?.text.isNotEmpty == true
            ? secondReminderNumber!.text
            : "empty"
      ], timestamps: [
        now
      ]),
      thirdReminderNumber: ThirdReminderNumber(thirdReminderNumber: [
        thirdReminderNumber?.text.isNotEmpty == true
            ? thirdReminderNumber!.text
            : "empty"
      ], timestamps: [
        now
      ]),
      firstReminderText: FirstReminderText(firstReminderText: [
        firstReminderText?.text.isNotEmpty == true
            ? firstReminderText!.text
            : "empty"
      ], timestamps: [
        now
      ]),
      secondReminderText: SecondReminderText(secondReminderText: [
        secondReminderText?.text.isNotEmpty == true
            ? secondReminderText!.text
            : "empty"
      ], timestamps: [
        now
      ]),
      thirdReminderText: ThirdReminderText(thirdReminderText: [
        thirdReminderText?.text.isNotEmpty == true
            ? thirdReminderText!.text
            : "empty"
      ], timestamps: [
        now
      ]),
      frequencyNumber: FrequencyNumber(frequencyNumber: [
        frequencyNumber?.text.isNotEmpty == true
            ? frequencyNumber!.text
            : "empty"
      ], timestamps: [
        now
      ]),
      frequencyText: FrequencyText(
        frequencyText: [
          frequencyText?.text.isNotEmpty == true
              ? FrequencyText.frequencyFromString(frequencyText!.text)
              : null
        ],
        timestamps: [now],
      ),
      status: startDateController!.text.isNotEmpty
          ? StatusModel(
              status: StatusModel.statusFromString(
                  AppConstants.scheduled), // استخدم الدالة دي للتحويل
              timestamp: now)
          : StatusModel(
              status: StatusModel.statusFromString(
                  AppConstants.todo), // استخدم الدالة دي للتحويل
              timestamp: now),
      comments: [],
    );

    if (createTodoFormKey.currentState!.validate()) {
      // log(employeeController.currentEmployee!.email!.emails!.last!);
      createTodoDialog(
        context,
        () async {
          final response =
              await todoRepo.addTodo(todoModel, "admin@baynatz.com");
          response.fold((failure) {
            log("Failure Adding Todo to database ${failure.message}");
          }, (success) async {
            Navigator.of(context).pop(); // Close the TwoButtonedDialog
            Navigator.of(context).pop(); // Navigate back to previous screen
            await createTodoSuccessDialog(context);
            clearControllers();
            getTodoList();
            searchAndFilter();
            update();
          });
        },
      );
    } else {
      update();
    }
  }

  //
  /// Change a To-Do status in database from todo to deleted and vice versa
  Future<void> deleteToDoStatus(
      TodoModel todoModel, BuildContext context) async {
    deleteTodoDialog(
      context,
      () async {
        if (todoModel.status!.status == TodoStatus.deleted) {
          todoModel.status!.status = TodoStatus.todo;
        } else {
          todoModel.status!.status = TodoStatus.deleted;
        }
        todoModel.status!.timestamp = Timestamp.now();
        updateTodo(todoModel: todoModel);
        update();
        Navigator.of(context).pop();
        deleteTodoSuccessDialog(context);
      },
    );
  }

  ///
  // change todo status in database from deleted to todo
  Future<void> recoverTodo(TodoModel todoModel, BuildContext context) async {
    recoverTodoDialog(
      context,
      () async {
        if (todoModel.status!.status == TodoStatus.deleted) {
          todoModel.status = StatusModel(
            status: TodoStatus.todo,
            timestamp: Timestamp.now(),
          );
          await updateTodo(todoModel: todoModel);
        }

        Get.back();
        recoverTodoSuccessDialog(context);
      },
    );
  }

  ///
  /// Updates a TodoModel in the database whenever any change is made to it and updates ui
  Future<void> editTodo(
      {required TodoModel todoModel, required BuildContext context}) async {
    if (createTodoFormKey.currentState!.validate()) {
      final now = Timestamp.now();
      TodoModel model = TodoModel(
        id: todoModel.id,
        status: todoModel.status,
        comments: todoModel.comments!.isNotEmpty ? todoModel.comments : [],
        name: NameModel(
          name: [
            nameController.text.isNotEmpty ? nameController.text : "empty"
          ],
          timestamps: [Timestamp.now()],
        ),
        description: DescriptionModel(
          description: [
            descriptionController?.text.isNotEmpty == true
                ? descriptionController!.text
                : "empty",
          ],
          timestamps: [Timestamp.now()],
        ),
        priority: PriorityModel(
          priority: [
            priorityController?.text.isNotEmpty == true
                ? PriorityModel.priorityFromString(priorityController!.text)
                : null,
          ],
          timestamps: [now],
        ),
        startDate: DateModel(date: [
          startDateController?.text.isNotEmpty == true
              ? startDateController!.text
              : "empty",
        ], timestamps: [
          now
        ]),
        endDate: DateModel(date: [
          endDateController?.text.isNotEmpty == true
              ? endDateController!.text
              : "empty",
        ], timestamps: [
          now
        ]),
        startTime: TimeModel(time: [
          startTimePublishing?.text.isNotEmpty == true
              ? startTimePublishing!.text
              : "empty",
        ], timestamps: [
          now
        ]),
        endTime: TimeModel(time: [
          endTimePublishing?.text.isNotEmpty == true
              ? endTimePublishing!.text
              : "empty",
        ], timestamps: [
          now
        ]),
        firstReminderNumber: FirstReminderNumber(firstReminderNumber: [
          firstReminderNumber?.text != "" ? firstReminderNumber?.text : "empty"
        ], timestamps: [
          now
        ]),
        secondReminderNumber: SecondReminderNumber(secondReminderNumber: [
          secondReminderNumber?.text != ""
              ? secondReminderNumber?.text
              : "empty"
        ], timestamps: [
          now
        ]),
        thirdReminderNumber: ThirdReminderNumber(thirdReminderNumber: [
          thirdReminderNumber?.text != "" ? thirdReminderNumber?.text : "empty"
        ], timestamps: [
          now
        ]),
        firstReminderText: FirstReminderText(firstReminderText: [
          firstReminderText?.text != "" ? firstReminderText?.text : "empty"
        ], timestamps: [
          now
        ]),
        secondReminderText: SecondReminderText(secondReminderText: [
          secondReminderText?.text != "" ? secondReminderText?.text : "empty"
        ], timestamps: [
          now
        ]),
        thirdReminderText: ThirdReminderText(thirdReminderText: [
          thirdReminderText?.text != "" ? thirdReminderText?.text : "empty"
        ], timestamps: [
          now
        ]),
        frequencyNumber: FrequencyNumber(frequencyNumber: [
          frequencyNumber?.text != "" ? frequencyNumber?.text : "empty"
        ], timestamps: [
          now
        ]),
        frequencyText: FrequencyText(
          frequencyText: [
            frequencyText?.text.isNotEmpty == true
                ? FrequencyText.frequencyFromString(frequencyText!.text)
                : null
          ],
          timestamps: [now],
        ),
      );

      editTodoDialog(context, () async {
        var response = await todoRepo.updateTodo(
          model,
          "admin@baynatz.com",
        );
        response.fold((failure) {
          log("Failure Updating Todo to database ${failure.message}");
        }, (success) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          searchAndFilter();
          update();
          editTodoSuccessDialog(context);

          Future.delayed(const Duration(milliseconds: 500), () {
            getTodoList();
            searchAndFilter();
            update();
            clearControllers();
          });
        });
      });
    } else {
      update();
    }
  }

  ///
  // Adds a new Item to a Selected Todo and Updates ui for Instant Feedback
  Future<void> addComment(String itemName, TodoModel todoModel) async {
    if (commentController.text.isNotEmpty) {
      if (addItemFormKey.currentState!.validate()) {
        CommentModel commentsModel = CommentModel(
          itemName: itemName,
          itemIsDeleted: CommentIsDelete(
            commentIsDelete: false,
            timestamp: Timestamp.now(),
          ),
          creationDate: Timestamp.now().toDate().toString(),
          itemIsDone: CommentIsDone(
            commentIsDone: false,
            timestamps: Timestamp.now(),
          ),
        );
        commentController.clear();
        todoModel.comments?.add(commentsModel);
        await updateCommentsField(todoModel: todoModel);
      }
    }
  }

  ///
  // Deletes a Comment from a Selected Todo from DataBase and ui for Instant Feedback
  void deleteComment(BuildContext context,
      {required TodoModel todoModel, required int index}) async {
    if (todoModel.status!.status != TodoStatus.deleted) {
      deleteCommentDialog(context, () async {
        // STEP 1: Locally remove comment from TodoModel
        final updatedComments =
            List<CommentModel?>.from(todoModel.comments ?? []);
        updatedComments.removeAt(index);

        // STEP 2: Create a new model with updated comments
        todoModel.comments = updatedComments;

        // STEP 3: Call deleteComment from repo
        final result = await todoRepo.deleteComment(
          todoId: todoModel.id!,
          user: "admin@baynatz.com",
          index: index,
        );

        // STEP 4: Handle result and update the ui
        result.fold(
          (failure) => log("Failed to delete comment: ${failure.message}"),
          (_) async {
            await updateTodo(todoModel: todoModel);
            Navigator.of(context).pop();
            deleteCommentSuccessDialog(context);
          },
        );
      });
    }

    update(); // optional if needed for ui refresh
  }

  ///
  // Filters the todoList based on the selected priority and updates the ui (Low - Medium - High)
  void filterByPriority(TodoPriority? priorityFilter) {
    if (priorityFilter == null) {
      filteredTodoList = List.from(todoList);
    } else {
      filteredTodoList = todoList.where((todo) {
        return todo.priority?.priority?.last == priorityFilter;
      }).toList();
    }
    update();
  }

  ///
  // Sorts the todoList in Home based on the selected value
  void sortHomePage(String value) {
    if (value == "endDate") {
      // sortByEndDate();
    } else if (value == "frequency") {
      // sortByFrequency();
    } else if (value == "Scheduled") {}
  }

  ///
  // Sorts the todoList in Home based on Frequency
  // void sortByFrequency() {
  //   if (!isSortedByFrequency) {
  //     // Save current unsorted state before applying sort
  //     unsortedFilteredList = List.from(filteredTodoList);
  //     filteredTodoList.sort((a, b) {
  //       final frequencies = ['hour', 'day', 'week', 'month'];
  //       final aIndex = frequencies.indexOf(
  //           a.frequencyText?.frequencyText?.last?.toLowerCase() ?? 'empty');
  //       final bIndex = frequencies.indexOf(
  //           b.frequencyText?.frequencyText?.last?.toLowerCase() ?? 'empty');
  //       return (aIndex == -1 ? 999 : aIndex)
  //           .compareTo(bIndex == -1 ? 999 : bIndex);
  //     });
  //     isSortedByFrequency = true;
  //     isSortedByEndDate = false;
  //   } else {
  //     // Restore to unsorted state
  //     filteredTodoList = List.from(unsortedFilteredList);
  //     isSortedByFrequency = false;
  //   }
  //   update();
  // }

  ///
  // Sorts the todoList in Home based on End Date
  // void sortByEndDate() {
  //   if (!isSortedByEndDate) {
  //     // Save current unsorted state before applying sort
  //     unsortedFilteredList = List.from(filteredTodoList);
  //     filteredTodoList.sort((a, b) {
  //       // Handle empty dates
  //       if (a.endDate?.date?.last == "empty" ||
  //           a.endTime?.time?.last == "empty") {
  //         return 1; // Push items without dates to bottom
  //       }
  //       if (b.endDate?.date?.last == "empty" ||
  //           b.endTime?.time?.last == "empty") {
  //         return -1;
  //       }
  //       // Parse dates
  //       final aDate =
  //           _parseTodoDate(a.endDate!.date!.last!, a.endTime!.time!.last!);
  //       final bDate =
  //           _parseTodoDate(b.endDate!.date!.last!, b.endTime!.time!.last!);
  //       // Sort nearest to furthest
  //       return aDate.compareTo(bDate);
  //     });
  //     isSortedByEndDate = true;
  //     isSortedByFrequency = false;
  //   } else {
  //     // Restore to unsorted state
  //     filteredTodoList = List.from(unsortedFilteredList);
  //     isSortedByEndDate = false;
  //   }
  //   update();
  // }
  // DateTime _parseTodoDate(String dateStr, String timeStr) {
  //   try {
  //     final dateParts = dateStr.split(' ');
  //     final day = int.parse(dateParts[0]);
  //     final month = _monthToNumber(dateParts[1]);
  //     final year = int.parse(dateParts[2]);
  //     final timeParts = timeStr.split(' ');
  //     final hourMinute = timeParts[0].split(':');
  //     var hour = int.parse(hourMinute[0]);
  //     final minute = int.parse(hourMinute[1]);
  //     if (timeParts[1].toLowerCase() == 'pm' && hour != 12) hour += 12;
  //     if (timeParts[1].toLowerCase() == 'am' && hour == 12) hour = 0;
  //     return DateTime(year, month, day, hour, minute);
  //   } catch (e) {
  //     return DateTime(2100); // Far future date for invalid dates
  //   }
  // }
  // int _monthToNumber(String month) {
  //   const months = {
  //     'jan': 1,
  //     'feb': 2,
  //     'mar': 3,
  //     'apr': 4,
  //     'may': 5,
  //     'jun': 6,
  //     'jul': 7,
  //     'aug': 8,
  //     'sep': 9,
  //     'oct': 10,
  //     'nov': 11,
  //     'dec': 12
  //   };
  //   return months[month.toLowerCase().substring(0, 3)] ?? 1;
  // }

  ///
  // Initializes the controllers for editing a TodoModel so when user gets into edit mode the data shows in screen
  void initEditControllers() {
    if (selectedFrequencyNumber.value.isNotEmpty ||
        selectedFrequencyText.value.isNotEmpty) {
      isFrequency = true;
    }
    if (startDateController!.text.isNotEmpty ||
        endDateController!.text.isNotEmpty) {
      isScheduale = true;
    }
    nameController.text = selecetedTodoModel!.name.name.last!;
    if (selecetedTodoModel!.description!.description!.last! != "empty") {
      descriptionController!.text =
          selecetedTodoModel!.description!.description!.last!;
    }
    final lastPriority = selecetedTodoModel!.priority?.priority?.last;
    if (lastPriority != null) {
      priorityController!.text = lastPriority.toString().split('.').last;
      selectedPriority.value =
          lastPriority.toString().split('.').last.capitalizeFirst!;
    }
    if (selecetedTodoModel!.startDate!.date!.last! != "empty") {
      startDateController!.text = selecetedTodoModel!.startDate!.date!.last!;
    }
    if (selecetedTodoModel!.endDate!.date!.last! != "empty") {
      endDateController!.text = selecetedTodoModel!.endDate!.date!.last!;
    }
    if (selecetedTodoModel!.startTime!.time!.last! != "empty") {
      startTimePublishing!.text = selecetedTodoModel!.startTime!.time!.last!;
    }
    if (selecetedTodoModel!.endTime!.time!.last! != "empty") {
      endTimePublishing!.text = selecetedTodoModel!.endTime!.time!.last!;
    }
    if (selecetedTodoModel!.firstReminderNumber!.firstReminderNumber!.last! !=
        "empty") {
      firstReminderNumber!.text =
          selecetedTodoModel!.firstReminderNumber!.firstReminderNumber!.last!;
      firstSelectedReminderNumber.value =
          selecetedTodoModel!.firstReminderNumber!.firstReminderNumber!.last!;
    }
    if (selecetedTodoModel!.secondReminderNumber!.secondReminderNumber!.last! !=
        "empty") {
      secondReminderNumber!.text =
          selecetedTodoModel!.secondReminderNumber!.secondReminderNumber!.last!;
      secondSelectedReminderNumber.value =
          selecetedTodoModel!.secondReminderNumber!.secondReminderNumber!.last!;
    }
    if (selecetedTodoModel!.thirdReminderNumber!.thirdReminderNumber!.last! !=
        "empty") {
      thirdReminderNumber!.text =
          selecetedTodoModel!.thirdReminderNumber!.thirdReminderNumber!.last!;
      thirdSelectedReminderNumber.value =
          selecetedTodoModel!.thirdReminderNumber!.thirdReminderNumber!.last!;
    }
    if (selecetedTodoModel!.firstReminderText!.firstReminderText!.last! !=
        "empty") {
      firstReminderText!.text =
          selecetedTodoModel!.firstReminderText!.firstReminderText!.last!;
      firstSelectedReminderText.value = selecetedTodoModel!
          .firstReminderText!.firstReminderText!.last!.capitalize!;
    }
    if (selecetedTodoModel!.secondReminderText!.secondReminderText!.last! !=
        "empty") {
      secondReminderText!.text =
          selecetedTodoModel!.secondReminderText!.secondReminderText!.last!;
      secondSelectedReminderText.value = selecetedTodoModel!
          .secondReminderText!.secondReminderText!.last!.capitalize!;
    }
    if (selecetedTodoModel!.thirdReminderText!.thirdReminderText!.last! !=
        "empty") {
      thirdReminderText!.text =
          selecetedTodoModel!.thirdReminderText!.thirdReminderText!.last!;
      thirdSelectedReminderText.value = selecetedTodoModel!
          .thirdReminderText!.thirdReminderText!.last!.capitalize!;
    }
    final lastFrequency =
        selecetedTodoModel!.frequencyText?.frequencyText?.last;
    if (lastFrequency != null) {
      frequencyText!.text = lastFrequency.toString().split('.').last;
      selectedFrequencyText.value =
          lastFrequency.toString().split('.').last.capitalizeFirst!;
    }
    if (selecetedTodoModel!.frequencyNumber!.frequencyNumber!.last! !=
        "empty") {
      frequencyNumber!.text =
          selecetedTodoModel!.frequencyNumber!.frequencyNumber!.last!;
      selectedFrequencyNumber.value =
          selecetedTodoModel!.frequencyNumber!.frequencyNumber!.last!;
    }
  }

  ///
  // repo function for deleting todo
  Future<void> deleteTodo(String todoId) async {
    final result = await todoRepo.deleteTodo(todoId, "admin@baynatz.com");
    result.fold(
      (failure) {
        log("Error deleting Todo");
      },
      (_) async {
        todoList.removeWhere((todo) => todo.id == todoId);
        log("Success deleting Todo");
      },
    );
    update();
  }

  ///
  // Updates a TodoModel in the database whenever any change is made to it and updates ui
  Future<void> updateTodo({required TodoModel todoModel}) async {
    var response = await todoRepo.updateTodo(
      todoModel,
      "admin@baynatz.com",
    );
    response.fold((failure) {
      log("Failure Updating Todo to database ${failure.message}");
    }, (r) {});
    searchAndFilter();
    update();
  }

  // Cancels comment as in when user presses delete and ignore the comment he was about to upload
  void cancelComment() {
    commentController.clear();
    update();
  }

  ///
  // change todo status from done to undone and vice versa
  Future<void> changeToDoStatus({required TodoModel todoModel}) async {
    if (todoModel.status!.status != TodoStatus.deleted) {
      if (todoModel.status!.status == TodoStatus.done) {
        todoModel.status = StatusModel(
          status: TodoStatus.todo,
          timestamp: Timestamp.now(),
        );
      } else {
        todoModel.status = StatusModel(
          status: TodoStatus.done,
          timestamp: Timestamp.now(),
        );
        if (todoModel.status!.status == TodoStatus.done) {
          if (todoModel.comments != null) {
            for (int i = 0; i < todoModel.comments!.length; i++) {
              todoModel.comments![i]!.itemIsDone =
                  todoModel.comments![i]!.itemIsDone!.copyWith(
                commentIsDone: true,
                timestamp: Timestamp.now(),
              );
            }
          }
        }
      }
    }
    await updateTodo(todoModel: todoModel);
    update();
  }

  ///
  // change comment status from done to undone and vice versa
  Future<void> changeCommentStatus(
      {required TodoModel todoModel, required int index}) async {
    // Toggle the done status for the specific comment and count statuses.
    if (todoModel.status!.status != TodoStatus.deleted) {
      if (todoModel.comments![index]!.itemIsDone!.commentIsDone == true) {
        todoModel.comments![index]!.itemIsDone!.commentIsDone = false;
        todoModel.comments![index]!.itemIsDone!.timestamps = Timestamp.now();
      } else if (todoModel.comments![index]!.itemIsDone!.commentIsDone ==
          false) {
        todoModel.comments![index]!.itemIsDone!.commentIsDone = true;
        todoModel.comments![index]!.itemIsDone!.timestamps = Timestamp.now();
      }
    }
    await updateTodo(todoModel: todoModel);
    update();
  }

  ///
  // Updates the ToDoModel as in add a comment to it and updates ui
  Future<void> updateCommentsField({required TodoModel todoModel}) async {
    var response =
        await todoRepo.updateComments(todoModel, "admin@baynatz.com");
    response.fold(
      (failure) {
        log("Failure updating comments: ${failure.message}");
      },
      (_) {},
    );
    searchAndFilter();
    update();
  }

  /// Gets all ToDos from the database
  Future<void> getTodoList() async {
    allTodoList.clear();
    var response = await todoRepo.getTodo("admin@baynatz.com");
    response.fold((failure) {
      log(" Failure Getting Todo from database ${failure.message}");
    }, (todoList) async {
      allTodoList = todoList;
      // checkDayToEnd(allTodoList);
    });
  }

  /// Selects a date from the calendar
  Future<void> selectDate(BuildContext context, String dateType) async {
    List<DateTime?> selectedDates = [];
    final List<DateTime?>? picked = await DatePicker().showDatePicker(
      context,
      selectedDates,
      DateTime.now(),
      CalendarDatePicker2Type.single,
    );

    if (picked != null && picked.isNotEmpty) {
      String formattedDate =
          "${picked[0]!.day} ${DateFormat.MMM().format(picked[0]!)} ${picked[0]!.year}";

      if (dateType == startDateKey) {
        startDateController?.text = formattedDate;
      } else if (dateType == endDateKey) {
        endDateController?.text = formattedDate;
      }

      update();
    }
  }

  /// Selects [start] time from the clock
  void onDateTimeChangedStart(DateTime datetime) {
    startTimePublishing?.text =
        DateFormat('hh:mm a').format(datetime).toUpperCase();
    update();
  }

  /// Selects [end] time from the clock
  void onDateTimeChangedEnd(DateTime datetime) {
    endTimePublishing?.text =
        DateFormat('hh:mm a').format(datetime).toUpperCase();
    update();
  }

  //
  /// Searches for todos in the `allTodoList` based on the `searchName`.
  Future<void> searchAtList() async {
    if (searchName == "") {
      await getTodoList();
      searchTodoList.clear();
      for (int i = 0; i < allTodoList.length; i++) {
        searchTodoList.add(allTodoList[i]);
      }
    } else {
      await getTodoList();
      searchTodoList.clear();
      for (int i = 0; i < allTodoList.length; i++) {
        if (allTodoList[i]
                .name
                .name
                .last
                ?.toLowerCase()
                .contains(searchName.toLowerCase()) ??
            false) {
          searchTodoList.add(allTodoList[i]);
        }
      }
    }
    update();
  }

  //
  /// Filters the `searchTodoList` based on the `filterIndex` and updates the `todoList`.
  Future<void> filterList() async {
    filterIndex = selectedFilterIndex;

    TodoStatus? statusToCheck;
    List<TodoModel> todoFilter = [];
    switch (filterIndex) {
      case 1:
        statusToCheck = TodoStatus.todo;
        break;
      case 2:
        statusToCheck = TodoStatus.done;
        break;
      case 3:
        statusToCheck = TodoStatus.deleted;
        break;
      case 4:
        statusToCheck = TodoStatus.scheduled;
      default:
        statusToCheck = null;
    }
    if (statusToCheck != null) {
      // Filter case
      for (int i = 0; i < searchTodoList.length; i++) {
        if (searchTodoList[i].status?.status == statusToCheck) {
          todoFilter.add(searchTodoList[i]);
        }
      }
      todoList.clear();
      filteredTodoList.clear();
      todoList.addAll(todoFilter);
      filteredTodoList = todoList;
    } else {
      todoList.clear();
      filteredTodoList.clear();
      todoList.addAll(searchTodoList);

      filteredTodoList = todoList;
    }
    update();
  }

  /// This is a convenience method that allows you to search and filter the todo list
  void searchAndFilter() async {
    await searchAtList();
    await filterList();
  }

  /// Switches between scheduale display on and off.
  void switchScheduale(bool value) {
    isScheduale = value;
    update();
  }

  /// Switches between frequency display on and off.
  void switchFrequency(bool value) {
    isFrequency = value;
    update();
  }

  /// Clear all controllers usually after leaving the screen.
  Future<void> clearControllers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    nameController.clear();
    descriptionController?.clear();
    startTimePublishing?.clear();
    endTimePublishing?.clear();
    endDateController?.clear();
    startDateController?.clear();
    priorityController?.clear();
    firstReminderNumber?.clear();
    secondReminderNumber?.clear();
    thirdReminderNumber?.clear();
    firstReminderText?.clear();
    secondReminderText?.clear();
    thirdReminderText?.clear();
    frequencyNumber?.clear();
    frequencyText?.clear();

    selectedPriority.value = "";
    firstSelectedReminderNumber.value = "";
    secondSelectedReminderNumber.value = "";
    thirdSelectedReminderNumber.value = "";
    firstSelectedReminderText.value = "";
    secondSelectedReminderText.value = "";
    thirdSelectedReminderText.value = "";
    selectedFrequencyText.value = "";
    selectedFrequencyNumber.value = "";

    isFrequency = false;
    isScheduale = false;
    reminderNumber = 0;
    selectedFilterIndex = 0;
    isYellow = false;
  }
}
