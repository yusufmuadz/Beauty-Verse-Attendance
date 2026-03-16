import 'dart:convert';

import '../../models/attendance.dart';

class AttendanceResponseModel {
  final bool? status;
  final bool? isLateOrEarly;
  final String? type;
  final Attendance? attendance;
  final String? message;

  AttendanceResponseModel({
    this.status,
    this.isLateOrEarly,
    this.type,
    this.attendance,
    this.message,
  });

  factory AttendanceResponseModel.fromRawJson(String str) =>
      AttendanceResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) =>
      AttendanceResponseModel(
        status: json["status"],
        isLateOrEarly: json["is_late_or_early"],
        type: json["type"],
        attendance: json["attendance"] == null
            ? null
            : Attendance.fromJson(json["attendance"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "is_late_or_early": isLateOrEarly,
    "type": type,
    "attendance": attendance?.toJson(),
    "message": message,
  };
}
