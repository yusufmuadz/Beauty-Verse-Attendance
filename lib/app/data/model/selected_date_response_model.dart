import 'dart:convert';

class SelectedDateResponseModel {
  final bool? status;
  final String? message;
  final Clock? clockin;
  final Clock? clockout;

  SelectedDateResponseModel({
    this.status,
    this.message,
    this.clockin,
    this.clockout,
  });

  factory SelectedDateResponseModel.fromJson(String str) =>
      SelectedDateResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectedDateResponseModel.fromMap(Map<String, dynamic> json) =>
      SelectedDateResponseModel(
        status: json["status"],
        message: json["message"],
        clockin:
            json["clockin"] == null ? null : Clock.fromMap(json["clockin"]),
        clockout:
            json["clockout"] == null ? null : Clock.fromMap(json["clockout"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "clockin": clockin?.toMap(),
        "clockout": clockout?.toMap(),
      };
}

class Clock {
  final String? userAttendanceId;
  final String? shiftId;
  final String? type;
  final String? lat;
  final String? lang;
  final String? coordinate;
  final String? address;
  final String? image;
  final String? urlImage;
  final String? catatan;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Clock({
    this.userAttendanceId,
    this.shiftId,
    this.type,
    this.lat,
    this.lang,
    this.coordinate,
    this.address,
    this.image,
    this.urlImage,
    this.catatan,
    this.createdAt,
    this.updatedAt,
  });

  factory Clock.fromJson(String str) => Clock.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Clock.fromMap(Map<String, dynamic> json) => Clock(
        userAttendanceId: json["user_attendance_id"],
        shiftId: json["shift_id"],
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
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "user_attendance_id": userAttendanceId,
        "shift_id": shiftId,
        "type": type,
        "lat": lat,
        "lang": lang,
        "coordinate": coordinate,
        "address": address,
        "image": image,
        "url_image": urlImage,
        "catatan": catatan,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
