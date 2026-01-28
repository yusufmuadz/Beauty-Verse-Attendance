import 'dart:convert';

import 'package:lancar_cat/app/data/model/submission_attendance_response_model.dart';

class AgreementOvertimeResponseModel {
  final bool? status;
  final String? message;
  final List<DetailOvertime>? data;
  final int? pendingLenght;

  AgreementOvertimeResponseModel({
    this.status,
    this.message,
    this.data,
    this.pendingLenght,
  });

  factory AgreementOvertimeResponseModel.fromJson(String str) =>
      AgreementOvertimeResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AgreementOvertimeResponseModel.fromMap(Map<String, dynamic> json) =>
      AgreementOvertimeResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<DetailOvertime>.from(
                json["data"]!.map((x) => DetailOvertime.fromMap(x)),
              ),
        pendingLenght: json['pending_lenght'],
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class Extends {
  final String? overtimeRequestId;
  final String? type;
  final dynamic durationBeforeShift;
  final String? durationAfterShift;
  final dynamic durationOvertimeDayoff;
  final DateTime? createdAt;

  Extends({
    this.overtimeRequestId,
    this.type,
    this.durationBeforeShift,
    this.durationAfterShift,
    this.durationOvertimeDayoff,
    this.createdAt,
  });

  factory Extends.fromJson(String str) => Extends.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Extends.fromMap(Map<String, dynamic> json) => Extends(
    overtimeRequestId: json["overtime_request_id"],
    type: json["type"],
    durationBeforeShift: json["duration_before_shift"],
    durationAfterShift: json["duration_after_shift"],
    durationOvertimeDayoff: json["duration_overtime_dayoff"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toMap() => {
    "overtime_request_id": overtimeRequestId,
    "type": type,
    "duration_before_shift": durationBeforeShift,
    "duration_after_shift": durationAfterShift,
    "duration_overtime_dayoff": durationOvertimeDayoff,
    "created_at": createdAt?.toIso8601String(),
  };
}

class DetailOvertime {
  final String? id;
  final String? overtimeMasterId;
  final String? usersId;
  final String? shiftId;
  final String? type;
  final String? durationBeforeShift;
  final String? durationAfterShift;
  final String? breakBeforeShift;
  final String? breakAfterShift;
  final String? timeInDayoff;
  final String? timeOutDayoff;
  final String? durationOvertimeDayoff;
  final String? breakOvertimeDayoff;
  final String? notes;
  final String? status;
  final String? statusLine;
  final String? statusSuperadmin;
  final String? approvalLine;
  final String? approvalSuperadmin;
  final dynamic dateApprovalLine;
  final DateTime? dateApprovalSuperadmin;
  final String? reasonSuperadmin;
  final DateTime? dateRequestFor;
  final DateTime? createdAt;
  final Line? user;
  final Line? line;
  final Line? superadmin;
  final Extends? datumExtends;

  DetailOvertime({
    this.id,
    this.overtimeMasterId,
    this.usersId,
    this.shiftId,
    this.type,
    this.durationBeforeShift,
    this.durationAfterShift,
    this.breakBeforeShift,
    this.breakAfterShift,
    this.timeInDayoff,
    this.timeOutDayoff,
    this.durationOvertimeDayoff,
    this.breakOvertimeDayoff,
    this.notes,
    this.status,
    this.statusLine,
    this.statusSuperadmin,
    this.approvalLine,
    this.approvalSuperadmin,
    this.dateApprovalLine,
    this.dateApprovalSuperadmin,
    this.reasonSuperadmin,
    this.dateRequestFor,
    this.createdAt,
    this.user,
    this.line,
    this.superadmin,
    this.datumExtends,
  });

  factory DetailOvertime.fromJson(String str) =>
      DetailOvertime.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailOvertime.fromMap(Map<String, dynamic> json) => DetailOvertime(
    id: json["id"],
    overtimeMasterId: json["overtime_master_id"],
    usersId: json["users_id"],
    shiftId: json["shift_id"],
    type: json["type"],
    durationBeforeShift: json["duration_before_shift"],
    durationAfterShift: json["duration_after_shift"],
    breakBeforeShift: json["break_before_shift"],
    breakAfterShift: json["break_after_shift"],
    timeInDayoff: json["time_in_dayoff"],
    timeOutDayoff: json["time_out_dayoff"],
    durationOvertimeDayoff: json["duration_overtime_dayoff"],
    breakOvertimeDayoff: json["break_overtime_dayoff"],
    notes: json["notes"],
    status: json["status"],
    statusLine: json["status_line"],
    statusSuperadmin: json["status_superadmin"],
    approvalLine: json["approval_line"],
    approvalSuperadmin: json["approval_superadmin"],
    dateApprovalLine: json["date_approval_line"],
    dateApprovalSuperadmin: json["date_approval_superadmin"] == null
        ? null
        : DateTime.parse(json["date_approval_superadmin"]),
    reasonSuperadmin: json["reason_superadmin"],
    dateRequestFor: json["date_request_for"] == null
        ? null
        : DateTime.parse(json["date_request_for"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    user: json["user"] == null ? null : Line.fromMap(json["user"]),
    line: json["line"] == null ? null : Line.fromMap(json["line"]),
    superadmin: json["superadmin"] == null
        ? null
        : Line.fromMap(json["superadmin"]),
    datumExtends: json["extends"] == null
        ? null
        : Extends.fromMap(json["extends"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "overtime_master_id": overtimeMasterId,
    "users_id": usersId,
    "shift_id": shiftId,
    "type": type,
    "duration_before_shift": durationBeforeShift,
    "duration_after_shift": durationAfterShift,
    "break_before_shift": breakBeforeShift,
    "break_after_shift": breakAfterShift,
    "time_in_dayoff": timeInDayoff,
    "time_out_dayoff": timeOutDayoff,
    "duration_overtime_dayoff": durationOvertimeDayoff,
    "break_overtime_dayoff": breakOvertimeDayoff,
    "notes": notes,
    "status": status,
    "status_line": statusLine,
    "status_superadmin": statusSuperadmin,
    "approval_line": approvalLine,
    "approval_superadmin": approvalSuperadmin,
    "date_approval_line": dateApprovalLine,
    "date_approval_superadmin": dateApprovalSuperadmin?.toIso8601String(),
    "reason_superadmin": reasonSuperadmin,
    "date_request_for":
        "${dateRequestFor!.year.toString().padLeft(4, '0')}-${dateRequestFor!.month.toString().padLeft(2, '0')}-${dateRequestFor!.day.toString().padLeft(2, '0')}",
    "created_at": createdAt?.toIso8601String(),
    "user": user?.toMap(),
    "line": line?.toMap(),
    "superadmin": superadmin?.toMap(),
    "extends": datumExtends?.toMap(),
  };
}
