import 'dart:convert';

class SubmitAttendanceResponseModel {
  final bool? status;
  final String? type;
  final String? message;
  final bool? isLateOrEarly;
  final SubmitAttendance? attendance;

  SubmitAttendanceResponseModel({
    this.status,
    this.type,
    this.message,
    this.isLateOrEarly,
    this.attendance,
  });

  factory SubmitAttendanceResponseModel.fromJson(String str) =>
      SubmitAttendanceResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubmitAttendanceResponseModel.fromMap(Map<String, dynamic> json) =>
      SubmitAttendanceResponseModel(
        status: json["status"],
        type: json["type"],
        message: json["message"],
        isLateOrEarly: json["is_late_or_early"],
        attendance: json["attendance"] == null
            ? null
            : SubmitAttendance.fromMap(json["attendance"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "type": type,
        "message": message,
        "is_late_or_early": isLateOrEarly,
        "attendance": attendance?.toMap(),
      };
}

class SubmitAttendance {
  final String? userAttendanceId;
  final String? shiftId;
  final String? type;
  final String? lang;
  final String? lat;
  final String? coordinate;
  final String? address;
  final String? image;
  final String? urlImage;
  final String? catatan;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  SubmitAttendance({
    this.userAttendanceId,
    this.shiftId,
    this.type,
    this.lang,
    this.lat,
    this.coordinate,
    this.address,
    this.image,
    this.urlImage,
    this.catatan,
    this.updatedAt,
    this.createdAt,
  });

  factory SubmitAttendance.fromJson(String str) =>
      SubmitAttendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubmitAttendance.fromMap(Map<String, dynamic> json) =>
      SubmitAttendance(
        userAttendanceId: json["user_attendance_id"],
        shiftId: json["shift_id"],
        type: json["type"],
        lang: json["lang"],
        lat: json["lat"],
        coordinate: json["coordinate"],
        address: json["address"],
        image: json["image"],
        urlImage: json["url_image"],
        catatan: json["catatan"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "user_attendance_id": userAttendanceId,
        "shift_id": shiftId,
        "type": type,
        "lang": lang,
        "lat": lat,
        "coordinate": coordinate,
        "address": address,
        "image": image,
        "url_image": urlImage,
        "catatan": catatan,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
      };
}
