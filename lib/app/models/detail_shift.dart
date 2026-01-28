import 'dart:convert';

class RespModelShift {
  final bool? status;
  final int? code;
  final Content? content;
  final String? message;

  RespModelShift({
    this.status,
    this.code,
    this.content,
    this.message,
  });

  factory RespModelShift.fromJson(String str) =>
      RespModelShift.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RespModelShift.fromMap(Map<String, dynamic> json) => RespModelShift(
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
  final String? shiftIdOld;
  final String? shiftIdNew;
  final String? notes;
  final String? status;
  final String? statusLine;
  final String? statusSuperadmin;
  final String? approvalLine;
  final String? approvalSuperadmin;
  final DateTime? dateApprovalLine;
  final DateTime? dateApprovalSuperadmin;
  final dynamic reasonLine;
  final dynamic reasonSuperadmin;
  final DateTime? dateRequestFor;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final String? nama;
  final String? avatar;
  final DetailShift? oldShift;
  final DetailShift? newShift;

  Content({
    this.id,
    this.usersId,
    this.shiftIdOld,
    this.shiftIdNew,
    this.notes,
    this.status,
    this.statusLine,
    this.statusSuperadmin,
    this.approvalLine,
    this.approvalSuperadmin,
    this.dateApprovalLine,
    this.dateApprovalSuperadmin,
    this.reasonLine,
    this.reasonSuperadmin,
    this.dateRequestFor,
    this.deletedAt,
    this.createdAt,
    this.nama,
    this.avatar,
    this.oldShift,
    this.newShift,
  });

  factory Content.fromJson(String str) => Content.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Content.fromMap(Map<String, dynamic> json) => Content(
        id: json["id"],
        usersId: json["users_id"],
        shiftIdOld: json["shift_id_old"],
        shiftIdNew: json["shift_id_new"],
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
        reasonLine: json["reason_line"],
        reasonSuperadmin: json["reason_superadmin"],
        dateRequestFor: json["date_request_for"] == null
            ? null
            : DateTime.parse(json["date_request_for"]),
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        nama: json["nama"],
        avatar: json["avatar"],
        oldShift: json["old_shift"] == null
            ? null
            : DetailShift.fromMap(json["old_shift"]),
        newShift: json["new_shift"] == null
            ? null
            : DetailShift.fromMap(json["new_shift"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "users_id": usersId,
        "shift_id_old": shiftIdOld,
        "shift_id_new": shiftIdNew,
        "notes": notes,
        "status": status,
        "status_line": statusLine,
        "status_superadmin": statusSuperadmin,
        "approval_line": approvalLine,
        "approval_superadmin": approvalSuperadmin,
        "date_approval_line": dateApprovalLine?.toIso8601String(),
        "date_approval_superadmin": dateApprovalSuperadmin?.toIso8601String(),
        "reason_line": reasonLine,
        "reason_superadmin": reasonSuperadmin,
        "date_request_for":
            "${dateRequestFor!.year.toString().padLeft(4, '0')}-${dateRequestFor!.month.toString().padLeft(2, '0')}-${dateRequestFor!.day.toString().padLeft(2, '0')}",
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "nama": nama,
        "avatar": avatar,
        "old_shift": oldShift?.toMap(),
      };
}

class DetailShift {
  final String? id;
  final String? shiftName;
  final dynamic scheduleIn;
  final dynamic scheduleOut;
  final dynamic breakStart;
  final dynamic breakEnd;
  final dynamic description;
  final String? dayoff;
  final String? shiftAllEmployee;
  final String? showInRequest;
  final DateTime? createdAt;
  final String? createdBy;

  DetailShift({
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

  factory DetailShift.fromJson(String str) =>
      DetailShift.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailShift.fromMap(Map<String, dynamic> json) => DetailShift(
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
