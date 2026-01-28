import 'dart:convert';

class ProfileResponseModel {
  final bool? status;
  final Data? data;
  final String? message;

  ProfileResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory ProfileResponseModel.fromJson(String str) =>
      ProfileResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfileResponseModel.fromMap(Map<String, dynamic> json) =>
      ProfileResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "message": message,
      };
}

class Data {
  final Dashboard? dashboard;
  final Person? person;
  final List<dynamic>? employment;

  Data({
    this.dashboard,
    this.person,
    this.employment,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        dashboard: json["dashboard"] == null
            ? null
            : Dashboard.fromMap(json["dashboard"]),
        person: json["person"] == null ? null : Person.fromMap(json["person"]),
        employment: json["employment"] == null
            ? []
            : List<dynamic>.from(json["employment"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "dashboard": dashboard?.toMap(),
        "person": person?.toMap(),
        "employment": employment == null
            ? []
            : List<dynamic>.from(employment!.map((x) => x)),
      };
}

class Dashboard {
  final int? sisaCuti;
  final int? presentasiKehadiran;

  Dashboard({
    this.sisaCuti,
    this.presentasiKehadiran,
  });

  factory Dashboard.fromJson(String str) => Dashboard.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Dashboard.fromMap(Map<String, dynamic> json) => Dashboard(
        sisaCuti: json["sisa_cuti"],
        presentasiKehadiran: json["presentasi_kehadiran"],
      );

  Map<String, dynamic> toMap() => {
        "sisa_cuti": sisaCuti,
        "presentasi_kehadiran": presentasiKehadiran,
      };
}

class Person {
  final InformasiPribadi? informasiPribadi;
  final InformasiKontak? informasiKontak;
  final InformasiAlamat? informasiAlamat;
  final InformasiPekerjaan? informasiPekerjaan;

  Person({
    this.informasiPribadi,
    this.informasiKontak,
    this.informasiAlamat,
    this.informasiPekerjaan,
  });

  factory Person.fromJson(String str) => Person.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Person.fromMap(Map<String, dynamic> json) => Person(
        informasiPribadi: json["informasi_pribadi"] == null
            ? null
            : InformasiPribadi.fromMap(json["informasi_pribadi"]),
        informasiKontak: json["informasi_kontak"] == null
            ? null
            : InformasiKontak.fromMap(json["informasi_kontak"]),
        informasiAlamat: json["informasi_alamat"] == null
            ? null
            : InformasiAlamat.fromMap(json["informasi_alamat"]),
        informasiPekerjaan: json["informasi_pekerjaan"] == null
            ? null
            : InformasiPekerjaan.fromMap(json["informasi_pekerjaan"]),
      );

  Map<String, dynamic> toMap() => {
        "informasi_pribadi": informasiPribadi?.toMap(),
        "informasi_kontak": informasiKontak?.toMap(),
        "informasi_alamat": informasiAlamat?.toMap(),
        "informasi_pekerjaan": informasiPekerjaan?.toMap(),
      };
}

class InformasiAlamat {
  final String? alamat;

  InformasiAlamat({
    this.alamat,
  });

  factory InformasiAlamat.fromJson(String str) =>
      InformasiAlamat.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InformasiAlamat.fromMap(Map<String, dynamic> json) => InformasiAlamat(
        alamat: json["alamat"],
      );

  Map<String, dynamic> toMap() => {
        "alamat": alamat,
      };
}

class InformasiKontak {
  final String? email;
  final String? noTelepon;

  InformasiKontak({
    this.email,
    this.noTelepon,
  });

  factory InformasiKontak.fromJson(String str) =>
      InformasiKontak.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InformasiKontak.fromMap(Map<String, dynamic> json) => InformasiKontak(
        email: json["email"],
        noTelepon: json["no_telepon"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "no_telepon": noTelepon,
      };
}

class InformasiPekerjaan {
  final String? idKaryawan;
  final String? namaPerusahaan;
  final String? cabang;
  final String? posisiPekerjaan;
  final String? levelPekerjaan;
  final String? statusPekerjaan;
  final DateTime? tanggalBergabung;
  final DateTime? tanggalBerakhirKontrak;
  final String? masaKerja;

  InformasiPekerjaan({
    this.idKaryawan,
    this.namaPerusahaan,
    this.cabang,
    this.posisiPekerjaan,
    this.levelPekerjaan,
    this.statusPekerjaan,
    this.tanggalBergabung,
    this.tanggalBerakhirKontrak,
    this.masaKerja,
  });

  factory InformasiPekerjaan.fromJson(String str) =>
      InformasiPekerjaan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InformasiPekerjaan.fromMap(Map<String, dynamic> json) =>
      InformasiPekerjaan(
        idKaryawan: json["id_karyawan"],
        namaPerusahaan: json["nama_perusahaan"],
        cabang: json["cabang"],
        posisiPekerjaan: json["posisi_pekerjaan"],
        levelPekerjaan: json["level_pekerjaan"],
        statusPekerjaan: json["status_pekerjaan"],
        tanggalBergabung: json["tanggal_bergabung"] == null
            ? null
            : DateTime.parse(json["tanggal_bergabung"]),
        tanggalBerakhirKontrak: json["tanggal_berakhir_kontrak"] == null
            ? null
            : DateTime.parse(json["tanggal_berakhir_kontrak"]),
        masaKerja: json["masa_kerja"],
      );

  Map<String, dynamic> toMap() => {
        "id_karyawan": idKaryawan,
        "nama_perusahaan": namaPerusahaan,
        "cabang": cabang,
        "posisi_pekerjaan": posisiPekerjaan,
        "level_pekerjaan": levelPekerjaan,
        "status_pekerjaan": statusPekerjaan,
        "tanggal_bergabung":
            "${tanggalBergabung!.year.toString().padLeft(4, '0')}-${tanggalBergabung!.month.toString().padLeft(2, '0')}-${tanggalBergabung!.day.toString().padLeft(2, '0')}",
        "tanggal_berakhir_kontrak":
            "${tanggalBerakhirKontrak!.year.toString().padLeft(4, '0')}-${tanggalBerakhirKontrak!.month.toString().padLeft(2, '0')}-${tanggalBerakhirKontrak!.day.toString().padLeft(2, '0')}",
        "masa_kerja": masaKerja,
      };
}

class InformasiPribadi {
  final String? idKaryawan;
  final String? nama;
  final String? imageUrl;
  final String? tempatLahir;
  final DateTime? tanggalLahir;
  final String? agama;
  final String? jenisKelamin;
  final String? golonganDarah;
  final String? statusPernikahan;

  InformasiPribadi({
    this.idKaryawan,
    this.nama,
    this.imageUrl,
    this.tempatLahir,
    this.tanggalLahir,
    this.agama,
    this.jenisKelamin,
    this.golonganDarah,
    this.statusPernikahan,
  });

  factory InformasiPribadi.fromJson(String str) =>
      InformasiPribadi.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InformasiPribadi.fromMap(Map<String, dynamic> json) =>
      InformasiPribadi(
        idKaryawan: json["id_karyawan"],
        nama: json["nama"],
        imageUrl: json["image_url"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: json["tanggal_lahir"] == null
            ? null
            : DateTime.parse(json["tanggal_lahir"]),
        agama: json["agama"],
        jenisKelamin: json["jenis_kelamin"],
        golonganDarah: json["golongan_darah"],
        statusPernikahan: json["status_pernikahan"],
      );

  Map<String, dynamic> toMap() => {
        "nama": nama,
        "image_url": imageUrl,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir":
            "${tanggalLahir!.year.toString().padLeft(4, '0')}-${tanggalLahir!.month.toString().padLeft(2, '0')}-${tanggalLahir!.day.toString().padLeft(2, '0')}",
        "agama": agama,
        "jenis_kelamin": jenisKelamin,
        "golongan_darah": golonganDarah,
        "status_pernikahan": statusPernikahan,
      };
}
