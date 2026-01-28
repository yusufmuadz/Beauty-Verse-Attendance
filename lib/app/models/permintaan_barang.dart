// import 'dart:convert';

// class ResponseModelPermintaanBarang {
//   final bool? status;
//   final int? code;
//   final List<PermintaanBarang>? content;
//   final String? message;

//   ResponseModelPermintaanBarang({
//     this.status,
//     this.code,
//     this.content,
//     this.message,
//   });

//   factory ResponseModelPermintaanBarang.fromJson(String str) =>
//       ResponseModelPermintaanBarang.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory ResponseModelPermintaanBarang.fromMap(Map<String, dynamic> json) =>
//       ResponseModelPermintaanBarang(
//         status: json["status"],
//         code: json["code"],
//         content: json["content"] == null
//             ? []
//             : List<PermintaanBarang>.from(
//                 json["content"]!.map((x) => PermintaanBarang.fromMap(x)),
//               ),
//         message: json["message"],
//       );

//   Map<String, dynamic> toMap() => {
//     "status": status,
//     "code": code,
//     "content": content == null
//         ? []
//         : List<dynamic>.from(content!.map((x) => x.toMap())),
//     "message": message,
//   };
// }

// class PermintaanBarang {
//   final DateTime? tanggalPermintaan;
//   final String? permintaanId;
//   final String? pemohon;
//   final String? jabatan;
//   final String? tipePermintaan;
//   final int? itChecking;
//   final dynamic penerimaBarang;
//   final String? noPermintaan;
//   final String? statusPermintaan;
//   final dynamic catatan;
//   final List<TrackingBarang>? trackingBarang;
//   final String? status;
//   final String? jumlahPermintaan;
//   final List<ListBarang>? listBarang;

//   PermintaanBarang({
//     this.tanggalPermintaan,
//     this.permintaanId,
//     this.pemohon,
//     this.jabatan,
//     this.catatan,
//     this.tipePermintaan,
//     this.itChecking,
//     this.penerimaBarang,
//     this.trackingBarang,
//     this.statusPermintaan,
//     this.status,
//     this.noPermintaan,
//     this.jumlahPermintaan,
//     this.listBarang,
//   });

//   factory PermintaanBarang.fromJson(String str) =>
//       PermintaanBarang.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory PermintaanBarang.fromMap(Map<String, dynamic> json) =>
//       PermintaanBarang(
//         tanggalPermintaan: json["tanggal_permintaan"] == null
//             ? null
//             : DateTime.parse(json["tanggal_permintaan"]),
//         permintaanId: json["permintaan_id"],
//         pemohon: json["pemohon"],
//         jabatan: json["jabatan"],
//         penerimaBarang: json["penerima_barang"],
//         tipePermintaan: json["tipe_permintaan"],
//         itChecking: json["it_checking"],
//         statusPermintaan: json["status_permintaan"],
//         catatan: json["catatan"],
//         noPermintaan: json["no_permintaan"],
//         trackingBarang: json["tracking_barang"] == null
//             ? []
//             : List<TrackingBarang>.from(
//                 json["tracking_barang"]!.map((x) => TrackingBarang.fromMap(x)),
//               ),
//         status: json["status"],
//         jumlahPermintaan: json["jumlah_permintaan"],
//         listBarang: json["list_barang"] == null
//             ? []
//             : List<ListBarang>.from(
//                 json["list_barang"]!.map((x) => ListBarang.fromMap(x)),
//               ),
//       );

//   Map<String, dynamic> toMap() => {
//     "tanggal_permintaan": tanggalPermintaan?.toIso8601String(),
//     "permintaan_id": permintaanId,
//     "pemohon": pemohon,
//     "jabatan": jabatan,
//     "tipe_permintaan": tipePermintaan,
//     "penerima_barang": penerimaBarang,
//     "no_permintaan": noPermintaan,
//     "status_permintaan": statusPermintaan,
//     "it_checking": itChecking,
//     "catatan": catatan,
//     "tracking_barang": trackingBarang == null
//         ? []
//         : List<dynamic>.from(trackingBarang!.map((x) => x.toMap())),
//     "status": status,
//     "jumlah_permintaan": jumlahPermintaan,
//     "list_barang": listBarang == null
//         ? []
//         : List<dynamic>.from(listBarang!.map((x) => x.toMap())),
//   };
// }

// class ListBarang {
//   final String? jumlahPermintaan;
//   final String? namaStok;
//   final String? quantitas;
//   final int? barangMasuk;
//   final int? barangKeluar;
//   final int? tidakTerpenuhi;
//   final int? diperlukanSegera;
//   final int? disetujuiAtasan;
//   final int? ditolakGudang;

//   ListBarang({
//     this.jumlahPermintaan,
//     this.namaStok,
//     this.quantitas,
//     this.barangMasuk,
//     this.barangKeluar,
//     this.tidakTerpenuhi,
//     this.diperlukanSegera,
//     this.disetujuiAtasan,
//     this.ditolakGudang,
//   });

//   factory ListBarang.fromJson(String str) =>
//       ListBarang.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory ListBarang.fromMap(Map<String, dynamic> json) => ListBarang(
//     jumlahPermintaan: json["jumlah_permintaan"],
//     namaStok: json["nama_stok"],
//     quantitas: json["quantitas"],
//     barangMasuk: json["barang_masuk"],
//     barangKeluar: json["barang_keluar"],
//     tidakTerpenuhi: json["tidak_terpenuhi"],
//     diperlukanSegera: json["diperlukan_segera"],
//     disetujuiAtasan: json["disetujui_atasan"],
//     ditolakGudang: json["ditolak_gudang"],
//   );

//   Map<String, dynamic> toMap() => {
//     "jumlah_permintaan": jumlahPermintaan,
//     "nama_stok": namaStok,
//     "quantitas": quantitas,
//     "barang_masuk": barangMasuk,
//     "barang_keluar": barangKeluar,
//     "tidak_terpenuhi": tidakTerpenuhi,
//     "diperlukan_segera": diperlukanSegera,
//     "disetujui_atasan": disetujuiAtasan,
//     "ditolak_gudang": ditolakGudang,
//   };
// }

// class TrackingBarang {
//   final String? type;
//   final String? typeUser;
//   final String? typeAction;
//   final String? nama;
//   final DateTime? tanggal;

//   TrackingBarang({
//     this.type,
//     this.typeUser,
//     this.typeAction,
//     this.nama,
//     this.tanggal,
//   });

//   factory TrackingBarang.fromJson(String str) =>
//       TrackingBarang.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory TrackingBarang.fromMap(Map<String, dynamic> json) => TrackingBarang(
//     type: json["type"],
//     typeUser: json["type_user"],
//     typeAction: json["type_action"],
//     nama: json["nama"],
//     tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
//   );

//   Map<String, dynamic> toMap() => {
//     "type": type,
//     "type_user": typeUser,
//     "type_action": typeAction,
//     "nama": nama,
//     "tanggal": tanggal?.toIso8601String(),
//   };
// }
import 'dart:convert';

class ResponseModelPermintaanBarang {
  final bool? status;
  final int? code;
  final List<PermintaanBarang>? content;
  final String? message;

  ResponseModelPermintaanBarang({
    this.status,
    this.code,
    this.content,
    this.message,
  });

  ResponseModelPermintaanBarang copyWith({
    bool? status,
    int? code,
    List<PermintaanBarang>? content,
    String? message,
  }) => ResponseModelPermintaanBarang(
    status: status ?? this.status,
    code: code ?? this.code,
    content: content ?? this.content,
    message: message ?? this.message,
  );

  factory ResponseModelPermintaanBarang.fromRawJson(String str) =>
      ResponseModelPermintaanBarang.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseModelPermintaanBarang.fromJson(Map<String, dynamic> json) =>
      ResponseModelPermintaanBarang(
        status: json["status"],
        code: json["code"],
        content: json["content"] == null
            ? []
            : List<PermintaanBarang>.from(
                json["content"]!.map((x) => PermintaanBarang.fromJson(x)),
              ),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "content": content == null
        ? []
        : List<dynamic>.from(content!.map((x) => x.toJson())),
    "message": message,
  };
}

class PermintaanBarang {
  final DateTime? tanggalPermintaan;
  final String? permintaanId;
  final String? pemohon;
  final String? jabatan;
  final String? tipePermintaan;
  final String? penerimaBarang;
  final int? itChecking;
  final String? noPermintaan;
  final String? statusPermintaan;
  final dynamic catatan;
  final List<TrackingBarang>? trackingBarang;
  final String? status;
  final List<ListBarang>? listBarang;
  final String? jumlahPermintaan;

  PermintaanBarang({
    this.tanggalPermintaan,
    this.permintaanId,
    this.pemohon,
    this.jabatan,
    this.tipePermintaan,
    this.penerimaBarang,
    this.itChecking,
    this.noPermintaan,
    this.statusPermintaan,
    this.catatan,
    this.trackingBarang,
    this.status,
    this.listBarang,
    this.jumlahPermintaan,
  });

  PermintaanBarang copyWith({
    DateTime? tanggalPermintaan,
    String? permintaanId,
    String? pemohon,
    String? jabatan,
    String? tipePermintaan,
    String? penerimaBarang,
    int? itChecking,
    String? noPermintaan,
    String? statusPermintaan,
    dynamic catatan,
    List<TrackingBarang>? trackingBarang,
    String? status,
    List<ListBarang>? listBarang,
    String? jumlahPermintaan,
  }) => PermintaanBarang(
    tanggalPermintaan: tanggalPermintaan ?? this.tanggalPermintaan,
    permintaanId: permintaanId ?? this.permintaanId,
    pemohon: pemohon ?? this.pemohon,
    jabatan: jabatan ?? this.jabatan,
    tipePermintaan: tipePermintaan ?? this.tipePermintaan,
    penerimaBarang: penerimaBarang ?? this.penerimaBarang,
    itChecking: itChecking ?? this.itChecking,
    noPermintaan: noPermintaan ?? this.noPermintaan,
    statusPermintaan: statusPermintaan ?? this.statusPermintaan,
    catatan: catatan ?? this.catatan,
    trackingBarang: trackingBarang ?? this.trackingBarang,
    status: status ?? this.status,
    listBarang: listBarang ?? this.listBarang,
    jumlahPermintaan: jumlahPermintaan ?? this.jumlahPermintaan,
  );

  factory PermintaanBarang.fromRawJson(String str) =>
      PermintaanBarang.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PermintaanBarang.fromJson(Map<String, dynamic> json) =>
      PermintaanBarang(
        tanggalPermintaan: json["tanggal_permintaan"] == null
            ? null
            : DateTime.parse(json["tanggal_permintaan"]),
        permintaanId: json["permintaan_id"],
        pemohon: json["pemohon"],
        jabatan: json["jabatan"],
        tipePermintaan: json["tipe_permintaan"],
        penerimaBarang: json["penerima_barang"],
        itChecking: json["it_checking"],
        noPermintaan: json["no_permintaan"],
        statusPermintaan: json["status_permintaan"],
        catatan: json["catatan"],
        trackingBarang: json["tracking_barang"] == null
            ? []
            : List<TrackingBarang>.from(
                json["tracking_barang"]!.map((x) => TrackingBarang.fromJson(x)),
              ),
        status: json["status"],
        listBarang: json["list_barang"] == null
            ? []
            : List<ListBarang>.from(
                json["list_barang"]!.map((x) => ListBarang.fromJson(x)),
              ),
        jumlahPermintaan: json["jumlah_permintaan"],
      );

  Map<String, dynamic> toJson() => {
    "tanggal_permintaan": tanggalPermintaan?.toIso8601String(),
    "permintaan_id": permintaanId,
    "pemohon": pemohon,
    "jabatan": jabatan,
    "tipe_permintaan": tipePermintaan,
    "penerima_barang": penerimaBarang,
    "it_checking": itChecking,
    "no_permintaan": noPermintaan,
    "status_permintaan": statusPermintaan,
    "catatan": catatan,
    "tracking_barang": trackingBarang == null
        ? []
        : List<dynamic>.from(trackingBarang!.map((x) => x.toJson())),
    "status": status,
    "list_barang": listBarang == null
        ? []
        : List<dynamic>.from(listBarang!.map((x) => x.toJson())),
    "jumlah_permintaan": jumlahPermintaan,
  };
}

class ListBarang {
  final dynamic jumlahPermintaan;
  final String? namaStok;
  final String? quantitas;
  final int? barangMasuk;
  final int? barangKeluar;
  final int? tidakTerpenuhi;
  final int? diperlukanSegera;
  final int? disetujuiAtasan;
  final int? ditolakGudang;

  ListBarang({
    this.jumlahPermintaan,
    this.namaStok,
    this.quantitas,
    this.barangMasuk,
    this.barangKeluar,
    this.tidakTerpenuhi,
    this.diperlukanSegera,
    this.disetujuiAtasan,
    this.ditolakGudang,
  });

  ListBarang copyWith({
    dynamic jumlahPermintaan,
    String? namaStok,
    String? quantitas,
    int? barangMasuk,
    int? barangKeluar,
    int? tidakTerpenuhi,
    int? diperlukanSegera,
    int? disetujuiAtasan,
    int? ditolakGudang,
  }) => ListBarang(
    jumlahPermintaan: jumlahPermintaan ?? this.jumlahPermintaan,
    namaStok: namaStok ?? this.namaStok,
    quantitas: quantitas ?? this.quantitas,
    barangMasuk: barangMasuk ?? this.barangMasuk,
    barangKeluar: barangKeluar ?? this.barangKeluar,
    tidakTerpenuhi: tidakTerpenuhi ?? this.tidakTerpenuhi,
    diperlukanSegera: diperlukanSegera ?? this.diperlukanSegera,
    disetujuiAtasan: disetujuiAtasan ?? this.disetujuiAtasan,
    ditolakGudang: ditolakGudang ?? this.ditolakGudang,
  );

  factory ListBarang.fromRawJson(String str) =>
      ListBarang.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListBarang.fromJson(Map<String, dynamic> json) => ListBarang(
    jumlahPermintaan: json["jumlah_permintaan"],
    namaStok: json["nama_stok"],
    quantitas: json["quantitas"],
    barangMasuk: json["barang_masuk"],
    barangKeluar: json["barang_keluar"],
    tidakTerpenuhi: json["tidak_terpenuhi"],
    diperlukanSegera: json["diperlukan_segera"],
    disetujuiAtasan: json["disetujui_atasan"],
    ditolakGudang: json["ditolak_gudang"],
  );

  Map<String, dynamic> toJson() => {
    "jumlah_permintaan": jumlahPermintaan,
    "nama_stok": namaStok,
    "quantitas": quantitas,
    "barang_masuk": barangMasuk,
    "barang_keluar": barangKeluar,
    "tidak_terpenuhi": tidakTerpenuhi,
    "diperlukan_segera": diperlukanSegera,
    "disetujui_atasan": disetujuiAtasan,
    "ditolak_gudang": ditolakGudang,
  };
}

class TrackingBarang {
  final String? type;
  final String? typeUser;
  final String? typeAction;
  final String? nama;
  final DateTime? tanggal;

  TrackingBarang({
    this.type,
    this.typeUser,
    this.typeAction,
    this.nama,
    this.tanggal,
  });

  TrackingBarang copyWith({
    String? type,
    String? typeUser,
    String? typeAction,
    String? nama,
    DateTime? tanggal,
  }) => TrackingBarang(
    type: type ?? this.type,
    typeUser: typeUser ?? this.typeUser,
    typeAction: typeAction ?? this.typeAction,
    nama: nama ?? this.nama,
    tanggal: tanggal ?? this.tanggal,
  );

  factory TrackingBarang.fromRawJson(String str) =>
      TrackingBarang.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TrackingBarang.fromJson(Map<String, dynamic> json) => TrackingBarang(
    type: json["type"],
    typeUser: json["type_user"],
    typeAction: json["type_action"],
    nama: json["nama"],
    tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "type_user": typeUser,
    "type_action": typeAction,
    "nama": nama,
    "tanggal": tanggal?.toIso8601String(),
  };
}
