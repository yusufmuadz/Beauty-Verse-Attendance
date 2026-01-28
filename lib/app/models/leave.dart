import 'dart:convert';

class ResponseModelLeave {
  final bool? status;
  final String? message;
  final List<Leave>? data;

  ResponseModelLeave({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseModelLeave.fromJson(String str) =>
      ResponseModelLeave.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseModelLeave.fromMap(Map<String, dynamic> json) =>
      ResponseModelLeave(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Leave>.from(json["data"]!.map((x) => Leave.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Leave {
  final String? type;
  final DateTime? startTimeOff;
  final DateTime? endTimeOff;
  final String? statusSuperadmin;
  final String? reason;

  Leave({
    this.type,
    this.startTimeOff,
    this.endTimeOff,
    this.statusSuperadmin,
    this.reason,
  });

  factory Leave.fromJson(String str) => Leave.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Leave.fromMap(Map<String, dynamic> json) => Leave(
        type: json["type"],
        startTimeOff: json["start_time_off"] == null
            ? null
            : DateTime.parse(json["start_time_off"]),
        endTimeOff: json["end_time_off"] == null
            ? null
            : DateTime.parse(json["end_time_off"]),
        statusSuperadmin: json["status_superadmin"],
        reason: json["reason"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "start_time_off":
            "${startTimeOff!.year.toString().padLeft(4, '0')}-${startTimeOff!.month.toString().padLeft(2, '0')}-${startTimeOff!.day.toString().padLeft(2, '0')}",
        "end_time_off":
            "${endTimeOff!.year.toString().padLeft(4, '0')}-${endTimeOff!.month.toString().padLeft(2, '0')}-${endTimeOff!.day.toString().padLeft(2, '0')}",
        "status_superadmin": statusSuperadmin,
        "reason": reason,
      };
}
