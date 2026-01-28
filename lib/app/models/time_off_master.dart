import 'dart:convert';

class TimeOffMaster {
  final String? id;
  final String? name;
  final String? code;
  final DateTime? effectiveDate;
  final dynamic description;
  final String? show;
  final DateTime? createdAt;

  TimeOffMaster({
    this.id,
    this.name,
    this.code,
    this.effectiveDate,
    this.description,
    this.show,
    this.createdAt,
  });

  factory TimeOffMaster.fromJson(String str) =>
      TimeOffMaster.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TimeOffMaster.fromMap(Map<String, dynamic> json) => TimeOffMaster(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        effectiveDate: json["effective_date"] == null
            ? null
            : DateTime.parse(json["effective_date"]),
        description: json["description"],
        show: json["show"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "code": code,
        "effective_date":
            "${effectiveDate!.year.toString().padLeft(4, '0')}-${effectiveDate!.month.toString().padLeft(2, '0')}-${effectiveDate!.day.toString().padLeft(2, '0')}",
        "description": description,
        "show": show,
        "created_at": createdAt?.toIso8601String(),
      };
}
