import 'dart:convert';

class LateBreakResponseModel {
  final bool? status;
  final String? message;
  final List<LateBreak>? data;

  LateBreakResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory LateBreakResponseModel.fromJson(String str) =>
      LateBreakResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LateBreakResponseModel.fromMap(Map<String, dynamic> json) =>
      LateBreakResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<LateBreak>.from(
                json["data"]!.map((x) => LateBreak.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class LateBreak {
  final String? id;
  final String? usersId;
  final String? attendanceId;
  final String? lat;
  final String? lang;
  final String? coordinate;
  final String? address;
  final String? image;
  final String? urlImage;
  final String? catatan;
  final DateTime? createdAt;

  LateBreak({
    this.id,
    this.usersId,
    this.attendanceId,
    this.lat,
    this.lang,
    this.coordinate,
    this.address,
    this.image,
    this.urlImage,
    this.catatan,
    this.createdAt,
  });

  factory LateBreak.fromJson(String str) => LateBreak.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LateBreak.fromMap(Map<String, dynamic> json) => LateBreak(
        id: json["id"],
        usersId: json["users_id"],
        attendanceId: json["attendance_id"],
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
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "users_id": usersId,
        "attendance_id": attendanceId,
        "lat": lat,
        "lang": lang,
        "coordinate": coordinate,
        "address": address,
        "image": image,
        "url_image": urlImage,
        "catatan": catatan,
        "created_at": createdAt?.toIso8601String(),
      };
}
