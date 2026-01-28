import 'dart:convert';

class RespModelLeave {
  final bool? status;
  final int? code;
  final Content? content;
  final String? message;

  RespModelLeave({
    this.status,
    this.code,
    this.content,
    this.message,
  });

  factory RespModelLeave.fromJson(String str) =>
      RespModelLeave.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RespModelLeave.fromMap(Map<String, dynamic> json) => RespModelLeave(
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
  final String? timeOffMasterId;
  final String? userId;
  final String? type;
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
  final String? nama;
  final String? tipeCuti;
  final String? jabatan;
  final String? avatar;
  final List<Attachment>? attachments;

  Content({
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
    this.nama,
    this.tipeCuti,
    this.jabatan,
    this.avatar,
    this.attachments,
  });

  factory Content.fromJson(String str) => Content.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Content.fromMap(Map<String, dynamic> json) => Content(
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
        dateApprovalLine: json["date_approval_line"] == null
            ? null
            : DateTime.parse(json["date_approval_line"]),
        dateApprovalSuperadmin: json["date_approval_superadmin"] == null
            ? null
            : DateTime.parse(json["date_approval_superadmin"]),
        commentApprovalLine: json["comment_approval_line"],
        commentApprovalSuperadmin: json["comment_approval_superadmin"],
        nama: json["nama"],
        tipeCuti: json["tipe_cuti"],
        jabatan: json["jabatan"],
        avatar: json["avatar"],
        attachments: json["attachments"] == null
            ? []
            : List<Attachment>.from(
                json["attachments"]!.map((x) => Attachment.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "time_off_master_id": timeOffMasterId,
        "user_id": userId,
        "type": type,
        "reason": reason,
        "status": status,
        "status_line": statusLine,
        "status_superadmin": statusSuperadmin,
        "start_time_off":
            "${startTimeOff!.year.toString().padLeft(4, '0')}-${startTimeOff!.month.toString().padLeft(2, '0')}-${startTimeOff!.day.toString().padLeft(2, '0')}",
        "end_time_off":
            "${endTimeOff!.year.toString().padLeft(4, '0')}-${endTimeOff!.month.toString().padLeft(2, '0')}-${endTimeOff!.day.toString().padLeft(2, '0')}",
        "cancel_at": cancelAt,
        "date_request": dateRequest?.toIso8601String(),
        "approval_line": approvalLine,
        "approval_superadmin": approvalSuperadmin,
        "date_approval_line": dateApprovalLine?.toIso8601String(),
        "date_approval_superadmin": dateApprovalSuperadmin?.toIso8601String(),
        "comment_approval_line": commentApprovalLine,
        "comment_approval_superadmin": commentApprovalSuperadmin,
        "nama": nama,
        "tipe_cuti": tipeCuti,
        "jabatan": jabatan,
        "avatar": avatar,
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toMap())),
      };
}

class Attachment {
  final int? id;
  final String? requestId;
  final String? file;
  final String? url;

  Attachment({
    this.id,
    this.requestId,
    this.file,
    this.url,
  });

  factory Attachment.fromJson(String str) =>
      Attachment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Attachment.fromMap(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        requestId: json["request_id"],
        file: json["file"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "request_id": requestId,
        "file": file,
        "url": url,
      };
}
