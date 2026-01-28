class TimeOff {
  String timeoffId;
  String specialLeave;
  String forGender;
  String isBalance;
  int maxRequest;
  String attachmentRequest;
  String id;
  String name;
  String code;
  DateTime effectiveDate;
  String? description;
  String show;
  DateTime createdAt;
  String timeOffMasterId;
  String userId;
  int balance;
  DateTime startDate;
  DateTime endDate;
  String createdBy;
  DateTime? deletedAt;
  String? deletedBy;

  TimeOff({
    required this.timeoffId,
    required this.specialLeave,
    required this.forGender,
    required this.isBalance,
    required this.maxRequest,
    required this.attachmentRequest,
    required this.id,
    required this.name,
    required this.code,
    required this.effectiveDate,
    this.description,
    required this.show,
    required this.createdAt,
    required this.timeOffMasterId,
    required this.userId,
    required this.balance,
    required this.startDate,
    required this.endDate,
    required this.createdBy,
    this.deletedAt,
    this.deletedBy,
  });

  factory TimeOff.fromJson(Map<String, dynamic> json) {
    return TimeOff(
      timeoffId: json['timeoff_id'],
      specialLeave: json['special_leave'],
      forGender: json['for_gender'],
      isBalance: json['is_balance'],
      maxRequest: json['max_request'],
      attachmentRequest: json['attachment_request'],
      id: json['id'],
      name: json['name'],
      code: json['code'],
      effectiveDate: DateTime.parse(json['effective_date']),
      description: json['description'],
      show: json['show'],
      createdAt: DateTime.parse(json['created_at']),
      timeOffMasterId: json['time_off_master_id'],
      userId: json['user_id'],
      balance: json['balance'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      createdBy: json['created_by'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      deletedBy: json['deleted_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeoff_id': timeoffId,
      'special_leave': specialLeave,
      'for_gender': forGender,
      'is_balance': isBalance,
      'max_request': maxRequest,
      'attachment_request': attachmentRequest,
      'id': id,
      'name': name,
      'code': code,
      'effective_date': effectiveDate.toIso8601String(),
      'description': description,
      'show': show,
      'created_at': createdAt.toIso8601String(),
      'time_off_master_id': timeOffMasterId,
      'user_id': userId,
      'balance': balance,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_by': createdBy,
      'deleted_at': deletedAt?.toIso8601String(),
      'deleted_by': deletedBy,
    };
  }
}
