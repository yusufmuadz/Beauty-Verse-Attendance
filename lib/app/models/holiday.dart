import 'dart:convert';

class Holiday {
  final String? summary;
  final DateTime? end;
  final String? description;

  Holiday({
    this.summary,
    this.end,
    this.description,
  });

  factory Holiday.fromJson(String str) => Holiday.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Holiday.fromMap(Map<String, dynamic> json) => Holiday(
        summary: json["summary"],
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "summary": summary,
        "end":
            "${end!.year.toString().padLeft(4, '0')}-${end!.month.toString().padLeft(2, '0')}-${end!.day.toString().padLeft(2, '0')}",
        "description": description,
      };
}
