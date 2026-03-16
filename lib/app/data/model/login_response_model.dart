import 'dart:convert';

import '../../models/user_attendance.dart';

class LoginResponseModel {
  final bool? status;
  final String? mesasge;
  final String? token;
  final User? user;

  LoginResponseModel({this.status, this.mesasge, this.token, this.user});

  factory LoginResponseModel.fromJson(String str) =>
      LoginResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromMap(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json["status"],
        mesasge: json["mesasge"],
        token: json["token"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "mesasge": mesasge,
    "token": token,
    "user": user?.toMap(),
  };
}

class User {
  final String? id;
  final String? idKaryawan;
  final String? email;
  final String? password;
  final String? avatar;
  final String? nama;
  final DateTime? tanggalLahir;
  final String? tempatLahir;
  final String? telepon;
  final String? alamat;
  final String? jenisKelamin;
  final String? statusPernikahan;
  final String? golDarah;
  final String? agama;
  final String? status;
  final String? superAdmin;
  final String? manager;
  final dynamic statusActivity;
  final dynamic createdBy;
  final dynamic updatedBy;
  final dynamic deletedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? divisi;
  final String? jabatan;
  final int? subordinate;
  final Cabang? cabang;
  final Job? job;
  final UserAttendance? attendance;
  final String? leave;

  User({
    this.id,
    this.idKaryawan,
    this.email,
    this.password,
    this.avatar,
    this.nama,
    this.tanggalLahir,
    this.tempatLahir,
    this.telepon,
    this.alamat,
    this.jenisKelamin,
    this.statusPernikahan,
    this.golDarah,
    this.agama,
    this.status,
    this.superAdmin,
    this.manager,
    this.statusActivity,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.divisi,
    this.jabatan,
    this.cabang,
    this.subordinate,
    this.job,
    this.attendance,
    this.leave,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    idKaryawan: json["id_karyawan"],
    email: json["email"],
    password: json["password"],
    avatar: json["avatar"],
    nama: json["nama"],
    tanggalLahir: json["tanggal_lahir"] == null
        ? null
        : DateTime.parse(json["tanggal_lahir"]),
    tempatLahir: json["tempat_lahir"],
    telepon: json["telepon"],
    alamat: json["alamat"],
    jenisKelamin: json["jenis_kelamin"],
    statusPernikahan: json["status_pernikahan"],
    golDarah: json["gol_darah"],
    agama: json["agama"],
    status: json["status"],
    superAdmin: json["super_admin"],
    manager: json["manager"],
    statusActivity: json["status_activity"],
    createdBy: json["created_by"] ?? "",
    updatedBy: json["updated_by"] ?? "",
    deletedBy: json["deleted_by"] ?? "",
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"] == null
        ? null
        : DateTime.parse(json["deleted_at"]),
    divisi: json["divisi"],
    jabatan: json["jabatan"] ?? '',
    cabang: json["cabang"] == null ? null : Cabang.fromMap(json["cabang"]),
    subordinate: json["subordinate"],
    job: json["job"] == null ? null : Job.fromMap(json["job"]),
    attendance: json["attendance"] == null
        ? null
        : UserAttendance.fromMap(json["attendance"]),
    leave: json["leave"] ?? '',
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "email": email,
    "password": password,
    "avatar": avatar,
    "nama": nama,
    "tanggal_lahir":
        "${tanggalLahir!.year.toString().padLeft(4, '0')}-${tanggalLahir!.month.toString().padLeft(2, '0')}-${tanggalLahir!.day.toString().padLeft(2, '0')}",
    "tempat_lahir": tempatLahir,
    "telepon": telepon,
    "alamat": alamat,
    "jenis_kelamin": jenisKelamin,
    "status_pernikahan": statusPernikahan,
    "gol_darah": golDarah,
    "agama": agama,
    "status": status,
    "super_admin": superAdmin,
    "manager": manager,
    "status_activity": statusActivity,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "divisi": divisi,
    "jabatan": jabatan,
    "cabang": cabang?.toMap(),
    "job": job?.toMap(),
  };
}

class Cabang {
  final String? kode;
  final String? nama;
  final String? telp;
  final String? alamat;

  Cabang({this.kode, this.nama, this.telp, this.alamat});

  factory Cabang.fromJson(String str) => Cabang.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cabang.fromMap(Map<String, dynamic> json) => Cabang(
    kode: json["kode"],
    nama: json["nama"],
    telp: json["telp"],
    alamat: json["alamat"],
  );

  Map<String, dynamic> toMap() => {
    "kode": kode,
    "nama": nama,
    "telp": telp,
    "alamat": alamat,
  };
}

class Job {
  final String? idKaryawan;
  final String? levelPekerjaanId;
  final String? statusPekerjaan;
  final DateTime? tglBergabung;
  final DateTime? tglBerakhir;
  final String? approvalAbsensi;
  final String? approvalShift;
  final String? approvalLembur;
  final String? approvalIzinKembali;
  final String? approvalIstirahatTelat;
  final dynamic createdBy;
  final JobLevelMaster1? jobLevelMaster1;
  final String? penempatanPertama;
  final String? statusPTKP;

  Job({
    this.idKaryawan,
    this.levelPekerjaanId,
    this.statusPekerjaan,
    this.tglBergabung,
    this.tglBerakhir,
    this.approvalAbsensi,
    this.approvalShift,
    this.approvalLembur,
    this.approvalIzinKembali,
    this.approvalIstirahatTelat,
    this.createdBy,
    this.jobLevelMaster1,
    this.penempatanPertama,
    this.statusPTKP,
  });

  factory Job.fromJson(String str) => Job.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Job.fromMap(Map<String, dynamic> json) => Job(
    idKaryawan: json["id_karyawan"] ?? '',
    levelPekerjaanId: json["level_pekerjaan_id"],
    statusPekerjaan: json["status_pekerjaan"],
    tglBergabung: json["tgl_bergabung"] == null
        ? null
        : DateTime.parse(json["tgl_bergabung"]),
    tglBerakhir: json["tgl_berakhir"] == null
        ? null
        : DateTime.parse(json["tgl_berakhir"]),
    approvalAbsensi: json["approval_absensi"],
    approvalShift: json["approval_shift"],
    approvalLembur: json["approval_lembur"],
    approvalIzinKembali: json["approval_izin_kembali"],
    approvalIstirahatTelat: json["approval_istirahat_telat"],
    createdBy: json["created_by"],
    jobLevelMaster1: json["job_level_master1"] == null
        ? null
        : JobLevelMaster1.fromMap(json["job_level_master1"]),
    penempatanPertama: json["penempatan_pertama"] ?? '',
    statusPTKP: json["ptkp"] ?? '',
  );

  Map<String, dynamic> toMap() => {
    "id_karyawan": idKaryawan,
    "level_pekerjaan_id": levelPekerjaanId,
    "status_pekerjaan": statusPekerjaan,
    "tgl_bergabung":
        "${tglBergabung!.year.toString().padLeft(4, '0')}-${tglBergabung!.month.toString().padLeft(2, '0')}-${tglBergabung!.day.toString().padLeft(2, '0')}",
    "tgl_berakhir":
        "${tglBerakhir!.year.toString().padLeft(4, '0')}-${tglBerakhir!.month.toString().padLeft(2, '0')}-${tglBerakhir!.day.toString().padLeft(2, '0')}",
    "approval_absensi": approvalAbsensi,
    "approval_shift": approvalShift,
    "approval_lembur": approvalLembur,
    "approval_izin_kembali": approvalIzinKembali,
    "approval_istirahat_telat": approvalIstirahatTelat,
    "created_by": createdBy,
    "job_level_master1": jobLevelMaster1?.toMap(),
    'penempatan_pertama': penempatanPertama,
    'ptkp': statusPTKP,
  };
}

class JobLevelMaster1 {
  final String? nama;

  JobLevelMaster1({this.nama});

  factory JobLevelMaster1.fromJson(String str) =>
      JobLevelMaster1.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobLevelMaster1.fromMap(Map<String, dynamic> json) =>
      JobLevelMaster1(nama: json["nama"]);

  Map<String, dynamic> toMap() => {"nama": nama};
}
