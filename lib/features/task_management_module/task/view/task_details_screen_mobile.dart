import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/model/card_model/card_model.dart';
import '../data/model/board_model/board_model.dart';

class TaskDetailsMobile extends StatelessWidget {
  final CardModel cardModel;
  final String department;
  final String board;
  final List<CardModel> cards;
  final BoardModel boardModel;

  const TaskDetailsMobile({
    super.key,
    required this.cardModel,
    required this.department,
    required this.board,
    required this.cards,
    required this.boardModel,
  });

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Task Details'.tr)));
}
