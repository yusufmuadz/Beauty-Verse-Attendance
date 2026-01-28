import 'dart:convert';

class BiodataResponseModel {
  final bool? status;
  final String? message;
  final List<DetailBiodata>? data;

  BiodataResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory BiodataResponseModel.fromJson(String str) =>
      BiodataResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BiodataResponseModel.fromMap(Map<String, dynamic> json) =>
      BiodataResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<DetailBiodata>.from(
                json["data"]!.map((x) => DetailBiodata.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class DetailBiodata {
  final String? id;
  final String? usersId;
  final String? typeApproval;
  final String? from;
  final String? to;
  final String? status;
  final String? reasonRequest;
  final dynamic reasonApproval;
  final DateTime? dateRequest;
  final dynamic dateApproval;
  final dynamic approvedBy;
  final Superadmin? superadmin;

  DetailBiodata({
    this.id,
    this.usersId,
    this.typeApproval,
    this.from,
    this.to,
    this.status,
    this.reasonRequest,
    this.reasonApproval,
    this.dateRequest,
    this.dateApproval,
    this.approvedBy,
    this.superadmin,
  });

  factory DetailBiodata.fromJson(String str) =>
      DetailBiodata.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailBiodata.fromMap(Map<String, dynamic> json) => DetailBiodata(
        id: json["id"],
        usersId: json["users_id"],
        typeApproval: json["type_approval"],
        from: json["from"],
        to: json["to"],
        status: json["status"],
        reasonRequest: json["reason_request"],
        reasonApproval: json["reason_approval"],
        dateRequest: json["date_request"] == null
            ? null
            : DateTime.parse(json["date_request"]),
        dateApproval: json["date_approval"],
        approvedBy: json["approved_by"],
        superadmin: json["superadmin"] == null
            ? null
            : Superadmin.fromMap(json["superadmin"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "users_id": usersId,
        "type_approval": typeApproval,
        "from": from,
        "to": to,
        "status": status,
        "reason_request": reasonRequest,
        "reason_approval": reasonApproval,
        "date_request": dateRequest?.toIso8601String(),
        "date_approval": dateApproval,
        "approved_by": approvedBy,
        "superadmin": superadmin?.toMap(),
      };
}

class Superadmin {
  final String? id;
  final String? nama;

  Superadmin({
    this.id,
    this.nama,
  });

  factory Superadmin.fromJson(String str) =>
      Superadmin.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Superadmin.fromMap(Map<String, dynamic> json) => Superadmin(
        id: json["id"],
        nama: json["nama"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nama": nama,
      };
}
