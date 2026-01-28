import 'dart:convert';

class RespModelOvertime {
  final bool? status;
  final int? code;
  final Content? content;
  final String? message;

  RespModelOvertime({
    this.status,
    this.code,
    this.content,
    this.message,
  });

  factory RespModelOvertime.fromJson(String str) =>
      RespModelOvertime.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RespModelOvertime.fromMap(Map<String, dynamic> json) =>
      RespModelOvertime(
        status: json["status"],
        code: json["code"],
        content:
            json["content"] == null ? null : Content.fromMap(json["content"]),
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "content": content?.toMap(),
        "message": message,
      };
}

class Content {
  final String? id;
  final String? overtimeMasterId;
  final String? usersId;
  final String? shiftId;
  final String? dataFrom;
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
  final DateTime? dateApprovalLine;
  final DateTime? dateApprovalSuperadmin;
  final dynamic reasonSuperadmin;
  final DateTime? dateRequestFor;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final dynamic cancelBy;
  final String? nama;
  final String? avatar;

  Content({
    this.id,
    this.overtimeMasterId,
    this.usersId,
    this.shiftId,
    this.dataFrom,
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
    this.deletedAt,
    this.cancelBy,
    this.nama,
    this.avatar,
  });

  factory Content.fromJson(String str) => Content.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Content.fromMap(Map<String, dynamic> json) => Content(
        id: json["id"],
        overtimeMasterId: json["overtime_master_id"],
        usersId: json["users_id"],
        shiftId: json["shift_id"],
        dataFrom: json["data_from"],
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
        dateApprovalLine: json["date_approval_line"] == null
            ? null
            : DateTime.parse(json["date_approval_line"]),
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
        deletedAt: json["deleted_at"],
        cancelBy: json["cancel_by"],
        nama: json["nama"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "overtime_master_id": overtimeMasterId,
        "users_id": usersId,
        "shift_id": shiftId,
        "data_from": dataFrom,
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
        "date_approval_line": dateApprovalLine?.toIso8601String(),
        "date_approval_superadmin": dateApprovalSuperadmin?.toIso8601String(),
        "reason_superadmin": reasonSuperadmin,
        "date_request_for":
            "${dateRequestFor!.year.toString().padLeft(4, '0')}-${dateRequestFor!.month.toString().padLeft(2, '0')}-${dateRequestFor!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "cancel_by": cancelBy,
        "nama": nama,
        "avatar": avatar,
      };
}
