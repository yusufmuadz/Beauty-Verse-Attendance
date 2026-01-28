import 'dart:convert';

class ResponseApprovalIndex {
  final ApprovalIndex? data;

  ResponseApprovalIndex({this.data});

  factory ResponseApprovalIndex.fromJson(String str) =>
      ResponseApprovalIndex.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseApprovalIndex.fromMap(Map<String, dynamic> json) =>
      ResponseApprovalIndex(
        data: json["data"] == null ? null : ApprovalIndex.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {"data": data?.toMap()};
}

class ApprovalIndex {
  final int? attendance;
  final int? overtime;
  final int? timeOff;
  final int? shift;
  final int? totalPending;

  ApprovalIndex({
    this.attendance,
    this.overtime,
    this.timeOff,
    this.shift,
    this.totalPending,
  });

  factory ApprovalIndex.fromJson(String str) =>
      ApprovalIndex.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ApprovalIndex.fromMap(Map<String, dynamic> json) => ApprovalIndex(
    attendance: json["attendance"],
    overtime: json["overtime"],
    timeOff: json["time_off"],
    shift: json["shift"],
    totalPending: json["total_pending"],
  );

  Map<String, dynamic> toMap() => {
    "attendance": attendance,
    "overtime": overtime,
    "time_off": timeOff,
    "shift": shift,
    "total_pending": totalPending,
  };
}
