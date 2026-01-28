import 'dart:convert';
import 'package:lancar_cat/app/models/shift.dart';

class ShiftResponseModel {
  final bool? status;
  final String? message;
  final Shift? shift;

  ShiftResponseModel({this.status, this.message, this.shift});

  factory ShiftResponseModel.fromJson(String str) =>
      ShiftResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShiftResponseModel.fromMap(Map<String, dynamic> json) =>
      ShiftResponseModel(
        status: json["status"],
        message: json["message"],
        shift: json["shift"] == null ? null : Shift.fromMap(json["shift"]),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "shift": shift?.toMap(),
  };
}
