import 'package:lancar_cat/app/data/model/login_response_model.dart';
import 'package:lancar_cat/app/models/cuti.dart';

class TimeOffRequest {
  String? id;
  String? timeOffMasterId;
  String? userId;
  String? reason;
  String? status;
  String? statusLine;
  String? statusSuperadmin;
  String? dateRequest;
  String? approvalLine;
  String? approvalSuperadmin;
  String? dateApprovalLine;
  String? dateApprovalSuperadmin;
  String? commentApprovalLine;
  String? commentApprovalSuperadmin;
  String startTimeOff;
  String endTimeOff;
  User? superadmin;
  User user;
  Master master;
  List<Attach>? attach;

  TimeOffRequest({
    required this.id,
    required this.timeOffMasterId,
    required this.userId,
    required this.reason,
    required this.status,
    required this.statusLine,
    this.statusSuperadmin,
    required this.dateRequest,
    required this.approvalLine,
    required this.approvalSuperadmin,
    this.dateApprovalLine,
    this.dateApprovalSuperadmin,
    this.commentApprovalLine,
    this.commentApprovalSuperadmin,
    required this.startTimeOff,
    required this.endTimeOff,
    this.superadmin,
    required this.user,
    required this.master,
    this.attach,
  });

  factory TimeOffRequest.fromJson(Map<String, dynamic> json) {
    return TimeOffRequest(
      id: json['id'],
      timeOffMasterId: json['time_off_master_id'],
      userId: json['user_id'],
      reason: json['reason'],
      status: json['status'],
      statusLine: json['status_line'],
      statusSuperadmin: json['status_superadmin'],
      dateRequest: json['date_request'],
      approvalLine: json['approval_line'],
      approvalSuperadmin: json['approval_superadmin'],
      dateApprovalLine: json['date_approval_line'],
      dateApprovalSuperadmin: json['date_approval_superadmin'],
      commentApprovalLine: json['comment_approval_line'],
      commentApprovalSuperadmin: json['comment_approval_superadmin'],
      startTimeOff: json['start_time_off'],
      endTimeOff: json['end_time_off'],
      superadmin: json['superadmin'] != null
          ? User.fromJson(json['superadmin'])
          : null,
      user: User.fromJson(json['user']),
      master: Master.fromJson(json['master']),
      attach: json["attach"] == null
          ? null
          : List<Attach>.from(json["attach"].map((x) => Attach.fromJson(x))),
    );
  }
}
