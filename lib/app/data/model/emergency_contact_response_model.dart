import 'dart:convert';

class EmergencyContactResponseModel {
  final bool? success;
  final String? message;
  final List<Contact>? data;

  EmergencyContactResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory EmergencyContactResponseModel.fromJson(String str) =>
      EmergencyContactResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EmergencyContactResponseModel.fromMap(Map<String, dynamic> json) =>
      EmergencyContactResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Contact>.from(json["data"]!.map((x) => Contact.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Contact {
  final int? id;
  final String? usersId;
  final String? nama;
  final String? hubungan;
  final String? noTelp;
  final DateTime? createdAt;

  Contact({
    this.id,
    this.usersId,
    this.nama,
    this.hubungan,
    this.noTelp,
    this.createdAt,
  });

  factory Contact.fromJson(String str) => Contact.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
        id: json["id"],
        usersId: json["users_id"],
        nama: json["nama"],
        hubungan: json["hubungan"],
        noTelp: json["no_telp"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "users_id": usersId,
        "nama": nama,
        "hubungan": hubungan,
        "no_telp": noTelp,
        "created_at": createdAt?.toIso8601String(),
      };
}
