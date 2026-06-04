import 'dart:ui';


/// by : mohamed ashraf
enum ApprovalStatus {
  all,
  approved,
  pending,
  rejected,
  canceled,
}

extension GetApprovalStatusName on ApprovalStatus {
  String get getName {
    switch (this) {
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.pending:
        return 'Pending';
      case ApprovalStatus.rejected:
        return 'Rejected';
      case ApprovalStatus.canceled:
        return 'Canceled';
      case ApprovalStatus.all:
        return 'All';
    }
  }

  String get getOrderName {
    switch (this) {
      case ApprovalStatus.approved:
        return 'Approve';
      case ApprovalStatus.pending:
        return 'Pending';
      case ApprovalStatus.rejected:
        return 'Reject';
      case ApprovalStatus.canceled:
        return 'Cancel';
      case ApprovalStatus.all:
        return 'All';
    }
  }
}
