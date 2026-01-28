import 'dart:convert';

class TimeoffSubmissionResponseModel {
  final bool? status;
  final String? message;
  final Data? data;
  final Files? files;

  TimeoffSubmissionResponseModel({
    this.status,
    this.message,
    this.data,
    this.files,
  });

  factory TimeoffSubmissionResponseModel.fromJson(String str) =>
      TimeoffSubmissionResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TimeoffSubmissionResponseModel.fromMap(Map<String, dynamic> json) =>
      TimeoffSubmissionResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
        files: json["files"] == null ? null : Files.fromMap(json["files"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data?.toMap(),
        "files": files?.toMap(),
      };
}

class Data {
  final String? id;
  final String? timeOffMasterId;
  final String? userId;
  final String? reason;
  final String? approvalLine;
  final dynamic approvalSuperadmin;
  final String? startTimeOff;
  final String? endTimeOff;

  Data({
    this.id,
    this.timeOffMasterId,
    this.userId,
    this.reason,
    this.approvalLine,
    this.approvalSuperadmin,
    this.startTimeOff,
    this.endTimeOff,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        timeOffMasterId: json["time_off_master_id"],
        userId: json["user_id"],
        reason: json["reason"],
        approvalLine: json["approval_line"],
        approvalSuperadmin: json["approval_superadmin"],
        startTimeOff: json["start_time_off"],
        endTimeOff: json["end_time_off"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "time_off_master_id": timeOffMasterId,
        "user_id": userId,
        "reason": reason,
        "approval_line": approvalLine,
        "approval_superadmin": approvalSuperadmin,
        "start_time_off": startTimeOff,
        "end_time_off": endTimeOff,
      };
}

class Files {
  final String? requestId;
  final String? file;
  final String? url;

  Files({
    this.requestId,
    this.file,
    this.url,
  });

  factory Files.fromJson(String str) => Files.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Files.fromMap(Map<String, dynamic> json) => Files(
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
