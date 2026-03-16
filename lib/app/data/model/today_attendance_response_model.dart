import 'dart:convert';

import '../../models/attendance.dart';
import '../../models/shift.dart';

class TodayAttendanceResponseModel {
  final List<Attendance>? attendance;
  final Master? timeoff;
  final Shift shift;
  // final TodayAttendanceResponseModelTimeoff? timeoff;

  TodayAttendanceResponseModel({
    this.attendance,
    this.timeoff,
    required this.shift,
  });

  factory TodayAttendanceResponseModel.fromJson(String str) =>
      TodayAttendanceResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TodayAttendanceResponseModel.fromMap(Map<String, dynamic> json) =>
      TodayAttendanceResponseModel(
        attendance: json["attendance"] == null
            ? []
            : List<Attendance>.from(
                json["attendance"]!.map((x) => Attendance.fromMap(x)),
              ),
        timeoff: json['timeoff'] == null
            ? null
            : Master.fromMap(json['timeoff']),
        shift: Shift.fromMap(json["shift"]),
      );

  Map<String, dynamic> toMap() => {
    "attendance": attendance == null
        ? []
        : List<dynamic>.from(attendance!.map((x) => x.toMap())),
    "timeoff": timeoff?.toMap(),
    "shift": shift.toMap(),
  };
}

class TodayAttendanceResponseModelTimeoff {
  final String? id;
  final DateTime? period;
  final String? usersId;
  final dynamic userAttendanceId;
  final String? userTimeoffRequestId;
  final dynamic userLateBreakInId;
  final dynamic userPermitOut;
  final dynamic userOvertimeId;
  final TimeoffTimeoff? timeoff;

  TodayAttendanceResponseModelTimeoff({
    this.id,
    this.period,
    this.usersId,
    this.userAttendanceId,
    this.userTimeoffRequestId,
    this.userLateBreakInId,
    this.userPermitOut,
    this.userOvertimeId,
    this.timeoff,
  });

  factory TodayAttendanceResponseModelTimeoff.fromJson(String str) =>
      TodayAttendanceResponseModelTimeoff.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TodayAttendanceResponseModelTimeoff.fromMap(
    Map<String, dynamic> json,
  ) => TodayAttendanceResponseModelTimeoff(
    id: json["id"],
    period: json["period"] == null ? null : DateTime.parse(json["period"]),
    usersId: json["users_id"],
    userAttendanceId: json["user_attendance_id"],
    userTimeoffRequestId: json["user_timeoff_request_id"],
    userLateBreakInId: json["user_late_break_in_id"],
    userPermitOut: json["user_permit_out"],
    userOvertimeId: json["user_overtime_id"],
    timeoff: json["timeoff"] == null
        ? null
        : TimeoffTimeoff.fromMap(json["timeoff"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "period":
        "${period!.year.toString().padLeft(4, '0')}-${period!.month.toString().padLeft(2, '0')}-${period!.day.toString().padLeft(2, '0')}",
    "users_id": usersId,
    "user_attendance_id": userAttendanceId,
    "user_timeoff_request_id": userTimeoffRequestId,
    "user_late_break_in_id": userLateBreakInId,
    "user_permit_out": userPermitOut,
    "user_overtime_id": userOvertimeId,
    "timeoff": timeoff?.toMap(),
  };
}

class TimeoffTimeoff {
  final String? id;
  final String? timeOffMasterId;
  final String? userId;
  final String? reason;
  final String? status;
  final String? statusLine;
  final String? statusSuperadmin;
  final DateTime? startTimeOff;
  final DateTime? endTimeOff;
  final dynamic cancelAt;
  final DateTime? dateRequest;
  final String? approvalLine;
  final String? approvalSuperadmin;
  final DateTime? dateApprovalLine;
  final DateTime? dateApprovalSuperadmin;
  final dynamic commentApprovalLine;
  final dynamic commentApprovalSuperadmin;
  final Master? master;

  TimeoffTimeoff({
    this.id,
    this.timeOffMasterId,
    this.userId,
    this.reason,
    this.status,
    this.statusLine,
    this.statusSuperadmin,
    this.startTimeOff,
    this.endTimeOff,
    this.cancelAt,
    this.dateRequest,
    this.approvalLine,
    this.approvalSuperadmin,
    this.dateApprovalLine,
    this.dateApprovalSuperadmin,
    this.commentApprovalLine,
    this.commentApprovalSuperadmin,
    this.master,
  });

  factory TimeoffTimeoff.fromJson(String str) =>
      TimeoffTimeoff.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TimeoffTimeoff.fromMap(Map<String, dynamic> json) => TimeoffTimeoff(
    id: json["id"],
    timeOffMasterId: json["time_off_master_id"],
    userId: json["user_id"],
    reason: json["reason"],
    status: json["status"],
    statusLine: json["status_line"],
    statusSuperadmin: json["status_superadmin"],
    startTimeOff: json["start_time_off"] == null
        ? null
        : DateTime.parse(json["start_time_off"]),
    endTimeOff: json["end_time_off"] == null
        ? null
        : DateTime.parse(json["end_time_off"]),
    cancelAt: json["cancel_at"],
    dateRequest: json["date_request"] == null
        ? null
        : DateTime.parse(json["date_request"]),
    approvalLine: json["approval_line"],
    approvalSuperadmin: json["approval_superadmin"],
    dateApprovalLine: json["date_approval_line"] == null
        ? null
        : DateTime.parse(json["date_approval_line"]),
    dateApprovalSuperadmin: json["date_approval_superadmin"] == null
        ? null
        : DateTime.parse(json["date_approval_superadmin"]),
    commentApprovalLine: json["comment_approval_line"],
    commentApprovalSuperadmin: json["comment_approval_superadmin"],
    master: json["master"] == null ? null : Master.fromMap(json["master"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "time_off_master_id": timeOffMasterId,
    "user_id": userId,
    "reason": reason,
    "status": status,
    "status_line": statusLine,
    "status_superadmin": statusSuperadmin,
    "start_time_off": startTimeOff?.toIso8601String(),
    "end_time_off": endTimeOff?.toIso8601String(),
    "cancel_at": cancelAt,
    "date_request": dateRequest?.toIso8601String(),
    "approval_line": approvalLine,
    "approval_superadmin": approvalSuperadmin,
    "date_approval_line": dateApprovalLine?.toIso8601String(),
    "date_approval_superadmin": dateApprovalSuperadmin?.toIso8601String(),
    "comment_approval_line": commentApprovalLine,
    "comment_approval_superadmin": commentApprovalSuperadmin,
    "master": master?.toMap(),
  };
}

class Master {
  final String? id;
  final String? name;
  final String? code;
  final DateTime? effectiveDate;
  final dynamic description;
  final String? show;
  final DateTime? createdAt;

  Master({
    this.id,
    this.name,
    this.code,
    this.effectiveDate,
    this.description,
    this.show,
    this.createdAt,
  });

  factory Master.fromJson(String str) => Master.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Master.fromMap(Map<String, dynamic> json) => Master(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    effectiveDate: json["effective_date"] == null
        ? null
        : DateTime.parse(json["effective_date"]),
    description: json["description"],
    show: json["show"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "code": code,
    "effective_date":
        "${effectiveDate!.year.toString().padLeft(4, '0')}-${effectiveDate!.month.toString().padLeft(2, '0')}-${effectiveDate!.day.toString().padLeft(2, '0')}",
    "description": description,
    "show": show,
    "created_at": createdAt?.toIso8601String(),
  };
}
