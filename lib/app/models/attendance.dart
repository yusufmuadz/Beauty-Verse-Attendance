import 'dart:convert';

class Attendance {
  final dynamic id;
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
  final String? usersId;
  final DateTime? period;
  final String? status;

  Attendance({
    this.id,
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
    this.usersId,
    this.period,
    this.status,
  });

  factory Attendance.fromJson(String str) =>
      Attendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Attendance.fromMap(Map<String, dynamic> json) => Attendance(
        id: json["id"],
        userAttendanceId: json["user_attendance_id"] ?? "",
        shiftId: json["shift_id"] ?? "",
        type: json["type"] ?? "",
        lat: json["lat"] ?? "",
        lang: json["lang"] ?? "",
        coordinate: json["coordinate"] ?? "",
        address: json["address"] ?? "",
        image: json["image"] ?? "",
        urlImage: json["url_image"] ?? "",
        catatan: json["catatan"] ?? "",
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        usersId: json["users_id"] ?? "",
        period: json["period"] == null ? null : DateTime.parse(json["period"]),
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
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
        "users_id": usersId,
        "period": period?.toIso8601String(),
        "status": status,
      };
}
