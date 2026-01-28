import 'dart:convert';

class RespModelAttendance {
  final bool? status;
  final int? code;
  final Content? content;
  final String? message;

  RespModelAttendance({
    this.status,
    this.code,
    this.content,
    this.message,
  });

  factory RespModelAttendance.fromJson(String str) =>
      RespModelAttendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RespModelAttendance.fromMap(Map<String, dynamic> json) =>
      RespModelAttendance(
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
  final String? usersId;
  final dynamic attachmentUrl;
  final DateTime? dateRequest;
  final DateTime? dateRequestFor;
  final dynamic clockinTime;
  final String? clockoutTime;
  final String? reasonRequest;
  final dynamic reasonLine;
  final dynamic reasonSuperadmin;
  final String? approvalLine;
  final String? approvalSuperadmin;
  final DateTime? dateApprovalLine;
  final DateTime? dateApprovalSuperadmin;
  final String? status;
  final String? statusLine;
  final String? statusSuperadmin;
  final dynamic cancelAt;
  final String? nama;
  final String? avatar;
  final Shift? shift;

  Content({
    this.id,
    this.usersId,
    this.attachmentUrl,
    this.dateRequest,
    this.dateRequestFor,
    this.clockinTime,
    this.clockoutTime,
    this.reasonRequest,
    this.reasonLine,
    this.reasonSuperadmin,
    this.approvalLine,
    this.approvalSuperadmin,
    this.dateApprovalLine,
    this.dateApprovalSuperadmin,
    this.status,
    this.statusLine,
    this.statusSuperadmin,
    this.cancelAt,
    this.nama,
    this.avatar,
    this.shift,
  });

  factory Content.fromJson(String str) => Content.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Content.fromMap(Map<String, dynamic> json) => Content(
        id: json["id"],
        usersId: json["users_id"],
        attachmentUrl: json["attachment_url"],
        dateRequest: json["date_request"] == null
            ? null
            : DateTime.parse(json["date_request"]),
        dateRequestFor: json["date_request_for"] == null
            ? null
            : DateTime.parse(json["date_request_for"]),
        clockinTime: json["clockin_time"],
        clockoutTime: json["clockout_time"],
        reasonRequest: json["reason_request"],
        reasonLine: json["reason_line"],
        reasonSuperadmin: json["reason_superadmin"],
        approvalLine: json["approval_line"],
        approvalSuperadmin: json["approval_superadmin"],
        dateApprovalLine: json["date_approval_line"] == null
            ? null
            : DateTime.parse(json["date_approval_line"]),
        dateApprovalSuperadmin: json["date_approval_superadmin"] == null
            ? null
            : DateTime.parse(json["date_approval_superadmin"]),
        status: json["status"],
        statusLine: json["status_line"],
        statusSuperadmin: json["status_superadmin"],
        cancelAt: json["cancel_at"],
        nama: json["nama"],
        avatar: json["avatar"],
        shift: json["shift"] == null ? null : Shift.fromMap(json["shift"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "users_id": usersId,
        "attachment_url": attachmentUrl,
        "date_request": dateRequest?.toIso8601String(),
        "date_request_for":
            "${dateRequestFor!.year.toString().padLeft(4, '0')}-${dateRequestFor!.month.toString().padLeft(2, '0')}-${dateRequestFor!.day.toString().padLeft(2, '0')}",
        "clockin_time": clockinTime,
        "clockout_time": clockoutTime,
        "reason_request": reasonRequest,
        "reason_line": reasonLine,
        "reason_superadmin": reasonSuperadmin,
        "approval_line": approvalLine,
        "approval_superadmin": approvalSuperadmin,
        "date_approval_line": dateApprovalLine?.toIso8601String(),
        "date_approval_superadmin": dateApprovalSuperadmin?.toIso8601String(),
        "status": status,
        "status_line": statusLine,
        "status_superadmin": statusSuperadmin,
        "cancel_at": cancelAt,
        "nama": nama,
        "avatar": avatar,
        "shift": shift?.toMap(),
      };
}

class Shift {
  final String? id;
  final String? shiftName;
  final String? scheduleIn;
  final String? scheduleOut;
  final String? breakStart;
  final String? breakEnd;
  final dynamic description;
  final String? dayoff;
  final String? shiftAllEmployee;
  final String? showInRequest;
  final DateTime? createdAt;
  final String? createdBy;

  Shift({
    this.id,
    this.shiftName,
    this.scheduleIn,
    this.scheduleOut,
    this.breakStart,
    this.breakEnd,
    this.description,
    this.dayoff,
    this.shiftAllEmployee,
    this.showInRequest,
    this.createdAt,
    this.createdBy,
  });

  factory Shift.fromJson(String str) => Shift.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Shift.fromMap(Map<String, dynamic> json) => Shift(
        id: json["id"],
        shiftName: json["shift_name"],
        scheduleIn: json["schedule_in"],
        scheduleOut: json["schedule_out"],
        breakStart: json["break_start"],
        breakEnd: json["break_end"],
        description: json["description"],
        dayoff: json["dayoff"],
        shiftAllEmployee: json["shift_all_employee"],
        showInRequest: json["show_in_request"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "shift_name": shiftName,
        "schedule_in": scheduleIn,
        "schedule_out": scheduleOut,
        "break_start": breakStart,
        "break_end": breakEnd,
        "description": description,
        "dayoff": dayoff,
        "shift_all_employee": shiftAllEmployee,
        "show_in_request": showInRequest,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
      };
}
