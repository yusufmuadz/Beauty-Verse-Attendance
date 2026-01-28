import 'dart:convert';

class RespSubmissionAttendance {
  bool? status;
  String? message;
  List<SubAttendance>? data;

  RespSubmissionAttendance({this.status, this.message, this.data});

  RespSubmissionAttendance copyWith({
    bool? status,
    String? message,
    List<SubAttendance>? data,
  }) => RespSubmissionAttendance(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory RespSubmissionAttendance.fromJson(String str) =>
      RespSubmissionAttendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RespSubmissionAttendance.fromMap(Map<String, dynamic> json) =>
      RespSubmissionAttendance(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<SubAttendance>.from(
                json["data"]!.map((x) => SubAttendance.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class SubAttendance {
  String? nama;
  String? userId;
  String? avatar;
  String? id;
  DateTime? dateRequest;
  DateTime? dateRequestFor;
  String? statusLine;

  SubAttendance({
    this.nama,
    this.userId,
    this.avatar,
    this.id,
    this.dateRequest,
    this.dateRequestFor,
    this.statusLine,
  });

  SubAttendance copyWith({
    String? nama,
    String? userId,
    String? avatar,
    String? id,
    DateTime? dateRequest,
    DateTime? dateRequestFor,
    String? statusLine,
  }) => SubAttendance(
    nama: nama ?? this.nama,
    userId: userId ?? this.userId,
    avatar: avatar ?? this.avatar,
    id: id ?? this.id,
    dateRequest: dateRequest ?? this.dateRequest,
    dateRequestFor: dateRequestFor ?? this.dateRequestFor,
    statusLine: statusLine ?? this.statusLine,
  );

  factory SubAttendance.fromJson(String str) =>
      SubAttendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubAttendance.fromMap(Map<String, dynamic> json) => SubAttendance(
    nama: json["nama"],
    userId: json["user_id"],
    avatar: json["avatar"],
    id: json["id"],
    dateRequest: json["date_request"] == null
        ? null
        : DateTime.parse(json["date_request"]),
    dateRequestFor: json["date_request_for"] == null
        ? null
        : DateTime.parse(json["date_request_for"]),
    statusLine: json["status_line"],
  );

  Map<String, dynamic> toMap() => {
    "nama": nama,
    "user_id": userId,
    "avatar": avatar,
    "id": id,
    "date_request": dateRequest?.toIso8601String(),
    "date_request_for":
        "${dateRequestFor!.year.toString().padLeft(4, '0')}-${dateRequestFor!.month.toString().padLeft(2, '0')}-${dateRequestFor!.day.toString().padLeft(2, '0')}",
    "status_line": statusLine,
  };
}
