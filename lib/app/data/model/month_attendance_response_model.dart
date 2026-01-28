import 'dart:convert';

import 'package:lancar_cat/app/models/attendance.dart';
import 'package:lancar_cat/app/models/holiday.dart';
import 'package:lancar_cat/app/models/pattern.dart';

import '../../models/overtime.dart';

class MonthAttendanceResponseModel {
  final bool? status;
  final Detail? detail;
  final List<DetailSchedule>? data;

  MonthAttendanceResponseModel({this.status, this.detail, this.data});

  factory MonthAttendanceResponseModel.fromJson(String str) =>
      MonthAttendanceResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MonthAttendanceResponseModel.fromMap(Map<String, dynamic> json) =>
      MonthAttendanceResponseModel(
        status: json["status"],
        detail: json["detail"] == null ? null : Detail.fromMap(json["detail"]),
        data: json["data"] == null
            ? []
            : List<DetailSchedule>.from(
                json["data"]!.map((x) => DetailSchedule.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "detail": detail?.toMap(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class DetailSchedule {
  final Holiday? holiday;
  final CPattern? pattern;
  final DateTime? date;
  final List<Attendance>? attendance;
  final List<Overtime>? overtimeAttendance;
  final bool? isClockInLate;
  final bool? isClockOutEarly;
  final AbsenRecap? absenRecap;

  DetailSchedule({
    this.holiday,
    this.pattern,
    this.date,
    this.attendance,
    this.overtimeAttendance,
    this.isClockInLate,
    this.isClockOutEarly,
    this.absenRecap,
  });

  factory DetailSchedule.fromJson(String str) =>
      DetailSchedule.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailSchedule.fromMap(Map<String, dynamic> json) => DetailSchedule(
    holiday: json["holiday"] == null ? null : Holiday.fromMap(json["holiday"]),
    pattern: json["pattern"] == null ? null : CPattern.fromMap(json["pattern"]),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    attendance: json["attendance"] == null
        ? []
        : List<Attendance>.from(
            json["attendance"]!.map((x) => Attendance.fromMap(x)),
          ),
    overtimeAttendance: json["attendance_overtime"] == null
        ? []
        : List<Overtime>.from(
            json["attendance_overtime"]!.map((x) => Overtime.fromMap(x)),
          ),
    isClockInLate: json["is_clock_in_late"],
    isClockOutEarly: json["is_clock_out_early"],
    absenRecap: json["absen_recap"] == null
        ? null
        : AbsenRecap.fromMap(json["absen_recap"]),
  );

  Map<String, dynamic> toMap() => {
    "pattern": pattern?.toMap(),
    "date":
        "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "attendance": attendance == null
        ? []
        : List<dynamic>.from(attendance!.map((x) => x.toMap())),
    "is_clock_in_late": isClockInLate,
    "is_clock_out_early": isClockOutEarly,
    "absen_recap": absenRecap?.toMap(),
  };
}

class AbsenRecap {
  final String? id;
  final DateTime? period;
  final String? usersId;
  final String? userAttendanceId;
  final String? userTimeoffRequestId;
  final String? userLateBreakInId;
  final String? userPermitOut;
  final dynamic userOvertimeId;
  final String? name;

  AbsenRecap({
    this.id,
    this.period,
    this.usersId,
    this.userAttendanceId,
    this.userTimeoffRequestId,
    this.userLateBreakInId,
    this.userPermitOut,
    this.userOvertimeId,
    this.name,
  });

  factory AbsenRecap.fromJson(String str) =>
      AbsenRecap.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AbsenRecap.fromMap(Map<String, dynamic> json) => AbsenRecap(
    id: json["id"],
    period: json["period"] == null ? null : DateTime.parse(json["period"]),
    usersId: json["users_id"],
    userAttendanceId: json["user_attendance_id"],
    userTimeoffRequestId: json["user_timeoff_request_id"],
    userLateBreakInId: json["user_late_break_in_id"],
    userPermitOut: json["user_permit_out"],
    userOvertimeId: json["user_overtime_id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "period":
        "${period!.year.toString().padLeft(4, '0')}-${period!.month.toString().padLeft(2, '0')}-${period!.day.toString().padLeft(2, '0')}",
    "users_id": usersId,
    "user_attendance_id": userAttendanceId,
    "user_timeoff_request_id": userTimeoffRequestId,
    "user_late_break_in_id": userLateBreakInId,
    "user_permit_out": userPermitOut,
    "user_overtime_id": userOvertimeId,
    "name": name,
  };
}

class Detail {
  final int? presensi;
  final int? notClockOut;
  final int? lateClockIn;
  final int? earlyClockOut;

  Detail({
    this.presensi,
    this.notClockOut,
    this.lateClockIn,
    this.earlyClockOut,
  });

  factory Detail.fromJson(String str) => Detail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Detail.fromMap(Map<String, dynamic> json) => Detail(
    presensi: json["presensi"],
    notClockOut: json["notClockOut"],
    lateClockIn: json["lateClockIn"],
    earlyClockOut: json["earlyClockOut"],
  );

  Map<String, dynamic> toMap() => {
    "presensi": presensi,
    "notClockOut": notClockOut,
    "lateClockIn": lateClockIn,
    "earlyClockOut": earlyClockOut,
  };
}
