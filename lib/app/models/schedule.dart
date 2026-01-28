import 'dart:convert';

Schedule scheduleFromJson(String str) => Schedule.fromJson(json.decode(str));

class Schedule {
  DateTime? startDate;
  ScheduleClass? schedule;

  Schedule({
    required this.startDate,
    this.schedule,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        startDate: DateTime.parse(json["start_date"]),
        schedule: ScheduleClass.fromJson(json["schedule"]),
      );
}

class ScheduleClass {
  String id;
  String schName;
  DateTime effectiveDate;
  ShiftPattern shiftPattern;
  dynamic description;
  DateTime createdAt;
  dynamic createdBy;

  ScheduleClass({
    required this.id,
    required this.schName,
    required this.effectiveDate,
    required this.shiftPattern,
    required this.description,
    required this.createdAt,
    required this.createdBy,
  });

  factory ScheduleClass.fromJson(Map<String, dynamic> json) => ScheduleClass(
        id: json["id"],
        schName: json["sch_name"],
        effectiveDate: DateTime.parse(json["effective_date"]),
        shiftPattern: ShiftPattern.fromJson(json["shift_pattern"]),
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
      );
}

class ShiftPattern {
  int lenght;
  List<Map<String, String?>> pattern;

  ShiftPattern({
    required this.lenght,
    required this.pattern,
  });

  factory ShiftPattern.fromJson(Map<String, dynamic> json) => ShiftPattern(
        lenght: json["lenght"],
        pattern: List<Map<String, String?>>.from(json["pattern"].map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, String?>(k, v)))),
      );
}
