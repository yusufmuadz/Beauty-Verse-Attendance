import 'dart:convert';

class ResponseSubordinate {
  String? msg;
  List<Subordinate>? data;

  ResponseSubordinate({this.msg, this.data});

  ResponseSubordinate copyWith({String? msg, List<Subordinate>? data}) =>
      ResponseSubordinate(msg: msg ?? this.msg, data: data ?? this.data);

  factory ResponseSubordinate.fromJson(String str) =>
      ResponseSubordinate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseSubordinate.fromMap(Map<String, dynamic> json) =>
      ResponseSubordinate(
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<Subordinate>.from(
                json["data"]!.map((x) => Subordinate.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class Subordinate {
  String? nama;
  String? avatar;
  String? id;
  String? jabatan;
  List<Attendance>? attendance;
  int? subordinate;

  Subordinate({
    this.nama,
    this.avatar,
    this.id,
    this.jabatan,
    this.attendance,
    this.subordinate,
  });

  Subordinate copyWith({
    String? nama,
    String? avatar,
    String? id,
    String? jabatan,
    List<Attendance>? attendance,
    int? subordinate,
  }) => Subordinate(
    nama: nama ?? this.nama,
    avatar: avatar ?? this.avatar,
    id: id ?? this.id,
    jabatan: jabatan ?? this.jabatan,
    attendance: attendance ?? this.attendance,
    subordinate: subordinate ?? this.subordinate,
  );

  factory Subordinate.fromJson(String str) =>
      Subordinate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Subordinate.fromMap(Map<String, dynamic> json) => Subordinate(
    nama: json["nama"],
    avatar: json["avatar"],
    id: json["id"],
    jabatan: json["jabatan"],
    attendance: json["attendance"] == null
        ? []
        : List<Attendance>.from(
            json["attendance"]!.map((x) => Attendance.fromMap(x)),
          ),
    subordinate: json["subordinate"],
  );

  Map<String, dynamic> toMap() => {
    "nama": nama,
    "avatar": avatar,
    "id": id,
    "jabatan": jabatan,
    "attendance": attendance == null
        ? []
        : List<dynamic>.from(attendance!.map((x) => x.toMap())),
    "subordinate": subordinate,
  };
}

class Attendance {
  String? shiftName;
  String? type;
  int? id;
  DateTime? presentAt;

  Attendance({this.shiftName, this.type, this.id, this.presentAt});

  Attendance copyWith({
    String? shiftName,
    String? type,
    int? id,
    DateTime? presentAt,
  }) => Attendance(
    shiftName: shiftName ?? this.shiftName,
    type: type ?? this.type,
    id: id ?? this.id,
    presentAt: presentAt ?? this.presentAt,
  );

  factory Attendance.fromJson(String str) =>
      Attendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Attendance.fromMap(Map<String, dynamic> json) => Attendance(
    shiftName: json["shift_name"],
    type: json["type"],
    id: json["id"],
    presentAt: json["present_at"] == null
        ? null
        : DateTime.parse(json["present_at"]),
  );

  Map<String, dynamic> toMap() => {
    "shift_name": shiftName,
    "type": type,
    "id": id,
    "present_at": presentAt?.toIso8601String(),
  };
}
