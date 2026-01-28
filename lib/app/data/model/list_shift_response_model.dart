import 'dart:convert';

import 'package:lancar_cat/app/models/shift.dart';

class ListShiftResponseModel {
  final bool? status;
  final String? message;
  final List<Shift>? data;

  ListShiftResponseModel({this.status, this.message, this.data});

  factory ListShiftResponseModel.fromJson(String str) =>
      ListShiftResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ListShiftResponseModel.fromMap(Map<String, dynamic> json) =>
      ListShiftResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Shift>.from(json["data"]!.map((x) => Shift.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}
