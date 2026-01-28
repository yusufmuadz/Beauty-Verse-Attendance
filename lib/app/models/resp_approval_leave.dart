import 'dart:convert';

class RespAppLeave {
  String? message;
  List<AppLeave>? data;

  RespAppLeave({this.message, this.data});

  RespAppLeave copyWith({String? message, List<AppLeave>? data}) =>
      RespAppLeave(message: message ?? this.message, data: data ?? this.data);

  factory RespAppLeave.fromJson(String str) =>
      RespAppLeave.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RespAppLeave.fromMap(Map<String, dynamic> json) => RespAppLeave(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<AppLeave>.from(json["data"]!.map((x) => AppLeave.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class AppLeave {
  String? userId;
  String? nama;
  String? avatar;
  String? id;
  DateTime? dateRequest;
  String? statusLine;
  String? leaveType;

  AppLeave({
    this.userId,
    this.nama,
    this.avatar,
    this.id,
    this.dateRequest,
    this.statusLine,
    this.leaveType,
  });

  AppLeave copyWith({
    String? userId,
    String? nama,
    String? avatar,
    String? id,
    DateTime? dateRequest,
    String? statusLine,
    String? leaveType,
  }) => AppLeave(
    userId: userId ?? this.userId,
    nama: nama ?? this.nama,
    avatar: avatar ?? this.avatar,
    id: id ?? this.id,
    dateRequest: dateRequest ?? this.dateRequest,
    statusLine: statusLine ?? this.statusLine,
    leaveType: leaveType ?? this.leaveType,
  );

  factory AppLeave.fromJson(String str) => AppLeave.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppLeave.fromMap(Map<String, dynamic> json) => AppLeave(
    userId: json["user_id"],
    nama: json["nama"],
    avatar: json["avatar"],
    id: json["id"],
    dateRequest: json["date_request"] == null
        ? null
        : DateTime.parse(json["date_request"]),
    statusLine: json["status_line"],
    leaveType: json["leave_type"],
  );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "nama": nama,
    "avatar": avatar,
    "id": id,
    "date_request": dateRequest?.toIso8601String(),
    "status_line": statusLine,
    "leave_type": leaveType,
  };
}
