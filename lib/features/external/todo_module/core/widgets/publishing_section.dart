import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/features/external/todo_module/core/widgets/publishing_section_body_mobile.dart';
import 'package:demo_app/features/external/todo_module/core/widgets/publishing_section_body_tablet.dart';

/// Date Created 9/March/2025
/// Developer Name : Ahmed Mahmoud
/// Objectives:  this file represents customization publishing section in creation and edit

class SchedualeSection extends StatelessWidget {
  const SchedualeSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return isTablet
        ? PulbishingSectionBodyTablet()
        : PublishingSectionBodyMobile();
  }
}

