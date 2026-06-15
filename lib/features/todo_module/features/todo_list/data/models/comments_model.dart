import 'comment_is_delete.dart';
import 'comment_is_done.dart';

/// Developer Name : Mohamed Hussien
/// Date of Last Edit :12/May/2024 By mohamed
class CommentModel {
  String? itemName;
  CommentIsDone? itemIsDone;
  CommentIsDelete? itemIsDeleted;
  String? creationDate;

  CommentModel({
    this.itemName,
    this.itemIsDone,
    this.itemIsDeleted,
    this.creationDate,
  });

  CommentModel copyWith({
    String? itemName,
    CommentIsDone? itemIsDone,
    CommentIsDelete? itemIsDeleted,
    String? creationDate,
  }) {
    return CommentModel(
      itemName: itemName ?? this.itemName,
      itemIsDone: itemIsDone ?? this.itemIsDone,
      itemIsDeleted: itemIsDeleted ?? this.itemIsDeleted,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  static const String fieldItemName = 'Item_Name';
  static const String fieldItemCreationDate = 'Item_Creation_Date';
  static const String fieldItemIsDone = 'Item_Is_Done';
  static const String fieldItemIsDeleted = 'Item_Is_Deleted';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldItemName: itemName?.toLowerCase(),
      fieldItemCreationDate: creationDate?.toLowerCase(),
      fieldItemIsDone: itemIsDone?.toMap(),
      fieldItemIsDeleted: itemIsDeleted?.toMap(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    String? name = map[fieldItemName];
    if (name != null) {
      name = name.substring(0, 1).toUpperCase() + name.substring(1);
    }

    String capitalize(String input) {
      if (input.isEmpty) return input;
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }

    String formatDateString() {
      String? inputDate = map[fieldItemCreationDate];
      if (inputDate != null) {
        List<String> parts = inputDate.split(', ');
        if (parts.length != 2) {
          return inputDate; // Return as is if format is unexpected
        }

        String dayOfWeek = capitalize(parts[0]);
        List<String> dateParts = parts[1].split(' ');

        if (dateParts.length != 2) {
          return inputDate; // Return as is if format is unexpected
        }

        String day = dateParts[0];
        String month = capitalize(dateParts[1]);

        return '$dayOfWeek, $day $month';
      }
      return "Not Found";
    }

    return CommentModel(
      itemName: name,
      itemIsDone: CommentIsDone.fromMap(map[fieldItemIsDone]),
      itemIsDeleted: CommentIsDelete.fromMap(map[fieldItemIsDeleted]),
      creationDate: formatDateString(),
    );
  }
}
