import 'dart:convert';

class ResponseModelBarangPermintaan {
  final bool? status;
  final int? code;
  final List<Barang>? content;
  final String? message;

  ResponseModelBarangPermintaan({
    this.status,
    this.code,
    this.content,
    this.message,
  });

  factory ResponseModelBarangPermintaan.fromJson(String str) =>
      ResponseModelBarangPermintaan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseModelBarangPermintaan.fromMap(Map<String, dynamic> json) =>
      ResponseModelBarangPermintaan(
        status: json["status"],
        code: json["code"],
        content: json["content"] == null
            ? []
            : List<Barang>.from(json["content"]!.map((x) => Barang.fromMap(x))),
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

class Barang {
  final String? id;
  final String? namaStok;
  final int? underLimit;
  final int? outOfStock;
  int? jumlahBarang;
  String? warna;
  String? ukuran;
  String? diperlukanUntuk;
  bool urgensi;
  Map<String, dynamic>? data;

  Barang({
    this.id,
    this.namaStok,
    this.underLimit,
    this.outOfStock,
    this.jumlahBarang = 1,
    this.warna,
    this.ukuran,
    this.diperlukanUntuk,
    this.urgensi = false,
    this.data,
  });

  factory Barang.fromJson(String str) => Barang.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Barang.fromMap(Map<String, dynamic> json) => Barang(
        id: json["id"],
        namaStok: json["nama_stok"],
        underLimit: json["under_limit"],
        outOfStock: json["out_of_stock"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nama_stok": namaStok,
        "under_limit": underLimit,
        "out_of_stock": outOfStock,
        "jumlah_barang": jumlahBarang,
        "warna": warna,
        "ukurang": ukuran,
        "diperlukan_untuk": diperlukanUntuk,
        "urgensi": urgensi,
        "data": data,
      };
}
