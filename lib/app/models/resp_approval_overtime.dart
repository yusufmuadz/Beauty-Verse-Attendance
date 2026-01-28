import 'dart:convert';

class RespApprovalOvertime {
  final bool? status;
  final List<ApprovalOvertime>? data;

  RespApprovalOvertime({this.status, this.data});

  RespApprovalOvertime copyWith({bool? status, List<ApprovalOvertime>? data}) =>
      RespApprovalOvertime(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory RespApprovalOvertime.fromRawJson(String str) =>
      RespApprovalOvertime.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RespApprovalOvertime.fromJson(Map<String, dynamic> json) =>
      RespApprovalOvertime(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<ApprovalOvertime>.from(
                json["data"]!.map((x) => ApprovalOvertime.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ApprovalOvertime {
  final String? id;
  final String? avatar;
  final String? nama;
  final String? statusLine;
  final String? type;
  final DateTime? dateRequestFor;

  ApprovalOvertime({
    this.id,
    this.avatar,
    this.nama,
    this.statusLine,
    this.type,
    this.dateRequestFor,
  });

  ApprovalOvertime copyWith({
    String? id,
    String? avatar,
    String? nama,
    String? statusLine,
    String? type,
    DateTime? dateRequestFor,
  }) => ApprovalOvertime(
    id: id ?? this.id,
    avatar: avatar ?? this.avatar,
    nama: nama ?? this.nama,
    statusLine: statusLine ?? this.statusLine,
    type: type ?? this.type,
    dateRequestFor: dateRequestFor ?? this.dateRequestFor,
  );

  factory ApprovalOvertime.fromRawJson(String str) =>
      ApprovalOvertime.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApprovalOvertime.fromJson(Map<String, dynamic> json) =>
      ApprovalOvertime(
        id: json["id"],
        avatar: json["avatar"],
        nama: json["nama"],
        statusLine: json["status_line"],
        type: json["type"],
        dateRequestFor: json["date_request_for"] == null
            ? null
            : DateTime.parse(json["date_request_for"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "nama": nama,
    "status_line": statusLine,
    "type": type,
    "date_request_for":
        "${dateRequestFor!.year.toString().padLeft(4, '0')}-${dateRequestFor!.month.toString().padLeft(2, '0')}-${dateRequestFor!.day.toString().padLeft(2, '0')}",
  };
}
