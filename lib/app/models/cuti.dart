// To parse this JSON data, do
//
//     final approval = approvalFromJson(jsonString);

import 'dart:convert';

List<Approval> approvalFromJson(String str) =>
    List<Approval>.from(json.decode(str).map((x) => Approval.fromJson(x)));

class Approval {
  String id;
  String timeOffMasterId;
  String userId;
  String? reason;
  String status;
  String statusLine;
  String? statusSuperadmin;
  DateTime dateRequest;
  String approvalLine;
  String approvalSuperadmin;
  DateTime? dateApprovalLine;
  DateTime? dateApprovalSuperadmin;
  String? commentApprovalLine;
  dynamic commentApprovalSuperadmin;
  String lineNama;
  String startTimeOff;
  String endTimeOff;
  List<Attach>? attach;
  Master master;

  Approval(
      {required this.id,
      required this.timeOffMasterId,
      required this.userId,
      required this.reason,
      required this.status,
      required this.statusLine,
      required this.statusSuperadmin,
      required this.dateRequest,
      required this.approvalLine,
      required this.approvalSuperadmin,
      required this.dateApprovalLine,
      required this.dateApprovalSuperadmin,
      required this.commentApprovalLine,
      required this.commentApprovalSuperadmin,
      required this.lineNama,
      required this.attach,
      required this.master,
      required this.startTimeOff,
      required this.endTimeOff});

  factory Approval.fromJson(Map<String, dynamic> json) => Approval(
        id: json["id"],
        timeOffMasterId: json["time_off_master_id"],
        userId: json["user_id"],
        reason: json["reason"],
        status: json["status"],
        statusLine: json["status_line"],
        statusSuperadmin: json["status_superadmin"],
        dateRequest: DateTime.parse(json["date_request"]),
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
        lineNama: json["line_nama"],
        attach: json["attach"] == null
            ? null
            : List<Attach>.from(json["attach"].map((x) => Attach.fromJson(x))),
        master: Master.fromJson(json["master"]),
        startTimeOff: json['start_time_off'],
        endTimeOff: json['end_time_off'],
      );
}

class Attach {
  String requestId;
  String file;
  String url;

  Attach({
    required this.requestId,
    required this.file,
    required this.url,
  });

  factory Attach.fromJson(Map<String, dynamic> json) => Attach(
        requestId: json["request_id"],
        file: json["file"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "request_id": requestId,
        "file": file,
        "url": url,
      };
}

class Master {
  String id;
  String name;
  String code;
  DateTime effectiveDate;
  dynamic description;
  String show;
  DateTime createdAt;

  Master({
    required this.id,
    required this.name,
    required this.code,
    required this.effectiveDate,
    required this.description,
    required this.show,
    required this.createdAt,
  });

  factory Master.fromJson(Map<String, dynamic> json) => Master(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        effectiveDate: DateTime.parse(json["effective_date"]),
        description: json["description"],
        show: json["show"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "effective_date":
            "${effectiveDate.year.toString().padLeft(4, '0')}-${effectiveDate.month.toString().padLeft(2, '0')}-${effectiveDate.day.toString().padLeft(2, '0')}",
        "description": description,
        "show": show,
        "created_at": createdAt.toIso8601String(),
      };
}
