import 'dart:convert';

class Overtime {
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
  final dynamic catatan;
  final DateTime? createdAt;
  final dynamic updateAt;

  Overtime({
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

  factory Overtime.fromJson(String str) => Overtime.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Overtime.fromMap(Map<String, dynamic> json) => Overtime(
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
