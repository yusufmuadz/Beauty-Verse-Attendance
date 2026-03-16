import 'dart:convert';

import 'agreement_overtime_response_model.dart';

class AttendanceOvertimeResponseModel {
  final bool? status;
  final String? message;
  final DetailOvertime? detailOvertime;
  final String? statusOvertime;
  final Data? data;

  AttendanceOvertimeResponseModel({
    this.status,
    this.message,
    this.detailOvertime,
    this.statusOvertime,
    this.data,
  });

  factory AttendanceOvertimeResponseModel.fromJson(String str) =>
      AttendanceOvertimeResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AttendanceOvertimeResponseModel.fromMap(Map<String, dynamic> json) =>
      AttendanceOvertimeResponseModel(
        status: json["status"],
        message: json["message"],
        detailOvertime: json["detail_overtime"] == null
            ? null
            : DetailOvertime.fromMap(json["detail_overtime"]),
        statusOvertime: json["status_overtime"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "detail_overtime": detailOvertime?.toMap(),
    "status_overtime": statusOvertime,
    "data": data?.toMap(),
  };
}

class Data {
  final String? id;
  final String? usersId;
  final DateTime? period;
  final String? statusOut;
  final String? statusApproval;
  final Clock? clockIn;
  final Clock? clockOut;

  Data({
    this.id,
    this.usersId,
    this.period,
    this.statusOut,
    this.statusApproval,
    this.clockIn,
    this.clockOut,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    id: json["id"],
    usersId: json["users_id"],
    period: json["period"] == null ? null : DateTime.parse(json["period"]),
    statusOut: json["status_out"],
    statusApproval: json["status_approval"],
    clockIn: json["clock_in"] == null ? null : Clock.fromMap(json["clock_in"]),
    clockOut: json["clock_out"] == null
        ? null
        : Clock.fromMap(json["clock_out"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "users_id": usersId,
    "period": period?.toIso8601String(),
    "status_out": statusOut,
    "status_approval": statusApproval,
    "clock_in": clockIn?.toMap(),
    "clock_out": clockOut?.toMap(),
  };
}

class Clock {
  final int? id;
  final String? overtimeAttendanceId;
  final String? overtimeRequestId;
  final String? type;
  final String? lat;
  final String? lang;
  final String? coordinate;
  final String? address;
  final String? image;
  final String? urlImage;
  final String? catatan;
  final DateTime? createdAt;
  final dynamic updateAt;

  Clock({
    this.id,
    this.overtimeAttendanceId,
    this.overtimeRequestId,
    this.type,
    this.lat,
    this.lang,
    this.coordinate,
    this.address,
    this.image,
    this.urlImage,
    this.catatan,
    this.createdAt,
    this.updateAt,
  });

  factory Clock.fromJson(String str) => Clock.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Clock.fromMap(Map<String, dynamic> json) => Clock(
    id: json["id"],
    overtimeAttendanceId: json["overtime_attendance_id"],
    overtimeRequestId: json["overtime_request_id"],
    type: json["type"],
    lat: json["lat"],
    lang: json["lang"],
    coordinate: json["coordinate"],
    address: json["address"],
    image: json["image"],
    urlImage: json["url_image"],
    catatan: json["catatan"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updateAt: json["update_at"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "overtime_attendance_id": overtimeAttendanceId,
    "overtime_request_id": overtimeRequestId,
    "type": type,
    "lat": lat,
    "lang": lang,
    "coordinate": coordinate,
    "address": address,
    "image": image,
    "url_image": urlImage,
    "catatan": catatan,
    "created_at": createdAt?.toIso8601String(),
    "update_at": updateAt,
  };
}
