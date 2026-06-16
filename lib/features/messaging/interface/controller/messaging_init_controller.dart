import 'package:flutter/material.dart';
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

// Stub: MessagingConfigurations
// Provides the theme-related hooks the app's ThemeController calls into.
// These are no-ops in the stub build (the real messaging module is absent).
class MessagingConfigurations {
  void toggleTheme() {}

  void initTheme(Color primary, Color secondary, bool isDark) {}

  void updateBrandingColors(Color primary, Color secondary) {}
}

// Stub: MessagingInitController
class MessagingInitController extends GetxController {
  final MessagingConfigurations messagingConfigurations =
      MessagingConfigurations();

  List<GroupEntity> getUserGroups() => [];
}
