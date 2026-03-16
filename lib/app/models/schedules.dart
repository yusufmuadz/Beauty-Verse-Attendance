
import 'attendance.dart';
import 'pattern.dart';

class SchedulesPackage {
  final List<Schedules>? schedules;
  final Map<String, dynamic>? detail;

  SchedulesPackage({this.detail, this.schedules});

  factory SchedulesPackage.fromJson(Map<String, dynamic> json) {
    return SchedulesPackage(
      detail: json['detail'],
      schedules: (json['data'] as List<dynamic>)
          .map((e) => Schedules.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Schedules {
  final DateTime date;
  final List<Attendance>? attendance;
  final CPattern pattern;
  final bool isClockInLate;
  final bool isClockOutEarly;

  Schedules({
    required this.isClockInLate,
    required this.isClockOutEarly,
    required this.date,
    required this.attendance,
    required this.pattern,
  });

  factory Schedules.fromJson(Map<String, dynamic> json) => Schedules(
    isClockInLate: json["is_clock_in_late"],
    isClockOutEarly: json["is_clock_out_early"],
    date: DateTime.parse(json["date"]),
    attendance: (json['attendance'] as List?)
        ?.map((e) => Attendance.fromJson(e))
        .toList(),
    pattern: CPattern.fromJson(json["pattern"]),
  );
}
