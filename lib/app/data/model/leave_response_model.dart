import 'dart:convert';

import 'package:lancar_cat/app/data/model/login_response_model.dart';

class LeaveResponseModel {
  final bool? status;
  final String? message;
  final List<Leave>? data;
  final int? pendingLenght;

  LeaveResponseModel({
    this.status,
    this.message,
    this.data,
    this.pendingLenght,
  });

  factory LeaveResponseModel.fromJson(String str) =>
      LeaveResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeaveResponseModel.fromMap(Map<String, dynamic> json) =>
      LeaveResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Leave>.from(json["data"]!.map((x) => Leave.fromMap(x))),
        pendingLenght: json['pending_lenght'] ?? 0,
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "pending_lenght": pendingLenght,
  };
}

class Leave {
  final String? id;
  final String? timeOffMasterId;
  final String? userId;
  final String? reason;
  final String? status;
  final String? statusLine;
  final dynamic statusSuperadmin;
  final DateTime? startTimeOff;
  final DateTime? endTimeOff;
  final dynamic cancelAt;
  final DateTime? dateRequest;
  final String? approvalLine;
  final String? approvalSuperadmin;
  final dynamic dateApprovalLine;
  final dynamic dateApprovalSuperadmin;
  final dynamic commentApprovalLine;
  final dynamic commentApprovalSuperadmin;
  final User? user;
  final Master? master;
  final List<Attach>? attach;

  Leave({
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
    this.user,
    this.master,
    this.attach,
  });

  factory Leave.fromJson(String str) => Leave.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Leave.fromMap(Map<String, dynamic> json) => Leave(
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
    dateApprovalLine: json["date_approval_line"],
    dateApprovalSuperadmin: json["date_approval_superadmin"],
    commentApprovalLine: json["comment_approval_line"],
    commentApprovalSuperadmin: json["comment_approval_superadmin"],
    user: json["user"] == null ? null : User.fromMap(json["user"]),
    master: json["master"] == null ? null : Master.fromMap(json["master"]),
    attach: json["attach"] == null
        ? []
        : List<Attach>.from(json["attach"]!.map((x) => Attach.fromMap(x))),
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
    "date_approval_line": dateApprovalLine,
    "date_approval_superadmin": dateApprovalSuperadmin,
    "comment_approval_line": commentApprovalLine,
    "comment_approval_superadmin": commentApprovalSuperadmin,
    "user": user?.toMap(),
    "master": master?.toMap(),
    "attach": attach == null
        ? []
        : List<dynamic>.from(attach!.map((x) => x.toMap())),
  };
}

class Attach {
  final String? requestId;
  final String? file;
  final String? url;

  Attach({this.requestId, this.file, this.url});

  factory Attach.fromJson(String str) => Attach.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Attach.fromMap(Map<String, dynamic> json) => Attach(
    requestId: json["request_id"],
    file: json["file"],
    url: json["url"],
  );

  Map<String, dynamic> toMap() => {
    "request_id": requestId,
    "file": file,
    "url": url,
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
