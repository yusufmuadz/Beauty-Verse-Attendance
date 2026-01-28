import 'dart:convert';

class LogSubmissionResponseModel {
  final String? message;
  final List<Permit>? permit;
  final LateBreak? lateBreak;

  LogSubmissionResponseModel({
    this.message,
    this.permit,
    this.lateBreak,
  });

  factory LogSubmissionResponseModel.fromJson(String str) =>
      LogSubmissionResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LogSubmissionResponseModel.fromMap(Map<String, dynamic> json) =>
      LogSubmissionResponseModel(
        message: json["message"],
        permit: json["permit"] == null
            ? []
            : List<Permit>.from(json["permit"]!.map((x) => Permit.fromMap(x))),
        lateBreak: json["late_break"] == null
            ? null
            : LateBreak.fromMap(json["late_break"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "permit": permit == null
            ? []
            : List<dynamic>.from(permit!.map((x) => x.toMap())),
        "late_break": lateBreak?.toMap(),
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

class Permit {
  final String? id;
  final String? usersId;
  final String? attendanceId;
  final String? type;
  final String? lat;
  final String? lang;
  final String? coordinate;
  final String? address;
  final String? catatan;
  final DateTime? createdAt;

  Permit({
    this.id,
    this.usersId,
    this.attendanceId,
    this.type,
    this.lat,
    this.lang,
    this.coordinate,
    this.address,
    this.catatan,
    this.createdAt,
  });

  factory Permit.fromJson(String str) => Permit.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Permit.fromMap(Map<String, dynamic> json) => Permit(
        id: json["id"],
        usersId: json["users_id"],
        attendanceId: json["attendance_id"],
        type: json["type"],
        lat: json["lat"],
        lang: json["lang"],
        coordinate: json["coordinate"],
        address: json["address"],
        catatan: json["catatan"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "users_id": usersId,
        "attendance_id": attendanceId,
        "type": type,
        "lat": lat,
        "lang": lang,
        "coordinate": coordinate,
        "address": address,
        "catatan": catatan,
        "created_at": createdAt?.toIso8601String(),
      };
}
