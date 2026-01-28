import 'dart:convert';

import 'package:lancar_cat/app/data/model/leave_response_model.dart';

class TimeOffResponseModel {
  final bool? status;
  final int? code;
  final List<Approval>? content;
  final String? message;

  TimeOffResponseModel({this.status, this.code, this.content, this.message});

  factory TimeOffResponseModel.fromJson(String str) =>
      TimeOffResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TimeOffResponseModel.fromMap(Map<String, dynamic> json) =>
      TimeOffResponseModel(
        status: json["status"],
        code: json["code"],
        content: json["content"] == null
            ? []
            : List<Approval>.from(
                json["content"]!.map((x) => Approval.fromMap(x)),
              ),
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "code": code,
    "message": message,
  };
}

class Approval {
  final String? id;
  final String? timeOffMasterId;
  final String? userId;
  final String? type;
  final String? reason;
  final String? status;
  final String? statusLine;
  final dynamic statusSuperadmin;
  final DateTime? startTimeOff;
  final DateTime? endTimeOff;
  final dynamic cancelAt;
  final DateTime? dateRequest;
  final String? approvalLine;
  final dynamic approvalSuperadmin;
  final dynamic dateApprovalLine;
  final dynamic dateApprovalSuperadmin;
  final dynamic commentApprovalLine;
  final dynamic commentApprovalSuperadmin;
  final String? lineNama;
  final dynamic superadminNama;
  final String? masterCuti;
  final List<Attach>? attach;

  Approval({
    this.id,
    this.timeOffMasterId,
    this.userId,
    this.type,
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
    this.lineNama,
    this.superadminNama,
    this.masterCuti,
    this.attach,
  });

  factory Approval.fromJson(String str) => Approval.fromMap(json.decode(str));

  factory Approval.fromMap(Map<String, dynamic> json) => Approval(
    id: json["id"],
    timeOffMasterId: json["time_off_master_id"],
    userId: json["user_id"],
    type: json["type"],
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
    dateApprovalLine: json["date_approval_line"],
    dateApprovalSuperadmin: json["date_approval_superadmin"],
    commentApprovalLine: json["comment_approval_line"],
    commentApprovalSuperadmin: json["comment_approval_superadmin"],
    lineNama: json["line_nama"],
    superadminNama: json["superadmin_nama"],
    masterCuti: json["master_cuti"],
    attach: json["attach"] == null
        ? []
        : List<Attach>.from(json["attach"]!.map((x) => Attach.fromMap(x))),
  );
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
