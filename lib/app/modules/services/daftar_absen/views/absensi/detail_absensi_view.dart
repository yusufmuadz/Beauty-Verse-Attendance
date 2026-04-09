import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../../controllers/model_controller.dart';
import '../../../../../core/components/custom_stepper_approve.dart';
import '../../../../../core/constant/time_format_schedule.dart';
import '../../../../../core/constant/variables.dart';
import '../../../../../data/model/submission_attendance_response_model.dart';
import '../../../../../shared/attach/show_multiple_file.dart';
import '../../../../../shared/button/button_1.dart';
import '../../../../../shared/images/images.dart';
import '../../../../../shared/loading/loading1.dart';
import '../../../cuti/pengajuan/views/detail_pengajuan_cuti_view.dart';

class DetailPengajuanAbsensi extends StatefulWidget {
  const DetailPengajuanAbsensi({super.key});

  @override
  State<DetailPengajuanAbsensi> createState() => _DetailPengajuanAbsensiState();
}

class _DetailPengajuanAbsensiState extends State<DetailPengajuanAbsensi> {
  final m = Get.find<ModelController>();
  late Submission data;
  List statusApproval = [];
  bool isRejected = false;

  int indexStatus = 0;

  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    statusApproval = [
      'Presensi ${_checkStatusApprovalUser(data.status ?? 'Pending')}',
      '${_checkStatusApproval(data.statusLine!)} ${data.line != null ? data.line!.nama : 'user'}',
      '${_checkStatusApproval(data.statusSuperadmin ?? "Pending")}${data.superadmin?.nama ?? 'Super Admin'}',
    ];
    _settingIndexApprove(
      data.status ?? 'Pending',
      data.statusLine ?? 'Rejected',
      data.statusSuperadmin ?? 'Pending',
    );
    _checkRejected(data.statusLine!, data.statusSuperadmin ?? 'Pending');
  }

  String _checkStatusApprovalUser(String approval) {
    switch (approval) {
      case "Rejected":
        return 'dibatalkan';
      default:
        return 'diajukan';
    }
  }

  void _checkRejected(String line, String superAdmin) {
    if (line.contains('Rejected') || superAdmin.contains('Rejected')) {
      isRejected = true;
    }
  }

  void _settingIndexApprove(String user, String line, String superAdmin) {
    if (user.contains('Rejected')) {
      isRejected = true;
    }
    if (line.contains('Rejected')) {
      isRejected = true;
    }
    if (superAdmin.contains('Rejected')) {
      isRejected = true;
    }

    if (line.contains('Approved') || line.contains('Rejected')) {
      indexStatus = 1;
    }

    if (superAdmin.contains('Approved') || superAdmin.contains('Rejected')) {
      indexStatus = 2;
    }

    log(indexStatus.toString());
  }

  _checkStatusApproval(String approval) {
    switch (approval) {
      case "Pending":
        return 'Menunggu persetujuan ';
      case "Approved":
        return 'Disetujui oleh ';
      case "Rejected":
        return 'Ditolak oleh ';
      default:
        break;
    }
  }

  _setColorStatus(String status) {
    switch (status) {
      case 'Approved':
        return Colors.amber;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Detail Pengajuan Presensi')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: [
            const Gap(10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              width: Get.width,
              child: Column(
                children: [
                  // status pengajuan cuti
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: _setColorStatus(data.status ?? 'Pending'),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      '${data.status}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // informasi pegawai cuti
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 55,
                          height: 55,
                          child: ImageNetwork(
                            url: m.u.value.avatar!,
                            borderRadius: 100,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                        const Gap(15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '${m.u.value.nama}',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              m.u.value.jabatan!.toLowerCase(),
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // status pengajuan cuti
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      'Status Pengajuan',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // informasi pegawai cuti
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tanggal Pengajuan :',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          DateFormat(
                            'dd MMMM yyyy',
                            'id_ID',
                          ).format(data.dateRequest ?? DateTime.now()),
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // custom stepper
                  const Gap(30),

                  CustomStepperApprove(
                    listStepper: statusApproval,
                    activeIndex: indexStatus,
                    isRejected: isRejected,
                    listDate: [
                      data.dateRequest,
                      data.dateApprovalLine,
                      data.dateApprovalSuperadmin,
                    ],
                  ),
                ],
              ),
            ),
            if (data.clockinTime != null)
              Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // status pengajuan cuti
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        'Detail Pengajuan Clock-In',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // informasi pegawai cuti
                    CustomDetailPengajuan(
                      title: 'Tanggal Absensi',
                      subTitle: DateFormat(
                        'dd MMM yyyy',
                      ).format(data.dateRequestFor!),
                    ),
                    CustomDetailPengajuan(
                      title: 'Shift',
                      subTitle: "${data.shift!.shiftName}",
                    ),
                    if (data.shift!.scheduleIn != null)
                      CustomDetailPengajuan(
                        title: 'Jam Kerja',
                        subTitle:
                            "${TimeFormatSchedule().timeOfDayFormat(data.shift!.scheduleIn!)} - ${TimeFormatSchedule().timeOfDayFormat(data.shift!.scheduleOut!)}",
                      ),
                    CustomDetailPengajuan(
                      title: 'Clock-In',
                      subTitle: "${_formatDate(data.clockinTime)}",
                    ),

                    CustomDetailPengajuan(
                      title: 'Alasan',
                      subTitle: "${data.reasonRequest ?? '-'}",
                    ),
                  ],
                ),
              ),
            if (data.clockoutTime != null)
              Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // status pengajuan cuti
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Detail Pengajuan Clock-Out',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // informasi pegawai cuti
                    CustomDetailPengajuan(
                      title: 'Tanggal Presensi',
                      subTitle: DateFormat(
                        'dd MMM yyyy',
                      ).format(data.dateRequestFor!),
                    ),
                    CustomDetailPengajuan(
                      title: 'Shift',
                      subTitle: "${data.shift!.shiftName}",
                    ),
                    if (data.shift!.scheduleIn != null)
                      CustomDetailPengajuan(
                        title: 'Jam Kerja',
                        subTitle:
                            "${TimeFormatSchedule().timeOfDayFormat(data.shift!.scheduleIn!)} - ${TimeFormatSchedule().timeOfDayFormat(data.shift!.scheduleOut!)}",
                      ),
                    CustomDetailPengajuan(
                      title: 'Clock-Out',
                      subTitle: "${_formatDate(data.clockoutTime!)}",
                    ),

                    CustomDetailPengajuan(
                      title: 'Alasan',
                      subTitle: "${data.reasonRequest ?? '-'}",
                    ),
                  ],
                ),
              ),
            if (data.attachmentUrl != null) ...{
              Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: () {
                    // debugPrint(data.attachmentUrl);
                    Get.dialog(Loading1());
                    openFile(
                      url: data.attachmentUrl!,
                      name: data.attachmentUrl!.split('/').last,
                    );
                  },
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined),
                        const Gap(5.0),
                        Text(
                          data.attachmentUrl!.split('/').last,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            },
            const Gap(10),
            if (data.approvalSuperadmin == null && !isRejected)
              Button1(
                backgroundColor: Colors.red,
                color: Colors.white,
                showOutline: false,
                title: 'Batalkan Pengajuan',
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Informasi',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        content: Text(
                          'Batalkan pengajuan presensi?',
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'Tidak',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await cancelSubmissionAttendance();
                              Get.back();
                              Get.back();
                            },
                            child: Text(
                              'Ya',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            const Gap(10),
          ],
        ),
      ),
    );
  }

  String _formatDate(String time) {
    // Parsing string ke DateTime
    DateTime dateTime = DateFormat('HH:mm:ss').parse(time);
    // Mengubah ke format yang diinginkan
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return formattedTime;
  }

  Future cancelSubmissionAttendance() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${m.token.value}',
    };
    var request = http.Request(
      'POST',
      Uri.parse(
        '${Variables.baseUrl}/v1/user/submission/cancel/attendance/cancel',
      ),
    );

    request.body = json.encode({"id": data.id});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
