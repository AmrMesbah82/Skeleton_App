import 'package:get/get.dart';

// Stub: GroupEntity
class GroupEntity {
  final String? name;
  final String? id;
  final List<String>? members;
  // Fields used by home widgets
  final String groupId;
  final String? groupImage;
  final String imageUri;
  final String primaryLanguageName;
  final String? secondaryLanguageName;

  GroupEntity({
    this.name,
    this.id,
    this.members,
    String? groupId,
    this.groupImage,
    this.imageUri = '',
    String? primaryLanguageName,
    this.secondaryLanguageName,
  })  : groupId = groupId ?? id ?? '',
        primaryLanguageName = primaryLanguageName ?? name ?? '';
}

// Stub: MessagingInitController
class MessagingInitController extends GetxController {
  List<GroupEntity> getUserGroups() => [];
}
