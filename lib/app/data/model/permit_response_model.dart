import 'dart:convert';

class PermitResponseModel {
  final bool? status;
  final String? message;
  final Permit? latest;
  final List<Permit>? logs;

  PermitResponseModel({
    this.status,
    this.message,
    this.latest,
    this.logs,
  });

  factory PermitResponseModel.fromJson(String str) =>
      PermitResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PermitResponseModel.fromMap(Map<String, dynamic> json) =>
      PermitResponseModel(
        status: json["status"],
        message: json["message"],
        latest: json["latest"] == null ? null : Permit.fromMap(json["latest"]),
        logs: json["logs"] == null
            ? []
            : List<Permit>.from(json["logs"]!.map((x) => Permit.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "latest": latest?.toMap(),
        "logs":
            logs == null ? [] : List<dynamic>.from(logs!.map((x) => x.toMap())),
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
