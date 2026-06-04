class CardChecklistInvitedMembers {
  final String status;
  final String card;
  final String? startDate;
  final String? endDate;
  final String task;
  final String memberName;
  final String? memberImage;

  CardChecklistInvitedMembers({
    required this.status,
    required this.card,
      this.startDate,
      this.endDate,
    required this.task,
    required this.memberName,
    this.memberImage,
  });
}
