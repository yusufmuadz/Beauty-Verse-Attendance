import 'dart:convert';

class ResponseModelTipePermintaan {
  final bool? status;
  final int? code;
  final List<TipePermintaan>? content;
  final String? message;

  ResponseModelTipePermintaan({
    this.status,
    this.code,
    this.content,
    this.message,
  });

  factory ResponseModelTipePermintaan.fromJson(String str) =>
      ResponseModelTipePermintaan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseModelTipePermintaan.fromMap(Map<String, dynamic> json) =>
      ResponseModelTipePermintaan(
        status: json["status"],
        code: json["code"],
        content: json["content"] == null
            ? []
            : List<TipePermintaan>.from(
                json["content"]!.map((x) => TipePermintaan.fromMap(x))),
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toMap())),
        "message": message,
      };
}

class TipePermintaan {
  final String? id;
  final String? code;
  final String? name;
  final String? slug;
  final int? withItem;
  final int? isPermintaanProduksi;
  final int? isShow;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TipePermintaan({
    this.id,
    this.code,
    this.name,
    this.slug,
    this.withItem,
    this.isPermintaanProduksi,
    this.isShow,
    this.createdAt,
    this.updatedAt,
  });

  factory TipePermintaan.fromJson(String str) =>
      TipePermintaan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TipePermintaan.fromMap(Map<String, dynamic> json) => TipePermintaan(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        slug: json["slug"],
        withItem: json["with_item"],
        isPermintaanProduksi: json["is_permintaan_produksi"],
        isShow: json["is_show"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "code": code,
        "name": name,
        "slug": slug,
        "with_item": withItem,
        "is_permintaan_produksi": isPermintaanProduksi,
        "is_show": isShow,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
