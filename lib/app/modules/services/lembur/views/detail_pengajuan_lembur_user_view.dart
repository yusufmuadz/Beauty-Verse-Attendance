import 'dart:developer';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../controllers/model_controller.dart';
import '../../../../core/components/custom_dialog.dart';
import '../../../../core/components/custom_stepper_approve.dart';
import '../../../../core/constant/time_format_schedule.dart';
import '../../../../core/constant/variables.dart';
import '../../../../data/model/agreement_overtime_response_model.dart';
import '../../../../shared/button/button_1.dart';
import '../../../../shared/images/images.dart';
import '../../../../shared/loading/loading1.dart';
import '../../../../shared/textfield/textfield_1.dart';
import '../../cuti/pengajuan/views/detail_pengajuan_cuti_view.dart';

class DetailPengajuanLemburUser extends StatefulWidget {
  const DetailPengajuanLemburUser({super.key});

  @override
  State<DetailPengajuanLemburUser> createState() =>
      _DetailPengajuanLemburUserState();
}

class _DetailPengajuanLemburUserState extends State<DetailPengajuanLemburUser> {
  final m = Get.find<ModelController>();
  final extendTime = TextEditingController();

  late DetailOvertime data;
  List statusApproval = [];
  bool isRejected = false;

  int indexStatus = 0;

  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    statusApproval =
        (data.statusLine == null &&
            data.status == 'Approved' &&
            data.statusSuperadmin == 'Approved')
        ? [
            'Lembur ${_checkStatusApprovalUser(data.status ?? 'Pending')}',
            '${_checkStatusApproval(data.statusSuperadmin ?? "Pending")}${data.superadmin?.nama ?? 'Super Admin'}',
          ]
        : [
            'Lembur ${_checkStatusApprovalUser(data.status ?? 'Pending')}',
            '${_checkStatusApproval(data.statusLine ?? "Rejected")}${data.line != null ? data.line!.nama : 'user'}',
            '${_checkStatusApproval(data.statusSuperadmin ?? "Pending")}${data.superadmin?.nama ?? 'Super Admin'}',
          ];
    _settingIndexApprove(
      data.status ?? 'Pending',
      data.statusLine ?? 'Rejected',
      data.statusSuperadmin ?? 'Pending',
    );
    _checkRejected(
      data.statusLine ?? 'Rejected',
      data.statusSuperadmin ?? 'Pending',
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

  String _checkStatusApproval(String approval) {
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

    return 'Pengajuan selesai ';
  }

  _setColorStatus(String status) {
    switch (status) {
      case 'Canceled':
        return Colors.red;
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
        title: const Text('Detail Lembur'),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            BiodataUser(),
            StepperSubmission(),
            _reasonOvertime(data: data),
            if (data.type == 'Day off') _customDayOff(),
            if (data.type == "Working day") ...[
              if (data.durationBeforeShift != '00:00:00')
                _customWorkingDayBefore(),
              if (data.durationAfterShift != '00:00:00')
                _customWorkingDayAfter(),
            ],
            if ((data.statusLine == null || data.statusLine == "Pending") &&
                data.status == "Pending") ...[
              const Gap(20),
              Button1(
                backgroundColor: Colors.red,
                title: 'Batalkan lembur',
                onTap: () async {
                  Get.dialog(
                    CustomDialog(
                      title: 'Batalkan',
                      content: 'Apakah anda yakin akan membatalkan lembur?',
                      onConfirm: () async {
                        Variables().loading(message: 'Membatalkan...');

                        await cancelOvertime(data.id!);

                        Get.back();
                        Get.back();
                        Get.back();
                      },
                      onCancel: () {
                        Get.back();
                      },
                    ),
                  );
                },
              ),
            ],
            const Gap(10),
          ],
        ),
      ),
    );
  }

  Future cancelOvertime(String idOvertime) async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/user/cancel/lembur/$idOvertime'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // debugPrint(await response.stream.bytesToString());
    } else {
      debugPrint('${response.reasonPhrase}');
    }
  }

  Container _customWorkingDayAfter() {
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
              'Detail Pengajuan Sesudah Shift',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          // informasi pegawai cuti
          CustomDetailPengajuan(
            title: 'Tanggal Absensi',
            subTitle: DateFormat('dd MMM yyyy').format(data.dateRequestFor!),
          ),
          CustomDetailPengajuan(
            title: 'Durasi Lembur',
            subTitle: '${data.durationAfterShift}',
          ),
          if (data.datumExtends != null &&
              data.datumExtends!.durationAfterShift != null)
            CustomDetailPengajuan(
              title: 'Durasi Lembur Tambahan',
              subTitle: '${data.datumExtends!.durationAfterShift}',
            ),
          CustomDetailPengajuan(
            title: 'Durasi Istirahat',
            subTitle: data.breakAfterShift.toString(),
          ),
          const Gap(25),
          // if (data.datumExtends == null ||
          //     data.datumExtends!.durationAfterShift == null)
          if (data.status != 'Rejected')
            Button1(
              backgroundColor: Colors.orange.shade300,
              title: 'Tambah Lembur Sesudah Shift',
              onTap: () => customDialogAlert(
                overtime_request_id: data.id.toString(),
                type: data.type.toString(),
                type_duration: 'after_shift',
              ),
            ),
        ],
      ),
    );
  }

  Container _customWorkingDayBefore() {
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
              'Detail Pengajuan Sebelum Shift',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          // informasi pegawai cuti
          CustomDetailPengajuan(
            title: 'Tanggal Absensi',
            subTitle: DateFormat('dd MMM yyyy').format(data.dateRequestFor!),
          ),
          CustomDetailPengajuan(
            title: 'Durasi Lembur',
            subTitle: '${data.durationBeforeShift}',
          ),
          if (data.datumExtends != null &&
              data.datumExtends!.durationBeforeShift != null)
            CustomDetailPengajuan(
              title: 'Durasi Lembur Tambahan',
              subTitle: '${data.datumExtends!.durationBeforeShift}',
            ),
          CustomDetailPengajuan(
            title: 'Durasi Istirahat',
            subTitle: data.breakBeforeShift.toString(),
          ),
          const Gap(25),

          if (data.status != 'Rejected')
            Button1(
              backgroundColor: Colors.orange.shade300,
              title: 'Tambah Lembur Sebelum Shift',
              onTap: () => customDialogAlert(
                overtime_request_id: data.id.toString(),
                type: data.type.toString(),
                type_duration: 'before_shift',
              ),
            ),
        ],
      ),
    );
  }

  Container _customDayOff() {
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
              'Detail Pengajuan Hari Libur',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          // informasi pegawai cuti
          CustomDetailPengajuan(
            title: 'Tanggal Absensi',
            subTitle: DateFormat('dd MMM yyyy').format(data.dateRequestFor!),
          ),
          CustomDetailPengajuan(
            title: 'Waktu Masuk Lembur',
            subTitle: TimeFormatSchedule().timeOfDayFormat(
              data.timeInDayoff.toString(),
            ),
          ),
          CustomDetailPengajuan(
            title: 'Waktu Keluar Lembur',
            subTitle: TimeFormatSchedule().timeOfDayFormat(
              data.timeOutDayoff.toString(),
            ),
          ),
          CustomDetailPengajuan(
            title: 'Durasi Lembur',
            subTitle: data.durationOvertimeDayoff.toString(),
          ),
          CustomDetailPengajuan(
            title: 'Durasi Istirahat',
            subTitle: data.breakOvertimeDayoff.toString(),
          ),
          if (data.datumExtends != null)
            if (data.datumExtends!.durationOvertimeDayoff != null)
              CustomDetailPengajuan(
                title: 'Durasi Lembur Tambahan',
                subTitle: '${data.datumExtends!.durationOvertimeDayoff}',
              ),
          // if (data.datumExtends == null) ...[
          const Gap(15),
          Button1(
            title: 'Tambahan Lembur',
            onTap: () {
              customDialogAlert(
                overtime_request_id: data.id.toString(),
                type: data.type.toString(),
                type_duration: 'holiday',
              );
            },
          ),
        ],
        // ],
      ),
    );
  }

  Future<dynamic> customDialogAlert({
    required String overtime_request_id,
    required String type,
    required String type_duration,
  }) {
    return Get.dialog(
      AlertDialog(
        title: Text(
          'Informasi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(15),
            Text(
              'Jika anda melakukan perubahan data, mohon konfirmasi terlebih dahulu.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const Gap(15),
            TextField1(
              hintText: 'Tambahan waktu lembur',
              controller: extendTime,
              readOnly: true,
              onTap: () async {
                await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: 0, minute: 0),
                  initialEntryMode: TimePickerEntryMode.input,
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      extendTime.text = timeFormatInput(value.format(context));
                    });
                  }
                });
              },
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        actionsPadding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Batal', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              Get.dialog(Loading1());
              await extendsTime(
                overtime_request_id: overtime_request_id,
                type: type,
                duration: extendTime.text,
                type_duration: type_duration,
              );
              Get.back();
              Get.back();
              Get.back();
            },
            child: Text('Konfirmasi', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  Future<void> extendsTime({
    required String overtime_request_id,
    required String type,
    required String duration,
    required String type_duration,
  }) async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Variables.baseUrl}/v1/user/extend/lembur'),
      );

      // Tambahkan field umum
      request.fields.addAll({
        'overtime_request_id': overtime_request_id,
        'type': type,
      });

      // Tentukan field durasi berdasarkan type_duration
      switch (type_duration) {
        case 'before_shift':
          request.fields['duration_before_shift'] = duration;
          break;
        case 'after_shift':
          request.fields['duration_after_shift'] = duration;
          break;
        default: // Asumsikan 'overtime_dayoff'
          request.fields['duration_overtime_dayoff'] = duration;
      }

      // Tambahkan headers
      request.headers.addAll(headers);

      debugPrint('${request.fields}');

      // Kirim request dan dapatkan response
      http.StreamedResponse streamedResponse = await request.send();

      // Ubah streamedResponse menjadi response biasa
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Berhasil, log response body
        // debugPrint('Success: ${response.body}');
      } else {
        // Gagal, log alasan
        debugPrint('Error: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      // Tangani error lainnya
      debugPrint('Exception caught: $e');
    }
  }

  String timeFormatInput(String timeString) {
    // Pisahkan string berdasarkan titik untuk mendapatkan jam dan menit
    List<String> parts = timeString.split('.');
    int hours = int.parse(parts[0]); // Ambil bagian jam
    int minutes = int.parse(parts[1]); // Ambil bagian menit

    // Buat objek DateTime menggunakan jam dan menit
    DateTime dateTime = DateTime(0, 0, 0, hours, minutes);

    // Format ke bentuk "HH:mm:ss"
    String formattedTime = DateFormat('HH:mm:ss').format(dateTime);

    return formattedTime;
  }

  Container StepperSubmission() {
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
              style: TextStyle(
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
                  'Tanggal Mengajukan',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(': '),
              Expanded(
                child: Text(
                  DateFormat(
                    'dd MMMM yyyy',
                    'id_ID',
                  ).format(data.createdAt ?? DateTime.now()),
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          // custom stepper
          const Gap(30),
          if (data.status == 'Approved' &&
              data.statusSuperadmin == 'Approved' &&
              data.statusLine == null) ...[
            CustomStepperApprove(
              listStepper: statusApproval,
              activeIndex: 3,
              isRejected: false,
              listDate: [
                data.createdAt,
                data.createdAt,
                data.dateApprovalSuperadmin,
              ],
            ),
          ] else ...[
            CustomStepperApprove(
              listStepper: statusApproval,
              activeIndex: indexStatus,
              isRejected: isRejected,
              listDate: [
                data.createdAt,
                data.dateApprovalLine,
                data.dateApprovalSuperadmin,
              ],
            ),
          ],
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
                    Text(
                      '${m.u.value.jabatan}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 12,
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

class _reasonOvertime extends StatelessWidget {
  const _reasonOvertime({required this.data});

  final DetailOvertime data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              'Alasan Pengajuan Lembur',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          // informasi pegawai cuti
          Text(
            data.notes ?? 'Pengajuan lembur dikirimkan dari Super Admin',
            textAlign: TextAlign.left,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
