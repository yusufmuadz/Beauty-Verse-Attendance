class Job {
  String? idKaryawan;
  String? levelPekerjaanId;
  String? statusPekerjaan;
  DateTime? tglBergabung;
  DateTime? tglBerakhir;
  String? approvalAbsensi;
  String? approvalShift;
  String? approvalLembur;
  String? approvalIzinKembali;
  String? approvalIstirahatTelat;
  String? createdBy;

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
  });

  factory Job.fromJson(Map<String?, dynamic> json) => Job(
        idKaryawan: json["id_karyawan"] ?? "",
        levelPekerjaanId: json["level_pekerjaan_id"] ?? "",
        statusPekerjaan: json["status_pekerjaan"] ?? "",
        tglBergabung: (json['tgl_bergabung'] == null)
            ? DateTime.now()
            : DateTime.parse(json["tgl_bergabung"]),
        tglBerakhir: (json['tgl_berakhir'] == null)
            ? DateTime.now()
            : DateTime.parse(json["tgl_berakhir"]),
        approvalAbsensi: json["approval_absensi"] ?? "",
        approvalShift: json["approval_shift"] ?? "",
        approvalLembur: json["approval_lembur"] ?? "",
        approvalIzinKembali: json["approval_izin_kembali"] ?? "",
        approvalIstirahatTelat: json["approval_istirahat_telat"] ?? "",
        createdBy: json["created_by"] ?? "",
      );
}
