// To parse this JSON data, do
//
//     final master = masterFromJson(jsonString);

import 'dart:convert';

Attach masterFromJson(String str) => Attach.fromJson(json.decode(str));

String masterToJson(Attach data) => json.encode(data.toJson());

class Attach {
  String requestId;
  String file;
  String url;

  Attach({
    required this.requestId,
    required this.file,
    required this.url,
  });

  factory Attach.fromJson(Map<String, dynamic> json) => Attach(
        requestId: json["request_id"],
        file: json["file"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "request_id": requestId,
        "file": file,
        "url": url,
      };
}
