import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/frequency_model.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/proiority_model.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/reminder_numbers.dart';
import 'package:demo_app/features/external/todo_module/features/todo_list/data/models/reminder_texts.dart';
import 'comments_model.dart';
import 'date_model.dart';
import 'description_model.dart';
import 'name_model.dart';
import 'status_model.dart';
import 'time_model.dart';

/// Developer Name : Mohamed Hussien
/// Date of Last Edit :29/January/2025 By Fouad
class TodoModel {
  static const String filedName = 'Name';
  static const String filedDescription = 'Description';
  static const String filedStartTime = 'StartTime';
  static const String filedEndTime = 'EndTime';
  static const String filedStartDate = 'StartDate';
  static const String filedEndDate = 'EndDate';
  static const String filedProiority = 'Proiority';
  static const String filedFirstReminderNumber = 'FirstReminderNumber';
  static const String filedSecondReminderNumber = 'SecondReminderNumber';
  static const String filedThirdReminderNumber = 'ThirdReminderNumber';
  static const String filedFirstReminderText = 'FirstReminderText';
  static const String filedSecondReminderText = 'SecondReminderText';
  static const String filedThirdReminderText = 'ThirdReminderText';
  static const String filedFrequencyNumber = 'FrequencyNumber';
  static const String filedFrequencyText = 'FrequencyText';
  static const String filedComments = 'Comments';
  static const String filedStatus = 'Status';

  NameModel name;
  DescriptionModel? description;
  DateModel? startDate;
  DateModel? endDate;
  TimeModel? startTime;
  TimeModel? endTime;
  PriorityModel? priority;
  FirstReminderNumber? firstReminderNumber;
  SecondReminderNumber? secondReminderNumber;
  ThirdReminderNumber? thirdReminderNumber;
  FirstReminderText? firstReminderText;
  SecondReminderText? secondReminderText;
  ThirdReminderText? thirdReminderText;
  FrequencyNumber? frequencyNumber;
  FrequencyText? frequencyText;
  List<CommentModel?>? comments;
  StatusModel? status;
  final String? id;

  TodoModel({
    this.id,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.priority,
    this.firstReminderNumber,
    this.secondReminderNumber,
    this.thirdReminderNumber,
    this.firstReminderText,
    this.secondReminderText,
    this.thirdReminderText,
    this.frequencyNumber,
    this.frequencyText,
    this.comments,
    this.status,
  });

  factory TodoModel.fromMap({required Map data, required String id}) {
    return TodoModel(
      name: NameModel.fromMap(data[filedName]),
      description: DescriptionModel.fromMap(data[filedDescription]),
      startDate: DateModel.fromMap(data[filedStartDate]),
      endDate: DateModel.fromMap(data[filedEndDate]),
      startTime: TimeModel.fromMap(data[filedStartTime]),
      endTime: TimeModel.fromMap(data[filedEndTime]),
      priority: PriorityModel.fromMap(data[filedProiority]),
      firstReminderNumber:
          FirstReminderNumber.fromMap(data[filedFirstReminderNumber]),
      secondReminderNumber:
          SecondReminderNumber.fromMap(data[filedSecondReminderNumber]),
      thirdReminderNumber:
          ThirdReminderNumber.fromMap(data[filedThirdReminderNumber]),
      firstReminderText:
          FirstReminderText.fromMap(data[filedFirstReminderText]),
      secondReminderText:
          SecondReminderText.fromMap(data[filedSecondReminderText]),
      thirdReminderText:
          ThirdReminderText.fromMap(data[filedThirdReminderText]),
      frequencyNumber: FrequencyNumber.fromMap(data[filedFrequencyNumber]),
      frequencyText: FrequencyText.fromMap(data[filedFrequencyText]),
      comments: (data[filedComments] as List<dynamic>?)
          ?.map((itemData) => CommentModel.fromMap(itemData))
          .toList(),
      status: StatusModel.fromMap(data[filedStatus]),
      id: id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      filedName: name.toMap(),
      filedDescription: description?.toMap(),
      filedStartTime: startTime?.toMap(),
      filedEndTime: endTime?.toMap(),
      filedStartDate: startDate?.toMap(),
      filedEndDate: endDate?.toMap(),
      filedProiority: priority?.toMap(),
      filedFirstReminderNumber: firstReminderNumber?.toMap(),
      filedSecondReminderNumber: secondReminderNumber?.toMap(),
      filedThirdReminderNumber: thirdReminderNumber?.toMap(),
      filedFirstReminderText: firstReminderText?.toMap(),
      filedSecondReminderText: secondReminderText?.toMap(),
      filedThirdReminderText: thirdReminderText?.toMap(),
      filedFrequencyNumber: frequencyNumber?.toMap(),
      filedFrequencyText: frequencyText?.toMap(),
      filedComments: comments?.map((item) => item?.toMap()).toList(),
      filedStatus: status?.toMap(),
    };
  }
}
