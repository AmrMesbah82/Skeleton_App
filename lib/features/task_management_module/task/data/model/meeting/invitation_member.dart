import 'package:cloud_firestore/cloud_firestore.dart';

class InvitationMember {
  List<String>? invitationMember;
  List<String>? invitationMemberStatus;
  List<Timestamp>? timestamp;

  InvitationMember({
    this.invitationMember,
    this.invitationMemberStatus,
    this.timestamp,
  });

  InvitationMember.fromJson(dynamic json) {
    invitationMember = json['Invitation_Member'] != null
        ? json['Invitation_Member'].cast<String>()
        : [];
    invitationMemberStatus = json['Invitation_Member_Status'] != null
        ? json['Invitation_Member_Status'].cast<String>()
        : [];
    timestamp =
        json['Timestamp'] != null ? json['Timestamp'].cast<Timestamp>() : [];
  }

  InvitationMember copyWith({
    List<String>? invitationMember,
    List<String>? invitationMemberStatus,
    List<Timestamp>? timestamp,
  }) =>
      InvitationMember(
        invitationMember: invitationMember ?? this.invitationMember,
        invitationMemberStatus:
            invitationMemberStatus ?? this.invitationMemberStatus,
        timestamp: timestamp ?? this.timestamp,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Invitation_Member'] = invitationMember;
    map['Invitation_Member_Status'] = invitationMemberStatus;
    map['Timestamp'] = timestamp;
    return map;
  }
}
