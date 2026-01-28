import 'dart:convert';

class ChangeShiftResponseModel {
  final bool? status;
  final String? message;
  final List<ChangeShift>? data;

  ChangeShiftResponseModel({this.status, this.message, this.data});

  factory ChangeShiftResponseModel.fromJson(String str) =>
      ChangeShiftResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChangeShiftResponseModel.fromMap(Map<String, dynamic> json) =>
      ChangeShiftResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ChangeShift>.from(
                json["data"]!.map((x) => ChangeShift.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class ChangeShift {
  final String? id;
  final String? usersId;
  final String? shiftIdOld;
  final String? shiftIdNew;
  final String? notes;
  final String? status;
  final String? statusLine;
  final dynamic statusSuperadmin;
  final String? approvalLine;
  final dynamic approvalSuperadmin;
  final dynamic dateApprovalLine;
  final dynamic dateApprovalSuperadmin;
  final dynamic reasonLine;
  final dynamic reasonSuperadmin;
  final DateTime? dateRequestFor;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final String? shiftNameOld;
  final String? scheduleInOld;
  final String? scheduleOutOld;
  final String? shiftNameNew;
  final dynamic scheduleInNew;
  final dynamic scheduleOutNew;
  final String? user;
  final String? lineName;
  final String? superadminName;
  final String? userAvatarUrl;
  final bool isFlexible;

  ChangeShift({
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
    this.createdAt,
    this.deletedAt,
    this.shiftNameOld,
    this.scheduleInOld,
    this.scheduleOutOld,
    this.shiftNameNew,
    this.scheduleInNew,
    this.scheduleOutNew,
    this.user,
    this.lineName,
    this.superadminName,
    this.userAvatarUrl,
    this.isFlexible = false,
  });

  factory ChangeShift.fromJson(String str) =>
      ChangeShift.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChangeShift.fromMap(Map<String, dynamic> json) => ChangeShift(
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
    dateApprovalLine: json["date_approval_line"],
    dateApprovalSuperadmin: json["date_approval_superadmin"],
    reasonLine: json["reason_line"],
    reasonSuperadmin: json["reason_superadmin"],
    dateRequestFor: json["date_request_for"] == null
        ? null
        : DateTime.parse(json["date_request_for"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    deletedAt: json["deleted_at"],
    shiftNameOld: json["shift_name_old"],
    scheduleInOld: json["schedule_in_old"],
    scheduleOutOld: json["schedule_out_old"],
    shiftNameNew: json["shift_name_new"],
    scheduleInNew: json["schedule_in_new"],
    scheduleOutNew: json["schedule_out_new"],
    user: json["user_name"],
    lineName: json["line_name"],
    superadminName: json["superadmin_name"],
    userAvatarUrl: json["user_avatar_url"],
    isFlexible: json["is_flexible"] ?? false,
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
    "date_approval_line": dateApprovalLine,
    "date_approval_superadmin": dateApprovalSuperadmin,
    "reason_line": reasonLine,
    "reason_superadmin": reasonSuperadmin,
    "date_request_for":
        "${dateRequestFor!.year.toString().padLeft(4, '0')}-${dateRequestFor!.month.toString().padLeft(2, '0')}-${dateRequestFor!.day.toString().padLeft(2, '0')}",
    "created_at": createdAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "shift_name_old": shiftNameOld,
    "schedule_in_old": scheduleInOld,
    "schedule_out_old": scheduleOutOld,
    "shift_name_new": shiftNameNew,
    "schedule_in_new": scheduleInNew,
    "schedule_out_new": scheduleOutNew,
    "user_name": user,
    "line_name": lineName,
    "superadmin_name": superadminName,
    "user_avatar_url": userAvatarUrl,
    "is_flexible": isFlexible,
  };
}
