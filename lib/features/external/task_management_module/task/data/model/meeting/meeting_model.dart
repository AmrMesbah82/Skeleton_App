import 'meeting_name.dart';
import 'description.dart';
import 'date.dart';
import 'start_time.dart';
import 'end_time.dart';
import 'repeat.dart';
import 'notify.dart';
import 'meeting_creator.dart';
import 'invitation_member.dart';

class MeetingModel {
  String? meetingId;
  MeetingName? meetingName;
  Description? description;
  Date? date;
  StartTime? startTime;
  EndTime? endTime;
  Repeat? repeat;
  Notify? notify;
  MeetingCreator? meetingCreator;
  InvitationMember? invitationMember;
  String? status;
  MeetingModel({
    this.meetingId,
    this.meetingName,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.repeat,
    this.notify,
    this.meetingCreator,
    this.invitationMember,
    this.status,
  });

  MeetingModel.fromMap(dynamic json, String id) {
    meetingName = json['Meeting_Name'] != null
        ? MeetingName.fromJson(json['Meeting_Name'])
        : null;
    description = json['Description'] != null
        ? Description.fromJson(json['Description'])
        : null;
    date = json['Date'] != null ? Date.fromJson(json['Date']) : null;
    startTime = json['Start_Time'] != null
        ? StartTime.fromJson(json['Start_Time'])
        : null;
    endTime =
        json['End_Time'] != null ? EndTime.fromJson(json['End_Time']) : null;
    repeat = json['Repeat'] != null ? Repeat.fromJson(json['Repeat']) : null;
    notify = json['Notify'] != null ? Notify.fromJson(json['Notify']) : null;
    meetingCreator = json['Meeting_Creator'] != null
        ? MeetingCreator.fromJson(json['Meeting_Creator'])
        : null;
    invitationMember = json['Invitation_Member'] != null
        ? InvitationMember.fromJson(json['Invitation_Member'])
        : null;
    status = json['Status'];
    meetingId = id;
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (meetingName != null) {
      map['Meeting_Name'] = meetingName?.toJson();
    }
    if (description != null) {
      map['Description'] = description?.toJson();
    }
    if (date != null) {
      map['Date'] = date?.toJson();
    }
    if (startTime != null) {
      map['Start_Time'] = startTime?.toJson();
    }
    if (endTime != null) {
      map['End_Time'] = endTime?.toJson();
    }
    if (repeat != null) {
      map['Repeat'] = repeat?.toJson();
    }
    if (notify != null) {
      map['Notify'] = notify?.toJson();
    }
    if (meetingCreator != null) {
      map['Meeting_Creator'] = meetingCreator?.toJson();
    }
    if (invitationMember != null) {
      map['Invitation_Member'] = invitationMember?.toJson();
    }
    map['Status'] = status;
    return map;
  }
}
