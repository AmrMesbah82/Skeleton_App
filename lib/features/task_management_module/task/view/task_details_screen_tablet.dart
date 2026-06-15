import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/model/card_model/card_model.dart';
import '../data/model/board_model/board_model.dart';

class TaskDetailsTabletScreen extends StatelessWidget {
  final String projectName;
  final String listName;
  final String department;
  final List<CardModel> cards;
  final CardModel currentCard;
  final BoardModel boardModel;

  const TaskDetailsTabletScreen({
    super.key,
    required this.projectName,
    required this.listName,
    required this.department,
    required this.cards,
    required this.boardModel,
    required this.currentCard,
  });

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Task Details'.tr)));
}
