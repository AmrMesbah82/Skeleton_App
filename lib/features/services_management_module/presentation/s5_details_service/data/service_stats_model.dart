class ServiceStatsModel {
  final int done;
  final int approved;
  final int inprogress;
  final int pending;
  final int rejected;
  final int cancel;
  final int branchsla;

  ServiceStatsModel({
    required this.done,
    required this.approved,
    required this.inprogress,
    required this.pending,
    required this.rejected,
    required this.cancel,
    required this.branchsla,
  });

  factory ServiceStatsModel.empty() {
    return ServiceStatsModel(
      done: 0,
      approved: 0,
      inprogress: 0,
      pending: 0,
      rejected: 0,
      cancel: 0,
      branchsla: 0,
    );
  }

  factory ServiceStatsModel.fromMap(Map<String, int> map) {
    return ServiceStatsModel(
      done: map['done'] ?? 0,
      approved: map['approved'] ?? 0,
      inprogress: map['inprogress'] ?? 0,
      pending: map['pending'] ?? 0,
      rejected: map['rejected'] ?? 0,
      cancel: map['cancel'] ?? 0,
      branchsla: map['branchsla'] ?? 0,
    );
  }

  Map<String, int> toMap() {
    return {
      'done': done,
      'approved': approved,
      'inprogress': inprogress,
      'pending': pending,
      'rejected': rejected,
      'cancel': cancel,
      'branchsla': branchsla,
    };
  }

  ServiceStatsModel copyWith({
    int? done,
    int? approved,
    int? inprogress,
    int? pending,
    int? rejected,
    int? cancel,
    int? branchsla,
  }) {
    return ServiceStatsModel(
      done: done ?? this.done,
      approved: approved ?? this.approved,
      inprogress: inprogress ?? this.inprogress,
      pending: pending ?? this.pending,
      rejected: rejected ?? this.rejected,
      cancel: cancel ?? this.cancel,
      branchsla: branchsla ?? this.branchsla,
    );
  }
}