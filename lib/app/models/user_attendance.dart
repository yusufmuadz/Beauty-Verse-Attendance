import 'dart:convert';

import '../modules/services/daftar_absen/views/daftar_absen_riwayat_view.dart';
import 'attendance.dart';

class UserAttendance {
  final String? id;
  final String? usersId;
  final DateTime? period;
  final String? status;
  final List<Attendance>? details;

  UserAttendance({
    this.id,
    this.usersId,
    this.period,
    this.status,
    this.details,
  });

  factory UserAttendance.fromJson(String str) =>
      UserAttendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserAttendance.fromMap(Map<String, dynamic> json) => UserAttendance(
    id: json["id"],
    usersId: json["users_id"],
    period: json["period"] == null ? null : DateTime.parse(json["period"]),
    status: json["status"],
    details: json["details"] == null
        ? []
        : List<Attendance>.from(
            json["details"]!.map((x) => Attendance.fromMap(x)),
          ),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "users_id": usersId,
    "period": period?.toIso8601String(),
    "status": status,
    "details": details == null
        ? []
        : List<dynamic>.from(details!.map((x) => x.toMap())),
  };

  map(ListTileInfo Function(dynamic e) param0) {}
}
