class   Locations {
  String? message;
  List<Location>? locations;
  Setting? setting;

  Locations({
    this.message,
    this.locations,
    this.setting,
  });

  factory Locations.fromJson(Map<String, dynamic> json) => Locations(
        message: json["message"],
        locations: List<Location>.from(
            json["locations"].map((x) => Location.fromJson(x))),
        setting: Setting.fromJson(json["setting"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "locations": List<dynamic>.from(locations!.map((x) => x.toJson())),
        "setting": setting!.toJson(),
      };
}

class Location {
  String? liveAttendanceId;
  String? locName;
  String? address;
  String? lat;
  String? lng;
  String? coordinate;
  int? radius;

  Location({
    required this.liveAttendanceId,
    required this.locName,
    required this.address,
    required this.lat,
    required this.lng,
    required this.coordinate,
    required this.radius,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        liveAttendanceId: json["live_attendance_id"] ?? null,
        locName: json["loc_name"] ?? null,
        address: json["address"] ?? null,
        lat: json["lat"] ?? null,
        lng: json["lng"] ?? null,
        coordinate: json["coordinate"] ?? null,
        radius: json["radius"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "live_attendance_id": liveAttendanceId,
        "loc_name": locName,
        "address": address,
        "lat": lat,
        "lng": lng,
        "coordinate": coordinate,
        "radius": radius,
      };
}

class Setting {
  String id;
  String liveAttendanceName;
  String flexible;
  DateTime createdAt;
  dynamic updatedAt;

  Setting({
    required this.id,
    required this.liveAttendanceName,
    required this.flexible,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        id: json["id"],
        liveAttendanceName: json["live_attendance_name"],
        flexible: json["flexible"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "live_attendance_name": liveAttendanceName,
        "flexible": flexible,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}
