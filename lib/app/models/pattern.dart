import 'dart:convert';

class CPattern {
  final String? id;
  final String? shiftName;
  final dynamic scheduleIn;
  final dynamic scheduleOut;
  final dynamic breakStart;
  final dynamic breakEnd;
  final dynamic description;
  final String? dayoff;
  final String? shiftAllEmployee;
  final String? showInRequest;
  final DateTime? createdAt;
  final String? createdBy;

  CPattern({
    this.id,
    this.shiftName,
    this.scheduleIn,
    this.scheduleOut,
    this.breakStart,
    this.breakEnd,
    this.description,
    this.dayoff,
    this.shiftAllEmployee,
    this.showInRequest,
    this.createdAt,
    this.createdBy,
  });

  factory CPattern.fromJson(String str) => CPattern.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CPattern.fromMap(Map<String, dynamic> json) => CPattern(
        id: json["id"],
        shiftName: json["shift_name"],
        scheduleIn: json["schedule_in"],
        scheduleOut: json["schedule_out"],
        breakStart: json["break_start"],
        breakEnd: json["break_end"],
        description: json["description"],
        dayoff: json["dayoff"],
        shiftAllEmployee: json["shift_all_employee"],
        showInRequest: json["show_in_request"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "shift_name": shiftName,
        "schedule_in": scheduleIn,
        "schedule_out": scheduleOut,
        "break_start": breakStart,
        "break_end": breakEnd,
        "description": description,
        "dayoff": dayoff,
        "shift_all_employee": shiftAllEmployee,
        "show_in_request": showInRequest,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
      };
}
