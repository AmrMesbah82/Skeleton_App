class LeaveRequestsModel {
  String? department;
  String? leaveType;
  String? status;
  String? dateRequest;
  String? requestId;
  String? firstName;
  String? lastName;
  String? email;
  String? fromTime;
  String? toTime;
  String? reason;
  String? totalTime;
  String? attachment;
  String? assignTo;
  String? rejectReason;

  // Constructor
  LeaveRequestsModel({
    this.department,
    this.leaveType,
    this.status,
    this.dateRequest,
    this.requestId,
    this.firstName,
    this.lastName,
    this.email,
    this.fromTime,
    this.toTime,
    this.reason,
    this.totalTime,
    this.attachment,
    this.assignTo,
    this.rejectReason,
  });
  factory LeaveRequestsModel.fromMap(Map data) {
    return LeaveRequestsModel(
      department: data['Department'],
      leaveType: data['Leave_Type'],
      status: data['Status'],
      dateRequest: data['Date_Request'],
      requestId: data['Request_Id'],
      firstName: data['First_Name'],
      lastName: data['Last_Name'],
      email: data['Email'],
      fromTime: data['From_Time'],
      toTime: data['To_Time'],
      reason: data['Reason'],
      totalTime: data['Total_Time'],
      attachment: data['Attachment'],
      assignTo: data['Assign_To'],
      rejectReason: data['Reject_Reason'],
    );
  }

  Map<String, dynamic> toMap() => {
        'Request_Id': requestId,
        'Department': department,
        'Leave_Type': leaveType,
        'Status': status,
        'Date_Request': dateRequest,
        'First_Name': firstName,
        'Last_Name': lastName,
        'Email': email,
        'From_Time': fromTime,
        'To_Time': toTime,
        'Reason': reason,
        'Total_Time': totalTime,
        'Attachment': attachment,
        'Assign_To': assignTo,
        'Reject_Reason': rejectReason,
      };
}
