import 'dart:convert';

class SuperadminResponseModel {
  final bool? status;
  final String? message;
  final List<DetailApprove>? data;

  SuperadminResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory SuperadminResponseModel.fromJson(String str) =>
      SuperadminResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SuperadminResponseModel.fromMap(Map<String, dynamic> json) =>
      SuperadminResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<DetailApprove>.from(
                json["data"]!.map((x) => DetailApprove.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class DetailApprove {
  final String? usersId;
  final String? approvedBy;
  final String? statusSuperadmin;
  final String? status;
  final Superadmin? superadmin;
  final String? userId;
  final String? approvalSuperadmin;
  final String? reason;
  final String? reasonSuperadmin;
  final DateTime? dateApprovalSuperadmin;

  DetailApprove({
    this.usersId,
    this.approvedBy,
    this.statusSuperadmin,
    this.status,
    this.superadmin,
    this.userId,
    this.reason,
    this.reasonSuperadmin,
    this.approvalSuperadmin,
    this.dateApprovalSuperadmin,
  });

  factory DetailApprove.fromJson(String str) =>
      DetailApprove.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailApprove.fromMap(Map<String, dynamic> json) => DetailApprove(
        usersId: json["users_id"],
        approvedBy: json["approved_by"],
        statusSuperadmin: json["status_superadmin"],
        status: json["status"],
        superadmin: json["superadmin"] == null
            ? null
            : Superadmin.fromMap(json["superadmin"]),
        userId: json["user_id"],
        approvalSuperadmin: json["approval_superadmin"],
        reason: json["reason"],
        reasonSuperadmin: json["reason_superadmin"],
        dateApprovalSuperadmin: json["date_approval_superadmin"] == null
            ? null
            : DateTime.parse(json["date_approval_superadmin"]),
      );

  Map<String, dynamic> toMap() => {
        "users_id": usersId,
        "approved_by": approvedBy,
        "status_superadmin": statusSuperadmin,
        "status": status,
        "superadmin": superadmin?.toMap(),
        "user_id": userId,
        "reason": reason,
        "reason_superadmin": reasonSuperadmin,
        "approval_superadmin": approvalSuperadmin,
        "date_approval_superadmin": dateApprovalSuperadmin?.toIso8601String(),
      };
}

class Superadmin {
  final String? id;
  final String? nama;
  final String? avatar;

  Superadmin({
    this.id,
    this.nama,
    this.avatar,
  });

  factory Superadmin.fromJson(String str) =>
      Superadmin.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Superadmin.fromMap(Map<String, dynamic> json) =>
      Superadmin(id: json["id"], nama: json["nama"], avatar: json["avatar"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "nama": nama,
        "avatar": avatar,
      };
}
