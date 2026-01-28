import 'dart:convert';

class ResponseDetailAttendance {
  String? msg;
  Data? data;

  ResponseDetailAttendance({this.msg, this.data});

  ResponseDetailAttendance copyWith({String? msg, Data? data}) =>
      ResponseDetailAttendance(msg: msg ?? this.msg, data: data ?? this.data);

  factory ResponseDetailAttendance.fromJson(String str) =>
      ResponseDetailAttendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseDetailAttendance.fromMap(Map<String, dynamic> json) =>
      ResponseDetailAttendance(
        msg: json["msg"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {"msg": msg, "data": data?.toMap()};
}

class Data {
  String? shiftName;
  String? scheduleIn;
  String? scheduleOut;
  String? type;
  String? latitude;
  String? longitude;
  String? address;
  String? urlImage;
  DateTime? createdAt;

  Data({
    this.shiftName,
    this.scheduleIn,
    this.scheduleOut,
    this.type,
    this.latitude,
    this.longitude,
    this.address,
    this.urlImage,
    this.createdAt,
  });

  Data copyWith({
    String? shiftName,
    String? scheduleIn,
    String? scheduleOut,
    String? type,
    String? latitude,
    String? longitude,
    String? address,
    String? urlImage,
    DateTime? createdAt,
  }) => Data(
    shiftName: shiftName ?? this.shiftName,
    scheduleIn: scheduleIn ?? this.scheduleIn,
    scheduleOut: scheduleOut ?? this.scheduleOut,
    type: type ?? this.type,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    address: address ?? this.address,
    urlImage: urlImage ?? this.urlImage,
    createdAt: createdAt ?? this.createdAt,
  );

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    shiftName: json["shift_name"],
    scheduleIn: json["schedule_in"],
    scheduleOut: json["schedule_out"],
    type: json["type"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    address: json["address"],
    urlImage: json["url_image"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toMap() => {
    "shift_name": shiftName,
    "schedule_in": scheduleIn,
    "schedule_out": scheduleOut,
    "type": type,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "url_image": urlImage,
    "created_at": createdAt?.toIso8601String(),
  };
}
