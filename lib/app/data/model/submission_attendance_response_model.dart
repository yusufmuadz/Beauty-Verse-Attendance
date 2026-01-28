import 'dart:convert';

class SubmissionApprovalResponseModel {
  final bool? status;
  final String? message;
  final List<Submission>? submission;
  final int? pendingLenght;

  SubmissionApprovalResponseModel({
    this.status,
    this.message,
    this.submission,
    this.pendingLenght,
  });

  factory SubmissionApprovalResponseModel.fromJson(String str) =>
      SubmissionApprovalResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubmissionApprovalResponseModel.fromMap(Map<String, dynamic> json) =>
      SubmissionApprovalResponseModel(
        status: json["status"],
        message: json["message"],
        submission: json["submission"] == null
            ? []
            : List<Submission>.from(
                json["submission"]!.map((x) => Submission.fromMap(x))),
        pendingLenght: json['pending_lenght'] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "submission": submission == null
            ? []
            : List<dynamic>.from(submission!.map((x) => x.toMap())),
      };
}

class Submission {
  final String? id;
  final String? usersId;
  final String? attachmentUrl;
  final DateTime? dateRequest;
  final DateTime? dateApprovalLine;
  final DateTime? dateApprovalSuperadmin;
  final DateTime? dateRequestFor;
  final dynamic clockinTime;
  final String? clockoutTime;
  final String? reasonRequest;
  final dynamic reasonLine;
  final dynamic reasonSuperadmin;
  final String? approvalLine;
  final dynamic approvalSuperadmin;
  final String? status;
  final String? statusLine;
  final String? statusSuperadmin;
  final dynamic cancelAt;
  final Shift? shift;
  final Line? line;
  final Line? user;
  final Line? superadmin;

  Submission({
    this.id,
    this.usersId,
    this.attachmentUrl,
    this.dateRequest,
    this.dateApprovalLine,
    this.dateApprovalSuperadmin,
    this.dateRequestFor,
    this.clockinTime,
    this.clockoutTime,
    this.reasonRequest,
    this.reasonLine,
    this.reasonSuperadmin,
    this.approvalLine,
    this.approvalSuperadmin,
    this.status,
    this.statusLine,
    this.statusSuperadmin,
    this.cancelAt,
    this.shift,
    this.line,
    this.user,
    this.superadmin,
  });

  factory Submission.fromJson(String str) =>
      Submission.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Submission.fromMap(Map<String, dynamic> json) => Submission(
        id: json["id"],
        usersId: json["users_id"],
        attachmentUrl: json["attachment_url"],
        dateRequest: json["date_request"] == null
            ? null
            : DateTime.parse(json["date_request"]),
        dateRequestFor: json["date_request_for"] == null
            ? null
            : DateTime.parse(json["date_request_for"]),
        dateApprovalLine: json["date_approval_line"] == null
            ? null
            : DateTime.parse(json["date_approval_line"]),
        dateApprovalSuperadmin: json["date_approval_superadmin"] == null
            ? null
            : DateTime.parse(json["date_approval_superadmin"]),
        clockinTime: json["clockin_time"],
        clockoutTime: json["clockout_time"],
        reasonRequest: json["reason_request"],
        reasonLine: json["reason_line"],
        reasonSuperadmin: json["reason_superadmin"],
        approvalLine: json["approval_line"],
        approvalSuperadmin: json["approval_superadmin"],
        status: json["status"],
        statusLine: json["status_line"],
        statusSuperadmin: json["status_superadmin"],
        cancelAt: json["cancel_at"],
        shift: json["shift"] == null ? null : Shift.fromMap(json["shift"]),
        line: json["line"] == null ? null : Line.fromMap(json["line"]),
        user: json["user"] == null ? null : Line.fromMap(json["user"]),
        superadmin: json["superadmin"] == null
            ? null
            : Line.fromMap(json["superadmin"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "users_id": usersId,
        "attachment_url": attachmentUrl,
        "date_request": dateRequest?.toIso8601String(),
        "date_request_for":
            "${dateRequestFor!.year.toString().padLeft(4, '0')}-${dateRequestFor!.month.toString().padLeft(2, '0')}-${dateRequestFor!.day.toString().padLeft(2, '0')}",
        "clockin_time": clockinTime,
        "clockout_time": clockoutTime,
        "reason_request": reasonRequest,
        "reason_line": reasonLine,
        "reason_superadmin": reasonSuperadmin,
        "approval_line": approvalLine,
        "approval_superadmin": approvalSuperadmin,
        "status": status,
        "status_line": statusLine,
        "status_superadmin": statusSuperadmin,
        "cancel_at": cancelAt,
        "shift": shift?.toMap(),
        "line": line?.toMap(),
        "user": user?.toMap(),
        "superadmin": superadmin?.toMap(),
      };
}

class Line {
  final String? id;
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
  final String? createdBy;
  final dynamic updatedBy;
  final dynamic deletedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Line({
    this.id,
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
  });

  factory Line.fromJson(String str) => Line.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Line.fromMap(Map<String, dynamic> json) => Line(
        id: json["id"],
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
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        deletedBy: json["deleted_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
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
      };
}

class Shift {
  final String? id;
  final String? shiftName;
  final String? scheduleIn;
  final String? scheduleOut;
  final String? breakStart;
  final String? breakEnd;
  final dynamic description;
  final String? dayoff;
  final String? shiftAllEmployee;
  final String? showInRequest;
  final DateTime? createdAt;
  final String? createdBy;

  Shift({
    this.id,
    this.shiftName,
    this.scheduleIn,
    this.scheduleOut,
    this.breakStart,
    this.breakEnd,
    this.description,
    this.dayoff,
    this.shiftAllEmployee,
    this.showInRequest,
    this.createdAt,
    this.createdBy,
  });

  factory Shift.fromJson(String str) => Shift.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Shift.fromMap(Map<String, dynamic> json) => Shift(
        id: json["id"],
        shiftName: json["shift_name"],
        scheduleIn: json["schedule_in"],
        scheduleOut: json["schedule_out"],
        breakStart: json["break_start"],
        breakEnd: json["break_end"],
        description: json["description"],
        dayoff: json["dayoff"],
        shiftAllEmployee: json["shift_all_employee"],
        showInRequest: json["show_in_request"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "shift_name": shiftName,
        "schedule_in": scheduleIn,
        "schedule_out": scheduleOut,
        "break_start": breakStart,
        "break_end": breakEnd,
        "description": description,
        "dayoff": dayoff,
        "shift_all_employee": shiftAllEmployee,
        "show_in_request": showInRequest,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
      };
}
