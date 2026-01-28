import 'dart:convert';

import 'package:lancar_cat/app/data/model/login_response_model.dart';

class IdentifyJobScopeResponseModel {
  final bool? status;
  final String? message;
  final List<User>? data;

  IdentifyJobScopeResponseModel({this.status, this.message, this.data});

  factory IdentifyJobScopeResponseModel.fromJson(String str) =>
      IdentifyJobScopeResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory IdentifyJobScopeResponseModel.fromMap(Map<String, dynamic> json) =>
      IdentifyJobScopeResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<User>.from(json["data"]!.map((x) => User.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}
