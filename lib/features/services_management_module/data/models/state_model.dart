class StateStatisticsModel
{
  final int approvedCount;
  final int cancelCount;
  final int pendingCount;
  final int rejectedCount;
  final int inProgressCount;
  final int branchSlaCount;
  final int doneCount; // ✅ Add this

  StateStatisticsModel({
    required this.approvedCount,
    required this.cancelCount,
    required this.pendingCount,
    required this.rejectedCount,
    required this.inProgressCount,
    required this.branchSlaCount,
    required this.doneCount, // ✅ Add this
  });

  Map<String, dynamic> toJson() {
    return {
      'approved': approvedCount,
      'canceled': cancelCount,
      'pending': pendingCount,
      'rejected': rejectedCount,
      'inProgress': inProgressCount,
      'breachedSLA': branchSlaCount,
    };
  }

  String formatCount(int count) => count.toString().padLeft(2, '0');
}
