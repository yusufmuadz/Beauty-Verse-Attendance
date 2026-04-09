import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import '../../../../../controllers/model_controller.dart';
import '../../../../../core/components/custom_dialog.dart';
import '../../../../../core/components/custom_stepper_approve.dart';
import '../../../../../core/constant/time_format_schedule.dart';
import '../../../../../core/constant/variables.dart';
import '../../../../../data/model/change_shift_response_model.dart';
import '../../../../../shared/button/button_1.dart';
import '../../../../../shared/images/images.dart';
import '../../../cuti/pengajuan/views/detail_pengajuan_cuti_view.dart';

class DetailPengajuanShiftView extends StatefulWidget {
  const DetailPengajuanShiftView({super.key});

  @override
  State<DetailPengajuanShiftView> createState() =>
      _DetailPengajuanShiftViewState();
}

class _DetailPengajuanShiftViewState extends State<DetailPengajuanShiftView> {
  final m = Get.find<ModelController>();
  final extendTime = TextEditingController();

  late ChangeShift shift;
  List statusApproval = [];
  bool isRejected = false;

  int indexStatus = 0;

  @override
  void initState() {
    super.initState();
    shift = Get.arguments;
    statusApproval = [
      'Perubahan Shift ${_checkStatusApprovalUser(shift.status ?? 'Pending')}',
      '${_checkStatusApproval(shift.statusLine ?? "Pending")}${shift.lineName ?? 'user'}',
      '${_checkStatusApproval(shift.statusSuperadmin ?? "Pending")}${shift.superadminName ?? 'Super Admin'}',
    ];
    _settingIndexApprove(
      shift.status ?? 'Pending',
      shift.statusLine ?? 'Rejected',
      shift.statusSuperadmin ?? 'Pending',
    );
    _checkRejected(
      shift.statusLine ?? 'Rejected',
      shift.statusSuperadmin ?? 'Pending',
    );
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
      appBar: AppBar(
        title: const Text('Detail Ganti Shift'),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            BiodataUser(),
            _buildStepper(),
            ReasonSubmission(),
            DetailShiftChange(),
            if (!isRejected)
              Column(
                children: [
                  const Gap(10),
                  Button1(
                    title: 'Batalkan Ganti Shift',
                    backgroundColor: Colors.red,
                    onTap: () async {
                      if (Get.isDialogOpen! ||
                          Get.isBottomSheetOpen! ||
                          Get.isSnackbarOpen) {
                        return;
                      }
                      Get.dialog(
                        CustomDialog(
                          title: 'Batalkan',
                          content:
                              'Apakah anda yakin akan membatalkan ganti shift?',
                          onConfirm: () async {
                            Variables().loading(message: 'Membatalkan...');
                            await cancelChangeShift(shift.id ?? '');
                          },
                          onCancel: () {
                            Get.back();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future cancelChangeShift(String id) async {
    final m = Get.find<ModelController>();
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/user/cancel/change/shift/$id'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Get.back();
      Get.back();
      Get.back();
    } else {
      Get.back();
    }
  }

  String settingShiftAndSchedule(ChangeShift shift, String type) {
    String scheduleInNew = TimeFormatSchedule().timeOfDayFormat(
      shift.scheduleInNew ?? '00:00:00',
    );
    String scheduleOutNew = TimeFormatSchedule().timeOfDayFormat(
      shift.scheduleOutNew ?? '00:00:00',
    );

    if (type == 'new') {
      return '${shift.shiftNameNew} ($scheduleInNew-$scheduleOutNew)';
    }

    String scheduleInOld = TimeFormatSchedule().timeOfDayFormat(
      shift.scheduleInOld ?? '00:00:00',
    );
    String scheduleOutOld = TimeFormatSchedule().timeOfDayFormat(
      shift.scheduleOutOld ?? '00:00:00',
    );
    return '${shift.shiftNameOld} ($scheduleInOld-$scheduleOutOld)';
  }

  Container DetailShiftChange() {
    return Container(
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
              'Detail Shift Baru',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          // informasi pegawai cuti

          // custom stepper
          CustomDetailPengajuan(
            title: 'Untuk Tanggal',
            subTitle: DateFormat(
              'dd MMMM yyyy',
              'id_ID',
            ).format(shift.dateRequestFor!),
          ),
          CustomDetailPengajuan(
            title: 'Shift Sebelumnya',
            subTitle: settingShiftAndSchedule(shift, 'old'),
          ),
          CustomDetailPengajuan(
            title: 'Shift Baru',
            subTitle: settingShiftAndSchedule(shift, 'new'),
          ),
        ],
      ),
    );
  }

  Container ReasonSubmission() {
    return Container(
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
              'Alasan Ganti Shift',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          // informasi pegawai cuti

          // custom stepper
          Text(shift.notes ?? ''),
        ],
      ),
    );
  }

  Container _buildStepper() {
    return Container(
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
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),

          // informasi pegawai cuti
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tanggal diajukan',
                  style: GoogleFonts.outfit(fontSize: 12),
                ),
              ),
              Text(': '),
              Expanded(
                child: Text(
                  DateFormat(
                    'dd MMMM yyyy',
                    'id_ID',
                  ).format(shift.createdAt ?? DateTime.now()),
                  style: GoogleFonts.outfit(fontSize: 12),
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
              shift.createdAt,
              shift.dateApprovalLine,
              shift.dateApprovalSuperadmin,
            ],
          ),
        ],
      ),
    );
  }

  Container BiodataUser() {
    return Container(
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
              color: _setColorStatus(shift.status ?? 'Pending'),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(15.0),
            child: Text(
              '${shift.status}',
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
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey.shade300,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: m.u.value.avatar!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.account_circle_rounded),
                    ),
                  ),
                ),
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${m.u.value.nama}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.5,
                      child: Text(
                        '${m.u.value.jabatan}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
